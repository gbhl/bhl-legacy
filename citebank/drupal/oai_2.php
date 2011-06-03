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

$harvestId = 2;

$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'manualOaiHarvester.php');


// **************************************************
?>
