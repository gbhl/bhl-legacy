<?php

// Internet Archive cron processor

// $Id: iaprocessor.php,v 1.0.0.0 2011/04/19 4:44:44 dlheskett $

/**  iaprocessor class
 *
 * Copyright (c) 2011 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 04/19/2011
 *
 */

$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'CronIAProcessor.php');

// ****************************************
// ****************************************
// ****************************************
echo "\n";
echo 'start ' . date('Y/m/d H:i:s');
echo "\n";
$cronIA = new CronIAProcessor();
echo "\n";
echo 'begin ' . date('Y/m/d H:i:s');
echo "\n";
$ret = $cronIA->runInternetArchiveCron();

if (!$ret) {
	echo "\n";
	echo 'cron is OFF ' . date('Y/m/d H:i:s');
	echo "\n";
}

echo "\n";
echo 'end ' . date('Y/m/d H:i:s');
echo "\n";

return ($ret ? 1 : 0);

// ****************************************
// ****************************************
// ****************************************

?>
