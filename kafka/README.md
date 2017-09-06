1.	环境部署
1.1	机器列表


1.2	部署目标
 

1.3	安装步骤
1.3.1	安装JDK
- 所有机器上传jdk-7u80-linux-x64.rpm
- 所有机器安装JDK
```
rpm -ivh jdk-7u80-linux-x64.rpm
```
1.3.2	修改HOSTS
- 修改所有机器的HOSTS文件/etc/hosts
```
172.18.163.121 ka1
172.18.163.131 ka2
172.18.163.141 ka3
172.18.163.128 zk1
172.18.163.132 zk2
172.18.163.149 zk3
```
1.3.3	Zookepper安装配置
- 下载zookeeper-3.4.6.tar.gz
- 上传到/SERVICE01
- 解压unzip zookeeper-3.4.6.tar.gz
- 编辑/SERVICE01/zookeeper-3.4.6/conf/zoo.cfg
```
tickTime=2000
dataDir=/ SERVICE01/zookeeper-data
clientPort=2181
initLimit=5
syncLimit=2
server.1=zk1:2881:2882
server.2=zk2:2881:2882
server.3=zk3:2881:2882
```
- 编写zookepper启动脚本/SERVICE01/zookeeper- start.sh
```
#!/bin/bash
/SERVICE01/zookeeper-3.4.6/bin/zkServer.sh start
tail -f zookeeper.out
```
- 编写zookepper停止脚本/SERVICE01/zookeeper -shutdown.sh
```
#!/bin/bash
/SERVICE01/zookeeper-3.4.6/bin/zkServer.sh stop
```
- 编写zookepper清理脚本/SERVICE01/zookeeper-reset.sh
```
#!/bin/bash
if [ x"$1" == x ] ; then
    echo "input number for myid !!!"
    exit 1
fi
rm -rf /SERVICE01/zookeeper-data
mkdir /SERVICE01/zookeeper-data
echo "$1">/SERVICE01/zookeeper-data/myid
```
- 初始化各个Zookepper
```
在zk1上执行：
./zookeeper-reset.sh 1
在zk2上执行：
./zookeeper-reset.sh 2
在zk3上执行：
./zookeeper-reset.sh 3
```

1.3.4	Kafka-Manager安装配置
- 在Windos环境下载源码，安装sbt，过程略
- 编译打包，得到kafka-manager-1.3.3.7.zip
```
./sbt clean dist
```
- 上传到/SERVICE01
- 解压kafka-manager-1.3.3.7.zip
- 上传jdk-8u111-linux-i586.tar.gz到/opt目录（由于Kafka-Manager使用JDK1.8编译）
```
cd /opt
tar xvf jdk-8u111-linux-i586.tar.gz
```
- 修改配置文件/SERVICE01/kafka-manager-1.3.3.7/conf/application.conf
```
kafka-manager.zkhosts="zk1:2181, zk2:2181, zk3:2181"
```
- 编写kafka-manager启动脚本/SERVICE01/kafkamanager-start.sh
```
#!/bin/bash
export JAVA_HOME=/opt/jdk1.8.0_111
echo ''>nohup.out
nohup kafka-manager-1.3.3.7/bin/kafka-manager &
tail -f nohup.out
```
- 编写kafka-manager停止脚本/SERVICE01/kafkamanager-shutdown.sh
```
#!/bin/bash
pid=`lsof -i :9000|grep java|grep LISTEN|awk '{print $2}'`
if [ x$pid != x ] ; then
    kill -9 $pid
    rm -rf /SERVICE01/kafka-manager-1.3.3.7/RUNNING_PID
    rm -rf /SERVICE01/kafka-manager-1.3.3.7/application.home_IS_UNDEFINED
fi
```

