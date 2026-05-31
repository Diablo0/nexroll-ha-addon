# NeXroll — Home Assistant Add-on

[![NeXroll upstream](https://img.shields.io/github/v/release/JFLXCLOUD/NeXroll?label=upstream&color=yellow)](https://github.com/JFLXCLOUD/NeXroll/releases/latest)

A Home Assistant add-on that wraps **[NeXroll](https://github.com/JFLXCLOUD/NeXroll)** — a preroll manager for Plex and Jellyfin. Schedule short video clips (holiday bumpers, trailers, coming-soon reels) to play automatically before your movies.

---

## Features

- Schedule prerolls by day, week, month, or year with fallback categories
- Sequence builder with random + fixed blocks
- **NeX-Up** — auto-download trailers from Radarr / Sonarr via YouTube
- Holiday browser (100+ countries, 32+ built-in presets)
- Community prerolls (1,300+ clips at prerolls.uk)
- Backup & restore built-in

---

## Installation

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Click the **⋮** menu (top-right) → **Repositories**.
3. Add this repository URL:
   ```
   https://github.com/YOUR_GITHUB_USERNAME/nexroll-ha-addon
   ```
4. Find **NeXroll** in the store and click **Install**.
5. Configure options (Plex/Jellyfin URLs, token, etc.) in the **Configuration** tab.
6. Click **Start**, then open the Web UI at `http://<ha-ip>:9393`.

---

## Configuration

See [DOCS.md](nexroll/DOCS.md) for full option descriptions and setup tips.

| Option | Default | Description |
|---|---|---|
| `plex_url` | `` | Plex server URL |
| `plex_token` | `` | Plex auth token |
| `jellyfin_url` | `` | Jellyfin server URL |
| `jellyfin_api_key` | `` | Jellyfin API key |
| `radarr_url` | `` | Radarr URL (NeX-Up) |
| `radarr_api_key` | `` | Radarr API key |
| `sonarr_url` | `` | Sonarr URL (NeX-Up) |
| `sonarr_api_key` | `` | Sonarr API key |
| `prerolls_path` | `/share/nexroll/prerolls` | Where to store preroll files |
| `log_level` | `info` | Logging verbosity |

---

## Architecture

This add-on extends the official upstream Docker image (`jbrns/nexroll:latest`) and adds:

- A startup script (`run.sh`) that reads HA's `options.json` and maps settings to NeXroll's environment variables
- `jq` for JSON parsing

No NeXroll code is modified.

---

## Updating

When a new NeXroll version is released:

1. Update `version` in `nexroll/config.yaml` to match the new upstream release.
2. Commit and push.
3. In HA → Add-on Store → NeXroll → **Update**.

---

## Credits

NeXroll is created by [JFLXCLOUD](https://github.com/JFLXCLOUD) and the community.  
This add-on wrapper is unofficial and not affiliated with the NeXroll project.
