#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)
#echo Client: $CLIENT
mkdir -p retrievals/$CLIENT

EPOCH=$(cat .retrieval-epoch)

if [ -z "$EPOCH" ]; then
  EPOCH=$(date -u +'%s')
  echo $EPOCH > .retrieval-epoch
fi

mkdir -p retrievals/$CLIENT-$EPOCH

TARGET_DIR=retrievals/$CLIENT-$EPOCH

grep -L Success $TARGET_DIR/wiki*.log | xargs rm -v

