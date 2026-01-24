Building a reliable “doorbell history” in Home Assistant sounds simple on the surface — until you try to do it without duplicating video storage, without relying on snapshots, and without breaking every time Home Assistant restarts. I wanted a clean, fast, tablet‑friendly dashboard that showed:
- A live feed from my doorbell camera
- A row of recent motion/doorbell alerts with thumbnails
- Tap‑to‑open video playback for each alert
- A secondary driveway camera feed
- Zero external dependencies
- Instant updates when someone rings the bell
Most importantly, I wanted the entire solution to run natively inside Home Assistant, without custom containers, without installing Python on every reboot, and without storing extra media files.
This guide walks through the full journey — from pulling alert data out of Blue Iris, to parsing JSON, to building a custom dashboard using button-card, card-mod, and browser_mod. Along the way, I’ll cover the real‑world problems I hit (DNS issues, container persistence, card limitations, popup behavior across devices) and the engineering decisions that led to the final, stable design.
The end result is a polished, responsive dashboard that feels like a commercial doorbell interface — but fully customizable, fully local, and powered entirely by Blue Iris and Home Assistant.
If you want to build the same thing, this guide includes:
- The Bash script that fetches and formats Blue Iris alerts
- The Home Assistant command_line sensor configuration
- The card layout and styling
- The popup logic for video playback
- Screenshots of the final dashboard
- Lessons learned and tips for adapting it to your setup
