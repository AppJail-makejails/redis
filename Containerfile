ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG NO_PKGCLEAN
ARG REDISVER

LABEL org.opencontainers.image.title="Redis" \
    org.opencontainers.image.description="Persistent key-value database with built-in net interface" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/redis" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/redis" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install redis${REDISVER}; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh && \
    mkdir -p /data

VOLUME ["/data"]

WORKDIR "/data"

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 6379

CMD ["redis-server"]
