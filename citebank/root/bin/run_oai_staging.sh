if [ $# -ne 1 ]; then
	echo "Usage: `basename $0` <instance number>"
	exit 1
fi

#SITE="citebank.org"
SITE="staging.citebank.org"

#echo "--OAI Harvester--[ `date +"%d/%b/%Y:%H:%M:%S %Z"` ]--started--${SITE}/${0}--" >> /var/log/apache2/${SITE}.access.log
echo "--OAI Harvester--[ `date +"%d/%b/%Y:%H:%M:%S %Z"` ]--started--${SITE}/${1}--" >> /var/log/apache2/${SITE}.access.log

cd /var/www/${SITE}
#/opt/drush/drush -l ${SITE} php-script oai_${1}
/opt/drush/drush -l ${SITE} php-script oai_x_${1}

echo "--OAI Harvester--[ `date +"%d/%b/%Y:%H:%M:%S %Z"` ]---ended---${SITE}/${1}--" >> /var/log/apache2/${SITE}.access.log

exit 0
