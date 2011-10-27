<?php
// $Id: manualOaiHarvesterModel.php,v 1.0.0.0 2011/01/18 4:44:44 dlheskett $

/** manualOaiHarvesterModel class
 *
 * Copyright (c) 2010-2011 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 01/13/2011
 * updated: 06/03/2011
 * @date reCreated: 06/07/2011
 *
 */


// using Drush, attempt to simulate the "cron" process that should occur, because oaiharvester cron is totally busted and unreliable, so workaround ...
// drush php-script <filename less the .php>  
// drush php-script manualOaiHarvesterCron

// HOW TO RUN TEST:
// sudo /root/bin/run_oai.sh 5
// sudo /opt/drush/drush -l test1.citebank.org php-script oai_5

//$includePath = dirname(__FILE__) . '/';
//require_once($includePath . 'DBInterfaceController.php');

/** 
 * class manualOaiHarvesterModel - .
 * 
 */
class manualOaiHarvesterModel
{
	public $className;

	public $listFlag;
	public $harvestId;

	const CLASS_NAME    = 'manualOaiHarvesterModel';

	const MAXLENGTH = 30;  // max length of title to use

	/**
	 * _construct - constructor
	 */
	function __construct()
	{
		$this->initDefaults();
	}

	/**
	 * initDefaults - set defaults
	 */
	function initDefaults()
	{
	}

