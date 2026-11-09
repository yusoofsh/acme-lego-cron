# syntax=docker/dockerfile:1
FROM golang:1.27.2-alpine@sha256:f92b6ef800e499660581efdabdf25d9d817a9d124eaf900924f0504e7e27e12d AS builder
WORKDIR /src
# Pin the current upstream main commit (the upstream repository's preferred
# development source), while retaining a checksum for reproducible builds.
ADD https://github.com/go-acme/lego/archive/a6d49ddf1edad742bca32d07d36a01d11f37d8a7.tar.gz /tmp/lego-source.tar.gz
RUN echo '5a4059813e857c226e88c9bf8fee7e76f56f827a165e7ed3c17e468ed3d0da98  /tmp/lego-source.tar.gz' | sha256sum -c - \
 && tar -xzf /tmp/lego-source.tar.gz --strip-components=1 -C /src \
 && go mod edit -require=golang.org/x/crypto@v0.58.0 -require=golang.org/x/net@v0.62.0 -require=golang.org/x/text@v0.43.0 -require=google.golang.org/grpc@v1.84.0 -require=software.sslmate.com/src/go-pkcs12@v0.7.4 \
 && go mod download all \
 && CGO_ENABLED=0 GOTOOLCHAIN=local GOMAXPROCS=2 GOMEMLIMIT=2400MiB go build -p 2 -trimpath -ldflags='-s -w -X main.version=dev-a6d49dd' -o /out/lego . \
 && go version -m /out/lego | grep -F go1.27.2

FROM brahmadev/acme-lego-cron:latest@sha256:598f9ecea0c919717b8dfd1c353e68a6d7e0a879195c00f5816c97bade939f63
# Retain the cron schedule, scripts, hooks, environment and existing ACME state.
RUN apk add --no-cache 'c-ares>=1.34.8-r0' 'curl>=8.22.0-r0' 'libcurl>=8.22.0-r0' \
 'jq>=1.8.2-r0' 'libcrypto3>=3.5.8-r0' 'libssl3>=3.5.8-r0'
COPY --from=builder --chmod=0755 /out/lego /lego

ARG LEGO_COMMIT=a6d49ddf1edad742bca32d07d36a01d11f37d8a7
LABEL io.yusoofsh.upstream.revision="${LEGO_COMMIT}" \
 org.opencontainers.image.source="https://github.com/yusoofsh/acme-lego-cron"
