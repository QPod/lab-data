# Start a Standalone mode single-node Kafka cluster in Kraft mode (using bitnami docker image)

Reference: https://github.com/bitnami/containers/tree/main/bitnami/kafka#kafka-without-zookeeper-kraft

Notice: the `localhost` in the `KAFKA_CFG_ADVERTISED_LISTENERS` needed to be changed to your host's external IP/hostname.

```bash
KAFKA_DATA_DIR="/data/kafka-bitnami/broker" && mkdir -pv $KAFKA_DATA_DIR && chmod -R ugo+rws $KAFKA_DATA_DIR
docker-compose up -d
```

## Debug and Development

```bash
docker run -it --rm \
    -e ALLOW_PLAINTEXT_LISTENER='yes' \
    -e KAFKA_BROKER_ID=1 \
    -e KAFKA_ENABLE_KRAFT='yes' \
    -e KAFKA_KRAFT_CLUSTER_ID='k4hJjYlsRYSk9UQcZjN0rA' \
    -e KAFKA_CFG_PROCESS_ROLES='broker,controller' \
    -e KAFKA_CFG_CONTROLLER_QUORUM_VOTERS='1@127.0.0.1:9093' \
    -e KAFKA_CFG_CONTROLLER_LISTENER_NAMES='CONTROLLER' \
    -e KAFKA_CFG_INTER_BROKER_LISTENER_NAME='PLAINTEXT' \
    -e KAFKA_CFG_LISTENERS='CONTROLLER://:9093,PLAINTEXT://:9092' \
    -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP='CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT' \
    -e KAFKA_CFG_ADVERTISED_LISTENERS='PLAINTEXT://localhost:9092' \
    --name kafka-broker \
    -h broker \
    -p 9092:9092 \
    -v /data/kafka-bitnami/broker:/bitnami \
    -u root \
docker.io/bitnami/kafka:latest bash

apt update && apt install vim

vim /opt/bitnami/scripts/kafka/setup.sh

bash /opt/bitnami/scripts/kafka/setup.sh

bash /opt/bitnami/scripts/kafka/entrypoint.sh /opt/bitnami/scripts/kafka/run.sh
```
