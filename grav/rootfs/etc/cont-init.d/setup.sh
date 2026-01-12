#!/usr/bin/with-contenv bashio

if [ ! -d "/data/grav-admin/user" ]; then
    bashio::log.info "First time setup. Making grav persistent..."
    cp -a /var/www/grav-admin /data
    bashio::log.debug "Existing permissions:"
    bashio::log.debug "$( echo $(ls -alh /data) )"
    bashio::log.info "Setting permissions..."
    chown apache:apache /data/grav-admin
    chmod g+s /data/grav-admin
fi

# chown -R apache:apache /data
bashio::log.debug "Fixing up future permission issues..."
echo '/data/grav-admin IN_CREATE /bin/chown -R apache:apache /data/grav-admin/' > /tmp/temp1
incrontab /tmp/temp1

crond &

exec httpd -DFOREGROUND

