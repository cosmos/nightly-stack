FROM cgr.dev/chainguard/wolfi-base:latest@sha256:88924850126144d97a8aa4d4227132b876db2759481e2f3ac7a2568fc6f8c98a

ARG BINARY

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
