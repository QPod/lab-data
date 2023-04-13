## debug

```bash
docker run -it  --name=tmp-ckafka  -v $(pwd):/tmp/dev -h=broker  qpod/jdk11 bash

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
export CLUSTER_ID="${CLUSTER_ID:-$(kafka-storage random-uuid)}"
/etc/confluent/docker/run > /tmp/kafka.log
```

## Standalone mode
Reference: https://github.com/bitnami/containers/tree/main/bitnami/kafka#kafka-without-zookeeper-kraft

If the following error occurs when starting in Kraft mode, try to set this environment variable: `export KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1`:

```log
ERROR [ClusterLinkMetadataManager-broker-1] Cluster link metadata topic creation failed: org.apache.kafka.common.errors.InvalidReplicationFactorException: Unable to replicate the partition 3 time(s): The target replication factor of 3 cannot be reached because only 1 broker(s) are registered. (kafka.serverlinkClusterLinkMetadataManagerWithKRaftSupport)
```