# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv

## originally from https://github.com/hollie/tailscale-caddy-proxy/blob/main/image/Dockerfile
#ARG TAILSCALE_VERSION=latest
#FROM tailscale/tailscale:$TAILSCALE_VERSION

FROM alpine:latest

LABEL maintainer="andy@a6k.dev"

ENV PROXY_TARGET=caddy
ENV PROXY_PORT=443
ENV TS_AUTHKEY=
ENV TS_HOSTNAME=tsproxy
ENV TS_EXTRA_ARGS=--ssh
ENV TS_TAILSCALED_EXTRA_ARGS=--state=mem:
ENV TS_USERSPACE=true
ENV TS_STATE_DIR=/var/lib/tailscale/
ENV TS_AUTH_ONCE=true

ENV KUBERNETES_SERVICE_HOST=

# Copy Tailscale binaries from the tailscale image on Docker Hub.
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

RUN apk update && apk upgrade --no-cache && apk add --no-cache tini-static socat

# Add the startup script
COPY start.sh /app/start.sh
RUN  chmod +x /app/start.sh

# And run it
ENTRYPOINT ["sh"]
#ENTRYPOINT ["/sbin/tini-static", "--"]

CMD ["/app/start.sh"]
#ENTRYPOINT  [ "/bin/sh" "start.sh" ]