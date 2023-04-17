# Distributed under the terms of the Modified BSD License.
ARG BASE_NAMESPACE
ARG BASE_IMG="base"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/

ENV GPDB_HOME="/opt/gpdb" \
    GPDB_DATA="/data/gpdb" \
    GPDB_USER="gpadmin"

RUN source /opt/utils/script-utils.sh \
 && install_apt /opt/utils/install_list_greenplum.apt \
 && useradd ${GPDB_USER} \
 && usermod -aG root ${GPDB_USER} \
 && echo "${GPDB_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
 && mkdir -p /home/${GPDB_USER}/.ssh \
 && chown -R ${GPDB_USER}:${GPDB_USER} /home/${GPDB_USER} \
 && echo "${GPDB_USER}:${GPDB_USER}" | chpasswd \
 && install_tar_gz https://github.com/greenplum-db/gpdb/releases/download/7.0.0-beta.2/7.0.0-beta.2-src-full.tar.gz \
 && cd /opt/gpdb_src \
 && export PATH="${PATH}":${GPDB_HOME}/bin \
 && PYTHON=/opt/conda/bin/python3 ./configure --prefix=${GPDB_HOME} --with-perl --with-python --with-libxml --with-gssapi --with-openssl \
 && sudo make -j16 && sudo make install -j16 \
 && mkdir -pv ${GPDB_HOME}/conf ${GPDB_DATA} \
 && sudo chown -R ${GPDB_USER}:${GPDB_USER} ${GPDB_HOME} ${GPDB_DATA} \
 && cp ${GPDB_HOME}/docs/cli_help/gpconfigs/gpinitsystem_config ${GPDB_HOME}/conf/gpinitsystem_config \
 && PYTHON_SITE=$(python3 -c 'import sys;print(list(filter(lambda s: "site" in s, sys.path))[0])') \
 && sudo ln -s ${GPDB_HOME}/lib/python/* ${PYTHON_SITE}/ \
 && pip install conan psutil pygresql \
 && cp -rf /opt/utils/etc / && rm -rf /opt/utils/etc /opt/gpdb_src \
 && echo "source ${GPDB_HOME}/greenplum_path.sh" >> /etc/profile \
 && echo "Clean up" && list_installed_packages && install__clean

USER ${GPDB_USER}
EXPOSE 5432 22
VOLUME ["${GPDB_HOME}"]
