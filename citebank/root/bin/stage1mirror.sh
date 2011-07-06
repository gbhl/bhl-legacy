#!/bin/bash

export START=`date "+%Y-%m-%d%n"`

export DOCROOT="/var/www/citebank.org"
export DOCROOT_NEW="/var/www/staging.citebank.org"
export DB="citebank"
export TEMP_DIR="/tmp/prod_staging_$START"
export www_user="www-data"
export www_group="www-data"

#note: mysql user/pass stored in ~/.my.cnf

clear; echo "----------------------"
echo " stage1mirror ftw"
echo "----------------------"

echo -n "  * create temp directories..."
if [ ! -d $TEMP_DIR ]; then
        mkdir -p $TEMP_DIR
else
        rm -rf $TEMP_DIR/*
fi
echo "done"

echo -n "  * creating new www directory..."
if [ ! -d $DOCROOT_NEW ]; then
        mkdir -p $DOCROOT_NEW
else
        rm -rf $DOCROOT_NEW/*
fi
cp -Rp $DOCROOT/* $DOCROOT_NEW
cp -Rp $DOCROOT/.htaccess $DOCROOT_NEW
echo "done"

echo -n "  * new www directory size is..."
echo "`du -hc $DOCROOT_NEW | tail -n1 | cut -d"t" -f1`"

echo -n "  * creating www timestamp..."
echo `date "+%H:%M:%S %Y-%m-%d%n"` > $DOCROOT_NEW/www_migrated_from_prod
echo "use Solr Stage instance 172.16.16.238:8983" >> $DOCROOT_NEW/www_migrated_from_prod
echo "done"

echo -n "  * reloading the mysql database..."
/etc/init.d/mysql restart
sleep 1

echo -n "  * making a hotcopy of prod database..."
mysqlhotcopy -u root -p p@ncak3s! --allowold -q $DB 
#mysqldump -u root -p'p@ncak3s!' citebank > citebank_backup.sql
echo "done"

echo -n "  * creating db timestamp..."
echo `date "+%H:%M:%S %Y-%m-%d%n"` > $DOCROOT_NEW/db_migrated_from_prod
echo "done"

echo -n "  * updating settings.php..."
cd $DOCROOT_NEW/sites/default
for f in settings.php; do sed 's/citebank/citebank_copy/g' $f > $f.new && mv $f.new $f; done
echo "done"

echo -n "  * setting permissions on new www directory..."
chown -R $www_user:$www_group $DOCROOT_NEW
echo "done"

echo -n "  * refreshing caches..."
/etc/init.d/varnish force-reload
/etc/init.d/apache2 reload
/etc/init.d/memcached restart
/etc/init.d/nginx restart
echo "done"

exit 0
