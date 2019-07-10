#!/bin/bash
set -e

if [ ! -d $PGDATA ]; then
    mkdir $PGDATA
fi
chown -R postgres "$PGDATA"

#if [ -z "$(ls -A "$PGDATA")" ]; then
#    gosu postgres initdb --locale=ru_RU.UTF-8 --lc-collate=ru_RU.UTF-8 --lc-ctype=ru_RU.UTF-8 --encoding=UTF8
#fi

if [ "$1" = 'postgres' ]; then
    gosu postgres initdb --locale=ru_RU.UTF-8 --lc-collate=ru_RU.UTF-8 --lc-ctype=ru_RU.UTF-8 --encoding=UTF8

    gosu postgres pg_ctl start -D /var/lib/postgresql/data -w

    # Fix encoding bug
    gosu postgres psql -c "UPDATE pg_database SET datallowconn = TRUE WHERE datname = 'template0' ;"
    gosu postgres psql -c "UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1' ;"
    gosu postgres psql -c "DROP DATABASE template1 ;"
    gosu postgres psql -c "CREATE DATABASE template1 WITH encoding = 'UTF-8' lc_collate = 'ru_RU.UTF8' lc_ctype = 'ru_RU.UTF8' template = template0 ;"
    gosu postgres psql -c "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1' ;"
    gosu postgres psql -c "UPDATE pg_database SET datallowconn = FALSE WHERE datname = 'template0' ;"

    #/etc/init.d/postgresql start
    #gosu postgres pg_ctl /var/lib/postgresql/data -m fast -w stop
    #gosu postgres initdb --locale=ru_RU.UTF-8 --lc-collate=ru_RU.UTF-8 --lc-ctype=ru_RU.UTF-8 --encoding=UTF8
    #gosu -V
    
    #gosu postgres pg_ctl start
    #/etc/init.d/postgresql start
    #service postgresql start
    #sudo -u postgres pg_ctl -D /var/lib/postgresql/data start
fi

#/etc/init.d/postgresql stop

exec "$@"