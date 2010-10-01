<?php
// $Id: DataHandlerModel.php,v 1.0.0.0 2010/09/15 4:44:44 dlheskett $

/** DataHandlerModel base class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/15/2010
 *
 */

/** 
 * class DataHandlerModel - model data handler
 * 
 */
abstract class DataHandlerModel
{
	public $className;
	
	public $record;
	public $xpath;
	public $info;
	// data
	public $data_place_published;
	public $data_call_number;
	public $data_contributors;
	public $data_date;
	public $data_edition;
	public $data_isbn;
	public $data_issn;
	public $data_issue;
	public $data_keywords;
	public $data_lang;
	public $data_pages;
	public $data_publisher;
	public $data_secondary_title;
	public $data_section;
	public $data_title;
	public $data_type;
	public $data_url;
	public $data_volume;
	public $data_year;

	public $data_source_org;
	public $data_source_prj;
	public $data_source_url;


	const CLASS_NAME    = 'DataHandlerModel';

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
		$this->info = '';
		$this->record = '';
		$this->xpath = '';
		$this->className = self::CLASS_NAME;

		$this->data_call_number      = '';
		$this->data_contributors     = array();
		$this->data_date             = '';
		$this->data_edition          = '';
		$this->data_isbn             = '';
		$this->data_issn             = '';
		$this->data_issue            = '';
		$this->data_lang             = '';
		$this->data_keywords         = '';
		$this->data_pages            = '';
		$this->data_place_published  = '';
		$this->data_publisher        = '';
		$this->data_secondary_title  = '';
		$this->data_section          = '';
		$this->data_title            = '';
		$this->data_type             = '';
		$this->data_url              = '';
		$this->data_volume           = '';
		$this->data_year             = '';

		$this->data_source_org       = '';
		$this->data_source_prj       = '';
		$this->data_source_url       = '';

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

/*
	list of important data fields (conceptual name)

	// BIBLIO_FIELD_TOPIC: Publication Type
	// BIBLIO_FIELD_TOPIC: Date Published
	// BIBLIO_FIELD_TOPIC: Year of Publication
	// BIBLIO_FIELD_TOPIC: Journal Title
	// BIBLIO_FIELD_TOPIC: Authors
	// BIBLIO_FIELD_TOPIC: Secondary Authors
	// BIBLIO_FIELD_TOPIC: Publisher
	// BIBLIO_FIELD_TOPIC: Keywords
	// BIBLIO_FIELD_TOPIC: Edition

*/

	/**
	 * parseValue_ - parse the data values
	 */
	abstract protected function parseValue_Identifiers();

	/**
	 * parseValue_ - parse the data values
	 */
	abstract protected function parseValue_Title();

	/**
	 * parseValue_ - parse the data values
	 */
	abstract protected function parseValue_Publisher();
	
	/**
	 * parseValue_ - parse the data values
	 */
	abstract protected function parseValue_DateYear();
	
	/**
	 * parseValue_ - parse the data values
	 */
	abstract protected function parseValue_Lang();
	
	/**
	 * parseValue_ - parse the data values
	 */
	abstract protected function parseValue_Authors();
	
	/**
	 * parseValue_ - parse the data values
	 */
	abstract protected function parseValue_Keywords();

	/**
	 * parseValue_ - parse the data values
	 */
	abstract protected function parseValue_Classification();

	/**
	 * parseValue_ - parse the data values
	 */
	abstract protected function parseValue_PublicationType();

	/**
	 * parseValue_ - parse the data values
	 */
	abstract protected function parseValue_JournalTitle();
	
	/**
	 * parseValue_ - parse the data values
	 */
	abstract protected function parseValue_Edition();
	
	/**
	 * makeInfo - fill up an array with the data
	 */
	protected function makeInfo()
	{
		$this->info['place_published'] = $this->data_place_published;
		$this->info['call_number']     = $this->data_call_number;
		$this->info['contributors']    = $this->data_contributors;
		$this->info['date']            = $this->data_date;
		$this->info['edition']         = $this->data_edition;

		$this->info['isbn']            = $this->data_isbn;
		$this->info['issn']            = $this->data_issn;
		$this->info['issue']           = $this->data_issue;
		$this->info['keywords']        = $this->data_keywords;
		$this->info['lang']            = $this->data_lang;

		$this->info['pages']           = $this->data_pages;
		$this->info['publisher']       = $this->data_publisher;
		$this->info['secondary_title'] = $this->data_secondary_title;
		$this->info['section']         = $this->data_section;
		$this->info['title']           = $this->data_title;

		$this->info['type']            = $this->data_type;
		$this->info['url']             = $this->data_url;
		$this->info['volume']          = $this->data_volume;
		$this->info['year']            = $this->data_year;

		$this->info['source_org']      = $this->data_source_org;
		$this->info['source_prj']      = $this->data_source_prj;
		$this->info['source_url']      = $this->data_source_url;
	}

	/**
	 *	getAttributionSource - get sourcing info
	 */
	function getAttributionSource($hay)
	{
		$includePath = dirname(__FILE__) . '/';
		require_once($includePath . 'Attribution.php');

		static $findAttribution = null;
		
		if (!$findAttribution) {
			$findAttribution = new Attribution();
		}

		$source = $findAttribution->getAttributionSource($hay);
		
		return $source;
	}
	
	/**
	 *  loadPublicationTypes - get number values for word values of publication types
	 */
	function loadPublicationTypes()
	{
		static $biblioTypes = array();
		static $publicationTypes = null;
		
		if ($biblioTypes) {
			; // done
		} else {
			$includePath = dirname(__FILE__) . '/';
			require_once($includePath . 'PublicationTypes.php');

			$publicationTypes = new PublicationTypes();
			$biblioTypes = $publicationTypes->loadPublicationTypes();
		}
		
		return $biblioTypes;
	}

	/**
	 * filterLang - standardize the language value
	 */
	protected function filterLang($lang)
	{
		$lang = trim($lang);
		$language = $lang;

		// TODO: expand the list to be comprehensive
		// filter languages
		switch ($lang)
		{
			case 'en_US':
			case 'eng':
			case 'en':
				$language = 'English';
				break;

			case 'es':
				$language = 'Spanish';
				break;

			// en;es
			// en, es
			
			default:
				break;
		}
		
		return $language;
	}

	/**
	 * processHarvest - handle the data
	 */
	abstract public function processHarvest($record);

	
}  // end class
// ****************************************
// ****************************************
// ****************************************
