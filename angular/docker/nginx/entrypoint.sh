#!/usr/bin/env bash

nginx_template_server_file="/etc/nginx/conf.d/server.conf.template"
nginx_server_file="/etc/nginx/conf.d/default.conf"

cat ${nginx_template_server_file} > ${nginx_server_file}
while read -r line; do
    name="${line%=*}"
    eval value="\$$name"
    sed -i -e "s/\$${name}/${value}/g" ${nginx_server_file} &> /dev/null
done <<EOF
$(env)
EOF

if [[ $# -eq 0 ]]; then
    nginx -g "daemon off;"
else
    exec "$@"
fi


