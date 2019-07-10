# vim:set ft=dockerfile:
FROM ubuntu:xenial

LABEL maintainer "Andrey Mishchenko <info@msav.ru>"

ARG DEBIAN_FRONTEND=noninteractive

ENV PG_TIMEZONE="Europe/Moscow"

# Make the "ru_RU.UTF-8" locale so postgres will be utf-8 enabled by default.
# Ubuntu doesn't require explicit locale-file generation.
ENV LANG="ru_RU.utf8"

ENV PG_MAJOR="9.6" 
ENV PG_VERSION="${PG_MAJOR}.7-1" \
    PG_DIST="./dist" \
    PG_DEST="/tmp/pgsql" \
    PG_USER="postgres" \
	PGDATA="/var/lib/postgresql/data"

RUN apt-get update -y \
    && `# --------------- Install common packages --------------- ` \
    && apt-get -y --no-install-recommends install \
        bzip2 \
        wget \
        gnupg2 \
        rename \
        gosu \
    && `# --------------- Configure server locale --------------- ` \
    && apt-get -y --no-install-recommends install \
        locales \
        tzdata \
    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 \
    && ln -snf /usr/share/zoneinfo/${PG_TIMEZONE} /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && `# --------------- Install optional packages --------------- ` \
    && apt-get -y --no-install-recommends install \
        net-tools \
        lsof \
        git \
        nano \
        mc

RUN mkdir ${PG_DEST}
COPY ${PG_DIST} ${PG_DEST}
RUN find ${PG_DEST} -type f -exec rename -v 'y/_/\-/' {} \;

RUN cd ${PG_DEST} \
    && tar -xvjf postgresql-${PG_VERSION}.1C-amd64-deb.tar.bz2 \
    && rm postgresql-${PG_VERSION}.1C-amd64-deb.tar.bz2 \
    && find ${PG_DEST} -type f -iname '*.deb' -exec mv {} ${PG_DEST} \; \
    && find ${PG_DEST} -type f -iname '*.deb' -exec rename -v 'y/_/\-/' {} \; \
    && apt-get -y --no-install-recommends install \
        libgssapi-krb5-2 \
        libldap-2.4-2 \
        postgresql-client-common \
        libedit2 \
        ssl-cert \
        tzdata \
        libxml2 \
        postgresql-common \
    && dpkg -i libpq5-${PG_VERSION}.1C-amd64.deb \
    && dpkg -i postgresql-client-9.6-${PG_VERSION}.1C-amd64.deb \
    && dpkg -i postgresql-9.6-${PG_VERSION}.1C-amd64.deb \
	&& systemctl disable postgresql

# Change default PostgreSQL configuration
RUN sed -ri s/^shared_preload_libraries/#shared_preload_libraries/ /etc/postgresql/9.6/main/postgresql.conf \
	&& sed -ri /local\\s+all\\s+postgres\\s+/s/peer/trust/ /etc/postgresql/9.6/main/pg_hba.conf \
    && { echo; echo "host all all all md5"; } | tee -a /etc/postgresql/9.6/main/pg_hba.conf > /dev/null

ENV PATH /usr/lib/postgresql/${PG_MAJOR}/bin:$PATH

COPY ./docker-entrypoint.sh /
RUN chmod 775 /docker-entrypoint.sh

EXPOSE 5432

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "postgres" ]
