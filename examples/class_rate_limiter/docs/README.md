# Multi-Class Rate Limiter
This use case implements a two-class rate limiter. The class of traffic is
identified by the IP source subnet. The host parts of the two subnsts
will have 2 different allowed rates.

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
We can also do a pingall, in this way ONOS will discover all the hosts in the
Mininet topology.
```
make pingall
```
After that, the switch and hosts should appear in the ONOS GUI:
![](rate_limiter_onos_gui.png)

Now we can draw the EFSM in the EFSM GUI:
![](rate_limiter_efsm_gui.png)

Or otherwise loading the [`EFSM_rate_limiter.json`](EFSM_rate_limiter.json)
using the LOAD FSM button.

When the EFSM is drawn we can push the runtime configuration to ONOS using the 
GENERATE SWITCH CONFIG ONOS button.

Now, we can run:
```
make h1-test
```
and obtain a similar output:
```
*** Opening iperf server on H10
    PID: 152
*** Opening iperf client on H1
------------------------------------------------------------
Client connecting to 10.10.10.1, UDP port 5001
Sending 1470 byte datagrams, IPG target: 5742.19 us (kalman adjust)
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  5] local 10.0.0.1 port 56115 connected with 10.10.10.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  5]  0.0-20.0 sec  4.88 MBytes  2.05 Mbits/sec
[  5] Sent 3484 datagrams
[  5] Server Report:
[  5]  0.0-20.3 sec  2.36 MBytes   975 Kbits/sec   0.000 ms 1803/ 3483 (0%)
*** Killing iperf server on H10
```
and
```
make h2-test
```
and obtain a similar output:
```
*** Opening iperf server on H10
    PID: 184
*** Opening iperf client on H2
------------------------------------------------------------
Client connecting to 10.10.10.1, UDP port 5002
Sending 1470 byte datagrams, IPG target: 4593.75 us (kalman adjust)
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  5] local 10.0.1.1 port 38511 connected with 10.10.10.1 port 5002
[ ID] Interval       Transfer     Bandwidth
[  5]  0.0-20.0 sec  6.11 MBytes  2.56 Mbits/sec
[  5] Sent 4355 datagrams
[  5] Server Report:
[  5]  0.0-20.3 sec  4.68 MBytes  1.94 Mbits/sec   0.000 ms 1014/ 4354 (0%)
*** Killing iperf server on H10
```
The 2 hosts, being part of two different subnets have different associated rates.

## Useful make Targets
[Documentation](../../docs/useful_make_targets.md)


## Teardown
```bash
make stop
```

