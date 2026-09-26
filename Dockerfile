# syntax=docker/dockerfile:1
FROM golang:1.26.8-alpine@sha256:8ac98ca534ac3f51e1f420a1dd2c15e74c75cfa0f23f3ad27eb5d7236c349a0c AS builder
WORKDIR /src
# Exact source of the installed Lego 5.2.2; retain all DNS provider support.
ADD https://github.com/go-acme/lego/archive/3d5a6695e027d625bd34334d516d77f578d43f11.tar.gz /tmp/lego-source.tar.gz
RUN echo 'a1572810c293790638ff8d6105e004b67cd77aa838ad86573817e089c9fac8a4  /tmp/lego-source.tar.gz' | sha256sum -c - \
 && tar -xzf /tmp/lego-source.tar.gz --strip-components=1 -C /src \
 && go mod edit -require=golang.org/x/crypto@v0.56.0 -require=golang.org/x/net@v0.58.0 -require=golang.org/x/text@v0.41.0 -require=google.golang.org/grpc@v1.83.2 -require=software.sslmate.com/src/go-pkcs12@v0.7.2 \
 && go mod download all \
 && CGO_ENABLED=0 GOTOOLCHAIN=local go build -trimpath -ldflags='-s -w -X main.version=5.2.2' -o /out/lego . \
 && go version -m /out/lego | grep -F go1.26.8

FROM brahmadev/acme-lego-cron@sha256:ac21688d68e204329dd33efad1ab5efea5ae0c1fe3d88645db11609a1b32ed43
# Retain the cron schedule, scripts, hooks, environment and existing ACME state.
RUN apk add --no-cache 'c-ares=1.34.8-r0' 'curl=8.22.0-r0' 'libcurl=8.22.0-r0' \
 'jq=1.8.2-r0' 'libcrypto3=3.5.8-r0' 'libssl3=3.5.8-r0'
COPY --from=builder --chmod=0755 /out/lego /lego
