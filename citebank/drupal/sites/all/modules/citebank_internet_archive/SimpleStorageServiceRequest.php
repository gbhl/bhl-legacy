<?php
// $Id: SimpleStorageServiceRequest.php,v 1.0.0.0 2011/01/18 4:44:44 dlheskett $

/** SimpleStorageServiceRequest class
 *
 * Copyright (c) 2010-2011 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 01/19/2011
 *
 */

/*

derived and based upon an Amazon S3 class by

http://undesigned.org.za/
Donovan Schönknecht
15 AUG 2009

http://undesigned.org.za/2007/10/22/amazon-s3-php-class
This class is a standalone Amazon S3 REST implementation for PHP 5.2.x (using 
CURL), that supports large file uploads and doesn't require PEAR.

Modified by David L. Heskett
changes structure by splitting out objects
standardize formatting
made Internet Archive specific, removed Amazon refd bits

*/

$includePath = dirname(__FILE__) . '/';
require_once($includePath . 'S3Keys.php');

/** 
 * class SimpleStorageServiceRequest - Simple Storage Service (S3)
 * 
 */
class SimpleStorageServiceRequest
{
	public $className;
  public $accessKey; // AWS Access key
  public $secretKey; // AWS Secret key
	
	public $fp       = false;
	public $size     = 0;
	public $data     = false;
	public $response;
	public $useSSL   = false;

	private $verb       = '';
	private $bucket     = '';
	private $uri        = '';
	private $resource   = '';
	private $parameters = array();
	private $amzHeaders = array();
	private $headers    = array( 'Host' => '', 'Date' => '', 'Content-MD5' => '', 'Content-Type' => '' );
	
	const HOST_TARGET_BASE       = 's3.us.archive.org';
	const HOST_TARGET_DEFAULT    = 's3.us.archive.org';
	const HOST_TARGET_CLOUD      = 'cloudfront.us.archive.org';
	const CLASS_NAME      = 'SimpleStorageServiceRequest';

	const ACCESS_KEY    = S3_ACCESS_KEY;  // S3 Access key
	const SECRET_KEY    = S3_SECRET_KEY;  // S3 Secret key

	/**
	* Constructor
	*
	*/
	function __construct()
	{
		$this->accessKey = self::ACCESS_KEY;
		$this->secretKey = self::SECRET_KEY;
	}

	/**
	* S3Request
	*
	* @param string $verb Verb
	* @param string $bucket Bucket name
	* @param string $uri Object URI
	* @return mixed
	*/
	function S3Request($verb, $bucket = '', $uri = '', $defaultHost = self::HOST_TARGET_BASE)
	{
		$this->verb = $verb;
		$this->bucket = strtolower($bucket);
		$this->uri = (($uri !== '') ? '/'.str_replace('%2F', '/', rawurlencode($uri)) : '/');
		
		if ($this->bucket !== '') {
			$this->headers['Host'] = $this->bucket . '.' . $defaultHost;
			$this->resource = '/' . $this->bucket . $this->uri;
		} else {
			$this->headers['Host'] = $defaultHost;
			$this->resource = $this->uri;
		}

		$this->headers['Date'] = gmdate('D, d M Y H:i:s T');

		$this->response = new STDClass;
		$this->response->error = false;
		
		return $this;
	}

	/**
	* Set request parameter
	*
	* @param string $key Key
	* @param string $value Value
	* @return void
	*/
	public function setParameter($key, $value)
	{
		$this->parameters[$key] = $value;
	}

	/**
	* setUseSSL - Set request parameter
	*
	* @param string $flag true or false
	* @return void
	*/
	public function setUseSSL($flag)
	{
		$this->useSSL = $flag;
	}

	/**
	* Set request header
	*
	* @param string $key Key
	* @param string $value Value
	* @return void
	*/
	public function setHeader($key, $value)
	{
		$this->headers[$key] = $value;
	}

	/**
	* Set x-amz-meta-* header
	*
	* @param string $key Key
	* @param string $value Value
	* @return void
	*/
	public function setAmzHeader($key, $value)
	{
		$this->amzHeaders[$key] = $value;
	}

	/**
	* Generate the auth string: "AWS AccessKey:Signature"
	*
	* @internal Used by S3Request::getResponse()
	* @param string $string String to sign
	* @return string
	*/
	public function setAccessKeys($accessKey, $secretKey) 
	{
		$this->accessKey = $accessKey;
		$this->secretKey = $secretKey;
	}

