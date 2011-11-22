<?php
// $Id: CitebankUniqueIdentifierProcessor.php,v 1.0.0.0 2011/09/30 4:44:44 dlheskett $

/**  CitebankUniqueIdentifierProcessor class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/30/2011
 *
 */


$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'CitebankUniqueIdentifierModel.php');


/** 
 * class CitebankUniqueIdentifierProcessor - holds a drupal node data item
 * 
 */
class CitebankUniqueIdentifierProcessor
{
	public $dbi        = 0;
	public $flag = false;

	public $model = null;
	
	const CLASS_NAME    = 'CitebankUniqueIdentifierProcessor';

	const CBID  = '12345';

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
		$this->model = new CitebankUniqueIdentifierModel();
	}

	/**
	 * stub - process the node, store it or something
	 */
	function stub($node)
	{
	}

	/**
	 * createTable - build the table
	 */
	function createTable()
	{
		// table: citebank_unique_identifier
		
		// nid     - node id
		// link    - url  (used to check for previous source, also used as destination if 'active')
		// active  - 1 = use this link, 0 = not a primary
		// created - yyyymmdd item created
		// status  - link status, indicate if url is 404 or such, status types to be determined(20111007)
		// changed - when status changed
		// altflag - url to use if primary is unavailable  1 = alternate url to use, 0 = not specified
		
		$flag = $this->model->createTable();
	}

	/**
	 * isTable - 
	 */
	function isTable()
	{
		$flag = false;
		
		$flag = $this->model->isTable();
		
		return $flag;
	}	

	/**
	 * setUp - this should be a one time process, executed once to build and populate the table
	 */
	function setUp()
	{
		$flag = $this->model->setUp();
		
		return $flag;
	}

	/**
	 * createList - build the initial list and fill an empty table
	 */
	function createList()
	{
		
		// SELECT nid, biblio_url FROM biblio ORDER BY nid DESC LIMIT 4;
		// SELECT nid, biblio_url FROM biblio ORDER BY nid LIMIT 4;
		
		// SELECT nid, biblio_url FROM citebank_internet_archive_records ORDER BY nid LIMIT 4;
		
	}

	/**
	 * getHighestNid - get the highest nid number
	 */
	function getHighestNid()
	{
		$nid = 0;
		
		$nid = $this->model->getHighestNid();
		
		return $nid;
	}

	/**
	 * getLowestNid - get the lowest nid number
	 */
	function getLowestNid()
	{
		$nid = 0;
		
		$nid = $this->model->getLowestNid();
		
		return $nid;
	}

	/**
	 * getLowestNid - get the lowest nid number
	 */
	function countBiblioNids()
	{
		$total = 0;
		
		$total = $this->model->countBiblioNids();
		
		return $total;
	}

	/**
	 * markActive - flag item as the active link
	 */
	function markActive($nid)
	{
		$this->model->markActive($nid);
	}

	/**
	 * markDormant - flag item as the dormant link
	 */
	function markDormant($nid)
	{
		$nid = $this->model->markDormant($nid);
	}

	/**
	 * maintainList - keep list up to date, adding new entries that have come in
	 */
	function maintainList()
	{
	}

	/**
	 * setDb - set the database handle
	 */
	function setDb($dbi)
	{
		$this->dbi = $dbi;
		$this->flag = true;

		$this->model->setDb($dbi);
	}

	/**
	 * add - process the node, store it or something
	 */
	function add($node, $url)
	{
		// nid     - node id
		// link    - url  (used to check for previous source, also used as destination if 'active')
		// active  - 1 = use this link, 0 = not a primary
		// created - yyyymmdd item created
		// status  - link status, indicate if url is 404 or such, status types to be determined(20111007)
		// changed - when status changed
		// altflag - url to use if primary is unavailable  1 = alternate url to use, 0 = not specified
		
		$alreadyHave = $this->checkDuplicate($url);

		if (!$alreadyHave) {
			$this->model->add($node, $url);
		}
	}

	/**
	 * update - process the node, store it or something
	 */
	function update($node)
	{
		$this->model->update($node, $url);
	}

	/**
	 * remove - process the node, store it or something
	 */
	function remove($node)
	{
		$this->model->remove($node, $url);
	}


	/**
	 * checkDuplicate - process the node, store it or something
	 */
	function checkDuplicate($url)
	{
		$flag = $this->model->checkDuplicate($url);

		return $flag;
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
