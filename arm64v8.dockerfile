# :: QEMU
  FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone https://github.com/11notes/util.git;

# :: Build
  FROM alpine as build
  ENV BUILD_VERSION=1.18.7

  ADD https://github.com/keeweb/keeweb/releases/download/v${BUILD_VERSION}/KeeWeb-${BUILD_VERSION}.html.zip /tmp
  RUN set -ex; \
    mkdir -p /opt/keeweb; \
    apk --no-cache add \
      unzip; \
    unzip /tmp/KeeWeb-${BUILD_VERSION}.html.zip -d /opt/keeweb;


# :: Header
  FROM 11notes/nginx:arm64v8-stable
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  COPY --from=util /util/linux/shell/elevenLogJSON /usr/local/bin
  COPY --from=build /opt/keeweb/ /keeweb/www
  ENV APP_ROOT=/keeweb
  ENV APP_NAME="keeweb"

# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --no-cache add \
        openssl; \
      apk --no-cache upgrade;

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