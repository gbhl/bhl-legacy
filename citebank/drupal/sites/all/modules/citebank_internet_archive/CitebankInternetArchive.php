<?php
// $Id: CitebankInternetArchive.php,v 1.0.0.0 2011/01/28 4:44:44 dlheskett $

/** CitebankInternetArchive class
 *
 * Copyright (c) 2010-2011 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 01/28/2011
 *
 */


$includePath = dirname(__FILE__) . '/';

//require_once($includePath . 'InternetArchiveModel.php');


/** 
 * class CitebankInternetArchive - 
 * 
 */
class CitebankInternetArchive
{
	public $className;

	const CLASS_NAME    = 'CitebankInternetArchive';

	/**
	 * _construct - constructor
	 */
	function __construct()
	{
		$this->initDefaults();
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

?>
