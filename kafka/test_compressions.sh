#!/bin/bash

TOPIC="topic${1}4"

$T --topic $TOPIC --partitions 3 --replication-factor 1

echo "P > "$TOPIC

for i in 0 1 2 3; do
	$P --topic $TOPIC --threads 3 --batch-size 1000 --message-size 1000 --compression-codec $i
done

echo "C < "$TOPIC

for i in 0 1 2 3; do
	$C --topic $TOPIC --threads 3 --batch-size 1000 --message-size 1000 --compression-codec $i
done
