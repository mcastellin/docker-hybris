FROM ubuntu:16.04
MAINTAINER Manuel Castellin (manuel@castellinconsulting.com)

# input arguments
ARG COMMERCE_SUITE_FILE
ARG RECIPE

COPY ${COMMERCE_SUITE_FILE} /tmp/hybris-commerce-suite.zip

# Installing prerequisites
RUN \
apt-get update && apt-get -y --no-install-recommends install \
    curl \
    unzip \
    lsof \
    openjdk-8-jre

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/

RUN unzip /tmp/hybris-commerce-suite.zip -d /opt/ \
  && rm /tmp/hybris-commerce-suite.zip \
  && /opt/installer/install.sh -r ${RECIPE}

# Setting entrypoint
COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
