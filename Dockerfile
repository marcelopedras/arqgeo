FROM maven:3.6.1-jdk-8-alpine as cache
COPY ./dspace/app/dspace6 /usr/src/dspace
WORKDIR /usr/src/dspace
RUN mvn -nsu dependency:resolve -P '!dspace-lni,!dspace-oai,!dspace-sword,!dspace-swordv2,!dspace-xmlui'


FROM debian:9

ENV DEBIAN_FRONTEND=noninteractive

ENV CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/dspace
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/
ENV PATH=$CATALINA_HOME/bin:$DSPACE_HOME/bin:$PATH
#ENV TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-9/v$TOMCAT_VER/bin/apache-tomcat-$TOMCAT_VER.tar.gz


WORKDIR /tmp

RUN apt update && apt upgrade -y \
    && apt install -y \
        apt-utils \
        openjdk-8-jdk \
        maven \
        ant \
        postgresql-client \
        locales-all \
        locales \
        bzip2 \
        curl \
        git \
        nano \
        imagemagick \
        ghostscript \
        cron \
    && mkdir -p "$CATALINA_HOME" \
    && TOMCAT_VER=`curl --silent https://downloads.apache.org/tomcat/tomcat-9/ | grep v9 | awk '{split($5,c,">v") ; split(c[2],d,"/") ; print d[1]}'` \
    && TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-9/v$TOMCAT_VER/bin/apache-tomcat-$TOMCAT_VER.tar.gz \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && tar -xf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" \
    && rm -rf tomcat.tar.gz \
    && apt clean && rm -rf /var/lib/apt/lists/*

#    Config timezone and locale
RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && update-locale LANG=pt_BR.UTF-8 \
    && echo "pt_BR pt_BR.UTF-8" >> /etc/locale.alias

ENV LANG='pt_BR.UTF-8' LANGUAGE='pt_BR:pt:en' LC_ALL='pt_BR.UTF-8'


# Dspace configs

# Create Dspace user and adding to the sudoers group
RUN useradd -ms /bin/bash dspace \
    && usermod -a -G root dspace

# Some configs for 6.0
COPY ./dspace/config/setenv.sh "$CATALINA_HOME"/bin
COPY ./dspace/config/server.xml "$CATALINA_HOME"/conf

# Copy source to /tmp/dspace
ADD ./dspace/app/dspace6 dspace

# Add local configs before build
COPY ./dspace/config/local.cfg dspace/dspace/config/
COPY ./dspace/config/noticias-topo.html dspace/dspace/config/
COPY ./dspace/config/noticias-lado.html dspace/dspace/config/

# Add .m2 cache to project
COPY --from=cache /root/.m2 /root/.m2

RUN cd dspace && mvn -nsu clean package -P '!dspace-lni,!dspace-oai,!dspace-sword,!dspace-swordv2,!dspace-xmlui' \
#RUN cd dspace && mvn package -P '!dspace-lni,!dspace-oai,!dspace-sword,!dspace-swordv2,!dspace-xmlui'
    && cd dspace/target/dspace-installer \
    && ant init_installation init_configs install_code copy_webapps \
    && rm -fr "$CATALINA_HOME/webapps" && mv -f /dspace/webapps "$CATALINA_HOME" \
    && sed -i s/CONFIDENTIAL/NONE/ /usr/local/tomcat/webapps/rest/WEB-INF/web.xml \
    # Cleanup
    && rm -rf /usr/local/tomcat/webapps/oai \
    && rm -rf /usr/local/tomcat/webapps/sword \
    && rm -rf /usr/local/tomcat/webapps/swordv2 \
    && rm -rf /usr/local/tomcat/webapps/xmlui \
    && rm -rf /root/.m2 \
    && rm -rf /tmp/dspace \
    && apt clean && rm -rf /var/lib/apt/lists/*


# Install root filesystem
ADD ./dspace/rootfs /
COPY ./dspace/config/local.cfg /dspace/config
COPY ./dspace/config/noticias-topo.html /dspace/config/noticias-topo.html
COPY ./dspace/config/noticias-lado.html /dspace/config/noticias-lado.html

# Add cron task file
COPY ./dspace/cron_tasks/dspace_tasks.cron /dspace/dspace_tasks.cron
RUN chmod +x /dspace/dspace_tasks.cron && crontab /dspace/dspace_tasks.cron && touch /var/log/cronlog

RUN chmod u+x -R /dspace/bin/

#VOLUME $DSPACE_HOME/assetstore

WORKDIR /dspace

EXPOSE 80

CMD ["start-dspace.bash"]