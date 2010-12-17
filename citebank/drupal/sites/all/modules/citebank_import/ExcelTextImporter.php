<?php
// $Id: ExcelTextImporter.module,v 1.0.0.0 2010/09/15 4:44:44 dlheskett $

/** ExcelTextImporter.module
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 10/05/2010
 *
 */

/**
 * ExcelTextImporter - 
 */
function ExcelTextImporter_help($path, $arg)
{
}

/** ExcelTextImporter class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/15/2010
 *
 */

//$includePath = dirname(__FILE__) . '/';

//require_once($includePath . 'ExcelTextImporter.php');

/** 
 * class ExcelTextImporter - pipe delim data to biblio 
 * 
 */
class ExcelTextImporter
{
	public $className;
	public $importData;
	public $biblioData;

	const CLASS_NAME    = 'ExcelTextImporter';
	

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
		$this->className = self::CLASS_NAME;
	}

	/** 
	 *  parseDelimitedData - 
	 */
	function parseDelimitedData($data, $sortFlag = false)
	{
		$len = strlen($data);
		
		$items = explode('|', $data);
		
		foreach ($items as $item) {
			$field = explode(':', $item);
			
			$list[trim($field[0])] = trim($field[1]);
		}
	
		if ($sortFlag) {
			ksort($list); // sort on the keys
		}
		
		return $list;
	}

	/**
	 * processFileIntoBiblioData - read a csv file, prepped with a mapping header, hand back biblio mapped data
	 */
	function processFileIntoBiblioData($dataFile)
	{
		$fld = '';
		$map = '';
		$items = '';
		$max = 0;

		// read a file
		$fileData = file_get_contents($dataFile);
		
		// clear out bogus new lines in the data (newlines in a data field)
		// leaves intact the row ending newline as a pipe
		$fileData = $this->filterNewlines($fileData);
		
		// rows marked by pipes, shove the rows into a handy array
		$lines = explode('|', $fileData);
		
		$rowNum = 0;
		// loop through the rows
		foreach ($lines as $row) {
			switch ($rowNum)
			{
				case 0:
					// first row - fields header
					$fld = $row;
					$rowNum++;
					break;

				case 1:
					// second row - biblio mapping
					$map = $row;
					$rowNum++;
					break;

				default:
					$rowNum++;
					// third plus rows - rows of data
					if($row) {
						$items .= $row;
						$items .= "\n";
					}
					break;
			}
		}
			
		// break up the fields, csv has commas, but the text does too
		// smartly make the field commas into pipes, leaving the other text commas alone
		$items = $this->convertCommasToPipes($items);
	
		$delim = ','; // for our header and mapping rows
		
		$biblio = array();
		$biblioItem = array();

		// the first two rows: the given header titles, and our mapping name row
		// our names in position with the headers we map to, one to one match
		$fieldHeaders = explode($delim, $fld);
		$maps   = explode($delim, $map);
		
		// number of fields
		$max = count($fieldHeaders);

		$delim = '|';  // for the data rows, since we want to preserve commas in text but need fields separated differently
		$rows   = explode("\n", $items);  // each line is a row of data
		foreach ($rows as $kk => $row) {

			// break the row into fields
			$fields   = explode($delim, $row);
			// move through the row and assign each field it's data
			foreach ($fields as $k => $v) {
				if ($k >= 0 && $k < $max) {
					if ($maps[$k]) {
						$biblioItem[$maps[$k]] = $v;  // put the value of the data field into a biblio field, mapping it relative to the header field
					}
				}
			}
			
			$biblio[] = $biblioItem; // build up the biblio entries
			unset($biblioItem);
			$biblioItem = array();
		}
		
		return $biblio;  // an array of biblio entries
	}

	/**
	 * convertCommasToPipes - change commas to pipes | and also preserve commas within quoted text
	 */
	function convertCommasToPipes($data)
	{
		
		$len = strlen($data);
		$flag = false;
		
		for ($x = 0; $x < $len; $x++) {
			
			switch ($data[$x])
			{
				case ',':
					if ($flag) {
						// ignore it, move on
					} else {
						$data[$x] = '|';  // make it a pipe
					}
					break;
					
				case '"':
					// toggle flag
					$flag = ($flag ? false : true);
					break;
					
				default:
					break;
			}
		}
		
		return $data;
	}

	/**
	 * filterNewlines - 
	 */
	function filterNewlines($dataFile)
	{
		// replace \r\n with pipe
		// replace \n with space

		$len = strlen($dataFile);
		
		for ($x = 0; $x < $len; $x++) {
			$c = $dataFile[$x];
			switch($c)
			{
				case "\r":
					$dataFile[$x] = '~';
					break;

				case "\n":
					$dataFile[$x] = '*';
					break;

				default:
					break;
			}
		}

		$dataFile = str_replace('~*', '|', $dataFile);
		$dataFile = str_replace('*', ' ', $dataFile);
		
		return $dataFile;
	}

	/**
	 * getProviderData - read a file, parse out the org, prj, url info
	 */
	function getProviderData($dataFile)
	{
		if (empty($dataFile)) {
			return;
		}
		
		// read a file
		$fileData = file_get_contents($dataFile);
		$data   = explode(',', $fileData);
		
		$provider['org'] = $data[0];
		$provider['prj'] = $data[1];
		$provider['url'] = $data[2];
		
		return $provider;
	}

	/**
	 * _toString - stringify
	 */
	function __toString()
	{
		$info = '';
		$info .= $this->className;
		//$info .= '<br>';
		//$info .= "\n";
		//$info .= var_export($this, true);

		return $info;
	}
	
	
}  // end class
// ****************************************
// ****************************************
// ****************************************
