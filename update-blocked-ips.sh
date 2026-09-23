#!/bin/bash

# Add Cloudflare IP blocks to allow list
curl -sS https://raw.githubusercontent.com/donharris/blocking-bad-ips/main/cloudflare_ips.txt > /etc/nginx/cloudflare-realip.inc

# Add my personal block list
curl -sS https://raw.githubusercontent.com/donharris/blocking-bad-ips/main/full.txt > /etc/nginx/conf.d/blocklist.conf

# Add Spamhaus block list
curl -sS https://www.spamhaus.org/drop/drop.txt > /tmp/spamhaus.txt
echo "# Start Spamhaus List" >> /etc/nginx/conf.d/blocklist.conf
grep -v ^\; /tmp/spamhaus.txt | awk '{ print "deny "$1";"}' >> /etc/nginx/conf.d/blocklist.conf

# Add Spamhaus DROP (Don't Route or Peer list)
curl -sS https://www.spamhaus.org/drop/drop.txt > /tmp/spamhaus_drop.txt
echo "# Start Spamhaus DROP List" >> /etc/nginx/conf.d/blocklist.conf
grep -v ^\; /tmp/spamhaus_drop.txt | awk '{print "deny " $0}' | awk -F\; '{print $1 "; # " $2}'  >> /etc/nginx/conf.d/blocklist.conf

# Add Country Block lists
# Russia
echo "# Start Russia blocklist" >> /etc/nginx/conf.d/blocklist.conf
curl -sS https://raw.githubusercontent.com/ipverse/country-ip-blocks/master/country/ru/ipv4-aggregated.txt > /tmp/ru.txt
grep -v ^\# /tmp/ru.txt | awk '{ print "deny "$1";"}' >> /etc/nginx/conf.d/blocklist.conf

# Singapore
echo "# Start Signapore blocklist" >> /etc/nginx/conf.d/blocklist.conf
curl -sS https://raw.githubusercontent.com/ipverse/country-ip-blocks/master/country/sg/ipv4-aggregated.txt > /tmp/sg.txt
grep -v ^\# /tmp/sg.txt | awk '{ print "deny "$1";"}' >> /etc/nginx/conf.d/blocklist.conf

# Test and reload nginx
nginx -t && nginx -s reload
