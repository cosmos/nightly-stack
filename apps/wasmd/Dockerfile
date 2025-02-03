FROM docker.io/library/golang:1.23-alpine3.19 AS go-builder

WORKDIR /code

# this comes from standard alpine nightly file
#  https://github.com/rust-lang/docker-rust-nightly/blob/master/alpine3.12/Dockerfile
# with some changes to support our toolchain, etc
RUN set -eux; apk add --no-cache ca-certificates build-base;

RUN apk add git
# NOTE: add these to run with LEDGER_ENABLED=true
# RUN apk add libusb-dev linux-headers

RUN git clone -b upgrade_sdk_0.52 https://github.com/CosmWasm/wasmd .

# See https://github.com/CosmWasm/wasmvm/releases
# trunk-ignore(checkov/CKV_DOCKER_4)
ADD https://github.com/CosmWasm/wasmvm/releases/download/v2.2.1/libwasmvm_muslc.aarch64.a /lib/libwasmvm_muslc.aarch64.a
# trunk-ignore(checkov/CKV_DOCKER_4)
ADD https://github.com/CosmWasm/wasmvm/releases/download/v2.2.1/libwasmvm_muslc.x86_64.a /lib/libwasmvm_muslc.x86_64.a
RUN sha256sum /lib/libwasmvm_muslc.aarch64.a | grep ba6cb5db6b14a265c8556326c045880908db9b1d2ffb5d4aa9f09ac09b24cecc
RUN sha256sum /lib/libwasmvm_muslc.x86_64.a | grep b3bd755efac0ff39c01b59b8110f961c48aa3eb93588071d7a628270cc1f2326

# force it to use static lib (from above) not standard libgo_cosmwasm.so file
RUN LEDGER_ENABLED=false BUILD_TAGS=muslc LINK_STATICALLY=true make build
RUN echo "Ensuring binary is statically linked ..." \
  && (file /code/build/wasmd | grep "statically linked")

# --------------------------------------------------------
FROM docker.io/library/alpine:3.21@sha256:21dc6063fd678b478f57c0e13f47560d0ea4eeba26dfc947b2a4f81f686b9f45

ENV HOME=/config

# trunk-ignore(hadolint/DL3018)
RUN apk add --no-cache \
  bash \
  jq \
  tini

COPY --from=go-builder /code/build/wasmd /app/node
COPY ./entrypoint.sh /entrypoint.sh

WORKDIR /app

# rest server
EXPOSE 1317
# tendermint p2p
EXPOSE 26656
# tendermint rpc
EXPOSE 26657

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
