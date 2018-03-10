FROM hirotakakato/virtualbox:latest

RUN set -eux; \
  curl -fLRSso vagrant.rpm $(curl -s https://www.vagrantup.com/downloads.html | sed 's/^.* href="\(.*_x86_64\.rpm\)".*$/\1/p' -n); \
  yum -y install openssh-clients rsync vagrant.rpm; \
  rm -rf /var/cache/yum vagrant.rpm
