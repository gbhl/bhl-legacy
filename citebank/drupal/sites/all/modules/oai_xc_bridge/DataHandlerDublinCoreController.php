<?php
// $Id: DataHandlerDublinCoreController.php,v 1.0.0.0 2010/09/15 4:44:44 dlheskett $

/** DataHandlerDublinCoreController class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/15/2010
 *
 */

/** 
 * class DataHandlerDublinCoreController - mods to biblio 
 * 
 */
class DataHandlerDublinCoreController extends DataHandlerModel
{

	const CLASS_NAME    = 'DataHandlerDublinCoreController';

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
	protected function parseValue_Identifiers()
	{
	  // Get the unique URL (identifier) for the item
	  $identifiers = $this->record->getElementsByTagName('identifier');
		$this->data_url = '';
		
	  if (count($identifiers)) {
		  foreach ($identifiers as $identifier) {
		  	$url = $identifier->nodeValue;

				if (filter_var($url, FILTER_VALIDATE_URL)) {
					$this->data_url = $url;
					break;
				}
		  }  
		}
	
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Title()
	{
	  // Get the title information
	  $this->data_title = $this->record->getElementsByTagName('title')->item(0)->nodeValue;
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Publisher()
	{
		// BIBLIO_FIELD_TOPIC: Publisher
		// BIBLIO_FIELD: place_published
		// BIBLIO_FIELD: publisher
	  // Get the publishing information
		$this->data_publisher = $this->record->getElementsByTagName('publisher')->item(0)->nodeValue;
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_DateYear()
	{
	  $this->data_year = 9999;
	  $this->data_date = '';
	  $this->data_year = $this->record->getElementsByTagName('date')->item(0)->nodeValue;

		// BIBLIO_FIELD_TOPIC: Date Published
		// BIBLIO_FIELD_TOPIC: Year of Publication
		// BIBLIO_FIELD: year
		// BIBLIO_FIELD: date
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Lang()
	{
		// BIBLIO_FIELD: lang
	  // Get the language
	  $this->data_lang = $this->record->getElementsByTagName('language')->item(0)->nodeValue;
	  
	  $this->data_lang = $this->filterLang($this->data_lang);
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Authors()
	{
		// BIBLIO_FIELD_TOPIC: Authors
		// BIBLIO_FIELD_TOPIC: Secondary Authors
		// BIBLIO_FIELD: contributors, authors
	  // Get the authors
	  //$this->data_contributors = '';
	  //$this->data_contributors = array();
		$auth_type = 1;	// match to row in table 'biblio_contributor_type_data'

	  $creators = $this->record->getElementsByTagName('creator');
	  $contributors = $this->record->getElementsByTagName('contributor');
	  
	  $creators = ($creators ? $creators : $contributors);
		$authorName = '';
	
	  if (count($creators)) {
		  foreach ($creators as $creator) {
		  	$authorName = ($creator->nodeValue ? $creator->nodeValue : '');
				
		  	if ($authorName) {
		  		if (substr_count($authorName, ';')) {
		  			$authorNames = explode(';', $authorName);
		  			$authorName = $authorNames[0];
		  		}

		    	$name = $authorName;
		    	//$this->data_contributors[1][] = array('name' => $authorName, 'auth_type' => $auth_type);
		    	$this->data_contributors[1][] = compact('name', 'auth_type');
		    	//log_info('Author', $authorName . ' [' . print_r($this->data_contributors, true) . ']');
		    }
		  }
		}
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Keywords()
	{
	  $subjects = $this->record->getElementsByTagName('subject');
	  $this->data_keywords = array();
	
	  if (count($subjects)) {
		  foreach ($subjects as $subject) {
				$keywords = explode(";", $subject->nodeValue);
		
				if (count($keywords)) {
					foreach ($keywords as $keyword) {
						$this->data_keywords[] = $keyword;
					}
				}
		  }
		}
		// BIBLIO_FIELD_TOPIC: Keywords
		// BIBLIO_FIELD: keywords
	  // Get the subjects (keywords)
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Classification()
	{
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_PublicationType()
	{
		// BIBLIO_FIELD_TOPIC: Publication Type
		// BIBLIO_FIELD: type (book, article, journal)
	  // Identify the type of item

		$biblioTypes = $this->loadPublicationTypes();
  	$this->data_type = $biblioTypes['book'];	// default to "Book" and change if otherwise

	  // Check whether one of the types specific in the OAI feed match a Biblio Type
	  $types = $this->record->getElementsByTagName('type');
	
	  if (count($types)) {
		  foreach ($types as $type) {
		  	// if find a type, assign it, and done
		  	if ($this->data_type = biblio_oai_xc_gettypeid($type->nodeValue)) {
					break;
				}
		  }
		}
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_JournalTitle()
	{
		// BIBLIO_FIELD_TOPIC: Journal Title
		// articles
		// BIBLIO_FIELD: secondary_title
		// BIBLIO_FIELD: volume
		// BIBLIO_FIELD: issue
		// BIBLIO_FIELD: section
		// BIBLIO_FIELD: pages
		// BIBLIO_FIELD: year
	  // Check for page and volume information for journals
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Edition()
	{
		// BIBLIO_FIELD_TOPIC: Edition
		// BIBLIO_FIELD: Edition:  originInfo   edition
	}
	
	/**
	 * processHarvest - handle the data
	 */
	function processHarvest($record)
	{
		//$this->record = $record;

	  $raw = $record['metadata']['childNode'];
	  $this->record = $raw;

		// Attribution
		$id = $record['header']['identifier'];
		$biblio_source    =  $this->getAttributionSource($id);
		$this->data_source_org = $biblio_source['org'];
		$this->data_source_prj = $biblio_source['prj'];
		$this->data_source_url = $biblio_source['url'];

		// get 
		//  url
		//  isbn
		//  issn
		$this->parseValue_Identifiers();
		
		// BIBLIO_FIELD_TOPIC: Journal Title
		// BIBLIO_FIELD: title
		$this->parseValue_Title();

		// BIBLIO_FIELD_TOPIC: Publisher
		// BIBLIO_FIELD: place_published
		// BIBLIO_FIELD: publisher
	  // Get the publishing information
		$this->parseValue_Publisher();

	  // Get the date information
		// BIBLIO_FIELD_TOPIC: Date Published
		// BIBLIO_FIELD_TOPIC: Year of Publication
		// BIBLIO_FIELD: year
		// BIBLIO_FIELD: date
		$this->parseValue_DateYear();
	  
		// BIBLIO_FIELD: lang
	  // Get the language
		$this->parseValue_Lang();
	
		// BIBLIO_FIELD_TOPIC: Authors
		// BIBLIO_FIELD_TOPIC: Secondary Authors
		// BIBLIO_FIELD: contributors, authors
	  // Get the authors
		$this->parseValue_Authors();

		// BIBLIO_FIELD_TOPIC: Keywords
		// BIBLIO_FIELD: keywords
	  // Get the subjects (keywords)
		$this->parseValue_Keywords();
	  
		// BIBLIO_FIELD: call_number (classification)
	  // Look for a call number in the item's classification entries
		$this->parseValue_Classification();

		// BIBLIO_FIELD_TOPIC: Publication Type
		// BIBLIO_FIELD: type (book, article, journal)
	  // Identify the type of item
		$this->parseValue_PublicationType();
	  
		// BIBLIO_FIELD_TOPIC: Journal Title
		// articles
		// BIBLIO_FIELD: secondary_title
		// BIBLIO_FIELD: volume
		// BIBLIO_FIELD: issue
		// BIBLIO_FIELD: section
		// BIBLIO_FIELD: pages
		// BIBLIO_FIELD: year
	  // Check for page and volume information for journals
		$this->parseValue_JournalTitle();
	
		// BIBLIO_FIELD_TOPIC: Edition
		// BIBLIO_FIELD: Edition:  originInfo   edition
		$this->parseValue_Edition();

		$this->makeInfo();
		
		return $this->info;
	}

	
}  // end class
// ****************************************
// ****************************************
// ****************************************


?>
