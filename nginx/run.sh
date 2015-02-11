#!/bin/sh
sed -i -e "s:__ADDRESS__:$COREOS_PRIVATE_IPV4:" /etc/nginx/conf.d/default.conf
nginx -g "daemon off;"
