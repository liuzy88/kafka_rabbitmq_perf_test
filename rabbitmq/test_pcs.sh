#!/bin/bash

echo 'ps'

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
	$T -x1 -y$i -a
done

echo 'cs'

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
	$T -x$i -y1 -a
done
