# NeXroll Add-on Documentation

NeXroll is a preroll manager for **Plex** and **Jellyfin** that lets you schedule, sequence, and automate the short video clips that play before your movies. Think holiday bumpers, coming-soon trailers, or anything else you want to play before your main feature.

- **Smart scheduling** — daily, weekly, monthly, or yearly recurrence with fallback categories
- **Sequence builder** — ordered sequences with random and fixed blocks
- **NeX-Up** — auto-download trailers from Radarr / Sonarr via YouTube
- **Holiday browser** — 100+ countries, 32+ built-in holiday presets
- **Community prerolls** — 1,300+ clips from [prerolls.uk](https://prerolls.uk)

---

## First-time Setup

1. Fill in the **Configuration** tab (see below), then **Start** the add-on.
2. Open the Web UI via the **Open Web UI** button or navigate to `http://<your-ha-ip>:9393`.
3. In the NeXroll UI → **Settings** → **Media Server**, verify your Plex or Jellyfin connection.
4. Upload prerolls, create categories, and set up your first schedule.

---

## Configuration Options

| Option | Description |
|---|---|
| `plex_url` | Full URL to your Plex server, e.g. `http://192.168.1.10:32400` |
| `plex_token` | Your Plex authentication token |
| `jellyfin_url` | Full URL to your Jellyfin server, e.g. `http://192.168.1.10:8096` |
| `jellyfin_api_key` | Jellyfin API key (Admin → Dashboard → API Keys) |
| `radarr_url` | Radarr URL for NeX-Up trailer downloads |
| `radarr_api_key` | Radarr API key |
| `sonarr_url` | Sonarr URL for NeX-Up trailer downloads |
| `sonarr_api_key` | Sonarr API key |
| `prerolls_path` | Where to store preroll video files. Defaults to `/share/nexroll/prerolls` which maps to `<ha-config>/share/nexroll/prerolls` on your host. Change this to point at a NAS share if you have one. |
| `log_level` | Verbosity: `info` is recommended for normal use; `debug` for troubleshooting. |

All media-server and *arr credentials can also be entered (or changed) at any time inside the NeXroll Web UI — they are stored in the add-on database and take precedence over the above environment-level options on next save.

---

## Prerolls Storage

By default prerolls are saved to `/share/nexroll/prerolls` inside the container, which corresponds to the `share/nexroll/prerolls` folder on your Home Assistant host (the same `/share` that is accessible to all add-ons and Samba).

**To use a NAS share or a different path:**
1. Mount the share via the [SMB/NFS mounts](https://www.home-assistant.io/common-tasks/os/#network-storage) or via the Samba add-on.
2. Change `prerolls_path` to the mounted path, e.g. `/share/media/prerolls`.
3. Restart the add-on.

---

## Accessing the UI from the Sidebar

NeXroll doesn't embed directly into the HA iframe (the React frontend uses absolute asset paths), but you can add a quick-launch tile to your dashboard:

1. Go to **Settings → Dashboards → your dashboard → Edit → Add card**.
2. Choose **Webpage** (or **iFrame**).
3. Set the URL to `http://<your-ha-ip>:9393`.

Alternatively, add a **Sidebar link** via the [custom-sidebar](https://github.com/elchininet/custom-sidebar) integration.

---

## Data Persistence

| Path inside add-on | Contents | Persisted? |
|---|---|---|
| `/data` | SQLite database, thumbnails, secrets | ✅ Yes (add-on data volume) |
| `/data/prerolls` or `prerolls_path` | Preroll video files | ✅ Yes (mapped share volume) |

The database survives add-on restarts and updates. A **Backup & Restore** function is also built into the NeXroll UI.

---

## Getting a Plex Token

Run this on any machine that has `curl` and `jq` installed:

```bash
curl -s -X POST "https://plex.tv/users/sign_in.json" \
  -H "X-Plex-Client-Identifier: nexroll-ha" \
  -d "user[login]=YOUR_EMAIL&user[password]=YOUR_PASSWORD" | \
  jq -r '.user.authToken'
```

Or use the [official instructions](https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/).

---

## Support

- **NeXroll project**: https://github.com/JFLXCLOUD/NeXroll
- **Discord**: https://discord.gg/R9eH7TbxEk
- **Reddit**: https://www.reddit.com/r/NeXroll/
