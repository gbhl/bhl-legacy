#!/bin/bash
cd /var/www/staging.citebank.org/sites/all/modules/citebank_internet_archive/
su www-data -c "/opt/drush/drush --root=/var/www/staging.citebank.org php-script iaprocessor.php"
exit 0
