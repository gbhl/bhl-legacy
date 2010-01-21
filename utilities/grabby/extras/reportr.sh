cd /root

echo "<html><head><title>grabby status</title></head><body>" > index.html
echo "<h2><div align="center">IA download status as of `date`</h2>" >> index.html
echo "<div align="center">" >> index.html
echo -n "Current download rate "`bwm-ng -I eth1 -o html -T rate | cut -d":" -f3 | cut -d"<" -f4 | cut -d">" -f2` >> index.html
#echo -n " - total downloaded "`du -hc /mnt/export/grabby*|tail -n1|cut -f1` >> index.html
echo -n " - total downloaded `df -h | tail -n1 | cut -d"T" -f2` Terabytes" >> index.html
echo " - updated every 10 minutes</div>" >> index.html
echo "<hr>" >> index.html
#

# get stuff from current grabby processes
cat /mnt/export/grabby*/status >> index.html

#
echo "<div align="center"><a href="http://www.youtube.com/watch?v=QvqDYj3mkGk" alt="Dexter\'s Laboratory"><img src="dexter.jpg" border="0"></a>" >> index.html
echo "<br /><br />" >> index.html 
echo "<hr>" >> index.html
#
echo -n "<a href="http://files.biodiversitylibrary.org/">files</a>  -  " >> index.html
echo -n "<a href="http://cluster.biodiversitylibrary.org/dir/">directories</a>  -  " >> index.html
echo "<a href="http://www.slideshare.net/phil.cryer/building-a-scalable-open-source-storage-solution-2482448">about</a></div>" >> index.html

echo "</body></html>" >> index.html
chown www-data:www-data index.html
cp -p index.html /var/www/cluster
mv index.html /var/www/cluster.biodiversitylibrary.org
exit 0
