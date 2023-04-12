source /opt/utils/script-utils.sh

setup_confluent_kafka() {
  # ref: https://docs.confluent.io/platform/current/installation/installing_cp/zip-tar.html#get-the-software
  local VER_C_KAFKA_MINOR=${KAFKA_VERSION:-"7.3.3"}
  local VER_C_KAFKA_MAJOR=${VER_C_KAFKA_MINOR%.*}
  local URL_C_KAFKA="http://packages.confluent.io/archive/${VER_C_KAFKA_MAJOR}/confluent-${VER_C_KAFKA_MINOR}.tar.gz"
  echo "Installing Confluent Kafka from: $URL_C_KAFKA}"
  install_tar_gz "${URL_C_KAFKA}"
  install_zip https://github.com/confluentinc/kafka-images/archive/refs/heads/master.zip

  export KAFKA_HOME=/opt/kafka
  mv /opt/confluent-* /opt/kafka
  mv /opt/kafka-images* ${KAFKA_HOME}/docker
  mv "${KAFKA_HOME}/docker/kafka/include/etc/confluent/docker/"  "${KAFKA_HOME}/etc/"
  ln -sf ${KAFKA_HOME}/etc /etc/confluent
  ls -alh ${KAFKA_HOME}/*

  echo "Setting up kafka dirs:" && mkdir -pv /var/lib/kafka/data /etc/kafka/secrets
}

setup_confluent_kafka_kraft() {
  # ref: https://github.com/confluentinc/cp-all-in-one/blob/7.3.3-post/cp-all-in-one-kraft/update_run.sh
  # Docker workaround: Remove check for KAFKA_ZOOKEEPER_CONNECT parameter
  sed -i '/KAFKA_ZOOKEEPER_CONNECT/d' /etc/confluent/docker/configure
  # Docker workaround: Ignore cub zk-ready
  sed -i 's/cub zk-ready/echo ignore zk-ready/' /etc/confluent/docker/ensure
  # KRaft required step: Format the storage directory with a new cluster ID
  echo "kafka-storage format --ignore-formatted -t $(kafka-storage random-uuid) -c /etc/kafka/kafka.properties" >> /etc/confluent/docker/ensure
}
