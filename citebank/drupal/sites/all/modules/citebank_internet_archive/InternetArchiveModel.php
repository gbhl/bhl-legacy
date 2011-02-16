<?php
// $Id: InternetArchiveModel.php,v 1.0.0.0 2011/01/18 4:44:44 dlheskett $

/** InternetArchiveModel class
 *
 * Copyright (c) 2010-2011 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 01/18/2011
 *
 */

$includePath = dirname(__FILE__) . '/';
require_once($includePath . 'S3Keys.php');
require_once($includePath . 'SimpleStorageServiceRequest.php');
require_once($includePath . 'SimpleStorageServiceModel.php');

// local testing stub
require_once($includePath . 'DBInterfaceController.php');

function db_query($sql)
{
	$x = new DBInterfaceController();

	$data = $x->fetch($sql);

	return $data;
}

function db_insert($sql)
{
	$x = new DBInterfaceController();

	$data = $x->insert($sql);

	return $data;
}

function db_update($sql)
{
	$x = new DBInterfaceController();

	$data = $x->update($sql);

	return $data;
}

function db_fetch_object($sql, $list = 0)
{
	$x = new DBInterfaceController();

	if ($list == 0) {
		$data = $x->fetchobj($sql);
	} else if ($list == 2) {
		$data = $x->fetch($sql);
	} else {
		$data = $x->fetchobjlist($sql);
	}

	return $data;
}

function db_fetch($sql)
{
	$x = new DBInterfaceController();
	$data = $x->fetch($sql);

	return $data;
}
// local testing stub


/** 
 * class InternetArchiveModel - handle data, format, communicate with Internet Archive, to place records there, both metadata and files.
 * 
 */
class InternetArchiveModel
{
	public $className;

  private $accessKey; // AWS Access key
  private $secretKey; // AWS Secret key
  
  private $s3;
  private $s3Model;

	const CLASS_NAME    = 'InternetArchiveModel';
	// TODO: put these in the database instead of here and have a drupal front end to change them
	const ACCESS_KEY    = S3_ACCESS_KEY;  // S3 Access key
	const SECRET_KEY    = S3_SECRET_KEY;  // S3 Secret key
	const LIMIT_THRESHOLD = 1000;

	const ARCHIVE_TABLE = 'citebank_internet_archive_records';
	
	//const MAXLENGTH = 15;  // max length of title to use
	const MAXLENGTH = 30;  // max length of title to use

	const DOI_PREFIX = '123456789';  // DOI prefix for BHL, Citebank, etc... (TBD, possibly will not be one)
	const PREFIX = 'cbarchive';      // prefix for BHL, Citebank, etc...
	
	const IASTATUS_IGNORE = -1;				// ignore item, do not transfer
	const IASTATUS_READY  = 0;				// ready to send
	const IASTATUS_SENT   = 1;				// sent
	
	const DBCMD_QUERY          = 1;				// 
	const DBCMD_QUERY_LIST     = 2;				// array of objects
	const DBCMD_FETCH          = 3;				// 
	const DBCMD_INSERT         = 4;				// 
	const DBCMD_UPDATE         = 5;				// 
	const DBCMD_FETCH_OBJ      = 6;				// 
	const DBCMD_FETCH_OBJ_LIST = 7;				// assoc array
	
	const PATH_MODULE          = 'all/modules/citebank_internet_archive';
	const PATH_FIX             = 'default/files';

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

		$this->accessKey = self::ACCESS_KEY;
		$this->secretKey = self::SECRET_KEY;
		
		$this->s3      = new SimpleStorageServiceRequest();
		$this->s3Model = new SimpleStorageServiceModel();
		
		$this->s3->setAccessKeys($this->accessKey, $this->secretKey);
		$this->s3Model->setS3Obj($this->s3);
		
