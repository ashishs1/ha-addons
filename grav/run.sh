#!/usr/bin/with-contenv bashio

for d in user backup logs; do
    if [ ! -d "/data/$d" ]; then
        bashio::log.info "Initializing /data/$d"
        mkdir "/data/$d"
	if [ "$d" = "user" ]; then cp -r "/defaults/$d" "/data/"; fi
    fi
done

bashio::log.info "Setting permissions..."
chown -R apache:apache /data

crond &

exec httpd -DFOREGROUND

