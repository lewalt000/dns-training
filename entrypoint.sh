#!/bin/sh
# Simple entrypoint script to start named when container starts

# Run in foreground and log to console
exec /usr/sbin/named -c /etc/named.conf -g -u named
