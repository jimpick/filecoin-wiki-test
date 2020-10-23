#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)

count=0
total=`ls wiki*.zip.??.?? | wc -l`
for f in wiki*.zip.??.??; do
	echo $f $((++count)) of $total
	lotus client import $f | tee $f.$CLIENT.import
	cat $f.import | sed 's,^.*Root ,,' > $f.cid
done
