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

require_once($includePath . 'DBInterfaceController.php');

// FEDORA -  Flexible Extensible Digitial Object and Repository Architecture

/** 
 * class FedoraModel - Pass citations and uploaded files from Biblio into Fedora via FOXML.
 * 
 */
class FedoraModel
{
	public $className;
	public $dbi        = 0;
	public $throttleFlag = false;
	public $throttle     = 100;

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
		//$this->dbi = new DBInterfaceController();
		$this->dbi = new Fedora_DBInterfaceController();
		
		$this->getConfigs();
	}

	/**
	 * getConfigs - set defaults
	 */
	function getConfigs()
	{
		$configs = array();
		
//		$configs['throttle']     = 1000;
//		$configs['throttleFlag'] = true;
//		
//		$configs['hostServer']   = 'http://172.16.17.197:8080/fedora/';
//		$configs['namespace']    = 'citebank';

		$configs['throttle']     = variable_get('citebank_fedora_commons_throttle', 1000);
		$configs['throttleFlag'] = (variable_get('citebank_fedora_commons_throttleflag', true) ? true : false);  // 1 or 0 in database
		
		$configs['hostServer']   = variable_get('citebank_fedora_commons_hostserver', 'http://172.16.17.197:8080/fedora/');  // FIXME: get the production setting
		$configs['namespace']    = variable_get('citebank_fedora_commons_namespace', 'citebank');

		$configs['loggingFlag']  = (variable_get('citebank_fedora_commons_loggingflag', true) ? true : false);  // 1 or 0 in database
		
		$configs['processFlag']  = (variable_get('citebank_fedora_commons_processflag', 0) ? 1 : 0);  // 1 or 0 in database

		$configs['fedoraUser']    = variable_get('citebank_fedora_commons_fedorauser', 'fedoraAdmin');
		$configs['fedoraPass']    = variable_get('citebank_fedora_commons_fedorapass', 'fedoraAdmin');

		$this->throttleFlag = $configs['throttleFlag'];
		$this->throttle     = $configs['throttle'];
		
		return $configs;
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
		
		$limits = '';
		if ($this->throttleFlag) {
			$limits = ' LIMIT ' . $this->throttle;
			
		}
		$sql = 'SELECT * FROM ' . $tbl . ' WHERE fedora_status = ' . $status . $limits;
		
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

// SELECT bcd.name, bcd.lastname, bcd.firstname, bcd.prefix, bcd.suffix, bcd.initials FROM biblio_contributor_data AS bcd JOIN biblio_contributor AS bc ON (bcd.cid = bc.cid) WHERE bc.nid = 72749
	/**
	 * getCitationContributors - get biblio data
	 */
	function getCitationContributors($nodeId)
	{
		$sql = 'SELECT bcd.name, bcd.lastname, bcd.firstname, bcd.prefix, bcd.suffix, bcd.initials FROM biblio_contributor_data AS bcd JOIN biblio_contributor AS bc ON (bcd.cid = bc.cid) WHERE bc.nid = ' . $nodeId . ' ORDER BY bcd.cid';

		$data = $this->dbi->fetch($sql);
//fedora_watchmen('getCitationContributors ' . print_r($data, true));

		return $data;
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
	 * getKeywordsList - get list of keywords for a biblio node
	 */
	function getKeywordsList($nodeId)
	{
		// done
		// SELECT d.word FROM biblio AS b JOIN node AS n ON (b.nid = n.nid) JOIN biblio_keyword AS k ON (b.nid = k.nid) JOIN biblio_keyword_data AS d ON (k.kid = d.kid) WHERE b.nid = 30518 ORDER BY d.word 
		
		$sql = 'SELECT d.word FROM biblio AS b JOIN node AS n ON (b.nid = n.nid) JOIN biblio_keyword AS k ON (b.nid = k.nid) JOIN biblio_keyword_data AS d ON (k.kid = d.kid) WHERE b.nid = ' . $nodeId . ' ORDER BY d.word';
		
		$rows = $this->dbi->fetch($sql);
		
		return $rows;
	}

	/**
	 *  getPublicationTypesData - get number values for word values of publication types
	 */
	function getPublicationTypesData(&$publicationNames, &$publicationKeys, &$listFlag)
	{
		$sql = 'SELECT * FROM {biblio_types}';
		$res = db_query($sql);

		if ($res) {
			while ($data = db_fetch_object($res)) {
				$key  = $data->tid;
				$name = $data->name;

				$publicationNames[strtolower($name)] = $key;
				$publicationKeys[$key] = $name;
			}

			if (count($publicationNames) > 0) {
				$listFlag = true;
			}
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
