#! /bin/bash

for f in ~/wiki-ipfs/wiki.[0-9][0-9].*.car; do echo $f; lotus client import --car $f; done

