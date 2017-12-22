#!/bin/bash

# 生成服务器keystore(密钥和证书)
keytool -keystore server.keystore.jks -alias ka1 -validity 365 -keyalg RSA -storepass 123123 -keypass 123123 -genkey -dname "C=CN,L=ShangHai,O=Unionpay,OU=newtech,CN=Kafka1"
# 生成客户端keystore(密钥和证书)
keytool -keystore client.keystore.jks -alias ka1 -validity 365 -keyalg RSA -storepass 123123 -keypass 123123 -genkey -dname "C=CN,L=ShangHai,O=Unionpay,OU=newtech,CN=Client"
# 创建CA证书
openssl req -new -x509 -keyout ca.key -out ca.crt -days 365 -passout pass:123123 -subj "/C=CN/L=ShangHai/O=Unionpay/OU=newtech/CN=CA"
# 将CA证书导入到服务器truststore
keytool -keystore server.truststore.jks -alias CARoot -import -file ca.crt -storepass 123123
# 将CA证书导入到客户端truststore
keytool -keystore client.truststore.jks -alias CARoot -import -file ca.crt -storepass 123123
# 导出服务器证书
keytool -keystore server.keystore.jks -alias ka1 -certreq -file cert-file -storepass 123123
keytool -keystore client.keystore.jks -alias ka1 -certreq -file client-cert-file -storepass 123123
# 用CA证书给服务器证书签名
openssl x509 -req -CA ca.crt -CAkey ca.key -in cert-file -out cert-signed -days 365 -CAcreateserial -passin pass:123123
openssl x509 -req -CA ca.crt -CAkey ca.key -in client-cert-file -out client-cert-signed -days 365 -CAcreateserial -passin pass:123123
# 将CA证书导入服务器keystore
keytool -keystore server.keystore.jks -alias CARoot -import -file ca.crt -storepass 123123
keytool -keystore client.keystore.jks -alias CARoot -import -file ca.crt -storepass 123123
# 将已签名的服务器证书导入服务器keystore
keytool -keystore server.keystore.jks -alias ka1 -import -file cert-signed -storepass 123123
keytool -keystore client.keystore.jks -alias ka1 -import -file client-cert-signed -storepass 123123
