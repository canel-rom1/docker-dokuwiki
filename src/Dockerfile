FROM canelrom1/apache2-php7:0.5.1

LABEL maintainer="Rom1 <rom1@canel.ch> - CANEL https://www.canel.ch"
LABEL date="27/05/2020"
LABEL description="CMS Dokuwiki"

ENV VERSION=$VERSION
ENV DOKUWIKI_VERSION="stable"
ENV DOKUWIKI_DOWNLOAD_URL="https://download.dokuwiki.org/src/dokuwiki/dokuwiki-${DOKUWIKI_VERSION}.tgz"
ENV USER="apache"
ENV DW_DIR="/var/www/html"
ENV PORT=80
ENV PHP_LIMITS_UPLOAD="25M"
ENV APACHE_HTACCESS=1

RUN apk update \
 && apk add --no-cache \
            php7-cli \
            php7-ctype \
            php7-curl \
            php7-gd \
            php7-iconv \
            php7-json \
            php7-ldap \
            php7-mbstring \
            php7-mysqli \
            php7-opcache \
            php7-openssl \
            php7-session \
            php7-xml \
            php7-simplexml \
            php7-zlib

#RUN adduser -D -H ${USER}

RUN rm -fr "${DW_DIR}"  \
 && mkdir "${DW_DIR}" \
 && wget --no-check-certificate "${DOKUWIKI_DOWNLOAD_URL}" -P /tmp \
 && tar -zxf /tmp/dokuwiki* --strip-components=1 -C "${DW_DIR}" \
 && rm -f /tmp/dokuwiki* \
 && chown ${USER}:${USER} -R ${DW_DIR}

COPY ./bin/* /usr/local/bin/
RUN chmod +x -R /usr/local/bin
 
EXPOSE "${PORT}"

HEALTHCHECK CMD curl -f "http://localhost:${PORT}" || exit 1

COPY ./entrypoint-dokuwiki.sh /entrypoints/30-dokuwiki.sh
RUN chmod +x /entrypoints/30-dokuwiki.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2"]