		$this->checkAndAddNewNodesForArchive();
	}

	/**
	 * getData - database handling indirection, isolate drupal calls
	 */
	function getData($sql, $cmd = 0)
	{
		$data = '';
		
		$type = 1; // test
		//$type = 2; // drupal FIXME: set up to use drupal db calls
		
		if ($type == 1) {
			// internal
			switch ($cmd)
			{
				case 0:
					break;
					
				case self::DBCMD_QUERY:
					$data = db_fetch_object($sql);
					break;

				case self::DBCMD_QUERY_LIST:
				case 2:
					$data = db_fetch_object($sql, 1);
					break;

				case self::DBCMD_FETCH:
				case 3:
					$data = db_fetch($sql, 2);
					break;

				case self::DBCMD_INSERT:
				case 4:
					$data = db_insert($sql);
					break;

				case self::DBCMD_FETCH_OBJ:
					$data = db_fetch_object($sql, 0);
					break;

				case self::DBCMD_FETCH_OBJ_LIST:
					$data = db_fetch_object($sql, 2);
					break;

				case self::DBCMD_UPDATE:
					$data = db_update($sql);
					break;
			}
		} else {
			// drupal
			switch ($cmd)
			{
				case 0:
					break;
					
				case self::DBCMD_QUERY:
					$result = db_query($sql);
					$data = db_fetch_object($result);
					break;

				case self::DBCMD_QUERY_LIST:
				case 2:
					$result = db_query($sql);
					$data = db_fetch_object($result);
//		$result = db_query($sql);
//		
//		while ($record = db_fetch_object($result)) {
//			$records[] = $record->nid;
//		}
					break;

				case self::DBCMD_FETCH:
				case 3:
					$result = db_query($sql);
					////$record = db_fetch_object($result);
					$data = db_fetch_array($result);
					break;

				case self::DBCMD_INSERT:
				case 4:
					$data = db_query($sql);

		// $fields = 'nid, archive_status, ia_title, created';
		// $result = db_query("INSERT INTO {$table} ($fields) VALUES (%s, %s, %s, %s)", $nid, $archive_status, $ia_title, $created);
//		$data = array(
//		  'nid' => $nid,
//		  'archive_status' => $archive_status,
//		  'ia_title' => $ia_title,
//		  'created' => $created,
//		);
//		
//		$ret = drupal_write_record($table, $data);
					break;

				case self::DBCMD_FETCH_OBJ:
					$data = db_fetch_object($sql, 0);
					break;

				case self::DBCMD_FETCH_OBJ_LIST:
					$data = db_fetch_object($sql, 2);
					break;

				case self::DBCMD_UPDATE:
					$data = db_query($sql);
					break;
			}
		}

		return $data;
	}

	/**
	 * listBuckets - show list of buckets
	 */
	function listBuckets()
	{
		$list = $this->s3Model->listBuckets();
		
		return $list;
	}

	/**
	 * statusCheck - verify setup
	 */
	function statusCheck()
	{
		$flag = false;
		
		// note: archive_status
		//   -1  = ignore item, do not transfer
		//    0  = ready to send
		//    1  = sent
		//  IASTATUS_IGNORE = -1;
		//  IASTATUS_READY  = 0;
		//  IASTATUS_SENT   = 1;

		
		// if not set up, perform first time set up
			// get all nids, that are biblio
			// record those in citebank_internet_archive_records
			// mark as -1 ignore
			// self::IASTATUS_IGNORE
			
			// self::IASTATUS_READY
			// check if citebank hosted items
				// mark as 0, ready to transfer
			// check if bhl article pdfs
				// mark as 0, ready to transfer
		if (!$this->checkReadyToProcess($count)) {
			$this->oneTimeSetup();
			$flag = true;
		} else {
			$flag = true;
		}
		// else, we should check to see about adding new info since last time we looked?
		
		return $flag;
	}

	/**
	 * process - check if set up (if not perform setup), look for items to send, and send them
	 */
	function process()
	{
		$count = 0;
		$statusInfo = array();

		$title  = 'title';
		$year   = 'biblio_year';
		$url    = 'biblio_url';
			
		$nidList = $this->getAllReadyNids();
		
		$readyToProcess = count($nidList);

		if (!$readyToProcess) {
			// 'nothing to process';
			// FIXME: log done
			
			$statusInfo[] = array('nid' => 0, 'status' => 0);
			// done.
			return $statusInfo;
		}
			
		// get items to transfer (possibly build in some throttling)
			// list of nids, that are 0 ready
			// roll through nids
			// gather meta data for nid
			// transfer,
			//   make bucket, item, metadata
			//   send
			//   mark as 1 sent
			// self::IASTATUS_SENT
		foreach ($nidList as $n) {
			$nid            = $n->nid;

			$title          = $n->title;
			$year           = $n->year;
			$url            = $n->biblio_url;
			
			$flagString = false;
			
			// process
			$fileToSend = $this->getItem($nid);
			
			// check for remote file
			$remote = substr_count($url, 'http://www.biodiversitylibrary.org/pdf');

			// handle bhl article pdfs, pull the data from the url and send that "file"
			if ($remote) {
				// http://www.biodiversitylibrary.org/pdf1/000100100036793.pdf
				// bhl article pdf
				// use remote file
				$fileToSend = file_get_contents($url);  // get the remote file data
				$flagString = true;  // indicate that we need to send slightly differently
			}

			// build the IA (Internet Archive) name, the meta data, and send it over to IA
			$bucket     = $this->makeIARecordName($nid, $title, $year);
			$metaData   = $this->makeIARecordMetaData($nid);
			$status     = $this->putItem($fileToSend, $bucket, $metaData, $flagString);

			// check off our item in the queue, preserve the original link, note the IA name
			if ($status == 0) {
				$this->markSentToIA($nid);
				$this->updateBiblioUrl($nid, $bucket, $url);  // change biblio_url to www.archive.org/details/cbarchive_$nid_$bucket
			} else if ($status == -1) {
				// failed put file
				// log entry?

			} else if ($status == -2) {
				// failed make bucket
				// log entry?
			} else {
				// status == 1
				
			}

			$statusInfo[] = array('nid' => $nid, 'status' => $status);
		}

		return $statusInfo;
	}

	/**
	 * getItem - get items file
	 */
	function getItem($nid)
	{
		$item = '';
		
		$filename = $this->getFilesFilename($nid);

		if (strlen($filename) > 0) {
			$item = dirname(__FILE__).'/'.$filename; // dynamically grab file 
			// if file local
			// fix the pathing to where we store the uploaded content
			$cutStr = self::PATH_MODULE;
			$item = str_replace($cutStr, self::PATH_FIX, $item);
		}

		return $item;
	}
	
	/**
	 * getFilesFilename - get items filename, table Files has filename of the upload link
	 */
	function getFilesFilename($nid)
	{
		$item = '';
		$flag = false;
		$resolverFlag = false;
		$openBrace = ($resolverFlag ? '{' : '');
		$clseBrace = ($resolverFlag ? '}' : '');
		
		// given a nid, we should be able to find a file for it
		$sql = 'SELECT fid FROM '. $openBrace . 'upload' . $clseBrace . ' WHERE nid = ' . $nid . '';
		$record = $this->getData($sql, self::DBCMD_FETCH_OBJ);

		$fid = $record->fid;
		
		// given a fid, we should be able to find the filename and path
		$sql = 'SELECT filepath, filename FROM '. $openBrace . 'files' . $clseBrace . ' WHERE nid = ' . $fid . '';
		$record = $this->getData($sql, self::DBCMD_FETCH_OBJ);

		$filename = $record->filename;  // get data file filename
		
		// if no file, then use the url, the bhl url.  which is handled later.
		
		return $filename;
	}

	/**
	 * putItem - put an item on Internet Archive
	 */
	function putItem($fileToSend, $bucket = '', $metaData = '', $flagString = false)
	{
		$status = 1;
		$uriName = 'document.pdf';

		$bucketName = $bucket;  // basically must be a unique identifier, like a serial number, that will be the IA entry name link
		// like so: http://www.archive.org/details/cbarchive_123456_booktitlegoeshere2011
		// bucketName = cbarchive_123456_booktitlegoeshere2011

		if (!$bucket) {  // where's mah bucket?
			return $status;
		}
		
		// the file we send to IA
		$uploadFile = $fileToSend;
		
		// if no file, fail
		if ($flagString == false) {  // if NOT a string, check the physical file.  if a "string" it is a remote pdf
			if (!file_exists($uploadFile) || !is_file($uploadFile)) {
				$status = -1; // no file?
				// log no file for x
				// log($str);
				return $status;
			}

			// object, can peel URI name from filename			
			// uriName: the name of the item that is put in the bucket, ie "test.pdf"
			$basename = baseName($uploadFile);
			$uriName = $this->filterSymbols($basename);
		} else {
			// string item, cut up the bucket name and peel out a reasonable file name (remember it is title and year)
			// uriName: the name of the item that is put in the bucket, ie "test.pdf"
			$namePieces = explode('_', $bucketName);
			$basename = $namePieces[2] . '.pdf';
			$uriName = $this->filterSymbols($basename);
		}

		// make an Internet Archive bucket, put the file and it's metadata there
		if ($this->s3Model->putBucket($bucketName)) {
			// if we are a file, put the object file; if we are a "string" (basically a pdf link), put the object string (and stream that pdf data over)
			if (($flagString ? $this->s3Model->putObjectString($uploadFile, $bucketName, $uriName, SimpleStorageServiceModel::ACL_PUBLIC_READ, $metaData) : $this->s3Model->putObjectFile($uploadFile, $bucketName, $uriName, SimpleStorageServiceModel::ACL_PUBLIC_READ, $metaData) ) ) {
				$status = 0;
			} else {
				// fails put the item
				$status = -1;
			}
		} else {
			// fails put the bucket
			$status = -2;
		}
		
		return $status;
	}

	/**
	 * setAuth - set authorization keys
	 */
	function setAuth($accessKey, $secretKey)
	{
		$this->accessKey = $accessKey;
		$this->secretKey = $secretKey;
	}

	/**
	 * nameFilter - filter out unwanted characters from name
	 */
	function nameFilter($name)
	{
		// http://www.archive.org/about/faqs.php#Uploading_Content
		//  "illegal". This includes the following characters in the name:
		// * ( ) { } [ ] / \ $ % @ # ^ & | < > ' ~ ` ! ? +
		// In addition, files and folders may not have spaces in their names.
		// You will need to remove any of these illegal characters by renaming the file(s) in order for the system to accept your contribution.
		
		// acceptable:
		// UTF8 encoded.
		// You can use accented and other special characters in your item text and file titles, 
		// but you need to make sure you use the xml-safe code for those characters instead of typing them directly into the forms.
		// see http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references

		$name = $this->cleanTitle($name);
		
		return $name;
	}

	/**
	 * checkReadyToProcess - are we ready to process
	 */
	function checkReadyToProcess(&$count)
	{
		$flag = false;
		
		// if we have some nids, then we should be set up
		$count = $this->getCountNids();
		
		if ($count > 0) {
			$flag = true;
		}
		
		return $flag;
	}

	/**
	 * getCountNids - get number of node records
	 */
	function getCountNids()
	{
		$flag = false;
		
		//$sql = 'SELECT count(*) as total FROM '. self::ARCHIVE_TABLE .' WHERE 1';
		$sql = 'SELECT count(*) as total FROM '. self::ARCHIVE_TABLE;

		$record = $this->getData($sql, self::DBCMD_QUERY);

		$total = $record->total;
		
		return $total;
	}

	/**
	 * getCountNewNodes - get number of new node records that are biblio entries
	 */
	function getCountNewNodes()
	{
		$totalNewNodes = 0;
		
		$countNodesBiblio       = $this->getCountNodesBiblio();        // all biblio node entries
		$countArchiveRecordNids = $this->getCountArchiveRecordNids();  // all archive nodes; items ignored, to send, and sent
		
		$totalNewNodes = $countNodesBiblio - $countArchiveRecordNids;

		return $totalNewNodes;
	}

	/**
	 * getCountNodesBiblio - get number of node records that are biblio entries
	 */
	function getCountNodesBiblio()
	{
		$flag = false;
		
		$sql = 'SELECT count(*) as total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid)';

		$record = $this->getData($sql, self::DBCMD_QUERY);

		$total = $record->total;
		
		return $total;
	}

	/**
	 * getCountArchiveRecordNids - get number of node records
	 */
	function getCountArchiveRecordNids()
	{
		$flag = false;
		
		$sql = 'SELECT count(*) as total FROM '. self::ARCHIVE_TABLE;

		$record = $this->getData($sql, self::DBCMD_QUERY);

		$total = $record->total;
		
		return $total;
	}

	/**
	 * getAllNids - get the records 
	 */
	function getAllNids()
	{
		$flag = false;
		
		$sql = 'SELECT * FROM '. self::ARCHIVE_TABLE . ' WHERE 1 ORDER BY nid';

		$records = $this->getData($sql, self::DBCMD_QUERY_LIST);

		return $records;
	}

	/**
	 * getAllReadyNids - get the records that are ready to send 
	 */
	function getAllReadyNids()
	{
		$flag = false;
		
		//$sql = 'SELECT * FROM '. self::ARCHIVE_TABLE . ' WHERE archive_status = ' . self::IASTATUS_READY . ' ORDER BY nid';
		//$sql = 'SELECT * FROM '. self::ARCHIVE_TABLE . ' WHERE archive_status = ' . self::IASTATUS_READY . ' ORDER BY nid';

		// adds title and year for naming later
		$sql = 'SELECT c.nid, n.title, b.biblio_year as year, b.biblio_url FROM '. self::ARCHIVE_TABLE . ' as c JOIN node as n ON (n.nid = c.nid) JOIN biblio as b ON (c.nid = b.nid) WHERE c.archive_status = ' . self::IASTATUS_READY . ' ORDER BY c.nid';
		// SELECT * FROM citebank_internet_archive_records AS c JOIN node AS n ON (n.nid = c.nid) JOIN biblio AS b ON (c.nid = b.nid) WHERE c.archive_status = 0 ORDER BY c.nid
		// SELECT c.nid, n.title, b.biblio_year as year FROM citebank_internet_archive_records AS c JOIN node AS n ON (n.nid = c.nid) JOIN biblio AS b ON (c.nid = b.nid) WHERE c.archive_status = 0 ORDER BY c.nid

		$records = $this->getData($sql, self::DBCMD_QUERY_LIST);

		return $records;
	}

	/**
	 * makeIARecordName - create the name to use for an Internet Archive entry
	 */
	function makeIARecordName($nid, $title = '', $year = '')
	{
		$recordName = '';
		$prefix = self::PREFIX;
		
		$title = $this->cleanTitle($title);
		
		$author = $this->cleanAuthor($author);

		$recordName = strtolower($prefix . '_' . $nid . '_' . $title . $year);
		// cbarchive_12345_bookofbutterfli1876
		
		return $recordName;
	}

	/**
	 * updateBiblioUrl - change biblio_url to www.archive.org/details/cbarchive_$nid_$bucket and remember old url
	 */
	function updateBiblioUrl($nid, $bucket, $url)
	{
		$table = self::ARCHIVE_TABLE;
		$ret = false;
		
		$bucketUrl = 'http://www.archive.org/details/' . $bucket . '';

		// set url and ia title in our queue table
		$sql = 'UPDATE ' . $table . ' SET biblio_url = ' . "'"  . $url . "'" . ', ia_title = ' . "'" . $bucket . "'" . ' WHERE nid = ' . $nid . '';
		$ret = $this->getData($sql, self::DBCMD_UPDATE);

		$ret = ($ret ? true : false);  // make if data, true else false

		// update biblio entry with IA url
		$sql = 'UPDATE biblio SET biblio_url = ' . "'" . $bucketUrl . "'" . ' WHERE nid = ' . $nid . '';
		$ret = $this->getData($sql, self::DBCMD_UPDATE);

		$ret = ($ret ? true : false);  // make if data, true else false

		return $ret;
	}

	/**
	 * getBiblioData - get biblio data
	 */
	function getBiblioData($nid)
	{
		$flag = false;
		
		$sql = 'SELECT * FROM biblio as b JOIN node as n ON (n.nid = b.nid) WHERE b.nid = '.$nid.'';

		$data = $this->getData($sql, self::DBCMD_FETCH);

		return $data[0];
	}

	/**
	 * makeIARecordMetaData - create the meta data for the nid item to use for an Internet Archive entry
	 */
	function makeIARecordMetaData($nid)
	{
		$metaData = array();
		
		// given nid, get the biblio data, title
		$node = $this->getBiblioData($nid);
		
		// fill in metadata
		// send back the array
		
		/*
			title
			year
			publisher
			biblio data?
		*/
		$biblio_abst_e                =  (isset($node['biblio_abst_e'])               ? $node['biblio_abst_e']               : '');
		$biblio_abst_f                =  (isset($node['biblio_abst_f'])               ? $node['biblio_abst_f']               : '');
		$biblio_access_date           =  (isset($node['biblio_access_date'])          ? $node['biblio_access_date']          : '');
		$biblio_accession_number      =  (isset($node['biblio_accession_number'])     ? $node['biblio_accession_number']     : '');
		$biblio_alternate_title       =  (isset($node['biblio_alternate_title'])      ? $node['biblio_alternate_title']      : '');
		$biblio_auth_address          =  (isset($node['biblio_auth_address'])         ? $node['biblio_auth_address']         : '');
		$biblio_call_number           =  (isset($node['biblio_call_number'])          ? $node['biblio_call_number']          : '');
		$biblio_citekey               =  (isset($node['biblio_citekey'])              ? $node['biblio_citekey']              : '');
		$biblio_coins                 =  (isset($node['biblio_coins'])                ? $node['biblio_coins']                : '');
		$biblio_contributors          =  (isset($node['biblio_contributors'])         ? $node['biblio_contributors']         : array());
		$biblio_custom1               =  (isset($node['biblio_custom1'])              ? $node['biblio_custom1']              : '');
		$biblio_custom2               =  (isset($node['biblio_custom2'])              ? $node['biblio_custom2']              : '');
		$biblio_custom3               =  (isset($node['biblio_custom3'])              ? $node['biblio_custom3']              : '');
		$biblio_custom4               =  (isset($node['biblio_custom4'])              ? $node['biblio_custom4']              : '');
		$biblio_custom5               =  (isset($node['biblio_custom5'])              ? $node['biblio_custom5']              : '');
		$biblio_custom6               =  (isset($node['biblio_custom6'])              ? $node['biblio_custom6']              : '');
		$biblio_custom7               =  (isset($node['biblio_custom7'])              ? $node['biblio_custom7']              : '');
		$biblio_date                  =  (isset($node['biblio_date'])                 ? $node['biblio_date']                 : '');
		$biblio_doi                   =  (isset($node['biblio_doi'])                  ? $node['biblio_doi']                  : '');
		$biblio_edition               =  (isset($node['biblio_edition'])              ? $node['biblio_edition']              : '');
		$biblio_full_text             =  (isset($node['biblio_full_text'])            ? $node['biblio_full_text']            : '');
		$biblio_isbn                  =  (isset($node['biblio_isbn'])                 ? $node['biblio_isbn']                 : '');
		$biblio_issn                  =  (isset($node['biblio_issn'])                 ? $node['biblio_issn']                 : '');
		$biblio_issue                 =  (isset($node['biblio_issue'])                ? $node['biblio_issue']                : '');
		$biblio_keywords              =  (isset($node['biblio_keywords'])             ? $node['biblio_keywords']             : array());
		$biblio_label                 =  (isset($node['biblio_label'])                ? $node['biblio_label']                : '');  // sourcePrj;
		$biblio_lang                  =  (isset($node['biblio_lang'])                 ? $node['biblio_lang']                 : '');
		$biblio_notes                 =  (isset($node['biblio_notes'])                ? $node['biblio_notes']                : '');
		$biblio_number                =  (isset($node['biblio_number'])               ? $node['biblio_number']               : '');
		$biblio_number_of_volumes     =  (isset($node['biblio_number_of_volumes'])    ? $node['biblio_number_of_volumes']    : '');
		$biblio_original_publication  =  (isset($node['biblio_original_publication']) ? $node['biblio_original_publication'] : '');
		$biblio_other_number          =  (isset($node['biblio_other_number'])         ? $node['biblio_other_number']         : '');
		$biblio_pages                 =  (isset($node['biblio_pages'])                ? $node['biblio_pages']                : '');
		$biblio_place_published       =  (isset($node['biblio_place_published'])      ? $node['biblio_place_published']      : '');
		$biblio_publisher             =  (isset($node['biblio_publisher'])            ? $node['biblio_publisher']            : '');
		$biblio_refereed              =  (isset($node['biblio_refereed'])             ? $node['biblio_refereed']             : '');
		$biblio_remote_db_name        =  (isset($node['biblio_remote_db_name'])       ? $node['biblio_remote_db_name']       : '');  // sourceUrl;
		$biblio_remote_db_provider    =  (isset($node['biblio_remote_db_provider'])   ? $node['biblio_remote_db_provider']   : '');  // sourceOrg;
		$biblio_reprint_edition       =  (isset($node['biblio_reprint_edition'])      ? $node['biblio_reprint_edition']      : '');
		$biblio_research_notes        =  (isset($node['biblio_research_notes'])       ? $node['biblio_research_notes']       : '');
		$biblio_secondary_title       =  (isset($node['biblio_secondary_title'])      ? $node['biblio_secondary_title']      : '');
		$biblio_section               =  (isset($node['biblio_section'])              ? $node['biblio_section']              : '');
		$biblio_short_title           =  (isset($node['biblio_short_title'])          ? $node['biblio_short_title']          : '');
		$biblio_tertiary_title        =  (isset($node['biblio_tertiary_title'])       ? $node['biblio_tertiary_title']       : '');
		//$biblio_title                 =  (isset($node['biblio_title'])              ? $node['biblio_title']                : '');
		$biblio_title                 =  (isset($node['title'])                       ? $node['title']                       : '');
		$biblio_translated_title      =  (isset($node['biblio_translated_title'])     ? $node['biblio_translated_title']     : '');
		$biblio_type                  =  (isset($node['biblio_type'])                 ? $node['biblio_type']                 : '');
		$biblio_type_of_work          =  (isset($node['biblio_type_of_work'])         ? $node['biblio_type_of_work']         : '');
		$biblio_url                   =  (isset($node['biblio_url'])                  ? $node['biblio_url']                  : '');
		$biblio_volume                =  (isset($node['biblio_volume'])               ? $node['biblio_volume']               : '');
		$biblio_year                  =  (isset($node['biblio_year'])                 ? $node['biblio_year']                 : '');

		// ******************************
		// set the meta data
		//
		//$metaData['type']                  = $biblio_type;
		//$metaData['number']                = $biblio_number;
		//$metaData['other_number']          = $biblio_other_number;

		if ($biblio_secondary_title) {
			$metaData['secondary_title']       = $biblio_secondary_title;
		}

		if ($biblio_tertiary_title) {
			$metaData['tertiary_title']        = $biblio_tertiary_title;
		}

		if ($biblio_edition) {
			$metaData['edition']               = $biblio_edition;
		}

		if ($biblio_publisher) {
			$metaData['publisher']             = $biblio_publisher;
		}

		if ($biblio_place_published) {
			$metaData['place_published']       = $biblio_place_published;
		}

		if ($biblio_year != 9999) {
			$metaData['year']                  = $biblio_year;
		}

		if ($biblio_volume) {
			$metaData['volume']                = $biblio_volume;
		}

		if ($biblio_pages) {
			$metaData['pages']                 = $biblio_pages;
		}

		if ($biblio_date) {
			$metaData['date']                  = $biblio_date;
		}

		//$metaData['isbn']                  = $biblio_isbn;

		if ($biblio_lang) {
			$metaData['language']              = $biblio_lang;
		}

		if ($biblio_abst_e) {
			$metaData['abstract']              = $biblio_abst_e;
		}

		if ($biblio_abst_f) {
			$metaData['abstract_f']            = $biblio_abst_f;
		}

		if ($biblio_full_text) {
			$metaData['full_text']             = $biblio_full_text;
		}

		if ($biblio_url) {
			$metaData['url']                   = $biblio_url;
		}

		if ($biblio_issue) {
			$metaData['issue']                 = $biblio_issue;
		}

		if ($biblio_type_of_work) {
			$metaData['type_of_work']          = $biblio_type_of_work;
		}

		if ($biblio_accession_number) {
			$metaData['accession_number']      = $biblio_accession_number;
		}

		if ($biblio_call_number) {
			$metaData['call_number']           = $biblio_call_number;
		}

		if ($biblio_notes) {
			$metaData['notes']                 = $biblio_notes;
		}

		//$metaData['custom1']               = $biblio_custom1;
		//$metaData['custom2']               = $biblio_custom2;
		//$metaData['custom3']               = $biblio_custom3;
		//$metaData['custom4']               = $biblio_custom4;
		//$metaData['custom5']               = $biblio_custom5;
		//$metaData['custom6']               = $biblio_custom6;
		//$metaData['custom7']               = $biblio_custom7;

		if ($biblio_research_notes) {
			$metaData['research_notes']        = $biblio_research_notes;
		}

		if ($biblio_number_of_volumes) {
			$metaData['number_of_volumes']     = $biblio_number_of_volumes;
		}

		if ($biblio_short_title) {
			$metaData['short_title']           = $biblio_short_title;
		}

		if ($biblio_alternate_title) {
			$metaData['alternate_title']       = $biblio_alternate_title;
		}

		if ($biblio_original_publication) {
			$metaData['original_publication']  = $biblio_original_publication;
		}

		if ($biblio_reprint_edition) {
			$metaData['reprint_edition']       = $biblio_reprint_edition;
		}

		if ($biblio_translated_title) {
			$metaData['translated_title']      = $biblio_translated_title;
		}

		if ($biblio_section) {
			$metaData['section']               = $biblio_section;
		}

		//$metaData['citekey']               = $biblio_citekey;
		//$metaData['coins']                 = $biblio_coins;

		if ($biblio_doi) {
			$metaData['doi']                   = $biblio_doi;
		}

		//$metaData['issn']                  = $biblio_issn;

		if ($biblio_auth_address) {
			$metaData['auth_address']          = $biblio_auth_address;
		}

		//$metaData['remote_db_name']        = $biblio_remote_db_name;
		//$metaData['remote_db_provider']    = $biblio_remote_db_provider;
		//$metaData['label']                 = $biblio_label;

		if ($biblio_remote_db_name) {
			$metaData['source_organization']   = $biblio_remote_db_name;
		}

		if ($biblio_remote_db_provider) {
			$metaData['source_url']            = $biblio_remote_db_provider;
		}

		if ($biblio_label) {
			$metaData['source_project']        = $biblio_label;
		}

		if ($biblio_access_date) {
			$metaData['access_date']           = $biblio_access_date;
		}

		if ($biblio_refereed) {
			$metaData['refereed']              = $biblio_refereed;
		}

		if ($biblio_title) {
			$metaData['title']                 = $biblio_title;
		}
		// ******************************
		
		return $metaData;
	}

	/**
	 * cleanAuthor - cleanse the string
	 */
	function cleanAuthor($author)
	{
		//return $this->cleanTitle($author, false);
		return $this->cleanTitle($author);
	}
	
	/**
	 * cleanTitle - cleanse the title
	 */
	function cleanTitle($giventitle, $allChars = true)
	{
		// take out " - : . space ( ) #
		
		// strip out for IA (Internet Archive) unwanted chars
		// * ( ) { } [ ] / \ $ % @ # ^ & | < > ' ~ ` ! ? +
		// and other odd chars, and take out spaces to compress into nice useable string
		//$search = array('*', '(', ')', '{', '}', '[', ']', '/', '\\', '$', '%', '@', '#', '^', '&', '|', '<', '>', "'", '~', '`', '!', '?', '+', '"', ':', '.', '-', ' ', ',');

		//$title = str_replace($search, '', $giventitle);
		$title = $this->cleanText($giventitle, $allChars);
		
		// remove preceding THE, A , OF , etc
		
		// chop to N characters
		$maxLength = self::MAXLENGTH; // 15
		$title = substr($title, 0, $maxLength);
		
		return $title;
	}

	/**
	 * cleanText - cleanse the text per IA requirements
	 */
	function cleanText($giventext, $allChars = true)
	{
		// take out " - : . space ( ) #
		
		// strip out for IA (Internet Archive) unwanted chars
		// * ( ) { } [ ] / \ $ % @ # ^ & | < > ' ~ ` ! ? +
		// and other odd chars, and take out spaces to compress into nice useable string
		if ($allChars) {
			$text = $this->filterOddChars($giventext);
		} else {
			$text = $this->filterSymbols($giventext);
		}

		return $text;
	}

	/**
	 * filterSymbols - cleanse the text per IA requirements
	 */
	function filterSymbols($giventext)
	{
		// take out " - : . space ( ) #
		
		// strip out for IA (Internet Archive) unwanted chars
		// * ( ) { } [ ] / \ $ % @ # ^ & | < > ' ~ ` ! ? +
		$search = array('*', '(', ')', '{', '}', '[', ']', '/', '\\', '$', '%', '@', '#', '^', '&', '|', '<', '>', "'", '~', '`', '!', '?', '+', '"');

		$text = str_replace($search, '', $giventext);
		
		return $text;
	}

	/**
	 * filterOddChars - cleanse the text per IA requirements
	 */
	function filterOddChars($giventext)
	{
		// take out " - : . space ( ) #
		
		// strip out for IA (Internet Archive) unwanted chars
		// * ( ) { } [ ] / \ $ % @ # ^ & | < > ' ~ ` ! ? +
		// and other odd chars, and take out spaces to compress into nice useable string
		$search = array('"', ':', '.', '-', ' ', ',');

		$text = str_replace($search, '', $giventext);
		
		return $text;
	}

	/**
	 * filterSymbols - cleanse the text per IA requirements
	 */
	function filterAllSymbols($giventext)
	{
		// take out " - : . space ( ) #
		
		// strip out for IA (Internet Archive) unwanted chars
		// * ( ) { } [ ] / \ $ % @ # ^ & | < > ' ~ ` ! ? +
		// and other odd chars, and take out spaces to compress into nice useable string
		$search = array('*', '(', ')', '{', '}', '[', ']', '/', '\\', '$', '%', '@', '#', '^', '&', '|', '<', '>', "'", '~', '`', '!', '?', '+', '"', ':', '.', '-', ' ', ',');

		$text = str_replace($search, '', $giventext);
		
		return $text;
	}

	/**
	 * getCountRecordsToDeliver - filter out records that we intend to send to IA
	 */
	function getCountRecordsToDeliver()
	{
		$total = 0;
		
		// do we send data for all nodes? No.
		// we send subset, 
		// all records that have data stored on citebank (and not stored elsewhere, citebank is acting as the online store of the data) has (records that have an attachment),
		// some BHL records (article pdfs)
		
		// SELECT n.nid, n.vid, f.filename, f.filepath, n.title FROM node AS n JOIN upload AS u ON n.nid = u.nid JOIN files AS f ON u.fid = f.fid WHERE n.nid = u.nid AND n.type = 'biblio' ORDER BY n.nid
		$sql = "SELECT count(*) as total FROM node AS n JOIN upload AS u ON n.nid = u.nid JOIN files AS f ON u.fid = f.fid WHERE n.nid = u.nid AND n.type = 'biblio' ORDER BY n.nid";

		$record = $this->getData($sql, self::DBCMD_FETCH_OBJ);

		$total = $record->total;
		
		return $total;
	}

	/**
	 * oneTimeSetup - check our citation data, find available items, if the item is new, mark it ready to send
	 */
	function oneTimeSetup()
	{
		//$num = $this->setNewNids();
		$num = $this->checkAndAddNewNodesForArchive();
		// FIXME: log number of new nodes 
		$this->setUpNids();
	}
	
	/**
	 * checkAndAddNewNodesForArchive - check if new nodes to add to listing to run through
	 */
	function checkAndAddNewNodesForArchive()
	{
		$countNewNodes = $this->getCountNewNodes();
		
		if ($countNewNodes > 0) {
			// find new ones
			$newNodes = $this->getNidsArrayNewItems();

			$archive_status = -1;
			$ia_title = 'blank';

			foreach ($newNodes as $nid) {
				$this->addArchiveRecord($nid, $archive_status, $ia_title);  // add them
			}
		}
		
		return $countNewNodes;
	}
	
	// get items ready to send to IA
	// SELECT * FROM biblio AS b JOIN citebank_internet_archive_records AS c ON b.nid = c.nid AND c.archive_status = 0
	//   includes title
	// SELECT b.nid, b.biblio_year, n.title, c.ia_title FROM biblio AS b JOIN node AS n ON b.nid = n.nid JOIN citebank_internet_archive_records AS c ON b.nid = c.nid AND c.archive_status = 0

