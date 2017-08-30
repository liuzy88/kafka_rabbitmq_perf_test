#!/bin/bash

pid=`lsof -i :9000|grep java|grep LISTEN|awk '{print $2}'`
if [ x$pid != x ] ; then
    kill -9 $pid
    rm -rf /SERVICE01/kafka-manager-1.3.3.7/RUNNING_PID
    rm -rf /SERVICE01/kafka-manager-1.3.3.7/application.home_IS_UNDEFINED
fi
