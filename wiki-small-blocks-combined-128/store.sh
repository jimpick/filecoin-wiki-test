#! /bin/bash

mkdir -p store-logs

./store-batch-worker.sh 2>&1 | tee -a store-logs/store-$(date -u +'%s').log


