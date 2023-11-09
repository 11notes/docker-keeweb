# Alpine :: KeeWeb
![size](https://img.shields.io/docker/image-size/11notes/keeweb/1.18.7?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/keeweb?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/keeweb?color=2b75d6) ![activity](https://img.shields.io/github/commit-activity/m/11notes/docker-keeweb?color=c91cb8) ![commit-last](https://img.shields.io/github/last-commit/11notes/docker-keeweb?color=c91cb8)

Run KeeWeb based on Alpine Linux. Small, lightweight, secure and fast 🏔️

Keeweb with local hosted kdbx files (nginx, webdav, http auth). The idea is to mount the kdbx from another source (NFS, CIFS or -v) and use them localy within keeweb, secured by HTTP auth and SSL.

## Volumes
* **/keeweb/www/etc** - Directory of keeweb json config file
* **/keeweb/www/db** - Directory of database location

## Run
```shell
docker run --name keeweb \
  -v ../etc:/keeweb/www/etc  \
  -v ../db:/keeweb/www/db \
  -d 11notes/keeweb:[tag]
```

## Defaults
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id |
| `gid` | 1000 | group id |
| `ssl` | 4096bit | 4k RSA for nginx |
| `dh` | 1024bit | 1k RSA for DH |

## Demo Parameters
* HTTP 401 / user:foo / password:bar (/keeweb/www/.htpasswd) - please change!
* Keepass default.kdbx / password:foo - please use your own kdbx files!
* keeweb / /keeweb/www/etc/default.json - please adjust with your settings!
* kdbx / /keeweb/www/db/default.kdbx - please use your own kdbx files!

## Parent image
* [11notes/nginx:stable](https://github.com/11notes/docker-nginx)

## Built with and thanks to
* [KeeWeb](https://keeweb.info)
* [Alpine Linux](https://alpinelinux.org)

## Tips
* Only use rootless container runtime (podman, rootless docker)
* Don't bind to ports < 1024 (requires root), use NAT/reverse proxy (haproxy, traefik, nginx)
* [Keepassium](https://keepassium.com/) - KeePass mobile app