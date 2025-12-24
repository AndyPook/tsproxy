#!/bin/ash
#trap 'kill -TERM $PID' TERM INT

env

echo "*** tailscale version"
/app/tailscale --version
/app/tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
/app/tailscale up --ssh --auth-key=${TS_AUTHKEY} --hostname=${TS_HOSTNAME}

echo "*** Starting socat - ${PROXY_TARGET}:${PROXY_PORT}"
socat -d -d tcp-listen:${PROXY_PORT},fork,reuseaddr tcp:${PROXY_TARGET}:${PROXY_PORT}
#tail -f /dev/null

#echo "*** Starting Tailscale"
#exec /usr/local/bin/containerboot
