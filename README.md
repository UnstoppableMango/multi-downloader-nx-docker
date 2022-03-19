# multi-downloader-nx Docker Image

[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/unstoppablemango/multi-downloader-nx?sort=date)](https://hub.docker.com/repository/docker/unstoppablemango/multi-downloader-nx)
[![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/unstoppablemango/multi-downloader-nx?sort=date)](https://hub.docker.com/r/unstoppablemango/multi-downloader-nx)
[![Docker Stars](https://img.shields.io/docker/stars/unstoppablemango/multi-downloader-nx)](https://hub.docker.com/r/unstoppablemango/multi-downloader-nx)

This is a docker image for [anidl/multi-downloader-nx](https://github.com/anidl/multi-downloader-nx)

## Usage

Bash:

```bash
docker run -it --rm \
    --name anidl \
    -v <path-to-your-config>:/config:rw \
    -v <path-to-your-downloads>:/videos:rw \
    unstoppablemango/multi-downloader-nx \
    <downloader-options>
```

Powershell:

```powershell
docker run -it --rm `
    --name anidl `
    -v <path-to-your-config>:/config:rw `
    -v <path-to-your-downloads>:/videos:rw `
    unstoppablemango/multi-downloader-nx `
    <downloader-options>
```

### Permissions

Currently downloads will be created as root. In the future I plan to allow setting UID and GID. For now to fix permissions, you can run

`$ sudo chown <uid>:<gid> /path/to/downloads/*`

`<uid>` and `<gid>` can be obtained from `id`.

### Examples

#### Authenticating

```bash
docker run -it --rm \
    -v ~/.config/anidl:/config:rw \
    unstoppablemango/multi-downloader-nx \
    --service crunchy \
    --auth
```

#### Searching

```bash
docker run -it --rm \
    -v ~/.config/anidl:/config:rw \
    unstoppablemango/multi-downloader-nx \
    --service crunchy \
    --search "Tower of God"
```

#### Downloading

```bash
docker run -it --rm \
    -v ~/.config/anidl:/config:rw \
    -v ~/Videos/anidl:/videos:rw \
    unstoppablemango/multi-downloader-nx \
    --service crunchy \
    --series G6J0G49DR
    --all
```

## Compose

Here is a barebones docker-compose file to get started.

This image comes with a default configuration, so the `/config` mount is technically optional.
Using the default config won't persist authentication info so it is recommended to provide your own.
See [Configuration](#configuration).

## Configuration

Currently all configuration is provided via commandline.
Refer to the [source documentation](https://github.com/anidl/multi-downloader-nx/blob/2.0.18/docs/DOCUMENTATION.md) for all options.

To persist configuration such as authentication, mount a volume to `/config`.

Downloads will be put in `/videos`.

```yaml
version: '3'

services:
  anidl:
    image: unstoppablemango/multi-downloader-nx
    volumes:
    - "<path-to-your-config>:/config:rw"
    - "<path-to-your-downloads>:/videos:rw"
    command: <downloader-options>
```

## Build

```bash
docker build . -t anidl
```

Optionally specify a different version.
The build works by cloning a tag from the source repository.
So the version must be a valid tag in <https://github.com/anidl/multi-downloader-nx>.

```bash
#!/bin/bash
VERSION=$(cut -d'-' -f 1 VERSION)
docker build . --build-arg VERSION=$VERSION -t anidl:$VERSION
```

Note: The version in [VERSION](VERSION) includes a suffix to track the image version so we strip that off before passing it to the build.

With BuildKit:

```bash
docker buildx build . -t anidl
```

```bash
#!/bin/bash
VERSION=$(cut -d'-' -f 1 VERSION)
docker buildx build . --build-arg VERSION=$VERSION -t anidl:$VERSION
```

## Official Image

Since creating this, the source project has added it's own image.

[Docker Hub](https://hub.docker.com/r/izuco/multi-downloader-nx/)

[Dockerfile](https://github.com/anidl/multi-downloader-nx/blob/master/Dockerfile)

As far as I can tell, both images serve the same end. I'll attempt to keep this updated anyways.

<sup>Mines smaller :smirk:</sup>
