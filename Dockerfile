FROM ubuntu
MAINTAINER Manuel Castellin (castellin.manuel@gmail.com)


# input arguments required to access artifactory
ARG COMMERCE_SUITE_FILE
ARG RECIPE

COPY ${COMMERCE_SUITE_FILE} /tmp/hybris-commerce-suite.zip

# Installing prerequistes and collectd
RUN \
apt-get update && apt-get -y --no-install-recommends install \
    curl \
    unzip \
    lsof \
    openjdk-8-jre \
    collectd

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/

RUN unzip /tmp/hybris-commerce-suite.zip -d /opt/ \
  && rm /tmp/hybris-commerce-suite.zip \
  && /opt/installer/install.sh -r ${RECIPE}

# No need to expose if running behind reverse proxy
# EXPOSE 8009 8010 9001 9002

# Setting entrypoint
COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
