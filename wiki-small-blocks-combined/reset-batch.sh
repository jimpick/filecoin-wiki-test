#! /bin/bash

CLIENT=$(lotus state lookup `lotus wallet default`)

rm -f wiki.zip.??.??.$CLIENT.deal
