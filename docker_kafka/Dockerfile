# Distributed under the terms of the Modified BSD License.
ARG BASE_NAMESPACE
ARG BASE_IMG="jdk11"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/


RUN source /opt/utils/script-confluent-kafka.sh \
 && echo "Install confluent-kafka:" && setup_confluent_kafka \
 && echo "Clean up" && list_installed_packages && install__clean
