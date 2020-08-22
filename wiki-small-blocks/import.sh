#! /bin/bash

count=0
total=`ls wiki*.zip.??.?? | wc -l`
for f in wiki*.zip.??.??; do
	echo $f $((++count)) of $total
	lotus client import $f | tee $f.import
	cat $f.import | sed 's,^.*Root ,,' > $f.cid
done
