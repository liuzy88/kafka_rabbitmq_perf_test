#!/bin/bash

TOPIC="topic${1}3"

$T --topic $TOPIC --partitions 3 --replication-factor 1

echo "P > "$TOPIC

for i in 1 2 5 10 50 100 500 1000; do
	$P --topic $TOPIC --threads 3 --batch-size $i --message-size 1000
done

echo "C < "$TOPIC

for i in 1 2 5 10 50 100 500 1000; do
	$C --topic $TOPIC --threads 3 --batch-size $i --message-size 1000
done
