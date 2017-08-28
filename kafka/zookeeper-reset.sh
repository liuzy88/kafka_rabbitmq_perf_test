#!/bin/bash

if [ x"$1" == x ] ; then
    echo "input number for myid !!!"
    exit 1
fi
rm -rf /SERVICE01/zookeeper-data
mkdir /SERVICE01/zookeeper-data
echo "$1">/SERVICE01/zookeeper-data/myid
