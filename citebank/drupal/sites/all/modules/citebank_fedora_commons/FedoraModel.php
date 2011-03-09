<?php
// $Id: FedoraModel.php,v 1.0.0.0 2010/10/12 4:44:44 dlheskett $

/** FedoraModel class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 10/12/2010
 *
 */

$includePath = dirname(__FILE__) . '/';

//require_once($includePath . 'DBInterfaceController.php');

// FEDORA -  Flexible Extensible Digitial Object and Repository Architecture

/** 
 * class FedoraModel - Pass citations and uploaded files from Biblio into Fedora via FOXML.
 * 
 */
class FedoraModel
{
	public $className;
	public $dbi        = 0;

	const CLASS_NAME    = 'FedoraController';

	const FEDORA_TABLE  = 'citebank_fedora_commons_records';
	const BIBLIO_TABLE  = 'biblio';
	const NODE_TABLE    = 'node';

	// status states
	const FDC_ERROR     = -2;
	const FDC_IGNORE    = -1;
	const FDC_TRANSFER  = 0;
	const FDC_SENT      = 1;

	// update states
	const FDC_UPDATE    = 1;
	const FDC_NO_UPDATE = 0;

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
		$this->dbi = new DBInterfaceController();
	}


// SELECT COUNT(*) FROM node AS n WHERE n.type = 'biblio'

/* 
	table:
		citebank_fedora_commons
		
	fields:
		citebank_fedora_commons_id
		nid
		fedora_status
		created
		

*/
	/**
	 * collectCitations - 
	 */
	function collectCitations()
	{
		$tbl = self::NODE_TABLE;
		
		// SELECT nid FROM node AS n WHERE n.type = 'biblio' ORDER BY nid
		$sql = 'SELECT nid FROM ' . $tbl . " as n WHERE n.type = 'biblio'" . ' ORDER BY nid';

		$data = $this->dbi->fetch($sql);

		return $data;
	}

	/**
	 * collectNewCitations - 
	 */
	function collectNewCitations()
	{
		$list = $this->getNidsArrayNewItems();

		return $list;
	}

	/**
	 * getCitationList - 
	 */
	function getCitationList($status)
	{
		$tbl = self::FEDORA_TABLE;
		
		$sql = 'SELECT * FROM ' . $tbl . ' WHERE fedora_status = ' . $status;
		
		$data = $this->dbi->fetchobjlist($sql);

		return $data;
	}

	/**
	 * addCitationItem - 
	 */
	function addCitationItem($nid, $status)
	{
		$tbl = self::FEDORA_TABLE;
		$created = date('YmdHis');
		
		$sql = 'INSERT INTO ' . $tbl . ' SET nid  = ' . $nid . ', fedora_status = ' . $status . ', created = \''. $created . '\'';
		
		$data = $this->dbi->insert($sql);

		return $data;
	}

	/**
	 * getNidsArrayNewItems - combine biblio nodes list and fedora nodes list, reduce to ones that should be new ones
	 */
	function getNidsArrayNewItems()
	{
		$biblios = $this->getNidsArrayBiblio();
		
		$fedoras = $this->getNidsArrayFedora();
		
		$biglist = array_diff($biblios, $fedoras);
		
		$newItems = array_unique($biglist);
		
		return $newItems;
	}

	/**
	 * getNidsArrayBiblio - get array of nodes that are biblio type
	 */
	function getNidsArrayBiblio()
	{
		//SELECT n.nid FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE n.type = 'biblio' ORDER BY n.nid
		$sql = "SELECT n.nid FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE n.type = 'biblio' ORDER BY n.nid";

		$records = array();

		$recordList = $this->dbi->fetchobjlist($sql);

		if (count($recordList) > 0) {
			foreach ($recordList as $record) { 
				$records[$record->nid] = $record->nid;
			}
		}
		
		return $records;
	}

	/**
	 * getNidsArrayArchive - get array of nodes in archive records
	 */
	function getNidsArrayFedora()
	{
		// SELECT c.nid FROM citebank_internet_archive_records AS c  WHERE 1 ORDER BY c.nid
		$sql = 'SELECT c.nid FROM ' . self::FEDORA_TABLE . ' AS c  WHERE 1 ORDER BY c.nid';
		
		$records = array();

		$recordList = $this->dbi->fetchobjlist($sql);

		if (count($recordList) > 0) {
			foreach ($recordList as $record) { 
				$records[$record->nid] = $record->nid;
			}
		}
		
		return $records;
	}

	/**
	 * getFedoraStats - get number of node records; ignored, ready, sent
	 */
	function getFedoraStats()
	{
		$stats = array();
	
		$ignored = $this->getFedoraCountStatus(self::FDC_IGNORE);

		$ready = $this->getFedoraCountStatus(self::FDC_TRANSFER);

		$sent = $this->getFedoraCountStatus(self::FDC_SENT);
		
		$stats['ignored'] = $ignored;
		$stats['ready']   = $ready;
		$stats['sent']    = $sent;
		
		return $stats;
	}

	/**
	 * getFedoraCountStatus - get number of records
	 */
	function getFedoraCountStatus($status)
	{
		// SELECT COUNT(*) AS total FROM citebank_fedora_commons_records WHERE fedora_status = 0
		$sql = 'SELECT count(*) as total FROM '. self::FEDORA_TABLE . ' WHERE fedora_status = ' . $status;
		$record = $this->dbi->fetchobj($sql);
		$total = $record->total;

		return $total;
	}

	/**
	 * getCitationData - get biblio data
	 */
	function getCitationData($nodeId)
	{
		$sql = 'SELECT * FROM biblio as b JOIN node as n ON (n.nid = b.nid) WHERE b.nid = ' . $nodeId . '';

		$data = $this->dbi->fetch($sql);

		return $data[0];
	}

	/**
	 * setFedoraState - 
	 */
	function setFedoraState($status, $nodeId)
	{
		$tbl = self::FEDORA_TABLE;
		
		$sql = 'UPDATE ' . $tbl . ' SET fedora_status = ' . $status . ' WHERE nid = ' . $nodeId;
		
		$data = $this->dbi->update($sql);

		return $data;
	}

	/**
	 * handleCitations - 
	 */
	function handleCitations()
	{
		// done
	}

	/**
	 * listStats - 
	 */
	function listStats()
	{
		$tbl = self::FEDORA_TABLE;
		$sql = 'SELECT fedora_status, COUNT(*) AS total FROM ' . $tbl . ' GROUP BY fedora_status ORDER BY fedora_status';

		$rows = $this->dbi->fetch($sql);

		return $rows;
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
