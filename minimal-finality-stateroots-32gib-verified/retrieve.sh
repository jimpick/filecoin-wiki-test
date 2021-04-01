#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)
echo Client: $CLIENT

EPOCH=$(cat .retrieval-epoch)

if [ -z "$EPOCH" ]; then
  EPOCH=$(date -u +'%s-%N')
  echo $EPOCH > .retrieval-epoch
fi

mkdir -p retrievals/$CLIENT-$EPOCH

TARGET_DIR=retrievals/$CLIENT-$EPOCH

grep -l 'ERROR: dial tcp 0.0.0.0:1234: connect: connection refused' $TARGET_DIR/minimal_*.log | xargs rm -f

stdbuf -oL -eL ./retrieve-worker.sh $TARGET_DIR 2>&1 | ts | tee -a $TARGET_DIR/retrieval-$(date -u +'%s-%N').log


