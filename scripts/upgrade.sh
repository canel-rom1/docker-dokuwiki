#!/usr/bin/env bash

VOLUME_DOCKER=${1:-"dokuwiki"}
DOKUWIKI_DOWNLOAD_URL="https://download.dokuwiki.org/src/dokuwiki/dokuwiki-rc.tgz"

docker run --rm \
        -v "${VOLUME_DOCKER}:/vol-dokuwiki" \
        canelrom1/alpine-canel:3.12.0 sh -c "cd /tmp ; \
                wget --no-check-certificate ${DOKUWIKI_DOWNLOAD_URL} ; \
                tar -zxf dokuwiki*.tgz ; rm -f dokuwiki*.tgz ;ls; cp -af /tmp/dokuwiki*/* /vol-dokuwiki"
