#!/bin/bash
cd /opt/hybris/bin/platform/

. ./setantenv.sh && \
  ant clean all

# restart collectd with delay so it won't fail jmx:rmi connection
(sleep 30 ; service collectd restart) &
./hybrisserver.sh
