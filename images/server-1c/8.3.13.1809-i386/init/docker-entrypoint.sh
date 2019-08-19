#!/bin/bash

if [ "$1" = "ragent" ]; then
  exec gosu usr1cv8 /opt/1C/v8.3/i386/ragent
#else
#  /etc/init.d/srv1cv83 start
fi

exec "$@"
