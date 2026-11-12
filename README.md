# Death Counter

Twitch chat-controlled death counter for an OBS Browser Source, plus a control panel.

- **Widget (put in OBS):** `https://kideohojima.github.io/death-counter/?channel=YOURCHANNEL`
- **Control panel:** `https://kideohojima.github.io/death-counter/control.html`

## Commands (broadcaster & mods only)

| Command | Effect |
|---|---|
| `!deathcount 10` | set to 10 |
| `!deathcount +` / `-` | +1 / -1 |
| `!deathcount +5` / `-3` | add / subtract |
| `!deathcount reset` | 0 |

## Control panel

The panel lets you change the count with buttons, style the widget with a live preview,
and generates the OBS URL for you. Its buttons send the same `!deathcount` commands to your
chat as your account, so every widget copy (every OBS source, every PC) gets them.
The commands are visible in chat.

You can open it in a normal browser tab, or add it to OBS:
**View → Docks → Custom Browser Docks**, then paste the panel URL.

### One-time setup: Twitch Client ID

The panel needs a (free) Twitch app so it can log you in:

1. Go to <https://dev.twitch.tv/console/apps> → **Register Your Application**.
2. **Name:** anything, e.g. `Death Counter Panel`.
3. **OAuth Redirect URLs:** `https://kideohojima.github.io/death-counter/control.html` (must match exactly).
4. **Category:** Broadcaster Suite. **Client Type:** Public. Click **Create**.
5. Click **Manage**, copy the **Client ID**, and paste it into the panel under *Twitch app setup*.
6. Click **Log in with Twitch**. The panel asks for chat read/send permission only.

The login token is kept in that browser only. Use **Log out** to revoke it.

## Widget URL parameters

The panel builds these for you; listed here for reference.

| Param | Example | Meaning |
|---|---|---|
| `channel` | `kideo_h` | Twitch channel to listen to (required) |
| `cmd` | `deathcount` | command word, without `!` |
| `label` | `Deaths:` | text before the number |
| `vip` | `1` | let VIPs use the command |
| `debug` | `1` | show every chat line the widget receives (troubleshooting) |
| `size` | `64` | font size in px |
| `font` | `Impact` | font family |
| `color` / `num` | `ffffff` / `ff4d4d` | label / number colour (hex, no `#`) |
| `stroke` / `outline` | `000000` / `2` | outline colour / width in px |
| `shadow` | `0` | turn off the drop shadow |

## Saving

The widget reads chat anonymously (read-only). The count is saved automatically per channel, so
it carries over between streams and OBS restarts. Different streamers (different `?channel=`)
each keep their own count. Each browser keeps its own copy, so an OBS source that was offline
can drift — use **Push this number to all widgets** in the panel to resync.
