<?php
// $Id: CSVHandler.php,v 1.0.0.0 2010/12/07 4:44:44 dlheskett $

/**  CSVHandler class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 12/07/2010
 *
 */

/** 
 * class CSVHandler - work with CSV files
 * 
 */
class CSVHandler
{
	public $includePath     = '';

	const CLASS_NAME        = 'CSVHandler';

	const EXT_CSV           = '.csv';
	const EXT_OLDCSV        = '.oldcsv';  // used csv files will be renamed to old and after some weeks time would be purged
	const EXT_APPROVEDCSV   = '.approve';
	const EXT_PREVIEWEDCSV  = '.preview';
	const PATH_FILES_STORED = 'sites/default/files/';
	const PATH_FIXER        = 'sites/all/modules/citebank_importer/';
	
	const WEEKS_TO_PURGE    = 1;  // number of weeks before file is ready to purge
	const WEEK_LENGTH       = 604800; // 60 * 60 * 24 * 7  seconds in a week, 604800
	
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
		$path = dirname(__FILE__) . '/';

		$path = str_replace(self::PATH_FIXER, '', $path);
		
		$this->includePath = $path . self::PATH_FILES_STORED;
		
		// [/var/www/test3.citebank.org/sites/all/modules/citebank_importer/testJAMCADatabaseSG_small.csv]
		//  /var/www/test3.citebank.org/sites/all/modules/citebank_importer/testJAMCADatabaseSG_small.csv
		//  /var/www/test3.citebank.org/sites/sites/default/files/all/modules/citebank_importer/testJAMCADatabaseSG_small.csv
		//  /var/www/test3.citebank.org/sites/default/files/testJAMCADatabaseSG_small.csv
	}

	/**
	 * _toString - stringify
	 */
	function __toString()
	{
		$info = '';

		$info .= ' ';
		$info .= 'includePath: ';
		$info .= $this->includePath;

		return $info;
	}

	/**
	 *  findListImportFiles - make a list of csv files, go through one, mark done, go through next later since running cron
	 */
	function findListImportFiles()
	{
		$ext = self::EXT_CSV;
		$csvList = $this->makeFilesList($ext);
		
		return $csvList;
	}
	
	/**
	 *  showTheList - 
	 */
	function showTheList($filenames)
	{
		$count = count($filenames);
		
		if ($count) {
			foreach ($filenames as $filename) {
				echo $filename;
				echo '<br>' . "\n";
			}
		}
	}
	
	/**
	 *  getTheList - 
	 */
	function getTheList($filenames)
	{
		$count = count($filenames);
		$strList = '';
		
		if ($count) {
			foreach ($filenames as $filename) {
				$strList .= $filename;
				$strList .= ',';
			}
			$strList = rtrim($strList, ',');
		}
		
		return $strList;
	}

	/**
	 *  purgeList - delete the old csv files that are now stale
	 */
	function purgeList($filenames)
	{
		$count = count($filenames);
		
		if ($count) {
			foreach ($filenames as $filename) {
				$this->remove($this->includePath . $filename);
			}
		}
	}
	
	/**
	 *  pushOffList - expire the csv, make it old by renaming it
	 */
	function pushOffList($filename)
	{
		$newFilename = '';
		
		$newFilename = str_replace(self::EXT_CSV, self::EXT_OLDCSV, $filename);
		
		$ret = rename($filename, $newFilename);

		$this->cutApproveTag($filename);
		
		return $ret;
	}
	
	/**
	 *  findOldListImportFiles - make a list of old csv files
	 */
	function findOldListImportFiles()
	{
		$ext = self::EXT_OLDCSV;
		$csvList = $this->makeFilesList($ext);

		return $csvList;
	}
	
	/**
	 *  findApprovedListImportFiles - make a list of approved csv files
	 */
	function findApprovedListImportFiles()
	{
		$ext = self::EXT_APPROVEDCSV;
		$csvList = $this->makeFilesList($ext);

		return $csvList;
	}
	
	/**
	 *  isApproved - check for approval
	 */
	function isApproved($filename)
	{
		$flagApproved = false;
		
		$fileSearch = str_replace(self::EXT_CSV, self::EXT_APPROVEDCSV, $filename);

		if (file_exists($fileSearch)) {
			$flagApproved = true;
		}
		
		return $flagApproved;
	}
	
	/**
	 *  isApproved - check for approval
	 */
	function oldisApproved($filename)
	{
		$flagApproved = false;
		
		$list = $this->findApprovedListImportFiles();
		
		$matchFile = rtrim($filename, self::EXT_CSV);  // trim off file extension
		
		foreach ($list as $fileSearch) {
			$matchSearchFile = rtrim($fileSearch, self::EXT_APPROVEDCSV);  // trim off file extension
			if (strcmp($matchSearchFile, $matchFile) == 0) {
				$flagApproved = true;
				break;
			}
		}
		
		return $flagApproved;
	}
	
	/**
	 *  isPreviewed - check for preview
	 */
	function isPreviewed($filename)
	{
		$flagPreviewed = false;

		$fileSearch = str_replace(self::EXT_CSV, self::EXT_PREVIEWEDCSV, $filename);

		if (file_exists($fileSearch)) {
			$flagPreviewed = true;
		}
		
		return $flagPreviewed;
	}

	/**
	 *  isPreviewed - check for preview
	 */
	function oldisPreviewed($filename)
	{
		$flagPreviewed = false;
		
		$list = $this->findApprovedListImportFiles();
		
		$matchFile = rtrim($filename, self::EXT_CSV);  // trim off file extension
		
		foreach ($list as $fileSearch) {
			$matchSearchFile = rtrim($fileSearch, self::EXT_PREVIEWEDCSV);  // trim off file extension
			if (strcmp($matchSearchFile, $matchFile) == 0) {
				$flagPreviewed = true;
				break;
			}
		}
		
		return $flagPreviewed;
	}

	/**
	 *  makeFilesList - make a list of $ext files
	 */
	function makeFilesList($ext)
	{
		$csvList = array();
		$filename = '';
		$includePath = $this->includePath;
		
		// find all files in path
		$filenames = scandir($includePath);
		
		$found = false;
		
		// get the CSV files, make a list
		foreach ($filenames as $filename) {
			
			// is it a CSV file?
			$found = substr_count($filename, $ext);
			
			// yes, then add to list
			if ($found) {
				$found = false;
				
				$csvList[] = $filename;
			}
		}
		
		return $csvList;
	}
	
	/**
	 *  makePreviewTag - 
	 */
	function makePreviewTag($filename)
	{
		$newFilename = str_replace(self::EXT_CSV, self::EXT_PREVIEWEDCSV, $filename);
		
		$ret = touch($newFilename);
	
		return $ret;
	}

	/**
	 *  cutPreviewTag - 
	 */
	function cutPreviewTag($filename)
	{
		$newFilename = str_replace(self::EXT_CSV, self::EXT_PREVIEWEDCSV, $filename);
		
		$ret = $this->remove($newFilename);
	
		return $ret;
	}

	/**
	 *  cutApproveTag - 
	 */
	function cutApproveTag($filename)
	{
		$newFilename = str_replace(self::EXT_CSV, self::EXT_APPROVEDCSV, $filename);
		
		$ret = $this->remove($newFilename);
	
		return $ret;
	}

	/**
	 *  makePreviewed - 
	 */
	function makePreviewed($filename)
	{
		$ret = $this->makePreviewTag($filename);
		
		return $ret;
	}

	/**
	 *  makeApproved - 
	 */
	function makeApproved($filename)
	{
		$ret = 0;

		if (strlen($filename)) {
			$this->cutPreviewTag($filename);
			
			$this->makeApproveTag($filename);

			$ret = 1;
		}

		return $ret;
	}

	/**
	 *  makeRejected - 
	 */
	function makeRejected($filename)
	{
		$ret = 0;

		if (strlen($filename)) {
			$this->cutPreviewTag($filename);
			
			$this->remove($filename);

			$ret = 1;
		}
		
		return $ret;
	}

	/**
	 *  makeApproveTag - 
	 */
	function makeApproveTag($filename)
	{
		$newFilename = str_replace(self::EXT_CSV, self::EXT_APPROVEDCSV, $filename);
		
		$ret = touch($newFilename);
	
		return $ret;
	}

	/**
	 *  reList - recover an old csv, putting it back ready to be used. note: it must still be around, after a week or more it will be gone.
	 */
	function reList($filename)
	{
		$ret = false;
		$newFilename = '';
		
		$newFilename = str_replace(self::EXT_OLDCSV, self::EXT_CSV, $filename);
		
		if (file_exists($filename)) {
			$ret = rename($filename, $newFilename);
		}
		
		return $ret;
	}
	
	/**
	 *  remove - delete a file
	 */
	function remove($filename)
	{
		$ret = false;
		
		if (file_exists($filename)) {
			$ret = unlink($filename);
		}
	
		return $ret;
	}
	
	/**
	 *  findFilesToPurge - clean out old csv files that are a week or more old
	 */
	function findFilesToPurge($weeks = self::WEEKS_TO_PURGE, $dateFlag = true)
	{
		$csvList = array();
		$filename = '';
		$includePath = $this->includePath;
	
		if ($weeks < 0) {
			$weeks = self::WEEKS_TO_PURGE;
		}
		
		$week = self::WEEK_LENGTH * $weeks;  // 604800 seconds
	
		// find all files in path
		$filenames = scandir($includePath);
		
		$found = false;
		
		// get the CSV files, make a list
		foreach ($filenames as $filename) {
			
			// is it an old CSV file?
			$found = substr_count($filename, self::EXT_OLDCSV);
			
			// yes, then add to list
			if ($found) {
				$found = false;
				
				if ($dateFlag) {
					$fileStats = stat($this->includePath . $filename);
					$past = $fileStats['mtime'];
					$now = time();
	
					// determine if file is older than number of weeks, thus stale and time to purge it
					$old = (($now - $past) >= $week ? true : false);
	
					if ($old) {
						$csvList[] = $filename;
					}
				} else {
					$csvList[] = $filename;
				}
				
			}
		}
		
		return $csvList;
	}

	/**
	 *  findCurrentFile - 
	 */
	function findCurrentFile($flagShort = false)
	{
		$fileName = '';
		$includePath = $this->includePath;
		$filenames   = $this->findListImportFiles();
		
		if (count($filenames) > 0) {
			$file = $filenames[0];
			$fileName = $includePath . $file;
		}
		
		// give us the actual file without the full path
		if ($flagShort) {
			$fileName = $this->shortFileName($fileName);
		}
	
		return $fileName;
	}
	

	/**
	 *  shortFileName - 
	 */
	function shortFileName($filename)
	{
		$x = explode('/', $filename);
		
		$count = count($x);
		
		$file = $x[$count - 1];
		
		return $file;
	}
	
}  // end class
// ****************************************
// ****************************************
// ****************************************
