#!/bin/bash

# Add my personal block list
curl -sS https://raw.githubusercontent.com/donharris/blocking-bad-ips/main/full.txt > /etc/nginx/conf.d/blocklist.conf

# Add Spamhaus block list
curl -sS https://www.spamhaus.org/drop/drop.txt > /tmp/spamhaus.txt
echo "# Start Spamhaus List" >> /etc/nginx/conf.d/blocklist.conf
grep -v ^\; /tmp/spamhaus.txt | awk '{ print "deny "$1";"}' >> /etc/nginx/conf.d/blocklist.conf

# Test and reload nginx
nginx -t && nginx -s reload
