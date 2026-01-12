#!/usr/bin/with-contenv bashio

if [ ! -d "/data/grav-admin" ]; then
    bashio::log.info "First time setup. Making grav persistent..."
    cp -a /var/www/grav-admin /data
    bashio::log.debug "Existing permissions:"
    bashio::log.debug "$( echo $(ls -alh /data) )"
    bashio::log.info "Setting permissions..."
    chown apache:apache /data/grav-admin
    chmod g+s /data/grav-admin
fi

# chown -R apache:apache /data

crond &

exec httpd -DFOREGROUND

