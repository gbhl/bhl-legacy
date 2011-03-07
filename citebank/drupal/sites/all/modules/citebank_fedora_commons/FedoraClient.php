<?php
// $Id: FedoraClient.php,v 1.0.0.0 2010/03/02 4:44:44 dlheskett $

/** FedoraClient class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 03/02/2011
 *
 */

$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'FedoraCommonsModel.php');

// FEDORA -  Flexible Extensible Digitial Object and Repository Architecture


/** 
 * class FedoraClient - fedora communications
 * 
 */
class FedoraClient
{
	public $pid;
	public $pidNum;
	public $pidName;
	
	public $args = '';
	
	const FEDORA_HOST = 'http://172.16.17.197:8080/fedora/';
	const FEDORA_FOX_XML_DATA = 'fedoraFoxXmlFile.xml';
	const FEDORA_TEMP_DATA = 'testdata.txt';
		
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


/*

curl --user fedoraAdmin:fedoraAdmin -i -s -H "Content-type: text/xml"
-XPOST "http://localhost:8080/fedora/objects/testX34b:105"
--data-binary @testX34b.xml -k

curl --user fedoraAdmin:fedoraAdmin -i -s -H "Content-type: text/xml" -XPOST "http://localhost:8080/fedora/objects/testX38:1011342" --data-binary @fedoraFoxXmlFile.xml -k

*/
// 'http://172.16.17.197:8080/fedora/';
	/**
	 * sendData - 
	 */
	function sendData($data, $pidName, $pidNum)
	{
		$pid = $pidName . ':' . $pidNum;
		$dsID = 'citebank';
		
		$curlCmd = 'curl --user fedoraAdmin:fedoraAdmin -i -s -H "Content-type: text/xml" -XPOST "http://172.16.17.197:8080/fedora/objects/'.$pidName.':'.$pidNum.'" --data-binary @fedoraFoxXmlFile.xml -k';
		
		$resp = exec($curlCmd);
		
		return $resp;	
	}

	/**
	 * sendData - this one does not work for some reason, error is "Content is not allowed in prolog "
   	 is an error generally emitted by the Java XML parsers when data is encountered before the <?xml... declaration.
   	 are we encountering a hidden added, BOM - Byte Order Mark   (unicode character identifier, to signal byte order)?
	 */
	function XXsendData($data, $pidName, $pidNum)
	{
		$ch = curl_init();
		
		$pid = $pidName . ':' . $pidNum;
		$dsID = 'citebank';
		
		$query = 'objects/'.$pid. '?' . 'controlGroup=X' .  '&dsState=A';

		$resp = $this->callFedora($query, 'post', 'xml', 'add');
		
		return $resp;	
	}


	/**
	 * getData - 
	 */
	function getData()
	{
		$resp = $this->callFedora('describe');
	
		return $resp;	
	}

	/**
	 * listData - 
	 */
	function listData($pid)
	{
		$stream = 'objects/'.$pid.'/datastreams';
		$resp = $this->callFedora($stream);
		
		return $resp;	
	}
	
	/**
	 * getNextPid - 
	 */
	function getNextPid($namespace)
	{
		$query = 'objects/nextPID';
		$args = '&numPIDs=1&namespace=' . $namespace;
		$this->args = $args;
		
		$resp = $this->callFedora($query, 'post');

		// quickly cut through the muck
		$str = explode($namespace . ':', $resp);
		$str = explode('<', $str[1]);
		$pid = $str[0];

		return $pid;	
	}

	/**
	 * callFedora - xmlFormatFlag (for response): xml, html, 0 = neither
	 */
	function callFedora($query, $flagPostGet = 'get', $xmlFormatFlag = 'xml', $flagAdd = '')
	{
		$ch = curl_init();
		
		$url = self::FEDORA_HOST; // 'http://172.16.17.197:8080/fedora/'
	
		$arg = $url . $query;
		
		if ($xmlFormatFlag == 'xml') {
			 $arg .= '?format=xml';
		} else if ($xmlFormatFlag == 'html') {
			 $arg .= '?format=html';
		}

		if ($this->args) {
			$arg .=  $this->args;
		}

		curl_setopt($ch, CURLOPT_URL,            $arg);
		curl_setopt($ch, CURLOPT_HEADER,         false);
		//curl_setopt($ch, CURLOPT_HEADER,         true);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		
		if ($flagPostGet == 'post') {
			curl_setopt($ch, CURLOPT_POST,           true);
		}
		if ($flagAdd == 'add') {
			curl_setopt ($ch, CURLOPT_HTTPHEADER, Array('Content-Type: text/xml'));
			$postflds['key'] = 'data-binary';
			$postflds['file'] = '@'.self::FEDORA_FOX_XML_DATA;
			curl_setopt($ch, CURLOPT_POSTFIELDS, $postflds);
		}
		
		curl_setopt($ch, CURLINFO_HEADER_OUT,    true);
		curl_setopt($ch, CURLOPT_USERPWD,    'fedoraAdmin' . ':' . 'fedoraAdmin');
	
		$resp = curl_exec($ch);
		
		$httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE); 
		
		curl_close($ch);
		
		return $resp;	
	}

	/**
	 * save - 
	 */
	function save($str)
	{
		$fp = fopen(self::FEDORA_TEMP_DATA, 'w');
	
		if ($fp) {
			fputs ($fp, $str);
			fclose ($fp);
		}
	}
	
	/**
	 * saveFoxFiles - 
	 */
	function saveFoxFiles($xml)
	{
		$fp = fopen(self::FEDORA_FOX_XML_DATA, 'w');
	
		if ($fp) {
			fputs ($fp, $xml);
			fclose ($fp);
		}
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
