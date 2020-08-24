#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)
echo Client: $CLIENT
mkdir -p retrievals/$CLIENT

./retrieve-worker.sh 2>&1 | tee -a retrievals/$CLIENT/retrieval.log


