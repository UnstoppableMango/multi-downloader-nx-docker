# multi-downloader-nx Docker

This is a docker image for [anidl/multi-downloader-nx](https://github.com/anidl/multi-downloader-nx).

## Usage

To run, execute the following

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

## Configuration

Currently all configuration is provided via commandline.
Refer to the [source documentation](https://github.com/anidl/multi-downloader-nx/blob/2.0.18/docs/DOCUMENTATION.md) for all options.

Some options, such as the authentication token, are persisted via files in `/config`. It is recommended to mount this directory when running.

## Compose

Here is a barebones docker-compose file to get started.

This image comes with a default configuration, so the `/config` mount is technically optional.
Using the default config won't persist authentication info so it is recommended to provide your own.
See [Configuration](#configuration).

```yaml
version: '3'

services:
  anidl:
    image: unstoppablemango/multi-downloader-nx
    volumes:
    - "<path-to-your-config>:/config:rw"
    - "<path-to-your-downloads>:/videos:rw"
```

## Build

To build, execute the following

```bash
docker build $(pwd) -t anidl
```

Optionally specify a different version.
The build works by cloning a tag from the source repository.
So the version must be a valid tag in <https://github.com/anidl/multi-downloader-nx>.

```bash
#!/bin/bash
VERSION=2.0.18
docker build $(pwd) --build-arg VERSION=$VERSION -t anidl:$VERSION
```
