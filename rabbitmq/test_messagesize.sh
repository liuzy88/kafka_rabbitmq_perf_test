#!/bin/bash

echo 'messsagesize'

for i in 100 200 400 600 800 1000 2000 4000 6000 8000 10000; do
	$T -x9 -y9 -a -s $i
done
