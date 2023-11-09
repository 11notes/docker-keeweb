#!/bin/ash
  if [ ! -e "${APP_ROOT}/ssl/cert.pem" ] || [ ! -e "${APP_ROOT}/ssl/key.pem" ]; then
    openssl req -x509 -newkey rsa:4096 -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=XX" \
      -keyout "${APP_ROOT}/ssl/key.pem" \
      -out "${APP_ROOT}/ssl/cert.pem" \
      -days 3650 -nodes -sha256 &> /dev/null
  fi

  if [ ! -e "${APP_ROOT}/ssl/dh.pem" ]; then
    openssl dhparam -out "${APP_ROOT}/ssl/dh.pem" 1024 &> /dev/null
  fi

  if [ -z "$1" ]; then
    set -- "nginx" \
      -g \
      'daemon off;'
  fi

  exec "$@"