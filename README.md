# redis

Redis is an open-source, networked, in-memory, key-value data store with optional durability. It is written in ANSI C. The development of Redis is sponsored by Redis Labs today; before that, it was sponsored by Pivotal and VMware. According to the monthly ranking by DB-Engines.com, Redis is the most popular key-value store. The name Redis means REmote DIctionary Server.

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Logo-redis.svg/2560px-Logo-redis.svg.png" width="80%" height="auto">

wikipedia.org/wiki/Redis

## Security

For the ease of accessing Redis from other jails via AppJail networking, the "Protected mode" is turned off by default. This means that if you expose the port outside of your host (e.g., via `expose` option), it will be open without a password to anyone. It is highly recommended to set a password (by supplying a config file) if you plan on exposing your Redis instance to the internet. For further information, see the following links about Redis security:

* [Redis documentation on security](https://redis.io/topics/security)
* [A few things about Redis security by antirez](http://antirez.com/news/96)

## How to use this Makejail

### Start a redis instance

```sh
appjail makejail \
    -j redis \
    -f gh+AppJail-makejails/redis \
    -o virtualnet=":<random> default" \
    -o nat
```

### Connecting via `redis-cli`

```sh
appjail cmd jexec redis redis-cli -h some-redis
```

### Additionally, If you want to use your own redis.conf ...

This Makejail takes advantage of the rc script through profiles. You just need to copy your `redis.conf` to `/usr/local/etc/redis-<NAME>.conf` where `<NAME>` is the profile name. Of course, `redis_profiles` argument has to be configured for the profiles you want to enable.

```sh
appjail makejail \
    -j redis \
    -f gh+AppJail-makejails/redis \
    -o virtualnet=":<random> default" \
    -o nat \
    -o copydir=/tmp/files \
    -o file=/usr/local/etc/redis-standard.conf -- \
        --redis_profiles "standard"
```

### Arguments

* `redis_profiles` (default: `insecure`): Set of profiles to be enabled.
