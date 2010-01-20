#!/bin/bash

# usage: sumthing_sha1.sh DIRECTORY
# eg - sumthing_sha1.sh books

if [ $# -ne 1 ]; then
        echo "Usage: `basename $0` directory_name"
        exit 1
fi
if [ ! -d ${1} ]; then
        echo "Fail: directory ${1} not found"
        exit 1
fi

DATE=`date +%m%d%Y`

if [ ! -d sumthing_sha1-${DATE} ]; then
	mkdir sumthing_sha1-${DATE}
fi
if [ ! -f sumthing_sha1-${DATE}/fail ]; then
	touch sumthing_sha1-${DATE}/fail
else
	rm sumthing_sha1-${DATE}/fail
	touch sumthing_sha1-${DATE}/fail
fi
if [ ! -f sumthing_sha1-${DATE}/pass ]; then
	touch sumthing_sha1-${DATE}/pass
else
	rm sumthing_sha1-${DATE}/pass
	touch sumthing_sha1-${DATE}/pass
fi
if [ -f /tmp/sumbook_list ]; then
	rm /tmp/sumbook_list
fi
if [ -f /tmp/sumfile_list ]; then
	rm /tmp/sumfile_list
fi

ls -1 ${1}/ > /tmp/sumbook_list

echo "------------------------"
echo " Sumthing_sha1 starting"
echo "------------------------"
echo

######################################################################
cat /tmp/sumbook_list | while read BOOK_ID
do
echo "	-> Checking ${BOOK_ID} sha1 sums"

##################################################
ls -1 ${1}/${BOOK_ID} > /tmp/sumfile_list
cat /tmp/sumfile_list | while read FILE_ID
do

#echo -n "		* `echo ${FILE_ID} | cut -d"." -f2`"
echo -n "		* `echo ${FILE_ID} | cut -d"." -f2`"
#echo -n "		* ${FILE_ID}"
#echo $FILE_ID

if [ ! -f ${1}/${BOOK_ID}/${BOOK_ID}_files.xml ]; then
	echo "		* FAIL! can't find file ${1}/${BOOK_ID}/${BOOK_ID}_files.xml"
fi

OUR_SUMS=`sha1sum ${1}/${BOOK_ID}/${FILE_ID}`
OUR_SUM=`echo ${OUR_SUMS} | cut -d" " -f1`
#echo $OUR_SUM

#echo ${OUR_SUM} 
#echo ${1}/${BOOK_ID}/${FILE_ID}
#echo ${1}/${BOOK_ID}/${BOOK_ID}_files.xml

#grep_output="$(grep `sha1sum ${1}/${BOOK_ID}/${FILE_ID}` ${1}/${BOOK_ID}/${BOOK_ID}_files.xml)"
#grep_output="$(grep -i `sha1sum ${1}/${BOOK_ID}/${FILE_ID}` ${1}/${BOOK_ID}/${BOOK_ID}_files.xml)"
grep_output="$(grep ${OUR_SUM} ${1}/${BOOK_ID}/${BOOK_ID}_files.xml)"
echo -n "			  ${OUR_SUM} ..............."
#echo "			IA  ${OUR_SUM}"

#exit 0

#grep_output="$(grep ${OUR_SUM} ${1}/${BOOK_ID}/${BOOK_ID}_files.xml)"

#echo `cat $grep_output | cut -d" " -f1`

#exit 0

if [ -z "$grep_output" ]; then
	echo " [ FAIL! ]" 
	#echo "		* file ${FILE_ID} has failed the sha1 checksum, a note has been made in sumthing_sha1-${DATE}/fail"
	echo ${BOOK_ID}/${FILE_ID} >> sumthing_sha1-${DATE}/fail
else
	echo " [ OK ]" 
	echo ${BOOK_ID}/${FILE_ID} >> sumthing_sha1-${DATE}/pass 
fi

done
				       #
				       #
########################################

done
				                                                #
				                                                #
#################################################################################

rm /tmp/sumbook_list
rm /tmp/sumfile_list

echo
echo "------------------------"
echo " Sumthing_sha1 completed, results in sumthing_sha1-${DATE}"
echo "------------------------"

exit 0
