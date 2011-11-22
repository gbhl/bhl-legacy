<?php
// $Id: CitebankUniqueIdentifierModel.php,v 1.0.0.0 2011/09/30 4:44:44 dlheskett $

/**  CitebankUniqueIdentifierModel class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/30/2011
 *
 */


$includePath = dirname(__FILE__) . '/';

//require_once($includePath . 'ImportErrorLog.php');


/** 
 * class CitebankUniqueIdentifierModel - unique identification system
 * 
 */
class CitebankUniqueIdentifierModel
{
	public $dbi                = 0;
	public $dbiflag            = null;
	public $loggingFlag        = false;
	
	const CLASS_NAME           = 'CitebankUniqueIdentifierModel';

	const ARCHIVE_TABLE        = 'citebank_internet_archive_records';
	const ID_TABLE             = 'citebank_unique_identifier';
	const BIBLIO_TABLE         = 'biblio';
	const BIBLIO_BACKUP_TABLE  = 'biblio_backup_urls';

	const ROOT_CITEBANK_LINK   = 'http://citebank.org/uid.php?id=';
	const ROOT_SEARCH_LINK     = 'http://citebank.org/uid';
	
	const SEARCH_DETAILS       = 'http://www.archive.org/details/cbarchive_';

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
		$this->loggingOn();
	}

	/**
	 * loggingOff - 
	 */
	function loggingOff()
	{
		$this->loggingFlag = false;
	}

	/**
	 * loggingOn - 
	 */
	function loggingOn()
	{
		$this->loggingFlag = true;
	}

	/**
	 * setUp - this should be a one time process, executed once to build and populate the table
	 */
	function setUpShortVersion()
	{
		$flag = false;
		
		// no table, make one, skip if already have it
		if (!$this->isTable()) {
			$msg = 'Set Up Table: ' . self::ID_TABLE;
			$this->watchdog($msg);

			$this->createTable();

			$msg = 'Complete Set Up Table: ' . self::ID_TABLE;
			$this->watchdog($msg);

			$flag = true;
		}
	
		// a new empty table? then fill it
		if ($this->isTableEmpty()) {
			// read biblio urls
			$biblioUrlList = $this->readBiblioUrls();  // get nids and urls
			
			// read old biblio urls
			$oldBiblioUrlList = $this->readOldBiblioUrls();  // get old urls (nids and urls), that had before IA
			
			$msg = 'Fill table data';
			$this->watchdog($msg);
			// load table
			$this->fillTable($oldBiblioUrlList);
	
			$this->fillTable($biblioUrlList);
	
			$msg = 'Done Fill table data';
			$this->watchdog($msg);
		}
		return $flag;
	}

	/**
	 * setUp - this should be a one time process, executed once to build and populate the table
	 */
	function setUp()
	{
		$flag = false;
		
		// no table, make one, skip if already have it
		if (!$this->isTable()) {
			$msg = 'Set Up Table: ' . self::ID_TABLE;
			$this->watchdog($msg);

			$this->createTable();

			$msg = 'Complete Set Up Table: ' . self::ID_TABLE;
			$this->watchdog($msg);

			$flag = true;
		}
	
		// a new empty table? then fill it
		if ($this->isTableEmpty()) {
			// read biblio urls
			$biblioUrlList = $this->readBiblioUrls();  // get nids and urls
			
			// read old biblio urls
			$oldBiblioUrlList = $this->readOldBiblioUrls();  // get old urls (nids and urls), that had before IA
			
			$msg = 'Fill table data';
			$this->watchdog($msg);
			// load table
			$this->fillTable($oldBiblioUrlList);
	
			$this->fillTable($biblioUrlList);
	
			$msg = 'Done Fill table data';
			$this->watchdog($msg);
			
			$msg = 'Intialize Primes';
			$this->watchdog($msg);
	
			$this->intializePrimes();
			
			$msg = 'Done Intialize Primes';
			$this->watchdog($msg);
		}
		
		// make a back up of the current biblio biblio_url entries
//		$this->initBackup();
//		if (!$this->isTableBiblioBackup()) {
//			$msg = 'Make BiblioBackup';
//			$this->watchdog($msg);
//
//			$this->createTableBackupBiblioUrls();
//			$this->intializeBiblioUrls();
//
//			$msg = 'Done BiblioBackup';
//			$this->watchdog($msg);
//		}

		return $flag;
	}
