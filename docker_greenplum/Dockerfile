# Distributed under the terms of the Modified BSD License.
ARG BASE_NAMESPACE
ARG BASE_IMG="base"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}


LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/

RUN source /opt/utils/script-utils.sh \
 && install_apt /opt/work/install_list_greenplum.apt \
 && install_tar_gz https://github.com/greenplum-db/gpdb/releases/download/7.0.0-beta.2/7.0.0-beta.2-src-full.tar.gz \
 && cd /opt/gpdb_src \
 && PYTHON=/opt/conda/bin/python3 ./configure --prefix=/opt/gpdb --with-perl --with-python --with-libxml --with-gssapi --with-openssl \
 && sudo make -j16 && sudo make install -j16 \
 && sudo chown -R gpadmin:gpadmin /opt/gpdb


 && echo "Clean up" && list_installed_packages && install__clean


EXPOSE 5432 22
