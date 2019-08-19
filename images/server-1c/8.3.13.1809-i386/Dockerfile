FROM i386/ubuntu:16.04

LABEL maintainer "Andrey Mishchenko <info@msav.ru>"

ARG DEBIAN_FRONTEND=noninteractive

ENV APP_1C_TIMEZONE="Europe/Moscow"

ENV LANG="ru_RU.utf8"

ENV APP_1C_PLATFORM_VERSION="8.3" \
    APP_1C_PLATFORM="83" \
    APP_1C_ARCH="i386"

ENV APP_1C_SERVER_VERSION="${APP_1C_PLATFORM_VERSION}.13.1809" \
    APP_1C_PKG_DIST="./dist" \
    APP_1C_PKG_DEST="/tmp/dist"

RUN apt-get update -y \
    && `# --------------- Install common packages --------------- ` \
    && apt-get -y --no-install-recommends install \
        apt-utils \
        apt-transport-https \
        ca-certificates \
        wget \
        rename \
        gosu

RUN `# --------------- Configure server locale --------------- ` \
    apt-get -y --no-install-recommends install \
        locales \
        tzdata \
    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 \
    && ln -snf /usr/share/zoneinfo/${APP_1C_TIMEZONE} /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

RUN `# --------------- Install dependencies --------------- ` \
    && apt-get -y --no-install-recommends install \
        fontconfig \
        imagemagick \
    && `# --------------- Install mscorefonts --------------- ` \
    && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
    && apt-get -y --no-install-recommends install \
        xfonts-utils \
        cabextract \
        ttf-mscorefonts-installer \
    && `# --------------- Install optional packages --------------- ` \
    && apt-get -y --no-install-recommends install \
        net-tools \
        lsof \
        git \
        nano \
        mc

RUN mkdir ${APP_1C_PKG_DEST}
ADD ${APP_1C_PKG_DIST}/*.gz ${APP_1C_PKG_DEST}
RUN find ${APP_1C_PKG_DEST}/*.deb -type f -exec rename -v 'y/[_\-]/\./' {} \;

RUN dpkg --install ${APP_1C_PKG_DEST}/1c.enterprise${APP_1C_PLATFORM}.common.${APP_1C_SERVER_VERSION}.${APP_1C_ARCH}.deb \
    && dpkg --install ${APP_1C_PKG_DEST}/1c.enterprise${APP_1C_PLATFORM}.server.${APP_1C_SERVER_VERSION}.${APP_1C_ARCH}.deb \
    && mkdir --parent /var/log/1C /home/usr1cv8/.1cv8/1C/1cv8/conf \
    && chown --recursive usr1cv8:grp1cv8 /var/log/1C /home/usr1cv8

COPY ./init/docker-entrypoint.sh /
RUN chmod 775 /docker-entrypoint.sh
COPY ./init/logcfg.xml /home/usr1cv8/.1cv8/1C/1cv8/conf

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME /home/usr1cv8
VOLUME /var/log/1C
VOLUME /opt/1C

EXPOSE 1540-1541 1560-1591

CMD ["ragent"]