// select * from biblio_backup_urls;
// select distinct nid, biblio_url from biblio order by nid limit 10;
// SELECT citebank_unique_identifier_id, created, active, prime, nid, link FROM citebank_unique_identifier WHERE nid = 33670 AND active = 1 ORDER BY created, citebank_unique_identifier_id DESC;
/*

select nid, title, status, changed from node join apachesolr_search_node as asn on (node.nid = asn.nid) where asn.changed > '1318609928';

select n.nid, n.title, asn.status, asn.changed from node as n join apachesolr_search_node as asn on (n.nid = asn.nid) where asn.changed > '1318523528';

select n.nid, b.biblio_url, n.title, asn.status, asn.changed from node as n join apachesolr_search_node as asn on (n.nid = asn.nid) join biblio as b on (n.nid = b.nid) where asn.changed > '1318523528';

select n.nid, b.biblio_url, c.biblio_url, n.title, asn.status, asn.changed from node as n join apachesolr_search_node as asn on (n.nid = asn.nid) join biblio as b on (n.nid = b.nid) join citebank_internet_archive_records as c on (n.nid = c.nid) where asn.changed > '1318523528';


SELECT n.nid, b.biblio_url AS url, c.biblio_url as oldurl, n.title, asn.status, asn.changed FROM node AS n JOIN apachesolr_search_node AS asn ON (n.nid = asn.nid) JOIN biblio as b ON (n.nid = b.nid) JOIN citebank_internet_archive_records AS c ON (n.nid = c.nid) WHERE asn.changed > 1318526124


select n.nid, n.title, b.biblio_year from node as n join biblio as b on (n.nid = b.nid) where b.biblio_remote_db_provider like '%Madrid – CSIC' limit 10;

 [ http://www.biodiversitylibrary.org/pdf1/000651900020231.pdf]
 
 
OLD URL: [ http://www.biodiversitylibrary.org/pdf1/000651900020231.pdf]
SELECT * FROM citebank_unique_identifier WHERE link = http://www.biodiversitylibrary.org/pdf1/000651900020231.pdf
SELECT * FROM citebank_unique_identifier WHERE link = http://citebank.org/pdf.php?pdf=5
***** found URL ******
UPDATE biblio SET biblio_url = 'http://citebank.org/pdf.php?pdf=5' WHERE nid = 5

http://www.biodiversitylibrary.org/pdf1/000651900020231.pdf

    $form_state['nid'] = $node->nid;
    $form_state['redirect'] = 'node/'. $node->nid;


    $form_state['nid'] = $node->nid;
    $form_state['redirect'] = 'uid/'. $node->nid;

CREATE TABLE `biblio_backup_urls` (`biblio_backup_urls_id` int(11) unsigned NOT NULL auto_increment, `nid` int(11) default NULL, `biblio_url` varchar(255) default NULL, PRIMARY KEY  (`biblio_backup_urls_id`))




staging.citebank.org/uid.php?id=33670

staging.citebank.org/uid.php?id=33720

http://staging.citebank.org/uid/33670

no, drupal steps in
http://test1.citebank.org/uid/33670

yes, maybe
http://test1.citebank.org/uid/?33670

yes, we get variable id
http://test1.citebank.org/uid/?id=33670


SELECT * FROM citebank_internet_archive_records WHERE archive_status = 1 AND nid > 35611 ORDER BY nid LIMIT 10

SELECT biblio_url FROM biblio WHERE nid = 5;

INSERT INTO change_log SET change_log.nid = 12345, change_log.table = 'biblio', change_log.field = 'biblio_year', change_log.old = '9999', change_log.new = '1923', change_log.created = '20110916193922'

SELECT COUNT(*) AS total FROM biblio_url_list WHERE url = 'citebank.org/node/12345'
SELECT url FROM biblio_url_list WHERE nid = 12345 AND dest_flag = 1 ORDER BY created LIMIT 1

SELECT * FROM import_error_log WHERE nid = '12345' ORDER BY created


SELECT biblio_url FROM biblio WHERE nid > 5 AND nid < 100 ORDER BY nid;

rank 

SELECT nid, link FROM citebank_unique_identifier WHERE nid = 5 AND active = 1 ORDER BY rank

SELECT nid, link FROM citebank_unique_identifier WHERE nid = 5 AND active = 1 ORDER BY created

primaryid

SELECT citebank_unique_identifier_id, created, active, prime, nid, link FROM citebank_unique_identifier WHERE nid = 5 AND active = 1 ORDER BY created, citebank_unique_identifier_id DESC

SELECT citebank_unique_identifier_id, created, active, prime, nid, link FROM citebank_unique_identifier WHERE nid = 5 AND active = 1 ORDER BY created, citebank_unique_identifier_id DESC LIMIT 1


SELECT n.nid, b.biblio_url AS url, c.biblio_url AS oldurl, n.title, asn.status, asn.changed FROM node AS n JOIN apachesolr_search_node AS asn ON (n.nid = asn.nid) JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_internet_archive_records AS c ON (n.nid = c.nid) WHERE asn.changed > 1315597035;

INSERT INTO biblio_backup_urls SET biblio_url = 'http://hdl.handle.net/10088/5098', nid = 29886

			 
CREATE TABLE `biblio_backup_urls` (`biblio_backup_urls_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT, `nid` INT(11) DEFAULT NULL, `biblio_url` VARCHAR(255) DEFAULT NULL, PRIMARY KEY  (`biblio_backup_urls_id`))


clear out the backup table
delete from biblio_backup_urls;



*/

	/**
	 * initBackup - create a backup of the biblio biblio_urls 
	 */
	function initBackup()
	{
		// make a back up of the current biblio biblio_url entries
		if (!$this->isTableBiblioBackup()) {
			$msg = 'Make BiblioBackup';
			$this->watchdog($msg);

			$this->createTableBackupBiblioUrls();
			$this->copyBiblioUrlsToBackup();
			
			// do this in a separate operation.  $this->intializeBiblioUrls();

			$msg = 'Done BiblioBackup';
			$this->watchdog($msg);
		}
	}

	/**
	 * checkDuplicate - look in CBUID table, true if found  CBUID citebank_unique_identifier
	 */
	function checkDuplicate($url)
	{
		$flag = false;

		if ($this->dbiflag) {
			$sql = 'SELECT count(*) AS total FROM ' . self::ID_TABLE . ' WHERE link = ' . "'". $url . "'";
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$total = $rows[0]['total'];
				if ($total >= 1) {
					$flag = true;
				}
			}
		}
		
		return $flag;
	}

	/**
	 * checkDuplicateAll - 
	 */
	function checkDuplicateAll($url, $title = '')
	{
		$flag = false;

		$flag = $this->checkDuplicate($url);
		
		if ($flag == false) {
			$flag = $this->isDoiUrlCheck($url, $title);
		}
		
		if ($flag == false) {
			$flag = $this->isRecordBiblio($url);
		}

		return $flag;
	}

	/**
	 *  isDoiUrlCheck - is there a record 
	 */
	function isDoiUrlCheck($url, $title) 
	{
		$flag = false;

		if ($this->dbiflag) {
			if (substr_count($url, 'http://dx.doi.org/')) {
				$sql = "SELECT count(*) AS total FROM node WHERE title = '".$title."'";
				// "select nid, title from node where title = 'Outcomes of the 2011 Botanical Nomenclature Section at the XVIII International Botanical Congress';"
				$rows = $this->dbi->fetch($sql);
				
				if (count($rows) > 0) {
					$total = $rows[0]['total'];
		
					if ($total >= 1) {
						$flag = true;
					}
				}
			}
		}
		
		return $flag;
	}
	
	/**
	 *  isRecordBiblio - is there a record, true = yes, false = no
	 */
	function isRecordBiblio($url) 
	{
		$flag = false;

		if ($this->dbiflag) {
			$sql = "SELECT count(*) as total FROM biblio where biblio_url = '".$url."'";
			
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$total = $rows[0]['total'];
	
				if ($total >= 1) {
					$flag = true;
				}
			}
		}
		
		return $flag;
	}
	
	/**
	 *  isRecordInternetArchived - is there a record (that we sent to Internet Archive?), true = yes, false = no
	 */
	function isRecordInternetArchived($url) 
	{
		$flag = false;
		// check first if table exists, if so, see if record exists
		
		// SHOW TABLES LIKE 'citebank_internet_archive_records'
		$tableIA = 'citebank_internet_archive_records';
		$sql = 'SHOW TABLES LIKE ' . "'".$tableIA."'";
		
		$rows = $this->dbi->fetch($sql);
		
		if (count($rows) > 0) {
			$sql = "SELECT count(*) AS total FROM citebank_internet_archive_records WHERE biblio_url = '".$url."'";
			
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
					$total = $rows[0]['total'];
	
				if ($total >= 1) {
					$flag = true;
				}
			}
		}
		
		return $flag;
	}
	
	/**
	 * getRangeNewItems - 
	 */
	function getRangeNewItems()
	{
		$range = $this->getLowNidHighNid();
		
		return $range;
	}

// select distinct count(*) from biblio as b join citebank_internet_archive_records as c on (b.nid = c.nid) where c.biblio_url > '';
// select distinct b.nid from biblio as b join citebank_internet_archive_records as c on (b.nid = c.nid) where c.biblio_url > '' LIMIT 10;
// select from citebank_internet_archive_records as c on where c.biblio_url > '' LIMIT 10; 
// select nid, biblio_url from citebank_internet_archive_records as c where c.biblio_url > '' LIMIT 10;
// select nid, biblio_url from citebank_internet_archive_records as c where c.biblio_url > '' and nid > 1234 LIMIT 10;
// select count(*) from biblio as b join citebank_internet_archive_records as c on (b.nid = c.nid) where c.biblio_url > '' and b.biblio_other_number = '';
// SELECT COUNT(*) FROM biblio AS b JOIN citebank_internet_archive_records AS c ON (b.nid = c.nid) WHERE c.biblio_url > '' AND b.biblio_other_number = '';


