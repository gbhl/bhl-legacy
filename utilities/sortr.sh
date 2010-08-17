#!/bin/bash

if [ $# -ne 2 ]; then
        echo "Usage: `basename $0` base_dir instance_num"
        exit 1
fi
if [ ! -d ${1} ]; then
        echo "Fail: directory ${1} not found"
        exit 1
fi

BASE_DIR=${1}
DEST_DIR="/mnt/glusterfs/www"
DEST_USER="www-data"
DEST_GROUP="www-data"
BASE_NUM=`ls -l ${1} | wc -l`
sum=0; num=1
START_TIME=`date "+%H:%M:%S %Y-%m-%d%n"`
PUID=`date +%s-${2}`

ls -1 ${1} | while read NAME
	do
        sum=$(($sum + $num))
        DEST_LETTER=`echo $NAME|nawk '{print substr($NAME,1,1)}'`
        #echo " [ $sum/$BASE_NUM ] Copying $NAME into $DEST_DIR/$DEST_LETTER ... " >>$0.$PUID 2>&1
        #echo " [ $sum/$BASE_NUM ] Copying $NAME into $DEST_DIR/$DEST_LETTER ... "
        echo " [ $sum/$BASE_NUM ] Syncing $NAME with $DEST_DIR/$DEST_LETTER ... " >>$0.$PUID 2>&1
        echo " [ $sum/$BASE_NUM ] Syncing $NAME with $DEST_DIR/$DEST_LETTER ... "
        cp -R $BASE_DIR/$NAME $DEST_DIR/$DEST_LETTER/ >>$0.$PUID 2>&1
        #mv -f $BASE_DIR/$NAME $DEST_DIR/$DEST_LETTER/ >>$0.$PUID 2>&1
        #rsync -ave $BASE_DIR/$NAME $DEST_DIR/$DEST_LETTER/ >>$0.$PUID 2>&1
        chown -R $DEST_USER:$DEST_GROUP $DEST_DIR/$DEST_LETTER/$NAME >>$0.$PUID 2>&1
        chmod -R 755 $DEST_DIR/$DEST_LETTER/$NAME >>$0.$PUID 2>&1
done 

echo "" >> $0.$PUID 2>&1
echo -n " Number of possible errors: " >> $0.$PUID 2>&1
echo "`grep cannot $0.$PUID | wc -l`" >> $0.$PUID 2>&1

exit 0
