<?php
// $Id: SendProof.php,v 1.1.0.0 2010/12/16 4:44:44 dlheskett $

/**  SendProof class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 12/16/2010
 *
 */

$includePath = dirname(__FILE__) . '/';

// http://phpmailer.worxware.com/index.php?pg=examplebmail
// 
require_once($includePath . 'class.phpmailer.php');

/** 
 * class SendProof - email handler
 * 
 */
class SendProof
{
	public $proofMailed = false;
	
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
	}

	/**
	 * sendProof - email out with an attachment the proof data
	 */
	function sendProof($attachment, $reviewName, $proofFile)
	{
		// TO:
		// Reviewer Test
		// Reviewer
		//$reviewerAddr = 'david.heskett@mobot.org';
		//$reviewerName = 'David Heskett';
		$reviewerAddr = 'trish.rose-sandler@mobot.org';
		$reviewerName = 'Trish Rose-Sandler';
		
		// FROM:
		// Automated Proof
		$fromAutoName = 'Automated Proof';
		$fromAutoAddr = 'feedback@citebank.org';
		
		// FILE NAME
		$filename = 'Proof-' . date('Y-m-d-H-i') . '.csv';  // attachment filename
		
		// SUBJECT:
		$subject = 'Data import PROOF to review for: ' . $reviewName;
		
		// ATTACHMENT FILE DATA:
		//  $attachment that is provided
		
		// DO EET!
		$mail = new PHPMailer(true); //defaults to using php "mail()"; the true param means it will throw exceptions on errors, which we need to catch
		
		try {
		  // REPLY TO:
		  $mail->AddReplyTo($fromAutoAddr, $fromAutoName);
		
		  // TO:
		  $mail->AddAddress($reviewerAddr, $reviewerName);
		
		  // FROM:
		  $mail->SetFrom($fromAutoAddr, $fromAutoName);
		
		  // SUBJECT:
		  $mail->Subject = $subject;
		  $mail->AltBody = 'To view the message, please use an HTML compatible email viewer!'; // optional - MsgHTML will create an alternate automatically
		
		  $linkToProofFile = str_replace('/var/www', 'http:/', $proofFile);
		  // MESSAGE:
		  $msg = 'Here is a <strong>Proof</strong> of <strong>' . $reviewName . '</strong>.  <br>See : ' . $linkToProofFile . ' <br><a href="' . $linkToProofFile . '">Proof File Link</a>';
		  $mail->MsgHTML($msg);
		
		  // ATTACHMENT:
		  $encoding = '8bit';
		  $type = 'application/excel';
		  $mail->AddStringAttachment($attachment, $filename, $encoding, $type); // attachment (generated on the fly, not a disk file)
		  
		  // SEND IT
		  $mail->Send();
		
		  //echo "Message Sent OK</p>\n";
		  $this->proofMailed = true;

		} catch (phpmailerException $e) {

		  $this->error = $e->errorMessage(); //Pretty error messages from PHPMailer

		} catch (Exception $e) {

		  $this->error = $e->getMessage(); //Boring error messages from anything else!
		}
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
