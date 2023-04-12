source /opt/utils/script-utils.sh

setup_confluent_kafka() {
  # ref: https://docs.confluent.io/platform/current/installation/installing_cp/zip-tar.html#get-the-software
  local VER_C_KAFKA_MINOR=${KAFKA_VERSION:-"7.3.3"}
  local VER_C_KAFKA_MAJOR=${VER_C_KAFKA_MINOR%.*}
  local URL_C_KAFKA="http://packages.confluent.io/archive/${VER_C_KAFKA_MAJOR}/confluent-${VER_C_KAFKA_MINOR}.tar.gz"
  echo "Installing Confluent Kafka from: $URL_C_KAFKA}"
  install_tar_gz "${URL_C_KAFKA}"
  mv /opt/confluent-* /opt/kafka
  export KAFKA_HOME=/opt/kafka
  ls -alh ${KAFKA_HOME}/*
}

setup_confluent_kafka_kraft() {
  # ref: https://github.com/confluentinc/cp-all-in-one/blob/7.3.3-post/cp-all-in-one-kraft/update_run.sh
  # Docker workaround: Remove check for KAFKA_ZOOKEEPER_CONNECT parameter
  sed -i '/KAFKA_ZOOKEEPER_CONNECT/d' ${KAFKA_HOME}/etc/confluent/docker/configure
  # Docker workaround: Ignore cub zk-ready
  sed -i 's/cub zk-ready/echo ignore zk-ready/' ${KAFKA_HOME}/etc/confluent/docker/ensure
  # KRaft required step: Format the storage directory with a new cluster ID
  echo "kafka-storage format --ignore-formatted -t $(kafka-storage random-uuid) -c ${KAFKA_HOME}/etc/kafka/kafka.properties" >>${KAFKA_HOME}/etc/confluent/docker/ensure
}
