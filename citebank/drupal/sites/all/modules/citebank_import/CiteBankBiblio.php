<?php
// $Id: CiteBankBiblio.php,v 1.0.0.0 2010/11/17 4:44:44 dlheskett $

/**  CiteBankBiblio class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 11/17/2010
 *
 */


$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'DrupalNode.php');
require_once($includePath . 'BiblioNode.php');
require_once($includePath . 'BiblioAuthorHandler.php');
//require_once($includePath . 'DBInterfaceController.php');
require_once($includePath . 'DBInterfaceController_3.php');


/** 
 * class CiteBankBiblio - holds a drupal node data item
 * 
 */
class CiteBankBiblio
{
	public $dbi        = 0;
	public $drupalNode = 0;
	public $biblioNode = 0;
	public $nid = 0;
	public $vid = 0;
	public $fid = 0;
	public $node = null;
	
	const CLASS_NAME    = 'CiteBankBiblio';

	// FIXME: this will need further work really, to make it more dynamic
	const DOS_SIGNATURE         = 'C:';
	const PATH_FILES_STORED_DOS = 'test/lib/';
	const PATH_FILES_STORED     = 'sites/default/files/';

	const DIR_HOST_PATH         = 'wamp/www/';
	const DIR_HOST_PATH_ACTUAL  = 'www/';

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
		//$this->dbi = new DBInterfaceController();
		$this->dbi = new DBInterfaceController_3();
		$this->drupalNode = new DrupalNode();
		$this->biblioNode = new BiblioNode();
	}

	/**
	 * stub - process the node, store it or something
	 */
	function stub($node)
	{
	}

	/**
	 * createNodeAndAttachment - 
	 */
	function createNodeAndAttachment($title, $uid, $filename, $filesize)
	{
		// ***** ***** make a node
		// ***** ***** get the node id  nid
		$nid = $this->makeNodeRecord($title, $uid);
		$this->makeNodeAccessRecord($nid);
		
		// ***** ***** make a files record
		// ***** ***** get the files id  fid
		$fid = $this->makeFilesRecord($filename, $filesize, $uid);
		
		$this->nid = $nid;
		$this->fid = $fid;
		
		$vid = $this->vid;

		//makeSqlForDBUpload
		// ***** ***** make an uploads record (to complete the attachement)
		$this->makeUploadsRecord($fid, $nid, $vid, $filename);
	}

	/**
	 * createAttachment - 
	 */
	function createAttachment($title, $uid, $filename, $filesize, $nid)
	{
		// ***** ***** get the node id  nid
		
		// ***** ***** make a files record
		// ***** ***** get the files id  fid
		$fid = $this->makeFilesRecord($filename, $filesize, $uid);
		
		$this->nid = $nid;
		$this->fid = $fid;
		
		$vid = $this->vid;

		//makeSqlForDBUpload
		// ***** ***** make an uploads record (to complete the attachement)
		$this->makeUploadsRecord($fid, $nid, $vid, $filename);
	}

	/**
	 * createNode - 
	 */
	function createNode($title)
	{
		$this->makeNodeRecord($title, 0);
	}

	// ***** ***** make a node
	/**
	 * makeNodeRecord - 
	 */
	function makeNodeRecord($title, $uid)
	{
		$nid = $this->getNid() + 1;
		$vid = $this->getVid($nid - 1) + 1;
		$this->nid = $nid;
		$this->vid = $vid;
		$this->drupalNode->nid = $nid;
		$this->drupalNode->vid = $vid;  // FIXME: do we need a vid?  it is set to nid (node id)
		
		$node = $this->drupalNode->makeNode($title, $uid);
		$this->node = $node;
		
		$sql = $this->drupalNode->makeSql($node, false);
		$this->dbi->insert($sql);
		//echo $sql;  echo '<br>'."\n";  // FIXME: remove
		
		return $nid;
	}

	/**
	 * makeNodeRevisionsRecord - 
	 */
	function makeNodeRevisionsRecord($nid, $vid, $title, $uid)
	{
		$sql = $this->drupalNode->makeSqlForNodeRevisions($nid, $vid, $title, $uid);
		$this->dbi->insert($sql);
		
		return $nid;
	}

	/**
	 * makeBiblioRecord - 
	 */
	function makeBiblioRecord($biblio)
	{
		$nid = $this->nid;
		$vid = $this->vid;
		$this->biblioNode->nid = $nid;
		$this->biblioNode->vid = $vid;

		$this->biblioNode->setDataByNodeX($biblio);
		$biblio = $this->biblioNode->processNode(null);
		
		$sql = $this->biblioNode->makeSql($biblio);
		$this->dbi->insert($sql);
		//echo $sql;  echo '<br>'."\n";  // FIXME: remove
	}

