#!/bin/bash

TOPIC="topic${1}7"

$T --topic $TOPIC --partitions 3 --replication-factor 1

echo "msg > "$TOPIC

$P --topic $TOPIC --threads 3 --batch-size 100 --message-size 100;

echo "C(fetch-size) < "$TOPIC

for i in 1024 4096 16384 65536 262144 1048576; do
	$C --topic $TOPIC --threads 3 --batch-size 1000 --fetch-size $i;
done

:<<!
resut
!
