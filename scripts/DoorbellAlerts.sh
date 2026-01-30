#!/bin/bash

# load secrets into this shell (silent)
if [ -f /config/load_secrets.sh ]; then
  # shellcheck disable=SC1090
  source /config/load_secrets.sh /config/secrets.yaml >/dev/null 2>&1
fi

# Read configuration from environment (required)
INTERNAL_BASE_URL="${BLUEIRIS_INTERNAL_URL:-}"
EXTERNAL_BASE_URL="${BLUEIRIS_EXTERNAL_URL:-}"
USERNAME="${BLUEIRIS_USERNAME:-}"
PASSWORD="${BLUEIRIS_PASSWORD:-}"

if [ -z "$EXTERNAL_BASE_URL" ] || [ -z "$INTERNAL_BASE_URL" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "Missing Blue Iris configuration. Set BLUEIRIS_INTERNAL_URL, BLUEIRIS_USERNAME, and BLUEIRIS_PASSWORD in environment or .env"
  exit 1
fi

# Authenticate with Blue Iris
SESSION=$(curl -s -X POST -H "Content-Type: application/json" \
  -d '{"cmd": "login"}' "$INTERNAL_BASE_URL" | jq -r '.session')

if [ "$SESSION" == "null" ]; then
  echo "Failed to get session token"
  exit 1
fi

HASH=$(echo -n "$USERNAME:$SESSION:$PASSWORD" | md5sum | awk '{print $1}')

AUTH_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"cmd\": \"login\", \"session\": \"$SESSION\", \"response\": \"$HASH\"}" "$INTERNAL_BASE_URL")

RESULT=$(echo "$AUTH_RESPONSE" | jq -r '.result')

if [ "$RESULT" != "success" ]; then
  echo "Authentication failed: $AUTH_RESPONSE"
  exit 1
fi

# Fetch alerts for the Doorbell camera
ALERTS_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"cmd\": \"alertlist\", \"session\": \"$SESSION\", \"camera\": \"Doorbell\"}" "$INTERNAL_BASE_URL")

ALERTS=$(echo "$ALERTS_RESPONSE" | jq -r '.data')

if [ "$ALERTS" == "null" ]; then
  echo "Failed to fetch alerts: $ALERTS_RESPONSE"
  exit 1
fi

# Extract and format the four most recent alerts
FORMATTED_ALERTS=$(echo "$ALERTS" | jq -r \
  --arg EXTERNAL_BASE_URL "$EXTERNAL_BASE_URL" \
  'sort_by(.date) | reverse | .[:4] | 
  map({
    filename: .file // "No filename available",
    path: .path // "No path available",
    thumbnail_url: (if $EXTERNAL_BASE_URL == "" then null else "\($EXTERNAL_BASE_URL)/thumbs/\(.path)" end),
    video_url: (if $EXTERNAL_BASE_URL == "" then null else "\($EXTERNAL_BASE_URL)/ui3.htm?rec=\(.path | gsub("@"; "") | gsub(".bvr"; ""))&cam=Doorbell&m=1" end),
    alert_time: (.date | todate)
  }) | {alerts: .}')

# Print the JSON to stdout
echo "$FORMATTED_ALERTS" | jq .