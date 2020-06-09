#!/usr/bin/env bash

usage()
{
        echo "Usage: $(basename $0) [CONTAINER] [VERSION]"
        echo "Defaults values:"
        echo -e "\tCONTAINER\t dokuwiki"
        echo -e "\tVERSION\t\t stable"
}

if [ "$1" = "-h" -o "$1" = "--help" ]
then
        usage
        exit 0
fi

CONTAINER_DOCKER="${1:-dokuwiki}"
DOKUWIKI_VERSION="${2:-stable}"

docker exec -it ${CONTAINER_DOCKER} upgrade ${DOKUWIKI_VERSION}


# vim: ft=sh
