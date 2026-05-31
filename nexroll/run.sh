#!/usr/bin/env bash
# NeXroll HA Add-on — startup script
# Reads /data/options.json (written by Supervisor from config.yaml schema),
# maps every option to the environment variables NeXroll already understands,
# then exec's uvicorn so the process receives signals correctly.

set -euo pipefail

# ── Logging helpers ────────────────────────────────────────────────────────────
RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[1;33m'
NC='\033[0m'
log()  { echo -e "${GRN}[NeXroll]${NC} $*"; }
warn() { echo -e "${YLW}[NeXroll WARN]${NC} $*"; }
err()  { echo -e "${RED}[NeXroll ERR]${NC} $*" >&2; }

# ── Read options from HA Supervisor ───────────────────────────────────────────
OPTIONS="/data/options.json"

if [[ ! -f "$OPTIONS" ]]; then
    warn "options.json not found — using built-in defaults."
    PLEX_URL=""
    PLEX_TOKEN=""
    JELLYFIN_URL=""
    JELLYFIN_API_KEY=""
    RADARR_URL=""
    RADARR_API_KEY=""
    SONARR_URL=""
    SONARR_API_KEY=""
    PREROLLS_PATH="/share/nexroll/prerolls"
    LOG_LEVEL="info"
else
    jq_str() { jq -r --arg key "$1" --arg default "$2" '.[$key] // $default' "$OPTIONS"; }

    PLEX_URL=$(jq_str plex_url "")
    PLEX_TOKEN=$(jq_str plex_token "")
    JELLYFIN_URL=$(jq_str jellyfin_url "")
    JELLYFIN_API_KEY=$(jq_str jellyfin_api_key "")
    RADARR_URL=$(jq_str radarr_url "")
    RADARR_API_KEY=$(jq_str radarr_api_key "")
    SONARR_URL=$(jq_str sonarr_url "")
    SONARR_API_KEY=$(jq_str sonarr_api_key "")
    PREROLLS_PATH=$(jq_str prerolls_path "/share/nexroll/prerolls")
    LOG_LEVEL=$(jq_str log_level "info")
fi

# ── Export NeXroll environment variables ──────────────────────────────────────
export PLEX_URL
export PLEX_TOKEN
export JELLYFIN_URL
export JELLYFIN_API_KEY
export RADARR_URL
export RADARR_API_KEY
export SONARR_URL
export SONARR_API_KEY

export NEXROLL_PORT="9393"
export NEXROLL_DB_DIR="/data"
export NEXROLL_PREROLL_PATH="$PREROLLS_PATH"
export NEXROLL_SECRETS_DIR="/data"

# TZ is injected by the Supervisor automatically from HA's configured timezone.

# ── Ensure storage directories exist ──────────────────────────────────────────
log "Ensuring directories exist..."
mkdir -p "$PREROLLS_PATH" /data

# ── Print startup summary (mask secrets) ──────────────────────────────────────
log "──────────────────────────────────────────"
log " NeXroll Home Assistant Add-on"
log "──────────────────────────────────────────"
log " Database dir : /data"
log " Prerolls path: $PREROLLS_PATH"
log " Port         : 9393"
log " Log level    : $LOG_LEVEL"
[[ -n "$PLEX_URL" ]]     && log " Plex URL     : $PLEX_URL"     || log " Plex URL     : (not configured)"
[[ -n "$JELLYFIN_URL" ]] && log " Jellyfin URL : $JELLYFIN_URL" || log " Jellyfin URL : (not configured)"
[[ -n "$RADARR_URL" ]]   && log " Radarr URL   : $RADARR_URL"   || log " Radarr URL   : (not configured)"
[[ -n "$SONARR_URL" ]]   && log " Sonarr URL   : $SONARR_URL"   || log " Sonarr URL   : (not configured)"
log "──────────────────────────────────────────"
log " Open the UI at: http://<ha-ip>:9393"
log "──────────────────────────────────────────"

# ── Start NeXroll ─────────────────────────────────────────────────────────────
cd /app/NeXroll
exec uvicorn backend.main:app \
    --host 0.0.0.0 \
    --port 9393 \
    --log-level "$LOG_LEVEL"
