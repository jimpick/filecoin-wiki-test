#! /bin/bash


CLIENT=$(./client.sh)

WORKDIR=$(mktemp -d -t blaster-imports.XXXXXXX)
function cleanup {
  if [ -d "$WORKDIR" ]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

lotus client local 2> /dev/null > $WORKDIR/local.txt
#3886: bafykbzaceankbh6mg7ykjvgvmdv6honjllswe7f7efdebymgafxx5dn3nrprw @/home/ubuntu/filecoin-wiki-test/wiki-small-blocks/wiki.zip.an.ac (import)

cat $WORKDIR/local.txt | sed -n 's,^\([0-9]*\): bafy.* @\(\/home.*\) (import)$,\1_\2,p' > $WORKDIR/files.txt
for f in `cat $WORKDIR/files.txt`; do
	#echo $f
	NUM=$(echo $f | sed 's,_.*,,')
	FILE=$(echo $f | sed 's,.*_,,')
	if [ ! -f "$FILE" ]; then
		echo $NUM $FILE
		lotus client drop $NUM
	fi
done
