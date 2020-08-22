#! /bin/bash

rsync -vaP --exclude '*.bin' --exclude '*.zip.??' --exclude '*.zip.??.??' --delete --delete-excluded lotus1:~/filecoin-wiki-test/wiki-large-blocks .
rsync -vaP --exclude '*.bin' --exclude '*.zip.??' --exclude '*.zip.??.??' --delete --delete-excluded lotus1:~/filecoin-wiki-test/wiki-small-blocks .
