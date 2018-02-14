#!/bin/bash

WALE_BIN=${WALE_BIN:-/usr/local/bin/wal-e}
PGHOST=${PGHOST:-timescaledb}
PGUSER=${PGUSER:-postgres}

set +e
while true; do
    sleep 1
    echo "Waiting for postgres."
    pg_isready -h $PGHOST

    if [[ $? == 0 ]] ; then
        break
    fi

done
set -e

$WALE_BIN $WALE_BASE_BACKUP_FLAGS backup-push $PGDATA
