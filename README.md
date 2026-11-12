# Death Counter

Twitch chat-controlled death counter for an OBS Browser Source.

**OBS URL:** `https://kideohojima.github.io/death-counter/?channel=YOURCHANNEL`

Optional params: `cmd=deathcount`, `label=Deaths:`, `vip=1`

## Commands (broadcaster & mods only)

| Command | Effect |
|---|---|
| `!deathcount 10` | set to 10 |
| `!deathcount up` / `down` | +1 / -1 |
| `!deathcount +5` / `-3` | add / subtract |
| `!deathcount reset` | 0 |

Reads chat anonymously (read-only). The count is stored per PC in OBS.
