<?php
// $Id: RightsModel.php,v 1.0.0.0 2011/04/28 4:44:44 dlheskett $

/** RightsModel class
 *
 * Copyright (c) 2010-2011 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 04/28/2011
 *
 */
 
if (!class_exists('RightsModel')) {  // fixes issue with Drupal not adhereing to the require_once declaration

//$includePath = dirname(__FILE__) . '/';
//require_once($includePath . 'Controller.php');

/** 
 * class RightsModel - handle data, format, communicate with Internet Archive, to place records there, both metadata and files.
 * 
 */
class RightsModel
{
	public $className;

  public $status;         // public domain, 'in copyright', unknown or blank
  public $licenseName;
  public $licenseUrl;
  public $statement;
  public $rightsHolder;   // publisher or name (copyrights holder)
  public $year;
  public $rank = self::RIGHTS_RANK_UNKNOWN;  // numeric representation of the different status types
	/*
			-1 unknown
			0  public domain
			1  licensed
			2  in copyright
			3  licensed in copyright
	*/
  
  private $basePublicDomainYear;

  private $rights;
  private $loggingFlag;
  
  private $host;

	const CLASS_NAME    = 'RightsModel';

	const RIGHTS_UNKNOWN    = 'unknown';
	const RIGHTS_PUBLIC     = 'public domain';
	const RIGHTS_LICENSED   = 'licensed';
	const RIGHTS_COPYRIGHT  = 'in copyright';
	const RIGHTS_LIC_COPY   = 'licensed in copyright';  // both licensed and copyright

	const RIGHTS_RANK_UNKNOWN    = -1; // unknown
	const RIGHTS_RANK_PUBLIC     = 0;  // public domain
	const RIGHTS_RANK_LICENSED   = 1;  // licensed
	const RIGHTS_RANK_COPYRIGHT  = 2;  // in copyright
	const RIGHTS_RANK_LIC_COPY   = 3;  // both licensed and copyright

	const RIGHTS_LIC_NAME   = 'Attribution-NonCommercial ShareAlike 3.0 Unported';

	const RIGHTS_LIC_URL    = 'http://creativecommons.org/licenses/by-nc/3.0/';

	//const RIGHTS_STATEMENT  = 'Permission to host granted on behalf of the ';  // add to with publisher or copyright holder name
	const RIGHTS_STATEMENT  = 'Permission to host granted on behalf of ';  // add to with publisher or copyright holder name

	const BASE_YEAR  = 1923;  // this is a hard fixed date for public domain 

	// ****************************************
	// ****************************************
	
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
		$this->host = $_SERVER['SERVER_NAME'];
		$this->loggingFlag = false;
		$this->loadRights();
		
		$this->basePublicDomainYear = self::BASE_YEAR;
	}

	/**
	 * setLoggingFlag - set default
	 */
	function setLoggingFlag($flag)
	{
		$this->loggingFlag = $flag;
	}

	/**
	 * loadRights - set the rights data
	 */
	function loadRights()
	{
		$rights['status']       = $this->status;
		$rights['licensename']  = $this->licenseName;
		$rights['licenseUrl']   = $this->licenseUrl;
		$rights['statement']    = $this->statement;

		$rights['rank']         = $this->rank;

		$rights['rightsHolder'] = $this->rightsHolder;

		$rights['year']         = $this->year;

		$this->rights = $rights;

		return $rights;
	}

	/**
	 * clearRights - set the rights data
	 */
	function clearRights()
	{
		$this->status       = '';
		$this->licenseName  = '';
		$this->licenseUrl   = '';
		$this->statement    = '';
		$this->rightsHolder = '';
		$this->year         = '';
		$this->rank         = '';

		$this->loadRights();
	}

	/**
	 * listData - show list of data
	 */
	function listData()
	{
		$list = $this->loadRights();
		
		return $list;
	}

	/**
	 * showRights - show the rights data
	 */
	function showRights()
	{
		$this->displayRights();
	}
			
	/**
	 * displayRights - show the rights data
	 */
	function displayRights()
	{
		$rights = $this->rights;
		
		foreach ($rights as $key => $val) {
			echo $key . ': [' . $val . ']';
			echo '<br>';
		}

		echo '<br>';
		echo '<br>';
	}
	
	/**
	 * setCopyrightHolder - set the copyright holder, either publisher or name
	 */
	function setCopyrightHolder($holder)
	{
		$this->rightsHolder = $holder;
	}

	/**
	 * setRightsHolder - (alias for setCopyrightHolder) set the copyright holder, either publisher or name
	 */
	function setRightsHolder($holder)
	{
		$this->setCopyrightHolder($holder);
	}

	/**
	 * determineRights - set the rights information depending upon year given
	 */
	function determineRights($year)
	{
		switch ($year) 
		{
			case 9999:
			case 0:
			case '':
			case 'unknown':
			default:
				$this->status = self::RIGHTS_UNKNOWN;
				$this->rank   = self::RIGHTS_RANK_UNKNOWN;

				$rights = $this->loadRights();
				break;

			case ($year < $this->basePublicDomainYear):
				$this->status = self::RIGHTS_PUBLIC;
				$this->rank   = self::RIGHTS_RANK_PUBLIC;

				$this->year = $year;

				$rights = $this->loadRights();
				break;
			
			case ($year >= $this->basePublicDomainYear):
				//$this->status = self::RIGHTS_LICENSED;
				//$this->rank   = self::RIGHTS_RANK_LICENSED;
				$this->status = self::RIGHTS_COPYRIGHT;
				$this->rank   = self::RIGHTS_RANK_COPYRIGHT;
				
				$this->licenseName  = self::RIGHTS_LIC_NAME;
				$this->licenseUrl   = self::RIGHTS_LIC_URL;
				$this->statement    = self::RIGHTS_STATEMENT . ' ' . $this->rightsHolder;
				$this->year         = $year;
				
				$rights = $this->loadRights();
				
				break;
		}
		
		return $rights;
	}

	/**
	 * process - generate property values based upon year, and do a simple display of those values
	 */
	function process($name, $year)
	{
		$this->clearRights();
		
		$this->setCopyrightHolder($name);
		$this->determineRights($year);
		$this->showRights();
	}

	/**
	 * set - make property values based upon year
	 */
	function set($name, $year)
	{
		$this->clearRights();
		
		$this->setCopyrightHolder($name);
		$this->determineRights($year);
	}

	/**
	 * setData - make property values based upon given parameters
	 */
	function setData($rightsHolder, $year, $status, $licenseName, $licenseUrl, $statement)
	{
		$this->clearRights();

		$this->status       = $status;
		$this->licenseName  = $licenseName;
		$this->licenseUrl   = $licenseUrl;
		$this->statement    = $statement . ' ' . $rightsHolder;
		$this->year         = $year;
		$this->rightsHolder = $rightsHolder;

		$this->rank         = $this->selectRank($status);

		$this->loadRights();
	}

	/**
	 * setCopyrightHolder - set the metadata, given the info from the biblio custom fields 
	 *   (creates an Internet Archive compatible data chunk for metadata)
	 */
	function setIAMetaData(&$metaData, $year, $biblio_custom1, $biblio_custom2, $biblio_custom3, $biblio_custom4)
	{
		$this->clearRights();

		// mapping of custom fields to data elements
		//
		// biblio_custom1 = $this->status;
		// biblio_custom2 = $this->statement;
		// biblio_custom3 = $this->licenseName;
		// biblio_custom4 = $this->licenseUrl;

		$this->status       = $biblio_custom1;
		$this->statement    = $biblio_custom2;
		$this->licenseName  = $biblio_custom3;
		$this->licenseUrl   = $biblio_custom4;

		$this->year         = (is_numeric($year) && ($year != 9999) ? $year : 'unknown');
		$this->rightsHolder = $this->parseRightsHolder($biblio_custom2);

		$this->rank         = $this->selectRank($biblio_custom1);

		$this->loadRights();
		
		$metaData['rights_' . 'status']       = $this->status;
		$metaData['rights_' . 'statement']    = $this->statement;
		$metaData['rights_' . 'license_name'] = $this->licenseName;
		$metaData['rights_' . 'license_url']  = $this->licenseUrl;
		$metaData['rights_' . 'rightsholder'] = $this->rightsHolder;
		//$metaData['rights_' . 'year']         = $this->year;
		
		return $metaData;
	}

	/**
	 * selectRank - set the rank field based on status
	 */
	function selectRank($status)
	{
		$rank = '';
		
		switch ($status)
		{
			case self::RIGHTS_UNKNOWN:
				$rank = self::RIGHTS_RANK_UNKNOWN;
				break;

			case self::RIGHTS_PUBLIC:
				$rank = self::RIGHTS_RANK_PUBLIC;
				break;

			case self::RIGHTS_LICENSED:
				$rank = self::RIGHTS_RANK_LICENSED;
				break;

			case self::RIGHTS_COPYRIGHT:
				$rank = self::RIGHTS_RANK_COPYRIGHT;
				break;

			case self::RIGHTS_LIC_COPY:
				$rank = self::RIGHTS_RANK_LIC_COPY;
				break;

			default:
				$rank = null;
				break;
		}
		
		$this->rank = $rank;
		
		return $rank;
	}

	/**
	 * makeBiblio - set the fields translated for biblio fields
	 */
	function makeBiblio()
	{
		$biblio['biblio_custom1'] = $this->status;
		$biblio['biblio_custom2'] = $this->statement;
		$biblio['biblio_custom3'] = $this->licenseName;
		$biblio['biblio_custom4'] = $this->licenseUrl;
		
		return $biblio;
	}

	/**
	 * parseRightsHolder - extract rights holder from the statement
	 *   (only works for a fixed type of statement we have defined)
	 */
	function parseRightsHolder($rightsHolder)
	{
		$pos = strpos($rightsHolder, self::RIGHTS_STATEMENT);
		$pos += strlen(self::RIGHTS_STATEMENT);

		$this->rightsHolder   = substr($rightsHolder, $pos);
		
		return $this->rightsHolder;
	}
	
	/**
	 * setFromNode - set the data pulled from a biblio node
	 */
	function setFromNode($biblio, $flagSetRightsHolder = false)
	{
		$this->clearRights();

		$this->year           = $biblio['biblio_year'];
		
		if ($flagSetRightsHolder) {
			$this->rightsHolder   = $biblio['biblio_publisher'];  // FIXME: define/determine more about this ...?
		} else {
			
			$statement = $biblio['biblio_custom2'];
			$rights_statement = self::RIGHTS_STATEMENT;
			
			// try to pull out the rightsholder, if contains our standard statement
			if (substr_count($statement, $rights_statement)) {

				$pos = strpos($statement, $rights_statement);
				$pos += strlen($rights_statement);
	
				$this->rightsHolder   = substr($biblio['biblio_custom2'], $pos);

			} else {
				$this->rightsHolder = '';
			}
			
		}

		$this->status         = $biblio['biblio_custom1'];
		
		if ($flagSetRightsHolder) {
			$this->statement      = $biblio['biblio_custom2'] . ' ' . $this->rightsHolder;
		} else {
			$this->statement      = $biblio['biblio_custom2'];
		}
		
		$this->licenseName    = $biblio['biblio_custom3'];
		$this->licenseUrl     = $biblio['biblio_custom4'];

		$this->rank           = $this->selectRank($this->status);

		$this->loadRights();
	}

	/**
	 * parseMods - peel out the piece of data from a BHL MODS source, given the "accessCondition" tag/data pair.
	 */
	function parseMods($mods, $year, $rightsHolder)
	{
		$ret = false;
		
		// given the following, or similar 
		// <mods:accessCondition type="useAndReproduction">data</mods:accessCondition>
		
		if (substr_count($mods, 'accessCondition') && substr_count($mods, 'useAndReproduction')) {
			// ready to process
			$ret = true;

		} else {
			// not good input
			// possible point to log this
			return $ret;
		}
		
		// we can do a brute force quick extract of the data value, no need for fancy xml objects and extractors
		// wrap data with pipes,
		$mods = str_replace('>', '|', $mods);
		$mods = str_replace('</', '|', $mods);
		// and then yank the data chunk out
		$modsA = explode('|', $mods);
		$copyRightStatus = $modsA[1];
		
		// start and initialize the data
		$this->clearRights();
		// **********

		// set the data
		$this->statement      = $copyRightStatus;

		$this->year           = $year;

		$this->rightsHolder   = $rightsHolder;

		// **********
		// finish and set the data
		$this->loadRights();

		return $ret;
	}

	/**
	 * writeDublinCore - set the fields translated for biblio fields
	 */
	function writeDublinCore()
	{
		$str = '';

		$str .= '<oai-dc:dc xmlns:oai-dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">';
		$str .= "\n";

		$str .= '<dc:rights ';
		$str .= "\n";
		$str .= "\t";
		$str .= 'status="' . $this->status . '" ';
		$str .= "\n";
		$str .= "\t";
		$str .= 'statement="' . $this->statement . '" ';
		$str .= "\n";
		$str .= "\t";
		$str .= 'licenseName="' . $this->licenseName . '" ';
		$str .= "\n";
		$str .= "\t";
		$str .= 'licenseUrl="' . $this->licenseUrl . '">';
		$str .= "\n";
		$str .= '</dc:rights>';
		$str .= "\n";

		$str .= '</oai-dc:dc>';
		$str .= "\n";

		return $str;
	}

	/**
	 * writeMods - set the fields translated for biblio fields
	 */
	function writeMods()
	{
//<name type="personal">
//<namePart>Kjellenberg, Fredrik Ulrik, </namePart>
//<namePart type="date">1795-1862.</namePart>
//</name>

		$str = '';

		$str .= '<rights>';
		$str .= "\n";

		$str .= "\t";
		$str .= '<status>';
		$str .= $this->status;
		$str .= '</status>';
		$str .= "\n";

		$str .= "\t";
		$str .= '<statement>';
		$str .= $this->statement;
		$str .= '</statement>';
		$str .= "\n";

		$str .= "\t";
		$str .= '<licenseName>';
		$str .= $this->licenseName;
		$str .= '</licenseName>';
		$str .= "\n";

		$str .= "\t";
		$str .= '<licenseUrl>';
		$str .= $this->licenseUrl;
		$str .= '</licenseUrl>';
		$str .= "\n";

		$str .= "\t";
		$str .= '<rightsHolder>';
		$str .= $this->rightsHolder;
		$str .= '</rightsHolder>';
		$str .= "\n";

		$str .= "\t";
		$str .= '<year>';
		$str .= $this->year;
		$str .= '</year>';
		$str .= "\n";
		
		$str .= '</rights>';
		$str .= "\n";

		return $str;
	}

	/**
	 * writeBiblioXml - in house xml
	 */
	function writeBiblioXmlProperties()
	{
		$str = '';

		$str .= '<biblio>';
		$str .= "\n";

		$str .= '<rights ';
		$str .= "\n";

		$str .= "\t";
		$str .= 'status="' . $this->status . '" ';
		$str .= "\n";
		$str .= "\t";
		$str .= 'statement="' . $this->statement . '" ';
		$str .= "\n";
		$str .= "\t";
		$str .= 'licenseName="' . $this->licenseName . '" ';
		$str .= "\n";
		$str .= "\t";
		$str .= 'licenseUrl="' . $this->licenseUrl . '" ';
		$str .= "\n";

		$str .= "\t";
		$str .= 'rightsHolder="' . $this->rightsHolder . '" ';
		$str .= "\n";
		$str .= "\t";
		$str .= 'year="' . $this->year . '"';
		$str .= '>';
		$str .= "\n";

		$str .= '</rights>';
		$str .= "\n";

		$str .= '</biblio>';
		$str .= "\n";

		return $str;
	}

	/**
	 * writeBibText - bibtext
	 */
	function writeBibText()
	{
		$str = '';
		
		/*
		@article {38042,
			title = {Hydrographical and biological investigations in Norwegian fiords.  IV. Combination of hydrographical and biological facts.},
			journal = {Hydrographical and biological investigations in Norwegian fiords.  By O. Nordgaard.  The protist plankton and the diatoms in bottom samples.  By E. J{\o}rgensen.  With 21 plates and 10 figures in the text.},
			volume = {2},
			year = {1905},
			chapter = {227},
			url = {http://www.biodiversitylibrary.org/pdf2/001229400023119.pdf},
			author = {O. NORDGAARD}
		}
		*/
		
		$str .= '@ARTICLE{rights';
		$str .= "\n";

		$str .= ' status = {' . $this->status . '},';
		$str .= "\n";
		$str .= ' statement = {' . $this->statement . '},';
		$str .= "\n";
		$str .= ' year = {' . $this->year . '},';
		$str .= "\n";
		$str .= ' licenseName = {' . $this->licenseName . '},';
		$str .= "\n";
		$str .= ' licenseUrl = {' . $this->licenseUrl . '},';
		$str .= "\n";
		$str .= ' rightsHolder = {' . $this->rightsHolder . '}';
		$str .= "\n";
		$str .= '}';
		$str .= "\n";


		return $str;
	}

	/**
	 * writeRIS - RIS format
	 */
	function writeRIS()
	{
		$str = '';
		
		/*
			RIS format
			http://en.wikipedia.org/wiki/RIS_(file_format)
		*/

		$str .= 'TY - ' . 'JOUR' . '';
		$str .= "\n";
		
		$str .= 'N1 - ' . $this->status . '';
		$str .= "\n";
		$str .= 'N1 - ' . $this->statement . '';
		$str .= "\n";
		$str .= 'Y1 - ' . $this->year . '';
		$str .= "\n";
		$str .= 'N1 - ' . $this->licenseName . '';
		$str .= "\n";
		$str .= 'UR - ' . $this->licenseUrl . '';
		$str .= "\n";
		$str .= 'PB - ' . $this->rightsHolder . '';
		$str .= "\n";

		$str .= 'ER - ' . '' . '';
		$str .= "\n";

		return $str;
	}

/* 
RIS format
http://en.wikipedia.org/wiki/RIS_(file_format)

TY  - Type of reference (must be the first tag)
ID  - Reference ID (not imported to reference software)
T1  - Primary title
TI  - Book title
CT  - Title of unpublished reference
A1  - Primary author
A2  - Secondary author (each name on separate line)
AU  - Author (syntax. Last name, First name, Suffix)
Y1  - Primary date
PY  - Publication year (YYYY/MM/DD)
N1  - Notes 
KW  - Keywords (each keyword must be on separate line preceded KW -)
RP  - Reprint status (IN FILE, NOT IN FILE, ON REQUEST (MM/DD/YY))
SP  - Start page number
EP  - Ending page number
JF  - Periodical full name
JO  - Periodical standard abbreviation
JA  - Periodical in which article was published
J1  - Periodical name - User abbreviation 1
J2  - Periodical name - User abbreviation 2
VL  - Volume number
IS  - Issue number
T2  - Title secondary
CY  - City of Publication
PB  - Publisher
U1  - User definable 1
U5  - User definable 5
T3  - Title series
N2  - Abstract
SN  - ISSN/ISBN (e.g. ISSN XXXX-XXXX)
AV  - Availability
M1  - Misc. 1
M3  - Misc. 3
AD  - Address
UR  - Web/URL
L1  - Link to PDF
L2  - Link to Full-text
L3  - Related records
L4  - Images
ER  - End of Reference (must be the last tag)
*/
	/**
	 * writeEndNote - endnote
	 */
	function writeEndNote($formatBrace = true)
	{
		$str = '';
		/*
		%0 Journal Article
		%J Hydrographical and biological investigations in Norwegian fiords.  By O. Nordgaard.  The protist plankton and the diatoms in bottom samples.  By E. Jørgensen.  With 21 plates and 10 figures in the text.
		%D 1905
		%T Hydrographical and biological investigations in Norwegian fiords.  IV. Combination of hydrographical and biological facts.
		%A O. NORDGAARD
		%U http://www.biodiversitylibrary.org/pdf2/001229400023119.pdf
		%V 2
		*/

		$str .= '%1 ' . $this->status . '';
		$str .= "\n";
		$str .= '%2 ' . $this->statement . '';
		$str .= "\n";
		$str .= '%D ' . $this->year . '';
		$str .= "\n";
		$str .= '%4 ' . $this->licenseName . '';
		$str .= "\n";
		$str .= '%U ' . $this->licenseUrl . '';
		$str .= "\n";
		$str .= '%I ' . $this->rightsHolder . '';
		$str .= "\n";

		$str .= "\n";

		return $str;
	}

	/**
	 * makeXmlHeader - xml header
	 */
	function makeXmlHeader($echo = false)
	{
		header('Content-type: text/xml');
		
		$str = '<' . '?'. 'xml version="1.0"'.'?'.'>';
		$str .= "\n";

		if ($echo) {
			echo $str;
		}
		
		return $str;
	}

	/**
	 * writeBiblioXml - in house xml
	 */
	function writeBiblioXml()
	{
		$str = '';

		$str .= '<biblio>';
		$str .= "\n";

		$str .= '<rights>';
		$str .= "\n";

		$str .= "\t";
		$str .= '<status>' . $this->status . '</status>';
		$str .= "\n";
		$str .= "\t";
		$str .= '<statement>' . $this->statement . '</statement>';
		$str .= "\n";
		$str .= "\t";
		$str .= '<licenseName>' . $this->licenseName . '</licenseName>';
		$str .= "\n";
		$str .= "\t";
		$str .= '<licenseUrl>' . $this->licenseUrl . '</licenseUrl>';
		$str .= "\n";

		$str .= "\t";
		$str .= '<rightsHolder>' . $this->rightsHolder . '</rightsHolder>';
		$str .= "\n";
		$str .= "\t";
		$str .= '<year>' . $this->year . '</year>';
		$str .= "\n";

		$str .= '</rights>';
		$str .= "\n";

		$str .= '</biblio>';
		$str .= "\n";

		return $str;
	}

/*

http://creativecommons.org/licenses/

http://dublincore.org/usage/meetings/2004/03/dc-rights-proposal.html

http://dublincore.org/documents/dces/

<rdf:Property rdf:about="http://purl.org/dc/elements/1.1/rights">
	<rdfs:label xml:lang="en-US">Rights</rdfs:label>

	<rdfs:comment xml:lang="en-US">Information about rights held in and over the resource.</rdfs:comment>

	<dcterms:description xml:lang="en-US">Typically, rights information includes a statement about various property rights associated with the resource, including intellectual property rights.</dcterms:description>
		<rdfs:isDefinedBy rdf:resource="http://purl.org/dc/elements/1.1/"/>
		<dcterms:issued>1999-07-02</dcterms:issued>
		<dcterms:modified>2008-01-14</dcterms:modified>
		<rdf:type rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#Property"/>
	<dcterms:hasVersion rdf:resource="http://dublincore.org/usage/terms/history/#rights-006"/>

	<skos:note xml:lang="en-US">A second property with the same name as this property has been declared in the dcterms: namespace (http://purl.org/dc/terms/).  See the Introduction to the document "DCMI Metadata Terms" (http://dublincore.org/documents/dcmi-terms/) for an explanation.</skos:note>

</rdf:Property>

*/

	/**
	 * watchdog - logging
	 */
	function watchdog($msg)
	{
		if ($this->loggingFlag) {
			watchdog('RightsModel', $msg);
		}
	}

	/**
	 * _toString - stringify
	 */
	function __toString()
	{
		$info = '';

		$info .= $this->status;
		$info .= '|';
		$info .= $this->statement;
		$info .= '|';

		$info .= $this->licenseName;
		$info .= '|';
		$info .= $this->licenseUrl;
		
		$info = str_replace('|||', '', $info);  // if it is blank, send empty instead of empty pipes
		
		// dont do this
		// <dc:rights>|||</dc:rights>

		// unknown
		// <dc:rights></dc:rights>

		// public domain
		// <dc:rights>public domain</dc:rights>

		// in copyright
		// <dc:rights>in copyright|statement|license|url</dc:rights>


//		$info .= '|';
//		$info .= $this->year;
//		$info .= '|';
//		$info .= $this->rightsHolder;

		return $info;
	}
	
}  // end class
// ****************************************
// ****************************************
// ****************************************
}
?>
