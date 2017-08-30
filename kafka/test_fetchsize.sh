#!/bin/bash

TOPIC="topic${1}7"

$T --topic $TOPIC --partitions 3 --replication-factor 1

echo "C < "$TOPIC

for i in 1024 4096 16384 65536 262144 1048576; do
	$C --topic $TOPIC --threads 3 --batch-size 1000 --fetch-size $i;
done
