FROM cgr.dev/chainguard/wolfi-base:latest@sha256:ef6dd240997674c8a940dd9ab565dd3e8700b8f7a8e7b743ed16b925d81a70ef

ARG BINARY

WORKDIR /app

USER root

COPY ./$BINARY /app/node

RUN apk update && \
  apk add --no-cache \
    bash \
    libstdc++ \
    jq \
    tini \
  && \
  mkdir -p /config && \
  chown -R nonroot:nonroot /app /config && \
  chmod -R u=rwX,go=rX /app /config && \
  chmod +x /app/node

USER nonroot

COPY ./entrypoint.sh /entrypoint.sh

# API Server
EXPOSE 1317

# Pprof Server
EXPOSE 6060

# gRPC Server
EXPOSE 9090

# CometBFT RPC interface
EXPOSE 26657

HEALTHCHECK --interval=1m --timeout=3s CMD /app/node query node status | grep validator_hash || exit 1

VOLUME ["/config"]

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]