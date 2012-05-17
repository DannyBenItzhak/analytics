#!/bin/bash

# This script is intended to be run hourly by a cron job -- it must be
# run frequently because AppEngine only keeps logs around for so long
# (about 20 hours on 15 May 2012, probably for less going forward).

# It just fetches the last hour's appengine (webserver) logs and puts
# them in ~/kalogs.

if [ -n "$1" ]; then
    hour="$1"
else
    hour=$(date --date='-1 hour' '+%Y-%m-%dT%H:00:00Z')
fi 
hour_next=$(date --date="$nour + 1 hour" +'%Y-%m-%dT%H:00:00Z')

if [ -n "$2" ]; then
    log_dir="$2"
else
    log_dir="$HOME/kalogs"
fi
mkdir -p "$log_dir"

ROOT="$(dirname $0)"

export PYTHONPATH="${ROOT}:${PYTHONPATH}"   # for oauth_util directory

exec "$ROOT/fetch_logs.py" -s "$hour" -e "$hour_next" \
    2> "$log_dir/$hour-error.log" \
    | gzip -c > "$log_dir/$hour.log.gz"