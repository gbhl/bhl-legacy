<?php
// updates records from a previous import, setting rights data as either 'public domain' or 'in copyright' (and the other rights fields too).  Total was 660 records affected, 126 previous 1923 and 534 post 1923
// this is a self contained and one time purpose utility, might be useful for similar things in future as a quick template.  change some sqls and go.

$includePath = dirname(__FILE__) . '/';

if (!class_exists('DBInterfaceController')) {  // fixes issue with Drupal not adhereing to the require_once declaration
//	require_once($includePath . 'DBInterfaceController.php');

/**
 * class DBInterfaceController  - database interface to simplify database setup and calling
 *
 */
class DBInterfaceController
{
	private $db; 
	private $i;
	
	public $error;
	
	public $base;
	public $host;
	public $pass;
	public $user;
	
	/**
	 *  constructor - initializes some hard fixed values
	 */
	function __construct($db = '')//DEF_DATABASE)
	{
		$this->init();
		
		$db = $this->base;
		$this->db = $this->connect($db);
	}

	/**
	 *  init - initializes 
	 */
	function init()
	{
		// read $db_url from settings: sites/default/settings.php
		//$dburl = 'mysql://root:w2ffl3s1@localhost/test3';
		$dburl = $this->findTheDatabaseConfig();
		
		$this->getDatabaseConfig($dburl);
	}

	/**
	 *  connect - initializes connection
	 */
	function connect($database = '')//DEF_DATABASE)
	{
		$new_link = false;
		$database = $this->base;
		$host = $this->host;
		$user = $this->user;
		$pass = $this->pass;

		if ( !$db_mysql = mysql_connect($host, $user, $pass, $new_link) ) {
		//if ( !$db_mysql = mysql_connect(DB_HOST, DB_USER, DB_PASS, $new_link) ) {
			//die("Can't connect to mysql db!");
			echo(mysql_error()."\n");
			exit(12);
		}
		
		if ($database && !mysql_select_db($database, $db_mysql) ) {
			// can't select requested database
			echo(mysql_error()."\n");
			exit(13);
		}
    
    $this->db = $db_mysql;


		return $this->db;
	}

	/**
	 *  insert - sql insert
	 */
	function insert($sql)
	{
			$res = mysql_query($sql, $this->db);
	
			if (!$res) {
				print mysql_error($this->db)." $sql";
			}
				
		return $res;
		
	}

	/**
	 *  update - sql update
	 */
	function update($sql)
	{
			$res = mysql_query($sql, $this->db);
	
			if (!$res) {
				print mysql_error($this->db)." $sql";
			}
				
		return $res;
		
	}

	/**
	 *  select - sql select
	 */
	function select($sql) 
	{
	
			$res = mysql_query($sql, $this->db);
	
			if (!$res) {
				print mysql_error($this->db)." $sql";
			}
				
		return $res;
	}

	/**
	 *  fetch - sql select with associated array data
	 */
	function fetch($sql) 
	{
	
		$res = mysql_query($sql, $this->db);
		$data = array();

		while ( ($row = mysql_fetch_assoc($res)) ) {
			$data[] = $row;
		}

		return $data;
	}

	/**
	 *  fetchobj - sql select with object array data
	 */
	function fetchobj($sql) 
	{
		$res = mysql_query($sql, $this->db);

		$data = @mysql_fetch_object($res);

		return $data;
	}

	/**
	 *  fetch - sql select with associated array data
	 */
	function fetchobjlist($sql) 
	{
		$res = mysql_query($sql, $this->db);
		$rows = array();

		while ( ($row = mysql_fetch_object($res)) ) {
			$rows[] = $row;
		}

		return $rows;
	}

	/**
	 *  findHostPath - get the host path info
	 */
	function findHostPath()
	{
		$includePath = dirname(__FILE__) . '/';
		// /var/www/test3.citebank.org/sites/all/modules/citebank_importer
		// ex:  host = test3.citebank.org
		
		$s = explode('/', $includePath);
		$host = $s[3];
	
		return $host;
	}
	
	/**
	 *  findTheDatabaseConfig - find the database config info from the drupal settings file.  yes, this is a tad cheesy, live with it.  if only drupal had a proper config file!
	 */
	function findTheDatabaseConfig()
	{
		// read drupals config file, and parse out the database setting config
		$hostpath = $this->findHostPath();
		$settingsFile = '/var/www/'.$hostpath.'/sites/default/'.'settings.php';
		$x = file_get_contents($settingsFile);

		$lines = explode("\n", $x);  // break apart on newlines
		
		$dbStr = '';
		
		// hunt for the active line with the config variable
		foreach ($lines as $line) {
			
			if ($line[0] == '$') {
				$hit = substr_count($line, '$db_url =');
				
				if ($hit) {
					$dbStr = $line; // and get the actual config data

					// clear out the junk
					$dbStr = str_replace('$db_url =', '', $dbStr);
					$dbStr = str_replace("'", '', $dbStr);
					$dbStr = str_replace(';', '', $dbStr);					
					$dbStr = str_replace(' ', '', $dbStr);					
					$dbStr = str_replace("\n", '', $dbStr);
					$dbStr = trim($dbStr);

					break;
				}
			}
		}

		return $dbStr;
	}

	/**
	 *  getDatabaseConfig - parse out the config data 
	 */
	function getDatabaseConfig($dburl)
	{
		$x = parse_url($dburl);

		$user = $x['user'];
		$pass = $x['pass'];
		$host = $x['host'];
		$base = str_replace('/', '', $x['path']);
		
		$database['base'] = $base;
		$database['host'] = $host;
		$database['pass'] = $pass;
		$database['user'] = $user;
	
		$this->base = $base;
		$this->host = $host;
		$this->pass = $pass;
		$this->user = $user;

		return $database;
	}
	
}  // end class
// ****************************************
// ****************************************
// ****************************************


}

