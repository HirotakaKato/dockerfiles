#!/bin/sh
set -eu

if [ -n "${CA_CERT-}" ]; then
	echo "$CA_CERT" > /usr/share/ca-certificates/ca.cert
	echo /usr/share/ca-certificates/ca.cert >> /etc/ca-certificates.conf
	update-ca-certificates 2> /dev/null
fi

exec dockerd-entrypoint.sh "$@" ${DOCKER_INSECURE_REGISTRY:+--insecure-registry ${DOCKER_INSECURE_REGISTRY//,/ --insecure-registry }}
