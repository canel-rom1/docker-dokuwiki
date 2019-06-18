FROM alpine:3.8

LABEL maintainer="Rom1 <rom1@canel.ch> - CANEL https://www.canel.ch"
LABEL date="08/02/2019"
LABEL description="CMS Dokuwiki"

ENV VERSION=$VERSION
ENV DOKUWIKI_DOWNLOAD_URL="https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz"
ENV USER="php"
ENV DW_DIR="/srv/html"
ENV PORT=8080

RUN apk update \
 && apk add --no-cache \
            curl \
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
            php7-zlib

RUN adduser -D -H ${USER}

RUN mkdir -p ${DW_DIR} \
 && wget --no-check-certificate "${DOKUWIKI_DOWNLOAD_URL}" -P /tmp \
 && tar -zxf /tmp/dokuwiki* --strip-components=1 -C "${DW_DIR}" \
 && rm -f /tmp/dokuwiki \
 && chown ${USER}:${USER} -R ${DW_DIR}
 

VOLUME	["${DW_DIR}/data", "${DW_DIR}/conf", \
         "${DW_DIR}/lib/plugins", "${DW_DIR}/lib/tpl"]

EXPOSE "${PORT}"

HEALTHCHECK CMD curl -f "http://localhost:${PORT}" || exit 1

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ${USER}

ENTRYPOINT ["/entrypoint.sh"]
CMD ["dokuwiki"]
