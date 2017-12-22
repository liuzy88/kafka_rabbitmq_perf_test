#!/bin/bash

TOPIC="topic${1}4"

$T --topic $TOPIC --partitions 9 --replication-factor 1

echo "P(compressions) > "$TOPIC

for i in "none" "gzip" "snappy" "lz4" ; do
    $P batch.size=16384 acks=1 compression.type=$i --topic $TOPIC --record-size 1000
done
