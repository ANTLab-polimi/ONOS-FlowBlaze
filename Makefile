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

curr_dir := $(shell pwd)
APP_VERSION = 0.0.1-SNAPSHOT
APP_NAME = flowblaze-app
APP_OAR = app/target/${APP_NAME}-${APP_VERSION}.oar

build-app:
	mvn clean install

$(APP_OAR):
	$(error Missing app binary, run 'make app-build' first)

push-app: $(APP_OAR)
	$(info ************ RELOADING ONOS APP ************)
	onos-app localhost reinstall! ${APP_OAR}

push-netcfg:
	onos-netcfg localhost topo/netcfg.json

start:
	docker-compose up -d

stop:
	docker-compose down

start-full:
	docker-compose -f docker-compose_full-fabric.yml -p full_fabric up -d

stop-full:
	docker-compose -f docker-compose_full-fabric.yml -p full_fabric down

push-netcfg-full:
	onos-netcfg localhost topo/netcfg_full_fabric.json

onos-log:
	docker-compose logs -f onos

mn-log:
	docker-compose logs -f mininet

gui-log:
	docker-compose logs -f gui

onos-cli:
	ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -p 8101 onos@localhost

leaf1_shell:
	$(info *** CLI Leaf1 )
	@docker-compose exec mininet /bin/sh -c 'simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port)'

leaf1-clear-reg:
	$(info *** Clear registers for leaf1)
	@echo "    reg_state"
	@docker-compose exec mininet /bin/sh -c 'echo "register_reset reg_state" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port) > /dev/null'
	@echo "    reg_R0"
	@docker-compose exec mininet /bin/sh -c 'echo "register_reset reg_R0" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port) > /dev/null'
	@echo "    reg_R1"
	@docker-compose exec mininet /bin/sh -c 'echo "register_reset reg_R1" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port) > /dev/null'
	@echo "    reg_R2"
	@docker-compose exec mininet /bin/sh -c 'echo "register_reset reg_R2" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port) > /dev/null'
	@echo "    reg_R3"
	@docker-compose exec mininet /bin/sh -c 'echo "register_reset reg_R3" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port) > /dev/null'
	@echo "    reg_G"
	@docker-compose exec mininet /bin/sh -c 'echo "register_reset reg_G" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port) > /dev/null'

leaf1-read-reg:
	$(info *** Read registers for S1)
	@echo "    reg_state"
	@docker-compose exec mininet /bin/sh -c 'echo "register_read reg_state" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port)'
	@echo "    reg_R0"
	@docker-compose exec mininet /bin/sh -c 'echo "register_read reg_R0" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port)'
	@echo "    reg_R1"
	@docker-compose exec mininet /bin/sh -c 'echo "register_read reg_R1" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port)'
	@echo "    reg_R2"
	@docker-compose exec mininet /bin/sh -c 'echo "register_read reg_R2" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port)'
	@echo "    reg_R3"
	@docker-compose exec mininet /bin/sh -c 'echo "register_read reg_R3" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port)'
	@echo "    reg_G"
	@docker-compose exec mininet /bin/sh -c 'echo "register_read reg_G" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-s1-thrift-port)'

mn-cli:
	$(info ******* Ctrl+A Ctrl+D to detach *******)
	docker-compose exec mininet screen -Urx -S cli

h1-cli:
	docker-compose exec mininet /mininet/util/m h1

h2-cli:
	docker-compose exec mininet /mininet/util/m h2

h10-cli:
	docker-compose exec mininet /mininet/util/m h10

h1-test:
	@docker-compose exec mininet /bin/sh -c '/mn_onos/utils/h1-iperf-test_udp.sh'

h2-test:
	@docker-compose exec mininet /bin/sh -c '/mn_onos/utils/h2-iperf-test_udp.sh'

p4runtime_shell:
	docker run -ti --rm p4lang/p4runtime-sh \
      --grpc-addr 172.28.0.2:50001 \
      --device-id 1 --election-id 0,1

push-json-onos-EXAMPLE:
	curl -X GET -u onos:rocks 'http://localhost:8181/onos/flowblaze/setDeviceId/device:leaf1'
	curl -i -X POST -H 'Content-Type: application/json' --data-binary @json_example/efsm_entry.json -u onos:rocks 'http://localhost:8181/onos/flowblaze/setEfsmEntry'
	curl -i -X POST -H 'Content-Type: application/json' --data-binary @json_example/pkt_actions.json -u onos:rocks 'http://localhost:8181/onos/flowblaze/setPktActions'
	curl -i -X POST -H 'Content-Type: application/json' --data-binary @json_example/conditions.json -u onos:rocks 'http://localhost:8181/onos/flowblaze/setConditions'

reset-flowblaze-onos:
	curl -X GET -u onos:rocks 'http://localhost:8181/onos/flowblaze/resetFlowblaze'

uc1-setup: push-app push-netcfg
	curl -X POST -u onos:rocks --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "enabled": "false" }' 'http://localhost:8181/onos/v1/configuration/org.onosproject.provider.lldp.impl.LldpLinkProvider?preset=true'
	curl -i -X POST -H 'Content-Type: application/json' --data-binary @topo/h1.json -u onos:rocks 'http://localhost:8181/onos/v1/hosts'
	curl -i -X POST -H 'Content-Type: application/json' --data-binary @topo/h2.json -u onos:rocks 'http://localhost:8181/onos/v1/hosts'
	curl -i -X POST -H 'Content-Type: application/json' --data-binary @topo/h10.json -u onos:rocks 'http://localhost:8181/onos/v1/hosts'

uc1-test-ping:
	@docker-compose exec mininet /bin/sh -c '/mininet/util/m h1 ping 10.0.1.1 -c 12'

uc2-setup: push-app push-netcfg