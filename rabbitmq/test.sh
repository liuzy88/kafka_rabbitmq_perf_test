#!/bin/bash

T="/SERVICE01/rabbitmq-perf-test-1.3.0.RC2/bin/runjava com.rabbitmq.perf.PerfTest -h\"amqp://admin:admin@172.16.24.135:5672/%2F\" -z 30"

export T

echo `date +%F\ %T` > test.txt
# ./test_messagesize.sh  >> test.txt
# ./test_pcs.sh  >> test.txt
#./test_ack_durable.sh  >> test.txt
./test_policy.sh  >> test.txt
echo `date +%F\ %T` >> test.txt

sed -i '/, time:/d' *.txt
sed -i '/, starting/d' *.txt
sed -i '/ WARN /d' *.txt
sed -i '/Exception/d' *.txt
sed -i '/	at /d' *.txt

cat test.txt
