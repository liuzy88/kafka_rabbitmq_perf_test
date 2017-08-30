#!/bin/bash

echo "非持久化非自动ACK"

for i in 1 2 3; do
	$T -x$i -y$i
done

echo "持久化非自动ACK"

for i in 1 2 3; do
	$T -x$i -y$i -f persistent
done

echo "持久化自动ACK"

for i in 1 2 3; do
	$T -x$i -y$i -f persistent -a
done

echo "非持久化自动ACK"

for i in 1 2 3; do
	$T -x$i -y$i -a
done