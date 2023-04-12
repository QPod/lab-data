# Distributed under the terms of the Modified BSD License.
ARG BASE_NAMESPACE
ARG BASE_IMG="jdk11"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

ARG KAFKA_VERSION="7.3.3"

LABEL maintainer="haobibo@gmail.com"

COPY work /opt/utils/

ENV KAFKA_HOME=/opt/kafka \
    KAFKA_VERSION="${KAFKA_VERSION}"

RUN source /opt/utils/script-confluent-kafka.sh \
 && echo "Install confluent-kafka:" && setup_confluent_kafka \
 && echo "Setup confluent kafka to use KRaft" && setup_confluent_kafka_kraft \
 && echo "Clean up" && list_installed_packages && install__clean

VOLUME ["/var/lib/kafka/data", "/etc/kafka/secrets"]
CMD ["/etc/confluent/docker/run"]
