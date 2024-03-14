# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="base"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG} as builder

ARG PG_MAJOR=15
FROM library/postgres:${PG_MAJOR:-latest}

LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/
COPY --from=builder /opt /opt

RUN set -x \
 && apt-get update && apt-get install -y gettext \
   apt-utils apt-transport-https ca-certificates gnupg2 dirmngr locales sudo lsb-release curl \
 && envsubst < /opt/utils/install_list_pgext.apt > /opt/utils/install_list_pgext.apt \
 && . /opt/utils/script-utils.sh \
 && install_apt /opt/utils/install_list_base.apt \
 && install_apt /opt/utils/install_list_pgext.apt \
 && echo "Clean up" && list_installed_packages && install__clean
