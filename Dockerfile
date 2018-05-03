FROM ubuntu:16.04
MAINTAINER Manuel Castellin (manuel@castellinconsulting.com)

# input arguments
ARG COMMERCE_SUITE_FILE
ARG RECIPE

# Installing prerequisites
RUN \
apt-get update && apt-get -y --no-install-recommends install \
    curl \
    unzip \
    lsof \
    openjdk-8-jre

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/

# create user in container so we can ultimately run hybris as non-root user
#RUN groupadd -g 999 hybrisuser && \
#    useradd -r -u 999 -g hybrisuser hybrisuser
#USER hybrisuser

RUN mkdir /home/hybrisuser && \
groupadd -r hybrisuser -g 999 && \
useradd -u 999 -r -g hybrisuser -d /home/hybrisuser -s /sbin/nologin -c "Docker image user" hybrisuser && \
chown -R hybrisuser:hybrisuser /home/hybrisuser && \
chown -R hybrisuser:hybrisuser /opt 
USER hybrisuser

COPY --chown=hybrisuser:hybrisuser ${COMMERCE_SUITE_FILE} /tmp/hybris-commerce-suite.zip

RUN unzip /tmp/hybris-commerce-suite.zip -d /opt/ \
  && rm /tmp/hybris-commerce-suite.zip \
  && /opt/installer/install.sh -r ${RECIPE}

# Setting entrypoint
COPY --chown=hybrisuser:hybrisuser entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
