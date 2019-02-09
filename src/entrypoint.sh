#!/bin/sh

set -e
trap "echo signal" HUP INT QUIT KILL TERM


if [ "$1" = "dokuwiki" ]
then
	exec php5 -S 0.0.0.0:8080 -t ${DW_DIR}
fi

exec "$@"
