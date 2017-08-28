#!/bin/bash

TOPIC="topic${1}51"

$T --topic $TOPIC --partitions 6 --replication-factor 1

echo "P > "$TOPIC

for i in -1 0 1; do
	$P --topic $TOPIC --threads 6 --batch-size 1000 --message-size 1000 --request-num-acks $i
done

if [ $1 -gt 1 ] ; then
	TOPIC="topic${1}52"
	
	$T --topic $TOPIC --partitions 6 --replication-factor 2
	
	echo "P > "$TOPIC
	
	for i in -1 0 1; do
		$P --topic $TOPIC --threads 6 --batch-size 1000 --message-size 1000 --request-num-acks $i
	done
fi

if [ $1 -gt 2 ] ; then
	TOPIC="topic${1}53"
	
	$T --topic $TOPIC --partitions 6 --replication-factor 3
	
	echo "P > "$TOPIC
	
	for i in -1 0 1; do
		$P --topic $TOPIC --threads 6 --batch-size 1000 --message-size 1000 --request-num-acks $i
	done
fi
