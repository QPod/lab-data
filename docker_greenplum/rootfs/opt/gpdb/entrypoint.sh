#!/bin/bash

function gp_init() {
  local GP_CONFIG_FILE_INIT="/opt/gpdb/conf/gpinitsystem.conf"

  export DATA_DIRECTORY="${GPDATA}/primary" &&
    mkdir -pv "${COORDINATOR_DIRECTORY}" "${DATA_DIRECTORY}" &&
    echo "Begin to init Greenplum using config file: ${GP_CONFIG_FILE_INIT}" &&
    gpinitsystem -a -c ${GP_CONFIG_FILE_INIT} &&
    echo "GreenplumDB has been successfully init and now started!" &&
    echo 'host  all  all  0.0.0.0/0  password' >>"${MASTER_DATA_DIRECTORY}/pg_hba.conf" &&
    gpconfig -c log_statement -v none &&
    gpconfig -c gp_enable_global_deadlock_detector -v on

  sleep 5s
}

sudo /usr/sbin/sshd -D && sleep 5s

if [ "$(ls -A ${GPDATA})" = "" ]; then
  gp_init && gpstop -u && tail -f gpAdminLogs/*.log
else
  gpstart -a && tail -f gpAdminLogs/*.log
fi
