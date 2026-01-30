## Overview
This file documents the Bash script responsible for retrieving the latest Blue Iris doorbell alerts and preparing them for Home Assistant. It handles the API calls, JSON parsing, and attribute formatting that make the dashboard’s thumbnails and video URLs possible. This script is the backbone of the entire system, feeding fresh alert data into the sensor and dashboard layers.

🖥️ Bash Script: Fetching and Formatting Blue Iris Alerts
This script is the glue between Blue Iris and Home Assistant. Blue Iris already stores every alert, thumbnail, and video clip — we just need a clean way to extract that information and hand it to Home Assistant in a format it can use.
This script:
- Authenticates to Blue Iris
- Pulls all alerts for the Doorbell camera
- Sorts them newest‑to‑oldest
- Extracts the four most recent
- Builds clean thumbnail and video URLs
- Outputs a tidy JSON object for Home Assistant
It runs entirely inside Home Assistant’s environment, requires no external dependencies, and survives reboots without any fuss.

🐍 Why Not Python?
My initial script to fetch the data was written in python, but my HA instance didn't have a python interpereter installed by default. I was able to get python installed and the script working, but when my HASSIO VM is restarted, it pulls a fresh docker image of Home Assistant, so the installed python3 was goen after a reboot. There are, of course, ways I could have made sure Python was available in my Home Assistant command line instance, but writing the script in bash proved to be a much easier (and faster) way to get the data.

🔍 Why Only Four Alerts?
The Blue Iris call I'm using returns every alert the camera has ever recorded. That’s great for long‑term history, but not ideal for a dashboard card.
For the dashboard, we only want the most recent handful — enough to see what just happened, but not so many that the UI becomes cluttered. The interface has options to be able to filter the list of alerts that are pulled back, so if the total number of alerts begins to slow the script down, filters can be added.
The script currently pulls all alerts and then filters them down. That’s plenty fast for a single camera, but if your doorbell is extremely busy or you have multiple cameras, the list could get large. In that case, Blue Iris supports filters in the JSON request, so you could easily fetch only the last 7 days, or only alerts with AI confirmation, or only alerts from specific cameras.
The magic line:
  sort_by(.date) | reverse | .[:4]


It sorts all alerts by timestamp, flips the order, and slices the first four.
If you want:
- 10 alerts → change .[:4] to .[:10]
- Alerts grouped by hour/day → easy to add
- Alerts filtered by AI confidence → also easy
- Alerts from multiple cameras → trivial to extend
This script is intentionally simple and modular so you can build on it later.

🔎 Inspecting the Blue Iris JSON (and Getting Ideas for Extensions)
Blue Iris returns a lot of useful information for every alert — far more than the script currently uses. The script keeps things simple by extracting only the fields needed for the dashboard, but you can easily extend it to include additional metadata.
The BlueIrisAlertsExample.json file has and example dataset of alerts returned from Blue Iris.
Some fields you might find useful:
- msec — clip duration in milliseconds
Great for auto‑closing the popup after playback.
- memo — AI detection summary
Useful for filtering alerts (e.g., only show “person” alerts).
- zones — number of motion zones triggered
Helpful if you want to group alerts by area.
- filesize — human‑readable clip length and size
Another source for duration or display text.
- clip — the underlying recording file
Could be used to build alternate playback URLs.

If you want to expose any of these fields in your output JSON, just add them to the jq mapping in the script. For example, to include clip duration:
duration: (.msec // 0),

Or to include the AI memo:
ai_summary: (.memo // ""),

Or to include the human‑readable clip length:
clip_length: (.filesize // ""),

Blue Iris gives you a rich dataset — this script is just the starting point. Feel free to customize it to match your dashboard, your cameras, and your imagination.

🔐 Security and Secrets
The script never hard‑codes credentials. Instead, it loads them from environment variables, which you populate using your load_secrets.sh helper.
This keeps your repo clean and makes the script portable — if you ever move to Vault, AWS Secrets Manager, or anything else, you only update the loader script.

🧠 Future Enhancements
This script is a great foundation for:
- Multi‑camera alert feeds
- Grouping alerts by hour/day
- Filtering by AI confidence
- Adding person/vehicle detection metadata
- Building a full “timeline” view
