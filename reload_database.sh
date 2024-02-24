#!/bin/bash

DUMP_FILE=$1

### Wait for postgres to be ready ###
timeout_limit=30
timeout_counter=0
until pg_isready -h ${PGHOST} -p ${PGPORT}
do
    timeout_counter=$((timeout_counter+1))
    echo "Waiting for Postgres: ${timeout_counter}/${timeout_limit}"
    if [ ${timeout_counter} -ge ${timeout_limit} ]
    then
        echo "initialize_database script timed out waiting for postgres"
        exit 1
    fi
    sleep 5s
done
echo "Postgres has started"

### Initialize database ###
set -e
psql -h ${PGHOST} -p ${PGPORT} -U postgres -d postgres -c "DROP DATABASE IF EXISTS warehouse"
psql -h ${PGHOST} -p ${PGPORT} -U postgres -d postgres -c "CREATE DATABASE warehouse"
psql -h ${PGHOST} -p ${PGPORT} -U postgres -d warehouse -f ${DUMP_FILE}