#! /bin/bash

for f in a b c d e f g h i j k l m n; do echo $f; ls a$f; CID=`ipfs add -r a$f | tail -1 | awk '{ print $2 }'`; echo $CID; ipfs dag export $CID > ../wiki.a$f.$CID.car; done
