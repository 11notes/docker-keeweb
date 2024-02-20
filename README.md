![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# 🏔️ Alpine - keeweb
![size](https://img.shields.io/docker/image-size/11notes/keeweb/1.18.7?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/keeweb/1.18.7?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/keeweb?color=2b75d6) ![activity](https://img.shields.io/github/commit-activity/m/11notes/docker-keeweb?color=c91cb8) ![commit-last](https://img.shields.io/github/last-commit/11notes/docker-keeweb?color=c91cb8) ![stars](https://img.shields.io/docker/stars/11notes/keeweb?color=e6a50e)

*KeePass, but in your browser, secured by TLS/SSL & HTTP401 & your master password**

# SYNOPSIS
What can I do with this? This image will provide you a webinterface for KeePass secured by TLS/SSL, HTTP 401 authentication and of course, your master password.


# VOLUMES
* **/keeweb/www/etc** - Directory of keeweb json config file
* **/keeweb/www/db** - Directory of kdbx database

# RUN
```shell
docker run --name keeweb \
  -v .../etc:/keeweb/www/etc \
  -v .../db:/keeweb/www/var \
  -d 11notes/keeweb:[tag]
```

# EXAMPLES
## config /keeweb/www/etc/default.json
```json
{
  "settings":{
    "theme":"te",
    "locale":"en",
    "autoUpdate":false,
    "colorfulIcons":true,
    "fontSize":1,
    "canImportXml":false,
    "canCreate":false,
    "canOpenDemo":false,
    "webdav":true,
    "webdavSaveMethod":"put",
    "hideEmptyFields":false,
    "autoSave":true,
    "idleMinutes":15
  },
  "files":[{
    "storage":"webdav",
    "name":"default",
    "path":"/db/default.kdbx"
  }]
}
```

# DEFAULT SETTINGS
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /keeweb | home directory of user docker |
| `web` | https://${IP}:8443 | web interface |
| `401 login` | foo // bar | default login for demo |
| `master password` | foo | default master password for demo |

# ENVIRONMENT
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Show debug information | |

# PARENT IMAGE
* [11notes/nginx:stable](https://hub.docker.com/r/11notes/nginx)

# BUILT WITH
* [keeweb](https://keeweb.info)
* [alpine](https://alpinelinux.org)

# TIPS
* Only use rootless container runtime (podman, rootless docker)
* Allow non-root ports < 1024 via `echo "net.ipv4.ip_unprivileged_port_start=53" > /etc/sysctl.d/ports.conf`
* Use a reverse proxy like Traefik, Nginx to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints
* [keepassium](https://keepassium.com/) - best KeePass mobile app

# ElevenNotes<sup>™️</sup>
This image is provided to you at your own risk. Always make backups before updating an image to a new version. Check the changelog for breaking changes.
    