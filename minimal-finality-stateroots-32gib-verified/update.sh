#! /bin/bash

CLIENT=$(./client.sh)
mkdir -p deals

./check.sh | tee ./deals/$CLIENT.txt
./check-count.sh
./quick-error-check.sh
./update-deals-json.sh
./write-retrieval-success-miners-json.sh
./write-retrieval-summary.sh
./update-deals-json.sh
./write-api-deal-statuses.sh