// BHL article pdfs, exclude empty titles
// SELECT n.title, b.biblio_year, bcd.lastname, b.biblio_url FROM biblio AS b JOIN node AS n ON n.nid = b.nid JOIN biblio_contributor AS bc ON b.nid = bc.nid JOIN biblio_contributor_data AS bcd ON bc.cid = bcd.cid WHERE b.biblio_label = 'Biodiversity' AND b.biblio_url LIKE '%.pdf' AND n.title != '' ORDER BY n.title, b.biblio_year, bcd.lastname
// SELECT n.nid, n.title, b.biblio_year, bcd.lastname, b.biblio_url FROM biblio AS b JOIN node AS n ON n.nid = b.nid JOIN biblio_contributor AS bc ON b.nid = bc.nid JOIN biblio_contributor_data AS bcd ON bc.cid = bcd.cid WHERE b.biblio_label = 'Biodiversity' AND b.biblio_url LIKE '%.pdf' AND n.title != '' ORDER BY n.title, b.biblio_year, bcd.lastname

	/**
	 * getRecordsToDeliver - filter out records that we intend to send to IA
	 */
	function getRecordsToDeliver($limitFlag = false, $limit = self::LIMIT_THRESHOLD, $biblioFlag = false, $authorsFlag = false)
	{
		// do we send data for all nodes? No.
		// we send subset, 
		// all records that have data stored on citebank (and not stored elsewhere, citebank is acting as the online store of the data) has (records that have an attachment),
		// some BHL records (article pdfs)
		
		// SELECT n.nid, n.vid, f.filename, f.filepath, n.title FROM node AS n JOIN upload AS u ON n.nid = u.nid JOIN files AS f ON u.fid = f.fid WHERE n.nid = u.nid AND n.type = 'biblio' ORDER BY n.nid
		$sql = "SELECT n.nid, n.vid, f.filename, f.filepath, n.title FROM node AS n JOIN upload AS u ON n.nid = u.nid JOIN files AS f ON u.fid = f.fid WHERE n.nid = u.nid AND n.type = 'biblio' ORDER BY n.nid";

		// with biblio record:
		if ($biblioFlag) {
			// SELECT * FROM node AS n JOIN biblio AS b ON b.nid = n.nid JOIN upload AS u ON n.nid = u.nid JOIN files AS f ON u.fid = f.fid WHERE n.nid = u.nid AND n.type = 'biblio' ORDER BY n.nid
			$sql = "SELECT * FROM node AS n JOIN biblio AS b ON b.nid = n.nid JOIN upload AS u ON n.nid = u.nid JOIN files AS f ON u.fid = f.fid WHERE n.nid = u.nid AND n.type = 'biblio' ORDER BY n.nid";
		}

		// with biblio, with authors
		if ($biblioFlag) {
			// SELECT * FROM node AS n JOIN biblio AS b ON b.nid = n.nid JOIN biblio_contributor AS bc ON bc.nid = b.nid JOIN biblio_contributor_data AS bcd ON bcd.cid = bc.cid JOIN upload AS u ON n.nid = u.nid JOIN files AS f ON u.fid = f.fid WHERE n.nid = u.nid AND n.type = 'biblio' ORDER BY n.nid
			$sql = "SELECT * FROM node AS n JOIN biblio AS b ON b.nid = n.nid JOIN biblio_contributor AS bc ON bc.nid = b.nid JOIN biblio_contributor_data AS bcd ON bcd.cid = bc.cid JOIN upload AS u ON n.nid = u.nid JOIN files AS f ON u.fid = f.fid WHERE n.nid = u.nid AND n.type = 'biblio' ORDER BY n.nid";
		}
		
		if ($limitFlag) {
			$sql .= ' LIMIT ' . $limit;
		}

		$records = array();

		$records = $this->getData($sql, self::DBCMD_QUERY_LIST);
		
		return $records;
	}
