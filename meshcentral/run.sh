#!/usr/bin/with-contenv bashio
set -e

CONFIG_PATH="/data/meshcentral-data"
APP_PATH="/opt/meshcentral"
CONFIG_FILE="$CONFIG_PATH/config.json"

mkdir -p "$CONFIG_PATH"

# Read HA config
ACCESS_DOMAIN="$(bashio::config 'access_domain')"

# Create default config if missing
if [ ! -f "$CONFIG_FILE" ]; then
  bashio::log.info "Creating initial MeshCentral config"

  cat > "$CONFIG_FILE" <<EOF
{
  "settings": {
    "cert": "${ACCESS_DOMAIN}",
    "port": 443,
    "aliasPort": 443
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
  jq 'del(._port, ._aliasPort)' "$CONFIG_FILE" > /tmp/config.json || true

  # Update cert if provided
  if [ -n "$ACCESS_DOMAIN" ]; then
    jq --arg cert "$ACCESS_DOMAIN" '.settings.cert=$cert' /tmp/config.json > "$CONFIG_FILE"
    jq --arg certUrl "https://${ACCESS_DOMAIN}:443/" '.domains[""].CertUrl=$certUrl' /tmp/config.json > "$CONFIG_FILE"
  else
    mv /tmp/config.json "$CONFIG_FILE"
  fi
fi

# Start MeshCentral
cd "$APP_PATH"
exec node node_modules/meshcentral --datapath "$CONFIG_PATH" | while IFS= read -r line; do echo "$(date '+%Y-%m-%d %H:%M:%S') $line"; done

