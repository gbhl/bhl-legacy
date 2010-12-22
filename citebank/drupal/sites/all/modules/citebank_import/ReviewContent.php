<?php
// $Id: ReviewContent.php,v 1.0.0.0 2010/12/13 4:44:44 dlheskett $

/**  ReviewContent class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 12/13/2010
 *
 */

$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'ExcelTextImporter.php');
require_once($includePath . 'BiblioNode.php');
require_once($includePath . 'SendProof.php');


/** 
 * class ReviewContent - 
 * 
 */
class ReviewContent
{
	public $biblioNode = null;
	public $excelImporter = null;
	public $sourceFile = '';
	public $reviewerEmail = '';
	
	const CLASS_NAME    = 'ReviewContent';
	const DEFAULT_REVIEW_EMAIL = 'david.heskett@mobot.org';

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
		$this->biblioNode = new BiblioNode();
		$this->excelImporter = new ExcelTextImporter();
		$this->biblioNode->titleRowFlag = true;
	}

	/**
	 * createReviewContent - process the node, create a review format of the data
	 */
	function createReviewContent($contentFormat = BiblioNode::STRING_TO_CSV)
	{
		$msg = '';
		$dataFile = $this->sourceFile;
		
		$biblios = $this->excelImporter->processFileIntoBiblioData($dataFile);

		$this->biblioNode->formatType = $contentFormat;

		// html header if using that
		if ($this->biblioNode->formatType == BiblioNode::STRING_TO_HTML) {
			$this->biblioNode->strhtm = -1;
			$msg .= $this->biblioNode;
		}

		foreach ($biblios as $biblio) {
			$this->biblioNode->setDataByNodeXData($biblio);
			$biblioNode = $this->biblioNode->processNode(null);

			if (count($biblio) > 1) {
				$msg .= $this->biblioNode; // utilizes built in customized to string method
			}
		}

		// end html header if using that
		if ($this->biblioNode->formatType == BiblioNode::STRING_TO_HTML) {
			$this->biblioNode->strhtm = 1;
			$msg .= $this->biblioNode;
		}
		
		return $msg;
	}

	/**
	 * reviewData - send the data to reviewer
	 */
	function reviewData($msg = 'no data')
	{
		echo $msg;
		//$this->sendIt($this->sourceFile, $this->reviewerEmail, $msg);
	}
	
	/**
	 * sendIt - send the data to reviewer, in this case, email it
	 */
	function sendIt($dataFile, $msg = 'no data', $reviewer = self::DEFAULT_REVIEW_EMAIL)
	{
		$file = $dataFile;
		$to = $reviewer;
		$subject = 'Data import to review for: ' . $file;

		$mailFlag = mail($to, $subject, $msg);
		
		return $mailFlag;
	}

	/**
	 * sendProof - send the data to reviewer, in this case, email it
	 */
	function sendProof($reviewName, $content)
	{
		$proof = new SendProof();

		$proof->sendProof($content, $reviewName);

		$mailFlag = $proof->proofMailed;
		
		return $mailFlag;
	}

	/**
	 * writeProof - write the data to review, in this case, to a file
	 */
	function writeProof($fileName, $content)
	{
		$ret = null;
		$proofFile = rtrim($fileName, '.csv') . '.proof.csv';
		
		$proofFile = str_replace('default/files', 'default/files/proofs', $proofFile);
		
		$flag = file_put_contents($proofFile, $content);
		
		if ($flag) {
			$ret = $proofFile;
		}
		
		return $ret;
	}

	/**
	 *  shortFileName - 
	 */
	function shortFileName($filename)
	{
		$x = explode('/', $filename);
		
		$count = count($x);
		
		$file = $x[$count - 1];
		
		return $file;
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
