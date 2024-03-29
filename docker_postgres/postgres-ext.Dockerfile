# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="postgres"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/

RUN set -x && . /opt/utils/script-utils.sh \
 && apt-get update && apt-get install -y gettext \
 && DISTRO_NAME=$(awk '{ print tolower($0) }' <<< $(lsb_release -is)) \
 && DISTRO_CODE_NAME=$(lsb_release -cs) \
 # apt source for: https://packagecloud.io/citusdata/community
 && curl -fsSL "https://packagecloud.io/citusdata/community/gpgkey" | gpg --dearmor > /etc/apt/trusted.gpg.d/citusdata_community.gpg \
 && echo "deb https://packagecloud.io/citusdata/community/${DISTRO_NAME}/ ${DISTRO_CODE_NAME} main" | sudo tee /etc/apt/sources.list.d/citusdata_community.list \
 # apt source for: https://packagecloud.io/timescale/timescaledb
 && curl -fsSL "https://packagecloud.io/timescale/timescaledb/gpgkey" | gpg --dearmor > /etc/apt/trusted.gpg.d/timescale_timescaledb.gpg \
 && echo "deb https://packagecloud.io/timescale/timescaledb/${DISTRO_NAME}/ ${DISTRO_CODE_NAME} main" | sudo tee /etc/apt/sources.list.d/timescale_timescaledb.list \
 # apt source for: https://packagecloud.io/pigsty/pgsql
 && curl -fsSL "https://packagecloud.io/pigsty/pgsql/gpgkey" | gpg --dearmor > /etc/apt/trusted.gpg.d/pigsty_pgsql.gpg \
 && echo "deb https://packagecloud.io/pigsty/pgsql/${DISTRO_NAME}/ ${DISTRO_CODE_NAME} main" | sudo tee /etc/apt/sources.list.d/pigsty_pgsql.list \
 && envsubst < /opt/utils/install_list_pgext.tpl.apt > /opt/utils/install_list_pgext.apt \
 && rm -rf /opt/utils/install_list_pgext.tpl.apt \
 && echo "To install PG extensions: $(cat /opt/utils/install_list_pgext.apt)" \
 && install_apt /opt/utils/install_list_pgext.apt \
 && ls -alh /usr/share/postgresql/*/extension/*.control | sort \
 && echo "Clean up" && list_installed_packages && install__clean

USER postgres
WORKDIR /var/lib/postgresql
