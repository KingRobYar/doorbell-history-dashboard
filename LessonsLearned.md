Lessons Learned
This project taught me a lot about how Blue Iris, UI3, Home Assistant, templating, and reverse proxies behave in the real world. These notes capture the practical discoveries, gotchas, and architectural decisions that shaped the final design. They’re the things I wish I had known before starting — and the things that will help anyone extending or adapting this setup.

🧩 Templating Rules Are Inconsistent Across Cards
Different Lovelace cards support different templating engines:
- button-card → JavaScript expressions
- card-mod → Jinja2
- Core Lovelace cards → neither
This is why the snapshot cards ended up being a hybrid:
- button-card for the tap‑action logic
- card-mod for the background image templating
It took some trial and error to figure out which tool could do what. The lesson: don’t assume templating works everywhere — test it.

🧠 UI3 Rewrites URLs in Unexpected Ways
UI3 sometimes rewrites hostnames to IP addresses, and if you’re behind a reverse proxy, that can break things. I ran into cases where UI3 tried to load resources using the internal IP plus the external port.
Fixing this required:
- Ensuring the reverse proxy forwarded the correct headers
- Preventing Blue Iris from rewriting URLs
- Using internal IPs for script access but external URLs for dashboard playback
Blue Iris is opinionated about networking, and you need to understand those opinions before layering Home Assistant on top. I spent several hours trying to figure out why NGINX Proxy Manager was injecting HSTS headers into my requests only to find that I had the "Send Strict-Transport-Security header" option checked in Blue Iris which configures HSTS to be set for a YEAR. I'm quite happy to have found where that setting was getting enabled, it's been hounding me for quite some time.

🧼 Keeping the Dashboard Stateless Was the Right Call
One of the best architectural decisions was keeping the dashboard stateless. Instead of creating extra helpers or template sensors, everything flows from:
- The script
- The sensor
- The dashboard
The dashboard reads directly from the sensor attributes, which keeps the YAML clean and avoids duplication. If the script changes, the dashboard automatically reflects it.

🔮 Future Improvements
A few enhancements I may explore later:
- Weather integration near the clock
I want a clean, minimal weather display, but I’m still deciding whether to use the built‑in weather entity, a custom card, or a third‑party integration.
- Better error handling in the script
Adding retries, fallback behavior, or logging could make the system more resilient.
- Dynamic number of snapshots



🔐 Blue Iris Authentication Behavior Matters More Than Expected
Blue Iris allows different authentication rules for local vs. remote connections. In my setup, authentication is only required for remote devices. This ended up being a great fit for Home Assistant because:
- The dashboard loads thumbnails and video URLs instantly
- Internal devices never get stuck behind login prompts
But it also means you need to be very deliberate about how you expose Blue Iris externally. If you’re using a reverse proxy, VPN, or Tailscale, make sure you understand which connections Blue Iris considers “local” and which it considers “remote.” That distinction quietly affects everything downstream.

🎥 UI3 Gives Access to All Cameras — Not Just the Doorbell
One important discovery: UI3 is an all‑cameras interface. If someone can load UI3, they can see every camera Blue Iris exposes.
This has a few implications:
- Treat UI3 as a full‑access portal, not a per‑camera view
- Lock it down tightly if you expose it externally
- Don’t embed UI3 directly in Home Assistant unless you’re okay with full camera access

🔗 How Everything Fits Together (Diagram-Friendly Summary)
Here’s a clean, high‑level description you can later turn into a diagram: 
Blue Iris → Bash Script → Home Assistant Sensor → Lovelace Dashboard


Blue Iris
- Generates alerts, thumbnails, and video clips
- Exposes them via its local API
Bash Script
- Runs on a schedule
- Pulls the latest alerts from Blue Iris
- Normalizes the JSON
- Writes the results into Home Assistant
Home Assistant Sensor
- Stores the parsed alert data as attributes
- Makes thumbnails and video URLs available to the UI
- Keeps the dashboard stateless
Lovelace Dashboard
- Displays the live doorbell feed
- Shows the four most recent snapshots
- Uses browser_mod to play video clips
- Includes a secondary driveway camera feed
This flow keeps the system simple, fast, and easy to maintain
