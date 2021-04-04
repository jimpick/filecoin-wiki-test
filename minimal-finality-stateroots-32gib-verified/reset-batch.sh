#! /bin/bash

CLIENT=$(./client.sh)

for f in ls *.cid; do
	BASE=$(echo $f | sed 's,\.cid$,,')
	rm -vf $BASE.$CLIENT.deal
done
