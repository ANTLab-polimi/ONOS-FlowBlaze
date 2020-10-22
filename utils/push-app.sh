#!/bin/bash

onos_ip=$1
onos_port=$2
app_oar=$3
app_name=$4

# Equivalent of onos-app localhost reinstall! ${APP_OAR}
echo "************ RELOADING ONOS APP ************"
curl -u onos:rocks -X DELETE http://${onos_ip}:${onos_port}/onos/v1/applications/${app_name}
curl -u onos:rocks -X POST -HContent-Type:application/octet-stream http://${onos_ip}:${onos_port}/onos/v1/applications?activate=true --data-binary @${app_oar}