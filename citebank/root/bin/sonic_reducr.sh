#!/bin/bash
# for this script we don't want " " as a separator
# so we don't confuse mv with "multiple arguments"
# while we're at it, make upper case lower case, rename things like [] ~ ! to "_" too

# to run it on a dir and have it auto rename all the files..
# find . -depth -exec ~/bin/sonic_reducr.sh {} \;

IFS=$'\n'

name=$1
newname=$name

# check for, and replace upper case letters if applicable
echo $name | grep -e [[:upper:]+]  > /dev/null
if [ "$?" = "0" ]
then
    newname=`echo $name |tr [:upper:] [:lower:]`
fi

# check for and delete leading spaces
echo $newname | egrep "^ +" > /dev/null
if [ "$?" = "0" ]
then
    newname=`echo $newname  |  sed "s/ *//"`
fi

# check for and delete leading spaces as presented by find
echo $newname | egrep "\./ +" > /dev/null
if [ "$?" = "0" ]
then
    newname=`echo $newname | egrep "\.\/ +" | sed "s/  *//" `
fi

# check for and delete trailing spaces
echo $newname | egrep " $" > /dev/null
if [ "$?" = "0" ]
then
    newname=`echo $newname  |  sed "s/  *$//"`
fi

# check for and delete other non-welcome characters
echo $newname | grep [\(\)\&\'\!]  > /dev/null
if [ "$?" = "0" ]
then
    newname=`echo $newname | sed "s/[\(\)\&\'\!]/_/g" `
fi

# check for and replace all other spaces with "_"
echo $newname | egrep " " > /dev/null
if [ "$?" = "0" ]
then
    newname=`echo $newname  |  sed "s/ /_/g"`
fi

# should we have generated a caravan of underscores
# this should take care of it
echo $newname | egrep "_+" > /dev/null
if [ "$?" = "0" ]
then
    newname=`echo $newname  |  sed "s/__*/_/g"`
fi

# "_-_" ... another artefact to be taken care of
echo $newname | grep "_-_" > /dev/null
if [ "$?" = "0" ]
then
    newname=`echo $newname  |  sed "s/_-_/_/g"`
fi


# if there were modifications, commit them
if [ "$name" != "$newname" ]
then
    echo "moving " $name $newname
    mv "$name" "$newname"
fi

echo $newname

exit 0
