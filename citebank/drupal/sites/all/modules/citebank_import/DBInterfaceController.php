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

require_once($includePath . 'DatabaseConfig.php');

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
	
	/**
	 *  constructor - initializes some hard fixed values
	 */
	function __construct($db = DEF_DATABASE)
	{
		$this->db = $this->connect($db);
	}

	/**
	 *  init - initializes 
	 */
	function init()
	{
		
	}

	/**
	 *  connect - initializes connection
	 */
	function connect($database = DEF_DATABASE)
	{
		$new_link = false;

		if ( !$db_mysql = mysql_connect(DB_HOST, DB_USER, DB_PASS, $new_link) ) {
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
	
}  // end class
// ****************************************
// ****************************************
// ****************************************
