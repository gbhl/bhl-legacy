#!/bin/bash
#
################################################################################
#
# File        	: grabby.sh
# Usage		: ./grabby.sh 
# Author      	: phil.cryer@mobot.org
# Date created  : 2009-10-10
# Last updated  : 2010-01-01
# Source	: http://code.google.com/p/bhl-bits/utilities/grabby
# Description 	: a bash script to perform batch downloads of Internet Archive
#		  (archive.org) materials, via record ids as listed in todo.txt
# Requires	: Bash, wget
# (optional)    : fast/stable internet connection, paitience, sense of humor
#
################################################################################
#
# Copyright (c) 2010, Biodiversity Heritage Library
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met: 
#
# Redistributions of source code must retain the above copyright notice, this 
# list of conditions and the following disclaimer. Redistributions in binary 
# form must reproduce the above copyright notice, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided with
# the distribution. Neither the name of the Biodiversity Heritage Library nor 
# the names of its contributors may be used to endorse or promote products 
# derived from this software without specific prior written permission. THIS
# SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
################################################################################
# More information about the BSD License can be found here:
# http://www.opensource.org/licenses/bsd-license.php
################################################################################
#
########################################
# Check todo, set time, make directory
########################################
if [ ! -f "todo.txt" ]; then 
	echo "can't find todo.txt, fail"
	echo "define IA identifiers in todo.txt (one per line) and rerun"
	exit 0
fi 
clear
sum=0
num=1
START_TIME=`date "+%H:%M:%S %Y-%m-%d%n"`
echo "Starting download at ${START_TIME}" 
echo "------------------------------------------------------"
START=`date +%s`
PUID=${2-${START}}
COMPLETE_DIR=complete.${PUID}
if [ ! -d ${COMPLETE_DIR} ]; then
	mkdir ${COMPLETE_DIR}
fi
MANIFEST=00_manifest.${PUID}
#
########################################
# Inventory do/done downloads
########################################
mv todo.txt  ${COMPLETE_DIR}
cd ${COMPLETE_DIR}
cat todo.txt | while read BOOK_ID
do
BASE_URL="http://archive.org/download/${BOOK_ID}"
sum=$(($sum + $num))
echo -n "$sum" > current.status.txt "of "
TOTAL=`cat todo.txt | wc -l` 
echo ${TOTAL} >> current.status.txt
echo "title: ${BOOK_ID}" >> current.status.txt
echo -n " [ `head -n1 current.status.txt` ]	Title: ${BOOK_ID}"; echo
if [ -d "${BOOK_ID}" ]; then
	echo "	- Existing data found, continuing previous download..."
	if [ -f "${BOOK_ID}/index.html" ]; then 
		rm ${BOOK_ID}/index.html 
	fi 
fi
#
########################################
# Build download list
########################################
wget -p -c -nc -nH -nd -erobots=off -P${BOOK_ID} ${BASE_URL}
grep "<a href=" ${BOOK_ID}/index.html | grep ${BOOK_ID} | grep -v "<h1" | cut -d">" -f1 | cut -d"\"" -f2 >> ${BOOK_ID}/xml_files_tmp
cat ${BOOK_ID}/xml_files_tmp | sed s/^/http:\\/\\/archive.org\\/download\\/$BOOK_ID\\// > ${BOOK_ID}/download.urls
rm ${BOOK_ID}/index.html; rm ${BOOK_ID}/xml_files_tmp*
#
########################################
# Download files
########################################
# download all related files (DEFAULT)
wget -p -c -i ${BOOK_ID}/download.urls -nc -nH -nd -erobots=off -P${BOOK_ID} ${BASE_URL}
# Notice: by default we now download every file related to the record id
# if you want to limit this, manually grep out files here. in this example,
# it will only djvu.txt files -  otherwise limit by file prefix on the wget line below
#grep djvu.txt ${BOOK_ID}/download.urls > ${BOOK_ID}/download.urls-single
#mv ${BOOK_ID}/download.urls-single ${BOOK_ID}/download.urls
# or to limit downloads to only xml files
#wget -p -c -A '.xml' -i ${BOOK_ID}/download.urls -nc -nH -nd -erobots=off -P${BOOK_ID} ${BASE_URL}
#
########################################
# Clean up download directory
########################################
rm ${BOOK_ID}/download.urls
if [ -f "${BOOK_ID}/index.html" ]; then 
	rm ${BOOK_ID}/index.html 
fi 
#mv ${BOOK_ID} ${COMPLETE_DIR}
echo "Download of ${BOOK_ID} complete."
done
#
########################################
# Summarize downloads, time, etc
########################################
TOTAL_DATA=`du -hc | tail -n1`
TOTAL_BOOKS=`cat current.status.txt | head -n1 | cut -d" " -f3`
END_TIME=`date "+%H:%M:%S %Y-%m-%d%n"`
rm current.status.txt
mv ${COMPLETE_DIR}/todo.txt ${COMPLETE_DIR}/00_download.${PUID}
cd ..
echo "------------------------------------------------------" > ${COMPLETE_DIR}/${MANIFEST}
echo "Start time		${START_TIME}" >> ${COMPLETE_DIR}/${MANIFEST}
echo "Finish time		${END_TIME} " >> ${COMPLETE_DIR}/${MANIFEST}
echo "Data transfered		${TOTAL_DATA}" >> ${COMPLETE_DIR}/${MANIFEST}
echo "Books transfered		${TOTAL_BOOKS}" >> ${COMPLETE_DIR}/${MANIFEST}
echo "------------------------------------------------------" >> ${COMPLETE_DIR}/${MANIFEST}
for f in $( ls ${COMPLETE_DIR} | grep -v ${MANIFEST} ); do echo $f >> ${COMPLETE_DIR}/${MANIFEST}; done
echo "------------------------------------------------------"
echo "Start time		${START_TIME}"
echo "Finish time		${END_TIME} "
echo "Data transfered		${TOTAL_DATA}"
echo "Books transfered		${TOTAL_BOOKS}"
echo "------------------------------------------------------"
FINISH=`date +%s`
ELAPSED=`expr $FINISH - $START`
echo "------------------------------------------------------" >> ${COMPLETE_DIR}/${MANIFEST}
echo "Total download time: ${ELAPSED} seconds"
echo "Total download time: ${ELAPSED} seconds" >> ${COMPLETE_DIR}/${MANIFEST}
echo "Files downloaded to: ${COMPLETE_DIR}"
exit 0
