<?php
// $Id: FedoraController.php,v 1.0.0.0 2010/10/12 4:44:44 dlheskett $

/** FedoraController class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 10/12/2010
 *
 */

$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'FedoraModel.php');
require_once($includePath . 'FedoraClient.php');
require_once($includePath . 'FedoraFoxXmlController.php');

// FEDORA -  Flexible Extensible Digitial Object and Repository Architecture
/** 
 * class FedoraController - Pass citations and uploaded files from Biblio into Fedora via FOXML.
 * 
 */
class FedoraController
{
	public $className;
	public $fedoraClient;
	public $fedoraFoxXml;
	public $fedoraModel;
	
	public $throttleFlag = false;
	public $throttle     = 100;
	public $hostServer   = '';
	public $namespace    = '';
	public $loggingFlag  = false;
	public $processFlag  = 0;

	public $fedoraUser   = 'fedoraAdmin';
	public $fedoraPass   = 'fedoraAdmin';

	public $publicationNames;
	public $publicationKeys;
	public $listFlag;

	const CLASS_NAME    = 'FedoraController';

	const NAME_SPACE    = 'citebank';

	const FEDORA_TABLE  = 'citebank_fedora_commons_records';

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

		$this->fedoraClient = new FedoraClient();
	
		$this->fedoraFoxXml = new FedoraFoxXmlController();

		$this->fedoraModel = new FedoraModel();

		$this->getConfigs();

		$this->publicationNames = array();
		$this->publicationKeys = array();
		$this->listFlag = false;
		
		$this->getPublicationTypesData();
	}

	/**
	 * getConfigs - get config settings
	 */
	function getConfigs()
	{
		$configs = $this->fedoraModel->getConfigs();
		
		$this->throttle     = $configs['throttle'];
		$this->throttleFlag = $configs['throttleFlag'];
		
		$this->hostServer   = $configs['hostServer'];
		$this->namespace    = $configs['namespace'];
		$this->loggingFlag  = $configs['loggingFlag'];

		$this->processFlag  = $configs['processFlag'];

		$this->fedoraUser  = $configs['fedoraUser'];
		$this->fedoraPass  = $configs['fedoraPass'];
		
		$this->fedoraClient->hostServer = $this->hostServer;
		$this->fedoraClient->loggingFlag = $this->loggingFlag;

		$this->fedoraClient->fedoraUser = $this->fedoraUser;
		$this->fedoraClient->fedoraPass = $this->fedoraPass;

	}