1.3.5	Kafka安装配置
- 下载kafka_2.9.2-0.8.2.1.tgz
- 上传到/SERVICE01
- 解压kafka_2.9.2-0.8.2.1.tgz
```
tar xvf kafka_2.9.2-0.8.2.1.tgz
```
- 编辑Kafka配置文件/SERVICE01/kafka.properties（注意：3个节点的broker.id和host.name）
```
broker.id=1
port=9092
advertised.host.name=172.18.163.121
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/SERVICE01/kafka-logs
num.partitions=1
num.recovery.threads.per.data.dir=1
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
log.cleaner.enable=false
zookeeper.connect=zk1:2181,zk2:2181,zk3:2181
zookeeper.connection.timeout.ms=6000
```
- 编写Kafka启动脚本/SERVICE01/kafka-start.sh
```
#!/bin/bash
export JMX_PORT=9999
export KAFKA_HEAP_OPTS="-Xmx4G -Xms4G"
/SERVICE01/kafka/bin/kafka-server-start.sh /SERVICE01/kafka.properties 1>/dev/null 2>&1 &
tail -f kafka/logs/server.log
```
- 编写Kafka停止脚本/SERVICE01/kafka-shutdown.sh
```
#!/bin/bash 
/SERVICE01/kafka/bin/kafka-server-stop.sh
```
- 编写Kafka重置脚本/SERVICE01/kafka-reset.sh
```
#!/bin/bash 
rm -rf /SERVICE01/kafka-logs
```
- 编写Kafka看日志脚本/SERVICE01/kafka-showlog.sh
```
#!/bin/bash 
tail -f kafka/logs/server.log
```


1.3.6	测试工具
- Kafka自带测试工具
```
/SERVICE01/kafka/bin/kafka-producer-perf-test.sh
/SERVICE01/kafka/bin/kafka-consumer-perf-test.sh
```

2.	测试过程
2.1	环境切换
2.1.1	单节点环境
- 停止Kafka-Manager
```
./kafkamanager-shutdown.sh
```
- 重置Zookepper，在zk1、zk2、zk3上分别执行（注意：reset脚本后面的ID要写对）
```
./zookeeper-shutdown.sh
./zookeeper-reset.sh 1或2或3
```
- 启动Zookepper，在zk1、zk2、zk3上分别执行
```
./zookeeper-start.sh
```
- 重置Kafka，在每个节点上执行
```
./kafka-shutdown.sh
./kafka-reset.sh
```
- 启动Kafka节点1
```
./kafka-start.sh
```

2.1.2	双节点环境
- 停止Kafka-Manager
```
./kafkamanager-shutdown.sh
```
- 重置Zookepper，在zk1、zk2、zk3上分别执行（注意：reset脚本后面的ID要写对）
```
./zookeeper-shutdown.sh
./zookeeper-reset.sh 1或2或3
```
- 启动Zookepper，在zk1、zk2、zk3上分别执行
```
./zookeeper-start.sh
```
- 重置Kafka，在每个节点上执行
```
./kafka-shutdown.sh
./kafka-reset.sh
```
- 启动Kafka节点1和节点2
```
./kafka-start.sh
```

2.1.3	三节点环境
- 停止Kafka-Manager
```
./kafkamanager-shutdown.sh
```
- 重置Zookepper，在zk1、zk2、zk3上分别执行（注意：reset脚本后面的ID要写对）
```
./zookeeper-shutdown.sh
./zookeeper-reset.sh 1或2或3
```
- 启动Zookepper，在zk1、zk2、zk3上分别执行
```
./zookeeper-start.sh
```
- 重置Kafka，在每个节点上执行
```
./kafka-shutdown.sh
./kafka-reset.sh
```
- 启动Kafka节点1、节点2、节点3
```
./kafka-start.sh
```

2.2	测试点

2.2.1	消息大小
测试消息大小为100,200,400,600,800,1000,2000,4000,6000,8000,10000时的吞吐量

2.2.2	生产者/消费者数量
测试生产/消费线程数为1,2,5,10,50,100时的吞吐量


2.2.3	批处理数量
测试批处理数量为1,2,5,10,50,100,500,1000时的吞吐量


2.2.4	压缩模式
测试压缩模式为Uncomp,Gzip,Snappy,LZ4时的吞吐量

