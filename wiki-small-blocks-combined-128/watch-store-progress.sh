#! /bin/bash

watch 'grep candidate ~/workshop-client-testnet/src/annotations-spacerace-slingshot-medium.js | wc -l ; ./parse-git-deal-candidates.sh | wc -l; ls skip-miners/ | wc -l'
