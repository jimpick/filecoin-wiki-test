#! /bin/bash

N=$1
if [ -z "$N" ]; then
  echo "need num"
  exit 1
fi

for n in `seq 1 $N`; do
  echo '>>> Layer' $n ' Reset'
  ./reset-batch.sh
  echo '>>> Layer' $n ' Store 1'
  ./store-batch.sh
  echo '>>> Layer' $n ' Fix Errors'
  ./fix-errors.sh
  echo '>>> Layer' $n ' Store 2'
  ./store-batch.sh
  echo
done

