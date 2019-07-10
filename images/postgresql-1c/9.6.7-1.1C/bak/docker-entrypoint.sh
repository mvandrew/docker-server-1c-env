#!/bin/bash
set -e

if [ ! -d $PGDATA ]; then
    mkdir $PGDATA
fi
chown -R postgres "$PGDATA"

if [ -z "$(ls -A "$PGDATA")" ]; then
    #gosu postgres initdb --locale=ru_RU.UTF-8 --lc-collate=ru_RU.UTF-8 --lc-ctype=ru_RU.UTF-8 --encoding=UTF8

    #sed -ri /local\\s+all\\s+postgres\\s+/s/peer/trust/ /etc/postgresql/9.6/main/pg_hba.conf
    # { echo; echo "host all all all md5"; } | tee -a /etc/postgresql/9.6/main/pg_hba.conf > /dev/null
    #/etc/init.d/postgresql restart

    # Fix encoding bug
    gosu postgres psql -c "UPDATE pg_database SET datallowconn = TRUE WHERE datname = 'template0' ;"
    gosu postgres psql -c "UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1' ;"
    gosu postgres psql -c "DROP DATABASE template1 ;"
    gosu postgres psql -c "CREATE DATABASE template1 WITH encoding = 'UTF-8' lc_collate = 'ru_RU.UTF8' lc_ctype = 'ru_RU.UTF8' template = template0 ;"
    gosu postgres psql -c "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1' ;"
    gosu postgres psql -c "UPDATE pg_database SET datallowconn = FALSE WHERE datname = 'template0' ;"

    # Init values
    : ${PGSQL_USER:=postgres}
    : ${PGSQL_DB:="${PGSQL_USER}_db"}

    # Check password
    if [ "$PGSQL_PASSWORD" ]; then
        PASS="PASSWORD '$PGSQL_PASSWORD'"
    else
        PASS="PASSWORD '$PGSQL_USER'"
    fi

    #Create database
    gosu postgres psql -c "CREATE DATABASE $PGSQL_DB ;"

    # Set password
    if [ $PGSQL_USER = 'postgres' ]; then
        MOD='ALTER'
    else
        MOD='CREATE'
    fi

    gosu postgres psql -c "$MOD USER $PGSQL_USER WITH SUPERUSER $PASS ;"
    
fi

exec "$@"
