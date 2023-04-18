#!/bin/bash

/var/run/sshd/sshd_start.sh && sleep 5s

if [ "`ls -A $GPDB_DATA`" = "" ]; then
    export COORDINATOR_DIRECTORY=$GPDB_DATA/coordinator

    gpinitsystem -a --ignore-warnings -c /home/gpadmin/gpinitsystem_config_singlenode -h /home/gpadmin/gp_hosts_list
    psql -d postgres -U gpadmin -f /home/gpadmin/initdb_gpdb.sql
    gpconfig -c log_statement -v none
    gpconfig -c gp_enable_global_deadlock_detector -v on
    echo 'host  all  all  0.0.0.0/0  password' >> ${COORDINATOR_DIRECTORY}/gpseg-1/pg_hba.conf
    sleep 5s && gpstop -u && tail -f gpAdminLogs/*.log
else
    gpstart -a && tail -f gpAdminLogs/*.log
fi
