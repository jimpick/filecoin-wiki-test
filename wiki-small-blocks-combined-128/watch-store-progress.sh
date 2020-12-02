#! /bin/bash

watch 'grep candidate ~/workshop-client-testnet/src/annotations-spacerace-slingshot-medium.js | wc -l ; DONE=$(./parse-git-deal-candidates.sh | wc -l); echo $DONE; SKIP=$(ls skip-miners/ | wc -l); echo $SKIP; echo $((DONE + SKIP)); lotus wallet balance; lotus state market balance `lotus wallet default`
'
