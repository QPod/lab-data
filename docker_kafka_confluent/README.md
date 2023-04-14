# Confluent Kafka in KRaft mode

In the KRaft mode, zookeeper is not need.
To start a standalone mode KRaft kafka, use the `docker-compose.yml` file in this folder.

## Development - debug inside docker

```bash
docker run -it \
    --name=cp-ckafka \
    -h=broker \
    -p=9092:9092 \
    -v $(pwd):/root/dev \
    qpod/jdk11 bash

export KAFKA_BROKER_ID=1
export KAFKA_LISTENER_SECURITY_PROTOCOL_MAP='CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT'
export KAFKA_ADVERTISED_LISTENERS='PLAINTEXT://broker:29092,PLAINTEXT_HOST://localhost:9092'
export KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1
export KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0
export KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1
export KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1
export KAFKA_JMX_PORT=9101
export KAFKA_JMX_HOSTNAME=localhost
export KAFKA_PROCESS_ROLES='broker,controller'
export KAFKA_NODE_ID=1
export KAFKA_CONTROLLER_QUORUM_VOTERS='1@broker:29093'
export KAFKA_LISTENERS='PLAINTEXT://broker:29092,CONTROLLER://broker:29093,PLAINTEXT_HOST://0.0.0.0:9092'
export KAFKA_INTER_BROKER_LISTENER_NAME='PLAINTEXT'
export KAFKA_CONTROLLER_LISTENER_NAMES='CONTROLLER'
export KAFKA_LOG_DIRS='/tmp/kraft-combined-logs'
export KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1

export COMPONENT=kafka
export KAFKA_HOME=/opt/kafka
export PATH=$PATH:$KAFKA_HOME/bin

export CLUSTER_ID="${CLUSTER_ID:-$(kafka-storage random-uuid)}"
kafka-storage format --ignore-formatted -t "${CLUSTER_ID}" -c /etc/kafka/kafka.properties

sed -i '1i\
export CLUSTER_ID="${CLUSTER_ID:-$(kafka-storage random-uuid)}"
' /etc/confluent/docker/run

/etc/confluent/docker/run > /tmp/kafka.log
```

## Development - build the docker image and run

```bash
docker build -t qpod/kafka --build-arg "BASE_NAMESPACE=qpod" .

docker run -it \
 -e KAFKA_BROKER_ID=1 \
 -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP='CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT' \
 -e KAFKA_ADVERTISED_LISTENERS='PLAINTEXT://broker:29092,PLAINTEXT_HOST://localhost:9092' \
 -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
 -e KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0 \
 -e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
 -e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
 -e KAFKA_JMX_PORT=9101 \
 -e KAFKA_JMX_HOSTNAME=localhost \
 -e KAFKA_PROCESS_ROLES='broker,controller' \
 -e KAFKA_NODE_ID=1 \
 -e KAFKA_CONTROLLER_QUORUM_VOTERS='1@broker:29093' \
 -e KAFKA_LISTENERS='PLAINTEXT://broker:29092,CONTROLLER://broker:29093,PLAINTEXT_HOST://0.0.0.0:9092' \
 -e KAFKA_INTER_BROKER_LISTENER_NAME='PLAINTEXT' \
 -e KAFKA_CONTROLLER_LISTENER_NAMES='CONTROLLER' \
 -e KAFKA_LOG_DIRS='/tmp/kraft-combined-logs' \
 -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
 --name cp-kafka \
 -h broker \
 -p 9092:9092 \
 -v $(pwd):/root/dev \ 
 qpod0dev/cp-kafka
```
