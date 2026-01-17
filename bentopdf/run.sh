#!/usr/bin/with-contenv bashio

# echo "Starting Nginx..."
# nginx &
# sleep 10
echo "Starting bentoPDF server..."
cd /opt/bentopdf/dist
npx http-server -p 3000

