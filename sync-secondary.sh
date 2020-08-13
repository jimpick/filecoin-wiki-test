#! /bin/bash

rsync -vaP --exclude '*.bin' --exclude '*.zip.??' --delete --delete-excluded calibration-1:~/tmp/filecoin-wiki-test/wiki-large-blocks/retrievals/*secondary* wiki-large-blocks/retrievals 
