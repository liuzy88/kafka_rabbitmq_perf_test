#!/bin/bash
#
# rabbitmqctl set_policy policy_1 "^" '{"ha-mode":"exactly","ha-params":2,"ha-sync-mode":"automatic"}'
# rabbitmqctl set_policy policy_1 "^" '{"ha-mode":"all","ha-sync-mode":"automatic"}'
# rabbitmqctl clear_policy policy_1


for i in 1 2 3; do
	$T -x$i -y$i -a
done
