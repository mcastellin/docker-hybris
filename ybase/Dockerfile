FROM openjdk:11-jdk-slim
LABEL maintainer="manuel@castellinconsulting.com"

ARG USERID="999"
ARG GROUPID="999"

RUN mkdir /home/hybris && \
  groupadd -r hybris -g ${GROUPID} && \
  useradd -u ${USERID} -g hybris -d /home/hybris -s /sbin/nologin -c "Hybris user" hybris && \
  chown -R hybris:hybris /home/hybris

COPY --chown=hybris:hybris target/ /opt/
RUN bash /opt/setup-bin/install.sh

USER hybris

WORKDIR /opt/hybris/bin/platform/

ENTRYPOINT ["/opt/entrypoint.sh"]
