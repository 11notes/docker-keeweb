# :: Header
    FROM 11notes/nginx:stable

    # :: SSL Settings
        ENV SSL_RSA_BITS=4096
        ENV SSL_DH_BITS=1024
        ENV SSL_ROOT="/keeweb/ssl"

# :: Run
    USER root
    RUN set -ex; \ 
        mkdir -p \
            /keeweb/ssl \
            /keeweb/www/etc \
            /keeweb/www/db;

    ADD https://github.com/keeweb/keeweb/archive/gh-pages.zip /tmp

    RUN set ex; \
        apk add --no-cache --virtual .build \
            unzip; \
        unzip /tmp/gh-pages.zip -d /tmp; \
        cp -r /tmp/keeweb-gh-pages/* /keeweb/www; \
        apk del .build; \
        rm -rf /tmp/*;

    RUN set -ex; \
        sed -i 's/(no-config)/\/etc\/default.json/g' /keeweb/www/index.html;

    # :: copy root filesystem changes
        COPY ./rootfs /

    # :: docker -u 1000:1000 (no root initiative)
        RUN set -ex; \
            chown -R nginx:nginx /keeweb;

# :: Volumes
    VOLUME ["/keeweb/www/etc", "/keeweb/www/db"]

# :: Monitor
    RUN apk --update add curl
    RUN chmod +x /usr/local/bin/healthcheck.sh
    HEALTHCHECK CMD /usr/local/bin/healthcheck.sh || exit 1

# :: Start
    RUN apk --update add openssl
    RUN chmod +x /usr/local/bin/entrypoint.sh
    USER nginx
    ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]