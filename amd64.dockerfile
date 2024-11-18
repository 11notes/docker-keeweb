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
  FROM 11notes/nginx:stable
  COPY --from=util /util/linux/shell/elevenLogJSON /usr/local/bin
  COPY --from=build /opt/keeweb/ /keeweb/static
  ENV APP_ROOT=/keeweb
  ENV APP_NAME="keeweb"
  ENV APP_VERSION=1.18.7

# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --no-cache --update add \
        openssl;

  # :: prepare image
    RUN set -ex; \ 
      mkdir -p \
        ${APP_ROOT}/etc;

    RUN set -ex; \
      sed -i 's@(no-config)@/default.json@g' ${APP_ROOT}/static/index.html;

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
  VOLUME ["${APP_ROOT}/etc", "${APP_ROOT}/var"]

# :: Monitor
  HEALTHCHECK CMD /usr/local/bin/healthcheck.sh || exit 1

# :: Start
  USER docker
  ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]