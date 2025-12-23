# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv

## originally from https://github.com/hollie/tailscale-caddy-proxy/blob/main/image/Dockerfile
ARG TAILSCALE_VERSION=latest

FROM tailscale/tailscale:$TAILSCALE_VERSION

LABEL maintainer="andy@a6k.dev"

ENV PROXY_TARGET=caddy
ENV PROXY_PORT=443
ENV TS_AUTHKEY=
ENV TS_HOSTNAME=
ENV TS_EXTRA_ARGS=--ssh
ENV TS_TAILSCALED_EXTRA_ARGS=--state=mem:
ENV TS_USERSPACE=true
ENV TS_STATE_DIR=/var/lib/tailscale/
ENV TS_AUTH_ONCE=true

RUN apk update && apk upgrade --no-cache && apk add --no-cache socat

# Add the startup script
COPY start.sh /usr/bin/start.sh
RUN  chmod +x /usr/bin/start.sh


# And run it
CMD  [ "start.sh" ]