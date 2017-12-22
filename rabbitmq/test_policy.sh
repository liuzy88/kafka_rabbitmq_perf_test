#!/bin/bash
#
# rabbitmqctl set_policy policy_1 "^" '{"ha-mode":"exactly","ha-params":2,"ha-sync-mode":"automatic"}'
# rabbitmqctl set_policy policy_1 "^" '{"ha-mode":"all","ha-sync-mode":"automatic"}'
# rabbitmqctl clear_policy policy_1

echo 'auto ack'
$T -x3 -y3 -a

echo 'not auto ack'
$T -x3 -y3