2.2.5	应答模式和复制因子
测试应答模式为-1,0,1和复制因子为1,2,3时的吞吐量

2.2.6	分区数量
测试分区数量为1,2,4,8,10时的吞吐量


2.3	脚本测试结果处理
- 删除多余的信息
```
sed -i '/ WARN /d' *.xx
sed -i '/Exception/d' *.xx
sed -i '/	at /d' *.xx
sed -i '/start.time/d' *.xx
```

2.4	结果示例（注意：P表示生产者、C表示消费者、倒数第三个值为MB/s、倒数第一个值为msg/s）
```
P
2017-07-28 09:41:45:362, 2017-07-28 09:41:48:505, 3, 100, 1000, 47.68, 15.1714, 500000, 159083.6780
2017-07-28 09:41:50:557, 2017-07-28 09:41:53:861, 3, 200, 1000, 95.37, 28.8642, 500000, 151331.7191
2017-07-28 09:41:55:910, 2017-07-28 09:41:59:789, 3, 400, 1000, 190.73, 49.1711, 500000, 128899.2008
2017-07-28 09:42:01:840, 2017-07-28 09:42:06:360, 3, 600, 1000, 286.10, 63.2970, 500000, 110619.4690
2017-07-28 09:42:08:385, 2017-07-28 09:42:12:759, 3, 800, 1000, 381.47, 87.2130, 500000, 114311.8427
2017-07-28 09:42:14:812, 2017-07-28 09:42:19:706, 3, 1000, 1000, 476.84, 97.4330, 500000, 102165.9174
2017-07-28 09:42:21:716, 2017-07-28 09:42:27:672, 3, 2000, 1000, 953.67, 160.1199, 500000, 83948.9590
2017-07-28 09:42:29:713, 2017-07-28 09:42:39:734, 3, 4000, 1000, 1907.35, 190.3352, 500000, 49895.2200
2017-07-28 09:42:41:769, 2017-07-28 09:42:53:252, 3, 6000, 1000, 2861.02, 249.1529, 500000, 43542.6282
2017-07-28 09:42:55:297, 2017-07-28 09:43:09:355, 3, 8000, 1000, 3814.70, 271.3542, 500000, 35566.9370
2017-07-28 09:43:11:453, 2017-07-28 09:43:28:982, 3, 10000, 1000, 4768.37, 272.0276, 500000, 28524.1600
C
2017-07-28 09:43:32:962, 2017-07-28 09:43:37:964, 1048576, 47.6837, 23841.8579, 500000, 250000000.0000
2017-07-28 09:43:41:919, 2017-07-28 09:43:46:921, 1048576, 47.6837, 23841.8579, 500000, 250000000.0000
2017-07-28 09:43:50:920, 2017-07-28 09:43:55:923, 1048576, 47.6837, 15894.5719, 500000, 166666666.6667
2017-07-28 09:43:59:880, 2017-07-28 09:44:04:881, 1048576, 47.6837, 47683.7158, 500000, 500000000.0000
2017-07-28 09:44:08:820, 2017-07-28 09:44:13:822, 1048576, 47.6837, 23841.8579, 500000, 250000000.0000
2017-07-28 09:44:17:744, 2017-07-28 09:44:22:746, 1048576, 47.6837, 23841.8579, 500000, 250000000.0000
2017-07-28 09:44:26:716, 2017-07-28 09:44:31:718, 1048576, 47.6837, 23841.8579, 500000, 250000000.0000
2017-07-28 09:44:35:679, 2017-07-28 09:44:40:681, 1048576, 47.6837, 23841.8579, 500000, 250000000.0000
2017-07-28 09:44:44:553, 2017-07-28 09:44:49:555, 1048576, 47.6837, 23841.8579, 500000, 250000000.0000
2017-07-28 09:44:53:471, 2017-07-28 09:44:58:473, 1048576, 47.6837, 23841.8579, 500000, 250000000.0000
2017-07-28 09:45:02:466, 2017-07-28 09:45:07:468, 1048576, 47.6837, 23841.8579, 500000, 250000000.0000
```


