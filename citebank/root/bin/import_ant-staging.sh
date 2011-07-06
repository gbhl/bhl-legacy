#!/bin/bash

#mv /home/transfer/* /var/www/staging.citebank.org/sites/default/files; chown -R www-data:www-data /var/www/staging.citebank.org/sites/default/files/*

#exit 0

SRC_DIR="/home/transfer-staging"
#FILE_TYPES="*.pdf | *.csv"
#FILE_TYPES=".pdf|.csv"
FILE_TYPES="*"
#TARGET_DIR="/var/www/staging.citebank.org/sites/default/files"
TARGET_DIR="/var/www/staging.citebank.org/sites/default/files"
TARGET_USER="www-data"
TARGET_GROUP="www-data"

#find ${SRC_DIR} -name "${FILE_TYPES}" | xargs mv ${TARGET_DIR}
find ${SRC_DIR} -type f -mmin +5 -exec mv {} ${TARGET_DIR} \;
#mv ${SRC_DIR}/* ${TARGET_DIR}
chown -R ${TARGET_USER}:${TARGET_GROUP} ${TARGET_DIR}

exit 0