//	function testBAR($author, $nid)
//	{
//		$this->nid = $nid;
//		$this->makeBiblioAuthorRecord($author);
//	}

	/**
	 * makeBiblioAuthorRecord - 
	 */
	function makeBiblioAuthorRecord($author)
	{
		$nid = $this->nid;
		$vid = $this->vid;

		// if multiple authors, then do a loop, else the one
		$authorHandle = new BiblioAuthorHandler();
		$flagMultiple = $authorHandle->hasMultipleAuthors($author);

		if ($flagMultiple) {
			$authors = $authorHandle->makeAuthorList($author);
			foreach ($authors as $key => $author) {
				$authorName = $authorHandle->preParseName($author);

				$sql = $this->drupalNode->makeBiblioContributorData($authorName);
				$this->dbi->insert($sql);
			
				$sql = $this->drupalNode->getContributorDataCid();

				$result = $this->dbi->fetch($sql);
				$cid = $result[0]['cid'];
		
				$sql = $this->drupalNode->makeBiblioContributor($nid, $vid, $cid);

				$this->dbi->insert($sql);
			}
		} else {
			$authorName = $authorHandle->preParseName($author);

			$sql = $this->drupalNode->makeBiblioContributorData($authorName);

			$this->dbi->insert($sql);
			
			$sql = $this->drupalNode->getContributorDataCid();

			$result = $this->dbi->fetch($sql);
			$cid = $result[0]['cid'];
	
			$sql = $this->drupalNode->makeBiblioContributor($nid, $vid, $cid);

			$this->dbi->insert($sql);
		}

		$sql = $this->drupalNode->getFixContributorDataAka();
		$this->dbi->update($sql);

	}

	// ***** ***** get the node id  nid
	/**
	 * getNid - 
	 */
	function getNid()
	{
		$nid = 0;

		$sql = $this->drupalNode->findLastNidSql();
		
		$result = $this->dbi->fetch($sql);
		$nid = $result[0]['nid'];
		
		return $nid;
	}

	// ***** ***** get the voc id  vid
	/**
	 * getVid - 
	 */
	function getVid($nid)
	{
		$vid = 0;

		$sql = $this->drupalNode->findLastVidSql($nid);
		
		$result = $this->dbi->fetch($sql);
		$vid = $result[0]['vid'];
		
		return $vid;
	}

	// ***** ***** make a files record
	/**
	 * makeFilesRecord - 
	 */
	function makeFilesRecord($filename, $filesize, $uid)
	{
		$sql = $this->drupalNode->makeSqlForDBFiles($filename, $filesize, $uid);
		$this->dbi->insert($sql);

		$fid = $this->getFid($filename);
		$this->fid = $fid;
		
		return $fid;
	}

	// ***** ***** get the files id  fid
	/**
	 * getFid - 
	 */
	function getFid($filename)
	{
		$fid = 0;

		$sql = $this->drupalNode->getFilesFid($filename);
		
		$result = $this->dbi->fetch($sql);
		if($result) {
			$fid = $result[0]['fid'];
			$this->fid = $fid;
		}
		
		return $fid;
	}

	/**
	 * makeNodeAccessRecord - 
	 */
	function makeNodeAccessRecord($nid)
	{
		$sql = $this->drupalNode->makeSqlForNodeAccess($nid);
		$this->dbi->insert($sql);
	}

	// ***** ***** make an uploads record (to complete the attachement)
	/**
	 * makeUploadsRecord - 
	 */
	function makeUploadsRecord($fid, $nid, $vid, $filename)
	{
		$sql = $this->drupalNode->makeSqlForDBUpload($fid, $nid, $vid, $filename);
		$this->dbi->insert($sql);
	}

// add a biblio record
//    and its author(s)
//    and its keyword(s)

