# :: Header
    FROM 11notes/nginx:stable

    # :: SSL Settings
        ENV SSL_RSA_BITS=4096
        ENV SSL_DH_BITS=1024
        ENV SSL_ROOT="/keeweb/ssl"

# :: Run
    USER root
    RUN mkdir -p /keeweb/ssl

    RUN apk add --update --virtual .tools \
            wget unzip \
        && wget -O /tmp/keeweb.zip https://github.com/keeweb/keeweb/archive/gh-pages.zip \
        && unzip /tmp/keeweb.zip -d /tmp \
        && mv /tmp/keeweb-gh-pages /keeweb/www \
        && sed -i 's/(no-config)/\/etc\/default.json/g' /keeweb/www/index.html \
        && apk del .tools

    RUN apk add --update \
            openssl curl \
        && rm /nginx/etc/default.conf

    ADD ./source/keeweb.conf /nginx/etc/default.conf
    ADD ./source/keeweb.ssl.conf /keeweb/ssl/nginx.conf
    ADD ./source/entrypoint.sh /usr/local/bin/healthcheck.sh
    ADD ./source/entrypoint.sh /usr/local/bin/entrypoint.sh
    ADD ./source/keeweb.json /keeweb/www/etc/default.json
    ADD ./source/default.kdbx /keeweb/www/db/default.kdbx
    ADD ./source/.htpasswd /keeweb/www/.htpasswd
    RUN chmod +x /usr/local/bin/healthcheck.sh
    RUN chmod +x /usr/local/bin/entrypoint.sh

    # :: docker -u 1000:1000 (no root initiative)
        RUN chown -R nginx:nginx /keeweb

# :: Volumes
    VOLUME ["/keeweb/www/etc", "/keeweb/www/db"]

# :: Monitor
    RUN apk --update add curl
    HEALTHCHECK CMD /usr/local/bin/healthcheck.sh || exit 1

# :: Start
    USER nginx
    ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]