	/**
	* Generate the auth string: "AWS AccessKey:Signature"
	*
	* @internal Used by S3Request::getResponse()
	* @param string $string String to sign
	* @return string
	*/
	public function getSignature($string) 
	{
		//$signature = 'AWS ' . $this->accessKey . ':' . $this->getHash($string);
		$signature = 'LOW ' . $this->accessKey . ':' . $this->secretKey;  // this is how IA rolls

		return $signature;
	}

	/**
	* Creates a HMAC-SHA1 hash
	*/
	public function useHashMac($string)
	{
		$hashHmac = hash_hmac('sha1', $string, $this->secretKey, true);
		
		return $hashHmac;
	}

	/**
	* Creates a HMAC-SHA1 hash
	*/
	public function usePackHash($string)
	{
		$packedStr = pack('H*', sha1((str_pad($this->secretKey, 64, chr(0x00)) ^ (str_repeat(chr(0x5c), 64))) . pack('H*', sha1((str_pad($this->secretKey, 64, chr(0x00)) ^ (str_repeat(chr(0x36), 64))) . $string))));

		return $packedStr;
	}

	/**
	* Creates a HMAC-SHA1 hash
	*
	* This uses the hash extension if loaded
	*
	* @internal Used by __getSignature()
	* @param string $string String to sign
	* @return string
	*/
	private function getHash($string) 
	{
		$str = (extension_loaded('hash') ?  $this->useHashMac($string) : $this->usePackHash($string));

		$hash = base64_encode($str);
		
		return $hash;
	}

