#! /bin/bash

HEIGHT=$(lotus chain getblock `lotus chain head | head -1` | jq .Height)

#git restore-mtime --force *.deal

for dealFile in `ls *.deal`; do
  delete=false
  PROPOSAL=$(cat $dealFile)
  echo $dealFile $PROPOSAL
  CLIENT=$(echo $dealFile | sed -E 's,^wiki\.[0-9]+\.([^.]+)\..*,\1,')
  #echo $CLIENT
  #grep $PROPOSAL list-deals/$CLIENT.txt
  DEALID=$(grep $PROPOSAL list-deals/$CLIENT.txt | awk '{ print $5 }')
  #echo "DealID: $DEALID (Current Height: $HEIGHT)"
  if [ $DEALID -gt 0 ]; then
    STATE=$(lotus state get-deal $DEALID 2>&1)
    if echo $STATE | grep 'ERROR' > /dev/null; then
      delete=true
    fi
  else
    delete=true
  fi
  if [ "$delete" = "true" ]; then
    if test $(find $dealFile -mtime +7); then
      echo "Deleting $dealFile"
      git rm $dealFile
    else
      echo "Not deleting $dealFile - under 7 days old"
    fi
  fi
done
