#!/bin/bash

TOPIC="topic${1}3"

$T --topic $TOPIC --partitions 3 --replication-factor 1

echo "P(batchs) > "$TOPIC

for i in 1 2 4 8 16 32 64 128 256 512 1024 4096 16384 65536; do
    $P batch.size=$i acks=1 compression.type=none --topic $TOPIC --record-size 100
done
