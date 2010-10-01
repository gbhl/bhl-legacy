<?php
// $Id: DataHandlerMarcXmlController.php,v 1.0.0.0 2010/09/23 4:44:44 dlheskett $

/** DataHandlerMarcXmlController class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/23/2010
 *
 */

$includePath = dirname(__FILE__) . '/';
require_once($includePath . 'MarcBibliographicInterpreter.php');

/** 
 * class DataHandlerMarcXmlController - marc xml to biblio 
 * 
 */
class DataHandlerMarcXmlController extends DataHandlerModel
{
	public $datafields;
	public $leaderDecoded;
	public $recordPrime;
	
	const CLASS_NAME    = 'DataHandlerMarcXmlController';

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
	 * DataHandlerMarcXmlController - constructor
	 */
	function DataHandlerMarcXmlController()
	{
		return;
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Identifiers()
	{
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Title()
	{
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Publisher()
	{
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_DateYear()
	{
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Lang()
	{
		// BIBLIO_FIELD: lang
	  // Get the language
		$this->data_lang = $this->filterLang($this->data_lang);
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Authors()
	{
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Keywords()
	{
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

		if ($this->leaderDecoded['Material'] == 'Books') {
			$this->data_type = $biblioTypes['book'];
		}

		// journal?
		if ($this->leaderDecoded['Material'] == 'Continuing Resources') {
			$this->data_type = $biblioTypes['journal'];
		}
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_JournalTitle()
	{
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Edition()
	{
	}
	
	/**
	 * keywords - create a list of keywords from a sting such as a title
	 */
	private function keywords($title)
	{
		static $keywordsFilter = null;
		$includePath = dirname(__FILE__) . '/';
		require_once($includePath . 'Keywords.php');
		
		if (!$keywordsFilter) {
			$keywordsFilter = new Keywords();
		}

		$keywords = $keywordsFilter->keywords($title);
		
		return $keywords;
	}

	/**
	 * parseValueList - parse the data values
	 */
	protected function parseValueList()
	{
		foreach ($this->datafields as $datafield) {
			switch ($datafield['tag']) 
			{
/*
		$this->parseValue_Identifiers();

		$this->parseValue_Classification();
		$this->parseValue_JournalTitle();

		$this->parseValue_Edition();
		$this->parseValue_PublicationType();
		$this->parseValue_Title();
		$this->parseValue_Publisher();
		$this->parseValue_DateYear();
		$this->parseValue_Lang();
		$this->parseValue_Keywords();
		$this->parseValue_Authors();
*/

				// 100 author
				// 245 title
				// 250 edition
				// 260 date, year
				// 546 language
				// 653 keywords
				// 
				case 100:
				case 110:
				case 111:
				case 700:
				case 710:
				case 711:
				case 720:
					// author
					if ($datafield['code'] == 'a') {
						$auth_type = 1;	// match to row in table 'biblio_contributor_type_data'

						switch ($datafield['tag']) 
						{
							default:
							case 100:  // Personal Name
							case 700:  // Personal Name
								$auth_type = 1;//'personal'
								break;
								
							case 110:  // Corporate Name
							case 710:  // Corporate Name
								$auth_type = 5;//'corporate'
								break;
								
							case 111:  // Meeting Name
							case 711:  // Meeting Name
								$auth_type = 19; //'conference'
								break;
								
							case 720:  // Uncontrolled Name 
								$auth_type = 1;
								break;
						}

						$name = trim($datafield['val']);

						if (strlen($name) > 0) {
							if (substr_count($name, ';')) {
								$names = explode(';', $name);
								$name = $names[0];
							}

							$this->data_contributors[1][] = compact('name', 'auth_type');
						}
					}
					break;

				case 245:
					// title
					if ($datafield['code'] == 'a') {
						$title = trim($datafield['val']);
						$this->data_title = $title;
					}
					break;

				case 250:
					// edition
					if ($datafield['code'] == 'a') {
						$edition = trim($datafield['val']);
						$this->data_edition = $edition;
					}
					break;

				case 260:
					// publisher, date, year of publication
					if ($datafield['code'] == 'b') {
						$val = trim($datafield['val']);
						$this->data_publisher = $val;
					}
					if ($datafield['code'] == 'c') {
						$val = trim($datafield['val']);

					  $this->data_date = '';
					  $this->data_year = 9999;
						
						$this->data_date = $val;
						$this->data_year = substr($val, 0, 4);
					}
					break;

				case 546:
					// language
					if ($datafield['code'] == 'a') {
						$language = trim($datafield['val']);
						$this->data_lang = $this->filterLang($language);
					}
					break;

				case 653:
					// keywords
					if ($datafield['code'] == 'a') {
						$words = trim($datafield['val']);
						$this->data_keywords[] = explode(";", $words);
					}
					break;

				default:
					break;
			}
		}
	}

	/**
	 * processHarvest - handle the data
	 */
	function processHarvest($record)
	{
		$this->recordPrime = $record;
	  $raw = $record['metadata']['childNode'];
	  $this->record = $raw;

		$leader = $this->record->getElementsByTagName('leader')->item(0)->nodeValue;
		$i = new MarcBibliographicInterpreter();
		$this->leaderDecoded = $i->parseLeaderDecode($leader);

		$title = 'none';

		$this->datafields = array();
		$count = $this->record->getElementsByTagName('datafield')->length;
		
		for ($x = 0; $x < $count; $x++) {
			$val  = $this->record->getElementsByTagName('datafield')->item($x)->nodeValue;
			$tag  = $this->record->getElementsByTagName('datafield')->item($x)->getAttribute('tag');
			$in1  = $this->record->getElementsByTagName('datafield')->item($x)->getAttribute('ind1');
			$in2  = $this->record->getElementsByTagName('datafield')->item($x)->getAttribute('ind2');
			$code = $this->record->getElementsByTagName('subfield')->item($x)->getAttribute('code');

			$this->datafields[] = compact('val', 'tag', 'ind1', 'ind2', 'code');
		}
		
		$this->parseValueList();
		
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