// biblio_other_number
	/**
	 * setBiblioOtherNumber - 
	 */
	function setBiblioOtherNumber($last = 0)
	{
		$limitFlag = true;
		$limit = '';

		if ($limitFlag) {
			//$limit = ' LIMIT 100';
			$limit = ' LIMIT 1';
		}

		// SELECT c.nid, c.biblio_url FROM citebank_internet_archive_records AS c WHERE c.biblio_url > '' AND c.nid > 1234 LIMIT 10;
		// SELECT nid, biblio_url FROM citebank_internet_archive_records WHERE biblio_url > '' AND nid > 1234 LIMIT 10;
		if ($this->dbiflag) {
			$sql = 'SELECT nid, biblio_url FROM citebank_internet_archive_records WHERE biblio_url > ' . "''" . ' AND nid > ' . $last . $limit;
			
			$rows = $this->dbi->fetch($sql);
		
			echo '<br>';
			if (count($rows) > 0) {
				foreach ($rows as $row) {
					$nid = $row['nid'];
					$biblioUrl = $row['biblio_url'];
					
					//$this->updateBiblioOtherNumber($nid, $biblioUrl);
					echo 'Nid:[';
					echo $nid;
					echo '] <br>';
					echo 'biblioUrl:[';
					echo $biblioUrl;
					echo '] ';
					echo '<br>';
	
					$last = $nid;
				}
			}
			
			echo '<br>';
			echo 'Last:[';
			echo $last;
			echo '] <br>';
		}
		
		return $last;
	}

	/**
	 * updateBiblioOtherNumber - update biblio other number with given url
	 */
	function updateBiblioOtherNumber($nid, $biblioUrl)
	{
		if ($this->dbiflag) {
			$sql = 'UPDATE biblio SET biblio_other_number = ' . "'" . $biblioUrl . "'" . ' WHERE nid = ' . $nid;
			$ret = $this->dbi->update($sql);
		}
	}

	/**
	 * createIADetailsUrl - 
	 */
	function createIADownloadUrl($url)
	{
		// check if is even an IA url
		// if IA url, is it details?
		// yes, then change
		if (substr_count($url, '/details/')) {
				$urlFrag = str_replace(self::SEARCH_DETAILS, '', $url);
				
				$str = explode('_', $urlFrag);
				$namefrag = $str[1];

				$firstpart = str_replace('/details/', '/download/', $url);
				$newurl = $firstpart . '/' . $namefrag . '.pdf';
				$url = $newurl;
		} else {
			// no, is it download, yes, then okay
			if (substr_count($url, '/download/')) {
				;
			} else {
				//   no, then just return the given url
				;
			}
		}

		return $url;
	}

	/**
	 * updateIADetailsUrl - update biblio with given url
	 */
	function updateIADetailsUrl($nid, $newIADetailsUrl)
	{
		if ($this->dbiflag) {
			$sql = 'UPDATE biblio SET biblio_url = ' . "'" . $newIADetailsUrl . "'" . ' WHERE nid = ' . $nid;
			$ret = $this->dbi->update($sql);
		}
	}

	/**
	 * updateIADetailsUrlBulkProcess - 
	 */
	function updateIADetailsUrlBulkProcess()
	{
		$data = null;
		
		if ($this->dbiflag) {
			
			//$sql = 'SELECT nid, biblio_url from biblio WHERE biblio_url like \'%/details/%\' ORDER BY nid';
			$sql = 'SELECT nid, biblio_url from biblio WHERE biblio_url like \'%/details/%\' ORDER BY nid LIMIT 10';  // FIXME remove limit 10
			// SELECT nid, biblio_url from biblio WHERE biblio_url like '%/details/%' ORDER BY nid LIMIT 10
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				foreach ($rows as $item) {
					$nid = $item['nid'];
					$url = $item['biblio_url'];

					//$namefragA = explode( '_', 'http://www.archive.org/details/cbarchive_33685_thefamilyhimantandraceae1943');
					//$urlFrag = str_replace('http://www.archive.org/details/cbarchive_', '', $url);
					$urlFrag = str_replace(self::SEARCH_DETAILS, '', $url);
					
					$str = explode('_', $urlFrag);
					$namefrag = $str[1];

					$firstpart = str_replace('/details/', '/download/', $url);
					$newurl = $firstpart . '/' . $namefrag . '.pdf';
					
					// FIXME: remove the echos
					echo 'Nid: [';
					echo $nid;
					echo '] ';
					echo 'Url: [';
					echo $url;
					echo '] ';
					echo 'New Url: [';
					echo $newurl;
					echo '] ';
					echo '<br>';
					echo '<br>';
				}
				
			}
		}
// http://www.archive.org/details/cbarchive_33685_thefamilyhimantandraceae1943
// http://ia700700.us.archive.org/23/items/cbarchive_33685_thefamilyhimantandraceae1943/thefamilyhimantandraceae1943.pdf
//
// http://www.archive.org/download/cbarchive_33685_thefamilyhimantandraceae1943/thefamilyhimantandraceae1943.pdf

		return null;
	}

	/**
	 * updateIADetailsUrl - 
	 */
	function XXupdateIADetailsUrl()
	{
		$data = null;
		
		if ($this->dbiflag) {
			
			//$offset = strlen('http://www.archive.org/details/cbarchive_');
			$offset = strlen(self::SEARCH_DETAILS);
			
			
			//$sql = 'SELECT nid, biblio_url from biblio WHERE biblio_url like \'%/details/%\' ORDER BY nid';
			$sql = 'SELECT nid, biblio_url from biblio WHERE biblio_url like \'%/details/%\' ORDER BY nid LIMIT 10';
			// SELECT nid, biblio_url from biblio WHERE biblio_url like '%/details/%' ORDER BY nid LIMIT 10
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				foreach ($rows as $item) {
					$nid = $item['nid'];
					$url = $item['biblio_url'];
					echo 'URL: [';
					echo $url;
					echo '] ';
					
					
					//$namefragA = explode( '_', 'http://www.archive.org/details/cbarchive_33685_thefamilyhimantandraceae1943');
					//$urlFrag = str_replace('http://www.archive.org/details/cbarchive_', '', $url);
					$urlFrag = str_replace(self::SEARCH_DETAILS, '', $url);
					$pos = strrpos($urlFrag, '_');
					$urlFrag[$pos] = '|';
					$str = explode('|', $urlFrag);
					$namefrag = $str[1];
					echo 'urlFrag: [';
					echo $urlFrag;
					echo '] ';
					echo 'str: [';
					print_r($str);
					echo '] ';
					echo 'namefrag: [';
					echo $namefrag;
					echo '] ';

					//$namefragA = explode( '_', $url);  // fails if underscores in title
					//$namefrag = $namefragA[2];
					$firstpart = str_replace('/details/', '/download/', $url);
					$newurl = $firstpart . '/' . $namefrag . '.pdf';
					
					echo 'Nid: [';
					echo $nid;
					echo '] ';
					echo 'Url: [';
					echo $url;
					echo '] ';
					echo 'New Url: [';
					echo $newurl;
					echo '] ';
					echo '<br>';
					echo '<br>';
				}
				
			}
		}
