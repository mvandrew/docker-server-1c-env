FROM ubuntu:xenial

LABEL maintainer "Andrey Mishchenko <info@msav.ru>"

ARG DEBIAN_FRONTEND=noninteractive

ENV APP_1C_TIMEZONE="Europe/Moscow"

RUN apt-get update -y \
    && `# --------------- Install common packages --------------- ` \
    && apt-get -y --no-install-recommends install \
        bzip2 \
        wget \
        gnupg2 \
        rename \
        gosu \
    && `# --------------- Configure server locale --------------- ` \
    apt-get -y --no-install-recommends install \
        locales \
        tzdata \
    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 \
    && ln -snf /usr/share/zoneinfo/${APP_1C_TIMEZONE} /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && `# --------------- Install optional packages --------------- ` \
    && apt-get -y --no-install-recommends install \
        net-tools \
        lsof \
        git \
        nano \
        mc

ENV LANG="ru_RU.utf8"
