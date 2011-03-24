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

	const CLASS_NAME    = 'FedoraController';

	const NAME_SPACE    = 'citebank';
//	const BASE_URL      = 'http://172.16.17.197:8080/fedora/';  // FIXME: make configurable

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
	}

	/**
	 * getConfigs - get config settings
	 */
	function getConfigs()
	{
		$configs = $this->fedoraModel->getConfigs();
		
		$this->throttle     = $configs['throttle'];
		$this->throttleFlag = $configs['throttleFlag'];
		
		$this->hostServer   = $configs['hostServer']; //'http://172.16.17.197:8080/fedora/';
		$this->namespace    = $configs['namespace']; //self::NAME_SPACE;
		$this->loggingFlag  = $configs['loggingFlag'];

		$this->processFlag  = $configs['processFlag'];
		
		$this->fedoraClient->hostServer = $this->hostServer;
		$this->fedoraClient->loggingFlag = $this->loggingFlag;
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
	 * makeAuthors - 
	 */
	function makeAuthors($nodeId)
	{
		$authors = '';
		
		//$authors = implode(';', $contributors);
		/* name
		   lastname
		   firstname
		   prefix
		   suffix
		   initials
		*/
		
		$list = $this->fedoraModel->getCitationContributors($nodeId);

		if (count($list)) {
			foreach ($list as $author) {
				$authors .= trim($author['name']);
				$authors .= '; ';
			}
//fedora_watchmen('authors ' . print_r($author, true));
//fedora_watchmen('authors name ' . $author['name']);
			$authors = trim($authors, ' ');
			$authors = rtrim($authors, ';');
		}
//fedora_watchmen('authors [' . $authors . ']');

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
	function xmlifyDataFilter($str)
	{
		$purifiedStr = str_replace('–', '', $str);
		//$purifiedStr = str_replace('’', '', $purifiedStr);
		//$purifiedStr = str_replace('“', '', $purifiedStr);
		//$purifiedStr = str_replace('”', '', $purifiedStr);
		//$purifiedStr = str_replace(',', '', $purifiedStr);

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
		$allowed = "/[^a-zA-Z0-9\\040\\.\\-\\_\\\\]/i";
		$purifiedStr = preg_replace($allowed, "", $purifiedStr);
  
		return $purifiedStr;
	}

	/**
	 * filterAccents - 
	 */
	function filterAccents($str)
	{
		$search  = explode(",", "ç,æ,œ,á,é,í,ó,ú,à,è,ì,ò,ù,ä,ë,ï,ö,ü,ÿ,â,ê,î,ô,û,å,e,i,ø,u,ã");
		$replace = explode(",", "c,ae,oe,a,e,i,o,u,a,e,i,o,u,a,e,i,o,u,y,a,e,i,o,u,a,e,i,o,u,a");

		$purifiedStr = str_replace($search, $replace, $str);

		return $purifiedStr;
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
	
		$this->fedoraFoxXml->clearData();
		$this->fedoraFoxXml->subjectName = $pidName;
		$this->fedoraFoxXml->state       = 'A';  // active
		$this->fedoraFoxXml->controlGrp  = 'X';  // xml
		$this->fedoraFoxXml->baseUrl     = $node['biblio_url'];
	
		// package up the data
		$this->fedoraFoxXml->title       = $this->filterAccents($this->xmlifyDataFilter($node['title']));
		$this->fedoraFoxXml->creator     = 'CiteBank';
		$this->fedoraFoxXml->subject     = $this->filterAccents($this->xmlifyDataFilter($node['title']));  // TODO: something else?
		$this->fedoraFoxXml->description = $this->xmlifyDataFilter($node['biblio_abst_e']);
		$this->fedoraFoxXml->publisher   = $this->xmlifyDataFilter($node['biblio_publisher']);
		$this->fedoraFoxXml->identifier  = $this->xmlifyDataFilter($nodeId);
		$contributors = $this->makeAuthors($nodeId);  // list out authors
		$this->fedoraFoxXml->contributor = $this->filterAccents($this->xmlifyDataFilter($contributors));//
		$this->fedoraFoxXml->date        = $this->xmlifyDataFilter($node['biblio_year']);
		$this->fedoraFoxXml->type        = $this->xmlifyDataFilter($node['biblio_type']);  // TODO: do we want to translate to words instead of code number?
		$this->fedoraFoxXml->format      = 'blank';
		$this->fedoraFoxXml->source      = $this->xmlifyDataFilter($node['biblio_remote_db_provider']);
		$this->fedoraFoxXml->language    = $this->xmlifyDataFilter($node['biblio_lang']);
		$this->fedoraFoxXml->relation    = 'none';
		$this->fedoraFoxXml->coverage    = 'NA';
		$this->fedoraFoxXml->rights      = 'public domain';  // TODO: is this something else? 
	
		$this->fedoraFoxXml->pidName     = $pidName;
		$this->fedoraFoxXml->pid         = $pidNum;
//		echo htmlentities($xml); echo '<br>';
		$xml = $this->fedoraFoxXml->buildFoxXml($ext);
//		echo '<pre>' . htmlentities($xml) . '</pre>' . '<br>' . "\n";
		$this->fedoraClient->pid     = $pidName . ':' . $pidNum;
		$this->fedoraClient->pidName = $pidName;
		$this->fedoraClient->pidNum  = $pidNum;

		if ($this->loggingFlag) {
			fedora_watchmen('fox xml author name ' . $this->fedoraFoxXml->contributor);
		}
		
		// create the fox xml file
		$this->fedoraClient->saveFoxFiles($xml);
		
		// feed fedora the data
		$resp = $this->fedoraClient->sendData($xml, $pidName, $pidNum);
//fedora_watchmen('sendData resp ' . $resp);
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
