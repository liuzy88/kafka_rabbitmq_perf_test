#!/bin/bash

TOPIC1="topic${1}61"
TOPIC2="topic${1}62"
TOPIC3="topic${1}63"
TOPIC4="topic${1}64"
TOPIC5="topic${1}65"

$T --topic $TOPIC1 --partitions 1 --replication-factor 1
$T --topic $TOPIC2 --partitions 2 --replication-factor 1
$T --topic $TOPIC3 --partitions 4 --replication-factor 1
$T --topic $TOPIC4 --partitions 8 --replication-factor 1
$T --topic $TOPIC5 --partitions 10 --replication-factor 1

echo "P"

for i in $TOPIC1 $TOPIC2 $TOPIC3 $TOPIC4 $TOPIC5; do
	$P --topic $i --threads 3 --batch-size 1000 --message-size 1000
done

echo "C"

for i in $TOPIC1 $TOPIC2 $TOPIC3 $TOPIC4 $TOPIC5; do
	$C --topic $i --threads 3 --batch-size 1000 --message-size 1000
done