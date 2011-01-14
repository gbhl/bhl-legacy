

// oai readme .txt

The files oai_X.php  (oai_1.php, oai_2.php, etc) are files to manually run the cron process that does the OAI imports.
The problem is the oaiharvester cron does not work as advertised, in fact does not work at all, so the solution is this
workaround.  These files are call by a cron process that uses a drush command to launch the process.  They are meant to be in the root dir.

	drush php-script oai_5.php

There is a script that calls each one by number.  The number is the harvest_schedule_id found in the oaiharvseter_harvester_schedules table.
These seven files have the number hard coded, since drush does not pass in an argument to the php script, and it was just faster to implement this way.