/*

		$node['biblio_abst_e']               = $this->data_abst_e;
		$node['biblio_abst_f']               = $this->data_abst_f;
		$node['biblio_access_date']          = $this->data_access_date;
		$node['biblio_accession_number']     = $this->data_accession_number;
		$node['biblio_alternate_title']      = $this->data_alternate_title;
		$node['biblio_auth_address']         = $this->data_auth_address;
		$node['biblio_call_number']          = $this->data_call_number;
		$node['biblio_citekey']              = $this->data_citekey;
		$node['biblio_coins']                = $this->data_coins;
		$node['biblio_contributors']         = $this->data_contributors;
		$node['biblio_custom1']              = $this->data_custom1;
		$node['biblio_custom2']              = $this->data_custom2;
		$node['biblio_custom3']              = $this->data_custom3;
		$node['biblio_custom4']              = $this->data_custom4;
		$node['biblio_custom5']              = $this->data_custom5;
		$node['biblio_custom6']              = $this->data_custom6;
		$node['biblio_custom7']              = $this->data_custom7;
		$node['biblio_date']                 = $this->data_date;
		$node['biblio_doi']                  = $this->data_doi;
		$node['biblio_edition']              = $this->data_edition;
		$node['biblio_full_text']            = $this->data_full_text;
		$node['biblio_isbn']                 = $this->data_isbn;
		$node['biblio_issn']                 = $this->data_issn;
		$node['biblio_issue']                = $this->data_issue;
		$node['biblio_keywords']             = $this->data_keywords;
		//$node['biblio_label']                = $this->data_label;
		$node['biblio_lang']                 = $this->data_lang;
		$node['biblio_notes']                = $this->data_notes;
		$node['biblio_number']               = $this->data_number;
		$node['biblio_number_of_volumes']    = $this->data_number_of_volumes;
		$node['biblio_original_publication'] = $this->data_original_publication;
		$node['biblio_other_number']         = $this->data_other_number;
		$node['biblio_pages']                = $this->data_pages;
		$node['biblio_place_published']      = $this->data_place_published;
		$node['biblio_publisher']            = $this->data_publisher;
		$node['biblio_refereed']             = $this->data_refereed;
		//$node['biblio_remote_db_name']       = $this->data_remote_db_name;
		//$node['biblio_remote_db_provider']   = $this->data_remote_db_provider;
		$node['biblio_reprint_edition']      = $this->data_reprint_edition;
		$node['biblio_research_notes']       = $this->data_research_notes;
		$node['biblio_secondary_title']      = $this->data_secondary_title;
		$node['biblio_section']              = $this->data_section;
		$node['biblio_short_title']          = $this->data_short_title;
		$node['biblio_tertiary_title']       = $this->data_tertiary_title;
		$node['biblio_title']                = $this->data_title;
		$node['title']                       = $this->data_title;  // because biblio insists on putting the title in the drupal node instead.
		$node['biblio_translated_title']     = $this->data_translated_title;
		$node['biblio_type']                 = $this->data_type;
		$node['biblio_type_of_work']         = $this->data_type_of_work;
		$node['biblio_url']                  = $this->data_url;
		$node['biblio_volume']               = $this->data_volume;
		$node['biblio_year']                 = $this->data_year;

		$node['biblio_remote_db_provider']   = $this->data_source_org; // sourceOrg;
		$node['biblio_label']                = $this->data_source_prj; // sourcePrj;
		$node['biblio_remote_db_name']       = $this->data_source_url; // sourceUrl;


*/

	/**
	 * makeAuthorsArray - make list of authors as an array
	 */
	function makeAuthorsArray($nodeId)
	{
		$authors = array();
		
		$list = $this->fedoraModel->getCitationContributors($nodeId);

		if (count($list)) {
			foreach ($list as $author) {
				$authors[] = trim($author['name']);
			}
		}

		return $authors;
	}
	
	/**
	 * updateFedora - 
	 */
	function updateFedora($nodeId, $node)
	{
		// TODO: finish this
	}

	/**
	 * storeFedoraCitation - 
	 */
	function storeFedoraCitation($citation)
	{
		$nodeId = $citation->nid;
		$biblio = $this->fedoraModel->getCitationData($nodeId);
		
		if ($this->loggingFlag) {
			fedora_watchmen('storeFedoraCitation ' . $nodeId);
		}
		
		$wroteToFedora = $this->writeFedora($nodeId, $biblio);
		
		if ($wroteToFedora) {
			$this->fedoraModel->setFedoraState(FedoraModel::FDC_SENT, $nodeId);
		}
		
		// done
	}

	/**
	 * updateFedoraCitation - 
	 */
	function updateFedoraCitation($nodeId, $node)
	{
		// done
	}

	/**
	 * handleCitations - 
	 */
	function handleCitations()
	{
		// check if we need to collect citations and create table listing
		// check if we need to collect newer citations and add to table listing
		$this->processCitationsCollection();
		
		// get list of citations that we need to transfer to Fedora Commons Repository		
		$this->processCitations();
		
		// done
	}

	/**
	 * processCitationsCollection - 
	 */
	function processCitationsCollection()
	{
		$x = 0;
		
		// check if we need to collect citations and create table listing
		$newCitations = $this->fedoraModel->collectNewCitations();

		if ($this->loggingFlag) {
			fedora_watchmen('process citations collection ' . count($newCitations));
		}
		
		if (count($newCitations) > 0) {
			foreach ($newCitations as $key => $nid) {
				$this->fedoraModel->addCitationItem($nid, FedoraModel::FDC_TRANSFER);
				
				$x++;
				if ($this->loggingFlag) {
					fedora_watchmen('add citation ' . $x . ' nid:' . $nid . '');
				}
				// if we desire a throttle on how many we process at a time, then max out on the count
				if ($this->throttleFlag) {
					if ($x >= $this->throttle) {
						break;
					}
				}
			}
		}
		
		// done
		return count($newCitations);
	}

	/**
	 * processCitations - 
	 */
	function processCitations()
	{
		// get list of citations that we need to transfer to Fedora Commons Repository		
		$citations = $this->fedoraModel->getCitationList(FedoraModel::FDC_TRANSFER);
		if ($this->loggingFlag) {
			fedora_watchmen('process citations ' . count($citations));
		}

		$citationsCount = count($citations);

		// process the list
		if ($citationsCount > 0) {
			foreach ($citations as $citation) {
				$nodeId = $citation->nid;
				
				// if fedora entry exists, mark we have it stored, else add it
				if ($this->fedoraClient->isExists($this->namespace.':'.$nodeId)) {
					$this->fedoraModel->setFedoraState(FedoraModel::FDC_SENT, $nodeId);
				} else {
					$this->storeFedoraCitation($citation);
				}
			}
		}
		
		// done
		return $citationsCount;
	}

	/**
	 * xmlifyDataFilter - 
	 */
	function xmlifyDataFilter($str, $option = 6)
	{
		$purifiedStr = $str;
		
		switch ($option)
		{
			case 1:
				$purifiedStr = str_replace('–', '', $str);

				// remove xml illegals:  & < > " ' 
				$purifiedStr = str_replace('&', '', $purifiedStr);
				$purifiedStr = str_replace('<', '', $purifiedStr);
				$purifiedStr = str_replace('>', '', $purifiedStr);
				$purifiedStr = str_replace('"', '', $purifiedStr);
				$purifiedStr = str_replace("'", '', $purifiedStr);
		
				//$purifiedStr = str_replace("“", '', $purifiedStr);
				//$purifiedStr = str_replace("”", '', $purifiedStr);
				//$purifiedStr = str_replace("’", '', $purifiedStr);

				$purifiedStr = str_replace("“", '"', $purifiedStr);
				$purifiedStr = str_replace("”", '"', $purifiedStr);
				$purifiedStr = str_replace("’", "'", $purifiedStr);

				$purifiedStr = $this->filterAccents($purifiedStr, 1);
				break;
				
			case 2:
				$purifiedStr = str_replace('–', '', $str);
		
				// remove xml illegals:  & < > " ' 
				$purifiedStr = str_replace('&', '', $purifiedStr);
				$purifiedStr = str_replace('<', '', $purifiedStr);
				$purifiedStr = str_replace('>', '', $purifiedStr);
				$purifiedStr = str_replace('"', '', $purifiedStr);
				$purifiedStr = str_replace("'", '', $purifiedStr);
		
				$purifiedStr = str_replace("“", '', $purifiedStr);
				$purifiedStr = str_replace("”", '', $purifiedStr);
				$purifiedStr = str_replace("’", '', $purifiedStr);
				
				// cut out xml breaking characters
				$allowed = "/[^a-zA-Z0-9 _?=\/\\040\\.\\-\\_\\\\]/i";
				$purifiedStr = preg_replace($allowed, "", $purifiedStr);
				break;
				
			case 3:
				$purifiedStr = str_replace("“", '', $purifiedStr);
				$purifiedStr = str_replace("”", '', $purifiedStr);
				$purifiedStr = str_replace("’", '', $purifiedStr);
				break;
				
			case 4:
				$purifiedStr = $this->xmlEntities($purifiedStr);
		
				// cut out xml breaking characters
				$allowed = "/[^a-zA-Z0-9 _?:=&;\ \/\\040\\.\\-\\_\\\\]/i";
				$purifiedStr = preg_replace($allowed, "", $purifiedStr);
				break;

			case 5:
				//$purifiedStr = $this->xmlEntities($purifiedStr);
		
				// cut out xml breaking characters
				$trans = get_html_translation_table(HTML_ENTITIES);
				//$encoded = "&lt;p&gt;Angoul&ecirc;me&lt;/p&gt;";
				$purifiedStr = strtr($purifiedStr, $trans);
				break;

			case 6:
				$purifiedStr = $this->xmlEntities($purifiedStr);
		
				// cut out xml breaking characters
				$purifiedStr = utf8_encode($purifiedStr);
				break;

			case 0:
			default:
				$purifiedStr = '<![CDATA['.$purifiedStr.']]>';
				break;
		}				
  
		return $purifiedStr;
	}

	/**
	 * xmlEntities - 
	 */
	function xmlEntities($string)
	{
	    return str_replace( array ( '&', '"', "'", '<', '>', "’", "“", "”" ), array ( '&amp;', '&quot;', '&apos;', '&lt;', '&gt;', '&apos;', '&quot;', '&quot;'), $string );
	}

	/**
	 * filterAccents - 
	 */
	function filterAccents($str, $option = 0)
	{
		$purifiedStr = $str;

		switch ($option)
		{
			case 1:
				$search  = explode(",", "ç,æ,œ,á,é,í,ó,ú,à,è,ì,ò,ù,ä,ë,ï,ö,ü,ÿ,â,ê,î,ô,û,å,ø,ã");
				$replace = explode(",", "c,ae,oe,a,e,i,o,u,a,e,i,o,u,a,e,i,o,u,y,a,e,i,o,u,a,o,a");
		
				$purifiedStr = str_replace($search, $replace, $str);
				break;
				
			case 2:
				$purifiedStr = '<![CDATA['.$purifiedStr.']]>';
				break;

			case 0:
			default:
				$purifiedStr = '<![CDATA['.$purifiedStr.']]>';
				break;
		}				

		return $purifiedStr;
	}

	/**
	 * getKeywordsList - 
	 */
	function getKeywordsList($nodeId, $filter = true)
	{
		$subjects = array();
		
		$words = $this->fedoraModel->getKeywordsList($nodeId);
		
		if (count($words) > 0) {
			foreach ($words as $key => $word) {
				if ($filter) {
					$subjects[] = $this->xmlifyDataFilter(trim($word['word']));
				} else {
					$subjects[] = trim($word['word']);
				}
			}
		} else {
			$subjects = null;
		}

		return $subjects;
	}

	/**
	 *  getPublicationTypesData - get number values for word values of publication types
	 */
	function getPublicationTypesData()
	{
		$this->fedoraModel->getPublicationTypesData($this->publicationNames, $this->publicationKeys, $this->listFlag);
	}

	/**
	 *  getPublicationType - get publication type from number key
	 */
	function getPublicationType($key)
	{
		$type = '';
		if ($this->listFlag) {
			$type = $this->publicationKeys[$key];
		}
		
		return $type;
	}

	/**
	 * writeFedora - 
	 */
	function writeFedora($nodeId, $node)
	{
		$flag = false;
		$namespace   = $this->namespace;
		$nextPid     = $nodeId;
	
		$pidName     = $namespace;
		$pidNum      = $nextPid;
		$ext         = 'pdf';

		$authors = array();
		$contributorsList = $this->makeAuthorsArray($nodeId);  // list out authors
		if (count($contributorsList)) {
			foreach ($contributorsList as $contributor) {
				$authors[] = $this->xmlifyDataFilter($contributor);
			}
		} else {
			$authors = null;
		}
		
		// build list of keywords for subject
		$keywordsList = $this->getKeywordsList($nodeId);
	
		$publishers[] = $node['biblio_publisher'];
		$publishers[] = $node['biblio_remote_db_provider'];
		
		$type = $this->getPublicationType($node['biblio_type']);  // translate number into human word

		$host = $_SERVER['SERVER_NAME'];
		
		// if year is 9999 make it blank, we don't want to store the biblio centric "no year" marker
		$year = ($node['biblio_year'] == 9999 ? '' : $node['biblio_year']);
	
		$this->fedoraFoxXml->clearData();
		$this->fedoraFoxXml->subjectName = $pidName;
		$this->fedoraFoxXml->state       = 'A';  // active
		$this->fedoraFoxXml->controlGrp  = 'X';  // xml
		$this->fedoraFoxXml->baseUrl     = htmlentities($node['biblio_url'], ENT_QUOTES, 'UTF-8');  // make friendly to the xml parser in Fedora
	
		// package up the data
		$this->fedoraFoxXml->title       = $this->xmlifyDataFilter($node['title']);
		$this->fedoraFoxXml->creator     = $authors;
		$this->fedoraFoxXml->subject     = $keywordsList; // grab any keywords and put in the subject field
		$this->fedoraFoxXml->description = $this->xmlifyDataFilter($node['biblio_abst_e']);
		$this->fedoraFoxXml->publisher   = $publishers;
		$this->fedoraFoxXml->identifier  = 'http://' . $host . '/node/' . $nodeId;
		$this->fedoraFoxXml->contributor = ''; // empty
		$this->fedoraFoxXml->date        = $year;
		$this->fedoraFoxXml->type        = $type;  // translated to words from code number
		$this->fedoraFoxXml->format      = '';
		$this->fedoraFoxXml->source      = htmlentities($node['biblio_url'], ENT_QUOTES, 'UTF-8');
		$this->fedoraFoxXml->language    = $node['biblio_lang'];
		$this->fedoraFoxXml->relation    = '';
		$this->fedoraFoxXml->coverage    = '';
		$this->fedoraFoxXml->rights      = ''; //'public domain';  // TODO: is this something else? 
	
		$this->fedoraFoxXml->pidName     = $pidName;
		$this->fedoraFoxXml->pid         = $pidNum;

		$xml = $this->fedoraFoxXml->buildFoxXml($ext);

		$this->fedoraClient->pid     = $pidName . ':' . $pidNum;
		$this->fedoraClient->pidName = $pidName;
		$this->fedoraClient->pidNum  = $pidNum;

		if ($this->loggingFlag) {
			fedora_watchmen('fox xml author name ' . $this->fedoraFoxXml->contributor);
		}
		
		// create the fox xml file
		$this->fedoraClient->saveFoxFiles($xml);
		
		// feed fedora the data
		$this->fedoraClient->httpcode = 200; // clear it to good so we don't have confusion with setting elsewhere in isExists.
		$resp = $this->fedoraClient->sendData($xml, $pidName, $pidNum);

		// an error has something like "Fedora: 401"
		// success has basically like  "citebank:12345"
		if ($this->loggingFlag) {
			if ($this->fedoraClient->httpcode != 200) {
				fedora_watchmen('sendData resp ' . $this->fedoraClient->httpcode);
			}
		}
		
		if (strstr($resp, $pidName . ':' . $pidNum)) {
			$flag = true;
		}
		
		// done
		return $flag;
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
