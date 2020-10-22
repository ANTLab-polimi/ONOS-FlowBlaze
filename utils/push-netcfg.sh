#!/bin/bash
# Equivalent of onos-netcfg localhost topo/netcfg.json
netcfg=$3
onos_ip=$1
onos_port=$2

# Check JSON
cat ${netcfg} | python -m json.tool > /dev/null

# Push netcfg
curl -u onos:rocks -X POST -H 'Content-Type:application/json' "http://${onos_ip}:${onos_port}/onos/v1/network/configuration/" -d@${netcfg}