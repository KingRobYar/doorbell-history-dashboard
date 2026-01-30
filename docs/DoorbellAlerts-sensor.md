## Overview
This file explains the Home Assistant sensor configuration that exposes the Blue Iris alert data to the rest of the system. The sensor stores the parsed JSON from the Bash script and makes the thumbnail URLs, video URLs, and timestamps available as attributes. It acts as the bridge between the script and the Lovelace dashboard, keeping the UI stateless and fast.

🛰️ Home Assistant Sensor Configuration
Home Assistant needs a way to ingest the JSON produced by the Bash script. The simplest approach is a command_line sensor that runs the script and stores the parsed alert data in its attributes.
Add the following block to your configuration.yaml (or a package file if you prefer):

```yaml
sensor:
  - platform: command_line
    name: Doorbell Alerts
    command: "bash /config/scripts/DoorbellAlerts.sh"
    scan_interval: 10
    value_template: "{{ value_json.alerts | length }}"
    json_attributes:
      - alerts
```

This sensor:
- Runs your Bash script every 10 seconds
- Stores the number of alerts as the sensor’s value
- Stores the full alert list in the alerts attribute
- Makes the data available to Lovelace cards and templates

📏 About Sensor Attribute Size Limits
Home Assistant stores the full alert list from the Bash script in the sensor’s attributes, not the sensor’s main value. This avoids the 255‑character limit on sensor states.
Attributes can hold much more data, but they do have an upper limit:
- Sensor state limit: 255 characters
- Sensor attribute limit: ~16 KB (16,384 bytes)
If the attributes exceed 16 KB, Home Assistant will still show them in the UI, but they won’t be stored in the history database, and you’ll see warnings in the logs.
The alert JSON produced by this script is very small, so you’re unlikely to hit this limit unless you start pulling hundreds of alerts or very large metadata fields. Still, it’s good to keep in mind if you plan to extend the script.

🔢 Why the Sensor State Stores the Alert Count
You might notice that the sensor’s state isn’t one of the alert fields — it’s simply the number of alerts returned by the script. That’s intentional.
Home Assistant limits sensor states to 255 characters, which makes them unsuitable for storing JSON. Instead, the full alert list lives in the sensor’s attributes, which can hold much more data.
But the state still matters.
By storing the count of alerts in the state, you get a lightweight, always‑available value that can be used for:
- Looping through the alert list in JavaScript
- Building dynamic dashboards
- Debugging (“is the script returning anything?”)
It also gives you a predictable index range if you ever want to iterate through the alerts manually:
```js
const entity = states['sensor.doorbell_alerts'];
const alerts = entity.attributes['alerts'];
const count = parseInt(entity.state, 10);

// Safety checks
if (!alerts || count === 0) {
  return "No alerts available";
}

// Loop through all alerts
for (let i = 0; i < count; i++) {
  const alert = alerts[i];

  // Example: do something with each alert
  console.log(`Alert ${i}:`, {
    thumbnail: alert['thumbnail_url'],
    video: alert['video_url'],
    time: alert['alert_time']
  });
}

// Example return value for a button-card or template
return alerts[0]['video_url'];
```
Even if you never use it directly, having the count in the state makes the sensor more flexible and future‑proof — especially if you expand the script to return more alerts or additional metadata.





