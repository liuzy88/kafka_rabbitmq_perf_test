#!/bin/bash

TOPIC="topic${1}4"

$T --topic $TOPIC --partitions 9 --replication-factor 1

echo "P > "$TOPIC

for i in 0 1 2 3; do
	$P --topic $TOPIC --threads 9 --batch-size 1000 --message-size 1000 --compression-codec $i
done

:<<!
resut
!
