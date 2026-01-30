🧱 Architecture at a Glance
This project ties together Blue Iris, Home Assistant, and a lightweight Bash script to create a fast, reliable, and fully local doorbell history dashboard. Here’s a high‑level look at how the pieces fit together.

🏠 Core Components
1. Blue Iris (NVR)
Blue Iris handles:
- Camera streams
- Motion/doorbell alerts
- AI‑confirmed triggers
- Thumbnail snapshots
- Video clip storage
- The UI3 web interface
It also exposes a JSON endpoint that returns recent alerts — this is the backbone of the entire dashboard.

2. Home Assistant
Home Assistant provides:
- The dashboard UI
- The command_line sensor that runs the script
- The tablet‑friendly Lovelace interface
- The button-card and card-mod customizations
- The browser_mod popup system
This is where the data becomes a usable interface.

3. Bash Script (stored in /config)
A lightweight Bash script:
- Authenticates to Blue Iris
- Fetches the alert JSON
- Extracts the latest thumbnails and video URLs
- Rewrites internal URLs to external ones for UI3 playback
- Outputs a clean JSON object for Home Assistant
Because it runs natively inside Home Assistant’s environment, it survives reboots and requires zero external dependencies.

4. Command Line Sensor
Home Assistant runs the Bash script every 10 seconds and stores:
- The alert count (as the sensor value)
- The full JSON (as attributes)
This gives the dashboard a single, reusable data source.

5. Lovelace Dashboard
The dashboard includes:
- A live doorbell camera feed
- Four recent alert cards with full‑bleed thumbnails
- Tap‑to‑open video playback
- A driveway camera feed
The UI is optimized for Fire tablets mounted around the house.

6. Browser Mod
This add‑on handles:
- Per‑device popups
- Opening UI3 video links in a modal window
- Ensuring that tapping a thumbnail only affects the device you’re using
Using fire-dom-event instead of call-service is the key to making this work correctly.

🔗 How the Data Flows
Here’s the full pipeline in plain English:
- Blue Iris generates alerts and exposes them via a JSON endpoint.
- Home Assistant runs the Bash script on a schedule.
- The script fetches the JSON, extracts the relevant fields, and outputs a clean structure.
- The command_line sensor stores the data in attributes.
- The button-card reads those attributes and displays the thumbnails.
- card-mod injects CSS to make the thumbnails full‑bleed backgrounds.
- When you tap a card, browser_mod opens the UI3 video in a popup on the current device.
- The sensor updates every 10 seconds, so new alerts appear almost instantly.
