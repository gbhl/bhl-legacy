<?php
// $Id: BiblioNodeData.php,v 1.0.0.0 2010/09/15 4:44:44 dlheskett $

/**  BiblioNodeData class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/15/2010
 *
 */

/** 
 * class BiblioNodeData - biblio class object to hold data
 * 
 */
class BiblioNodeData
{
	/** stores the class name */
	public $className;

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
	
	const PUBLICATION_TYPE_BOOK    = 100;
	const DEFAULT_YEAR    = 9999;

	const CLASS_NAME    = 'BiblioNodeData';

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

		$this->data_abst_e               = '';
		$this->data_abst_f               = '';
		$this->data_access_date          = '';
		$this->data_accession_number     = '';
		$this->data_alternate_title      = '';
		$this->data_auth_address         = '';
		$this->data_call_number          = '';
		$this->data_citekey              = '';
		$this->data_coins                = '';
		$this->data_contributors         = '';
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
		$this->data_type                 = self::PUBLICATION_TYPE_BOOK;
		$this->data_type_of_work         = '';
		$this->data_url                  = '';
		$this->data_volume               = '';
		$this->data_year                 = self::DEFAULT_YEAR;

		$this->data_source_org       = '';
		$this->data_source_prj       = '';
		$this->data_source_url       = '';
	}
	
	/**
	 * _toString - stringify
	 */
	function __toString()
	{
		//$info = '';
		//$info .= $this->className;
		//$info .= '<br>';
		//$info .= "\n";
		//$info .= var_export($this, true);

		$info = '';

		$info .= ' ';
		$info .= 'Title: ';
		$info .= $this->data_title;

		$info .= ' ';
		$info .= 'Date: ';
		$info .= $this->data_date;

		$info .= ' ';
		$info .= 'Year: ';
		$info .= $this->data_year;

		$info .= ' ';
		$info .= 'Authors: ';

		foreach ($this->data_contributors as $author) {
			$info .= $author;
		}

		return $info;
	}
	
	/**
	 * processNode - handle the data
	 */
	function processNode($node)
	{
	  // Add the identifiers to the node
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
		$node['biblio_translated_title']     = $this->data_translated_title;
		$node['biblio_type']                 = $this->data_type;
		$node['biblio_type_of_work']         = $this->data_type_of_work;
		$node['biblio_url']                  = $this->data_url;
		$node['biblio_volume']               = $this->data_volume;
		$node['biblio_year']                 = $this->data_year;

		$node['biblio_remote_db_provider']   = $this->data_source_org; // sourceOrg;
		$node['biblio_label']                = $this->data_source_prj; // sourcePrj;
		$node['biblio_remote_db_name']       = $this->data_source_url; // sourceUrl;

		
		return $node;
	}

	/**
	 * process - handle the data
	 */
	function process($data)
	{
		$info = $this->processNode($data);
		return $info;
	}
	

}  // end class
// ****************************************
// ****************************************
// ****************************************