/**
 * class DBInterfaceController  - database interface to simplify database setup and calling
 *
 */
class updater
{
	private $dbi; 

	/**
	 * _construct - constructor
	 */
	function __construct()
	{
		$this->dbi = new DBInterfaceController();
	}


	/**
	 * getNidsArrayArchive - get array of nodes in archive records
	 */
	function getListPublic()
	{
		$sql = 'SELECT n.nid FROM node AS n JOIN import_undo AS u ON (n.nid = u.nid) JOIN biblio AS b ON (n.nid = b.nid) WHERE b.biblio_year < 1923 AND b.biblio_year > 0 ORDER BY b.biblio_year, n.nid';
		
		$records = array();

		$recordList = $this->dbi->fetch($sql);

		if (count($recordList) && !empty($recordList)) {
			foreach ($recordList as $key => $record) { 
				$nid = $record['nid'];
				$records[$nid] = $nid;
			}
		}
		
		return $records;
	}

	/**
	 * getNidsArrayArchive - get array of nodes in archive records
	 */
	function getListCopy()
	{
		$sql = 'SELECT n.nid FROM node AS n JOIN import_undo AS u ON (n.nid = u.nid) JOIN biblio AS b ON (n.nid = b.nid) WHERE b.biblio_year >= 1923 ORDER BY b.biblio_year, n.nid';
		
		$records = array();

		$recordList = $this->dbi->fetch($sql);

		if (count($recordList) && !empty($recordList)) {
			foreach ($recordList as $key => $record) { 
				$nid = $record['nid'];
				$records[$nid] = $nid;
			}
		}
		
		return $records;
	}

	/**
	 * getNidsArrayArchive - get array of nodes in archive records
	 */
	function setRightsItemPublic($nid)
	{
		$sql = "UPDATE biblio AS ba SET ba.biblio_custom1 = 'public domain' WHERE ba.nid = " . $nid . "";
		
		$this->dbi->update($sql);
		//echo $sql; echo "\n";
	}

	/**
	 * getNidsArrayArchive - get array of nodes in archive records
	 */
	function setRightsItemCopyright($nid)
	{
		$sql = "UPDATE biblio AS ba SET ba.biblio_custom1 = 'in copyright',  ba.biblio_custom2 = 'Permission to host granted on behalf of The East Africa Natural History Society', ba.biblio_custom3 = 'Attribution-NonCommercial-ShareAlike 3.0 Unported', ba.biblio_custom4 = 'http://creativecommons.org/licenses/by-nc-sa/3.0/' WHERE ba.nid = " . $nid . "";
		
		$this->dbi->update($sql);
		//echo $sql; echo "\n";
	}


}



$x = new updater();

$list = $x->getListPublic();

foreach ($list as $key => $nid) {
	$x->setRightsItemPublic($nid);
}

$listCopy = $x->getListCopy();

foreach ($listCopy as $key => $nid) {
	$x->setRightsItemCopyright($nid);
}

?>
