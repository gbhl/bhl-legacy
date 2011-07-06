#!/bin/bash

echo "-----------------------------------------------------------------------" > stats.txt
echo "    citestats - CiteBank stats updated `date`" >> stats.txt
echo "-----------------------------------------------------------------------" >> stats.txt
echo "	* Total citations:" `mysql -u root -pp@ncak3s! < allbib.sql | tail -n1` >> stats.txt
echo "	* Citations with PDFs from BHL:" `mysql -u root -pp@ncak3s! < pdfs.sql | tail -n1` >> stats.txt 
echo "	* Citations without PDFs attached:" `mysql -u root -pp@ncak3s! < nopdfs.sql | tail -n1` >> stats.txt

echo "	* Citations from BHL:" `mysql -u root -pp@ncak3s! < biodivlib.sql | tail -n1` >> stats.txt
echo "	* Citations from Scielo:" `mysql -u root -pp@ncak3s! < scielo.sql | tail -n1` >> stats.txt
echo "	* Citations from various sources:" `mysql -u root -pp@ncak3s! < various.sql | tail -n1` >> stats.txt
echo "	* Citations from Pensoft:" `mysql -u root -pp@ncak3s! < pensoft.sql | tail -n1` >> stats.txt
echo "	* Citations from Zookeys:" `mysql -u root -pp@ncak3s! < zookeys.sql | tail -n1` >> stats.txt 

echo "	* Registerered CiteBank users:" `mysql -u root -pp@ncak3s! < users.sql | tail -n1` >> stats.txt

echo "-----------------------------------------------------------------------" >> stats.txt

mv stats.txt /var/www/citebank.org/sites/all/files/
chown -R www-data:www-data /var/www/citebank.org/sites/all/files/stats.txt

exit 0
