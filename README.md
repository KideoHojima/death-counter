# Death Counter

Twitch chat-controlled death counter for an OBS Browser Source.

**OBS URL:** `https://kideohojima.github.io/death-counter/?channel=YOURCHANNEL`

Optional params: `cmd=deathcount`, `label=Deaths:`, `vip=1`, `debug=1` (shows every chat line the widget receives — use this to troubleshoot)

## Commands (broadcaster & mods only)

| Command | Effect |
|---|---|
| `!deathcount 10` | set to 10 |
| `!deathcount +` / `-` | +1 / -1 |
| `!deathcount +5` / `-3` | add / subtract |
| `!deathcount reset` | 0 |

Reads chat anonymously (read-only).

**Saving:** the count is saved automatically for each channel, so it carries over between streams and OBS restarts. Different streamers (different `?channel=`) each keep their own count. It's stored in OBS on that PC — a different PC starts from its own count.
