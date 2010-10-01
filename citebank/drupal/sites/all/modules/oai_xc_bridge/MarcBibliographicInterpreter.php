<?php
// $Id: MarcBibliographicInterpreter.php,v 1.0.0.0 2010/09/23 4:44:44 dlheskett $

/** MarcBibliographicInterpreter class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 07/20/2010
 *
 */

// ****************************************
// ****************************************
// ****************************************

/**
 * class MarcBibliographicInterpreter  - handle Marc21 format data
 *
 */
class MarcBibliographicInterpreter
{
	private $data;
	private $TransRecordStatus;
	private $TransTypeOfRecord;
	private $TransBibliographicLevel;
	private $TransTypeOfControl;
	private $TransCharacterCodingScheme;
	private $TransEncodingLevel;
	private $TransDescriptiveCatalogingForm;
	private $TransMultipartResourceRecordLevel;
	

	// constants
	const MARC_DATA = 'xyz';

	/**
	 *  constructor - initializes 
	 */
	function __construct()
	{
		$this->init();
	}

	/**
	 *  init - initializes 
	 */
	function init()
	{
		$this->initTranslationFields();
	}

/*
<leader>
	<RecordLength>2663</recordLength>
	<RecordStatus>Corrected</RecordStatus>
	<TypeOfRecord>Language material</TypeOfRecord>
	<BibliographicLevel>Serial</BibliographicLevel>
	<TypeOfControl></TypeOfControl>
	<CharacterCodingScheme>UCS/Unicode</CharacterCodingScheme>
	<IndicatorCount>2</IndicatorCount>
	<SubfieldCodeCount>2</SubfieldCodeCount>
	<BaseAddressOfData>517</BaseAddressOfData>
	<EncodingLevel>Full level</EncodingLevel>
	<DescriptiveCatalogingForm>ISBD</DescriptiveCatalogingForm>
	<MultipartResourceRecordLevel></MultipartResourceRecordLevel>
	<LengthOfFieldPortion>4</LengthOfFieldPortion>
	<StartingCharacterPositionPortion>5</StartingCharacterPositionPortion>
	<ImplementationDefinedPortion>0</ImplementationDefinedPortion>
	<Undefined>0</Undefined>
</leader>


	<leader>02663Cas a2200517I 4500</leader> 
  <leader>02663Cas a2200517I  4500</leader>
123456789012345678901234 
012345678901234567890123 position
02663Cas a2200517I  4500
02663Cas a2200517I 4500
02663Cas a2200517 I 4500
	
02663  Record length: xxxxx

C      Record status: Corrected
a      Type of record: Language material
s      Bibliographic level: Serial
       Type of control: No specified type
a      Character coding scheme: UCS/Unicode
2      Indicator count: x
2      Subfield code count: x
00517  Base address of data: xxxxx Length of Leader and Directory
       Encoding Level:  Full level
I      Descriptive cataloging form: ISBD
       Multipart resource record level: NA
4      Length of the length-of-field portion: x (Number of characters in the length-of-field portion of a Directory entry)
5      Length of the starting-character-position portion: x (Number of characters in the starting-character-position portion of a Directory entry)
0      Length of the implementation-defined portion: x (Number of characters in the implementation-defined portion of a Directory entry)
0      Undefined: (Undefined)

http://ia360707.us.archive.org/8/items/proceedingsofent1072005ento/proceedingsofent1072005ento_marc.xml

XML MARC
http://www.loc.gov/marc/marcxml.html
http://www.loc.gov/standards/marcxml///
http://www.loc.gov/standards/marcxml/marcxml-architecture.html
http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd

*/

