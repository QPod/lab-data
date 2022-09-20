# Distributed under the terms of the Modified BSD License.

ARG BASE_NAMESPACE
ARG BASE_IMG="base"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

RUN source /opt/utils/script-setup.sh \
 && apt-get -qq update -yq --fix-missing && apt-get -qq install -yq --no-install-recommends openjdk-11-jdk-headless \
 && pip install -U apache-flink \
 && install__clean && list_installed_packages
