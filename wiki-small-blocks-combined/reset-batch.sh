#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)

for f in ls *.cid; do
	BASE=$(echo $f | sed 's,\.cid$,,')
	rm -vf $BASE.$CLIENT.deal
done
