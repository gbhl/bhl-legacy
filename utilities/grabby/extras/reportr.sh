cd /root
echo "<h2><div align="center">IA download status as of `date`<br /></h2>" > index.html
echo "<div align="center">(updated every 15 minutes)</div>" >> index.html
echo "<hr>" >> index.html
#
echo "<h3>grabby1 progress</h3>" >> index.html
echo "<ul><li>Process's uid `ls -al /mnt/export/grabby-01 | grep complete | head -n1 | cut -d"." -f2`" >> index.html
#PUID=`ls -altrs  /mnt/export/grabby-01 | grep complete. | tail -n1 | cut -d" " -f11`
#echo $PUID
#ls -altrs  /mnt/export/grabby-01 | grep complete. | tail -n1 | cut -d" " -f11
PUID=`ls -altrs  /mnt/export/grabby-01 | grep complete. | tail -n1 | cut -d"." -f2`
echo -n "<li>Currently downloading "`cat /mnt/export/grabby-01/complete.${PUID}/current.status.txt` >> index.html; echo "<br />" >> index.html
echo "<li>Data downloaded `du -hc /mnt/export/grabby-01/* | tail -n1`" >> index.html
echo "</ul><hr>" >> index.html
#
echo "<h3>grabby2 progress</h3>" >> index.html
echo "<ul><li>Process's uid `ls -al /mnt/export/grabby-02 | grep complete | head -n1 | cut -d"." -f2`" >> index.html
#PUID=`ls -altrs  /mnt/export/grabby-02 | grep complete. | tail -n1 | cut -d" " -f11`
#echo $PUID
#ls -altrs  /mnt/export/grabby-02 | grep complete. | tail -n1 | cut -d" " -f11
PUID=`ls -altrs  /mnt/export/grabby-02 | grep complete. | tail -n1 | cut -d"." -f2`
echo -n "<li>Currently downloading "`cat /mnt/export/grabby-02/complete.${PUID}/current.status.txt` >> index.html; echo "<br />" >> index.html
echo "<li>Data downloaded `du -hc /mnt/export/grabby-02/* | tail -n1`" >> index.html
echo "</ul><hr>" >> index.html
#
echo "<h3>grabby3 progress</h3>" >> index.html
echo "<ul><li>Process's uid `ls -al /mnt/export/grabby-03 | grep complete | head -n1 | cut -d"." -f2`" >> index.html
#PUID=`ls -altrs  /mnt/export/grabby-03 | grep complete. | tail -n1 | cut -d" " -f11`
#echo $PUID
#ls -altrs  /mnt/export/grabby-03 | grep complete. | tail -n1 | cut -d" " -f11
PUID=`ls -altrs  /mnt/export/grabby-03 | grep complete. | tail -n1 | cut -d"." -f2`
echo -n "<li>Currently downloading "`cat /mnt/export/grabby-03/complete.${PUID}/current.status.txt` >> index.html; echo "<br />" >> index.html
echo "<li>Data downloaded `du -hc /mnt/export/grabby-03/* | tail -n1`" >> index.html
echo "</ul><hr>" >> index.html
#





#echo "</ul><hr>" >> index.html
#
echo "Total download rate across all processes "`bwm-ng -I eth1 -o html -T rate | cut -d":" -f3 | cut -d"<" -f4 | cut -d">" -f2` >> index.html
echo "<br />" >> index.html
#
echo "Total data downloaded across all prcesses "`du -hc /mnt/export/grabby-0*|tail -n1|cut -f1` >> index.html
#
#
echo "<br /><div align="center"><a href="http://www.youtube.com/watch?v=QvqDYj3mkGk" alt="Dexter\'s Laboratory"><img src="dexter.jpg" border="0"></a></div>" >> index.html
chown www-data:www-data index.html
mv index.html /var/www/cluster
exit 0
