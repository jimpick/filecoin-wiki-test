#! /bin/bash

find retrievals/ -name 'wiki.zip.??.??' | tr '\-./' '   ' | awk '{print $5 }' | sort | uniq
