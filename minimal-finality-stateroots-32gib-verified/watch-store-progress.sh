#! /bin/bash

watch 'grep candidate ~/workshop-client-mainnet/src/annotations-mainnet-128mib-verified.js | wc -l ; DONE=$(./parse-git-deal-candidates.sh | wc -l); echo $DONE; SKIP=$(ls skip-miners/ | wc -l); echo $SKIP; echo $((DONE + SKIP)); lotus wallet balance; lotus state market balance `lotus wallet default`
'
