## Overview
This file describes the Lovelace dashboard used to display the doorbell feed, recent snapshots, and supporting camera views. It covers the layout, card types, templating, and browser_mod popups that make the interface feel responsive and intuitive. This dashboard ties the entire workflow together, turning raw alert data into a clean, glanceable visual history.

🧱 Layout Overview
The dashboard uses a panel view with a single vertical stack. This keeps the layout clean and predictable on all screen sizes. Inside the stack:
- A large digital clock at the top
- A live doorbell camera feed
- A horizontal row of four snapshot cards
- A live driveway camera feed
At some point, I plan to add weather information near the clock. I’m still researching which integration or method I want to use for that.

🕒 Time Display (Sensor Card)
The first card is a simple sensor card showing sensor.date_and_time, styled to be large and centered. The custom styling increases font size and weight for readability, which helps on wall tablets or when glancing quickly at the dashboard.

🎥 Live Doorbell Feed (picture-entity)
The next card is a picture-entity bound to my doorbell camera. Nothing fancy here — I used the Blue Iris integration from HACS to expose all of my Blue Iris devices in Home Assistant.
Key behaviors:
- camera_view: live ensures the feed updates continuously
- fit_mode: cover fills the card without letterboxing
- show_state and show_name provide quick context

🖼️ Recent Snapshot Row (horizontal-stack)
This is the heart of the dashboard: a row of four snapshot cards representing the most recent alerts from sensor.doorbell_alerts.
Each card is a custom:button-card with:
- A background image pulled from a jinja2 template using card-mod
    {{state_attr('sensor.doorbell_alerts', 'alerts')[N]['thumbnail_url']}}
- No name, icon, or state — the image is the card
- A tap action that opens a browser_mod popup with the associated video clip
- A 16:9 aspect ratio for consistent layout
- background-size: contain so the entire thumbnail is visible
Why button-card?
It gives you:
- The ability to use JavaScript inside the YAML for the URL (the main reason I chose it)
- Clean, borderless thumbnails
- A reliable tap target for opening video popups
- Zero extra UI chrome
Why card-mod?
button-card does not support templating inside its style block. Without templating, the card would show a tiny thumbnail instead of a full-background image.
card-mod solves this by allowing Jinja2 templating inside the style:
```yaml
card_mod:
  style: |
    ha-card {
      background-image: url("{{ state_attr('sensor.doorbell_alerts', 'alerts')[0]['thumbnail_url'] }}");
      background-size: contain;
      background-position: center;
      background-repeat: no-repeat;
      aspect-ratio: 16/9;
      width: auto;
      height: auto;
      overflow: hidden;
    }
```

This is what makes the snapshot cards look clean and consistent.
A big part of working with Home Assistant is simply knowing where templating or scripting is allowed and what kind (Jinja2 vs. JavaScript) each card supports.

Why browser_mod popups?
I needed a way to dynamically set the video URL using JavaScript or templating. browser_mod handled that perfectly.
Originally, I used it as a service call, but that caused videos to pop up on other devices in the house. Switching to the fire-dom-event action fixed that — now the popup only appears on the device that triggered it.

🚗 Driveway Camera Feed (picture-entity)
The final card is another picture-entity, this time for my driveway camera exposed by Blue Iris.
This is purely a personal preference. When I walk up to the door and my tablet wakes up, it’s nice to see the entire front side of the house at a glance.

🧩 Templating & Defensive Logic
The YAML includes several patterns worth calling out:
1. Attribute-based thumbnail URLs
You pull thumbnails directly from the alerts attribute:
state_attr('sensor.doorbell_alerts', 'alerts')[0]['thumbnail_url']


This keeps the dashboard stateless — no extra helpers or template sensors required.
2. JavaScript templating for video URLs
Inside the popup:
```js
const alerts = states['sensor.doorbell_alerts'].attributes['alerts'];
if (!alerts || !alerts[0] || !alerts[0]['video_url']) {
  return "about:blank";
}
```
This prevents errors when:
- The script hasn’t run yet
- Blue Iris hasn’t generated a clip
- The array is shorter than expected
