# Redis

Redis is an open-source, networked, in-memory, key-value data store with optional durability. It is written in ANSI C. The development of Redis is sponsored by Redis Labs today; before that, it was sponsored by Pivotal and VMware. According to the monthly ranking by DB-Engines.com, Redis is the most popular key-value store. The name Redis means REmote DIctionary Server.

wikipedia.org/wiki/Redis

<img src="https://raw.githubusercontent.com/docker-library/docs/0e42ee108b46e1ba6333e9eb44201b8f26c4032d/redis/logo.png" width="30%" height="auto" alt="Redis logo">

## How to use this Makejail

### Security

"Protected mode" is turned on by default. For further information, see the following links about Redis security:

* [Redis documentation on security](https://redis.io/docs/latest/operate/oss_and_stack/management/security/)
* [Protected mode](https://redis.io/docs/latest/operate/oss_and_stack/management/security/#protected-mode)
* [A few things about Redis security by antirez](http://antirez.com/news/96)

### Process User and Privileges

If the first positional argument is `redis-server`, this image drops privileges by running `redis-server` as the `noroot` user, and the `/data` volume is mapped based on the `PUID` and `PGID` environment variables.

### Start a redis instance

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    ghcr.io/appjail-makejails/redis some-redis \
    redis-server --protected-mode no
```

### Start with persistent storage

```console
$ mkdir -p /var/appjail-volumes/redis/data
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o fstab="/var/appjail-volumes/redis/data /data" \
    ghcr.io/appjail-makejails/redis some-redis \
    redis-server --save 60 1 --loglevel warning
```

There are several different persistence strategies to choose from. This one will save a snapshot of the DB every 60 seconds if at least 1 write operation was performed (it will also lead to more logs, so the loglevel option may be desirable). If persistence is enabled, data is stored in the `VOLUME ["/data"]`, which can be used with `-o fstab="/appjail/host/dir /data"` (see [appjail.readthedocs.io volumes](https://appjail.readthedocs.io/en/latest/fs-mgmt/)).

For more about Redis persistence, see [the official Redis documentation](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/).

### Connecting via redis-cli

```console
$ appjail oci run \
    -o ephemeral \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    ghcr.io/appjail-makejails/redis redis-client \
    redis-cli -h some-redis && 
  appjail stop redis-client
```

### Additionally, if you want to use your own `redis.conf` ...

You can create your own `Containerfile` that adds a `redis.conf` from the context into `/data/`, like so.

```dockerfile
FROM ghcr.io/appjail-makejails/redis
COPY redis.conf /usr/local/etc/redis.conf
CMD [ "redis-server", "/usr/local/etc/redis.conf" ]
```

Alternatively, you can specify something along the same lines with `appjail oci run` options.

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o fstab="/myredis.conf usr/local/etc/redis.conf nullfs ro" \
    ghcr.io/appjail-makejails/redis myredis \
    redis-server --protected-mode no /usr/local/etc/redis.conf
```

Where `/myredis.conf` is a local file containing your `redis.conf` file. Using this method means that there is no need for you to have a `Containerfile` for your redis container.

### Arguments (stage: build)

* `redis_from` (default: `ghcr.io/appjail-makejails/redis`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `redis_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-263aca83a3-data | `${PUID}` | `${PGID}` | - | - | /data |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-62
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        REDISVER: "62"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-72
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        REDISVER: "72"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-74
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        REDISVER: "74"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-80
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        REDISVER: "80"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-82
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        REDISVER: "82"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-84
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        REDISVER: "84"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-86
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        REDISVER: "86"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-devel
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        REDISVER: "-devel"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```

## Notes

1. The ideas present in the Docker image of Redis are taken into account for users who are familiar with it.