// http://www.archive.org/details/cbarchive_33685_thefamilyhimantandraceae1943
// http://ia700700.us.archive.org/23/items/cbarchive_33685_thefamilyhimantandraceae1943/thefamilyhimantandraceae1943.pdf
//
// http://www.archive.org/download/cbarchive_33685_thefamilyhimantandraceae1943/thefamilyhimantandraceae1943.pdf

		return null;
	}

	/**
	 * getItemCbuidBy - 
	 */
	function getItemCbuidBy($url)
	{
		$data = null;
		
		$data = $this->getItem($url);
		$cbuid = $data['citebank_unique_identifier_id'];
		
		return $cbuid;
	}

	/**
	 * clearAllSetOne - 
	 */
	function clearAllSetOne($nid, $cbuid)
	{
		$this->clearBothForNids($nid);
		$this->setPrimaryActive($cbuid);
	}

	/**
	 * getItem - 
	 */
	function getItem($url)
	{
		$data = null;
		
		if ($this->dbiflag) {
			$sql = 'SELECT * FROM ' . self::ID_TABLE . ' WHERE link = ' . "'". $url . "'";
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$data = $rows[0];
			}
		}

		return $data;
	}

	/**
	 * getLink - get url link for nid and is active
	 */
	function getLink($nid)
	{
		$data = null;
		
		if ($this->dbiflag) {
			$sql = 'SELECT * FROM ' . self::ID_TABLE . ' WHERE nid = ' . $nid . ' AND active = 1';
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$data = $rows[0]['link'];
			}
		}

		return $data;
	}

	/**
	 * createTable - build the table
	 */
	function createTable()
	{
		// table: citebank_unique_identifier
		
		// nid     - node id
		// link    - url  (used to check for previous source, also used as destination if 'active')
		// active  - 1 = use this link, 0 = not a primary
		// prime   - 1 = primary, 0 = ordinary  (combined with active, we could have many active links, but one that is the first we try, or the exclusive one we try)
		// created - yyyymmdd item created
		// status  - link status, indicate if url is 404 or such, status types to be determined(20111007)
		// changed - when status changed
		// altflag - url to use if primary is unavailable  1 = alternate url to use, 0 = not specified
		// rank    - 0 = no order, 1 thru n = sort or use order, use url 1 before url 2 and so on.
		
		if ($this->dbiflag) {
			$sql = 'CREATE TABLE `' . self::ID_TABLE . '` (
			  `citebank_unique_identifier_id` int(11) unsigned NOT NULL auto_increment,
			  `nid` int(11) default NULL,
			  `link` varchar(255) default NULL,
			  `active` int(1) default NULL,
			  `prime` int(1) default 0,
			  `created` datetime default NULL,
			  `status` int(1) default NULL,
			  `changed` datetime default NULL,
			  `altflag` int(1) default NULL,
			  `rank` int(3) default 0,
			  PRIMARY KEY  (`citebank_unique_identifier_id`)
			)';
			
			$this->dbi->update($sql);
		}
	}

	/**
	 * isTable - 
	 */
	function isTable()
	{
		$flag = false;
		
		if ($this->dbiflag) {
			$sql = "SHOW TABLES LIKE '" . self::ID_TABLE . "'";
			$row = $this->dbi->fetch($sql);
			
			if (count($row) > 0) {
				$flag = true;
			}
		}

		return $flag;
	}	

	/**
	 * isTableEmpty - 
	 */
	function isTableEmpty()
	{
		$flag = true;

		if ($this->dbiflag) {
			$count = $this->countUniqueIds();
			
			if ($count > 0) {
				$flag = false;
			}
		}

		return $flag;
	}	

	/**
	 * isExist - 
	 */
	function isExist($url)
	{
		$flag = false;

		// short circuit, filter out the short link
		if (substr_count($url, self::ROOT_CITEBANK_LINK)) {
			$flag = true;
			return $flag;
		}
		
		if ($this->dbiflag) {
			$sql = 'SELECT * FROM ' . self::ID_TABLE . ' WHERE link = \'' . $url . '\'';
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$flag = true;
			}
		}

		return $flag;
	}

	/**
	 * isExistUrl - 
	 */
	function isExistUrl($url)
	{
		$flag = false;
		
		if ($this->dbiflag) {
			$sql = 'SELECT * FROM ' . self::ID_TABLE . ' WHERE link = \'' . $url . '\'';
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$flag = true;
			}
		}

		return $flag;
	}

	/**
	 * add - process the node, store it or something
	 */
	function add($node, $url)
	{
		// do not add items that are empty or otherwise wrong
		if ($node <= 0) {
			return;
		}

		if ($url == '') {
			return;
		}
		
		if ($url == null) {
			return;
		}
		
		// you have an entry already?, well, don't add it again if you have the same one
		if ($this->checkDuplicate($url)) {
			return;
		}

		// and really, don't put in the tiny url, cmon!
		if (substr_count($url, self::ROOT_CITEBANK_LINK)) {
			return;
		}
		
		// nid     - node id
		// link    - url  (used to check for previous source, also used as destination if 'active')
		// active  - 1 = use this link, 0 = not a primary
		// created - yyyymmdd item created
		// status  - link status, indicate if url is 404 or such, status types to be determined(20111007)
		// changed - when status changed
		// altflag - url to use if primary is unavailable  1 = alternate url to use, 0 = not specified
		
		$now = date('YmdHis');
		$status = 0;
		$changed = 0;
		$altflag = 0;
		

		$sql = "INSERT INTO " . self::ID_TABLE . " set nid = $node, link = '$url', active = 1, created = '$now', status = $status, changed = '$changed', altflag = $altflag";

		$this->dbi->insert($sql);
	}

	/**
	 * update - process the node, store it or something
	 */
	function update($uid)
	{
		$sql = 'SELECT * FROM ' . self::ID_TABLE . ' WHERE citebank_unique_identifier_id = ' . $uid;

		$this->dbi->update($sql);
	}

	/**
	 * getItemByCBID - 
	 */
	function getItemByCBID($cbuid)
	{
		$sql = 'SELECT * FROM ' . self::ID_TABLE . ' WHERE citebank_unique_identifier_id = ' . $cbuid;

		$data = $this->dbi->fetch($sql);
		
		return $data;
	}

	/**
	 * find - 
	 */
	function find($url)
	{
		$data = $this->findNidByUrl($url);
		
		return $data;
	}

	/**
	 * findNidByUrl - 
	 */
	function findNidByUrl($url)
	{
		$sql = 'SELECT * FROM ' . self::ID_TABLE . ' WHERE link = ' . "'" . $url . "'";

		$data = $this->dbi->fetch($sql);
		
		return $data;
	}

	/**
	 * lookupUrl - check if 
	 */
	function lookupUrl($nid)
	{
		$url = '';

		// SELECT link FROM citebank_unique_identifier WHERE nid = 33670 ORDER BY citebank_unique_identifier_id DESC limit 1;

		//$sql = 'SELECT link FROM ' . self::ID_TABLE . ' WHERE nid = ' . $nid . '';
		$sql = 'SELECT link FROM ' . self::ID_TABLE . ' WHERE nid = ' . $nid . ' ORDER BY citebank_unique_identifier_id DESC limit 1';
		//$sql = 'SELECT link FROM ' . self::ID_TABLE . ' WHERE nid = ' . $nid . ' AND active = 1 AND prime = 1 ORDER BY citebank_unique_identifier_id DESC limit 1';

		$record = $this->dbi->fetchobj($sql);

		if ($record) {
			$url = $record->link;
		}
		
		return $url;
	}

	/**
	 * remove - process the node, store it or something
	 */
	function remove($node)
	{
		$sql = '';  // delete from ....

		//$this->dbi->update($sql);
	}

	/**
	 * setDb - set the database handle
	 */
	function setDb($dbi)
	{
		$this->dbi = $dbi;
		$this->dbiflag = true;
	}

	/**
	 * getHighestNid - get the highest nid number
	 */
	function getHighestNid()
	{
		$nid = 0;
		
		if ($this->dbiflag) {
			$sql = 'SELECT nid, biblio_url FROM biblio ORDER BY nid DESC LIMIT 1';
			$row = $this->dbi->fetch($sql);
			
			if (count($row) > 0) {
				$nid = $row[0]['nid'];
			}
		}
		
		return $nid;
	}

	/**
	 * getLowestNid - get the lowest nid number
	 */
	function getLowestNid()
	{
		$nid = 0;
		
		if ($this->dbiflag) {
			$sql = 'SELECT nid, biblio_url FROM biblio ORDER BY nid LIMIT 1';
			$row = $this->dbi->fetch($sql);
			
			if (count($row) > 0) {
				$nid = $row[0]['nid'];
			}
		}
		
		return $nid;
	}

	/**
	 * countBiblioNids - get the count of nids
	 */
	function countBiblioNids()
	{
		$total = 0;
		
		if ($this->dbiflag) {
			$sql = 'SELECT count(*) as total FROM biblio';
			$row = $this->dbi->fetch($sql);
			
			if (count($row) > 0) {
				$total = $row[0]['total'];
			}
		}
		
		return $total;
	}

	/**
	 * getLowNidHighNid - get the highest nid number
	 */
	function getLowNidHighNid()
	{
		$nid = array();
		$loNid = 0;
		$loBiblioNid = 0;
		$hiBiblioNid = 0;
		
		if ($this->dbiflag) {
			$sql = 'select nid from citebank_unique_identifier order by nid desc limit 1';
			$row = $this->dbi->fetch($sql);
			
			if (count($row) > 0) {
				$loNid = $row[0]['nid'];
			}

			$row = '';
			$sql = 'select nid from biblio where nid > ' . $loNid . ' order by nid desc limit 1';
			$row = $this->dbi->fetch($sql);
			
			if (count($row) > 0) {
				$hiBiblioNid = $row[0]['nid'];
			}

			$row = '';
			$sql = 'select nid from biblio where nid > ' . $loNid . ' order by nid limit 1';
			$row = $this->dbi->fetch($sql);
			
			if (count($row) > 0) {
				$loBiblioNid = $row[0]['nid'];
			}
			
			$nid['lo'] = $loBiblioNid; // new nid in biblio, first in recent entry range
			$nid['hi'] = $hiBiblioNid; // new nid in biblio, last in recent entry range
			$nid['end'] = $loNid;      // ending nid in cbuid

		}
		
		return $nid;
	}

	/**
	 * getTotalNewItems - get the total count of new items
	 */
	function getTotalNewItems()
	{
		$total = 0;
		$nids = array();
		
		$nids = $this->getLowNidHighNid();
		$lo = $nids['lo'];
		$hi = $nids['hi'];
		
		// select count(*) as total from biblio where nid >= 125780 and nid <= 126136 order by nid;
		if ($this->dbiflag) {
			$sql = 'select count(*) as total from biblio where nid >= ' . $lo . ' and nid <= ' . $hi . ' order by nid';
			$row = $this->dbi->fetch($sql);
			
			if (count($row) > 0) {
				$total = $row[0]['total'];
			}
		}
		
		
		return $total;
	}

	/**
	 * markActive - flag item as the active link
	 */
	function markActive($cbuid)
	{
		if ($this->dbiflag) {
			$sql = 'UPDATE ' . self::ID_TABLE . ' SET active = 1 WHERE citebank_unique_identifier_id = ' . $cbuid;
			$ret = $this->dbi->update($sql);
		}
	}

	/**
	 * markDormant - flag item as the dormant link
	 */
	function markDormant($cbuid)
	{
		if ($this->dbiflag) {
			$sql = 'UPDATE ' . self::ID_TABLE . ' SET active = 0 WHERE citebank_unique_identifier_id = ' . $cbuid;
			$ret = $this->dbi->update($sql);
		}
	}

	/**
	 * readBiblioUrls - get nids and urls
	 */
	function readBiblioUrls()
	{
		$list = null;
		
		if ($this->dbiflag) {
			$sql = 'SELECT nid, biblio_url FROM biblio';
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$list = $rows;
			}
		}
		
		return $list;
	}

	/**
	 * readOldBiblioUrls - get old urls (nids and urls), that had before IA
	 */
	function readOldBiblioUrls()
	{
		$list = null;
		
		if ($this->dbiflag) {
			$tbl = self::ARCHIVE_TABLE;
			$sql = 'SELECT nid, biblio_url FROM ' . $tbl;
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$list = $rows;
			}
		}
		
		return $list;
	}

	/**
	 * fillTable - add items
	 */
	function fillTable($dataList)
	{
		$count = 0;
		
		foreach ($dataList as $item) {
			$count++;
			
			$nid = $item['nid'];
			$url = $item['biblio_url'];
			
			$this->add($nid, $url);
		}
		
		return $count;
	}

	/**
	 * countUniqueIds - get the count of nids from the unique id table
	 */
	function countUniqueIds()
	{
		$total = 0;
		
		if ($this->dbiflag) {
			$tbl = self::ID_TABLE;
			$sql = 'SELECT count(*) as total FROM ' . $tbl . '';
			$row = $this->dbi->fetch($sql);
			
			if (count($row) > 0) {
				$total = $row[0]['total'];
			}
		}
		
		return $total;
	}

	/**
	 * getFirstActiveUrl - 
	 */
	function getFirstActiveUrl()
	{
		$list = null;

		$list = $this->getActiveUrls(true);

		return $list;
	}

	/**
	 * getActiveUrls - 
	 */
	function getActiveUrls($limitFlag = false)
	{
		$list = null;
		
		if ($this->dbiflag) {
			
			$limit = '';
			if ($limitFlag) {
				$limit = ' LIMIT 1';
			}
			
			$tbl = self::ARCHIVE_TABLE;
			$sql = 'SELECT nid, link FROM ' . $tbl . ' WHERE active = 1 ORDER BY rank' . $limit;
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$list = $rows;
			}
		}
		
		return $list;
	}

	/**
	 * getPrimeActiveUrl - 
	 */
	function getPrimeActiveUrl($nid)
	{
		$list = null;
		$url = '';
		
		if ($this->dbiflag) {
			
			$tbl = self::ID_TABLE;
			$sql = 'SELECT link FROM ' . $tbl . ' WHERE active = 1 AND prime = 1 AND nid = ' . $nid;
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$list = $rows;
				$url = $list[0]['link'];
			}
		}
		
		
		return $url;
	}

	/**
	 * getActiveUrlsForSingleNid - 
	 */
	function getActiveUrlsForSingleNid($nid)
	{
		$list = null;
		
		$list = $this->getActiveUrlsForNid($nid, true);

		return $list;
	}

	/**
	 * getActiveUrlsForNid - 
	 */
	function getActiveUrlsForNid($nid, $limitFlag = false)
	{
		$list = null;
		
		if ($this->dbiflag) {
			
			$limit = '';
			if ($limitFlag) {
				$limit = ' LIMIT 1';
			}
			
			$sql = 'SELECT citebank_unique_identifier_id as cbuid, nid, link FROM ' . self::ID_TABLE . ' WHERE nid = ' . $nid . ' AND active = 1 ORDER BY rank' . $limit;
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$list = $rows;
			}
		}
		
		return $list;
	}

	/**
	 * getPrimaryActiveList - 
	 */
	function getPrimaryActiveList($nid, $limitFlag = false)
	{
		$list = null;

		if ($this->dbiflag) {

			$limit = '';
			if ($limitFlag) {
				$limit = ' LIMIT 1';
			}

			// SELECT citebank_unique_identifier_id, created, active, nid, link FROM citebank_unique_identifier WHERE nid = 5 AND active = 1 ORDER BY created, citebank_unique_identifier_id DESC
			//$sql = 'SELECT citebank_unique_identifier_id, created, active, nid, link FROM ' . self::ID_TABLE . ' WHERE nid = ' . $nid . ' AND active = 1 ORDER BY created, citebank_unique_identifier_id DESC LIMIT 1';
			$sql = 'SELECT citebank_unique_identifier_id, created, active, prime, nid, link FROM ' . self::ID_TABLE . ' WHERE nid = ' . $nid . ' AND active = 1 ORDER BY created, citebank_unique_identifier_id DESC' . $limit;
			$rows = $this->dbi->fetch($sql);

			if (count($rows) > 0) {
				$list = $rows;
			}
		}
		
		return $list;
	}

	/**
	 * getNidItemsMostRecent - 
	 */
	function getNidItemsMostRecent($nid, $limitFlag = false)
	{
		$list = null;

		if ($this->dbiflag) {

			$limit = '';
			if ($limitFlag) {
				$limit = ' LIMIT 1';
			}

			// SELECT citebank_unique_identifier_id, created, active, nid, link FROM citebank_unique_identifier WHERE nid = 5 AND active = 1 ORDER BY created, citebank_unique_identifier_id DESC
			//$sql = 'SELECT citebank_unique_identifier_id, created, active, nid, link FROM ' . self::ID_TABLE . ' WHERE nid = ' . $nid . ' AND active = 1 ORDER BY created, citebank_unique_identifier_id DESC LIMIT 1';
			$sql = 'SELECT citebank_unique_identifier_id, created, active, prime, nid, link FROM ' . self::ID_TABLE . ' WHERE nid = ' . $nid . ' ORDER BY created DESC, citebank_unique_identifier_id DESC' . $limit;
			echo '<br>'; echo $sql; echo '<br>';
			$msg = $sql;
			$this->watchdog($msg);

			//$rows = 0;//$this->dbi->fetch($sql);
			$rows = $this->dbi->fetch($sql);

			if (count($rows) > 0) {
				$list = $rows;
			}
		}
		
		return $list;
	}

	/**
	 * getCbIdMostRecentForNid - 
	 */
	function getCbIdMostRecentForNid($nid)
	{
		$cbuid = 0;
		$list = $this->getNidItemsMostRecent($nid, true);
		
		if ($list == 0) {
			$msg = 'No data for getNidItemsMostRecent';
			$this->watchdog($msg);
			return $cbuid;
		}

		if (count($list) > 0) {
			//foreach ($list as $item) {
				//$cbuid = $item['citebank_unique_identifier_id'];
				$cbuid = $list[0]['citebank_unique_identifier_id'];
				echo '<br>'; echo $cbuid; echo '<br>';
			$msg = 'CBUID:[' . $cbuid . '] ' . print_r($list, 1);
			$this->watchdog($msg);
			//	break;
			//}
		}
				
		return $cbuid;
	}

	/**
	 * setPrimaryActive - 
	 */
	function setPrimaryActive($cbuid)
	{
		if ($this->dbiflag) {
			if ($cbuid > 0) {
				$sql = 'UPDATE ' . self::ID_TABLE . ' SET active = 1, prime = 1 WHERE citebank_unique_identifier_id = ' . $cbuid;
//				echo '<br>'; echo $sql; echo '<br>';
//			$msg = $sql;
//			$this->watchdog($msg);
				//$ret = $this->dbi->update($sql);
			}
		}
	}

	/**
	 * setActive - 
	 */
	function setActive($cbuid)
	{
		if ($this->dbiflag) {
			if ($cbuid > 0) {
				$sql = 'UPDATE ' . self::ID_TABLE . ' SET active = 1 WHERE citebank_unique_identifier_id = ' . $cbuid;
//				echo '<br>'; echo $sql; echo '<br>';
//			$msg = $sql;
//			$this->watchdog($msg);
				//$ret = $this->dbi->update($sql);
			}
		}
	}

	/**
	 * setPrime - 
	 */
	function setPrime($cbuid)
	{
		if ($this->dbiflag) {
			if ($cbuid > 0) {
				$sql = 'UPDATE ' . self::ID_TABLE . ' SET prime = 1 WHERE citebank_unique_identifier_id = ' . $cbuid;
				$ret = $this->dbi->update($sql);
			}
		}
	}

	/**
	 * unsetActive - 
	 */
	function unsetActive($cbuid)
	{
		if ($this->dbiflag) {
			if ($cbuid > 0) {
				$sql = 'UPDATE ' . self::ID_TABLE . ' SET active = 0 WHERE citebank_unique_identifier_id = ' . $cbuid;
				$ret = $this->dbi->update($sql);
			}
		}
	}

	/**
	 * clearActiveForNids - 
	 */
	function clearActiveForNids($nid)
	{
		if ($this->dbiflag) {
			if ($nid > 0) {
				$sql = 'UPDATE ' . self::ID_TABLE . ' SET active = 0 WHERE nid = ' . $nid;
				$ret = $this->dbi->update($sql);
			}
		}
	}

	/**
	 * clearPrimeForNids - 
	 */
	function clearPrimeForNids($nid)
	{
		if ($this->dbiflag) {
			if ($cbuid > 0) {
				$sql = 'UPDATE ' . self::ID_TABLE . ' SET prime = 0 WHERE nid = ' . $nid;
				$ret = $this->dbi->update($sql);
			}
		}
	}

	/**
	 * clearBothForNids - 
	 */
	function clearBothForNids($nid)
	{
		if ($this->dbiflag) {
			if ($cbuid > 0) {
				$sql = 'UPDATE ' . self::ID_TABLE . ' SET active = 0, prime = 0 WHERE nid = ' . $nid;
				$ret = $this->dbi->update($sql);
			}
		}
	}

	/**
	 * setIntialPrime - 
	 */
	function setIntialPrime($nid)
	{
		$cbuid = $this->getCbIdMostRecentForNid($nid);

		$this->clearActiveForNids($nid);
		$this->setPrimaryActive($cbuid);
	}

	/**
	 * setupOnePrimaryOneActive - 
	 */
	function setupOnePrimaryOneActive($nid)
	{
		$cbuid = $this->getTopPrimary($nid);
		$this->clearBothForNids($nid);
		$this->setPrimaryActive($cbuid);
	}

	/**
	 * setThePrime - 
	 */
	function setThePrime($nid)
	{
		$cbuid = $this->getTopPrimary($nid);
		$this->setPrimaryActive($cbuid);
	}

	/**
	 * getTopPrimary - 
	 */
	function getTopPrimary($nid)
	{
		$cbuid = 0;
		$list = $this->getPrimaryActiveList($nid, true);

		if ($list) {
			foreach ($list as $item) {
				$cbuid = $item['citebank_unique_identifier_id'];
				break;
			}
		}
				
		return $cbuid;
	}

	/**
	 * updateBiblioUrl - 
	 */
	function updateBiblioUrl($nid)
	{
		if ($this->dbiflag) {
			$url = self::ROOT_CITEBANK_LINK . $nid; 
			$sql = 'UPDATE ' . self::BIBLIO_TABLE . ' SET biblio_url = \'' . $url . '\' WHERE nid = ' . $nid;
			//echo $sql;
			//echo '<br>'."\n";
			$ret = $this->dbi->update($sql);
		}
	}

	/**
	 * createTinyUrlupdateBiblioUrl - 
	 */
	function createTinyUrlupdateBiblioUrl($nid)
	{
		if ($this->dbiflag) {
			$url = self::ROOT_CITEBANK_LINK . $nid; 
			$sql = 'UPDATE ' . self::BIBLIO_TABLE . ' SET biblio_url = \'' . $url . '\' WHERE nid = ' . $nid;
			echo $sql;
			echo '<br>'."\n";
			$ret = $this->dbi->update($sql);
		}
	}

	/**
	 * isExistBiblioUrlBackup - check if the backup has this url already, true if it does
	 */
	function isExistBiblioUrlBackup($url)
	{
		$flag = false;

		// short circuit, filter out the short link
		if (substr_count($url, self::ROOT_CITEBANK_LINK)) {
			$flag = true;
			return $flag;
		}
		
		if ($this->dbiflag) {
			$sql = 'SELECT * FROM ' . self::BIBLIO_BACKUP_TABLE . ' WHERE biblio_url = \'' . $url . '\'';
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$flag = true;
			}
		}

		return $flag;
	}

	/**
	 * insertBiblioUrlToBackup - 
	 */
	function insertBiblioUrlToBackup($nid, $url)
	{
		if ($this->dbiflag) {
			
			// it has one?, don't pile up more, and silently ignore the tiny urls please too
			if ($this->isExistBiblioUrlBackup($url)) {
				return;
			}
			
			$sql = 'INSERT INTO ' . self::BIBLIO_BACKUP_TABLE . ' SET biblio_url = \'' . $url . '\', nid = ' . $nid;
//			echo $sql;
//			$msg = $sql;
//			$this->watchdog($msg);
			$ret = $this->dbi->update($sql);
		}
	}

