# :: Build
  FROM alpine as build
  ENV keewebVersion=1.18.7

  ADD https://github.com/keeweb/keeweb/releases/download/v${keewebVersion}/KeeWeb-${keewebVersion}.html.zip /tmp
  RUN set -ex; \
    mkdir -p /opt/keeweb; \
    apk --no-cache add \
      unzip; \
    unzip /tmp/KeeWeb-${keewebVersion}.html.zip -d /opt/keeweb;


# :: Header
  FROM 11notes/nginx:stable
  COPY --from=build /opt/keeweb/ /keeweb/www
  ENV APP_ROOT=/keeweb

# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk update; \
      apk --no-cache add \
        openssl; \
      apk upgrade;

  # :: prepare image
    RUN set -ex; \ 
      mkdir -p \
        ${APP_ROOT}/ssl \
        ${APP_ROOT}/www/etc \
        ${APP_ROOT}/www/db;

    RUN set -ex; \
      sed -i 's/(no-config)/\/etc\/default.json/g' ${APP_ROOT}/www/index.html;

  # :: copy root filesystem changes and add execution rights to init scripts
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin

  # :: change home path for existing user and set correct permission
    RUN set -ex; \
      usermod -d ${APP_ROOT} docker; \
      chown -R 1000:1000 \
        ${APP_ROOT};

# :: Volumes
  VOLUME ["${APP_ROOT}/www/etc", "${APP_ROOT}/www/db"]

# :: Monitor
  HEALTHCHECK CMD /usr/local/bin/healthcheck.sh || exit 1

# :: Start
  USER docker
  ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]