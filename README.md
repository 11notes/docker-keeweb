![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# keeweb
[<img src="https://img.shields.io/badge/github-source-blue?logo=github">](https://github.com/11notes/docker-keeweb/tree/1.18.7) ![size](https://img.shields.io/docker/image-size/11notes/keeweb/1.18.7?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/keeweb/1.18.7?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/keeweb?color=2b75d6)

**KeePass, but in your browser**

# SYNOPSIS
**What can I do with this?** This image will provide you a webinterface for your KeePass databases. You can add additional authentication layers via your reverse proxies, by default it will only use HTTP basic authentication and your master password of course.

# COMPOSE
```yaml
name: "keeweb"
services:
  keeweb:
    image: "11notes/keeweb:1.18.7"
    environment:
      TZ: Europe/Zurich
      # user1 // foo
      # user2 // bar
      # escape $ with $
      KEEWEB_HTPASSWD: |-
        user1:$apr1$lG5s/RN7$jJ7nREeEyIJ155IA5jT9h1
        user2:$apr1$fT6w1aEW$OJ4bzrQBlfPMM1RLV.Obf/
      KEEWEB_CONFIG: |-
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
            "path":"/var/default.kdbx"
          }]
        }
    volumes:
      - "etc:/keeweb/etc"
      - "var:/keeweb/var"
    ports:
      - "8443:8443/tcp"
    restart: always
volumes:
  etc:
  var:
```

# DEFAULT SETTINGS
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /keeweb | home directory of user docker |

# ENVIRONMENT
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Show debug information | |

# SOURCE
* [11notes/keeweb:1.18.7](https://github.com/11notes/docker-keeweb/tree/1.18.7)

# BUILT WITH
* [keeweb](https://keeweb.info)
* [alpine](https://alpinelinux.org)

# TIPS
* Use a reverse proxy like Traefik, Nginx to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints

# ElevenNotes<sup>™️</sup>
This image is provided to you at your own risk. Always make backups before updating an image to a different version. Check the [RELEASE.md](https://github.com/11notes/docker-keeweb/blob/1.18.7/RELEASE.md) for breaking changes. You can find all my repositories on [github](https://github.com/11notes).