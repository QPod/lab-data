#!/bin/bash
set -Eeo pipefail

printenv | sort

ls -alh /usr/share/postgresql/${PG_MAJOR}/extension/*.control

mkdir -pv ${PGDATA}/conf.d
echo "include_dir='./conf.d'" >> ${PGDATA}/postgresql.conf
sudo mv /opt/utils/pg-ext.conf ${PGDATA}/conf.d/

cat ${PGDATA}/conf.d/*
tail ${PGDATA}/postgresql.conf


# https://github.com/docker-library/postgres/blob/master/docker-entrypoint.sh
# form: docker-entrypoint.sh
docker_temp_server_stop
docker_temp_server_start

psql -v ON_ERROR_STOP=0 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CALL enable_all_extensions();
    SELECT extname AS name, extversion AS ver FROM pg_extension ORDER BY extname;
EOSQL
