<?php
// $Id: DataProcessorBiblio.php,v 1.0.0.0 2010/09/15 4:44:44 dlheskett $

/** DataProcessorBiblio class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/15/2010
 *
 */

$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'BiblioNodeData.php');

/** 
 * class DataProcessorBiblio - xFormat to biblio 
 * 
 */
class DataProcessorBiblio
{
	public $className;
	public $importData;
	public $biblioData;

	const CLASS_NAME    = 'DataProcessorBiblio';
	
	/**
	 * _construct - constructor
	 */
	function __construct($importData)
	{
		$this->importData = $importData;
		$this->biblioData = new DataProcessor_BiblioNodeData();

		$this->initDefaults();
	}

	/**
	 * initDefaults - set defaults
	 */
	function initDefaults()
	{
		$this->className = self::CLASS_NAME;
		$this->importData->initDefaults();
		$this->biblioData->initDefaults();
	}

	/**
	 * assignData - map data from import into biblio data
	 */
	function assignData()
	{
		// assign the data (map data to Biblio)
		$this->biblioData->data_abst_e                 = $this->importData->data_abst_e;
		$this->biblioData->data_abst_f                 = $this->importData->data_abst_f;
		$this->biblioData->data_access_date            = $this->importData->data_access_date;
		$this->biblioData->data_accession_number       = $this->importData->data_accession_number;
		$this->biblioData->data_alternate_title        = $this->importData->data_alternate_title;
		$this->biblioData->data_auth_address           = $this->importData->data_auth_address;
		$this->biblioData->data_call_number            = $this->importData->data_call_number;
		$this->biblioData->data_citekey                = $this->importData->data_citekey;
		$this->biblioData->data_coins                  = $this->importData->data_coins;
		$this->biblioData->data_contributors           = $this->importData->data_contributors;
		$this->biblioData->data_custom1                = $this->importData->data_custom1;
		$this->biblioData->data_custom2                = $this->importData->data_custom2;
		$this->biblioData->data_custom3                = $this->importData->data_custom3;
		$this->biblioData->data_custom4                = $this->importData->data_custom4;
		$this->biblioData->data_custom5                = $this->importData->data_custom5;
		$this->biblioData->data_custom6                = $this->importData->data_custom6;
		$this->biblioData->data_custom7                = $this->importData->data_custom7;
		$this->biblioData->data_date                   = $this->importData->data_date;
		$this->biblioData->data_doi                    = $this->importData->data_doi;
		$this->biblioData->data_edition                = $this->importData->data_edition;
		$this->biblioData->data_full_text              = $this->importData->data_full_text;
		$this->biblioData->data_isbn                   = $this->importData->data_isbn;
		$this->biblioData->data_issn                   = $this->importData->data_issn;
		$this->biblioData->data_issue                  = $this->importData->data_issue;
		$this->biblioData->data_keywords               = $this->importData->data_keywords;
		//$this->biblioData->data_label                  = $this->importData->data_label;
		$this->biblioData->data_lang                   = $this->importData->data_lang;
		$this->biblioData->data_notes                  = $this->importData->data_notes;
		$this->biblioData->data_number                 = $this->importData->data_number;
		$this->biblioData->data_number_of_volumes      = $this->importData->data_number_of_volumes;
		$this->biblioData->data_original_publication   = $this->importData->data_original_publication;
		$this->biblioData->data_other_number           = $this->importData->data_other_number;
		$this->biblioData->data_pages                  = $this->importData->data_pages;
		$this->biblioData->data_place_published        = $this->importData->data_place_published;
		$this->biblioData->data_publisher              = $this->importData->data_publisher;
		$this->biblioData->data_refereed               = $this->importData->data_refereed;
		//$this->biblioData->data_remote_db_name         = $this->importData->data_remote_db_name;
		//$this->biblioData->data_remote_db_provider     = $this->importData->data_remote_db_provider;
		$this->biblioData->data_reprint_edition        = $this->importData->data_reprint_edition;
		$this->biblioData->data_research_notes         = $this->importData->data_research_notes;
		$this->biblioData->data_secondary_title        = $this->importData->data_secondary_title;
		$this->biblioData->data_section                = $this->importData->data_section;
		$this->biblioData->data_short_title            = $this->importData->data_short_title;
		$this->biblioData->data_tertiary_title         = $this->importData->data_tertiary_title;
		$this->biblioData->data_title                  = $this->importData->data_title;
		$this->biblioData->data_translated_title       = $this->importData->data_translated_title;
		$this->biblioData->data_type                   = $this->importData->data_type;
		$this->biblioData->data_type_of_work           = $this->importData->data_type_of_work;
		$this->biblioData->data_url                    = $this->importData->data_url;
		$this->biblioData->data_volume                 = $this->importData->data_volume;
		$this->biblioData->data_year                   = $this->importData->data_year;
                           
		// source Org, Prj, Url
		$this->biblioData->data_source_org      = $this->importData->data_source_org;
		$this->biblioData->data_source_prj      = $this->importData->data_source_prj;
		$this->biblioData->data_source_url      = $this->importData->data_source_url;
	}

	/**
	 * process - import, parse, store data
	 */
	function processHarvestNode($data, $node)
	{
		// parse the data
		$this->importData->processHarvest($data);
		
		// assign the data (map Mods to Biblio)
		$this->assignData();

		// format the data
		$biblioProcessedData = $this->biblioData->processNode($node);	

		// give it back
		return $biblioProcessedData;
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
