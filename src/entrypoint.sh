#!/bin/sh

set -e
trap "echo SIGNAL" HUP INT QUIT KILL TERM

# Limits PHP upload
if [ -n "${PHP_LIMITS_UPLOAD}" ]
then
        echo "PHP_LIMITS_UPLOAD ${PHP_LIMITS_UPLOAD}" > /dev/stdout
        sed -i "/upload_max_filesize/s/2M/${PHP_LIMITS_UPLOAD}/g" /etc/php7/php.ini
fi

if [ "${1:0:1}" = "-" ] ; then
	exec /usr/sbin/httpd "$@"
fi

if [ "$1" = "/usr/sbin/httpd" ] ; then
	exec "$@"
fi

if [ "$1" = "apache2" ] ; then
	exec /usr/sbin/httpd -D FOREGROUND -f /etc/apache2/httpd.conf
fi

exec "$@"