// with biblio record:
// SELECT * FROM node AS n JOIN biblio AS b ON b.nid = n.nid JOIN upload AS u ON n.nid = u.nid JOIN files AS f ON u.fid = f.fid WHERE n.nid = u.nid AND n.type = 'biblio' ORDER BY n.nid

// with biblio, with authors
// SELECT * FROM node AS n JOIN biblio AS b ON b.nid = n.nid JOIN biblio_contributor AS bc ON bc.nid = b.nid JOIN biblio_contributor_data AS bcd ON bcd.cid = bc.cid JOIN upload AS u ON n.nid = u.nid JOIN files AS f ON u.fid = f.fid WHERE n.nid = u.nid AND n.type = 'biblio' ORDER BY n.nid

	/*
	
	Table:
	citebank_internet_archive_records
	
	Fields:
	id
	nid
	status      -1 = ignore, 0 = unsent, 1 = sent
	created   datetime (date time sent to IA)
	ia_title    created title for IA, also used to relink our url to IA
	
	populate with all nodes that are biblio entries. default to -1 ignore.
	
	look up all nodes that should be sent, set to 0, if is -1 already. (this will keep from overwriting any that already sent)
	
	*/
	
	/**
	 * addArchiveRecord - 
	 */
	function addArchiveRecord($nid, $archive_status, $ia_title)
	{
		$table = self::ARCHIVE_TABLE;
		$created = date('YmdHis');

		// INSERT INTO citebank_internet_archive_records SET nid = 1234, archive_status = 0, ia_title = 'butterflybook', created = '20110128044444';

		// I would prefer normal sql as opposed to drupals obfuscation.  surely you can't be serious?  I am serious, and don't call me Shirley.
		$sql = 'INSERT INTO ' . $table . ' SET nid = ' . $nid . ', archive_status = ' . $archive_status . ', ia_title = ' . "'" . $ia_title . "'" . ', created = \''. $created . '\'';
		$ret = $this->getData($sql, self::DBCMD_INSERT);

		return $ret;
	}
	
	/**
	 * markSentToIA - 
	 */
	function markSentToIA($nid)
	{
		$archive_status = 1;
		
		$this->updateArchiveRecordStatus($nid, $archive_status);
	}

	/**
	 * setUpNids - check our citation data, find available items, if the item is new, mark it ready to send
	 */
	function setUpNids()
	{
		$nidListA = $this->getNidsAttachments();
		$nidListB = $this->getNidsBhlArticles();
		
		$nidList = array_merge($nidListA, $nidListB);

		$archive_status = 0;
		
		foreach ($nidList as $nid) {
			if ($this->isNidReady($nid)) {
				$this->updateArchiveRecordStatus($nid, $archive_status);
			}
		}
	}

	/**
	 * getNidsAttachments - filter out records that we intend to send to IA, make a list of node ids
	 */
	function getNidsAttachments()
	{
		$sql = "SELECT n.nid FROM node AS n JOIN upload AS u ON n.nid = u.nid JOIN files AS f ON u.fid = f.fid WHERE n.nid = u.nid AND n.type = 'biblio' ORDER BY n.nid";

		$records = array();

		$recordList = $this->getData($sql, self::DBCMD_QUERY_LIST);

		foreach ($recordList as $record) { 
			$records[] = $record->nid;
		}
		
		return $records;
	}

	/**
	 * getNidsBhlArticles - filter out records that we intend to send to IA, make a list of node ids
	 */
	function getNidsBhlArticles()
	{
		$sql = "SELECT n.nid FROM biblio AS b JOIN node AS n ON n.nid = b.nid JOIN biblio_contributor AS bc ON b.nid = bc.nid JOIN biblio_contributor_data AS bcd ON bc.cid = bcd.cid WHERE b.biblio_label = 'Biodiversity' AND b.biblio_url LIKE '%.pdf' AND n.title != '' ORDER BY n.nid";

		$records = array();

		$recordList = $this->getData($sql, self::DBCMD_QUERY_LIST);

		foreach ($recordList as $record) { 
			$records[] = $record->nid;
		}
		
		return $records;
	}

	/**
	 * getNidsArrayNewItems - combine biblio nodes list and archive nodes list, reduce to ones that should be new ones
	 */
	function getNidsArrayNewItems()
	{
		$biblios = $this->getNidsArrayBiblio();
		
		$archives = $this->getNidsArrayArchive();
		
		$biglist = array_diff($biblios, $archives);
		
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

		$recordList = $this->getData($sql, self::DBCMD_QUERY_LIST);

		foreach ($recordList as $record) { 
			$records[$record->nid] = $record->nid;
		}
		
		return $records;
	}

	/**
	 * getNidsArrayArchive - get array of nodes in archive records
	 */
	function getNidsArrayArchive()
	{
		// SELECT c.nid FROM citebank_internet_archive_records AS c  WHERE 1 ORDER BY c.nid
		$sql = "SELECT c.nid FROM citebank_internet_archive_records AS c  WHERE 1 ORDER BY c.nid";
		
		$records = array();

		$recordList = $this->getData($sql, self::DBCMD_QUERY_LIST);

		foreach ($recordList as $record) { 
			$records[$record->nid] = $record->nid;
		}
		
		return $records;
	}

	/**
	 * getAllBiblioNids - 
	 */
	function getAllBiblioNids()
	{
		$sql = "SELECT nid FROM node AS n WHERE n.type = 'biblio' ORDER BY n.nid";
		
		$records = array();

		$records = $this->getData($sql, self::DBCMD_QUERY_LIST);
		
		return $records;
	}

	/**
	 * getArchiveStats - get number of node records; ignored, ready, sent
	 */
	function getArchiveStats()
	{
		$stats = array();
		
		$sql = 'SELECT count(*) as total FROM '. self::ARCHIVE_TABLE . ' WHERE archive_status = -1';
		$record = $this->getData($sql, self::DBCMD_QUERY);
		$total = $record->total;
		$ignored = $total;

		$sql = 'SELECT count(*) as total FROM '. self::ARCHIVE_TABLE . ' WHERE archive_status = 0';
		$record = $this->getData($sql, self::DBCMD_QUERY);
		$total = $record->total;
		$ready   = $total;

		$sql = 'SELECT count(*) as total FROM '. self::ARCHIVE_TABLE . ' WHERE archive_status = 1';
		$record = $this->getData($sql, self::DBCMD_QUERY);
		$total = $record->total;
		$sent		 = $total;
		
		$stats['ignored'] = $ignored;
		$stats['ready']   = $ready;
		$stats['sent']    = $sent;
		
		return $stats;
	}
	
	/**
	 * isNid - 
	 */
	function isNid($nid)
	{
		$table = self::ARCHIVE_TABLE;

		// SELECT COUNT(*) AS total FROM citebank_internet_archive_records AS t WHERE t.nid = 1237
		$sql = "SELECT count(*) as total FROM $table AS t WHERE t.nid = $nid";

		$record = $this->getData($sql, self::DBCMD_QUERY);
		$total = $record->total;
		
		return ($total > 0 ? true : false );
	}

