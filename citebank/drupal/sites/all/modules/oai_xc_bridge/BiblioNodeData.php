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
	public $data_place_published;
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

		$this->data_call_number      = '';
		$this->data_contributors     = '';
		$this->data_date             = '';
		$this->data_edition          = '';
		$this->data_isbn             = '';
		$this->data_issn             = '';
		$this->data_issue            = '';
		$this->data_keywords         = '';
		$this->data_lang             = '';
		$this->data_pages            = '';
		$this->data_place_published  = '';
		$this->data_publisher        = '';
		$this->data_secondary_title  = '';
		$this->data_section          = '';
		$this->data_title            = '';
		$this->data_type             = self::PUBLICATION_TYPE_BOOK;
		$this->data_url              = '';
		$this->data_volume           = '';
		$this->data_year             = self::DEFAULT_YEAR;

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
		$node['biblio_call_number']        = $this->data_call_number;
		$node['biblio_contributors']       = $this->data_contributors;
		$node['biblio_date']               = $this->data_date;
		$node['biblio_edition']            = $this->data_edition;
		$node['biblio_isbn']               = $this->data_isbn;
		$node['biblio_issn']               = $this->data_issn;
		$node['biblio_issue']              = $this->data_issue;
		$node['biblio_keywords']           = $this->data_keywords;
		$node['biblio_lang']               = $this->data_lang;
		$node['biblio_pages']              = $this->data_pages;
		$node['biblio_place_published']    = $this->data_place_published;
		$node['biblio_publisher']          = $this->data_publisher;
		$node['biblio_secondary_title']    = $this->data_secondary_title;
		$node['biblio_section']            = $this->data_section;
		$node['biblio_title']              = $this->data_title;
		$node['biblio_type']               = $this->data_type;
		$node['biblio_url']                = $this->data_url;
		$node['biblio_volume']             = $this->data_volume;
		$node['biblio_year']               = $this->data_year;

		$node['biblio_remote_db_provider'] = $this->data_source_org; // sourceOrg;
		$node['biblio_label']              = $this->data_source_prj; // sourcePrj;
		$node['biblio_remote_db_name']     = $this->data_source_url; // sourceUrl;

		
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
