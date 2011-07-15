<?php
// manualOaiHarvesterCron.php

/**  manualOaiHarvesterCron
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 01/13/2011
 *
 */

// using Drush, attempt to simulate the "cron" process that should occur, because oaiharvester cron is totally busted and unreliable, so workaround ...
// drush php-script <filename less the .php>  
// drush php-script manualOaiHarvesterCron

$harvestId = 14;

$includePath = dirname(__FILE__) . '/';

//require_once($includePath . 'manualOaiHarvester.php');
//return;

require_once($includePath . 'manualOaiHarvesterModel.php');

// prevent crons colliding, there can be only one highlander
$nameHarvestRunning = 'harvest_running_' . $harvestId;

$flagHarvestRunning = variable_get($nameHarvestRunning, false);

if ($flagHarvestRunning) {
	return;
}
variable_set($nameHarvestRunning, 1);

$x =  new manualOaiHarvesterModel();
$msg = 'harvest id:' . $harvestId;
$x->myOaiLogMsg($msg);

$msg = 'Start:' . date('YmdHis');
$x->myOaiLogMsg($msg);

// get started
$x->manualOaiHarvesterCron($harvestId);

$msg = 'End:' . date('YmdHis');
$x->myOaiLogMsg($msg);

variable_del($nameHarvestRunning);

// **************************************************
?>
