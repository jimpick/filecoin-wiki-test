#! /bin/bash

rsync -vaP --exclude '*.bin' --exclude '*.zip.??' --delete --delete-excluded lotus1:~/filecoin-wiki-test/wiki-large-blocks .
