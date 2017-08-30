#!/bin/bash

T="/SERVICE01/kafka/bin/kafka-topics.sh --create --zookeeper zk1:2181,zk2:2181,zk3:2181"
P="/SERVICE01/kafka/bin/kafka-producer-perf-test.sh --messages 500000"
C="/SERVICE01/kafka/bin/kafka-consumer-perf-test.sh --zookeeper zk1:2181,zk2:2181,zk3:2181 --messages 5000000"

if [ x"$1" == x ]; then
    echo "input number for brokers 1/2/3 !"
    exit 1
elif [ "$1" == 1 ]; then
	export P=$P" --broker-list ka1:9092"
elif [ "$1" == 2 ]; then
	export P=$P" --broker-list ka1:9092,ka2:9092"
elif [ "$1" == 3 ]; then
	export P=$P" --broker-list ka1:9092,ka2:9092,ka3:9092"
fi

export T
export C

echo `date +%F\ %T` > test$1.xx
./test_messagesize.sh $1 >> test$1.xx
#./test_pcs.sh $1 >> test$1.xx
#./test_batchs.sh $1 >> test$1.xx
#./test_compressions.sh $1 >> test$1.xx
#./test_acks.sh $1 >> test$1.xx
#./test_partitions.sh $1 >> test$1.xx
echo `date +%F\ %T` >> test$1.xx

sed -i '/ WARN /d' *.xx
sed -i '/Exception/d' *.xx
sed -i '/	at /d' *.xx
sed -i '/start.time/d' *.xx

cat test$1.xx
