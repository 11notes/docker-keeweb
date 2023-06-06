#!/bin/ash
  if [ ! -e "${SSL_ROOT}/cert.pem" ] || [ ! -e "${SSL_ROOT}/key.pem" ]; then
    openssl req -x509 -newkey rsa:${SSL_RSA_BITS} -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=XX" \
      -keyout "${SSL_ROOT}/key.pem" \
      -out "${SSL_ROOT}/cert.pem" \
      -days 3650 -nodes -sha256 &> /dev/null
  fi

  if [ ! -e "${SSL_ROOT}/dh.pem" ]; then
    openssl dhparam -out "${SSL_ROOT}/dh.pem" ${SSL_DH_BITS} &> /dev/null
  fi

  if [ -z "$1" ]; then
    set -- "nginx" \
      -g \
      'daemon off;'
  fi

  exec "$@"