	/**
	 *  parseLeader - parse the leader
	 */
	function parseLeader($leader)
	{
		// the "leader" part of a MARC 21 format xml data, is a fixed length field with positional data
		//  yeah, I know, why are we using fixed length positional data in xml, well, ask the Libray of Congress.
		//  probably so it can be printed on a note card...?
		//  http://www.loc.gov/marc/bibliographic/concise/bdleader.html
		//  okay, so they are keeping up, they do have full xml plus a toolkit (in Java though)
		//  http://www.loc.gov/marc/marcxml.html
		//  plus XSL!
		//  http://www.loc.gov/standards/mods/v3/MARC21slim2MODS3-3.xsl
		
		$leaderA['RecordLength']                      = $leader[0] . $leader[1] . $leader[2] . $leader[3] . $leader[4];
		$leaderA['RecordStatus']                      = $leader[5];
		$leaderA['TypeOfRecord']                      = $leader[6];
		$leaderA['BibliographicLevel']                = $leader[7];
		$leaderA['TypeOfControl']                     = $leader[8];
		$leaderA['CharacterCodingScheme']             = $leader[9];
		$leaderA['IndicatorCount']                    = $leader[10];
		$leaderA['SubfieldCodeCount']                 = $leader[11];
		$leaderA['BaseAddressOfData']                 = $leader[12] . $leader[13] . $leader[14] . $leader[15] . $leader[16];
		$leaderA['EncodingLevel']                     = $leader[17];
		$leaderA['DescriptiveCatalogingForm']         = $leader[18];
		$leaderA['MultipartResourceRecordLevel']      = $leader[19];
		$leaderA['LengthOfFieldPortion']              = $leader[20];
		$leaderA['StartingCharacterPositionPortion']  = $leader[21];
		$leaderA['ImplementationDefinedPortion']      = $leader[22];
		$leaderA['Undefined']                         = $leader[23];
		$leaderA['Material']                          = $this->materialType($leader[6], $leader[7]);
		
		return $leaderA;
	}

	/**
	 *  parseLeaderDecode - parse the leader and decode it
	 */
	function parseLeaderDecode($leader)
	{
		// translate the character codes
		$leaderA['RecordLength']                      = ltrim($leader[0] . $leader[1] . $leader[2] . $leader[3] . $leader[4], '0');
		$leaderA['RecordStatus']                      = $this->getRecordStatus($leader[5]);
		$leaderA['TypeOfRecord']                      = $this->getTypeOfRecord($leader[6]);
		$leaderA['BibliographicLevel']                = $this->getTransBibliographicLevel($leader[7]);
		$leaderA['TypeOfControl']                     = $this->getTransTypeOfControl($leader[8]);
		$leaderA['CharacterCodingScheme']             = $this->getTransCharacterCodingScheme($leader[9]);
		$leaderA['IndicatorCount']                    = $leader[10];
		$leaderA['SubfieldCodeCount']                 = $leader[11];
		$leaderA['BaseAddressOfData']                 = ltrim($leader[12] . $leader[13] . $leader[14] . $leader[15] . $leader[16], '0');
		$leaderA['EncodingLevel']                     = $this->getTransEncodingLevel($leader[17]);
		$leaderA['DescriptiveCatalogingForm']         = $this->getTransDescriptiveCatalogingForm($leader[18]);
		$leaderA['MultipartResourceRecordLevel']      = $this->getTransMultipartResourceRecordLevel($leader[19]);
		$leaderA['LengthOfFieldPortion']              = $leader[20];
		$leaderA['StartingCharacterPositionPortion']  = $leader[21];
		$leaderA['ImplementationDefinedPortion']      = $leader[22];
		$leaderA['Undefined']                         = $leader[23];
		$leaderA['Material']                          = $this->materialType($leader[6], $leader[7]);
		
		return $leaderA;
	}

	/*
	If Leader/06 = a and Leader/07 = a, c, d, or m: Books
	If Leader/06 = a and Leader/07 = b, i, or s: Continuing Resources
	If Leader/06 = t: Books
	If Leader/06 = c, d, i, or j: Music
	If Leader/06 = e, or f: Maps
	If Leader/06 = g, k, o, or r: Visual Materials
	If Leader/06 = m: Computer Files
	If Leader/06 = p: Mixed Materials
	*/
	/**
	 *  materialType - interprets dependencies to type of materials
	 */
	private function materialType($x, $y)
	{
		$material = '';
		$x = strtolower($x);
		$y = strtolower($y);
		
		switch ($x)
		{
			case 'a': 
				switch ($y)
				{
					case 'a':
					case 'c':
					case 'd':
					case 'm':
						$material = 'Books';
						break;
		
					case 'b':
					case 'i':
					case 's':
						$material = 'Continuing Resources';
						break;
		
					default:
						break;
				}
				break;

			case 't': 
				$material = 'Books';
				break;

			case 'c': 
			case 'd': 
			case 'i': 
			case 'j': 
				$material = 'Music';
				break;

			case 'e': 
			case 'f': 
				$material = 'Maps';
				break;

			case 'g': 
			case 'k': 
			case 'o': 
			case 'r': 
				$material = 'Visual Materials';
				break;

			case 'm': 
				$material = 'Computer Files';
				break;

			case 'p': 
				$material = 'Mixed Materials';
				break;

			default:
				break;
		}
		
		return $material;
	}


