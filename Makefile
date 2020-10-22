# Copyright 2020 Daniele Moro <daniele.moro@polimi.it>
#                Davide Sanvito <davide.sanvito@neclab.eu>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

onos_ip := localhost
onos_port := 8181

curr_dir := $(shell pwd)

app := org.polimi.flowblaze
app_name = flowblaze-app
app_version = $(shell cat VERSION)
app_oar = app/target/${app_name}-${app_version}.oar

###############################################################################
# From: https://github.com/opennetworkinglab/stratum-onos-demo/blob/master/app/Makefile
maven_img := maven:3.6.3-jdk-11-slim
curr_dir_sha := $(shell echo -n "$(curr_dir)" | shasum | cut -c1-7)

mvn_build_container_name := mvn-build-${curr_dir_sha}

build: _create_mvn_container _mvn_package
	$(info *** ONOS app .oar package created succesfully)
	@ls -1 app/target/*.oar

# Reuse the same container to persist mvn repo cache.
_create_mvn_container:
	@if ! docker container ls -a --format '{{.Names}}' | grep -q ${mvn_build_container_name} ; then \
		docker create -v ${curr_dir}:/mvn-src -w /mvn-src  --user "$(id -u):$(id -g)" --name ${mvn_build_container_name} ${maven_img} mvn clean install; \
	fi

_mvn_package:
	$(info *** Building ONOS app...)
	@mkdir -p target
	@docker start -a -i ${mvn_build_container_name}

clean:
	@-docker rm ${mvn_build_container_name} > /dev/null
	@-rm -rf target
	@-rm -rf app/target
	@-rm -rf api/target
###############################################################################

$(app_oar):
	$(error Missing app binary, run 'make build' first)

push-app: $(app_oar)
	./utils/push-app.sh ${onos_ip} ${onos_port} ${app_oar} ${app}






p4runtime_shell:
	docker run -ti --rm p4lang/p4runtime-sh \
      --grpc-addr 172.28.0.2:50001 \
      --device-id 1 --election-id 0,1

push-json-onos-EXAMPLE:
	curl -X GET -u onos:rocks 'http://localhost:8181/onos/flowblaze/setDeviceId/device:leaf1'
	curl -i -X POST -H 'Content-Type: application/json' --data-binary @json_example/efsm_entry.json -u onos:rocks 'http://localhost:8181/onos/flowblaze/setEfsmEntry'
	curl -i -X POST -H 'Content-Type: application/json' --data-binary @json_example/pkt_actions.json -u onos:rocks 'http://localhost:8181/onos/flowblaze/setPktActions'
	curl -i -X POST -H 'Content-Type: application/json' --data-binary @json_example/conditions.json -u onos:rocks 'http://localhost:8181/onos/flowblaze/setConditions'
