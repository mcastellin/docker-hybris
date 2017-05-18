FROM ubuntu
MAINTAINER Manuel Castellin (castellin.manuel@gmail.com)


# input arguments required to access artifactory
ARG COMMERCE_SUITE_FILE
ARG RECIPE

COPY ${COMMERCE_SUITE_FILE} /tmp/hybris-commerce-suite.zip

RUN \
apt-get update && apt-get -y --no-install-recommends install \
    curl \
    unzip \
    lsof \
    openjdk-8-jre

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/

RUN unzip /tmp/hybris-commerce-suite.zip -d /opt/
RUN rm /tmp/hybris-commerce-suite.zip

# install hybris recipe
RUN /opt/installer/install.sh -r ${RECIPE}

EXPOSE 8009 8010 9001 9002

# Installing collectd
RUN apt-get -y --no-install-recommends install collectd

# Setting entrypoint
COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
