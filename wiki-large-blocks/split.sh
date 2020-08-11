#! /bin/bash

split -b 264241152 ../wiki.zip wiki.zip. # 152MiB
#split -b 132120576 ../wiki.zip wiki.zip. # 126MiB
#split -a 3 -b 1000000 ../wiki.zip wiki.zip. # 1MiB