	/**
	 *  initTranslationFields - initializes translation field data
	 */
	private function initTranslationFields()
	{
		// 05 - Record status
		// Encoding level (Leader/17) of the record has been changed to a higher encoding level. 
		$this->TransRecordStatus['a'] = 'Increase in encoding level';
		// Addition/change other than in the Encoding level code has been made to the record.
		$this->TransRecordStatus['c'] = 'Corrected or revised';
		$this->TransRecordStatus['d'] = 'Deleted';
		$this->TransRecordStatus['n'] = 'New';
		// Prepublication record has had a change in cataloging level resulting from the availability of the published item. 
		$this->TransRecordStatus['p'] = 'Increase in encoding level from prepublication';
		
    // 06 - Type of record
    // Includes microforms and electronic resources that are basically textual in nature, whether they are reproductions from print or originally produced. 
		$this->TransTypeOfRecord['a'] = 'Language material';
		// Used for printed, microform, or electronic notated music.
		$this->TransTypeOfRecord['c'] = 'Notated music';
		// Used for manuscript notated music or a microform of manuscript music.
		$this->TransTypeOfRecord['d'] = 'Manuscript notated music';
		// Includes maps, atlases, globes, digital maps, and other cartographic items.
		$this->TransTypeOfRecord['e'] = 'Cartographic material';
		// Used for manuscript cartographic material or a microform of manuscript cartographic material. 
		$this->TransTypeOfRecord['f'] = 'Manuscript cartographic material';
		// Used for motion pictures, videorecordings (including digital video), filmstrips, slide, transparencies or material specifically designed for projection. 
		$this->TransTypeOfRecord['g'] = 'Projected medium';
		// Used for a recording of nonmusical sounds (e.g., speech).
		$this->TransTypeOfRecord['i'] = 'Nonmusical sound recording';
		// Used for a musical sound recording (e.g., phonodiscs, compact discs, or cassette tapes. 
		$this->TransTypeOfRecord['j'] = 'Musical sound recording';
		// Used for two-dimensional nonprojectable graphics such as, activity cards, charts, collages, computer graphics, digital pictures, drawings, duplication masters, flash cards, paintings, photo CDs, photomechanical reproductions, photonegatives, photoprints, pictures, postcards, posters, prints, spirit masters, study prints, technical drawings, transparency masters, and reproductions of any of these. 
		$this->TransTypeOfRecord['k'] = 'Two-dimensional nonprojectable graphic';
		// Used for the following classes of electronic resources: computer software (including programs, games, fonts), numeric data, computer-oriented multimedia, online systems or services. For these classes of materials, if there is a significant aspect that causes it to fall into another Leader/06 category, the code for that significant aspect is used instead of code m (e.g., vector data that is cartographic is not coded as numeric but as cartographic). Other classes of electronic resources are coded for their most significant aspect (e.g. language material, graphic, cartographic material, sound, music, moving image). In case of doubt or if the most significant aspect cannot be determined, consider the item a computer file. 
		$this->TransTypeOfRecord['m'] = 'Computer file';
		// Used for a mixture of various components issued as a unit and intended primarily for instructional purposes where no one item is the predominant component of the kit. 
		$this->TransTypeOfRecord['o'] = 'Kit';
		// Used when there are significant materials in two or more forms that are usually related by virtue of their having been accumulated by or about a person or body. Includes archival fonds and manuscript collections of mixed forms of materials, such as text, photographs, and sound recordings.
		$this->TransTypeOfRecord['p'] = 'Mixed materials';
		// Includes man-made objects such as models, dioramas, games, puzzles, simulations, sculptures and other three-dimensional art works, exhibits, machines, clothing, toys, and stitchery. Also includes naturally occurring objects such as, microscope specimens (or representations of them) and other specimens mounted for viewing. 
		$this->TransTypeOfRecord['r'] = 'Three-dimensional artifact or naturally occurring object';
		//
		$this->TransTypeOfRecord['t'] = 'Manuscript language material';

		// 07 - Bibliographic level   
		$this->TransBibliographicLevel['a'] = 'Monographic component part';
		$this->TransBibliographicLevel['b'] = 'Serial component part';
		$this->TransBibliographicLevel['c'] = 'Collection';
		$this->TransBibliographicLevel['d'] = 'Subunit';
		$this->TransBibliographicLevel['i'] = 'Integrating resource';
		$this->TransBibliographicLevel['m'] = 'Monograph/Item';
		$this->TransBibliographicLevel['s'] = 'Serial';

		//08 - Type of control
		$this->TransTypeOfControl[' '] = 'No specified type';
		$this->TransTypeOfControl['a'] = 'Archival';

		//09 - Character coding scheme
		$this->TransCharacterCodingScheme[' '] = 'MARC-8';
		$this->TransCharacterCodingScheme['a'] = 'UCS/Unicode';

		//17 - Encoding level
		$this->TransEncodingLevel[' '] = 'Full level';
		$this->TransEncodingLevel['1'] = 'Full level, material not examined';
		$this->TransEncodingLevel['2'] = 'Less-than-full level, material not examined';
		$this->TransEncodingLevel['3'] = 'Abbreviated level';
		$this->TransEncodingLevel['4'] = 'Core level';
		$this->TransEncodingLevel['5'] = 'Partial (preliminary) level';
		$this->TransEncodingLevel['7'] = 'Minimal level';
		$this->TransEncodingLevel['8'] = 'Prepublication level';
		$this->TransEncodingLevel['u'] = 'Unknown';
		$this->TransEncodingLevel['z'] = 'Not applicable';

		//18 - Descriptive cataloging form
		$this->TransDescriptiveCatalogingForm[' '] = 'Non-ISBD';
		$this->TransDescriptiveCatalogingForm['a'] = 'AACR 2';
		$this->TransDescriptiveCatalogingForm['i'] = 'ISBD';
		$this->TransDescriptiveCatalogingForm['u'] = 'Unknown';

		//19 - Multipart resource record level
		$this->TransMultipartResourceRecordLevel[' '] = 'Not specified or not applicable';
		$this->TransMultipartResourceRecordLevel['a'] = 'Set';
		$this->TransMultipartResourceRecordLevel['b'] = 'Part with independent title';
		$this->TransMultipartResourceRecordLevel['c'] = 'Part with dependent title';

	}

