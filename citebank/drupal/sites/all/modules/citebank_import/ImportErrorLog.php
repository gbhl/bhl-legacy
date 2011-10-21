<?php
// $Id: ImportErrorLog.php,v 1.0.0.0 2011/09/27 4:44:44 dlheskett $

/** ImportErrorLog class
 *
 * Copyright (c) 2010-2011 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/27/2011
 *
 */

//$includePath = dirname(__FILE__) . '/';

/** 
 * class ImportErrorLog - 
 * 
 */
class ImportErrorLog
{
	public $className;

	public $dbi;
	
	public $loggingFlag;
	
	public $isImportErrorLogFlag;
	public $isImportErrorLogChecked;
	
	/**
	 * _construct - constructor
	 */
	function __construct()
	{
		$this->initDefaults();
		$this->loggingFlag = true;
	}

	/**
	 * initDefaults - set defaults
	 */
	function initDefaults()
	{
		$this->isImportErrorLogFlag = false;
		$this->isImportErrorLogChecked = false;
		
		//$this->isImportErrorLog();
	}

	/**
	 * setDb - set the database handle
	 */
	function setDb($dbi)
	{
		$this->dbi = $dbi;
		$this->isImportErrorLog();
		$this->isImportErrorLogFlag = true;
	}

	/**
	 * importErrorLog - 
	 */
	function importErrorLog($nid, $msg, $url, $title)
	{
		if ($this->isImportErrorLogFlag) {
			$created = date('YmdHis');
			
			// INSERT INTO import_error_log SET import_error_log.nid = 12345, import_error_log.table = 'biblio', import_error_log.field = 'biblio_year', import_error_log.old = '9999', import_error_log.new = '1923', import_error_log.created = '20110916194143'
		
			$sql = 'INSERT INTO import_error_log SET import_error_log.nid = ' . $nid . ', import_error_log.msg = ' . "'" . $msg . "'" . ', import_error_log.url = ' . "'" . $url . "'" . ', import_error_log.title = ' . "'" . $title . "'" . ', import_error_log.created = ' . "'" . $created . "'" . '';

			$ret = $this->dbi->insert($sql);
		}
	}

	/**
	 * importErrorLog - 
	 */
	function readImportErrorLog($cmd = null, $search = null)
	{
		$data = null;
		$where = '';
		
		if ($this->isImportErrorLogFlag) {
			//$sql = 'INSERT INTO import_error_log SET import_error_log.nid = ' . $nid . ', import_error_log.msg = ' . "'" . $msg . "'" . ', import_error_log.url = ' . "'" . $url . "'" . ', import_error_log.title = ' . "'" . $title . "'" . ', import_error_log.created = ' . "'" . $created . "'" . '';
			
			if ($cmd) {
				if ($search) {
					$where = 'WHERE ' . $cmd . ' = ' . "'" . $search . "'" . ' ';
				}
			}
			
			$sql = 'SELECT * FROM import_error_log ' . $where . 'ORDER BY created';
			$data = $this->dbi->fetchobj($sql);
		}
		
		return $data;
	}

	/**
	 * checkExist - check if 
	 */
	function checkExist($url)
	{
		$flag = false;

		$sql = 'SELECT count(*) as total FROM import_error_log WHERE url = \'' . $url . '\'';

		$record = $this->dbi->fetchobj($sql);
		if ($record) {
			$flag = ($record->total > 0 ? true : false);
		}
		
		return $flag;
	}

	/**
	 * isImportErrorLog - check if table exists and set flags to notify of state
	 */
	function isImportErrorLog()
	{
		$flag = false;

		$sql = "SHOW TABLES LIKE 'import_error_log'";
		$row = $this->dbi->fetch($sql);

		if (count($row) > 0) {
			$flag = true;
		}
		
		$this->isImportErrorLogFlag = $flag;    // flag if solr exists or not, true = the table exists, false = no table
		$this->isImportErrorLogChecked = true;  // checked if solr exists

		return $flag;
	}
	
	// ******************************************************************************************************
	// ******************************************************************************************************
	// ******************************************************************************************************

	// ******************************************************************************************************
	// ******************************************************************************************************
	/* drupal stubs */
	function variable_set($field, $value)
	{
		$value = 'i:' . $value . ';';  // crude create of   i:1;  or i:10;
		
		$sql = 'UPDATE variable SET value = \'' . $value . '\' WHERE name = \'' . $field . '\'';

		$this->dbi->update($sql);
	}

	function variable_setFirst($field, $value)
	{
		$value = 'i:' . $value . ';';  // crude create of   i:1;  or i:10;
		
		$sql = 'INSERT INTO variable SET name = \'' . $field . '\', value = \'' . $value . '\'';

		$this->dbi->update($sql);
	}
	
	function variable_get($field, $value)
	{
		$sql = 'SELECT * FROM variable WHERE name = \'' . $field . '\'';
		
		$record = $this->dbi->fetchobj($sql);

		$value = $record->value;
		
		// crude strip of   i:1;  or i:10;
		$value = str_replace('i', '', $value);
		$value = str_replace(':', '', $value);
		$value = str_replace(';', '', $value);
		
		return $value;
	}
	// ******************************************************************************************************
	// ******************************************************************************************************

	// ******************************************************************************************************
	// ******************************************************************************************************


	/**
	 * watchdog - logging
	 */
	function watchdog($msg)
	{
		if ($this->loggingFlag) {

			$type = 'ImportErrorLog';
			$severity = 6;
			$now = time();
			
			$sql = 'INSERT INTO watchdog SET type = ' . "'" . $type . "'" . ', message = ' . "'" . $msg . "'" . '' . ', severity = ' . $severity . '' . ', timestamp = ' . "'" . $now . "'" . '';
	
			$this->dbi->insert($sql);
		}
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
