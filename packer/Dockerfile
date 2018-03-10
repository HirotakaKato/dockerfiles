FROM hirotakakato/virtualbox:latest

RUN set -eux; \
  curl -fLRSso packer.zip $(curl -s https://www.packer.io/downloads.html | sed 's/^.* href="\(.*_linux_amd64\.zip\)".*$/\1/p' -n); \
  yum -y install unzip; \
  unzip packer.zip -d /usr/local/bin; \
  yum -y autoremove unzip; \
  rm -rf /var/cache/yum packer.zip
