# Start a Standalone mode single-node Kafka cluster in Kraft mode (using confluent kafka)

Notice: the `localhost` in the `KAFKA_ADVERTISED_LISTENERS` needed to be changed to your host's external IP/hostname.

```bash
KAFKA_DATA_DIR="/data/kafka-confluent/broker" && mkdir -pv $KAFKA_DATA_DIR && chmod -R ugo+rws $KAFKA_DATA_DIR
docker-compose up -d
```

## Debug

```bash
docker run -it --rm \
    -e CLUSTER_ID='k4hJjYlsRYSk9UQcZjN0rA' \
    -e KAFKA_BROKER_ID=1 \
    -e KAFKA_NODE_ID=1 \
    -e KAFKA_LOG_DIRS='/var/lib/kafka/data' \ \
    -e KAFKA_PROCESS_ROLES='broker,controller' \
    -e KAFKA_CONTROLLER_QUORUM_VOTERS='1@127.0.0.1:9093' \
    -e KAFKA_CONTROLLER_LISTENER_NAMES='CONTROLLER' \
    -e KAFKA_INTER_BROKER_LISTENER_NAME='PLAINTEXT' \
    -e KAFKA_LISTENERS='CONTROLLER://:9093,PLAINTEXT://:9092' \
    -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP='CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT' \
    -e KAFKA_ADVERTISED_LISTENERS='PLAINTEXT://localhost:9092' \
    --name kafka-broker \
    -h broker \
    -p 9092:9092 \
    -v /data/kafka-confluent/broker/data:/var/lib/kafka/data \
    -v /data/kafka-confluent/broker/secrets:/etc/kafka/secrets \
docker.io/qpod/kafka:latest bash

/etc/confluent/docker/run
```

## Development

```bash
docker run -it \
    --name=kafka-broker-confluent-ce \
    -h=broker \
    -p=9092:9092 \
    -v /data/kafka-confluent/broker/:/var/lib/kafka-broker/ \
    -v $(pwd):/root/dev \
    qpod/jdk-11 bash

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
