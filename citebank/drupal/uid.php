<?php
// citebank.org/uid.php?id=33670
// staging.citebank.org/uid.php?id=33670

$includePath = dirname(__FILE__) . '/';
//require_once($modulesPath . 'DBInterfaceController.php');
//require_once($includePath . 'sites/all/modules/citebank_internet_archive/DBInterfaceController.php');
require_once($includePath . 'sites/all/modules/cbuid/DBInterfaceController.php');
/** 
 * class DBInterfaceController_Uid - extended database handler, for this process
 * 
 */
class DBInterfaceController_Uid extends DBInterfaceController
{

}


$dbi = new DBInterfaceController_Uid();

// get input node id
$itemNodeId = $_REQUEST['id'];
$url = '';

$x = new UidHandler();
$x->setDb($dbi);
$id = $x->cleanse($itemNodeId);
$url = $x->lookupUrl($id);

// push user to the pdf, or if invalid input to the default site
if ($url) {
	header('Location: ' . $url);
} else {
	header('Location: http://www.citebank.org');
}

// **********************************************************************

/** 
 * class UidHandler - unique identification system handler, small set of needed functions packaged up (easier to cut and paste core functions into)
 * 
 */
class UidHandler
{
	public $dbi                = null;
	public $flag               = false;

	const ID_TABLE             = 'citebank_unique_identifier';

	/**
	 * _construct - constructor
	 */
	function __construct()
	{
		$this->dbi = null;
		$this->flag = false;
	}

	/**
	 * setDb - set the database handle
	 */
	function setDb($dbi)
	{
		$this->dbi = $dbi;
		$this->flag = true;
	}

	/**
	 * lookupUrl - given a nid (node id), find the url from a possible list of urls for the node, the particular active one that we should use
	 */
	function lookupUrl($nid)
	{
		$url = '';

		if (is_numeric($nid)) {
			// SELECT link FROM citebank_unique_identifier WHERE nid = 33670 ORDER BY citebank_unique_identifier_id DESC limit 1;
			$sql = 'SELECT link FROM ' . self::ID_TABLE . ' WHERE nid = ' . $nid . ' ORDER BY citebank_unique_identifier_id DESC limit 1';
			//$sql = 'SELECT link FROM ' . self::ID_TABLE . ' WHERE nid = ' . $nid . ' AND active = 1 AND prime = 1 ORDER BY citebank_unique_identifier_id DESC limit 1';
	
			if ($this->flag) {
				$record = $this->dbi->fetchobj($sql);
		
				if ($record) {
					$url = $record->link;
				}
			}
		}
		
		return $url;
	}

	/**
	 * cleanse - clean up the input to avoid hackery
	 */
	function cleanse($aNodeId)
	{
		// clean the input
		$aNodeId = htmlspecialchars(stripslashes($aNodeId));
		$aNodeId = str_ireplace('script', 'blocked', $aNodeId);
		$aNodeId = mysql_real_escape_string($aNodeId);
		
		return $aNodeId;
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
