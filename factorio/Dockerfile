FROM frolvlad/alpine-glibc:alpine-3.8_glibc-2.28

EXPOSE 34197/udp

RUN set -eux; \
  apk add -q --no-cache wget; \
  wget -qO factorio.tar.xz https://www.factorio.com/get-download/0.16.51/headless/linux64; \
  apk del -q wget; \
  tar Jxf factorio.tar.xz; \
  rm -rf /var/cache/apk factorio.tar.xz

VOLUME /factorio/saves

CMD [ "/factorio/bin/x64/factorio", "--start-server-load-latest", "--server-settings", "/factorio/data/server-settings.json" ]

RUN set -eux; \
  ( echo '{'; \
    echo '  "name": "Factorio LAN Server",'; \
    echo '  "description": "Factorio LAN Server",'; \
    echo '  "visibility": { "lan": true },'; \
    echo '  "require_user_verification": false,'; \
    echo '  "allow_commands": "true",'; \
    echo '  "autosave_interval": 60,'; \
    echo '  "autosave_slots": 1,'; \
    echo '  "auto_pause": false,'; \
    echo '  "non_blocking_saving": true'; \
    echo '}' ) > /factorio/data/server-settings.json