/*
SELECT COUNT(*) AS total FROM citebank_internet_archive_records AS t WHERE t.nid = 1234 AND archive_status != 1
SELECT COUNT(*) AS total FROM citebank_internet_archive_records AS t WHERE t.nid = 1235 AND archive_status != 1
SELECT COUNT(*) AS total FROM citebank_internet_archive_records AS t WHERE t.nid = 1236 AND archive_status != 1


SELECT COUNT(*) AS total FROM citebank_internet_archive_records AS t WHERE archive_status != 1
SELECT COUNT(*) AS total FROM citebank_internet_archive_records AS t WHERE archive_status = 0
SELECT COUNT(*) AS total FROM citebank_internet_archive_records AS t WHERE archive_status = -1
*/

	/**
	 * isNidReady - 
	 */
	function isNidReady($nid)
	{
		$table = self::ARCHIVE_TABLE;

		$sql = "SELECT count(*) as total FROM $table AS t WHERE t.nid = $nid AND archive_status = -1";

		$record = $this->getData($sql, self::DBCMD_QUERY);

		$total = $record->total;
		
		return ($total > 0 ? true : false );
	}

	/**
	 * setNewNids - (deprecated) sort of set up the queue of potential items
	 */
	function setNewNids()
	{
		$table = self::ARCHIVE_TABLE;
		$count = 0;
		$archive_status = -1;
		$ia_title = 'blank';
		
		$nidsList = $this->getAllBiblioNids();
		
		foreach ($nidsList as $nidItem) {
			$nid = $nidItem->nid;

			// probably a slow way to do this, should be thorough though.
			// we have an existing item in queue list,
			// we have a new item for queue list
			if ($this->isNid($nid)) {
				; // skip it
			} else {
				$this->addArchiveRecord($nid, $archive_status, $ia_title);
				$count++;
			}
		}

		return $count;
	}

	/**
	 * updateArchiveRecordStatus - 
	 */
	function updateArchiveRecordStatus($nid, $archive_status)
	{
		$table = self::ARCHIVE_TABLE;
		$created = date('YmdHis');
		$ret = false;

		$sql = 'UPDATE ' . $table . ' SET archive_status = ' . $archive_status . ', created = ' . $created . ' WHERE nid = ' . $nid . ' ';
		$ret = $this->getData($sql, self::DBCMD_UPDATE);

		$ret = ($ret ? true : false);  // make if data, true else false

		return $ret;
	}

	/**
	 * _toString - stringify
	 */
	function __toString()
	{
		$info = '';
		$info .= $this->className;
		//$info .= '<br>';
		//$info .= "\n";
		//$info .= var_export($this, true);

		return $info;
	}
	
}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
