FROM canelrom1/apache2-php7:latest

LABEL maintainer="Rom1 <rom1@canel.ch> - CANEL https://www.canel.ch"
LABEL date="15/07/2019"
LABEL description="CMS Dokuwiki"

ENV VERSION=$VERSION
ENV DOKUWIKI_DOWNLOAD_URL="https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz"
ENV USER="apache"
ENV DW_DIR="/var/www/html"
ENV PORT=80
ENV PHP_LIMITS_UPLOAD="25M"

RUN apk update \
 && apk add --no-cache \
            php7-cli \
            php7-ctype \
            php7-curl \
            php7-gd \
            php7-iconv \
            php7-json \
            php7-ldap \
            php7-mysqli \
            php7-opcache \
            php7-openssl \
            php7-session \
            php7-xml \
            php7-simplexml \
            php7-zlib

#RUN adduser -D -H ${USER}

RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf \
 && sed -i '/AllowOverride/s/None/all/g' /etc/apache2/conf.d/website*

RUN rm -fr ${DW_DIR} && mkdir -p ${DW_DIR} \
 && wget --no-check-certificate "${DOKUWIKI_DOWNLOAD_URL}" -P /tmp \
 && tar -zxf /tmp/dokuwiki* --strip-components=1 -C "${DW_DIR}" \
 && rm -f /tmp/dokuwiki \
 && chown ${USER}:${USER} -R ${DW_DIR}
 

VOLUME	["${DW_DIR}"]

EXPOSE "${PORT}"

HEALTHCHECK CMD curl -f "http://localhost:${PORT}" || exit 1

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2"]
