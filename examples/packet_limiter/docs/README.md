# Packet Limiter
This use case implements a packet limiter that drops all the traffic from a host
after 10 packets.

## Guide

Start the Docker-compose network. This includes Mininet, ONOS and the EFSM GUI:
```
make start
```
ONOS GUI and EFSM GUI will be available at the following links:
- ONOS GUI: [http://localhost:8181/onos/ui](http://localhost:8181/onos/ui) 
(USER:onos, PASSWORD: rocks)
- EFSM GUI: [http://localhost:8000](http://localhost:8000)

When ONOS is correctly started (it can take up to 2 minutes), run the following
make target to push the FlowBlaze ONOS app and the network configuration:
```
make setup
```

After that, the switches and hosts should appear in the ONOS GUI:
![](packet_limiter_onos_gui.png)

We can try to ping the hosts and the ping should be successful as expected:
```
$ make test-ping 
PING 10.10.0.1 (10.10.0.1) 56(84) bytes of data.
64 bytes from 10.10.0.1: icmp_seq=1 ttl=62 time=31.0 ms
64 bytes from 10.10.0.1: icmp_seq=2 ttl=62 time=7.01 ms
64 bytes from 10.10.0.1: icmp_seq=3 ttl=62 time=20.2 ms
64 bytes from 10.10.0.1: icmp_seq=4 ttl=62 time=10.7 ms
64 bytes from 10.10.0.1: icmp_seq=5 ttl=62 time=20.8 ms
64 bytes from 10.10.0.1: icmp_seq=6 ttl=62 time=21.1 ms
64 bytes from 10.10.0.1: icmp_seq=7 ttl=62 time=16.1 ms
64 bytes from 10.10.0.1: icmp_seq=8 ttl=62 time=15.9 ms
64 bytes from 10.10.0.1: icmp_seq=9 ttl=62 time=16.4 ms
64 bytes from 10.10.0.1: icmp_seq=10 ttl=62 time=16.2 ms
64 bytes from 10.10.0.1: icmp_seq=11 ttl=62 time=16.8 ms
64 bytes from 10.10.0.1: icmp_seq=12 ttl=62 time=6.66 ms

--- 10.10.0.1 ping statistics ---
12 packets transmitted, 12 received, 0% packet loss, time 11014ms
rtt min/avg/max/mdev = 6.662/16.614/31.011/6.367 ms

```
Now we can draw the EFSM in the EFSM GUI:
![](packet_limiter_efsm_gui.png)

Or otherwise loading the [`EFSM_packet_limiter.json`](EFSM_packet_limiter.json)
using the LOAD FSM button.

When the EFSM is drawn we can push the runtime configuration to ONOS using the 
GENERATE SWITCH CONFIG ONOS button.

Now, we can run:
```
make test-ping
```
The ping should fail after 10 successful pings.

## Useful make Targets
[Documentation](../../docs/useful_make_targets.md)


## Teardown
```bash
make stop
```
