<?php
// $Id: SimpleStorageServiceModel.php,v 1.0.0.0 2011/01/18 4:44:44 dlheskett $

/** SimpleStorageServiceModel class
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
require_once($includePath . 'SimpleStorageServiceRequest.php');

/** 
 * class SimpleStorageServiceModel - Simple Storage Service (S3)
 * 
 */
class SimpleStorageServiceModel
{
	public $className;
	private $verb       = '';
	private $bucket     = '';
	private $uri        = '';
	private $resource   = '';
	private $parameters = array();
	private $amzHeaders = array();
	private $headers    = array( 'Host' => '', 'Date' => '', 'Content-MD5' => '', 'Content-Type' => '' );
  public $accessKey; // AWS Access key
  public $secretKey; // AWS Secret key
  
  public $s3obj;
	
	public $fp = false;
	public $size = 0;
	public $data = false;
	public $response;
	public $useSSL = false;
	
	const CLASS_NAME    = 'SimpleStorageServiceModel';
	const HOST_TARGET_BASE       = 's3.us.archive.org';
	const HOST_TARGET_DEFAULT    = 's3.us.archive.org';
	const HOST_TARGET_CLOUD      = 'cloudfront.us.archive.org';

	// ACL flags
	// Note: Internet Archive - ACLs are fake. permissions are: World readable, Item uploader writable.
	const ACL_PRIVATE            = 'private';
	const ACL_PUBLIC_READ        = 'public-read';
	const ACL_PUBLIC_READ_WRITE  = 'public-read-write';
	const ACL_AUTHENTICATED_READ = 'authenticated-read';

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
	* Set AWS access key and secret key
	*
	* @param string $accessKey Access key
	* @param string $secretKey Secret key
	* @return void
	*/
	public function setAuth($accessKey, $secretKey) 
	{
		self::$accessKey = $accessKey;
		self::$secretKey = $secretKey;
	}

	/**
	 * setS3Obj - 
	 */
	public function setS3Obj($s3obj)
	{
		$this->s3obj = $s3obj;
	}

	/**
	* Get a list of buckets
	*
	* @param boolean $detailed Returns detailed bucket list when true
	* @return array | false
	*/
	public function listBuckets($detailed = false)
	{
		$rest = $this->s3obj->S3Request('GET', '', '');

		$rest = $rest->getResponse();

		if ($rest->error === false && $rest->code !== 200) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::listBuckets(): [%s] %s", $rest->error['code'], $rest->error['message']), E_USER_WARNING);
			return false;
		}

		$results = array();

		if (!isset($rest->body->Buckets)) {
			return $results;
		}

		if ($detailed) {
			if (isset($rest->body->Owner, $rest->body->Owner->ID, $rest->body->Owner->DisplayName)) {
				$results['owner'] = array('id' => (string)$rest->body->Owner->ID, 'name' => (string)$rest->body->Owner->ID);
			}
			
			$results['buckets'] = array();
			
			foreach ($rest->body->Buckets->Bucket as $b) {
				$results['buckets'][] = array(
					'name' => (string)$b->Name, 'time' => strtotime((string)$b->CreationDate)
				);
			}
		} else {
			foreach ($rest->body->Buckets->Bucket as $b) {
				$results[] = (string)$b->Name;
			}
		}

