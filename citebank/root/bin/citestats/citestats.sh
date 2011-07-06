#!/bin/bash

echo "-----------------------------------------------------------------------" > stats.txt
echo "    citestats - CiteBank stats updated `date`" >> stats.txt
echo "-----------------------------------------------------------------------" >> stats.txt
echo "	* Total citations:" `mysql -u root -p${PASSWORD} < allbib.sql | tail -n1` >> stats.txt
echo "	* Citations with PDFs from BHL:" `mysql -u root -p${PASSWORD} < pdfs.sql | tail -n1` >> stats.txt 
echo "	* Citations without PDFs attached:" `mysql -u root -p${PASSWORD} < nopdfs.sql | tail -n1` >> stats.txt

echo "	* Citations from BHL:" `mysql -u root -p${PASSWORD} < biodivlib.sql | tail -n1` >> stats.txt
echo "	* Citations from Scielo:" `mysql -u root -p${PASSWORD} < scielo.sql | tail -n1` >> stats.txt
echo "	* Citations from various sources:" `mysql -u root -p${PASSWORD} < various.sql | tail -n1` >> stats.txt
echo "	* Citations from Pensoft:" `mysql -u root -p${PASSWORD} < pensoft.sql | tail -n1` >> stats.txt
echo "	* Citations from Zookeys:" `mysql -u root -p${PASSWORD} < zookeys.sql | tail -n1` >> stats.txt 

echo "	* Registerered CiteBank users:" `mysql -u root -p${PASSWORD} < users.sql | tail -n1` >> stats.txt

echo "-----------------------------------------------------------------------" >> stats.txt

mv stats.txt /var/www/citebank.org/sites/all/files/
chown -R www-data:www-data /var/www/citebank.org/sites/all/files/stats.txt

exit 0
