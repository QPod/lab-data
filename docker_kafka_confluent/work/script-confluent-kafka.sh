source /opt/utils/script-utils.sh

setup_confluent_kafka() {
  export KAFKA_HOME=/opt/kafka

  local VER_C_KAFKA_MINOR=${KAFKA_VERSION:-"7.3.3"}
  local VER_C_KAFKA_MAJOR=${VER_C_KAFKA_MINOR%.*}
  local URL_C_KAFKA="http://packages.confluent.io/archive/${VER_C_KAFKA_MAJOR}/confluent-community-${VER_C_KAFKA_MINOR}.tar.gz"

  # Downlaod CKafka package and unzip to /opt/kafka
  # ref: https://docs.confluent.io/platform/current/installation/installing_cp/zip-tar.html#get-the-software
  install_tar_gz "${URL_C_KAFKA}" && mv /opt/confluent-* ${KAFKA_HOME} \
 && echo "Setting up kafka dirs:" && mkdir -pv /var/lib/kafka/data /etc/kafka/secrets \
 && ln -sf ${KAFKA_HOME}/etc /etc/confluent \
 && ls -alh ${KAFKA_HOME}/*

  # CKafka docker images requires confluent docker utils for dub/cub command
  pip install -U confluent-kafka https://github.com/confluentinc/confluent-docker-utils/archive/refs/heads/master.zip \
 && install_zip https://github.com/confluentinc/confluent-docker-utils/archive/refs/heads/master.zip \
 && PYTHON_SITE=$(python3 -c 'import sys;print(list(filter(lambda s: "site" in s, sys.path))[0])') \
 && cp -rf /opt/confluent-*/confluent ${PYTHON_SITE} \
 && rm -rf /opt/confluent-*

  install_zip https://github.com/confluentinc/common-docker/archive/refs/heads/master.zip \
 && mv /opt/common-docker-master ${KAFKA_HOME}/common-docker \
 && mkdir -pv ${KAFKA_HOME}/etc/docker/ \
 && cp -rf ${KAFKA_HOME}/common-docker/base/include/etc/confluent/docker/* ${KAFKA_HOME}/etc/docker/

  # CKafka base docker images are built with some scripts included
  install_zip https://github.com/confluentinc/kafka-images/archive/refs/heads/master.zip
  mv /opt/kafka-images* ${KAFKA_HOME}/kafka-images
  cp -rf "${KAFKA_HOME}/kafka-images/kafka/include/etc/confluent/docker/"  "${KAFKA_HOME}/etc/"
}

setup_confluent_kafka_kraft() {
  # ref: https://github.com/confluentinc/cp-all-in-one/blob/7.3.3-post/cp-all-in-one-kraft/update_run.sh
  # Docker workaround 1: Remove check for KAFKA_ZOOKEEPER_CONNECT parameter
  # Docker workaround 2: Ignore cub zk-ready
  sed -i '/KAFKA_ZOOKEEPER_CONNECT/d' /etc/confluent/docker/configure
  sed -i 's/cub zk-ready/echo ignore zk-ready/' /etc/confluent/docker/ensure

  # KRaft required step: Format the storage directory with a new cluster ID
cat >>/etc/confluent/docker/configure <<EOF
kafka-storage format --ignore-formatted -t "\${CLUSTER_ID}" -c /etc/kafka/kafka.properties
EOF
}