	/**
	 *  getRecordStatus - translate the record status 
	 */
	private function getRecordStatus($x)
	{
		$str = '';
		$x = strtolower($x);
		
		if (array_key_exists($x, $this->TransRecordStatus)) {
			$str = $this->TransRecordStatus[$x];
		}
		
		return $str;
	}

	/**
	 *  getRecordStatus - translate the record status 
	 */
	private function getTypeOfRecord($x)
	{
		$str = '';
		$x = strtolower($x);
		
		if (array_key_exists($x, $this->TransTypeOfRecord)) {
			$str = $this->TransTypeOfRecord[$x];
		}
		
		return $str;
	}

	/**
	 *  getTransBibliographicLevel - translate 
	 */
	private function getTransBibliographicLevel($x)
	{
		$str = '';
		$x = strtolower($x);
		
		if (array_key_exists($x, $this->TransBibliographicLevel)) {
			$str = $this->TransBibliographicLevel[$x];
		}
		
		return $str;
	}

	/**
	 *  getTransTypeOfControl - translate
	 */
	private function getTransTypeOfControl($x)
	{
		$str = '';
		$x = strtolower($x);
		
		if (array_key_exists($x, $this->TransTypeOfControl)) {
			$str = $this->TransTypeOfControl[$x];
		}
		
		return $str;
	}

	/**
	 *  getTransCharacterCodingScheme - translate the record status 
	 */
	private function getTransCharacterCodingScheme($x)
	{
		$str = '';
		$x = strtolower($x);
		
		if (array_key_exists($x, $this->TransCharacterCodingScheme)) {
			$str = $this->TransCharacterCodingScheme[$x];
		}
		
		return $str;
	}

	/**
	 *  getTransEncodingLevel - translate
	 */
	private function getTransEncodingLevel($x)
	{
		$str = '';
		$x = strtolower($x);
		
		if (array_key_exists($x, $this->TransEncodingLevel)) {
			$str = $this->TransEncodingLevel[$x];
		}
		
		return $str;
	}

	/**
	 *  getTransDescriptiveCatalogingForm - translate
	 */
	private function getTransDescriptiveCatalogingForm($x)
	{
		$str = '';
		$x = strtolower($x);
		
		if (array_key_exists($x, $this->TransDescriptiveCatalogingForm)) {
			$str = $this->TransDescriptiveCatalogingForm[$x];
		}
		
		return $str;
	}

	/**
	 *  getTransMultipartResourceRecordLevel - translate
	 */
	private function getTransMultipartResourceRecordLevel($x)
	{
		$str = '';
		$x = strtolower($x);
		
		if (array_key_exists($x, $this->TransMultipartResourceRecordLevel)) {
			$str = $this->TransMultipartResourceRecordLevel[$x];
		}
		
		return $str;
	}

