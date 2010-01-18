#!/bin/bash
#
################################################################################
#
# File          : grabby.sh
# Usage         : ./grabby.sh download_list
# Author        : phil.cryer@mobot.org
# Date created  : 2009-10-10
# Last updated  : 2010-01-17
# Source        : http://code.google.com/p/bhl-bits/utilities/grabby
# Description   : a bash script to perform batch downloads of Internet Archive
#                 (archive.org) materials, via record ids as listed in todo.txt
# Requires      : Bash, wget
# (optional)    : fast/stable internet connection, paitience, sense of humor
#
################################################################################
#
# Copyright (c) 2010, Biodiversity Heritage Library
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer. Redistributions in binary
# form must reproduce the above copyright notice, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided with
# the distribution. Neither the name of the Biodiversity Heritage Library nor
# the names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission. THIS
# SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
################################################################################
# More information about the BSD License can be found here:
# http://www.opensource.org/licenses/bsd-license.php
################################################################################
#
########################################
# Verify action file called 
########################################
if [ $# -ne 1 ]; then
	echo "Usage: `basename $0` download_list"
	exit 1
fi
if [ ! -f ${1} ]; then
	echo "Fail: file ${1} not found"
	exit 1
fi
#
########################################
# Check for/create directories
########################################
if [ ! -d done ]; then 
	mkdir done 
fi
if [ ! -d complete ]; then 
	mkdir complete
fi
if [ ! -d failed ]; then 
	mkdir failed
fi
#
########################################
# Get report stats
########################################
sum=0; num=1; full=`cat ${1} | wc -l` 
START_TIME=`date "+%H:%M:%S %Y-%m-%d%n"`
PUID=`date +%s`
#
########################################
# Start the loop
########################################
cat ${1} | while read BOOK_ID
do
sum=$(($sum + $num))
#
########################################
# Generate report file
########################################
TOTAL_DATA=`du -hc complete failed | tail -n1`
TOTAL_COMPLETE=`ls complete/ | wc -l`
TOTAL_FAILED=`ls failed/ | wc -l`
START_TIME=`date "+%H:%M:%S %Y-%m-%d%n"`
#END_TIME=`date "+%H:%M:%S %Y-%m-%d%n"`
#START=`date +%s`
#END=`date +%s`
ELAPSED=`expr $END - $START`
echo "<h3>grabby progress - running</h3>" > status
echo "<ul>" >> status
echo "<li>Process uid is ${PUID}</li>" >> status
echo "<li>Running since ${START_TIME}</li>" >> status
#echo "<li>Finished at ${END_TIME}</li>" >> status
echo "<li>${TOTAL_COMPLETE} books downloaded successfully</li>" >> status
echo "<li>${TOTAL_FAILED} books failed to download</li>" >> status
#echo "<li>Download took ${ELAPSED} seconds</li>" >> status
echo "<li>Total data downloaded `du -hc complete/ failed/ | tail -n1`</li>" >> status
echo "</ul><hr>" >> status
#
########################################
# Download files
########################################
wget --user-agent="Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.2; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)" --tries=2 --span-hosts --recursive --level=1 --continue --no-parent --no-host-directories --reject index.html --cut-dirs=2 --execute robots=off http://www.archive.org/download/${BOOK_ID} 
#	
########################################
# Generate and check sha1 checksums
########################################
echo; echo "    Generating SHA1 sums..."
shasum ${BOOK_ID}/* > /tmp/shasums_${BOOK_ID} 
echo; echo "    Checking SHA1 sums..."; echo 
shasum -c /tmp/shasums_${BOOK_ID} > /tmp/cksums_${BOOK_ID}
if [ `grep FAILED /tmp/cksums_${BOOK_ID} | wc -l` -gt '0' ]; then
	mv ${BOOK_ID} failed
	mv /tmp/cksums_${BOOK_ID} failed/${BOOK_ID}
else
	mv ${BOOK_ID} complete
fi
#
########################################
# End loop, save download list to done
########################################
done
mv ${1} done/${PUID}.${1}
#
########################################
# Summarize downloads, time, etc
########################################
TOTAL_DATA=`du -hc complete failed | tail -n1`
TOTAL_COMPLETE=`ls complete/ | wc -l`
TOTAL_FAILED=`ls failed/ | wc -l`
START_TIME=`date "+%H:%M:%S %Y-%m-%d%n"`
END_TIME=`date "+%H:%M:%S %Y-%m-%d%n"`
START=`date +%s`
END=`date +%s`
ELAPSED=`expr $END - $START`
echo "<h3>grabby progress - completed</h3>" > status
echo "<ul>" >> status
echo "<li>Process uid was ${PUID}</li>" >> status
echo "<li>Started at ${START_TIME}</li>" >> status
echo "<li>Finished at ${END_TIME}</li>" >> status
echo "<li>${TOTAL_COMPLETE} books downloaded successfully</li>" >> status
echo "<li>${TOTAL_FAILED} books failed to download</li>" >> status
echo "<li>Download took ${ELAPSED} seconds</li>" >> status
echo "<li>Total data downloaded `du -hc complete/ failed/ | tail -n1`</li>" >> status
echo "</ul><hr>" >> status
cp status done/${PUID}.status
#
exit 0