/*

SELECT DISTINCT nid FROM citebank_unique_identifier LIMIT 10;
SELECT DISTINCT nid FROM citebank_unique_identifier;
SELECT DISTINCT COUNT(nid) FROM citebank_unique_identifier;

SELECT DISTINCT nid, citebank_unique_identifier_id, active, prime FROM citebank_unique_identifier LIMIT 10;
SELECT DISTINCT nid, citebank_unique_identifier_id AS cbuid, active, prime FROM citebank_unique_identifier ORDER BY cbuid LIMIT 10;
SELECT DISTINCT nid, citebank_unique_identifier_id AS cbuid, active, prime FROM citebank_unique_identifier ORDER BY cbuid DESC LIMIT 10;

SELECT nid, citebank_unique_identifier_id AS cbuid, active, prime FROM citebank_unique_identifier ORDER BY nid DESC, cbuid DESC;
SELECT nid, citebank_unique_identifier_id AS cbuid, active, prime FROM citebank_unique_identifier WHERE nid = 29886 ORDER BY nid, cbuid DESC;

*/

	/**
	 * intializePrimes - set up the list for the first time
	 */
	function intializePrimes()
	{
		$list = null;
		$testmax = 3;

		if ($this->dbiflag) {
			$sql = 'SELECT distinct nid FROM ' . self::ID_TABLE . '';

			$rows = $this->dbi->fetch($sql);

			if (count($rows) > 0) {
				$list = $rows;
				
				foreach ($list as $item) {
					$nid = $item['nid'];

					$this->setIntialPrime($nid);
					$testcount++;
					if ($testcount >= $testmax) {
						break;
					}
				}
			}
		}
		
		return $list;
	}

	/**
	 * intializeBiblioUrls - 
	 */
	function intializeBiblioUrls()
	{
		$list = null;

		if ($this->dbiflag) {
			$sql = 'SELECT distinct nid FROM ' . self::ID_TABLE . ' ORDER BY nid' . ' limit 10';  // FIXME: remove limit
			//$sql = 'SELECT distinct nid FROM ' . self::ID_TABLE . ' ORDER BY nid';  // FIXME: remove limit

			$rows = $this->dbi->fetch($sql);

			if (count($rows) > 0) {
				$list = $rows;
				
				foreach ($list as $item) {
					$nid = $item['nid'];

					//$this->updateBiblioUrl($nid);  // FIXME: activate this line
//					echo 'Nid: [' . $nid . '] <br>';
				}
			}
		}
		
		return $list;
	}

