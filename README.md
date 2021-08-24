# docker-keeweb
Keeweb with local hosted kdbx files (nginx, webdav, http auth). The idea is to mount the kdbx from another source (nfs, cifs) and use them localy within keeweb, secured by HTTP auth and SSL.

## Volumes
* /keeweb/www/etc - Purpose: Location of keeweb json config file
* /keeweb/www/db - Purpose: kdbx database location (used for webdav)

## Run
```shell
docker run --name keeweb \
    -v volume-etc:/keeweb/www/etc  \
    -v volume-db:/keeweb/www/db \
    -d 11notes/keeweb:[tag]
```

## Defaults
* HTTP 401 / user:foo / password:bar (/keeweb/www/.htpasswd) - please change!
* Keepass default.kdbx / password:foo - please use your own kdbx files!
* keeweb / /keeweb/www/etc/default.json - please adjust with your settings!
* kdbx / /keeweb/www/db/default.kdbx - please use your own kdbx files!
* 4096bit runtime RSA & 1024bit runtime DH (created at container start)

## Docker -u 1000:1000 (no root initiative)
As part to make containers more secure, this container will not run as root, but as uid:gid 1000:1000. Therefore the default TCP port 443 was changed to 8443.

## Build with
* [11notes/nginx:stable](https://github.com/11notes/docker-nginx) - Parent container
* [Keeweb](https://keeweb.info/) - Keeweb KeePass web interface

## Tips
* [Permanent Storge with NFS/CIFS/...](https://github.com/11notes/alpine-docker-netshare) - Module to store permanent container data via NFS/CIFS/...
* [Keepassium](https://keepassium.com/) - KeePass mobile app