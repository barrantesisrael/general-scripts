#!/usr/bin/env bash
# getallmd5.sh -- generates a table of MD5 sums of all files and directories under the current dir
# 2016-02-24 isradelacon@gmail.com
# echo -e "name|type|size|MD5|description"
for id in * ; do
    if [[ -d $id ]]
    then
  	echo -en "\`$id\`|dir|"
	du -h $id | tail -n1 | cut -f1 | awk '{printf $0}'
	# source http://stackoverflow.com/questions/1657232/how-can-i-calculate-an-md5-checksum-of-a-directory
    	find ./$id -type f -name "*" -exec md5sum {} + 2>/dev/null | awk '{print $1}' | sort | md5sum | sed 's/ .*//g;' | awk '{print "|"$1"|"}'
    else
    	echo -en "\`$id\`|file|"
	du -h $id | tail -n1 | cut -f1 | awk '{printf $0}'
	md5sum $id | awk '{print "|"$1"|"}'
    fi
done

