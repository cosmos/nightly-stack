FROM cgr.dev/chainguard/wolfi-base:latest@sha256:c93d380c88ee4ccfc4a1827b6ea54debd9ff6e69e64deb53bb75471297ae713a

ARG BINARY

ENV HOME=/config

WORKDIR /app

USER root

COPY ./$BINARY /app/node

# trunk-ignore(hadolint/DL3018)
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
