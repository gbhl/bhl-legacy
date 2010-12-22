<?php
// $Id: BiblioAuthorHandler.php,v 1.0.0.0 2010/12/17 4:44:44 dlheskett $

/** BiblioAuthorHandler class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 12/17/2010
 *
 */

$includePath = dirname(__FILE__) . '/';
require_once($includePath . 'DBInterfaceController.php');

/** 
 * class BiblioAuthorHandler - handle biblios author structure
 * 
 */
class BiblioAuthorHandler
{
	public $className;

	const CLASS_NAME    = 'BiblioAuthorHandler';

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
	}

	/**
	 * stub - 
	 */
	function stub()
	{
		$this->x = 'x';

		return $this->x;
	}

	/**
	 * addAuthors - given a node id and array of author(s), put them into biblios database tables: biblio_contributor_data, biblio_contributor
	 */
	function addAuthors($nid, $authors)
	{
		$numberOfAuthors = count($authors);
		
		if ($numberOfAuthors > 0) {
			foreach ($authors as $key => $author) {
				
			}
		}


		//return $this->x;
	}

/*
Margalit J.Dean D.
Stewart RJ.Miura T.
Kimsey RB.Brittnacher JG.
Kottkamp WB.Meisch MV.
Friederich PA.

"Smith, John K" or "John K Smith" or "J.K. Smith"
*/
	/**
	 * parseName - 
	 */
	function parseName($author)
	{
		
		$name = explode(' ', $author);

		$lastname  = $name[1];
		$firstname = $name[0];
		$initials  = $name[2];
		
		$contributor_data['lastname']    = $lastname;
		$contributor_data['firstname']   = $firstname;
		$contributor_data['prefix']      = '';
		$contributor_data['suffix']      = '';
		$contributor_data['initials']    = $initials;

		//$contributor_data['name']        = $contributor_data['prefix'] . ' ' . $contributor_data['firstname'] . ' ' . $contributor_data['initials'] . ' ' . $contributor_data['lastname'] . ' ' . $contributor_data['suffix'];
		$contributor_data['name']        = $contributor_data['firstname'] . ' ' . $contributor_data['initials'] . '. ' . $contributor_data['lastname'];

		$contributor_data['affiliation'] = '';
		$contributor_data['md5']         = '';

		return $contributor_data;
	}

	/**
	 * hasMultipleAuthors - 
	 */
	function hasMultipleAuthors($authors)
	{
		$multipleFlag = false;
		$authorsStr = $authors;
		
//		if (is_array($authors)){
//			// array
//			
//		} else {
//			// string
//			$authorsStr = $authors;
//		}

		//strstr
		$howManyAuthors = substr_count($authorsStr, ';');
		
		// 
		$multipleFlag = ($howManyAuthors > 1 ? true : false );
		
		return $multipleFlag;
	}

	/**
	 * preParseName - 
	 */
	function preParseName($author)
	{
		$authorName['name'] = $author;

		$data = $this->biblio_parse_author($authorName);

		return $data;
	}

	/**
	 * makeAuthor - 
	 */
	function makeAuthor($nid, $author)
	{
		$multipleFlag = false;
		
		
	}

	/**
	 * makeAuthorList - 
	 */
	function makeAuthorList($authors)
	{
		$authorList = explode(';', $authors);

		return $authorList;
	}

