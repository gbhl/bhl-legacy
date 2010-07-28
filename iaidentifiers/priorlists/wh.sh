#!/bin/bash

FILE=201003.txt
FILE2=200910.txt

cat $FILE | while read a
do
	if grep $a $FILE2 ; then echo "id found in $FILE2"; else echo $a >> missing.txt ;fi
done

exit 0
