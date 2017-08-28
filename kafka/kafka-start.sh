#!/bin/bash

export JMX_PORT=9999
export KAFKA_HEAP_OPTS="-Xmx4G -Xms4G"

/SERVICE01/kafka/bin/kafka-server-start.sh /SERVICE01/kafka.properties 1>/dev/null 2>&1 &

tail -f kafka/logs/server.log
