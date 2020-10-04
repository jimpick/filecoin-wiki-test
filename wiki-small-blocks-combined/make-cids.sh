#! /bin/bash

for f in `ls ../../wiki-ipfs/wiki*.car`; do echo $f; BASE=$(echo $f | sed 's,^.*wiki-ipfs/\(wiki.*\)\..*\.car,\1,'); echo $BASE; CID=$(echo $f | sed 's,^[^Q]*\(Q.*\)\.car,\1,'); echo $CID; echo $CID > $BASE.cid; done

