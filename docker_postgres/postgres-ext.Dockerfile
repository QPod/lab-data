# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="postgres"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

COPY rootfs /

RUN set -x && . /opt/utils/script-utils.sh && . /opt/utils/script-setup-pg_ext_mirror.sh \
 && apt-get update && apt-get install -y gettext \
 && envsubst < /opt/utils/install_list_pgext.tpl.apt > /opt/utils/install_list_pgext.apt \
 && rm -rf /opt/utils/install_list_pgext.tpl.apt \
 && echo "To install PG extensions: $(cat /opt/utils/install_list_pgext.apt)" \
 && install_apt /opt/utils/install_list_pgext.apt \
 && . /opt/utils/script-setup-pg_ext.sh \
 && ls -alh /usr/share/postgresql/*/extension/*.control | sort \
 && echo "Clean up" && list_installed_packages && install__clean

USER postgres
WORKDIR /var/lib/postgresql
