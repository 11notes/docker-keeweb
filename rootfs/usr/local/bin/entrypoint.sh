#!/bin/ash
  if [ -z "${1}" ]; then
    if [ ! -f "/nginx/ssl/default.crt" ]; then
      elevenLogJSON debug "creating default TLS/SSL certificate"
      openssl req -x509 -newkey rsa:4096 -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=${APP_NAME}" \
        -keyout "/nginx/ssl/default.key" \
        -out "/nginx/ssl/default.crt" \
        -days 3650 -nodes -sha256 &> /dev/null
    fi

    echo "${KEEWEB_HTPASSWD}" > ${APP_ROOT}/etc/.htpasswd
    echo "${KEEWEB_CONFIG}" > ${APP_ROOT}/static/default.json

    elevenLogJSON info "starting ${APP_NAME} v${APP_VERSION}"
    set -- "nginx" \
      -g \
      'daemon off;'
  fi

  exec "$@"