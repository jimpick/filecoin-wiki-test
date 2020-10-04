#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)
echo Client: $CLIENT

EPOCH=$(cat .retrieval-epoch)

if [ -z "$EPOCH" ]; then
  EPOCH=$(date -u +'%s')
  echo $EPOCH > .retrieval-epoch
fi

mkdir -p retrievals/$CLIENT-$EPOCH

TARGET_DIR=retrievals/$CLIENT-$EPOCH

./retrieve-worker.sh $TARGET_DIR 2>&1 | tee -a $TARGET_DIR/retrieval-$(date -u +'%s').log



