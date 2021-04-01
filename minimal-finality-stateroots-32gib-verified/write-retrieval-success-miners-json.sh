#! /bin/bash

find retrievals/ -name 'minimal*.log' | xargs grep Success -l | tr '\-.' ' ' | awk '{print $10}' | sort | uniq | jq -R '[inputs]' > ./retrievals/retrieval-success-miners.json
cat ./retrievals/retrieval-success-miners.json

