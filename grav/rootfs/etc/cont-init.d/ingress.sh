#!/command/with-contenv bashio
# shellcheck shell=bash

# Ingress serve

#ing="$(bashio::addon.ingress_entry)"
#bashio::log.info "Ingress path:"
#bashio::log.info "${ing}"

#bashio::var.json \
#    interface "$(bashio::addon.ip_address)" \
#    port "^$(bashio::addon.ingress_port)" \
#    | tempio \
#        -template /etc/apache2/templates/ingress.gtpl \
#        -out /etc/apache2/conf.d/ingress.conf