//select distinct nid, biblio_url from biblio order by nid limit 10;
//			$sql = 'SELECT distinct nid, biblio_url FROM ' . self::BIBLIO_TABLE . ' ORDER BY nid' . ' limit 10';

	/**
	 * copyBiblioUrlsToBackup - set up the list for the first time
	 */
	function copyBiblioUrlsToBackup($lo = 0, $hi = 0)
	{
		$list = null;

		if ($this->dbiflag) {
			
			//$limit = ' LIMIT 10';   // FIXME remove limit 10
			$limit = '';
			$sql = 'SELECT nid, biblio_url FROM ' . self::BIBLIO_TABLE . ' ORDER BY nid' . $limit;

			if (($lo > 0 && $hi > 0) && ($hi >= $lo)) {
				$sql = 'SELECT nid, biblio_url FROM ' . self::BIBLIO_TABLE . ' WHERE nid >= ' . $lo . ' AND nid <= ' . $hi . ' ORDER BY nid' . $limit;
			} else {
				//$sql = 'SELECT distinct nid, biblio_url FROM ' . self::BIBLIO_TABLE . ' ORDER BY nid' . ' limit 10';
				$sql = 'SELECT nid, biblio_url FROM ' . self::BIBLIO_TABLE . ' ORDER BY nid' . $limit;
				//$sql = 'SELECT nid, biblio_url FROM ' . self::BIBLIO_TABLE . ' ORDER BY nid';
			}

			$rows = $this->dbi->fetch($sql);

			if (count($rows) > 0) {
				$list = $rows;
				
				foreach ($list as $item) {
					$nid = $item['nid'];
					$url = $item['biblio_url'];

					$this->insertBiblioUrlToBackup($nid, $url);
//					echo 'Nid: [' . $nid . '] Url: ' . $url . ' <br>';
				}
			}
		}
		
		return $list;
	}

	/**
	 * updateBiblioUrlToShortForm - 
	 */
	function updateBiblioUrlToShortForm($nid)
	{
		$this->updateBiblioUrl($nid);
	}

