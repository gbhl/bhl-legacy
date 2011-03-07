<?php

// $Id: FedoraCommonsModel.php,v 1.0.0.0 2010/10/12 4:44:44 dlheskett $

/** FedoraCommonsModel class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 10/12/2010
 *
 */

//$includePath = dirname(__FILE__) . '/';

// FEDORA - Flexible Extensible Digital Object Repository Architecture
// OAIS   - Open Archival Information System

/** 
 * class FedoraCommonsModel - 
 * 
 */
class FedoraCommonsModel
{
	public $className;

	const CLASS_NAME    = 'FedoraCommonsModel';

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
