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

$harvestId = 3;

// get started
manualOaiHarvesterCron($harvestId);

/*
 *  manualOaiHarvesterCron - this is a workaround for the busted oaiharvester cron.
 */
function manualOaiHarvesterCron($harvestId)
{
	$msg = 'Running OAI Harvester Cron';
	myOaiLogMsg($msg);
	
	// build our list of harvest schedules
	$sql = 'SELECT * FROM oaiharvester_harvester_schedules AS oais JOIN oaiharvester_sets AS oaisets ON (oaisets.set_id = oais.set_id) JOIN oaiharvester_harvest_queue AS oaiq ON (oaiq.harvest_schedule_id = oais.harvest_schedule_id)  ORDER BY oais.harvest_schedule_id';
	$result = db_query($sql);
	
	$harvestList = array();
	
	// working through the items in the queue, build our list with needed info
	while ($record = db_fetch_object($result)) {
	
		$schedule_id    = $record->harvest_schedule_id;
		$schedule_name  = $record->schedule_name;
		$provider_id    = $record->provider_id;
		$provider_url   = $record->provider_url;
		$set_spec       = $record->set_spec;
		$metadata_prefix = $record->metadata_prefix;
		
		$recurrance     = $record->recurrence;
		$minute         = $record->minute;
		$hour           = $record->hour;
		$day_of_week    = $record->day_of_week;
		$start_date     = $record->start_date;
		$end_date       = $record->end_date;
		
		// the list of harvest items in our schedule
		$harvestList[$schedule_id] = array('schedule_id' => $schedule_id, 
			'schedule_name'   => $schedule_name, 
			'provider_id'     => $provider_id, 
			'provider_url'    => $provider_url, 
			'set_spec'        => $set_spec, 
			'metadata_prefix' => $metadata_prefix, 
			'recurrance'      => $recurrance, 
			'minute'          => $minute, 
			'hour'            => $hour, 
			'day_of_week'     => $day_of_week, 
			'start_date'      => $start_date, 
			'end_date'        => $end_date
		);
	}

	// provide a notice of what is in the list
	//$msg = print_r($harvestList, true);
	//myOaiLogMsg($msg);

	// TODO: filter through the schedule, based on kick off time, day of week, hourly and so on
	
	// for now, force this specific one.
	// process a specific item
	myHarvestProcess($harvestList, $harvestId);
	
	// we are done, drop a notice and leave
	$msg = 'Finished Running OAI Harvester Cron';
	myOaiLogMsg($msg);
}

// ****************************************

/*
 *  myHarvestProcess - work one of the harvest items 
 */
function myHarvestProcess($harvestList, $num)
{
	$schedule_id     = $harvestList[$num]['schedule_id'];
	$schedule_name   = $harvestList[$num]['schedule_name'];
	$provider_id     = $harvestList[$num]['provider_id'];
	$provider_url    = $harvestList[$num]['provider_url'];
	$set_spec        = $harvestList[$num]['set_spec'];
	$metadata_prefix = $harvestList[$num]['metadata_prefix'];

	//$msg = print_r($harvestList[$num], true);
	$msg = 'Processing (' . $schedule_id . ') ' . $schedule_name . '';
	myOaiLogMsg($msg);

	try {
		myOai_harvest($schedule_id, $schedule_name, $provider_id, $provider_url, $set_spec, $metadata_prefix);
	} catch (Exception $e){
		$msg = 'harvest error:' . print_r($e, true);
		myOaiLogMsg($msg);
	}
}

/*
 *  myOaiLogMsg - 
 */
function myOaiLogMsg($msg, $flag = 1)
{
	if ($flag) {
		$type = 'OAI Manual Cron';
		log_info($type, $msg);
	}
}

/**
 * myOai_harvest - reworked oaiharvester _harvest function
 * Harvest the records
 * @param $schedule_id The ID of the schedule
 * @param $schedule_name The name of the schedule
 * @param $provider_id The ID of data provider
 * @param $url The base URL to harvest
 * @param $set The set parameter
 * @param $format The metadataPrefix parameter
 * @return unknown_type
 */
function myOai_harvest($schedule_id, $schedule_name, $provider_id, $url, $set, $metadataPrefix) 
{
	//myOaiLogMsg('let the harvest begin');

  set_time_limit(0);
  $is_first = TRUE;
  $is_test  = TRUE;
  $count = 0;

  while ($is_test == TRUE 
      && ($is_first == TRUE 
         || (isset($oai) && $oai['ListRecords']['resumptionToken']))) {

    if ($is_first) {
      $params = array(
        'set' => $set, 
        'metadataPrefix' => $metadataPrefix,
      );
      $is_first = FALSE;
      
    } else {
      $params = array(
        'resumptionToken' => $oai['ListRecords']['resumptionToken']['text'],
        'metadataPrefix'  => $metadataPrefix,
      );
    }
    
    $request = $url . '?' . http_build_query(array_merge(
      array('verb' => 'ListRecords'), $params));
      
    drupal_set_message(__LINE__ . ') request: ' . $request);
    
    //$msg = 'OaiPmg Factory start';
    //myOaiLogMsg($msg);
    
    $oai = OaiPmh::factory('ListRecords', $url, $params);

    //$msg = 'OaiPmg Factory end';
    //myOaiLogMsg($msg);
    
    $is_test  = FALSE;
  } // end while
  
  // error? or records processed?
  if (isset($oai['error'])) {
  	$msg = print_r($oai, true);
  	myOaiLogMsg($msg);
  	
  } else {
    $msg = 'Number of records: ' . count($oai['ListRecords']['record']);
   	myOaiLogMsg($msg);

    // this is the core of what we are trying to get at, this will get into our bridge from here: biblio_oaiharvester_process_record, and do the real work we need done
    foreach ($oai['ListRecords']['record'] as $record) {
      module_invoke_all('oaiharvester_process_record', $record);
    }
    
    drupal_set_message(t('Imported %count record(s)', array('%count' => $count)));
  }
  
  // done
  module_invoke_all('oaiharvester_request_processed');
}

// **************************************************
?>
