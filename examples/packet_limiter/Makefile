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

start:
	TOPO_FOLDER=${curr_dir}/topo TOPO_FILE=${curr_dir}/topo/topo.py docker-compose -f ../utils/docker-compose.yml --env-file ../utils/.env up  -d

stop:
	docker-compose -f ../utils/docker-compose.yml down -t0

onos-log:
	docker-compose -f ../utils/docker-compose.yml logs -f onos

onos-cli:
	ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -p 8101 onos@localhost

mn-log:
	docker-compose -f ../utils/docker-compose.yml logs -f mininet

mn-cli:
	$(info ******* Ctrl+A Ctrl+D to detach *******)
	docker-compose -f ../utils/docker-compose.yml exec mininet screen -Urx -S cli

gui-log:
	docker-compose -f ../utils/docker-compose.yml logs -f gui

push-netcfg:
	../../utils/push-netcfg.sh localhost 8181 ./topo/netcfg.json

push-app:
	cd ../../ && make push-app

leaf1-shell:
	$(info *** CLI Leaf1 )
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port)'

leaf1-clear-regs:
	$(info *** Clear registers for leaf1)
	@echo "    reg_state"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_reset reg_state" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port) > /dev/null'
	@echo "    reg_R0"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_reset reg_R0" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port) > /dev/null'
	@echo "    reg_R1"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_reset reg_R1" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port) > /dev/null'
	@echo "    reg_R2"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_reset reg_R2" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port) > /dev/null'
	@echo "    reg_R3"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_reset reg_R3" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port) > /dev/null'
	@echo "    reg_G"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_reset reg_G" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port) > /dev/null'

leaf1-read-regs:
	$(info *** Read registers for S1)
	@echo "    reg_state"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_read reg_state" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port)'
	@echo "    reg_R0"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_read reg_R0" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port)'
	@echo "    reg_R1"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_read reg_R1" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port)'
	@echo "    reg_R2"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_read reg_R2" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port)'
	@echo "    reg_R3"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_read reg_R3" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port)'
	@echo "    reg_G"
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c 'echo "register_read reg_G" | simple_switch_CLI --thrift-port $$(cat /tmp/bmv2-leaf1-thrift-port)'

reset-flowblaze-onos:
	curl -X GET -u onos:rocks 'http://localhost:8181/onos/flowblaze/resetFlowblaze'

reset: reset-flowblaze-onos leaf1-clear-regs

h1-cli:
	docker-compose -f ../utils/docker-compose.yml exec mininet /mininet/util/m h1

h2-cli:
	docker-compose -f ../utils/docker-compose.yml exec mininet /mininet/util/m h2

test-ping:
	@docker-compose -f ../utils/docker-compose.yml exec mininet /bin/sh -c '/mininet/util/m h1 ping 10.10.0.1 -c 12'

setup: push-netcfg push-app
	# Disable LLDP Link Provider
	curl -X POST -u onos:rocks --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "enabled": "false" }' 'http://localhost:8181/onos/v1/configuration/org.onosproject.provider.lldp.impl.LldpLinkProvider?preset=true'
	# Push hosts
	curl -i -X POST -H 'Content-Type: application/json' --data-binary @topo/h1.json -u onos:rocks 'http://localhost:8181/onos/v1/hosts'
	curl -i -X POST -H 'Content-Type: application/json' --data-binary @topo/h2.json -u onos:rocks 'http://localhost:8181/onos/v1/hosts'
	../../utils/push-netcfg.sh localhost 8181 ./topo/links.json
