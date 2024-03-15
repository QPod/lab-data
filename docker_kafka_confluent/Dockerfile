# Distributed under the terms of the Modified BSD License.
ARG BASE_NAMESPACE
ARG BASE_IMG="jdk-11"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

ARG KAFKA_VERSION="7.3.3"

LABEL maintainer="haobibo@gmail.com"

# ref: https://docs.confluent.io/platform/current/installation/docker/image-reference.html
# ref: https://github.com/confluentinc/kafka-images/blob/master/kafka/Dockerfile.ubi8

COPY work /opt/utils/

ENV COMPONENT=kafka \
    KAFKA_VERSION="${KAFKA_VERSION}" \
    KAFKA_HOME=/opt/kafka

RUN source /opt/utils/script-confluent-kafka.sh \
 && echo "Install confluent-kafka:" && setup_confluent_kafka \
 && echo "Setup confluent Kafka to run in KRaft mode" && setup_confluent_kafka_kraft \
 && echo "Clean up" && list_installed_packages && install__clean

ENV PATH=$PATH:$KAFKA_HOME/bin \
    CLUSTER_ID="pUyrmY_RQHClQc9LPBJqTw" \
    KAFKA_LOG_DIRS="/var/lib/${COMPONENT}/data"

EXPOSE 9092
VOLUME ["/var/lib/${COMPONENT}/data", "/etc/${COMPONENT}/secrets"]
ENTRYPOINT ["tini", "-g", "--"]
CMD ["/etc/confluent/docker/run"]
