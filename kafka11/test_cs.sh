#!/bin/bash

TOPIC="topic${1}251"

$T --topic $TOPIC --partitions 9 --replication-factor 1

echo "msg > "$TOPIC

$P batch.size=16384 acks=1 compression.type=none --topic $TOPIC --record-size 100

echo "C(cs) < "$TOPIC

for i in 1 2 3 4 5 6 7 8 9; do
    $C --topic $TOPIC --threads $i --batch-size 1000 --fetch-size 1048576;
done
