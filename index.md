## Doorbell History Dashboard
A reproducible Home Assistant dashboard powered by Blue Iris UI3
Welcome to the documentation site for the Doorbell History Dashboard, a project designed to bring a modern, intuitive, and fully documented doorbell event interface to Home Assistant. This guide walks through the architecture, integrations, scripts, and UI components that make the dashboard work — all with a focus on clarity, reproducibility, and real‑world practicality.
This project grew out of a simple need: a better way to view and interact with doorbell events. Most smart‑home systems offer limited history views or clunky interfaces. By combining Blue Iris UI3, Home Assistant, and a few lightweight automations, this dashboard delivers a clean, familiar experience that feels on par with modern commercial smart‑home apps.  Not to mention, Amazon’s Ring has partnered with Axon — yes, the Taser people — they’ve reintroduced the ability for police to “request” video from your doorbell camera. Hard pass.

Setting up your own Home Assistant doorbell camera can be a bit of an adventure, and even when you get it working, the built‑in interface still feels a little… let’s call it “minimalist.” Compared to polished systems like Ring or Nest, Home Assistant doesn’t give you an easy way to scroll back through the interesting stuff your doorbell has captured.

There are quite a few tutorials available for how to integrate the Blue Iris software with Home Assistant and configure AI to validate triggered events to turn them into alerts and use MQTT to send a message to Home Assistant. The Blue Iris integration in HACS does a pretty good job of exposing camera feeds and groups to Home Assistant. However, from what I can tell, none of that utilizes the UI3 interface, and that's a shame because I have yet to find any way to stream video from IP Cameras as nicely as the UI3 interface in Blue Iris does it.

## UI3 Interface
The UI3 interface already does everything that this dashboard is doing inside of itself. The reason I created this dashboard is because while it has all of the functionality I might want, it has TOO much, and because of that, it's very cramped and hard to use on a smaller device like a tablet or a phone. Most of the discussions I've read in home assistant forums focus on saving images and exporting videos rather than just referencing them directly from the Blue Iris server. Below is an example of what the UI3 interface looks like...

![Sample UI3 Interface](/images/UI3_Interface.PNG)
*Blue Iris UI3 showing filtered alerts and live camera view.*

You can see a list of the confirmed alerts (due to the filter) on the left, and selecting any of those would bring up the video player and show that video. Otherwise, the selected camera group shows up as a live view. If you're only ever going to use Home Assistant on a PC, or all of your displays are very large, then you might just paste the address to your Blue Iris server into an iframe and call it a day. Another thing to 

I haven't had a Ring doorbell for quite a few years, but one of the features that both Ring and Nest had right out of the box was one that doesn't seem very easy to reproduce in Home Assistant, so I set out to replicate the best parts of those commercial systems — especially the ability to quickly review recent activity — without giving up privacy, control, or local storage.


If you're still reading, then you're interested in something that feels a little more native to Home Assistant, but still gives the same functionality. This is what the doorbell view page looks like in a browser window shrunk down to around the size of a tablet.  
![Doorbell View Example](/images/DoorbellView.PNG)

Here is an example of what it looks like when a video is selected.
![Doorbell Video Example](/images/PopupDoorbellVideo.PNG)



## What You’ll Find Here
This site provides a full overview of the project, including:
- Project Architecture
How Blue Iris, Home Assistant, DNS automation, and templated sensors work together.
- Blue Iris Integration
How UI3 is used to capture snapshots, event metadata, and motion triggers.
- Home Assistant Sensors
The YAML, templates, and logic that store and expose doorbell events.
- Dashboard Layout
A clean, modern Lovelace interface designed for quick browsing and visual clarity.
- Automation & Scripts
The Bash script and Cloudflare DNS workflow that keep everything running smoothly.
- Troubleshooting & Gotchas
Real‑world issues encountered during development and how to solve them.

## Who This Project Is For
This guide is written for:
- Home Assistant users who want a better doorbell history interface
- Blue Iris users looking to integrate UI3 more deeply
- Smart‑home tinkerers who enjoy reproducible, well‑documented setups
- Developers who appreciate clean architecture and transparent design choices
Whether you’re following the project step‑by‑step or adapting pieces for your own setup, everything here is meant to be approachable and easy to extend.

## Start Exploring
Use the navigation links below (or the sidebar, if your theme supports it) to dive into the sections that interest you:
- [Dashboard Prerequisites](/docs/prerequisites.md)
- [Architecture Overview](/docs/architecture.md)
- [Blue Iris Integration](docs/DoorbellAlerts-bash.md)
- [Home Assistant Sensors](docs/DoorbellAlerts-sensor.md)
- [Dashboard Layout](docs/DoorbellAlerts-dashboard.md)
- [Lessons Learned](docs/LessonsLearned.md)

