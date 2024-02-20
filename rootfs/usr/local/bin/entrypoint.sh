#!/bin/ash
  if [ -z "${1}" ]; then
    if [ ! -f "${APP_ROOT}/ssl/default.crt" ]; then
      elevenLogJSON info "creating default TLS/SSL certificate"
      openssl req -x509 -newkey rsa:4096 -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=${APP_NAME}" \
        -keyout "${APP_ROOT}/ssl/default.key" \
        -out "${APP_ROOT}/ssl/default.crt" \
        -days 3650 -nodes -sha256 &> /dev/null
    fi

    if [ ! -f "${APP_ROOT}/ssl/dh.pem" ]; then
      openssl dhparam -out "${APP_ROOT}/ssl/dh.pem" 1024 &> /dev/null
    fi

    elevenLogJSON info "starting nginx"
    set -- "nginx" \
      -g \
      'daemon off;'
  fi

  exec "$@"