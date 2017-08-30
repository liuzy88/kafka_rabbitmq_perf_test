#!/bin/bash

TOPIC="topic${1}1"

$T --topic $TOPIC --partitions 3 --replication-factor 1

echo "P > "$TOPIC

for i in 100 200 400 600 800 1000 2000 4000 6000 8000 10000; do
	$P --topic $TOPIC --threads 3 --batch-size 1000 --message-size $i;
done

# echo "C < "$TOPIC

# for i in 100 200 400 600 800 1000 2000 4000 6000 8000 10000; do
# 	$C --topic $TOPIC --threads 3 --batch-size 1000 --message-size $i;
# done