		return $results;
	}

	/*
	* Get contents for a bucket
	*
	* If maxKeys is null this method will loop through truncated result sets
	*
	* @param string $bucket Bucket name
	* @param string $prefix Prefix
	* @param string $marker Marker (last file listed)
	* @param string $maxKeys Max keys (maximum number of keys to return)
	* @param string $delimiter Delimiter
	* @param boolean $returnCommonPrefixes Set to true to return CommonPrefixes
	* @return array | false
	*/
	public function getBucket($bucket, $prefix = null, $marker = null, $maxKeys = null, $delimiter = null, $returnCommonPrefixes = false)
	{
		$rest = $this->s3obj->S3Request('GET', $bucket, '');
		
		if ($prefix !== null && $prefix !== '') {
			$rest->setParameter('prefix', $prefix);
		}
		
		if ($marker !== null && $marker !== '') {
		 $rest->setParameter('marker', $marker);
		}
		
		if ($maxKeys !== null && $maxKeys !== '') {
			$rest->setParameter('max-keys', $maxKeys);
		}
		
		if ($delimiter !== null && $delimiter !== '') {
			$rest->setParameter('delimiter', $delimiter);
		}
		
		$response = $rest->getResponse();
		
		if ($response->error === false && $response->code !== 200) {
			$response->error = array('code' => $response->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($response->error !== false) {
			trigger_error(sprintf("S3::getBucket(): [%s] %s", $response->error['code'], $response->error['message']), E_USER_WARNING);
			return false;
		}

		$results = array();

		$nextMarker = null;
		
		if (isset($response->body, $response->body->Contents)) {
			foreach ($response->body->Contents as $c) {
				$results[(string)$c->Key] = array(
					'name' => (string)$c->Key,
					'time' => strtotime((string)$c->LastModified),
					'size' => (int)$c->Size,
					'hash' => substr((string)$c->ETag, 1, -1)
				);
				
				$nextMarker = (string)$c->Key;
			}
		}

		if ($returnCommonPrefixes && isset($response->body, $response->body->CommonPrefixes)) {
			foreach ($response->body->CommonPrefixes as $c) {
				$results[(string)$c->Prefix] = array('prefix' => (string)$c->Prefix);
			}
		}

		if (isset($response->body, $response->body->IsTruncated) && (string)$response->body->IsTruncated == 'false') {
			return $results;
		}

		if (isset($response->body, $response->body->NextMarker)) {
			$nextMarker = (string)$response->body->NextMarker;
		}

		// Loop through truncated results if maxKeys isn't specified
		if ($maxKeys == null && $nextMarker !== null && (string)$response->body->IsTruncated == 'true') {
			do {
				$rest = $this->s3obj->S3Request('GET', $bucket, '');
				
				if ($prefix !== null && $prefix !== '') {
					$rest->setParameter('prefix', $prefix);
				}
				
				$rest->setParameter('marker', $nextMarker);
				
				if ($delimiter !== null && $delimiter !== '') {
					$rest->setParameter('delimiter', $delimiter);
				}
	
				if (($response = $rest->getResponse(true)) == false || $response->code !== 200) {
					break;
				}
	
				if (isset($response->body, $response->body->Contents)) {
					foreach ($response->body->Contents as $c) {
						$results[(string)$c->Key] = array(
							'name' => (string)$c->Key,
							'time' => strtotime((string)$c->LastModified),
							'size' => (int)$c->Size,
							'hash' => substr((string)$c->ETag, 1, -1)
						);
						
						$nextMarker = (string)$c->Key;
					}
				}
	
				if ($returnCommonPrefixes && isset($response->body, $response->body->CommonPrefixes)) {
					foreach ($response->body->CommonPrefixes as $c) {
						$results[(string)$c->Prefix] = array('prefix' => (string)$c->Prefix);
					}
				}
	
				if (isset($response->body, $response->body->NextMarker)) {
					$nextMarker = (string)$response->body->NextMarker;
				}
	
			} while ($response !== false && (string)$response->body->IsTruncated == 'true');
		}

		return $results;
	}

	/**
	* Put a bucket
	*
	* @param string $bucket Bucket name
	* @param constant $acl ACL flag
	* @param string $location Set as "EU" to create buckets hosted in Europe
	* @return boolean
	*/
	public function putBucket($bucket, $acl = self::ACL_PUBLIC_READ, $location = false) 
	{
		$rest = $this->s3obj->S3Request('PUT', $bucket, '');
		//$rest->setAmzHeader('x-amz-acl', $acl);
		$rest->setAmzHeader('x-archive-acl', $acl);
		$rest->setHeader('Content-Length', 0);

		if ($location !== false) {
			$dom = new DOMDocument;
			$createBucketConfiguration = $dom->createElement('CreateBucketConfiguration');
			$locationConstraint = $dom->createElement('LocationConstraint', strtoupper($location));
			$createBucketConfiguration->appendChild($locationConstraint);
			$dom->appendChild($createBucketConfiguration);
			$rest->data = $dom->saveXML();
			$rest->size = strlen($rest->data);
			$rest->setHeader('Content-Type', 'application/xml');
		}
		
		$rest = $rest->getResponse();

		if ($rest->error === false && $rest->code !== 200 && $rest->code !== 201) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::putBucket({$bucket}, {$acl}, {$location}): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		return true;
	}

	/**
	* Delete an empty bucket
	*
	* @param string $bucket Bucket name
	* @return boolean
	*/
	public function deleteBucket($bucket) 
	{
		$rest = $this->s3obj->S3Request('DELETE', $bucket);
		$rest = $rest->getResponse();
		
		if ($rest->error === false && $rest->code !== 204) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
			
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::deleteBucket({$bucket}): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		return true;
	}

	/**
	* Create input info array for putObject()
	*
	* @param string $file Input file
	* @param mixed $md5sum Use MD5 hash (supply a string if you want to use your own)
	* @return array | false
	*/
	public function inputFile($file, $md5sum = true) 
	{
		if (!file_exists($file) || !is_file($file) || !is_readable($file)) {
			trigger_error('S3::inputFile(): Unable to open input file: '.$file, E_USER_WARNING);
			
			return false;
		}

		//return array('file' => $file, 'size' => filesize($file), 'md5sum' => $md5sum !== false ? (is_string($md5sum) ? $md5sum : base64_encode(md5_file($file, true))) : '');
		//return array('file' => basename($file), 'size' => filesize($file), 'md5sum' => $md5sum !== false ? (is_string($md5sum) ? $md5sum : base64_encode(md5_file($file, true))) : '');
		return array('file' => $file, 'basefile' => basename($file), 'size' => filesize($file), 'md5sum' => $md5sum !== false ? (is_string($md5sum) ? $md5sum : base64_encode(md5_file($file, true))) : '');
	}

	/**
	* Create input array info for putObject() with a resource
	*
	* @param string $resource Input resource to read from
	* @param integer $bufferSize Input byte size
	* @param string $md5sum MD5 hash to send (optional)
	* @return array | false
	*/
	public function inputResource(&$resource, $bufferSize, $md5sum = '')
	{
		if (!is_resource($resource) || $bufferSize < 0) {
			trigger_error('S3::inputResource(): Invalid resource or buffer size', E_USER_WARNING);
			
			return false;
		}
		
		$input = array('size' => $bufferSize, 'md5sum' => $md5sum);
		$input['fp'] =& $resource;
		
		return $input;
	}

	/**
	* Put an object
	*
	* @param mixed $input Input data
	* @param string $bucket Bucket name
	* @param string $uri Object URI
	* @param constant $acl ACL constant
	* @param array $metaHeaders Array of x-amz-meta-* headers
	* @param array $requestHeaders Array of request headers or content type as a string
	* @return boolean
	*/
	public function putObject($input, $bucket, $uri, $acl = self::ACL_PUBLIC_READ, $metaHeaders = array(), $requestHeaders = array())
	{
//		echo 'input: ' . print_r($input, 1) . '<br>' . "\n"; // FIXME: DEBUG remove
		if ($input === false) {
			return false;
		}

		// have to make new object for this to work, must be collision of some sort.
		//$rest = $this->s3obj->S3Request('PUT', $bucket, $uri);
		$s3obj      = new SimpleStorageServiceRequest();
		$rest = $s3obj->S3Request('PUT', $bucket, $uri);

		if (is_string($input)) {
			$input = array(
				'data' => $input, 'size' => strlen($input),
				'md5sum' => base64_encode(md5($input, true))
			);
		}

		// Data
		if (isset($input['fp'])) {
			$rest->fp =& $input['fp'];
		} elseif (isset($input['file'])) {
			$rest->fp = @fopen($input['file'], 'rb');
		} elseif (isset($input['data'])) {
			$rest->data = $input['data'];
		}

		// Content-Length (required)
		if (isset($input['size']) && $input['size'] >= 0) {
			$rest->size = $input['size'];
		} else {
			if (isset($input['file'])) {
				$rest->size = filesize($input['file']);
			} elseif (isset($input['data'])) {
				$rest->size = strlen($input['data']);
			}
		}

		// Custom request headers (Content-Type, Content-Disposition, Content-Encoding)
		if (is_array($requestHeaders)) {
			foreach ($requestHeaders as $h => $v) {
				$rest->setHeader($h, $v);
			}
		} elseif (is_string($requestHeaders)) { // Support for legacy contentType parameter
			$input['type'] = $requestHeaders;
		}

		// Content-Type
		if (!isset($input['type'])) {
			if (isset($requestHeaders['Content-Type'])) {
				$input['type'] =& $requestHeaders['Content-Type'];
			} elseif (isset($input['file'])) {
				$input['type'] = self::__getMimeType($input['file']);
			} elseif (isset($input['data'])) {  
				/*  dlh: added if string data, (and uri has .pdf as extension) 
						so we should pick up the correct mime type, 
						and bonus, if our uri has diff extensions will be universal */
				$input['type'] = self::__getMimeType($uri);
			} else {
				$input['type'] = 'application/octet-stream';
			}
		}

		// We need to post with Content-Length and Content-Type, MD5 is optional
		if ($rest->size >= 0 && ($rest->fp !== false || $rest->data !== false)) {
			$rest->setHeader('Content-Type', $input['type']);
			
			if (isset($input['md5sum'])) {
				$rest->setHeader('Content-MD5', $input['md5sum']);
			}

			//$rest->setAmzHeader('x-amz-acl', $acl);
			$rest->setAmzHeader('x-archive-acl', $acl);
			
			$rest->setAmzHeader('x-archive-meta-collection', 'citebank');  // DLH FIXME maybe need if we already have metadata there
			$rest->setAmzHeader('x-archive-ignore-preexisting-bucket', '1');  // DLH FIXME maybe need if we already have metadata there
			
			foreach ($metaHeaders as $h => $v) {
				//echo '' . $h . ' ' . $v . '<br>';
				//$rest->setAmzHeader('x-amz-meta-'.$h, $v);
				$h = str_replace('_', '--', $h);
				$rest->setAmzHeader('x-archive-meta-'.$h, $v);
			}
//			echo '<br>***<br>'; echo print_r($rest, 1); echo '<br>****<br>'; 
			$rest->getResponse();
		} else {
			$rest->response->error = array('code' => 0, 'message' => 'Missing input parameters');
		}

		if ($rest->response->error === false && $rest->response->code !== 200 && $rest->response->code !== 201) { // FIXME: 201 is Created, and seems correct, thus excluded from the error.
			$rest->response->error = array('code' => $rest->response->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->response->error !== false) {
			trigger_error(sprintf("S3::putObject(): [%s] %s", $rest->response->error['code'], $rest->response->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		return true;
	}

	/**
	* Put an object from a file (legacy function)
	*
	* @param string $file Input file path
	* @param string $bucket Bucket name
	* @param string $uri Object URI
	* @param constant $acl ACL constant
	* @param array $metaHeaders Array of x-amz-meta-* headers
	* @param string $contentType Content type
	* @return boolean
	*/
	public function putObjectFile($file, $bucket, $uri, $acl = self::ACL_PUBLIC_READ, $metaHeaders = array(), $contentType = null) 
	{
		return self::putObject(self::inputFile($file), $bucket, $uri, $acl, $metaHeaders, $contentType);
	}

	/**
	* Put an object from a string (legacy function)
	*
	* @param string $string Input data
	* @param string $bucket Bucket name
	* @param string $uri Object URI
	* @param constant $acl ACL constant
	* @param array $metaHeaders Array of x-amz-meta-* headers
	* @param string $contentType Content type
	* @return boolean
	*/
	public function putObjectString($string, $bucket, $uri, $acl = self::ACL_PUBLIC_READ, $metaHeaders = array(), $contentType = 'text/plain') 
	{
		return self::putObject($string, $bucket, $uri, $acl, $metaHeaders, $contentType);
	}

	/**
	* Get an object
	*
	* @param string $bucket Bucket name
	* @param string $uri Object URI
	* @param mixed $saveTo Filename or resource to write to
	* @return mixed
	*/
	public function getObject($bucket, $uri, $saveTo = false) 
	{
		$rest = $this->s3obj->S3Request('GET', $bucket, $uri);
		
		if ($saveTo !== false) {
			if (is_resource($saveTo)) {
				$rest->fp =& $saveTo;
			} else {
				if (($rest->fp = @fopen($saveTo, 'wb')) !== false) {
					$rest->file = realpath($saveTo);
				} else {
					$rest->response->error = array('code' => 0, 'message' => 'Unable to open save file for writing: '.$saveTo);
				}
			}
		}
		
		if ($rest->response->error === false) {
			$rest->getResponse();
		}

		if ($rest->response->error === false && $rest->response->code !== 200 && $rest->response->code !== 201) { // FIXME: 201 is Created, and seems correct, thus excluded from the error.
			$rest->response->error = array('code' => $rest->response->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->response->error !== false) {
			trigger_error(sprintf("S3::getObject({$bucket}, {$uri}): [%s] %s",
			$rest->response->error['code'], $rest->response->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		return $rest->response;
	}

	/**
	* Get object information
	*
	* @param string $bucket Bucket name
	* @param string $uri Object URI
	* @param boolean $returnInfo Return response information
	* @return mixed | false
	*/
	public function getObjectInfo($bucket, $uri, $returnInfo = true) 
	{
		$rest = $this->s3obj->S3Request('HEAD', $bucket, $uri);
		$rest = $rest->getResponse();
		
		if ($rest->error === false && ($rest->code !== 200 && $rest->code !== 404)) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::getObjectInfo({$bucket}, {$uri}): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		return $rest->code == 200 ? $returnInfo ? $rest->headers : true : false;
	}

	/**
	* Copy an object
	*
	* @param string $bucket Source bucket name
	* @param string $uri Source object URI
	* @param string $bucket Destination bucket name
	* @param string $uri Destination object URI
	* @param constant $acl ACL constant
	* @param array $metaHeaders Optional array of x-amz-meta-* headers
	* @param array $requestHeaders Optional array of request headers (content type, disposition, etc.)
	* @return mixed | false
	*/
	public function copyObject($srcBucket, $srcUri, $bucket, $uri, $acl = self::ACL_PUBLIC_READ, $metaHeaders = array(), $requestHeaders = array()) 
	{
		$rest = $this->s3obj->S3Request('PUT', $bucket, $uri);
		$rest->setHeader('Content-Length', 0);
		
		foreach ($requestHeaders as $h => $v) {
			$rest->setHeader($h, $v);
		}
		
		foreach ($metaHeaders as $h => $v) {
			//$rest->setAmzHeader('x-amz-meta-'.$h, $v);
			$rest->setAmzHeader('x-archive-meta-'.$h, $v);
		}
		
		//$rest->setAmzHeader('x-amz-acl', $acl);
		//$rest->setAmzHeader('x-amz-copy-source', sprintf('/%s/%s', $srcBucket, $srcUri));
		$rest->setAmzHeader('x-archive-acl', $acl);
		$rest->setAmzHeader('x-archive-copy-source', sprintf('/%s/%s', $srcBucket, $srcUri));
		
		if (sizeof($requestHeaders) > 0 || sizeof($metaHeaders) > 0) {
			//$rest->setAmzHeader('x-amz-metadata-directive', 'REPLACE');
			$rest->setAmzHeader('x-archive-metadata-directive', 'REPLACE');
		}

		$rest = $rest->getResponse();
		
		if ($rest->error === false && $rest->code !== 200) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::copyObject({$srcBucket}, {$srcUri}, {$bucket}, {$uri}): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		return (isset($rest->body->LastModified, $rest->body->ETag) ? array(
				'time' => strtotime((string)$rest->body->LastModified),
				'hash' => substr((string)$rest->body->ETag, 1, -1)
			) : false);
	}

	/**
	* Set logging for a bucket
	*
	* @param string $bucket Bucket name
	* @param string $targetBucket Target bucket (where logs are stored)
	* @param string $targetPrefix Log prefix (e,g; domain.com-)
	* @return boolean
	*/
	public function setBucketLogging($bucket, $targetBucket, $targetPrefix = null) 
	{
		// The S3 log delivery group has to be added to the target bucket's ACP
		if ($targetBucket !== null && ($acp = self::getAccessControlPolicy($targetBucket, '')) !== false) {
			// Only add permissions to the target bucket when they do not exist
			$aclWriteSet = false;
			$aclReadSet = false;
			
			foreach ($acp['acl'] as $acl) {
				if ($acl['type'] == 'Group' && $acl['uri'] == 'http://acs.'.self::HOST_TARGET_BASE.'/groups/s3/LogDelivery') {
					if ($acl['permission'] == 'WRITE') {
						$aclWriteSet = true;
					} elseif ($acl['permission'] == 'READ_ACP') {
						$aclReadSet = true;
					}
				}
				
				if (!$aclWriteSet) {
					$acp['acl'][] = array(
						'type' => 'Group', 'uri' => 'http://acs.'.self::HOST_TARGET_BASE.'/groups/s3/LogDelivery', 'permission' => 'WRITE'
					);
				}
				
				if (!$aclReadSet) {
					$acp['acl'][] = array(
						'type' => 'Group', 'uri' => 'http://acs.'.self::HOST_TARGET_BASE.'/groups/s3/LogDelivery', 'permission' => 'READ_ACP'
					);
				}
				
				if (!$aclReadSet || !$aclWriteSet) {
					self::setAccessControlPolicy($targetBucket, '', $acp);
				}
			}
		}

		$dom = new DOMDocument;
		$bucketLoggingStatus = $dom->createElement('BucketLoggingStatus');
		$bucketLoggingStatus->setAttribute('xmlns', 'http://'.self::HOST_TARGET_BASE.'/doc/2006-03-01/');
		
		if ($targetBucket !== null) {
			if ($targetPrefix == null) {
				$targetPrefix = $bucket . '-';
			}
			
			$loggingEnabled = $dom->createElement('LoggingEnabled');
			$loggingEnabled->appendChild($dom->createElement('TargetBucket', $targetBucket));
			$loggingEnabled->appendChild($dom->createElement('TargetPrefix', $targetPrefix));
			// TODO: Add TargetGrants?
			$bucketLoggingStatus->appendChild($loggingEnabled);
		}
		
		$dom->appendChild($bucketLoggingStatus);

		$rest = $this->s3obj->S3Request('PUT', $bucket, '');
		$rest->setParameter('logging', null);
		$rest->data = $dom->saveXML();
		$rest->size = strlen($rest->data);
		$rest->setHeader('Content-Type', 'application/xml');
		$rest = $rest->getResponse();
		
		if ($rest->error === false && $rest->code !== 200) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
			
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::setBucketLogging({$bucket}, {$uri}): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		return true;
	}

	/**
	* Get logging status for a bucket
	*
	* This will return false if logging is not enabled.
	* Note: To enable logging, you also need to grant write access to the log group
	*
	* @param string $bucket Bucket name
	* @return array | false
	*/
	public function getBucketLogging($bucket) 
	{
		$rest = $this->s3obj->S3Request('GET', $bucket, '');
		$rest->setParameter('logging', null);
		$rest = $rest->getResponse();
		
		if ($rest->error === false && $rest->code !== 200) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
			
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::getBucketLogging({$bucket}): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		if (!isset($rest->body->LoggingEnabled)) {
			return false; // No logging
		}
		
		return array(
			'targetBucket' => (string)$rest->body->LoggingEnabled->TargetBucket,
			'targetPrefix' => (string)$rest->body->LoggingEnabled->TargetPrefix,
		);
	}

	/**
	* Disable bucket logging
	*
	* @param string $bucket Bucket name
	* @return boolean
	*/
	public function disableBucketLogging($bucket) 
	{
		return self::setBucketLogging($bucket, null);
	}

	/**
	* Get a bucket's location
	*
	* @param string $bucket Bucket name
	* @return string | false
	*/
	public function getBucketLocation($bucket) 
	{
		$rest = $this->s3obj->S3Request('GET', $bucket, '');
		$rest->setParameter('location', null);
		$rest = $rest->getResponse();
		
		if ($rest->error === false && $rest->code !== 200) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
			
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::getBucketLocation({$bucket}): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		return (isset($rest->body[0]) && (string)$rest->body[0] !== '') ? (string)$rest->body[0] : 'US';
	}

	/**
	* Set object or bucket Access Control Policy
	*
	* @param string $bucket Bucket name
	* @param string $uri Object URI
	* @param array $acp Access Control Policy Data (same as the data returned from getAccessControlPolicy)
	* @return boolean
	*/
	public function setAccessControlPolicy($bucket, $uri = '', $acp = array()) 
	{
		$dom = new DOMDocument;
		$dom->formatOutput = true;
		$accessControlPolicy = $dom->createElement('AccessControlPolicy');
		$accessControlList = $dom->createElement('AccessControlList');

		// It seems the owner has to be passed along too
		$owner = $dom->createElement('Owner');
		$owner->appendChild($dom->createElement('ID', $acp['owner']['id']));
		$owner->appendChild($dom->createElement('DisplayName', $acp['owner']['name']));
		$accessControlPolicy->appendChild($owner);

		foreach ($acp['acl'] as $g) {
			$grant = $dom->createElement('Grant');
			$grantee = $dom->createElement('Grantee');
			$grantee->setAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
			
			if (isset($g['id'])) { // CanonicalUser (DisplayName is omitted)
				$grantee->setAttribute('xsi:type', 'CanonicalUser');
				$grantee->appendChild($dom->createElement('ID', $g['id']));
				
			} elseif (isset($g['email'])) { // AmazonCustomerByEmail
				$grantee->setAttribute('xsi:type', 'AmazonCustomerByEmail');
				$grantee->appendChild($dom->createElement('EmailAddress', $g['email']));
				
			} elseif ($g['type'] == 'Group') { // Group
				$grantee->setAttribute('xsi:type', 'Group');
				$grantee->appendChild($dom->createElement('URI', $g['uri']));
			}
			
			$grant->appendChild($grantee);
			$grant->appendChild($dom->createElement('Permission', $g['permission']));
			$accessControlList->appendChild($grant);
		}

		$accessControlPolicy->appendChild($accessControlList);
		$dom->appendChild($accessControlPolicy);

		$rest = $this->s3obj->S3Request('PUT', $bucket, $uri);
		$rest->setParameter('acl', null);
		$rest->data = $dom->saveXML();
		$rest->size = strlen($rest->data);
		$rest->setHeader('Content-Type', 'application/xml');
		$rest = $rest->getResponse();
		
		if ($rest->error === false && $rest->code !== 200) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
			
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::setAccessControlPolicy({$bucket}, {$uri}): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		return true;
	}

	/**
	* Get object or bucket Access Control Policy
	*
	* @param string $bucket Bucket name
	* @param string $uri Object URI
	* @return mixed | false
	*/
	public function getAccessControlPolicy($bucket, $uri = '') 
	{
		$rest = $this->s3obj->S3Request('GET', $bucket, $uri);
		$rest->setParameter('acl', null);
		$rest = $rest->getResponse();
		
		if ($rest->error === false && $rest->code !== 200) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::getAccessControlPolicy({$bucket}, {$uri}): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
		}

		$acp = array();
		
		if (isset($rest->body->Owner, $rest->body->Owner->ID, $rest->body->Owner->DisplayName)) {
			$acp['owner'] = array(
				'id' => (string)$rest->body->Owner->ID, 'name' => (string)$rest->body->Owner->DisplayName
			);
		}
		
		if (isset($rest->body->AccessControlList)) {
			$acp['acl'] = array();
			
			foreach ($rest->body->AccessControlList->Grant as $grant) {
				foreach ($grant->Grantee as $grantee) {
					if (isset($grantee->ID, $grantee->DisplayName)) { // CanonicalUser
						$acp['acl'][] = array(
							'type' => 'CanonicalUser',
							'id' => (string)$grantee->ID,
							'name' => (string)$grantee->DisplayName,
							'permission' => (string)$grant->Permission
						);
					} elseif (isset($grantee->EmailAddress)) { // AmazonCustomerByEmail
						$acp['acl'][] = array(
							'type' => 'AmazonCustomerByEmail',
							'email' => (string)$grantee->EmailAddress,
							'permission' => (string)$grant->Permission
						);
					} elseif (isset($grantee->URI)) { // Group
						$acp['acl'][] = array(
							'type' => 'Group',
							'uri' => (string)$grantee->URI,
							'permission' => (string)$grant->Permission
						);
					} else {
						continue;
					}
				}
			}
		}
		
		return $acp;
	}

	/**
	* Delete an object
	*
	* @param string $bucket Bucket name
	* @param string $uri Object URI
	* @return boolean
	*/
	public function deleteObject($bucket, $uri) 
	{
		$rest = $this->s3obj->S3Request('DELETE', $bucket, $uri);
		$rest = $rest->getResponse();
		
		if ($rest->error === false && $rest->code !== 204) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
			
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::deleteObject(): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		return true;
	}

	/**
	* Get a query string authenticated URL
	*
	* @param string $bucket Bucket name
	* @param string $uri Object URI
	* @param integer $lifetime Lifetime in seconds
	* @param boolean $hostBucket Use the bucket name as the hostname
	* @param boolean $https Use HTTPS ($hostBucket should be false for SSL verification)
	* @return string
	*/
	public function getAuthenticatedURL($bucket, $uri, $lifetime, $hostBucket = false, $https = false) 
	{
		$expires = time() + $lifetime;
		$uri = str_replace('%2F', '/', rawurlencode($uri)); // URI should be encoded (thanks Sean O'Dea)
		
		return sprintf(($https ? 'https' : 'http').'://%s/%s?AWSAccessKeyId=%s&Expires=%u&Signature=%s',
		$hostBucket ? $bucket : $bucket.self::HOST_TARGET_BASE, $uri, self::$accessKey, $expires,
		urlencode(self::__getHash("GET\n\n\n{$expires}\n/{$bucket}/{$uri}")));
	}

	/**
	* Get upload POST parameters for form uploads
	*
	* @param string $bucket Bucket name
	* @param string $uriPrefix Object URI prefix
	* @param constant $acl ACL constant
	* @param integer $lifetime Lifetime in seconds
	* @param integer $maxFileSize Maximum filesize in bytes (default 5MB)
	* @param string $successRedirect Redirect URL or 200 / 201 status code
	* @param array $amzHeaders Array of x-amz-meta-* headers
	* @param array $headers Array of request headers or content type as a string
	* @param boolean $flashVars Includes additional "Filename" variable posted by Flash
	* @return object
	*/
	public function getHttpUploadPostParams($bucket, $uriPrefix = '', $acl = self::ACL_PUBLIC_READ, $lifetime = 3600, $maxFileSize = 5242880, $successRedirect = "201", $amzHeaders = array(), $headers = array(), $flashVars = false) 
	{
		// Create policy object
		$policy = new stdClass;
		$policy->expiration = gmdate('Y-m-d\TH:i:s\Z', (time() + $lifetime));
		$policy->conditions = array();
		
		$obj = new stdClass;
		$obj->bucket = $bucket;
		array_push($policy->conditions, $obj);
		
		$obj = new stdClass;
		$obj->acl = $acl;
		array_push($policy->conditions, $obj);

		$obj = new stdClass; // 200 for non-redirect uploads
		
		if (is_numeric($successRedirect) && in_array((int)$successRedirect, array(200, 201))) {
			$obj->success_action_status = (string)$successRedirect;
		} else { // URL
			$obj->success_action_redirect = $successRedirect;
		}
		
		array_push($policy->conditions, $obj);

		array_push($policy->conditions, array('starts-with', '$key', $uriPrefix));
		
		if ($flashVars) {
			array_push($policy->conditions, array('starts-with', '$Filename', ''));
		}
		
		foreach (array_keys($headers) as $headerKey) {
			array_push($policy->conditions, array('starts-with', '$'.$headerKey, ''));
		}
		
		foreach ($amzHeaders as $headerKey => $headerVal) {
			$obj = new stdClass;
			$obj->{$headerKey} = (string)$headerVal;
			array_push($policy->conditions, $obj);
		}
		
		array_push($policy->conditions, array('content-length-range', 0, $maxFileSize));
		
		$policy = base64_encode(str_replace('\/', '/', json_encode($policy)));
	
		// Create parameters
		$params = new stdClass;
		$params->AWSAccessKeyId = self::$accessKey;
		$params->key = $uriPrefix.'${filename}';
		$params->acl = $acl;
		$params->policy = $policy; 
		unset($policy);
		$params->signature = self::__getHash($params->policy);
		
		if (is_numeric($successRedirect) && in_array((int)$successRedirect, array(200, 201))) {
			$params->success_action_status = (string)$successRedirect;
		} else {
			$params->success_action_redirect = $successRedirect;
		}
		
		foreach ($headers as $headerKey => $headerVal) {
			$params->{$headerKey} = (string)$headerVal;
		}
		
		foreach ($amzHeaders as $headerKey => $headerVal) {
			$params->{$headerKey} = (string)$headerVal;
		}
		
		return $params;
	}

	/**
	* Create a CloudFront distribution
	*
	* @param string $bucket Bucket name
	* @param boolean $enabled Enabled (true/false)
	* @param array $cnames Array containing CNAME aliases
	* @param string $comment Use the bucket name as the hostname
	* @return array | false
	*/
	public function createDistribution($bucket, $enabled = true, $cnames = array(), $comment = '') 
	{
		self::$useSSL = true; // CloudFront requires SSL
		
		$rest = $this->s3obj->S3Request('POST', '', '2008-06-30/distribution', self::HOST_TARGET_CLOUD);
		$rest->data = self::__getCloudFrontDistributionConfigXML($bucket.self::HOST_TARGET_BASE, $enabled, $comment, (string)microtime(true), $cnames);
		$rest->size = strlen($rest->data);
		$rest->setHeader('Content-Type', 'application/xml');
		$rest = self::__getCloudFrontResponse($rest);

		if ($rest->error === false && $rest->code !== 201) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::createDistribution({$bucket}, ".(int)$enabled.", '$comment'): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
			
		} elseif ($rest->body instanceof SimpleXMLElement) {
			return self::__parseCloudFrontDistributionConfig($rest->body);
		}
		
		return false;
	}

	/**
	* Get CloudFront distribution info
	*
	* @param string $distributionId Distribution ID from listDistributions()
	* @return array | false
	*/
	public function getDistribution($distributionId) 
	{
		self::$useSSL = true; // CloudFront requires SSL
		
		$rest = $this->s3obj->S3Request('GET', '', '2008-06-30/distribution/'.$distributionId, self::HOST_TARGET_CLOUD);
		$rest = self::__getCloudFrontResponse($rest);

		if ($rest->error === false && $rest->code !== 200) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::getDistribution($distributionId): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);

			return false;
			
		} elseif ($rest->body instanceof SimpleXMLElement) {
			$dist = self::__parseCloudFrontDistributionConfig($rest->body);
			$dist['hash'] = $rest->headers['hash'];

			return $dist;
		}
		
		return false;
	}

	/**
	* Update a CloudFront distribution
	*
	* @param array $dist Distribution array info identical to output of getDistribution()
	* @return array | false
	*/
	public function updateDistribution($dist) 
	{
		self::$useSSL = true; // CloudFront requires SSL
		
		$rest = $this->s3obj->S3Request('PUT', '', '2008-06-30/distribution/'.$dist['id'].'/config', self::HOST_TARGET_CLOUD);
		$rest->data = self::__getCloudFrontDistributionConfigXML($dist['origin'], $dist['enabled'], $dist['comment'], $dist['callerReference'], $dist['cnames']);
		$rest->size = strlen($rest->data);
		$rest->setHeader('If-Match', $dist['hash']);
		$rest = self::__getCloudFrontResponse($rest);

		if ($rest->error === false && $rest->code !== 200) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::updateDistribution({$dist['id']}, ".(int)$enabled.", '$comment'): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
			
		} else {
			$dist = self::__parseCloudFrontDistributionConfig($rest->body);
			$dist['hash'] = $rest->headers['hash'];
			
			return $dist;
		}
		
		return false;
	}

	/**
	* Delete a CloudFront distribution
	*
	* @param array $dist Distribution array info identical to output of getDistribution()
	* @return boolean
	*/
	public function deleteDistribution($dist) 
	{
		self::$useSSL = true; // CloudFront requires SSL
		
		$rest = $this->s3obj->S3Request('DELETE', '', '2008-06-30/distribution/'.$dist['id'], self::HOST_TARGET_CLOUD);
		$rest->setHeader('If-Match', $dist['hash']);
		$rest = self::__getCloudFrontResponse($rest);

		if ($rest->error === false && $rest->code !== 204) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::deleteDistribution({$dist['id']}): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
		}
		
		return true;
	}

	/**
	* Get a list of CloudFront distributions
	*
	* @return array
	*/
	public function listDistributions() 
	{
		self::$useSSL = true; // CloudFront requires SSL
		
		$rest = $this->s3obj->S3Request('GET', '', '2008-06-30/distribution', self::HOST_TARGET_CLOUD);
		$rest = self::__getCloudFrontResponse($rest);

		if ($rest->error === false && $rest->code !== 200) {
			$rest->error = array('code' => $rest->code, 'message' => 'Unexpected HTTP status');
		}
		
		if ($rest->error !== false) {
			trigger_error(sprintf("S3::listDistributions(): [%s] %s",
			$rest->error['code'], $rest->error['message']), E_USER_WARNING);
			
			return false;
			
		} elseif ($rest->body instanceof SimpleXMLElement && isset($rest->body->DistributionSummary)) {
			$list = array();
			
			if (isset($rest->body->Marker, $rest->body->MaxItems, $rest->body->IsTruncated)) {
				//$info['marker'] = (string)$rest->body->Marker;
				//$info['maxItems'] = (int)$rest->body->MaxItems;
				//$info['isTruncated'] = (string)$rest->body->IsTruncated == 'true' ? true : false;
			}
			
			foreach ($rest->body->DistributionSummary as $summary) {
				$list[(string)$summary->Id] = self::__parseCloudFrontDistributionConfig($summary);
			}
			
			return $list;
		}
		
		return array();
	}

	/**
	* Get a DistributionConfig DOMDocument
	*
	* @internal Used to create XML in createDistribution() and updateDistribution()
	* @param string $bucket Origin bucket
	* @param boolean $enabled Enabled (true/false)
	* @param string $comment Comment to append
	* @param string $callerReference Caller reference
	* @param array $cnames Array of CNAME aliases
	* @return string
	*/
	private function __getCloudFrontDistributionConfigXML($bucket, $enabled, $comment, $callerReference = '0', $cnames = array()) 
	{
		$dom = new DOMDocument('1.0', 'UTF-8');
		
		$dom->formatOutput = true;
		
		$distributionConfig = $dom->createElement('DistributionConfig');
		$distributionConfig->setAttribute('xmlns', 'http://'.self::HOST_TARGET_CLOUD.'/doc/2008-06-30/');
		$distributionConfig->appendChild($dom->createElement('Origin', $bucket));
		$distributionConfig->appendChild($dom->createElement('CallerReference', $callerReference));
		
		foreach ($cnames as $cname) {
			$distributionConfig->appendChild($dom->createElement('CNAME', $cname));
		}
			
		if ($comment !== '') {
			$distributionConfig->appendChild($dom->createElement('Comment', $comment));
		}
		
		$distributionConfig->appendChild($dom->createElement('Enabled', $enabled ? 'true' : 'false'));
		$dom->appendChild($distributionConfig);
		
		return $dom->saveXML();
	}

	/**
	* Parse a CloudFront distribution config
	*
	* @internal Used to parse the CloudFront DistributionConfig node to an array
	* @param object &$node DOMNode
	* @return array
	*/
	private function __parseCloudFrontDistributionConfig(&$node) 
	{
		$dist = array();
		
		if (isset($node->Id, $node->Status, $node->LastModifiedTime, $node->DomainName)) {
			$dist['id'] = (string)$node->Id;
			$dist['status'] = (string)$node->Status;
			$dist['time'] = strtotime((string)$node->LastModifiedTime);
			$dist['domain'] = (string)$node->DomainName;
		}
		
		if (isset($node->CallerReference)) {
			$dist['callerReference'] = (string)$node->CallerReference;
		}
		
		if (isset($node->Comment)) {
			$dist['comment'] = (string)$node->Comment;
		}
		
		if (isset($node->Enabled, $node->Origin)) {
			$dist['origin'] = (string)$node->Origin;
			$dist['enabled'] = (string)$node->Enabled == 'true' ? true : false;
			
		} elseif (isset($node->DistributionConfig)) {
			$dist = array_merge($dist, self::__parseCloudFrontDistributionConfig($node->DistributionConfig));
		}
		
		if (isset($node->CNAME)) {
			$dist['cnames'] = array();
			
			foreach ($node->CNAME as $cname) {
				$dist['cnames'][(string)$cname] = (string)$cname;
			}
		}
		
		return $dist;
	}

	/**
	* Grab CloudFront response
	*
	* @internal Used to parse the CloudFront S3Request::getResponse() output
	* @param object &$rest S3Request instance
	* @return object
	*/
	private function __getCloudFrontResponse(&$rest) 
	{
		$rest->getResponse();
		
		if ($rest->response->error === false && isset($rest->response->body) && is_string($rest->response->body) && substr($rest->response->body, 0, 5) == '<?xml') {

			$rest->response->body = simplexml_load_string($rest->response->body);

			// Grab CloudFront errors
			if (isset($rest->response->body->Error, $rest->response->body->Error->Code, $rest->response->body->Error->Message)) {
				$rest->response->error = array(
					'code' => (string)$rest->response->body->Error->Code,
					'message' => (string)$rest->response->body->Error->Message
				);
				
				unset($rest->response->body);
			}
		}
		
		return $rest->response;
	}

	/**
	* Get MIME type for file
	*
	* @internal Used to get mime types
	* @param string &$file File path
	* @return string
	*/
	public function __getMimeType(&$file) 
	{
		$type = false;
		
		// Fileinfo documentation says fileinfo_open() will use the
		// MAGIC env var for the magic file
		if (extension_loaded('fileinfo') && isset($_ENV['MAGIC']) && 
			($finfo = finfo_open(FILEINFO_MIME, $_ENV['MAGIC'])) !== false) {

			if (($type = finfo_file($finfo, $file)) !== false) {
				// Remove the charset and grab the last content-type
				$type = explode(' ', str_replace('; charset=', ';charset=', $type));
				$type = array_pop($type);
				$type = explode(';', $type);
				$type = trim(array_shift($type));
			}
			
			finfo_close($finfo);

		// If anyone is still using mime_content_type()
		} elseif (function_exists('mime_content_type')) {
			$type = trim(mime_content_type($file));
		}

		if ($type !== false && strlen($type) > 0) {
			return $type;
		}

		// Otherwise do it the old fashioned way
		static $exts = array(
			'jpg' => 'image/jpeg', 'gif' => 'image/gif', 'png' => 'image/png',
			'tif' => 'image/tiff', 'tiff' => 'image/tiff', 'ico' => 'image/x-icon',
			'swf' => 'application/x-shockwave-flash', 'pdf' => 'application/pdf',
			'zip' => 'application/zip', 'gz' => 'application/x-gzip',
			'tar' => 'application/x-tar', 'bz' => 'application/x-bzip',
			'bz2' => 'application/x-bzip2', 'txt' => 'text/plain',
			'asc' => 'text/plain', 'htm' => 'text/html', 'html' => 'text/html',
			'css' => 'text/css', 'js' => 'text/javascript',
			'xml' => 'text/xml', 'xsl' => 'application/xsl+xml',
			'ogg' => 'application/ogg', 'mp3' => 'audio/mpeg', 'wav' => 'audio/x-wav',
			'avi' => 'video/x-msvideo', 'mpg' => 'video/mpeg', 'mpeg' => 'video/mpeg',
			'mov' => 'video/quicktime', 'flv' => 'video/x-flv', 'php' => 'text/x-php'
		);
		
		$ext = strtolower(pathInfo($file, PATHINFO_EXTENSION));
		
		return isset($exts[$ext]) ? $exts[$ext] : 'application/octet-stream';
	}

	/**
	* Generate the auth string: "AWS AccessKey:Signature"
	*
	* @internal Used by S3Request::getResponse()
	* @param string $string String to sign
	* @return string
	*/
	public function __getSignature($string) 
	{
		//return 'AWS '.self::$accessKey.':'.self::__getHash($string);
		return 'LOW '.$this->accessKey.':'.$this->secretKey;
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
	private function __getHash($string) 
	{
		return base64_encode(extension_loaded('hash') ?
			hash_hmac('sha1', $string, self::$secretKey, true) : pack('H*', sha1(
			(str_pad(self::$secretKey, 64, chr(0x00)) ^ (str_repeat(chr(0x5c), 64))) .
			pack('H*', sha1((str_pad(self::$secretKey, 64, chr(0x00)) ^
			(str_repeat(chr(0x36), 64))) . $string)))));
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
