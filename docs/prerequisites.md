🧰 Prerequisites
Before diving into the build, you’ll need a few things already in place. This project doesn’t require anything exotic, but it does assume you’ve got the basics of your smart‑home ecosystem up and running.
🏠 1. A working Home Assistant instance
Any installation method works:
- Home Assistant OS
- Home Assistant Supervised
- Home Assistant Container
- Home Assistant Core
If you’re brand new to Home Assistant, get that set up first — this guide assumes you already have a running system you can edit and restart without fear. Okay "without fear" might be going a bit far, can't even restart my TV "without fear", let alone my much more complex Home Assistant installation.

🎥 2. Blue Iris installed and configured
You’ll need:
- A functioning Blue Iris server
- At least one camera (your doorbell)
- AI alerts enabled (DeepStack, CodeProject AI, or BI’s built‑in AI)
- UI3 accessible from your network
This guide pulls alert data directly from Blue Iris’s JSON endpoint, so make sure UI3 is reachable and returning data.

🌐 3. Optional: External access to Blue Iris
If you want to view video clips when you’re away from home, you’ll need one of the following:
- A reverse proxy (NGINX Proxy Manager, Traefik, Caddy)
- A secure port‑forward
- A VPN
- Tailscale (super cool, but a bit of a pain to maintain on phones)
If you only plan to use the dashboard inside your house, you can skip this entirely.

📱 4. A tablet or device for the dashboard (optional)
This dashboard shines on:
- Fire tablets
- Android tablets
- iPads
- Wall‑mounted displays
I’ll be publishing a separate guide on turning Amazon Kids tablets into Home Assistant kiosks — this dashboard integrates perfectly with that setup.

🧩 5. Basic familiarity with YAML and Home Assistant dashboards
You don’t need to be a YAML wizard, just comfortable editing:
- configuration.yaml
- Lovelace dashboards
- Custom cards like button-card and card-mod
If you’ve ever broken your dashboard and fixed it again, you’re more than qualified
