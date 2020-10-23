#! /bin/bash

find retrievals/ -name 'wiki*.log' | xargs grep Success -l | tr '\-.' ' ' | awk '{print $4}' | jq -R '[inputs]' > ./retrievals/retrieval-success-miners.json
cat ./retrievals/retrieval-success-miners.json

