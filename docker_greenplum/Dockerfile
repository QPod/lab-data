# Distributed under the terms of the Modified BSD License.
ARG BASE_NAMESPACE
ARG BASE_IMG="base"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG} AS builder

COPY work /opt/utils/

RUN source /opt/utils/script-utils.sh \
 && install_apt /opt/utils/install_list_greenplum.apt \
 && apt-get -qq install -yq --no-install-recommends  gcc g++ bison flex cmake pkg-config ccache ninja-build \
 && install_tar_gz https://github.com/greenplum-db/gpdb/releases/download/7.0.0-beta.2/7.0.0-beta.2-src-full.tar.gz \
 && cd /opt/gpdb_src \
 && PYTHON=/opt/conda/bin/python3 ./configure --prefix=/opt/gpdb --with-perl --with-python --with-libxml --with-gssapi --with-openssl \
 && sudo make -j16 && sudo make install -j16
 
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

COPY rootfs /
COPY --from=builder --chown=1000:1000 /opt/gpdb /opt/gpdb

ENV GPDB_HOME="/opt/gpdb" \
    GPDB_DATA="/data/gpdb" \
    GPDB_USER="gpadmin" \
    PGPORT=5432 \
    PGUSER=gpadmin \
    PGDATABASE=postgres

RUN source /opt/utils/script-utils.sh \
 && ls -alh /etc/security/* ${GPDB_HOME}/* \
 && echo "source ${GPDB_HOME}/greenplum_path.sh" >> /etc/profile \
 && useradd -u 1000 ${GPDB_USER} -s /bin/bash -d /home/${GPDB_USER} \
 && usermod -aG root ${GPDB_USER} \
 && echo "${GPDB_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
 && echo "${GPDB_USER}:${GPDB_USER}" | chpasswd \
 && mkdir -pv ${GPDB_HOME}/conf ${GPDB_DATA} /home/${GPDB_USER}/.ssh \
 && chown -R ${GPDB_USER}:${GPDB_USER} ${GPDB_HOME} ${GPDB_DATA} /home/${GPDB_USER} \
 && install_apt /opt/utils/install_list_greenplum.apt \
 && export PATH="${PATH}:${GPDB_HOME}/bin" && cd ${GPDB_HOME}/bin && ls -alh \
 && PYTHON_SITE=$(python3 -c 'import sys;print(list(filter(lambda s: "site" in s, sys.path))[0])') \
 && sudo ln -s ${GPDB_HOME}/lib/python/* ${PYTHON_SITE}/ \
 && pip install -U psutil pygresql pyyaml \
 && cp ${GPDB_HOME}/docs/cli_help/gpconfigs/gpinitsystem_config ${GPDB_HOME}/conf/gpinitsystem_config \
 # config sshd
 && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -i -r 's/^.*StrictHostKeyChecking\s+\w+/StrictHostKeyChecking no/' /etc/ssh/ssh_config \
 && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
 && echo "Clean up" && list_installed_packages && install__clean

ENV PATH="$PATH:${GPDB_HOME}/bin"
USER ${GPDB_USER}
WORKDIR /home/${GPDB_USER}

RUN ulimit -n 65536 65536 \
 && [ -e ~/.ssh/id_rsa.pub ] || ssh-keygen -t rsa -b 4096 -N "" -C `GreenplumDB` -f ~/.ssh/id_rsa \
 && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
 && chmod 600 ~/.ssh/authorized_keys

EXPOSE 5432 22
VOLUME ["${GPDB_DATA}", "${GPDB_HOME}/conf"]
CMD  [ "bash" , "/opt/gpdb/entrypoint.sh"]
