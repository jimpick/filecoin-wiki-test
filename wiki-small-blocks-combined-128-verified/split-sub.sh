#! /bin/bash

#split -b 264241152 ../wiki.zip wiki.zip. # 152MiB
#split -b 132120576 ../wiki.zip wiki.zip. # 126MiB
#split -a 3 -b 1000000 ../wiki.zip wiki.zip. # 1MiB
for b in `ls ../wiki-large-blocks/wiki.zip.??`; do
  echo $b
  SUFFIX=$(echo $b | sed 's,^.*\.,,')
  split -b 5000000 $b wiki.zip.$SUFFIX. # 5MiB
done
