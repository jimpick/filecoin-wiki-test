#! /bin/bash

#rsync -vanP --exclude '*.bin' --exclude '*.zip.??' calibration-0:~/tmp/wiki-large-blocks/* wiki-large-blocks
rsync -vaP --exclude '*.bin' --exclude '*.zip.??' --delete --delete-excluded calibration-0:~/tmp/wiki-large-blocks .