	/**
	* Get the S3 response
	*
	* @return object | false
	*/
	public function getResponse()
	{
		$query = '';
		
		if (sizeof($this->parameters) > 0) {
			$query = (substr($this->uri, -1) !== '?' ? '?' : '&');
			
			foreach ($this->parameters as $var => $value) {
				if ($value == null || $value == '') {
					$query .= $var.'&';
				// Parameters should be encoded (thanks Sean O'Dea) 
				} else {
					$query .= $var.'='.rawurlencode($value).'&';
				}
			}

			$query = substr($query, 0, -1);
			$this->uri .= $query;
		
			if (array_key_exists('acl', $this->parameters) ||
						array_key_exists('location', $this->parameters) ||
						array_key_exists('torrent', $this->parameters) ||
						array_key_exists('logging', $this->parameters)) {
						
				$this->resource .= $query;
			}
		}
		
		$url = (($this->useSSL && extension_loaded('openssl')) ? 'https://' : 'http://' ) . $this->headers['Host'] . $this->uri;
		//var_dump($this->bucket, $this->uri, $this->resource, $url);
		
		// Basic setup
		$curl = curl_init();

		curl_setopt($curl, CURLOPT_USERAGENT, 'CiteBank/php');
		
		if ($this->useSSL) {
			curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 1);
			curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 1);
		}
		
		curl_setopt($curl, CURLOPT_URL, $url);
		
		// Headers
		$headers = array(); 
		$amz = array();
		
		foreach ($this->amzHeaders as $header => $value) {
			if (strlen($value) > 0) {
				$headers[] = $header . ': ' . $value;
			}
		}
			
		foreach ($this->headers as $header => $value) {
			if (strlen($value) > 0) {
				$headers[] = $header . ': ' . $value;
			}
		}
		
		// Collect AMZ headers for signature
		foreach ($this->amzHeaders as $header => $value) {
			if (strlen($value) > 0) {
				$amz[] = strToLower($header) . ':' . $value;
			}
		}
		
		// AMZ headers must be sorted
		if (sizeof($amz) > 0) {
			sort($amz);
			$amz = "\n" . implode("\n", $amz);
		} else {
			$amz = '';
		}
		
		// Authorization string (CloudFront stringToSign should only contain a date)
		//$headers[] = 'Authorization: ' . $this->getSignature( ($this->headers['Host'] == 'cloudfront.amazonaws.com' ? $this->headers['Date'] : $this->verb . "\n" . $this->headers['Content-MD5'] . "\n". $this->headers['Content-Type'] . "\n" . $this->headers['Date'] . $amz . "\n" . $this->resource) );

		$getSignatureHeader = $this->verb . "\n" . $this->headers['Content-MD5'] . "\n". $this->headers['Content-Type'] . "\n" . $this->headers['Date'] . $amz . "\n" . $this->resource;
		$headers[] = 'Authorization: ' . $this->getSignature($getSignatureHeader);

		curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($curl, CURLOPT_HEADER, false);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, false);
		curl_setopt($curl, CURLOPT_WRITEFUNCTION, array(&$this, '__responseWriteCallback'));
		curl_setopt($curl, CURLOPT_HEADERFUNCTION, array(&$this, '__responseHeaderCallback'));
		curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);

		// Request types
		switch ($this->verb) 
		{
			case 'GET': 
				break;
				
			case 'PUT': 
			case 'POST': // POST only used for CloudFront
				if ($this->fp !== false) {
					curl_setopt($curl, CURLOPT_PUT, true);
					curl_setopt($curl, CURLOPT_INFILE, $this->fp);

					if ($this->size > 0) {
						curl_setopt($curl, CURLOPT_INFILESIZE, $this->size);
					}
				} elseif ($this->data !== false) {
					
					curl_setopt($curl, CURLOPT_CUSTOMREQUEST, $this->verb);
					curl_setopt($curl, CURLOPT_POSTFIELDS, $this->data);

					if ($this->size > 0) {
						curl_setopt($curl, CURLOPT_BUFFERSIZE, $this->size);
					}
				} else {
					curl_setopt($curl, CURLOPT_CUSTOMREQUEST, $this->verb);
				}

				break;

			case 'HEAD':
				curl_setopt($curl, CURLOPT_CUSTOMREQUEST, 'HEAD');
				curl_setopt($curl, CURLOPT_NOBODY, true);
				break;
				
			case 'DELETE':
				curl_setopt($curl, CURLOPT_CUSTOMREQUEST, 'DELETE');
				break;
				
			default: 
				break;
		}

		// Execute, grab errors
		if (curl_exec($curl)) {
			$this->response->code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
		} else {
			$this->response->error = array( 'code' => curl_errno($curl), 'message' => curl_error($curl), 'resource' => $this->resource);
		}
		
		@curl_close($curl);
		
		// Parse body into XML
		if ($this->response->error === false && isset($this->response->headers['type']) && $this->response->headers['type'] == 'application/xml' && isset($this->response->body)) {
			$this->response->body = simplexml_load_string($this->response->body);
		
			// Grab S3 errors
			if (!in_array($this->response->code, array(200, 204)) && isset($this->response->body->Code, $this->response->body->Message)) {
				$this->response->error = array( 'code' => (string)$this->response->body->Code, 'message' => (string)$this->response->body->Message );

				if (isset($this->response->body->Resource)) {
					$this->response->error['resource'] = (string)$this->response->body->Resource;
				}
				
				unset($this->response->body);
			}
		}
		
		// Clean up file resources
		if ($this->fp !== false && is_resource($this->fp)) {
			fclose($this->fp);
		}
		
		return $this->response;
	}

	/**
	* CURL write callback
	*
	* @param resource &$curl CURL resource
	* @param string &$data Data
	* @return integer
	*/
	private function __responseWriteCallback(&$curl, &$data)
	{
		if ($this->response->code == 200 && $this->fp !== false) {
			return fwrite($this->fp, $data);
		} else {
			$this->response->body .= $data;
		}
		
		return strlen($data);
	}

	/**
	* CURL header callback
	*
	* @param resource &$curl CURL resource
	* @param string &$data Data
	* @return integer
	*/
	private function __responseHeaderCallback(&$curl, &$data)
	{
		if (($strlen = strlen($data)) <= 2) {
			return $strlen;
		}
		
		if (substr($data, 0, 4) == 'HTTP') {
			$this->response->code = (int)substr($data, 9, 3);
		} else {
			list($header, $value) = explode(': ', trim($data), 2);

			if ($header == 'Last-Modified') {
				$this->response->headers['time'] = strtotime($value);
				
			} elseif ($header == 'Content-Length') {
				$this->response->headers['size'] = (int)$value;
				
			} elseif ($header == 'Content-Type') {
				$this->response->headers['type'] = $value;
				
			} elseif ($header == 'ETag') {
				$this->response->headers['hash'] = ( ($value{0} == '"') ? substr($value, 1, -1) : $value );
				
			//} elseif (preg_match('/^x-amz-meta-.*$/', $header)) {
			} elseif (preg_match('/^x-archive-meta-.*$/', $header)) {
				$this->response->headers[$header] = ( is_numeric($value) ? (int)$value : $value );
			}
		}

		return $strlen;
	}

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
