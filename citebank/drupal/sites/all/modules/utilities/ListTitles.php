<?php

/*

This will create a listing of all the biblio records, ordered by title and then node id (nid).
It shows nid and title.  Probably a handy list for someone looking at the records. 

run it like this from a browser, putting the file in the cbuid directory
(drupal will not get in the way of this path, since it is not an installed module)

http://citebank.org/sites/all/modules/cbuid/ListTitles.php

It may take a short time to run.  

Copy the text file from the server, 
delete it and the php file, (so it won't be accidently run somehow).

*/

$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'DBInterfaceController.php');

class DBInterfaceController_ListTitles extends DBInterfaceController
{

}

$x = new ListTitles();
$x->processList();

/** 
 * class ListTitles - handle creating a report log file, text based
 * 
 */
class ListTitles
{
	public $fp              = null;
	
	const CLASS_NAME        = 'ListTitles';

	const RPT_FILENAME      = 'ListTitles.txt';
	//const RPT_FILENAME      = 'ListTitlesPensoft.txt';
	//const RPT_FILENAME      = 'ListTitlesPensoft1.txt';

	
	/**
	 * _construct - constructor
	 */
	function __construct()
	{
		//$this->initDefaults();
		$this->dbi = new DBInterfaceController_ListTitles();
	}

	/**
	 * processList - 
	 */
	function processList()
	{
		//$filename = 'titlelisting.txt';
		$fp = fopen(self::RPT_FILENAME, 'w');
		
		if ($fp) {
			$this->fp = $fp;
		}

		//select nid, title from node order by title;
		//$sql = 'SELECT nid, title FROM node ORDER BY title, nid LIMIT 50';
		//$sql = "SELECT nid, title FROM node WHERE TYPE = 'biblio' ORDER BY title, nid LIMIT 500";
		//SELECT n.nid, n.title FROM node AS n JOIN biblio AS b ON (b.nid = n.nid) WHERE b.biblio_label LIKE '%Pensoft%' AND n.type = 'biblio' ORDER BY n.title, n.nid LIMIT 10;

		$sql = "SELECT nid, title FROM node WHERE TYPE = 'biblio' ORDER BY title, nid";
		//$sql = "SELECT n.nid, n.title FROM node AS n JOIN biblio AS b ON (b.nid = n.nid) WHERE b.biblio_label LIKE '%Pensoft%' AND n.type = 'biblio' ORDER BY n.title, n.nid";

		$titleList = $this->dbi->fetch($sql);
		
		foreach ($titleList as $titleItem) {
			//$msg = '' . $titleItem['nid'] . ' ' . (trim($titleItem['title']) ? $titleItem['title'] : 'NO TITLE') . ' ';
			$msg = '' . $titleItem['nid'] . (strlen($titleItem['nid']) == 6 ? '' : ' ') . ' ' . (trim($titleItem['title']) ? $titleItem['title'] : 'NO TITLE') . ' ';
			fprintf($this->fp, '%s', $msg);
			fprintf($this->fp, '%s', PHP_EOL);
		}

		if ($this->fp) {
			fclose($this->fp);
		}
		
		echo date('YmdHis');
	}

	/**
	 * _toString - stringify
	 */
	function __toString()
	{
		$info = '';

		$info .= '';

		return $info;
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
