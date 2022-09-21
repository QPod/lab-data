# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="base"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

ENV JAVA_HOME=/opt/jdk

COPY work /opt/utils/

RUN source /opt/utils/script-setup.sh \
 # && apt-get -qq update -yq --fix-missing && apt-get -qq install -yq --no-install-recommends openjdk-11-jdk-headless
 && setup_java_base && export JAVA_HOME="/opt/jdk" \
 # manually fix pyflink dependencies
 && install_pip /opt/utils/list_install_pip_pyflink.txt \
 && pip install -U --no-deps apache-flink-libraries apache-flink \
 && install__clean && list_installed_packages