	/**
	 *  makeLeaderXml - create the leader in decoded form as xml
	 */
	function makeLeaderXml($leader, $web = false)
	{

		$xml  = '<leader>';
		$xml .= "\n";
		$xml .= '	<RecordLength>'.$leader['RecordLength'].'</RecordLength>';
		$xml .= "\n";
		$xml .= '	<RecordStatus>'.$leader['RecordStatus'].'</RecordStatus>';
		$xml .= "\n";
		$xml .= '	<TypeOfRecord>'.$leader['TypeOfRecord'].'</TypeOfRecord>';
		$xml .= "\n";
		$xml .= '	<BibliographicLevel>'.$leader['BibliographicLevel'].'</BibliographicLevel>';
		$xml .= "\n";
		$xml .= '	<TypeOfControl>'.$leader['TypeOfControl'].'</TypeOfControl>';
		$xml .= "\n";
		$xml .= '	<CharacterCodingScheme>'.$leader['CharacterCodingScheme'].'</CharacterCodingScheme>';
		$xml .= "\n";
		$xml .= '	<IndicatorCount>'.$leader['IndicatorCount'].'</IndicatorCount>';
		$xml .= "\n";
		$xml .= '	<SubfieldCodeCount>'.$leader['SubfieldCodeCount'].'</SubfieldCodeCount>';
		$xml .= "\n";
		$xml .= '	<BaseAddressOfData>'.$leader['BaseAddressOfData'].'</BaseAddressOfData>';
		$xml .= "\n";
		$xml .= '	<EncodingLevel>'.$leader['EncodingLevel'].'</EncodingLevel>';
		$xml .= "\n";
		$xml .= '	<DescriptiveCatalogingForm>'.$leader['DescriptiveCatalogingForm'].'</DescriptiveCatalogingForm>';
		$xml .= "\n";
		$xml .= '	<MultipartResourceRecordLevel>'.$leader['MultipartResourceRecordLevel'].'</MultipartResourceRecordLevel>';
		$xml .= "\n";
		$xml .= '	<LengthOfFieldPortion>'.$leader['LengthOfFieldPortion'].'</LengthOfFieldPortion>';
		$xml .= "\n";
		$xml .= '	<StartingCharacterPositionPortion>'.$leader['StartingCharacterPositionPortion'].'</StartingCharacterPositionPortion>';
		$xml .= "\n";
		$xml .= '	<ImplementationDefinedPortion>'.$leader['ImplementationDefinedPortion'].'</ImplementationDefinedPortion>';
		$xml .= "\n";
		$xml .= '	<Undefined>'.$leader['Undefined'].'</Undefined>';
		$xml .= "\n";
		$xml .= '	<Material>'.$leader['Material'].'</Material>';
		$xml .= "\n";
		$xml .= '</leader>';
		$xml .= "\n";
		
		if ($web) {
			$xml = htmlspecialchars($xml);
			$xml = str_replace("\n", "\n<br>", $xml);
		}

		return $xml;
	}

	/**
	 *  parseDateTime - parse date time, convert to data elements. 
	 *    reads: 20040519125100.0 and creates an array of the date time info, 
	 *    or just a string YYYYMMDDHHMMSS
	 */
	function parseDateTime($dateTime, $justAString = false)
	{
		$year  = $dateTime[0] . $dateTime[1] . $dateTime[2] . $dateTime[3];
		$month = $dateTime[4] . $dateTime[5];
		$day   = $dateTime[6] . $dateTime[7];

		$hour  = $dateTime[8] . $dateTime[9];
		$min   = $dateTime[10] . $dateTime[11];
		$sec   = $dateTime[12] . $dateTime[13];
		$msec  = $dateTime[14] . $dateTime[15];

		if ($justAString) {
			$date = $year . $month . $day . $hour . $min . $sec;
		} else {
			$date['data'] = $dateTime;

			$date['year'] = $year;
			$date['month'] = $month;
			$date['day'] = $day;
	
			$date['hour'] = $hour;
			$date['min']  = $min;
			$date['sec']  = $sec;
			$date['msec'] = $msec;
	
			$date['date'] = $year . $month . $day;
			$date['time'] = $hour . $min . $sec;
		}
		
		return $date;
	}

	/**
	 *  parseMarcRecord - parse Marc 21 xml into an array
	 */
	function parseMarcRecord($xml)
	{
		$data = simplexml_load_string($xml);
		
		return $data;
	}



}  // end class
// ****************************************
// ****************************************
// ****************************************


?>
