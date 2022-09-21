ARG BASE_NAMESPACE
ARG BASE_IMG="base"
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG} as builder

ARG ES_VERSION="7.11.2"


RUN source /opt/utils/script-utils.sh \
 && ES_SOURCECODE="https://github.com/elastic/elasticsearch/archive/v${ES_VERSION}.tar.gz" \
 && ES_ARTIFACT="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz" \
 && install_tar_gz ${ES_SOURCECODE} && mv /opt/elasticsearch-* /tmp/elasticsearch \
 && install_tar_gz ${ES_ARTIFACT}   && mv /opt/elasticsearch-* /opt/elasticsearch \
 && mv /opt/elasticsearch/jdk /opt/ \
 && ln -s /opt/jdk /opt/elasticsearch/ \
 && ln -s /opt/jdk/bin/* /usr/bin/ \
 && echo "@ Version of Java (java/javac):" && java -version && javac -version \
 && sed -i -e 's/ES_DISTRIBUTION_TYPE=tar/ES_DISTRIBUTION_TYPE=docker/' /opt/elasticsearch/bin/elasticsearch-env \
 && mkdir -pv config/jvm.options.d

RUN set -ex \
 && mkdir -pv /tmp/build/src    && cd /tmp/build \
 && ln -s  /opt/elasticsearch/lib     /tmp/build/ \
 && ln -s  /opt/elasticsearch/modules /tmp/build/ \
 && find   /tmp/elasticsearch -name "License.java" | xargs -r -I {} cp {} . \
 && sed -i 's#this.type = type;#this.type = "platinum";#g' License.java \
 && sed -i 's#validate();#// validate();#g' License.java \
 && javac -cp "`ls lib/elasticsearch-${ES_VERSION}.jar`:`ls lib/elasticsearch-x-content-*.jar`:`ls lib/lucene-core-*.jar`:`ls modules/x-pack-core/x-pack-core-*.jar`" License.java \
 && cd /tmp/build/src \
 && find /opt/elasticsearch/ -name "x-pack-core-*.jar" | xargs -r -I {} cp {} . \
 && jar xf x-pack-core-${ES_VERSION}.jar \
 && cp -f ../License*.class org/elasticsearch/license/ \
 && jar cf x-pack-core-${ES_VERSION}.jar . \
 && cp -r /tmp/build/src/x-pack-core-*.jar /opt/elasticsearch/modules/x-pack-core/ \
 && rm -rf /tmp/*

COPY --chown=1000:0                 docker-entrypoint.sh    /opt/elasticsearch/docker-entrypoint.sh
COPY --chown=1000:0                 elasticsearch.yml       /opt/elasticsearch/config/
COPY --chown=1000:0                 log4j2.properties       /opt/elasticsearch/config/

# Second build stage
FROM ${BASE_NAMESPACE:+$BASE_NAMESPACE/}${BASE_IMG}

LABEL maintainer="haobibo@gmail.com"

COPY --from=builder                 /opt/jdk                /opt/jdk
COPY --from=builder --chown=1000:0  /opt/elasticsearch      /opt/elasticsearch

RUN source /opt/utils/script-setup.sh \
 && setup_tini \
 && ln -s /opt/jdk/bin/*     /usr/bin/ \
 && ln -s /opt/elasticsearch /usr/share/ \
 && groupadd --gid 1000 elasticsearch \
 && adduser --system -q --uid 1000 --gid 1000 --gid 0 --home /opt/elasticsearch elasticsearch \
 && chmod -R 0775 /opt/elasticsearch    && chgrp 0 /opt/elasticsearch \
 && chmod g=u /etc/passwd \
 && find / -xdev -perm -4000 -exec chmod ug-s {} + \
 && mkdir -p /data/elasticsearch/ && cd /data/elasticsearch && mkdir data logs \
 && cd /opt/elasticsearch && rm -rf ./data ./logs ./plugins && ln -s /data/elasticsearch/* ./ \
 && echo "elastic" | bin/elasticsearch-keystore add -xf bootstrap.password \
 && echo "" | bin/elasticsearch-certutil ca   -s --out elastic-stack-ca.p12 --pass \
 && echo "" | bin/elasticsearch-certutil cert -s --ca elastic-stack-ca.p12 --ca-pass "" --out elastic-certificates.p12 --pass \
 && mv elastic-*.p12 config/ && chown 1000:0 config/elastic-*.p12 config/elasticsearch.keystore \
 && echo "vm.swappiness=0"          >> /etc/sysctl.conf \
 && echo "vm.max_map_count=655360 " >> /etc/sysctl.conf \
 && echo "* soft memlock unlimited" >> /etc/security/limits.conf \
 && echo "* hard memlock unlimited" >> /etc/security/limits.conf

USER elasticsearch
EXPOSE 9200 9300
WORKDIR /opt/elasticsearch
VOLUME /data/elasticsearch

ENTRYPOINT ["tini", "--", "/opt/elasticsearch/docker-entrypoint.sh"]

CMD ["eswrapper"]
