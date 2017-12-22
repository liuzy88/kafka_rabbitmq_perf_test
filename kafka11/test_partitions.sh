#!/bin/bash

TOPIC1="topic${1}61"
TOPIC2="topic${1}62"
TOPIC3="topic${1}63"
TOPIC4="topic${1}64"
TOPIC5="topic${1}65"
TOPIC6="topic${1}66"
TOPIC7="topic${1}67"
TOPIC8="topic${1}68"
TOPIC9="topic${1}69"

$T --topic $TOPIC1 --partitions 1 --replication-factor 1
$T --topic $TOPIC2 --partitions 3 --replication-factor 1
$T --topic $TOPIC3 --partitions 6 --replication-factor 1
$T --topic $TOPIC4 --partitions 9 --replication-factor 1
$T --topic $TOPIC5 --partitions 12 --replication-factor 1
$T --topic $TOPIC6 --partitions 30 --replication-factor 1
$T --topic $TOPIC7 --partitions 60 --replication-factor 1
$T --topic $TOPIC8 --partitions 90 --replication-factor 1
$T --topic $TOPIC9 --partitions 120 --replication-factor 1

echo "P(partitions) > topic${1}61~topic${1}69"

for i in $TOPIC1 $TOPIC2 $TOPIC3 $TOPIC4 $TOPIC5 $TOPIC6 $TOPIC7 $TOPIC8 $TOPIC9; do
    $P batch.size=16384 acks=1 compression.type=none --topic $i --record-size 100
done
