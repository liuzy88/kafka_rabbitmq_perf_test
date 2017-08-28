#!/bin/bash

export JAVA_HOME=/opt/jdk1.8.0_111
echo ''>nohup.out
nohup kafka-manager-1.3.3.7/bin/kafka-manager &
tail -f nohup.out
