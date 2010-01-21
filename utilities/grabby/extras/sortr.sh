#!/bin/bash

TARGET_DIR="/tmp/cluster"
WEB_USER=www-data
WEB_GRP=www-data

if [ $# -ne 1 ]; then
	echo "Usage: `basename $0` raw_directory_name"
	exit 1 
fi

if [ ! -d ${TARGET_DIR} ]; then
	echo "Target directory not found, create manually"
	exit 1
fi

if [ -f /tmp/sortr_out ]; then 
	rm /tmp/sortr_out
	touch /tmp/sortr_out
fi

ls -1 ${1} | grep -v "sortr.sh" > /tmp/sortr_rawlist

cat /tmp/sortr_rawlist | while read RAW_ID
do

#DIR_ID=`echo ${RAW_ID} | sed 's/\([a-z]\).*/\1/'`
DIR_ID=`echo ${RAW_ID} | sed 's/\([A-Za-z0-9]\).*/\1/'`


if [ ! -d ${DIR_ID} ]; then
	mkdir -p ${TARGET_DIR}/${DIR_ID} 
fi

echo "	* copying ${RAW_ID} to ${TARGET_DIR}/${DIR_ID} - " >> /tmp/sort_out

echo -n "	* copying ${RAW_ID} to ${TARGET_DIR}/${DIR_ID}/ - "

chown -R ${WEB_USER}:${WEB_GRP} ${1}/${RAW_ID}
cp -Rp ${1}/${RAW_ID} ${TARGET_DIR}/${DIR_ID}/

echo "done"

done

exit 0
