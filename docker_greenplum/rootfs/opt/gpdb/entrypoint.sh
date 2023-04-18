#!/bin/bash

function gp_init() {
  export COORDINATOR_DIRECTORY="${GPDATA}/coordinator"
  export DATA_DIRECTORY="${GPDATA}/primary"
  mkdir -pv "${COORDINATOR_DIRECTORY}" "${DATA_DIRECTORY}"

  gpinitsystem -a -c /opt/gpdb/conf/gpinitsystem.conf \
  && echo "GPDB has successfully init and now started!"

  export USER=$(whoami) \
  && export COORDINATOR_DATA_DIRECTORY="${COORDINATOR_DIRECTORY}/gpseg-1" \
  && echo 'host  all  all  0.0.0.0/0  password' >> "${COORDINATOR_DATA_DIRECTORY}/pg_hba.conf" \
  && gpconfig -c log_statement -v none \
  && gpconfig -c gp_enable_global_deadlock_detector -v on

  sleep 5s
}

sudo /usr/sbin/sshd -D && sleep 5s

if [ "$(ls -A ${GPDATA})" = "" ]; then
  gp_init && gpstop -u && tail -f gpAdminLogs/*.log
else
  gpstart -a && tail -f gpAdminLogs/*.log
fi
