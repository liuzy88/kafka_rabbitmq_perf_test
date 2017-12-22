#!/bin/bash

export KAFKA_HEAP_OPTS="-Xmx32G"

T="/SERVICE01/kafka/bin/kafka-topics.sh --create --zookeeper zk1:2181,zk2:2181,zk3:2181"
P="/SERVICE01/kafka/bin/kafka-producer-perf-test.sh --num-records 1000000 --throughput 1000000 --producer-props"
C="/SERVICE01/kafka/bin/kafka-consumer-perf-test.sh --new-consumer --messages 5000000"

if [ x"$1" == x ]; then
    echo "input number for brokers 1/2/3 !"
    exit 1
elif [ "$1" == 1 ]; then
    export P=$P" bootstrap.servers=ka1:9092"
    export C=$C" --broker-list ka1:9092"
elif [ "$1" == 2 ]; then
    export P=$P" bootstrap.servers=ka1:9092,ka2:9092"
    export C=$C" --broker-list ka1:9092,ka2:9092"
elif [ "$1" == 3 ]; then
    export P=$P" bootstrap.servers=ka1:9092,ka2:9092,ka3:9092"
    export C=$C" --broker-list ka1:9092,ka2:9092,ka3:9092"
fi

export T

echo `date +%F\ %T` > test$1.txt
# ./test_acks.sh $1 >> test$1.txt
# ./test_batchs.sh $1 >> test$1.txt
# ./test_compressions.sh $1 >> test$1.txt
./test_cs.sh $1 >> test$1.txt
# ./test_fetchsize.sh $1 >> test$1.txt
# ./test_messagesize.sh $1 >> test$1.txt
# ./test_partitions.sh $1 >> test$1.txt
# ./test_ps.sh $1 >> test$1.txt
echo `date +%F\ %T` >> test$1.txt

sed -i '/ WARN /d' *.txt
sed -i '/ ERROR /d' *.txt
sed -i '/Exception/d' *.txt
sed -i '/    at /d' *.txt
sed -i '/start.time/d' *.txt
sed -i '/ max latency\./d' *.txt

cat test$1.txt