// add a files, given filename
//   extension should determine mime type?

	/**
	 * display - 
	 */
	function display($str)
	{
		echo '<br>' . "\n";
		echo $str;
		echo "\n";
		echo '<br>' . "\n";
	}

	/**
	 * docRootPath - get us a path, if via web or command line
	 */
	function docRootPath()
	{
		$path1 = $_SERVER['DOCUMENT_ROOT'];
		$path2 = $_SERVER['PWD'];
		
		$path = ($path1 ? $path1 : $path2);
		
		return $path;
	}

	/**
	 * constructFilePath - build a correct file path to the data store for the given file name.
	 */
	function constructFilePath($filename)
	{
		$rootplus = $this->docRootPath();
		
		$count = substr_count($rootplus, 'sites/all');
		
		if ($count) {
			// problem, $_SERVER['DOCUMENT_ROOT'];  is not available via command line call, we get an empty string.
			// remedy, below.
			// cleverness here:
			// all the code sitting under drupal resides in 'sites/all', so it's a good key to split on cleanly
			// so, we have something like:
			//  /var/www/test3.citebank.org/sites/all/more/dirs/here...
			// we want:
			//  /var/www/test3.citebank.org/
			// so drop everything after including 'sites/all....'
			//
			$parts = explode('sites/all', $rootplus);
			$root = $parts[0];
		} else {
			$root = $rootplus;
		}
		
		$filepath = $root . '/' . self::PATH_FILES_STORED . $filename;
	
		return $filepath;
	}

	/**
	 * getFileSize - 
	 */
	function getFileSize($filename)
	{
		$isDos = false;
		
		// detect host type, unix or dos, sniff out dos.  we need to know which for file path directory separators
		$rootstr = $this->docRootPath();
		$isDos = substr_count($rootstr, self::DOS_SIGNATURE);
	
		$path = self::PATH_FILES_STORED;
		if ($isDos) {
			$path = self::PATH_FILES_STORED_DOS;
		}
			
		//$filename = 'lavoie_OAIS.pdf';  // test name that exists on test servers
		$filepath = $this->constructFilePath($filename);

		if ($isDos) {
			$filepath = str_replace(self::DIR_HOST_PATH, self::DIR_HOST_PATH_ACTUAL, $filepath);  // change the wamp server path to web server path
			$filepath = str_replace('/', '\\', $filepath);  // unix dir separator to dos dir separator
		}

		// now find the size of the file we are looking for
		$filesize = @filesize($filepath);

		// file not found
		if (!$filesize) {
			$filesize = 0;  // nothing, nothing...
		}
	
		return $filesize;
	}
	
//	/**
//	 * addRecordTest - test the process
//	 */
//	function addRecordTest($title, $filename, $uid = 0, $filesize = 0)
//	{
//		// bulletproofing ****
//		if (strlen($filename) == 0) {
//			echo 'error: no filename';
//			return;
//		}
//
//		if (strlen($title) == 0) {
//			echo 'error: no title';
//			return;
//		}
//
//		if ($uid == 0) {
//			;//
//		}
//
//		if ($filesize == 0) {
//			// get the files size
//			$filesize = $this->getFileSize($filename);
//		}
//		// bulletproofing ****
//
//		// make a node
//		// get the node id  nid
//		// make a files record
//		// get the files id  fid
//		// make an uploads record (to complete the attachement)
//		$this->createNodeAndAttachment($title, $uid, $filename, $filesize);
//	}

	/**
	 * addCiteBankRecord - add an attachment record, also adds a drupal node
	 */
	function addCiteBankRecord($title, $filename, $biblio, $uid = 0, $filesize = 0)
	{
		// bulletproofing ****
		if (strlen($filename) == 0) {
			$errmsg = 'error: no filename ' . $filename;
			watchdog('CiteBankBiblio', $errmsg);  // drupal system call
			return;
		}

		if (strlen($title) == 0) {
			$errmsg = 'error: no title ' . $filename;
			watchdog('CiteBankBiblio', $errmsg);  // drupal system call
			return;
		}

		if ($uid == 0) {
			;//
		}

		if ($filesize == 0) {
			// get the files size
			$filesize = $this->getFileSize($filename);
		}
		// bulletproofing ****

		// make a node
		$this->makeNodeRecord($title, $uid);
		$this->makeNodeAccessRecord($this->nid);
		$this->makeNodeRevisionsRecord($this->nid, $this->vid, trim($title, '"'), $uid);
		
		// make a biblio record
		$this->makeBiblioRecord($biblio);
		
		// add the attachment
		$this->createAttachment($title, $uid, $filename, $filesize, $this->nid);
		
		// add the author(s)
		$this->makeBiblioAuthorRecord($biblio['biblio_contributors']);
		
		return $this->nid;
	}

//	/**
//	 * addRecord - add an attachment record, also adds a drupal node
//	 */
//	function addRecord($title, $filename, $uid = 0, $filesize = 0)
//	{
//		// bulletproofing ****
//		if (strlen($filename) == 0) {
//			echo 'error: no filename';
//			return;
//		}
//
//		if (strlen($title) == 0) {
//			echo 'error: no title';
//			return;
//		}
//
//		if ($uid == 0) {
//			;//
//		}
//
//		if ($filesize == 0) {
//			// get the files size
//			$filesize = $this->getFileSize($filename);
//		}
//		// bulletproofing ****
//
//		// make a node
//		// get the node id  nid
//		// make a files record
//		// get the files id  fid
//		// make an uploads record (to complete the attachement)
//		$this->createNodeAndAttachment($title, $uid, $filename, $filesize);
//	}

	/**
	 * checkDuplicate - 
	 */
	function checkDuplicate($biblio_url)
	{
		$duplicateFlag = false;

		$sql = 'SELECT count(*) AS total FROM biblio WHERE biblio_url = ' . "'" . $biblio_url . "'" . '';
		$row = $this->dbi->fetch($sql);
		
		// check if we got an entry, dup if we do
		if ($row[0]['total'] >= 1) {
			$duplicateFlag = true;
		}
		
		return $duplicateFlag;
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