//select nid, title, status, changed from node join apachesolr_search_node as asn on (node.nid = asn.nid) where asn.changed > '1318609928';

//select n.nid, n.title, asn.status, asn.changed from node as n join apachesolr_search_node as asn on (n.nid = asn.nid) where asn.changed > '1318523528';

//select n.nid, b.biblio_url, n.title, asn.status, asn.changed from node as n join apachesolr_search_node as asn on (n.nid = asn.nid) join biblio as b on (n.nid = b.nid) where asn.changed > '1318523528';

//select n.nid, b.biblio_url, c.biblio_url, n.title, asn.status, asn.changed from node as n join apachesolr_search_node as asn on (n.nid = asn.nid) join biblio as b on (n.nid = b.nid) join citebank_internet_archive_records as c on (n.nid = c.nid) where asn.changed > '1318523528';

	/**
	 * getRecentList - 
	 */
	function getRecentList()
	{
		$list = null;

		if ($this->dbiflag) {

			$nids = array();
			
			$nids = $this->getLowNidHighNid();
			$lo = $nids['lo'];
			$hi = $nids['hi'];

			$sql = 'SELECT n.nid, b.biblio_url AS url, c.biblio_url AS oldurl, n.title, asn.status, asn.changed FROM node AS n JOIN apachesolr_search_node AS asn ON (n.nid = asn.nid) JOIN biblio as b ON (n.nid = b.nid) JOIN citebank_internet_archive_records AS c ON (n.nid = c.nid) WHERE n.nid >= ' . $lo . ' and n.nid <= ' . $hi . ' order by n.nid';
			//echo $sql;
			$rows = $this->dbi->fetch($sql);

			if (count($rows) > 0) {
				$list = $rows;
			}
		}
		
		return $list;
	}

	/**
	 * getRecentList - 
	 */
	function getRecentListRangeOLD($lo, $hi)
	{
		$list = null;

		if ($this->dbiflag) {

			$sql = 'SELECT n.nid, b.biblio_url AS url, c.biblio_url AS oldurl, n.title, asn.status, asn.changed FROM node AS n JOIN apachesolr_search_node AS asn ON (n.nid = asn.nid) JOIN biblio as b ON (n.nid = b.nid) JOIN citebank_internet_archive_records AS c ON (n.nid = c.nid) WHERE n.nid >= ' . $lo . ' and n.nid <= ' . $hi . ' order by n.nid';
			//echo $sql;
			$rows = $this->dbi->fetch($sql);

			if (count($rows) > 0) {
				$list = $rows;
			}
		}
		
		return $list;
	}

	/**
	 * getRecentListRange - 
	 */
	function getRecentListRange($lo, $hi)
	{
		$list = null;

		if ($this->dbiflag) {

			$sql = 'SELECT n.nid, b.biblio_url AS url, b.biblio_url AS oldurl, n.title FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE n.nid >= ' . $lo . ' AND n.nid <= ' . $hi . ' ORDER BY n.nid';
			//echo $sql;
			$rows = $this->dbi->fetch($sql);

			if (count($rows) > 0) {
				$list = $rows;
			}
		}
		
		return $list;
	}

	/**
	 * getRecentList - 
	 */
	function getRecentListOLD()
	{
		$list = null;

		if ($this->dbiflag) {

			//$now = time() - 86400; // a day ago
			$now = 1315597035 - 86400; // a day ago  FIXME remove fixed time
			
			$sql = 'SELECT n.nid, b.biblio_url AS url, c.biblio_url AS oldurl, n.title, asn.status, asn.changed FROM node AS n JOIN apachesolr_search_node AS asn ON (n.nid = asn.nid) JOIN biblio as b ON (n.nid = b.nid) JOIN citebank_internet_archive_records AS c ON (n.nid = c.nid) WHERE asn.changed > ' . $now . '';
			//echo $sql;
			$rows = $this->dbi->fetch($sql);

			if (count($rows) > 0) {
				$list = $rows;
			}
		}
		
		return $list;
	}

