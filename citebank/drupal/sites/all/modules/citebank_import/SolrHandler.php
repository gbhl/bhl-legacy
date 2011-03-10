<?php
// $Id: SolrHandler.php,v 1.0.0.0 2011/03/09 4:44:44 dlheskett $

/**  SolrHandler class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 03/09/2011
 *
 */


$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'DBInterfaceController.php');

/** 
 * class SolrHandler - handles Solr queue for nodes
 * 
 */
class SolrHandler
{
	public $dbi        = 0;
	public $isSolrFlag = false;
	public $isSolrFlagChecked = false;
	
	const CLASS_NAME    = 'SolrHandler';

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
		$this->dbi = new DBInterfaceController();
	}

	/**
	 * isSolr - check if solr exists and set flags to notify of state
	 */
	function isSolr()
	{
		$solrFlag = false;

		$sql = "SHOW TABLES LIKE 'apachesolr_search_node'";
		$row = $this->dbi->fetch($sql);

		if (count($row) > 0) {
			$solrFlag = true;
		}
		
		$this->isSolrFlag = $solrFlag;    // flag if solr exists or not, true = the table exists, false = no table
		$this->isSolrFlagChecked = true;  // checked if solr exists

		return $solrFlag;
	}

	/**
	 * touchSolr - add or update a node to the solr queue if solr exists
	 */
	function touchSolr($nid)
	{
		$touchedSolrFlag = false;
		
		if (!$this->isSolrFlagChecked) {
			$this->isSolr();
		}
		
		// if Solr exists, check if nid is current, if so update the time, else create the entry and add the time
		if ($this->isSolrFlag) {
			// look for the nid in solr, if we find it we update it, else we insert it
			$sql = 'SELECT solr.nid, solr.changed FROM apachesolr_search_node solr WHERE nid = ' . $nid;
			$row = $this->dbi->fetch($sql);
			
			if (count($row) > 0) {
				// nid exists, update it, set changed = time()
				$sql = 'UPDATE apachesolr_search_node SET changed = ' . time() . ', status = 1 WHERE nid = ' . $nid . '';
				$this->dbi->update($sql);
				
				$touchedSolrFlag = true;
			} else {
				// no nid entry, add it, set changed = time()
				$sql = 'INSERT INTO apachesolr_search_node (nid, status, changed) VALUES (' . $nid . ', 1, ' . time() . ')';
				$this->dbi->insert($sql);

				$touchedSolrFlag = true;
			}
		}

		return $touchedSolrFlag;
	}

	/**
	 * addNewNodesToSolr - find all the nodes that are biblio entries, and that are not listed in solr and add them to the solr queue
	 */
	function addNewNodesToSolr()
	{
		$addNewNodesToSolrFlag = false;
		
		if (!$this->isSolrFlagChecked) {
			$this->isSolr();
		}

		if ($this->isSolrFlag) {
			$sql = "SELECT nid FROM node WHERE TYPE = 'biblio' AND nid > (SELECT nid FROM apachesolr_search_node ORDER BY nid DESC LIMIT 1) ORDER BY nid ASC";
			
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows)) {
				foreach ($rows as $row) {
					$nid = $row['nid'];
					$this->touchSolr($nid);
				}
				
				$addNewNodesToSolrFlag = true;
			}
		}

		return $addNewNodesToSolrFlag;
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
