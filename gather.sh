#!/usr/bin/env bash

## vars
logFile="/var/log/auth.log"
grepString="Received disconnect from "
timeString=`date +'%b %d %H'`
dateString=`date +'%b %d'`
hour=`date +'%H'`
outFile="$hour-failed.txt"
# cat auth.log | grep "Apr 23" | grep "Received disconnect from " | awk '{print $9}'  > "$hour"-$outFile

## Functions
removeWhitelist(){

  mv gathered.txt tmp.txt
  cat tmp.txt | grep -v 10.* | grep -v 192.* | grep -v 172.* > gathered.txt
  rm tmp.txt
}

combine(){

  cat "$outFile" > tmp.txt
  cat gathered.txt >> tmp.txt

  cat tmp.txt | sort | uniq > gathered.txt

  rm tmp.txt

}
## work

cat $logFile | grep "$timeString" | grep "$grepString" | awk '{ print $9}' | sort | uniq > "$outFile"

combine

removeWhitelist

git add gathered.txt
git commit -m "$timeString"
git push
# git fetch
# git checkout master -- gathered.txt > fetched.txt
