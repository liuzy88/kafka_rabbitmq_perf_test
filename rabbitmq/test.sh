#!/bin/bash

T="/root/rabbitmq-perf-test-1.3.0.RC2/bin/runjava com.rabbitmq.perf.PerfTest -h\"amqp://admin:admin@node4:5672/%2F\" -z 30"

export T

echo `date +%F\ %T` > test.xx
./test_messagesize.sh  >> test.xx
./test_pcs.sh  >> test.xx
echo `date +%F\ %T` >> test.xx

sed -i '/, time:/d' *.xx
sed -i '/, starting/d' *.xx
sed -i '/ WARN /d' *.xx
sed -i '/Exception/d' *.xx
sed -i '/	at /d' *.xx

cat test.xx
