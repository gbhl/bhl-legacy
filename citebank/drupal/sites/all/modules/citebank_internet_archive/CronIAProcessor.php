<?php

// Internet Archive cron processor

// $Id: CronIAProcessor.php,v 1.0.0.0 2011/04/19 4:44:44 dlheskett $

/**  CronIAProcessor class
 *
 * Copyright (c) 2011 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 04/19/2011
 *
 */

$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'InternetArchiveModel.php');

// ****************************************
// ****************************************
// ****************************************

/**
 * class CronIAProcessor  - 
 *
 */
class CronIAProcessor
{
	private $dbi; 
	private $i;
	
	public $error;
	
	public $info;

	/**
	 *  constructor - initializes some hard fixed values
	 */
	function __construct()
	{
		//$this->init();
	}

	/**
	 *  init - initializes 
	 */
//	function init()
//	{
//	}

	/**
	 *  runInternetArchiveCron - 
	 */
	function runInternetArchiveCron()
	{
		// must be explicitly set
		$processFlag = (0 + variable_get('citebank_internet_archive_processflag', 0) == 1 ? true : false);
		$ret = true;

		// if 
		if ($processFlag) {
			$x = new InternetArchiveModel();
			
			$x->runExternalCronProcess();
		} else {
			$type = 'InternetArchive';
			$msg = 'Citebank IA External cron PROCESSING IS OFF';
			$msg .= ' ' . date('YmdHis');
			watchdog($type, $msg);
			$ret = false;
		}
		
		return $ret;
	}

	/**
	 * _toString - stringify
	 */
	function __toString()
	{
		$info = '';
		$info .= $this->className;

		return $info;
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