	/*
	 *  manualOaiHarvesterCron - this is a workaround for the busted oaiharvester cron.
	 */
	function manualOaiHarvesterCron($harvestId)
	{
		$this->harvestId = $harvestId;
		
		$msg = 'Running OAI Harvester Cron id:' . $harvestId;
		$this->myOaiLogMsg($msg);
		
		// build our list of harvest schedules
		$sql = 'SELECT * FROM oaiharvester_harvester_schedules AS oais JOIN oaiharvester_sets AS oaisets ON (oaisets.set_id = oais.set_id) JOIN oaiharvester_harvest_queue AS oaiq ON (oaiq.harvest_schedule_id = oais.harvest_schedule_id)  ORDER BY oais.harvest_schedule_id';
		//$sql = 'SELECT * FROM oaiharvester_harvester_schedules AS oais JOIN oaiharvester_sets AS oaisets ON (oaisets.set_id = oais.set_id) JOIN oaiharvester_harvest_queue AS oaiq ON (oaiq.harvest_id = oais.harvest_schedule_id)  ORDER BY oais.harvest_schedule_id';
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

			$from_date      = $record->from_date;
			$until_date     = $record->until_date;
			
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

				'from_date'       => $from_date, 
				'until_date'      => $until_date,

				'start_date'      => $start_date, 
				'end_date'        => $end_date
			);
		}
	
		// provide a notice of what is in the list
		//$msg = print_r($harvestList, true);
		//$this->myOaiLogMsg($msg);
	
		// TODO: filter through the schedule, based on kick off time, day of week, hourly and so on
		
		// for now, force this specific one.
		// process a specific item
		$this->myHarvestProcess($harvestList, $harvestId);
		
		// we are done, drop a notice and leave
		$msg = 'Finished Running OAI Harvester Cron';
		$this->myOaiLogMsg($msg);
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

		$from_date       = $harvestList[$num]['from_date'];
		$until_date      = $harvestList[$num]['until_date'];
		
		$start_date      = $harvestList[$num]['start_date'];
		$end_date        = $harvestList[$num]['end_date'];
		
		// if from date > end date  then stop
		if ($this->checkRange($from_date, $end_date)) {
			$msg = 'Reached End Date Range:' . $harvestList[$num]['end_date'];
			$this->myOaiLogMsg($msg);
			
			//??? $this->setFromUntil($schedule_id, '', '');
			return;
		}
		
		// if from date same as today, lets hold off, give a day lag behind, wait for tomorrow to happen.
		$now = date('Y-m-d');
		if ($this->checkRange($from_date, $now)) {
			//$msg = 'Reached End Date Range:' . $harvestList[$num]['end_date'];
			//$this->myOaiLogMsg($msg);
			return;
		}

		// if no from date, use the start date to seed and add one day for the until date
		// if no from until dates, make them. save them.
		if (strlen($from_date) == 0) {
			$year  = 0;
			$month = 0;
			$day   = 0;

			$flag = $this->extractDate($start_date, $year, $month, $day);

			$from_date = $year . '-' . (strlen($month) < 2 ? '0' : '') . $month . '-' . (strlen($day) < 2 ? '0' : '') . $day;  // 2011-09-21

			$until_date = $this->makeNextDate($from_date);
			
			$this->setFromUntil($schedule_id, $from_date, $until_date);
		}
	
		//$msg = print_r($harvestList[$num], true);
		$msg = 'Processing (' . $schedule_id . ') ' . $schedule_name . '';
		$this->myOaiLogMsg($msg);
	
		try {
			$this->myOai_harvest($schedule_id, $schedule_name, $provider_id, $provider_url, $set_spec, $metadata_prefix, $from_date, $until_date);
		} catch (Exception $e){
			$msg = 'harvest error:' . print_r($e, true);
			$this->myOaiLogMsg($msg);
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
	

	/*
	 *  getLastResumption - 
	 */
	function getLastResumption($harvestId)
	{
		$last = '';
		
		// pull from data store
		//$last = '123123123';
		$last = variable_get('harvest_token_' . $harvestId, false);
		
		return $last;
	}

	/*
	 *  setLastResumption - 
	 */
	function setLastResumption($harvestId, $token)
	{
		variable_set('harvest_token_' . $harvestId, $token);
	}
	
	/*
	 *  clearLastResumption - 
	 */
	function clearLastResumption($harvestId)
	{
		variable_del('harvest_token_' . $harvestId);
	}
	
	/*
	 *  setFromUntil - 
	 */
	function setFromUntil($harvestId, $from_date, $until_date)
	{
		//variable_set('harvest_token_' . $harvestId, $token);
		//$sql = 'SELECT * FROM oaiharvester_harvester_schedules AS oais JOIN oaiharvester_sets AS oaisets ON (oaisets.set_id = oais.set_id) JOIN oaiharvester_harvest_queue AS oaiq ON (oaiq.harvest_schedule_id = oais.harvest_schedule_id)  ORDER BY oais.harvest_schedule_id';
		$sql = 'UPDATE oaiharvester_harvest_queue SET from_date = ' . "'" . $from_date . "'" . ', until_date = ' . "'" . $until_date . "'" . ' WHERE harvest_schedule_id = ' . $harvestId . '';
		// UPDATE oaiharvester_harvest_queue SET from_date = 'yyyy-mm-dd', until_date = 'yyyy-mm-dd' WHERE harvest_schedule_id = 5
		// UPDATE oaiharvester_harvest_queue SET from_date = '2009-01-07', until_date = '2009-01-08' WHERE harvest_schedule_id = 5
		$result = db_query($sql);

	}
	
	/*
	 *  extractDate - split up a date into pieces, validate ranges and flag for a good date, returning parts in given fields.
	 */
	function extractDate($date, &$year, &$month, &$day)
	{
		$year  = 0;
		$month = 0;
		$day   = 0;
		$flag  = false;
		
		if (strlen($date) >= 10) {
			$year  = $date[0] . $date[1] . $date[2] . $date[3];
			$month = $date[5] . $date[6];
			$day   = $date[8] . $date[9];
			
			// get php to see them as numbers
			$year  = 0 + $year;
			$month = 0 + $month;
			$day   = 0 + $day;
			
			if ($year > 0 && $month > 0 && $day > 0) {

				if ($year < 9999) {
					if ($month <= 12) {
						if ($day <= 31) {
							$flag = true;
						} else {
							$day = 0;
						}
					} else {
						$month = 0;
					}
				} else {
					$year = 0;
				}

			}

			if (($day <= 31) && ($day > 0)) {
			} else {
				if ($day < 0) {
					$day = 0;
				}
				
				switch ($month) {
					case 2:
						$leap = date('L', mktime(0, 0, 0, $month, $day, $year));
					  if ($day > ($leap ? 29 : 28)) {
					  	$day = 0;
					  }
						break;

					case 1:
					case 3:
					case 5:
					case 7:
					case 8:
					case 10:
					case 12:
					  if ($day > 31) {
					  	$day = 0;
					  }
						break;

					case 4:
					case 6:
					case 9:
					case 11:
					  if ($day > 30) {
					  	$day = 0;
					  }
						break;

					default:
						$day = 0;
						break;
				}
			}

			if ($year >= 9999) {
				$year = 0;
			}

			if ($month > 13) {
				$month = 0;
			}

			if ($year < 0) {
				$year = 0;
			}

			if ($month < 0) {
				$month = 0;
			}

		} else {
			// ?
		}

		return $flag;
	}

	/*
	 *  makeNextDate - 
	 */
	function makeNextDate($date, $days = 1)
	{
		$year  = '';
		$month = '';
		$day   = '';
		
		if ($date) {
			$flag = $this->extractDate($date, $year, $month, $day);
			
			if ($flag) {
				$date = date('Y-m-d', mktime(0, 0, 0, $month, $day + $days, $year));
			}
		} else {
			// ?
			$now = date('Y-m-d');
		
			$date = $now;
		}

		return $date;
	}

	/*
	 *  checkFromUntil - see that the from and until dates have data and are valid
	 */
	function checkFromUntil($from_date, $until_date)
	{
		$year  = 0;
		$month = 0;
		$day   = 0;
		$flag  = false;
		
		if (strlen($from_date) > 0 && strlen($until_date) > 0) {
			// check the YYYY-MM-DD format?
			$flagFrom  = $this->extractDate($from_date,  $year, $month, $day);
			$flagUntil = $this->extractDate($until_date, $year, $month, $day);
			
			$flag  = $flagFrom && $flagUntil;
		}
		
		return $flag;
	}

	/*
	 *  checkRange - check if from has exceeded ending date
	 */
	function checkRange($from_date, $end_date)
	{
		$year  = 0;
		$month = 0;
		$day   = 0;
		$flag  = false;
		
		if (strlen($from_date) > 0 && strlen($end_date) > 0) {
			// check the YYYY-MM-DD format?
			$flagFrom  = $this->extractDate($from_date,  $year, $month, $day);
			//$from = $year . $month . $day;  // 20110612  20110618
			$from = $year . (strlen($month) < 2 ? '0' : '') . $month . (strlen($day) < 2 ? '0' : '') . $day;  // 20110612  20110618
			$flagUntil = $this->extractDate($end_date,   $year, $month, $day);
			//$end = $year . $month . $day;   // 20110617
			$end = $year . (strlen($month) < 2 ? '0' : '') . $month . (strlen($day) < 2 ? '0' : '') . $day;   // 20110617
			
			// easy compare of dates
			//if ($from > $end) {
			if ((0 + $from) > (0 + $end)) {
				$flag = true;
			}
		}
		
		return $flag;
	}

	/*
	 *  checkOaiError - check if the error is just an empty response
	 */
	function checkOaiError($error)
	{
		$flag = false;
		$passError = 'noRecordsMatch';
		
		$code = $error['error'][0]['attributes']['code'];
			  	//$msg = print_r($oai, true);
			  	//$this->myOaiLogMsg($msg);		

  	//$msg = 'Code: [' . print_r($code, true) . ']';
  	//$this->myOaiLogMsg($msg);		

//Array ( 
//[responseDate] => 2011-07-01T18:07:24Z 
//[request] => Array 
//	( 
//		[attributes] => Array 
//		( 
//			[verb] => ListRecords 
//			[from] => 2011-01-30 
//			[until] => 2011-01-31 
//			[set] => phytokeys 
//			[metadataPrefix] => oai_dc
//		)
//	[text] => http://oai.pensoft.eu 
//	)
//[error] => Array 
//	( [0] => Array 
//		( 
//			[attributes] => Array 
//			( 
//				[code] => noRecordsMatch 
//			) 
//		[text] => oai.noRecordsMatch 
//		) 
//	) 
//)


		if (substr_count($code, $passError)) {
			$flag = true;
		}
		
		// <error code="noRecordsMatch">

		return $flag;
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
	function myOai_harvest($schedule_id, $schedule_name, $provider_id, $url, $set, $metadataPrefix, $from_date, $until_date) 
	{
	  set_time_limit(0);
	  $is_first = true;
	  $count = 0;
	  $lastResumption = false;
	  $flagFromUntil  = false;
	  $newFromFlag = false;
	  $flagNextFromUntil = false;
	  $flagResumption = false;
	  $newToken = '';

		$flagFromUntil = $this->checkFromUntil($from_date, $until_date);
		$lastResumption = $this->getLastResumption($this->harvestId);
		
		// if no resumption
		// if no from until
		//  check for the date or resumption token, and flag the item
		//  check for the condition to stop the loop either a set number of a throttle of loops
		//  make sure to store the resumption token or date from until values
		//  bump the from until dates
		//  
		
	  while (($is_first == true || (isset($oai) && $oai['ListRecords']['resumptionToken']))) {
	
	    // do first request (once), or the resumption request (repeat)
	    if ($is_first) {
	    	if (strlen($set) > 0) {
	      	$params = array('set' => $set, 'metadataPrefix' => $metadataPrefix);
	    	} else {
	      	$params = array('metadataPrefix' => $metadataPrefix);
	    	}
	      $is_first = false;

				// check if we are rolling through from a previous large set or using the dates to window over 
				if ($lastResumption || $flagFromUntil) {
					$is_first = false;
					
					if ($flagFromUntil) {
						$params = array('set' => $set, 'metadataPrefix' => $metadataPrefix, 'from' => $from_date, 'until' => $until_date);
				    $msg = '(' . $this->harvestId . ') From date: [' . $from_date . ']' . 'Until date: [' . $until_date . ']';
				   	$this->myOaiLogMsg($msg);
						
						$flagFromUntil = false;
						// bump date flag here
				   	$flagNextFromUntil = true;
					}
		
					// a resumption token will take precedence over a date 
					if ($lastResumption) {
						$flagResumption = true;
						//$params = array('resumptionToken' => $lastResumption);
			      $params = array('set' => $set, 'metadataPrefix' => $metadataPrefix, 'resumptionToken' => $lastResumption);
					}
				}
	      
	    } else {
	      //$params = array('resumptionToken' => $oai['ListRecords']['resumptionToken']['text']);
	      $params = array('set' => $set, 'metadataPrefix' => $metadataPrefix, 'resumptionToken' => $oai['ListRecords']['resumptionToken']['text']);
	      $flagResumption = true;
	
	      $this->myOaiLogMsg('token:[' . $oai['ListRecords']['resumptionToken']['text'] . ']');
	    }
	    
	    $request = $url . '?' . http_build_query(array_merge(array('verb' => 'ListRecords'), $params));
	      
	    $msg = 'Request: [' . $request . ']';
	   	$this->myOaiLogMsg($msg);
	    
	    $oai = OaiPmh::factory('ListRecords', $url, $params);
	
		  // error? or records processed?
		  if (isset($oai['error'])) {  // errors
		  	
		  	// if the error is something like: <error code="noRecordsMatch">
		  	//  and we are running a daily from until, then just let it pass as successful, there was no data for that day and move on
		    if ($this->checkOaiError($oai)) {
			    // if using from until dates, bump the dates by a day
			    if ($flagNextFromUntil && !$flagResumption) {

				   	//$msg = 'No data for this range: From date: [' . $from_date . ']' . 'Until date: [' . $until_date . ']';
				   	$msg = 'No data. Range: [' . $from_date . ']' . ' - [' . $until_date . ']';
				   	$this->myOaiLogMsg($msg);
	
						$from_date = $until_date;
						$until_date = $this->makeNextDate($until_date);
	
						$this->setFromUntil($this->harvestId, $from_date, $until_date);
				    $msg = '(' . $this->harvestId . ') NEXT From date: [' . $from_date . ']' . 'Until date: [' . $until_date . ']';
				   	$this->myOaiLogMsg($msg);
				   	$flagNextFromUntil = false;
			    }
			  } else {
			  	$msg = print_r($oai, true);
			  	$this->myOaiLogMsg($msg);
			  }
		  	
		  } else {  // records processed
		    $msg = 'Number of records: ' . count($oai['ListRecords']['record']);
		   	$this->myOaiLogMsg($msg);
		
		    // this is the core of what we are trying to get at, this will get into our bridge from here: biblio_oaiharvester_process_record, and do the real work we need done
		    foreach ($oai['ListRecords']['record'] as $record) {
		      module_invoke_all('oaiharvester_process_record', $record);
		    }
		    
		    // find a resumption token
		    if (isset($oai['ListRecords']['resumptionToken']['text'])) {
		    	$this->myOaiLogMsg('oaitoken:[' . $oai['ListRecords']['resumptionToken']['text'] . ']');
		    	$newToken = $oai['ListRecords']['resumptionToken']['text'];
		  	}
		    
		    if (strlen($newToken) > 0) {
		    	$this->setLastResumption($this->harvestId, $newToken);
		    	$newToken = '';
		    	$flagResumption = true;
		    } else {
		    	$this->clearLastResumption($this->harvestId);
		    	$flagResumption = false;
		    }
		    
		    // if using from until dates, bump the dates by a day
		    if ($flagNextFromUntil && !$flagResumption) {

					$from_date = $until_date;
					$until_date = $this->makeNextDate($until_date);

					$this->setFromUntil($this->harvestId, $from_date, $until_date);
			    $msg = '(' . $this->harvestId . ') NEXT From date: [' . $from_date . ']' . 'Until date: [' . $until_date . ']';
			   	$this->myOaiLogMsg($msg);
			   	$flagNextFromUntil = false;
		    }

		  }
	  } // end while
	  
	  // done
	  module_invoke_all('oaiharvester_request_processed');
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