//  select count(*) from biblio where biblio_url not like 'http:citebank.org/uid.php%';
	/**
	 * getCountNewItems - 
	 */
	function getCountNewItems()
	{
		$total = 0;

		if ($this->dbiflag) {
			$sql = 'SELECT count(*) AS total FROM biblio WHERE biblio_url NOT LIKE \'' . self::ROOT_SEARCH_LINK . '%\'';
			$rows = $this->dbi->fetch($sql);
			
			if (count($rows) > 0) {
				$total = $rows[0]['total'];
			}
		}

		return $total;
	}

	/**
	 * getNewItemsList - 
	 */
	function getNewItemsList()
	{
		$list = null;

		if ($this->dbiflag) {
			$total = $this->getCountNewItems();

			// if new items, get list
			if ($total > 0) {
				$sql = 'SELECT nid, biblio_url FROM biblio WHERE biblio_url NOT LIKE \'' . self::ROOT_SEARCH_LINK . '%\'';
	
				//echo $sql;
				$rows = $this->dbi->fetch($sql);
	
				if (count($rows) > 0) {
					$list = $rows;
				}
			}
		}

		return $list;
	}

	/**
	 * maintain - 
	 */
	function maintain()
	{
		$flag = false;
		
		// filter out items that are IA process potential items, pick them up later in another cycle hopefully after they have been moved to IA
		
		return $flag;
	}

	/**
	 * maintain - 
	 */
	function addRange()
	{
		$flag = false;
		
		// filter out items that are IA process potential items, pick them up later in another cycle hopefully after they have been moved to IA
		
		return $flag;
	}

	/**
	 * sweep - 
	 */
	function sweep()
	{
		$list = $this->getRecentList();
		
		if ($list) {
			foreach ($list as $item) {
				$oldurl = $item['oldurl'];
				echo '<br> OLD URL: [' . $oldurl . ']<br>';
				$url = $item['url'];
				echo '<br> CUR URL: [' . $url . ']<br>';
				$nid = $item['nid'];
				$foundOld = $this->isExist($oldurl);
				$foundUrl = $this->isExist($url);
							
				// previous biblio_url
				// a bhl article or csv imported data, that now has an IA link in biblio_url
				if (!$foundOld) {
					$this->add($nid, $oldurl);
				}

				// biblio_url not in 
				if (!$foundUrl) {
					echo '****** NOT FOUND URL, adding *****';
					$this->add($nid, $url);
					
					// set to short link
					$this->updateBiblioUrl($nid);
					
					
				} else {
					echo '***** found URL ******';
				}
//				print_r($item);
//				echo '<br>';
//				echo '<br>';
			}
		}
		
	}

	/**
	 * createTableBackupBiblioUrls - build the table for backup of biblio urls
	 */
	function createTableBackupBiblioUrls()
	{
		// table: citebank_unique_identifier
		
		// nid     - node id
		// url     - url  (used to check for previous source, also used as destination if 'active')

		// INSERT INTO biblio_backup_urls SET biblio_url = 'http://hdl.handle.net/10088/5098', nid = 29886
		// CREATE TABLE `biblio_backup_urls` (`biblio_backup_urls_id` int(11) unsigned NOT NULL auto_increment, `nid` int(11) default NULL, `biblio_url` varchar(255) default NULL, PRIMARY KEY  (`biblio_backup_urls_id`))

		if ($this->dbiflag) {
			$sql = 'CREATE TABLE `' . self::BIBLIO_BACKUP_TABLE . '` (
			  `biblio_backup_urls_id` int(11) unsigned NOT NULL auto_increment,
			  `nid` int(11) default NULL,
			  `biblio_url` varchar(255) default NULL,
			  PRIMARY KEY  (`biblio_backup_urls_id`)
			)';
			
			$this->dbi->update($sql);
		}
	}

	/**
	 * isTableBiblioBackup - 
	 */
	function isTableBiblioBackup()
	{
		$flag = false;
		
		if ($this->dbiflag) {
			$sql = "SHOW TABLES LIKE '" . self::BIBLIO_BACKUP_TABLE . "'";
			$row = $this->dbi->fetch($sql);
			
			if (count($row) > 0) {
				$flag = true;
			}
		}

		return $flag;
	}	

	/**
	 * watchdog - logging
	 */
	function watchdog($msg)
	{
		if ($this->loggingFlag) {

			$type = 'CBUID';
			$severity = 6;
			$now = time();
			
			$sql = 'INSERT INTO watchdog SET type = ' . "'" . $type . "'" . ', message = ' . "'" . $msg . "'" . '' . ', severity = ' . $severity . '' . ', timestamp = ' . "'" . $now . "'" . '';
	
			$this->dbi->insert($sql);
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
