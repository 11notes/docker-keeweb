# Alpine :: KeeWeb
Run KeeWeb based on Alpine Linux. Small, lightweight, secure and fast.

Keeweb with local hosted kdbx files (nginx, webdav, http auth). The idea is to mount the kdbx from another source (NFS, CIFS or -v) and use them localy within keeweb, secured by HTTP auth and SSL.

## Volumes
* **/keeweb/www/etc** - Directory of keeweb json config file
* **/keeweb/www/db** - Directory of database location

## Run
```shell
docker run --name keeweb \
  -v ../keeweb/etc:/keeweb/www/etc  \
  -v ../keeweb/db:/keeweb/www/db \
  -d 11notes/keeweb:[tag]
```

## Defaults
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `ssl` | 4096bit | 4k RSA for nginx |
| `dh` | 1024bit | 1k RSA for DH |

## Demo Parameters
* HTTP 401 / user:foo / password:bar (/keeweb/www/.htpasswd) - please change!
* Keepass default.kdbx / password:foo - please use your own kdbx files!
* keeweb / /keeweb/www/etc/default.json - please adjust with your settings!
* kdbx / /keeweb/www/db/default.kdbx - please use your own kdbx files!

## Parent
* [11notes/nginx:stable](https://github.com/11notes/docker-nginx)

## Built with
* [Alpine Linux](https://alpinelinux.org/)
* [KeeWeb](https://keeweb.info/)

## Tips
* Don't bind to ports < 1024 (requires root), use NAT/reverse proxy
* [Permanent Stroage](https://github.com/11notes/alpine-docker-netshare) - Module to store permanent container data via NFS/CIFS and more
* [Keepassium](https://keepassium.com/) - KeePass mobile app