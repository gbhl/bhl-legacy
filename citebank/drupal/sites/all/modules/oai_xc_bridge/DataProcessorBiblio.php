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

require_once($includePath . 'DataHandlerModel.php');

require_once($includePath . 'DataHandlerModsController.php');
require_once($includePath . 'DataHandlerDublinCoreController.php');
require_once($includePath . 'DataHandlerMarcXmlController.php');

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
	
	const FORMAT_STANDARD    = 1000;
	const FORMAT_MODSXML     = 1001;
	const FORMAT_MODSSTD     = 1002;
	const FORMAT_MODSXPT     = 1003;
	const FORMAT_DUBLINCORE  = 1004;
	const FORMAT_MARCXML     = 1005;
	
	/**
	 * _construct - constructor
	 */
	function __construct($format = self::FORMAT_MODSSTD)
	{
		switch ($format)
		{
			case self::FORMAT_DUBLINCORE:
				$this->importData = new DataHandlerDublinCoreController();
				break;

			case self::FORMAT_MARCXML:
				$this->importData = new DataHandlerMarcXmlController();
				break;

			default:
			case self::FORMAT_MODSSTD:
			case self::FORMAT_MODSXPT:
				$this->importData = new DataHandlerModsController();
				break;
		}

		$this->biblioData = new BiblioNodeData();

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
		// assign the data (map Mods to Biblio)
		$this->biblioData->data_call_number     = $this->importData->data_call_number;
		$this->biblioData->data_contributors    = $this->importData->data_contributors;
		$this->biblioData->data_date            = $this->importData->data_date;
		$this->biblioData->data_edition         = $this->importData->data_edition;
		$this->biblioData->data_isbn            = $this->importData->data_isbn;
		$this->biblioData->data_issn            = $this->importData->data_issn;
		$this->biblioData->data_issue           = $this->importData->data_issue;
		$this->biblioData->data_lang            = $this->importData->data_lang;
		$this->biblioData->data_keywords        = $this->importData->data_keywords;
		$this->biblioData->data_pages           = $this->importData->data_pages;
		$this->biblioData->data_place_published = $this->importData->data_place_published;
		$this->biblioData->data_publisher       = $this->importData->data_publisher;
		$this->biblioData->data_secondary_title = $this->importData->data_secondary_title;
		$this->biblioData->data_section         = $this->importData->data_section;
		$this->biblioData->data_title           = $this->importData->data_title;
		$this->biblioData->data_type            = $this->importData->data_type;
		$this->biblioData->data_url             = $this->importData->data_url;
		$this->biblioData->data_volume          = $this->importData->data_volume;
		$this->biblioData->data_year            = $this->importData->data_year;

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
		$importDataProcessedData = $this->importData->processHarvest($data);
		
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
