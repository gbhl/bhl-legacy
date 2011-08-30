<?php
// $Id: DataHandlerModsController.php,v 1.0.0.0 2010/09/15 4:44:44 dlheskett $

/** DataHandlerModsController class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/15/2010
 *
 */

$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'DataHandlerModel.php');
//require_once($includePath . 'RightsModel.php');

/** 
 * class DataHandlerModsController - mods to biblio 
 * 
 */
class DataHandlerModsController extends DataHandlerModel
{

	const CLASS_NAME    = 'DataHandlerModsController';


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
	  $identifiers = $this->xpath->query('/x:mods/x:identifier');
	
	  foreach ($identifiers as $identifier) {
	
			if ($identifier->hasAttribute('type')) {
	
				switch ($identifier->getAttribute('type'))
				{
					case 'uri':
						$this->data_url = $identifier->nodeValue;
						break;
	
					case 'isbn':
						$this->data_isbn = $identifier->nodeValue;
						break;
	
					case 'issn':
						$this->data_issn = $identifier->nodeValue;
						break;
				}			
			}
	  }  

	  // See if there is a 'url' element (let this take precedence over any 'uri' identifiers)
	  $urls = $this->xpath->query('/x:mods/x:location/x:url');
	
	  if ($urls->length > 0) {
			$this->data_url = $urls->item(0)->nodeValue;
	  }  
	  
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Title()
	{
	  // Get the title information
	  $titleInfoList = $this->xpath->query('/x:mods/x:titleInfo');

		// BIBLIO_FIELD_TOPIC: Journal Title
		// BIBLIO_FIELD: title
	  foreach ($titleInfoList as $titleInfo) {
			// Only use titles that apply to MARC 245a/b/n/p by ignoring any with the 'type' attribute
	
			if (!$titleInfo->hasAttribute('type')) {
				$this->data_title = '';
				$nonSort = $titleInfo->getElementsByTagName('nonSort');
				
				if ($nonSort->length > 0) {
					$this->data_title = $nonSort->item(0)->nodeValue . ' ';
				}
				
				$title = $titleInfo->getElementsByTagName('title');
				
				if ($title->length > 0) {
					$this->data_title = $this->data_title . $title->item(0)->nodeValue;
				}
				
				$subTitle = $titleInfo->getElementsByTagName('subTitle');
				
				if ($subTitle->length > 0) {
					$this->data_title = $this->data_title . ' ' . $subTitle->item(0)->nodeValue;
				}
			} else {
				// has attribute type
				/* 
					new types:
					
					translated
					abbreviated
					alternative
					uniform
					
					caveats, it is possible to have multiple alternative titles, and possibly some of the other types as well.
					   we are just going to only be able to handle only ONE of each.

						no type      maps to: data_title             (node title)
						translated   maps to: data_translated_title  (biblio_translated_title)
						abbreviated  maps to: data_short_title       (biblio_short_title)
						alternative  maps to: data_alternate_title   (biblio_alternate_title)
						uniform      maps to: data_secondary_title   (biblio_secondary_title)
						
						No real match on ‘uniform’ in biblio, so secondary is just a remaining likely slot.

				*/

				$type = $titleInfo->hasAttribute('type');
				$title = $titleInfo->getElementsByTagName('title');
				
				switch ($type)
				{
					case 'translated':
						if (!$this->data_translated_title) {
							$this->data_translated_title = $title;
						}
						break;

					case 'abbreviated':
						if (!$this->data_short_title) {
							$this->data_short_title = $title;
						}
						break;

					case 'alternative':
						if (!$this->data_alternate_title) {
							$this->data_alternate_title = $title;
						}
						break;

					case 'uniform':
						if (!$this->data_secondary_title) {
							$this->data_secondary_title = $title;
						}
						break;

					default:
						break;
				}
	  
				
			}
	  }
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
	  $originInfo = $this->xpath->query('/x:mods/x:originInfo');
	
	  foreach ($originInfo as $origin) {
	  	$this->data_place_published = '';
			$places = $origin->getElementsByTagName('place');
			
			foreach ($places as $place) {
				$placeTerm = $place->getElementsByTagName('placeTerm')->item(0);
	
				if ($placeTerm->getAttribute('type') == 'text') {
					$this->data_place_published = $placeTerm->nodeValue;
					break;
				}
			}
			
			$this->data_publisher = $origin->getElementsByTagName('publisher')->item(0)->nodeValue;
	  }
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_DateYear()
	{
	  $this->data_year = 9999;
	  $this->data_date = '';

		// BIBLIO_FIELD_TOPIC: Date Published
		// BIBLIO_FIELD_TOPIC: Year of Publication
		// BIBLIO_FIELD: year
		// BIBLIO_FIELD: date
	  $dates = $this->xpath->query('/x:mods/x:originInfo/x:dateIssued');
	
	  if ($dates->length > 0) {
			//$dates = $origin->getElementsByTagName('dateIssued');
	
			foreach ($dates as $date) {
	
				if (!$date->hasAttribute('encoding')) {
					$this->data_date = $date->nodeValue;
				} elseif ($date->getAttribute('encoding') == 'iso8601') {
					$this->data_date = $date->nodeValue;
				} elseif ($date->getAttribute('encoding') == 'marc') {
	
					if (!$date->hasAttribute('point')) {
						$this->data_year = $date->nodeValue;
					} elseif ($date->getAttribute('point') == 'start') {
						$this->data_year = $date->nodeValue;
					}
				}		
			}
	  }
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Lang()
	{
		// BIBLIO_FIELD: lang
	  // Get the language
	  $languageElement = $this->xpath->query('/x:mods/x:language');
	
	  if ($languageElement->length > 0) {
			$languageTerms = $languageElement->item(0)->getElementsByTagName('languageTerm');
		
			if ($languageTerms->length > 0) {
				$this->data_lang = $languageTerms->item(0)->nodeValue;
			}
		}  

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
	  $this->data_contributors = array();
	  $names = $this->xpath->query('/x:mods/x:name');
	
	  foreach($names as $name) {
			// get the type of author
			$auth_type = 1;	// match to row in table 'biblio_contributor_type_data'
	
			if ($name->hasAttribute('type')) {
				
				switch ($name->getAttribute('type')) 
				{
					case 'personal':
						$auth_type = 1;
						break;
					
					case 'corporate':
						$auth_type = 5;
						break;
					
					case 'conference':
						$auth_type = 19;
						break;		
				}
			}
		
			// get the name of the author
			$nameParts  = $name->getElementsByTagName('namePart');
			$authorName = '';
			$given      = '';
			$family     = '';
			$authorDate = '';
	
			foreach ($nameParts as $namePart) {
	
				if (!$namePart->hasAttribute('type')) {
					$authorName = $namePart->nodeValue;
					break;
				} else {
					
					switch($namePart->getAttribute('type'))
					{
						case 'given':
							$given = $namePart->nodeValue;
							break;
	
						case 'family':
							$family = $namePart->nodeValue;
							break;
	
						case 'date':
							$authorDate = $namePart->nodeValue;
							break;			
					}
				}	
			} 
			
			if ($authorName == '') {
				$authorName = $family . ', ' . $given . ' ' . $authorDate;
			}
			
			// add the author to the node
	    $this->data_contributors[1][] = array('name' => $authorName, 'auth_type' => $auth_type);
	  }  
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Keywords()
	{
		// BIBLIO_FIELD_TOPIC: Keywords
		// BIBLIO_FIELD: keywords
	  // Get the subjects (keywords)
	  $this->data_keywords = array();
	  $subjects = $this->xpath->query('/x:mods/x:subject');
	
	  foreach ($subjects as $subject) {
			$topics = $subject->getElementsByTagName('topic');
			
			foreach ($topics as $topic) {
				$this->data_keywords[] = $topic->nodeValue;
			}
	
			$names = $subject->getElementsByTagName('name');
	
			foreach ($names as $name) {
				$this->data_keywords[] = $name->nodeValue;
			}
	
			$geographics = $subject->getElementsByTagName('geographic');
	
			foreach ($geographics as $geographic) {
				$this->data_keywords[] = $geographic->nodeValue;
			}
	  }  
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Classification()
	{
		// BIBLIO_FIELD: call_number (classification)
	  // Look for a call number in the item's classification entries
	  $classifications = $this->xpath->query('/x:mods/x:classification');
	
	  foreach ($classifications as $classification) {
	
			if ($classification->hasAttribute('authority')) {
	
				if ($classification->getAttribute('authority') == 'lcc') {
					$this->data_call_number = $classification->nodeValue;
					break;
				}			
			}
	  }  
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_PublicationType()
	{
		// BIBLIO_FIELD_TOPIC: Publication Type
		// BIBLIO_FIELD: type (book, article, journal)
	  // Identify the type of item
	  $genres = $this->xpath->query('/x:mods/x:genre');
	
		// this should do a one time load of the types from the database
		$biblioTypes = $this->loadPublicationTypes();
		
	  if ($genres->length > 0) {
			$pubTypeName = strtolower($genres->item(0)->nodeValue);
			
			// find the number code for the publication type, if none, default to what a book value is.
			$typeName = (isset($pubTypeName) ? $pubTypeName : 'book');
			$typeCode = (isset($biblioTypes[$typeName]) ? $biblioTypes[$typeName] :  $biblioTypes['book']);
			$this->data_type = $typeCode;
			// note: biblio.biblio_type = biblio_types.tid  see biblio.install  _add_publication_types()
		}
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_JournalTitle()
	{
		$biblioTypes = $this->loadPublicationTypes();
		
		// BIBLIO_FIELD_TOPIC: Journal Title
		// articles
		// BIBLIO_FIELD: secondary_title
		// BIBLIO_FIELD: volume
		// BIBLIO_FIELD: issue
		// BIBLIO_FIELD: section
		// BIBLIO_FIELD: pages
		// BIBLIO_FIELD: year
	  // Check for page and volume information for journals
	  $relatedItems = $this->xpath->query('/x:mods/x:relatedItem');
	
	  foreach ($relatedItems as $relatedItem) {
	
			// added per request 2011 08 30
			if (($relatedItem->getAttribute('type') == 'series' || $relatedItem->getAttribute('type') == 'host') && $this->data_type == $biblioTypes['article']) {
			//if ($relatedItem->getAttribute('type') == 'host' && $this->data_type == $biblioTypes['article']) {
				// Get journal title
				$journalTitleInfo = $relatedItem->getElementsByTagName('titleInfo');
	
				if ($journalTitleInfo->length > 0) {
					//$this->data_secondary_title = $journalTitleInfo->item(0)->getElementsByTagName('title')->item(0)->nodeValue;	 // changed per request 2011 08 30
					$this->data_original_publication = $journalTitleInfo->item(0)->getElementsByTagName('title')->item(0)->nodeValue;
				}
			
				// Get volume/issue/pages
				$parts = $relatedItem->getElementsByTagName('part');
	
				if ($parts->length > 0) {
					$part = $parts->item(0);
					
					$details = $part->getElementsByTagName('detail');
					$text = $part->getElementsByTagName('text');
	
					if ($details->length > 0) {
	
						foreach ($details as $detail) {
							$number = $detail->getElementsByTagName('number')->item(0)->nodeValue;
							
							if (!empty($number)) {
	
								switch($detail->getAttribute('type'))
								{
									case 'volume':
										$this->data_volume = $number;
										break;
	
									case 'issue':
										$this->data_issue = $number;
										break;
								}
							}
						}
					} else {
						$this->data_volume = $text->item(0)->nodeValue;
					}
					
					$extents = $part->getElementsByTagName('extent');
	
					if ($extents->length > 0) {
						$this->data_section = $extents->item(0)->getElementsByTagName('start')->item(0)->nodeValue;
						$this->data_pages = $extents->item(0)->getElementsByTagName('list')->item(0)->nodeValue;
					}
					
					$partDates = $part->getElementsByTagName('date');
					if ($partDates->length > 0) {
						$this->data_year = $partDates->item(0)->nodeValue;
					}
				}
			}
	  }
	}
	
	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Rights()
	{
		$accessConditionData = '';
		//$accessConditionType = '';
		
	  $mods = $this->xpath->query('/x:mods');

	  if (count($mods)) {
		  foreach ($mods as $mod) {

		  	$rightsTag = $mod->getElementsByTagName('accessCondition');

		  	$accessConditionData .= $rightsTag->item(0)->nodeValue;

		  	break; // there is only one in a given record that we are working with
			}
		}

		//$type = 'Mods';
		//$msg = 'rights: ' . $accessConditionType . ' [' . $accessConditionData . ']';
		//watchdog($type, $msg); 

		$this->data_custom2 = $accessConditionData;
	}

	/**
	 * parseValue_ - parse the data values
	 */
	protected function parseValue_Edition()
	{
		$biblioTypes = $this->loadPublicationTypes();
		
		// BIBLIO_FIELD_TOPIC: Edition
		// BIBLIO_FIELD: Edition:  originInfo   edition
	  $bookEditionItems = $this->xpath->query('/x:mods/x:originInfo');
	  $articleEditionItems = $this->xpath->query('/x:mods/x:classificationType');
	  
		// look for book or article edition (article may be on a different branch, a second originInfo)
	  switch($this->data_type) 
	  {
	  	case $biblioTypes['book']:
	  	default:
	  		$editionItems = $bookEditionItems;
	  		break;
	
	  	case $biblioTypes['article']:
	  		$editionItems = $articleEditionItems;
	  		break;
	  }
	
		$editionInfo = '';
		$this->data_edition = '';
		
		// extract the edition info
		if (count($editionItems > 0)) {
			foreach ($editionItems as $editionItem) {
				$editionInfo = $editionItem->getElementsByTagName('edition')->item(0)->nodeValue;
				break;
			}
		}
		
		$this->data_edition = $editionInfo;
	}
	
	/**
	 * processHarvest - handle the data
	 */
	function processHarvest($record)
	{
		$this->record = $record;

	  $raw = $record['metadata']['childNode'];

	  // Set up an XPath document
	  $doc = new DOMDocument;
	  $doc->appendChild($doc->importNode($raw, true));
	  $xpath = new DOMXPath($doc);
	  $xpath->registerNamespace('x', 'http://www.loc.gov/mods/v3');

		$this->xpath = $xpath;

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

		// BIBLIO_FIELD: custom_field2   accessCondition   useAndReproduction
		$this->parseValue_Rights();

		return $this->info;
	}

	
}  // end class
// ****************************************
// ****************************************
// ****************************************
