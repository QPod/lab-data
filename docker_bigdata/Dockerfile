# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="python-3.11"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

ARG ARG_PROFILE_JAVA
ARG VERSION_JDK

COPY work /opt/utils/

ENV CONDA_PREFIX=/opt/conda
ENV JAVA_HOME=/opt/jdk
ENV PATH=$PATH:${CONDA_PREFIX}/bin:${JAVA_HOME}/bin

RUN set -eux \
 && source /opt/utils/script-setup.sh \
 && source /opt/utils/script-setup-db-clients.sh \
 && install_apt /opt/utils/install_list_base.apt \
 # -----------------------------
 && echo "If installing Java environment - notice that Java can be dependency for some other packages like flink" \
 && export VERSION_JDK=${VERSION_JDK:-11} \
 && for profile in $(echo $ARG_PROFILE_JAVA | tr "," "\n") ; do ( setup_java_${profile} ) ; done \
 # -----------------------------
 && echo "Install postgresql client:" && setup_postgresql_client \
 && echo "Install mysql client:" && setup_mysql_client \
 && echo "Install mongosh:" && setup_mongosh_client \
 && echo "Install redis-cli:" && setup_redis_client \
 && echo "Install pyspark:" && install_pip /opt/utils/list_install_pip_pyspark.txt \
 && echo "Install pyflink:" && install_pip /opt/utils/list_install_pip_pyflink.txt \
 && echo "Clean up" && list_installed_packages && install__clean
