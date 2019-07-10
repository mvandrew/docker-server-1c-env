#!/bin/bash
set -e

PG_BIN=/usr/lib/postgresql/${PG_MAJOR}/bin/postgres
PG_PWD=/var/lib/postgresql/passwd

if [ ! -d $PGDATA ]; then
    mkdir $PGDATA
fi
chown -R postgres "$PGDATA"

if [ -z "$(ls -A "$PGDATA")" ]; then
	echo "postgres" > $PG_PWD

	gosu postgres initdb \
		--locale=ru_RU.UTF-8 \
		--lc-collate=ru_RU.UTF-8 \
		--lc-ctype=ru_RU.UTF-8 \
		--encoding=UTF8 \
		--auth=trust \
		--pwfile=$PG_PWD
	
	sed -ri s/^shared_preload_libraries/\#shared_preload_libraries/ "${PGDATA}/postgresql.conf"
	{ echo; echo "host all all all md5"; } | tee -a /etc/postgresql/9.6/main/pg_hba.conf > /dev/null

#	gosu postgres $PG_BIN -D "$PGDATA" -c config_file=/etc/postgresql/9.6/main/postgresql.conf
fi


if [ "$1" = 'postgres' ]; then
	gosu postgres $PG_BIN -D "$PGDATA"
else
	gosu postgres pg_ctl -D "$PGDATA" start	
fi

exec "$@"
