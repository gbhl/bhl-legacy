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
	public $data_abst_e;
	public $data_abst_f;
	public $data_access_date;
	public $data_accession_number;
	public $data_alternate_title;
	public $data_auth_address;
	public $data_call_number;
	public $data_citekey;
	public $data_coins;
	public $data_contributors;
	public $data_custom1;
	public $data_custom2;
	public $data_custom3;
	public $data_custom4;
	public $data_custom5;
	public $data_custom6;
	public $data_custom7;
	public $data_date;
	public $data_doi;
	public $data_edition;
	public $data_full_text;
	public $data_isbn;
	public $data_issn;
	public $data_issue;
	public $data_keywords;
	//public $data_label;
	public $data_lang;
	public $data_notes;
	public $data_number;
	public $data_number_of_volumes;
	public $data_original_publication;
	public $data_other_number;
	public $data_pages;
	public $data_place_published;
	public $data_publisher;
	public $data_refereed;
	//public $data_remote_db_name;
	//public $data_remote_db_provider;
	public $data_reprint_edition;
	public $data_research_notes;
	public $data_secondary_title;
	public $data_section;
	public $data_short_title;
	public $data_tertiary_title;
	public $data_title;
	public $data_translated_title;
	public $data_type;
	public $data_type_of_work;
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

		$this->data_abst_e               = '';
		$this->data_abst_f               = '';
		$this->data_access_date          = '';
		$this->data_accession_number     = '';
		$this->data_alternate_title      = '';
		$this->data_auth_address         = '';
		$this->data_call_number          = '';
		$this->data_citekey              = '';
		$this->data_coins                = '';
		$this->data_contributors         = array();
		$this->data_custom1              = '';
		$this->data_custom2              = '';
		$this->data_custom3              = '';
		$this->data_custom4              = '';
		$this->data_custom5              = '';
		$this->data_custom6              = '';
		$this->data_custom7              = '';
		$this->data_date                 = '';
		$this->data_doi                  = '';
		$this->data_edition              = '';
		$this->data_full_text            = '';
		$this->data_isbn                 = '';
		$this->data_issn                 = '';
		$this->data_issue                = '';
		$this->data_keywords             = '';
		//$this->data_label                = '';
		$this->data_lang                 = '';
		$this->data_notes                = '';
		$this->data_number               = '';
		$this->data_number_of_volumes    = '';
		$this->data_original_publication = '';
		$this->data_other_number         = '';
		$this->data_pages                = '';
		$this->data_place_published      = '';
		$this->data_publisher            = '';
		$this->data_refereed             = '';
		//$this->data_remote_db_name       = '';
		//$this->data_remote_db_provider   = '';
		$this->data_reprint_edition      = '';
		$this->data_research_notes       = '';
		$this->data_secondary_title      = '';
		$this->data_section              = '';
		$this->data_short_title          = '';
		$this->data_tertiary_title       = '';
		$this->data_title                = '';
		$this->data_translated_title     = '';
		$this->data_type                 = '';
		$this->data_type_of_work         = '';
		$this->data_url                  = '';
		$this->data_volume               = '';
		$this->data_year                 = '';

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

	/*
	http://www.loc.gov/marc/languages/language_code.html
	http://www.i18nguy.com/unicode/language-identifiers.html
	http://www.loc.gov/standards/iso639-2/php/code_list.php
	?? Multiple
	
	ca Catalan
	zh Chinese
	hr Croation
	cs Czech
	da Danish
	nl Dutch
	en English
	fi Finnish
	fr French
	de German
	gu Gujarati
	hu Hungarian
	id Indonesian
	it Italian
	ja Japanese
	la Latin
	nl Dutch
	no Norwegian
	pl Polish
	pt Portugese 
	ro Romanian
	ru Russian
	es Spanish
	sv Swedish

	cat  Catalan
	chi  Chinese
	hrv  Croation
	cze  Czech
	dan  Danish
	dut  Dutch
	nid  Dutch
	eng  English
	fin  Finnish
	fre  French
	fra  French
	ger  German
	guj  Gujarati
	hun  Hungarian
	ind  Indonesian
	ita  Italian
	jpn  Japanese
	lat  Latin
	nor  Norwegian
	pol  Polish
	por  Portugese 
	rum  Romanian
	ron  Romanian
	rup  Romanian
	rus  Russian
	spa  Spanish
	swe  Swedish
	*/			

	/**
	 * filterLang - standardize the language value
	 */
	protected function filterLang($lang)
	{
		$lang = strtolower(trim($lang));
		$language = $lang;

		// filter languages
		switch ($lang)
		{
			case 'ca':
			case 'cat':
				$language = 'Catalan';
				break;

			case 'zh':
			case 'chi':
			case 'zho':
				$language = 'Chinese';
				break;

			case 'hr':
			case 'hrv':
				$language = 'Croation';
				break;

			case 'cs':
			case 'cze':
				$language = 'Czech';
				break;

			case 'da':
			case 'dan':
				$language = 'Danish';
				break;

			case 'nl':
			case 'dut':
			case 'nid':
				$language = 'Dutch';
				break;

			case 'en_US':
			case 'eng':
			case 'en':
				$language = 'English';
				break;

			case 'fi':
			case 'fin':
				$language = 'Finnish';
				break;

			case 'fr':
			case 'fre':
			case 'fra':
				$language = 'French';
				break;

			case 'de':
			case 'ger':
				$language = 'German';
				break;

			case 'gu':
			case 'guj':
				$language = 'Gujarati';
				break;

			case 'hu':
			case 'hun':
				$language = 'Hungarian';
				break;

			case 'id':
			case 'ind':
				$language = 'Indonesian';
				break;

			case 'it':
			case 'ita':
				$language = 'Italian';
				break;

			case 'ja':
			case 'jpn':
				$language = 'Japanese';
				break;

			case 'la':
			case 'lat':
				$language = 'Latin';
				break;

			case 'no':
			case 'nor':
				$language = 'Norwegian';
				break;

			case 'pl':
			case 'pol':
				$language = 'Polish';
				break;

			case 'pt':
			case 'por':
				$language = 'Portuese';
				break;

			case 'ro':
			case 'rum':
			case 'ron':
			case 'rup':
				$language = 'Romanian';
				break;

			case 'ru':
			case 'rus':
				$language = 'Russian';
				break;

			case 'es':
			case 'spa':
				$language = 'Spanish';
				break;

			case 'sv':
			case 'swe':
				$language = 'Swedish';
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
