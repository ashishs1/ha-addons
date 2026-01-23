#!/usr/bin/with-contenv bashio
set -e

CONFIG_PATH="/data/meshcentral-data"
APP_PATH="/opt/meshcentral"
CONFIG_FILE="$CONFIG_PATH/config.json"

for f in data backups files; do mkdir -p /data/meshcentral-${f}; done

# Read HA config
ACCESS_DOMAIN="$(bashio::config 'access_domain')"
N_BACKUPS="$(bashio::config 'no_of_days_backup')"
F_BACKUPS="$(bashio::config 'backup_interval_hours')"
BACKUP_FILES="$(bashio::config 'backup_files')"
WELTXT="$(bashio::config 'welcome_text')"

# Create default config if missing
if [ ! -f "$CONFIG_FILE" ]; then
  bashio::log.info "Creating initial MeshCentral config"

  cat > "$CONFIG_FILE" <<EOF
{
  "settings": {
    "cert": "${ACCESS_DOMAIN}",
    "port": 443,
    "aliasPort": 443,
    "autoBackup": {
      "_backupPath": "/data/meshcentral-backups"
    }
  },
  "domains": {
    "": {
      "CertUrl": "https://${ACCESS_DOMAIN}:443/"
    }
  }
}
EOF
else
  bashio::log.info "Updating MeshCentral config"

  # Remove _port / _aliasPort if present
  # jq 'del(._port, ._aliasPort)' "$CONFIG_FILE" > /tmp/config.json || true

  # Update cert location each time
  jq --arg certUrl "https://${ACCESS_DOMAIN}:443/" '.domains[""].CertUrl=$certUrl' "$CONFIG_FILE" > /tmp/config.json 
  jq --arg cert "$ACCESS_DOMAIN" '.settings.cert=$cert' /tmp/config.json > "$CONFIG_FILE"
fi

if [ -n "$N_BACKUPS" ]; then
  jq --arg nback "$N_BACKUPS" '.settings.autoBackup.keepLastDaysBackup=$nback' "$CONFIG_FILE" > /tmp/config.json
  mv /tmp/config.json $CONFIG_FILE
fi
if [ -n "$F_BACKUPS" ]; then
  jq --arg nback "$F_BACKUPS" '.settings.autoBackup.backupIntervalHours=$nback' "$CONFIG_FILE" > /tmp/config.json
  mv /tmp/config.json $CONFIG_FILE
fi
if [ "$BACKUP_FILES" ]; then
  jq '.settings.autoBackup.backupOtherFolders=true' "$CONFIG_FILE" > /tmp/config.json
  mv /tmp/config.json $CONFIG_FILE
fi
if [ -n "$WELTXT" ]; then
  jq --arg welt "$WELTXT" '.domains[""].welcomeText=$welt' "$CONFIG_FILE" > /tmp/config.json
  mv /tmp/config.json $CONFIG_FILE
fi

# Start MeshCentral
# Can run the following without --datapath flag also.
bashio::log.info "Starting Meshcentral..."
exec node $APP_PATH/node_modules/meshcentral --datapath "$CONFIG_PATH" | while IFS= read -r line; do echo "$(date '+%Y-%m-%d %H:%M:%S') $line"; done

