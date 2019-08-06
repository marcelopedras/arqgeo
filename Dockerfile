FROM maven:3.6.1-jdk-8-alpine as cache
COPY ./dspace/app/dspace-6.3-src-release /usr/src/dspace
WORKDIR /usr/src/dspace
RUN mvn dependency:resolve




FROM debian:9

ENV DEBIAN_FRONTEND=noninteractive

ENV CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/dspace
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/
ENV PATH=$CATALINA_HOME/bin:$DSPACE_HOME/bin:$PATH
ENV TOMCAT_TGZ_URL=https://www.apache.org/dist/tomcat/tomcat-9/v9.0.22/bin/apache-tomcat-9.0.22.tar.gz


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
    && mkdir -p "$CATALINA_HOME" \
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
ADD ./dspace/app/dspace-6.3-src-release dspace

# Add .m2 cache to project
COPY --from=cache /root/.m2 /root/.m2

RUN cd dspace && mvn clean package -P '!dspace-lni,!dspace-oai,!dspace-sword,!dspace-swordv2,!dspace-xmlui'
#RUN cd dspace && mvn package -P '!dspace-lni,!dspace-oai,!dspace-sword,!dspace-swordv2,!dspace-xmlui'
RUN cd dspace/dspace/target/dspace-installer \
    && ant init_installation init_configs install_code copy_webapps
RUN rm -fr "$CATALINA_HOME/webapps" && mv -f /dspace/webapps "$CATALINA_HOME" \
    && sed -i s/CONFIDENTIAL/NONE/ /usr/local/tomcat/webapps/rest/WEB-INF/web.xml

RUN rm -rf /usr/local/tomcat/webapps/oai \
    && rm -rf /usr/local/tomcat/webapps/sword \
    && rm -rf /usr/local/tomcat/webapps/swordv2 \
    && rm -rf /usr/local/tomcat/webapps/xmlui


# Install root filesystem
ADD ./dspace/rootfs /
COPY ./dspace/config/local.cfg /dspace/config
COPY ./dspace/config/noticias-topo.html /dspace/config/noticias-topo.html
COPY ./dspace/config/noticias-lado.html /dspace/config/noticias-lado.html

WORKDIR /dspace

EXPOSE 8080

CMD ["start-dspace"]
