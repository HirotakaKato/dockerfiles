FROM alpine:3.8

RUN set -eux; \
  apk add --no-cache dumb-init iptables squid thttpd; \
  \
  sed /etc/squid/squid.conf \
    -e '/^#http_access deny to_localhost$/ s/^#//' \
    -e '/^http_port 3128$/ a http_port 3129 intercept' \
    -e '/^#cache_dir / s/^#//' \
    -e '/^cache_dir / s/ 100 / 10000 /' \
    -e '/^cache_dir / a maximum_object_size 5 GB' \
    -e '$ a \\n' \
    -e '$ a access_log stdio:/dev/stdout combined' \
    -e '$ a cache_log /dev/stderr' \
    -e '$ a forwarded_for delete' \
    -e '$ a shutdown_lifetime 1 second' \
    -e '$ a visible_hostname unknown' \
    -e '$ a \\n' \
    -e '$ a acl url_rewrite url_regex ^http://mirrorlist\.centos\.org/\?' \
    -e '$ a \\n' \
    -e '$ a url_rewrite_access allow url_rewrite' \
    -e '$ a url_rewrite_children 1 startup=1' \
    -e '$ a url_rewrite_program /etc/squid/url_rewrite' \
    -i; \
  \
  ( \
    echo '#!/bin/sh'; \
    echo; \
    echo 'while read url dummy; do'; \
    echo '  echo "$url" | sed "s|^http://mirrorlist\.centos\.org/?release=\([^&]\+\)&arch=\([^&]\+\)&repo=\([^&]\+\).*$|http://localhost:3127/?http://ftp.iij.ad.jp/pub/linux/centos/\1/\3/\2/|"'; \
    echo 'done'; \
  ) | install -m 755 /dev/stdin /etc/squid/url_rewrite; \
  \
  ( \
    echo '#!/bin/sh'; \
    echo; \
    echo 'echo -e "Content-type: text/plain\n"'; \
    echo 'echo -n "$QUERY_STRING"'; \
  ) | install -m 755 /dev/stdin /var/www/http/index.cgi; \
  \
  ( \
    echo '#!/bin/sh'; \
    echo; \
    echo 'while true; do thttpd -p 3127 -d /var/www/http -c "*.cgi" -D; done'; \
  ) | install -m 755 /dev/stdin /thttpd.sh; \
  \
  ( \
    echo '#!/bin/sh'; \
    echo; \
    echo 'prerouting="iptables -A PREROUTING -t nat -m addrtype ! --dst-type LOCAL -p tcp --dport 80 -j REDIRECT --to-port 3129"'; \
    echo 'output="${prerouting/PREROUTING/OUTPUT} -m owner ! --uid-owner squid"'; \
    echo; \
    echo 'trap "${prerouting/-A/-D}; ${output/-A/-D}" EXIT'; \
    echo '$prerouting'; \
    echo '$output'; \
    echo; \
    echo 'tail -f /dev/null'; \
  ) | install -m 755 /dev/stdin /iptables.sh; \
  \
  ( \
    echo '#!/bin/sh'; \
    echo; \
    echo '/thttpd.sh &'; \
    echo '/iptables.sh &'; \
    echo; \
    echo 'chown squid: /dev/stderr /dev/stdout'; \
    echo 'exec squid -N';\
  ) | install -m 755 /dev/stdin /cmd.sh; \
  \
  chown squid: /dev/stderr; \
  squid -Nz

VOLUME /var/cache/squid

CMD [ "dumb-init", "/cmd.sh" ]
