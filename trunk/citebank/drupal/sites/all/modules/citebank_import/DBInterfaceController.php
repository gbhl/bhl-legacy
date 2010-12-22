<?php
// $Id: DBInterfaceController.php,v 1.0.0.0 2010/11/15 4:44:44 dlheskett $

/**  DBInterfaceController class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 05/02/2010
 *
 */

$includePath = dirname(__FILE__) . '/';

//require_once($includePath . 'DatabaseConfig.php');

// ****************************************
// ****************************************
// ****************************************


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
		
		// the cheesy part is parsing out and relying on the fact that there is four db_url tags including ones in comments
		// and since including the setting.php file whereever we want the config data will blow up pretty badly,
		// we have to muddle through and dig out the vital piece we need.  yay, drupal.
		// sure, we could use drupals system for all this, except sometimes all that baggage really is in the way of getting things done.
		// drupal, like a mystery puzzle, travel light years to get something simple accomplished, sheesh
		$star = explode('$db_url =', $x);  // find the db url info, keep in mind the comments have the tag too, brilliant.
		$gate = $star[4];                  // get the (hopefully) correct one
		$sg = explode("'", $gate);
		$sg = $sg[1];                      // and get the actual config data
		
		return $sg;
	}

	/**
	 *  getDatabaseConfig - parse out the config data 
	 */
	function getDatabaseConfig($dburl)
	{
		$a = explode('//', $dburl);
		$b = explode(':', $a[1]);
		$c = explode('@', $b[1]);
		$d = explode('/', $c[1]);
		
		$user = $b[0];
		$pass = $c[0];
		$host = $d[0];
		$base = $d[1];
		
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