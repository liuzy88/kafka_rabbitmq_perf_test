#!/bin/bash

TOPIC="topic${1}2"

$T --topic $TOPIC --partitions 3 --replication-factor 1

echo "P > "$TOPIC

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
	$P --topic $TOPIC --threads $i --batch-size 1000 --message-size 1000;
done

echo "C < "$TOPIC

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
	$C --topic $TOPIC --threads $i --batch-size 1000 --message-size 1000;
done
