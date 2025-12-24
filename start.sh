#!/bin/ash
#trap 'kill -TERM $PID' TERM INT

env

echo "*** tailscale version"
tailscale --version

echo "*** Starting socat - ${PROXY_TARGET}:${PROXY_PORT}"
socat -d -d tcp-listen:${PROXY_PORT},fork,reuseaddr tcp:${PROXY_TARGET}:${PROXY_PORT} &

echo "*** Starting Tailscale"
exec /usr/local/bin/containerboot