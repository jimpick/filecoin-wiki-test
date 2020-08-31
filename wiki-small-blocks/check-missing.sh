#! /bin/bash

for f in wiki.zip.??.??.cid; do
	base=$(echo $f | sed 's,\.cid,,')
	if [ ! -f $base.t08106.import ]; then
		echo $base
	fi
done
#wiki.zip.aa.aa.t03296.import
#wiki.zip.aa.aa.t08106.import
