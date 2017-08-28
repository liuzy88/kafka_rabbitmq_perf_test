#!/bin/bash

zookeeper-3.4.6/bin/zkServer.sh start
tail -f zookeeper.out
