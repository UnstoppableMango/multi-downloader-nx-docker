FROM node:17-bullseye-slim AS build

ARG VERSION=3.0.0

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
    && rm -rf /var/lib/apt/lists/*

RUN git \
        -c advice.detachedHead=false \
        clone \
        --depth 1 \
        --branch ${VERSION} \
        https://github.com/anidl/multi-downloader-nx.git \
    && cd multi-downloader-nx \
    && npm ci \
    && npx tsc \
    && npx pkg lib/index.js --target node17-linux-x64 --output /build/aniDL \
    && cp -r config /build/default-config

FROM debian:bullseye-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    mkvtoolnix \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build build/ ./

VOLUME /config
VOLUME /videos

ENTRYPOINT [ "./aniDL" ]
