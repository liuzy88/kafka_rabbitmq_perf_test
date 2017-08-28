# RabbitMQ 在5个场景下的性能测试

## 1.测试环境

### 1.1.单机

```
RabbitMQ
4C8G,Intel Xeon E312xx (Sandy Bridge),CentOS Linux release 7.2.1511 (Core)
RabbitMQ版本 3.6.10

生产者/消费者
4C8G,Intel Xeon E312xx (Sandy Bridge),CentOS Linux release 7.2.1511 (Core)
JDK版本 jdk1.8.0_111
```

### 1.2.集群

```
RabbitMQ 三台
4C8G,Intel Xeon E312xx (Sandy Bridge),CentOS Linux release 7.2.1511 (Core)
RabbitMQ版本 3.6.10

HAProxy 一台
4C8G,Intel Xeon E312xx (Sandy Bridge),CentOS Linux release 7.2.1511 (Core)
HAProxy版本 1.5.14

生产者/消费者
4C8G,Intel Xeon E312xx (Sandy Bridge),CentOS Linux release 7.2.1511 (Core)
JDK版本 jdk1.8.0_111
```

## 2.安装RabbitMQ 3.6.10
- 软件下载

```
http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.10/
http://www.rabbitmq.com/releases/erlang/
```

#### 2.x在CentOS 6 下安装

```
yum install -y openssl-devel ncurses-devel gcc gcc-c++ unixODBC-devel wget vim lsof

wget http://www.rabbitmq.com/releases/erlang/erlang-19.0.4-1.el6.x86_64.rpm
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/socat-1.7.2.3-1.el6.x86_64.rpm
wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.10/rabbitmq-server-3.6.10-1.el6.noarch.rpm

yum install -y *.rpm
```

#### 2.1在CentOS 7 下安装

```
yum install -y openssl-devel ncurses-devel gcc gcc-c++ unixODBC-devel wget vim lsof

wget http://www.rabbitmq.com/releases/erlang/erlang-19.0.4-1.el7.centos.x86_64.rpm
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/socat-1.7.2.2-5.el7.x86_64.rpm
wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.10/rabbitmq-server-3.6.10-1.el7.noarch.rpm

yum install -y *.rpm
```

#### 2.2登陆使用

```
echo '' >> /etc/profile
echo 'export PATH=$PATH:/usr/lib/rabbitmq/lib/rabbitmq_server-3.6.10/sbin' >> /etc/profile
echo '' >> /etc/profile

source /etc/profile

rabbitmq-plugins list
rabbitmq-plugins enable rabbitmq_management
rabbitmq-plugins list

service rabbitmq-server start

rabbitmqctl start_app

rabbitmqctl add_user admin admin
rabbitmqctl set_user_tags admin administrator
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"

lsof -i :15672

http://xxx.xxx.xxx.xxx:15672
admin
admin

vim /usr/lib/rabbitmq/lib/rabbitmq_server-3.6.10/ebin/rabbit.app
/loopback_users
```

#### 2.3集群配置

- 1.1配置`/etc/hosts`
```
xxx.xxx.xxx.xxx node1
xxx.xxx.xxx.xxx node2
xxx.xxx.xxx.xxx node3
```

- 2.1集群
```
在所有节点node1、node2、node3上：

pkill -u rabbitmq
cd /var/lib/rabbitmq
rm -rf *
rm -rf .erlang.cookie
service rabbitmq-server start

rabbitmqctl add_user admin admin
rabbitmqctl set_user_tags admin administrator
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"

在node2和node3上：

service rabbitmq-server stop
scp root@node1:/var/lib/rabbitmq/.erlang.cookie /var/lib/rabbitmq/.erlang.cookie
cp /var/lib/rabbitmq/.erlang.cookie ~/.erlang.cookie
rabbitmq-server -detached
rabbitmqctl stop_app
rabbitmqctl join_cluster --ram rabbit@node1
rabbitmqctl start_app

查看集群状态：
rabbitmqctl cluster_status

转换为RAM
rabbitmqctl stop_app
rabbitmqctl change_cluster_node_type ram
rabbitmqctl start_app

所有队列镜相复制
rabbitmqctl set_policy policy_1 "^" '{"ha-mode":"all","ha-sync-mode":"automatic"}'
```

- 3.1安装负载均衡器HAProxy，版本是haproxy-1.5.14-3.el7
```
yum install -y haproxy
```
- 3.2配置`/etc/haproxy/haproxy.cfg`
```
global
    log         127.0.0.1 local0 info

    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

    stats socket /var/lib/haproxy/stats

defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    #option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000

listen haproxy_web
    bind *:80
    stats uri /
    stats refresh 5s

listen rabbitmq_web
    bind *:15672
    server node1 node1:15672 check inter 5s rise 3 fall 3 weight 1
    server node2 node2:15672 check inter 5s rise 3 fall 3 weight 1
    server node3 node3:15672 check inter 5s rise 3 fall 3 weight 1

listen rabbitmq_cluster
    bind *:5672
    mode tcp
    option tcplog
    option clitcpka
    balance roundrobin
    server node1 node1:5672 check inter 5s rise 3 fall 3 weight 1
    server node2 node2:5672 check inter 5s rise 3 fall 3 weight 1
    server node3 node3:5672 check inter 5s rise 3 fall 3 weight 1
```
- 3.3启动HAProxy`service haproxy start`

- 4.1HAProxy状态页`http://xxx.xxx.xxx.xxx/`
- 4.2RabbitMQ管理页`http://xxx.xxx.xxx.xxx:15672/`
- 4.3连接RabbitMQ`admin admin xxx.xxx.xxx.xxx 5672`

## 3.测试步骤

### 3.1.场景1：单发送单接收

- 说明：无Exchange，无RoutingKey，生产者直接发送到队列，消费者直接取消息，设置Qos为0

```
./s1.sh
```

### 3.2.场景2：单发送多接收

- 说明：无Exchange，无RoutingKey，生产者直接发送到队列，多个消费者订阅队列直接取消息，设置Qos为1

```
./s2.sh
```

### 3.3.场景3：Publish/Subscribe

- 使用场景：发布、订阅模式，生产者发送广播fanout消息到RoutingKey，多个消费者订阅exchange内的消息，设置Qos为1

```
./s3.sh
```

### 3.4.场景4：Routing (按路线发送接收)

- 使用场景：生产者用direct模式，按RoutingKey把消息发送到Exchange，消费者按不同的RoutingKey接收消息。
- 测试时：RoutingKey个数等于消费者个数，生产者随机使用RoutingKey发送，每个消费者消费一个RoutingKey下的消息；

```
./s4.sh
```

### 3.5.场景5：Topics (按topic发送接收)

- 使用场景：生产者用topic模式，按"随机的RoutingKey"把消息发送到Exchange，消费者按"模式匹配的RoutingKey"接收消息。
- 测试时：RoutingKey个数等于消费者个数，每个消费者只设定一种"模式匹配的RoutingKey"；

```
./s5.sh
```
