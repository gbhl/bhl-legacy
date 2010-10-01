<?php

/** Keywords class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date created: 09/15/2010
 *
 */

/** 
 * class Keywords - class for keyword handling.
 * 
 */
class Keywords
{
	/**
	 * _construct - constructor
	 */
	function __construct()
	{
	}

//$ignoreWords[] = 'the';
//$ignoreWords[] = 'The';
//$ignoreWords[] = 'of';
//$ignoreWords[] = 'a';
//$ignoreWords[] = 'an';
//$ignoreWords[] = 'and';
//$ignoreWords[] = 'A';
//$ignoreWords[] = 'or';
//$ignoreWords[] = 'our';
//$ignoreWords[] = 'are';
//$ignoreWords[] = 'to';
//$ignoreWords[] = '';
	
	/**
	 * keywords - create a keyword list from a string,
	 *  excluding common words, select verbs, and other mundane words.
	 */
	function keywords($title)
	{
		$keywords = array();
		
		$keywordList = explode(' ', $title);
		
		foreach ($keywordList as $word) {
			
			$word = trim($word);
			$word = trim($word, ',.?!()#;:"@$%&*~_–=+<>/\\0123456789');
			
			switch($word)
			{
				// list of ignore words
				// common words
				case 'A':
				case 'An':
				case 'I':
				case 'I\'m':
				case 'The':
				case 'This':
				case 'With':
				case 'a':
				case 'am':
				case 'an':
				case 'and':
				case 'any':
				case 'are':
				case 'as':
				case 'at':
				case 'be':
				case 'being':
				case 'by':
				case 'do':
				case 'for':
				case 'from':
				case 'if':
				case 'in':
				case 'is':
				case 'it':
				case 'it\'s':
				case 'its':
				case 'my':
				case 'of':
				case 'oh':
				case 'on':
				case 'or':
				case 'our':
				case 'so':
				case 'the':
				case 'this':
				case 'to':
				case 'us':
				case 'with':
				case '':
				
				// maybe
				case 'Report':
				case 'book':
				case 'catalogue':
				case 'description':
				case 'descriptive':
				case 'exclusive':
				case 'illustrated':
				case 'including':
				case 'key':
				case 'most':
				case 'preliminary':
				case 'report':
				case 'review':
				case 'some':
				case 'their':
				case 'there':
				case 'upon':
	
				case 'that':
				case 'who':
				case 'into':
				case 'e.g':
				case 'etc':
				case 'can':
				case 'will':
	
				case 'am':
				case 'appear':
				case 'be':
				case 'are':
				case 'being':
				case 'become':
				case 'been':
				case 'being':
				case 'can':
				case 'could':
				case 'would':
				case 'did':
				case 'do':
				case 'does':
				case 'feel':
				case 'get':
				case 'grow':
				case 'have':
				case 'has':
				case 'been':
				case 'had':
				case 'has':
				case 'have':
				case 'is':
				case 'lie':
				case 'look':
				case 'may':
				case 'might':
				case 'must':
				case 'prove':
				case 'remain':
				case 'seem':
				case 'shall':
				case 'should':
				case 'sit':
				case 'smell':
				case 'sound':
				case 'stay':
				case 'taste':
				case 'turn':
				case 'was':
				case 'were':
				case 'will':
	//			case '':
					break;
					
				default:
					// give us a word, put it in our list
					if (!is_numeric($word)) {   // filter out numbers
						if (strlen($word) > 1) {  // more than a single letter
							// filter out html garbage
							if (substr_count($word, '>') || substr_count($word, '"') || strstr($word, '://')) {
								;
							} else if (substr_count($word, '&lt;')) {
								;
							} else if (substr_count($word, '=')) {
								;
							} else {
								$keywords[] = $word;
							}
						}
					}
					break;
			}
		}
		
		return $keywords;
		
	}
}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
