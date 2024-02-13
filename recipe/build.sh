#!/usr/bin/env bash
set -eux

# uses about 2gb
export TMPDIR="$( pwd )/tmp"
mkdir -p "${TMPDIR}"


export GOPATH="$( pwd )"
export GOFLAGS="-buildmode=pie -trimpath -mod=vendor -modcacherw -ldflags=-linkmode=external"
# consumed by `scripts/binary` below to avoid wrangling versioned flags
export VERSION="${PKG_VERSION}"
export DATE="$(date -u '+%Y-%m-%d_%I:%M:%S%p')"

module='github.com/traefik/traefik'

cd "src/${module}"

go mod vendor

make binary

mkdir -p "${PREFIX}/bin"

find dist
# these end up in e.g. dist/linux/amd64/traefik or dist/darwin/arm64/traefik
cp $(ls dist/traefik/*/*/traefik) "${PREFIX}/bin/traefik${target_goexe}"

go-licenses save \
    "." \
    --save_path "${SRC_DIR}/library_licenses/"
