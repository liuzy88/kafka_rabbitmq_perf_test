#!/bin/bash

TOPIC="topic${1}72"

$T --topic $TOPIC --partitions 9 --replication-factor 1

echo "msg > "$TOPIC

$P batch.size=16384 acks=1 compression.type=none --topic $TOPIC --record-size 100

echo "C(fetch-size) < "$TOPIC

for i in 1024 4096 16384 65536 262144 1048576; do
    $C --topic $TOPIC --threads 9 --batch-size 1000 --fetch-size $i;
done
