FROM node:17-bullseye-slim AS build

ARG VERSION=2.0.18

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        p7zip-full \
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
    && npm run build-linux64 \
    && BUILD=lib/_builds/multi-downloader-nx-${VERSION}-linux64 \
    && mkdir /build \
    && cp $BUILD/aniDL /build \
    && cp -r $BUILD/config /build

FROM debian:bullseye-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg > /usr/share/keyrings/gpg-pub-moritzbunkus.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/debian/ bullseye main" \
       > /etc/apt/sources.list.d/mkvtoolnix.download.list \
    && echo "deb-src [signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/debian/ bullseye main" \
       > /etc/apt/sources.list.d/mkvtoolnix.download.list

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    mkvtoolnix \
    && apt-get remove --purge -y curl \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build build/* ./

VOLUME /config
VOLUME /videos

ENTRYPOINT [ "./aniDL" ]
