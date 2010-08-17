#!/bin/bash

# it's a howto! it's a syncing script! it's the first stab at the global bhl-sync!
# contact/blame: phil.cryer@mobot.org

###### SETUP ######
####new user/environment
## create user, add him to www-data group
# useradd --groups www-data bhl-sync
# passwd bhl-sync
## setup user's home directory
# mkdir /home/bhl-sync
# chown bhl-sync:bhl-sync /home/bhl-sync
## change over to do the rest as user
# su - bhl-sync
## generate SSH key
# ssh-keygen -b 2048 -f ~/.ssh/id_rsa -P ''
## copy SSH key to remote host
# ssh-copy-id bhl-sync@remote.host
# ssh-copy-id '-p 6666 bhl-sync@whbhl01.ubio.org'
## test to see if you can SSH w/o password
# ssh -p 6666 bhl-sync@whbhl01.ubio.org

###### USAGE ######
#### the raw rsync commands to call if you aren't using lscynd and just want to use cron
## Woods Hole (whbhl01.ubio.org)
/usr/bin/rsync -av -e "ssh -p 6666"  /var/www/bhl-sync/ bhl-sync@whbhl01.ubio.org:/var/www/bhl-sync/

## London (cld-demeter.nhm.ac.uk)
#/usr/bin/rsync -av -e "ssh -p 22"  /var/www/bhl-sync/ bhl-sync@cld-demeter.nhm.ac.uk:/gpfs/bhlfsa/apache/docroot/sync_test/

###### CHECK ######
#### View results in St. Louis
#http://mbgserv18.mobot.org/bhl-sync/

#### View results in Woods Hole
#http://whbhl01.ubio.org/bhl-sync/

#### View results in London 
# http://cld-demeter.nhm.ac.uk:/gpfs/bhlfsa/apache/docroot/sync_test/ ??


###### SETUP - server ###### 
#### Use this setup to go the lsyncd route
## Install required packages
# su - root
# apt-get install libxml2-dev build-essential rsync
# exit

## Download, compile and install lsyncd
# wget http://lsyncd.googlecode.com/files/lsyncd-1.37.tar.gz
# tar -zxf lsyncd-*
# cd lsyncd-*
# ./configure; make
# su - root
# make install

## Configure lsyncd
# cp lsyncd.conf.xml /etc/
# vi /etc/lsyncd.conf.xml
#	(see contents below)

#run (as root) in screen like this:
# su - bhl-sync -c "lsyncd --conf /etc/lsyncd.conf.xml"

exit 0

# cat /etc/lsyncd.conf.xml
<lsyncd version="1">

<settings>
	<debug/> 
	<no-daemon/> 
	<logfile      filename="/var/log/lsyncd"/> 
	<binary       filename="/usr/bin/rsync"/> 
	<callopts> 
		<option text="-lt%rO"/> 
		<!--<option text="-av"/>--> 
		<option text="--rsh=ssh -p 6666 -l bhl-sync"/> 
		<exclude-file/> 
		<source/> 
		<destination/> 
		</callopts> 
</settings>

<directory> 
	<source path="/var/www/bhl-sync/"/> <
	<target path="whbhl01.ubio.org:/var/www/bhl-sync/"/> 
</directory>

</lsyncd>
