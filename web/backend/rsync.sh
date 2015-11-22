#!/bin/bash

File="restful.pl"
FixFile="restful_fix.pl"
while :
do
    #a="rsync -av `pwd`/$FixFile `pwd`/$File"
    #"$a|grep restful_fix.pl"
    perl $File &
    sleep 5
    id=`ps aux |grep 'restful.pl'|awk '{print $2}'`
    kill $id|awk '{print $1}'
done
