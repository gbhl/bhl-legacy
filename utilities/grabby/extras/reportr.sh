cd /root

echo "<h2><div align="center">IA download status as of `date`</h2>" > index.html
echo "<div align="center">(updated every 10 minutes)</div>" >> index.html
echo "<hr>" >> index.html
#

# get stuff from current grabby processes
cat /mnt/export/grabby*/status >> index.html

#
echo "Total download rate across all processes "`bwm-ng -I eth1 -o html -T rate | cut -d":" -f3 | cut -d"<" -f4 | cut -d">" -f2` >> index.html
echo "<br />" >> index.html
#
echo "Total data downloaded across all processes "`du -hc /mnt/export/grabby*|tail -n1|cut -f1` >> index.html
#
echo "<br /><br />Browse the downloaded files <a href="http://whbhl01.ubio.org/files/">here</a>" >> index.html
#
#
echo "<br /><div align="center"><a href="http://www.youtube.com/watch?v=QvqDYj3mkGk" alt="Dexter\'s Laboratory"><img src="dexter.jpg" border="0"></a></div>" >> index.html
chown www-data:www-data index.html
mv index.html /var/www/cluster
exit 0
