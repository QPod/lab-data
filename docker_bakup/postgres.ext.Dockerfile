ARG PG_MAJOR=11

FROM postgres:${PG_MAJOR} AS BUILDER

RUN apt-get update -y -qq --fix-missing \
 && apt-get -qq install -y --no-install-recommends \
	wget curl ca-certificates gnupg2 lsb-release build-essential \
	postgresql-server-dev-${PG_MAJOR} \
	libcurl4-openssl-dev libz-dev \
	libxml2-dev libgdal-dev

# Build and install ZomboDB extension
RUN cd /tmp \
 && wget -qO- https://github.com/zombodb/zombodb/archive/master.tar.gz -O /tmp/zombodb.tar.gz \
 && tar -xf zombodb.tar.gz \
 && cd zombodb-* \
 && make clean install \
 && rm -rf /tmp/zomdbo*

# Build and install PostGIS extension
RUN cd /tmp \
 && wget -qO- https://download.osgeo.org/postgis/source/postgis-3.0.0.tar.gz -O /tmp/postgis.tar.gz \
 && tar -xf ./postgis.tar.gz \
 && cd postgis-* \
 && make -j8 && make install \
 && rm -rf /tmp/postgis*

FROM postgres:${PG_MAJOR}

LABEL maintainer="haobibo@gmail.com"

COPY --from=BUILDER /usr/lib/postgresql/$PG_MAJOR/lib/zombodb.so /usr/lib/postgresql/$PG_MAJOR/lib/
COPY --from=BUILDER /usr/share/postgresql/$PG_MAJOR/extension/zombodb* /usr/share/postgresql/$PG_MAJOR/extension/

COPY --from=BUILDER /usr/lib/postgresql/$PG_MAJOR/lib/postgis*.so /usr/lib/postgresql/$PG_MAJOR/lib/
COPY --from=BUILDER /usr/share/postgresql/$PG_MAJOR/extension/postgis* /usr/share/postgresql/$PG_MAJOR/extension/


RUN apt-get update -y -qq --fix-missing \
 && apt-get -qq install -y --no-install-recommends \
      libcurl3 curl \
      libgeos-c1v5 libproj12 libjson-c3 \
 && apt-get clean && rm -rf /var/lib/apt/lists/*
