#!/bin/ash
#trap 'kill -TERM $PID' TERM INT

echo "This is Tailscale-Caddy-proxy version"
tailscale --version

# if [ ! -z "$SKIP_CADDYFILE_GENERATION" ] ; then
#    echo "Skipping Caddyfile generation as requested via environment"
# else
#    echo "Building Caddy configfile"

#    echo $TS_HOSTNAME'.'$TS_TAILNET.'ts.net' > /etc/caddy/Caddyfile
#    echo 'reverse_proxy' $CADDY_TARGET >> /etc/caddy/Caddyfile
# fi

echo "Starting socat - ${PROXY_TARGET}:${PROXY_PORT}"
socat -v -d -d tcp-listen:${PROXY_PORT},fork,reuseaddr tcp:${PROXY_TARGET}:${PROXY_PORT} &

echo "Starting Tailscale"
exec /usr/local/bin/containerboot