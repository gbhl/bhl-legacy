#!/bin/bash
#
################################################################################
#
# File        	: grabby.sh
# Usage		: ./grabby.sh 
# Author      	: phil.cryer@mobot.org
# Date        	: 2009-10-10
# Source	: http://code.google.com/p/bhl-bits/
# Description 	: a generic bash script to perform batch downloads of Internet
#		  Archive (archive.org) materials, as listed in todo.txt
# Requires	: BASH, wget
#
################################################################################
#
# Copyright (c) 2009, Biodiversity Heritage Library
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
#
if [ ! -f "todo.txt" ]; then 
	echo "can't find todo.txt, fail"
	echo "define IA identifiers in todo.txt (one per line) and rerun"
	exit 0
fi 
clear
sum=0
num=1
echo " * Starting download..."
echo; echo "------------------------------------------------------"; echo
#
################################################################################
#
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

wget -p -c -nc -nH -nd -erobots=off -P${BOOK_ID} ${BASE_URL}

grep "${BOOK_ID}." ${BOOK_ID}/index.html | cut -d"<" -f4 | cut -d">" -f2 >> ${BOOK_ID}/xml_files_tmp

sed "s/  *$//;/^$/d" ${BOOK_ID}/xml_files_tmp > ${BOOK_ID}/xml_files_tmp2

cat ${BOOK_ID}/xml_files_tmp2 | sed s/^/http:\\/\\/archive.org\\/download\\/$BOOK_ID\\// > ${BOOK_ID}/download.urls

rm ${BOOK_ID}/index.html; rm ${BOOK_ID}/xml_files_tmp*

# manually grep out files, in this example, it will only list djvu.txt files
# otherwise limit by file prefix on the wget line below
#grep djvu.txt ${BOOK_ID}/download.urls > ${BOOK_ID}/download.urls-single
#mv ${BOOK_ID}/download.urls-single ${BOOK_ID}/download.urls

# download all related files (DEFAULT)
wget -p -c -i ${BOOK_ID}/download.urls -nc -nH -nd -erobots=off -P${BOOK_ID} ${BASE_URL}

# to limit downloads to only xml files
#wget -p -c -A '.xml' -i ${BOOK_ID}/download.urls -nc -nH -nd -erobots=off -P${BOOK_ID} ${BASE_URL}

# to limit downloads to only txt files
#wget -p -c -A 'txt' -i ${BOOK_ID}/download.urls -nc -nH -nd -erobots=off -P${BOOK_ID} ${BASE_URL}

rm ${BOOK_ID}/download.urls
echo " > Download of ${BOOK_ID} complete."
echo; echo "------------------------------------------------------"; echo
done
#
################################################################################
#
echo " > Download of all items complete."
rm current.status.txt
exit 0
