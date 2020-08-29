#! /bin/bash

N=$1
if [ -z "$N" ]; then
  echo "need num"
  exit 1
fi

for n in `seq 1 $N`; do
  echo '>>> Layer' $n ' Store 1'
  ./store-batch-0-active.sh
  echo '>>> Layer' $n ' Reset'
  ./reset-batch.sh
  echo
done

