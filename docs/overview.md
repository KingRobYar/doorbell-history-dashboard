🚫 Now that Amazon’s Ring has partnered with Axon — yes, the Taser people — they’ve reintroduced the ability for police to “request” video from your doorbell camera. Hard pass.

🏡 Setting up your own Home Assistant doorbell camera can be a bit of an adventure, and even when you get it working, the built‑in interface still feels a little… let’s call it “minimalist.” Compared to polished systems like Ring or Nest, Home Assistant doesn’t give you an easy way to scroll back through the interesting stuff your doorbell has captured.

🎥 There are quite a few tutorials available for how to integrate the Blue Iris software with Home Assistant and configure AI to validate triggered events to turn them into alerts and use MQTT to send a message to Home Assistant. The Blue Iris integration in HACS does a pretty good job of exposing camera feeds and groups to Home Assistant. However, from what I can tell, none of that utilizes the UI3 interface, and that's a shame because I have yet to find any way to stream video from IP Cameras as nicely as the UI3 interface in Blue Iris does it. One of the nice things about the way I built this dashboard is that it exposes the entire UI3 interface. If you click on the button that looks like two arrows pointing at each other, you'll expose the rest of the UI3 interface, where you'll see a list of all of the alerts. Honestly, just dropping the UI3 interface into an iframe by itself is probably what a lot of people do.

🔧 I haven't had a Ring doorbell for quite a few years, but one of the features that both Ring and Nest had right out of the box was one that doesn't seem very easy to reproduce in Home Assistant, so I set out to replicate the best parts of those commercial systems — especially the ability to quickly review recent activity — without giving up privacy, control, or local storage.

🧩 Building a reliable “doorbell history” in Home Assistant sounds simple on the surface — until you try to do it without duplicating video storage, without relying on snapshots, and without breaking every time Home Assistant restarts. I wanted a clean, fast, tablet‑friendly dashboard that showed:
- A live feed from my doorbell camera
- A row of recent motion/doorbell alerts with thumbnails
- Tap‑to‑open video playback for each alert
- A secondary driveway camera feed
- Zero external dependencies
- Instant updates when the AI confirms an alert.

✅ Most importantly, I wanted the entire solution to run natively inside Home Assistant, without custom containers, without installing Python on every reboot, and without storing extra media files.

📘 This guide walks through the full journey — from pulling alert data out of Blue Iris, to parsing JSON, to building a custom dashboard using button-card, card-mod, and browser_mod. Along the way, I’ll cover the real‑world problems I hit (DNS issues, container persistence, card limitations, popup behavior across devices) and the engineering decisions that led to the final, stable design. The end result is a polished, responsive dashboard that feels like a commercial doorbell interface — but fully customizable, fully local, and powered entirely by Blue Iris and Home Assistant.
If you want to build the same thing, this guide includes:
- The Bash script that fetches and formats Blue Iris alerts
- The Home Assistant command_line sensor configuration
- The card layout and styling
- The popup logic for video playback
- Screenshots of the final dashboard
- Lessons learned and tips for adapting it to your setup