/*



makeAuthor($nid, $name)

$cid = makeBiblioContributorData($name)


makeBiblioContributor($nid, $cid, $rank = 0)




function makeBiblioContributorData($name)

$lastname  = $name['lastname'];
$firstname = $name['firstname'];
$lastname = $name['lastname'];
...



return $cid


makeBiblioContributor($nid, $cid, $rank = 0)

*/

	// ***** CUT FROM BIBLIO: biblio.contributors.inc *****
	// code has been cleaned up
	//
	/* Create writer arrays from bibtex input.
	 'author field can be (delimiters between authors are 'and' or '&'):
	 1. <first-tokens> <von-tokens> <last-tokens>
	 2. <von-tokens> <last-tokens>, <first-tokens>
	 3. <von-tokens> <last-tokens>, <jr-tokens>, <first-tokens>
	 */
	/**
	 * @param $author_array
	 * @return unknown_type
	 */
	function biblio_parse_author($author_array, $cat = 0) 
	{
		if ($cat == 5) {
			$author_array['firstname'] = '';
			$author_array['initials']  = '';
			$author_array['lastname']  = trim($author_array['name']);
			$author_array['prefix']    = '';

		} else {
			$value = trim($author_array['name']);
			
			$appellation = '';
			$prefix      = '';
			$surname     = '';
			$firstname   = '';
			$initials    = '';
			
			$value = preg_replace("/\s{2,}/", ' ', $value); // replace multiple white space by single space
			
			$author = explode(',', $value);
			$size = sizeof($author);
			
			// No commas therefore something like Mark Grimshaw, Mark Nicholas Grimshaw, M N Grimshaw, Mark N. Grimshaw
			if ($size == 1) {
				// Is complete surname enclosed in {...}, unless the string starts with a backslash (\) because then it is
				// probably a special latex-sign..
				// 2006.02.11 DR: in the last case, any NESTED curly braces should also be taken into account! so second
				// clause rules out things such as author="a{\"{o}}"
				//
				if (preg_match("/(.*){([^\\\].*)}/", $value, $matches) && !(preg_match("/(.*){\\\.{.*}.*}/", $value, $matches2))) {
					$author = explode(" ", $matches[1]);
					$surname = $matches[2];
				}
				else {
					$author = explode(' ', $value);
					// last of array is surname (no prefix if entered correctly)
					$surname = array_pop($author);
				}

			} else if ($size == 2) {
				// Something like Grimshaw, Mark or Grimshaw, Mark Nicholas  or Grimshaw, M N or Grimshaw, Mark N.
				// first of array is surname (perhaps with prefix)

				list ($surname, $prefix) = $this->_grabSurname(array_shift($author));

			} else {
				// If $size is 3, we're looking at something like Bush, Jr. III, George W
				// middle of array is 'Jr.', 'IV' etc.

				$appellation = implode(' ', array_splice($author, 1, 1));

				// first of array is surname (perhaps with prefix)
				list ($surname, $prefix) = $this->_grabSurname(array_shift($author));

			}
			
			$remainder = implode(" ", $author);

			list ($firstname, $initials, $prefix2) = $this->_grabFirstnameInitials($remainder);

			if (!empty ($prefix2)) {
				$prefix .= $prefix2;
			}

			$author_array['firstname'] = trim($firstname);
			$author_array['initials']  = trim($initials);
			$author_array['lastname']  = trim($surname);
			$author_array['prefix']    = trim($prefix);
			$author_array['suffix']    = trim($appellation);
		}

		$author_array['md5'] =  $this->_md5sum($author_array);

		return $author_array;
	}
	/**
	 * @param $creator
	 * @return unknown_type
	 */
	function _md5sum($creator) 
	{
		$string = $creator['firstname'] . $creator['initials'] . $creator['prefix'] . $creator['lastname'];

		$string = str_replace(' ', '', strtolower($string));

		return md5($string);
	}

	// grab firstname and initials which may be of form "A.B.C." or "A. B. C. " or " A B C " etc.
	/**
	 * @param $remainder
	 * @return unknown_type
	 */
	function _grabFirstnameInitials($remainder) 
	{
		$prefix = array();
		$firstname = $initials = '';

		$array = explode(' ', $remainder);

		foreach ($array as $value) {
			$firstChar = substr($value, 0, 1);

			if ((ord($firstChar) >= 97) && (ord($firstChar) <= 122)) {
				$prefix[] = $value;
			} else if (preg_match("/[a-zA-Z]{2,}/", trim($value))) {
				$firstnameArray[] = trim($value);
			} else {
				$initialsArray[] = trim(str_replace(".", " ", trim($value)));
			}
		}
		
		if (isset ($initialsArray)) {
			$initials = implode(' ', $initialsArray);
		}

		if (isset ($firstnameArray)) {
			$firstname = implode(' ', $firstnameArray);
		}

		if (!empty ($prefix)) {
			$prefix = implode(' ', $prefix);
		}

		return array($firstname, $initials, $prefix);
	}

	// surname may have title such as 'den', 'von', 'de la' etc. - characterised by first character lowercased.  Any
	// uppercased part means lowercased parts following are part of the surname (e.g. Van den Bussche)
	/**
	 * @param $input
	 * @return unknown_type
	 */
	function _grabSurname($input) 
	{
		$noPrefix = FALSE;
		$surname = FALSE;
		$prefix  = FALSE;
	
		$surnameArray = explode(' ', $input);
	
		foreach ($surnameArray as $value) {
			$firstChar = substr($value, 0, 1);

			if (!$noPrefix && (ord($firstChar) >= 97) && (ord($firstChar) <= 122)) {
				$prefix[] = $value;
			} else {
				$surname[] = $value;
				$noPrefix = TRUE;
			}
		}
		
		if (!empty($surname)) {
			$surname = implode(' ', $surname);
		}

		if (!empty ($prefix)) {
			$prefix = implode(' ', $prefix);
		}

		return array($surname, $prefix);
	}
	// ***** CUT FROM BIBLIO: biblio.contributors.inc *****
	//

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

?>
