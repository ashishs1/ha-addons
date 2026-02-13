#!/bin/sh
set -e

# Start Memos
exec su -s /bin/sh -c "/usr/local/memos/memos --port 5230"
