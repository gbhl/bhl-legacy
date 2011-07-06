<?php
// $Id: Attribution.php,v 1.0.0.0 2010/09/15 4:44:44 dlheskett $

/** Attribution class - handles entry of specific sourcing info.
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/15/2010
 *
 */

/** 
 * class Attribution - biblio class object to handle source to biblio identification
 * 
 */
class Attribution
{
	/**
	 * _construct - constructor
	 */
	function __construct()
	{
	}

	/**
	 *	translateHay - check hay for a translation
	 */
	function translateHay($hay)
	{
		// an ugly kludge.  the whole thing (Attribution) relies on guessing from the inconsistent identifier what our source is.
		// TODO: make a better way to do this
		if (substr_count($hay, 'zookeys')) {
			$hay = 'pensoft';
		}
		if (substr_count($hay, 'phytokeys')) {
			$hay = 'pensoft';
		}
		if (substr_count($hay, 'biorisk')) {
			$hay = 'pensoft';
		}
		if (substr_count($hay, 'journal_of_hymenoptera_research')) {
			$hay = 'pensoft';
		}
		if (substr_count($hay, 'international_journal_of_myriapodology')) {
			$hay = 'pensoft';
		}
		if (substr_count($hay, 'comparative_cytogenetics')) {
			$hay = 'pensoft';
		}
		if (substr_count($hay, 'subterranean_biology')) {
			$hay = 'pensoft';
		}
		if (substr_count($hay, 'nature_conservation')) {
			$hay = 'pensoft';
		}

		return $hay;
	}

	/**
	 *	getAttributionSource - get sourcing info
	 */
	function getAttributionSource($hay)
	{
		// an ugly kludge.  the whole thing (Attribution) relies on guessing from the inconsistent identifier what our source is.
		// TODO: make a better way to do this
		$hay = $this->translateHay($hay);

		$source = $this->matchIdentifier($hay);
		
		return $source;
	}
	
	/**
	 * matchIdentifier - given a source identifier from external data record, find our data provider
	 * @return array of sourch info: org, prj, url, flag.
	 */
	function matchIdentifier($hay)
	{
		// read db once, load array
		$src = $this->sourceProvidersArray('keys');
		$urlNeedles = $this->sourceProvidersArray('needles');
	
		$source = $src['empty'];
		$source['flag'] = false;
		
		// hunt for the right one
		foreach ($urlNeedles as $needle) {
			$count = substr_count($hay, $needle);
			if ($count) {
				$source = $src[$needle];
				$source['flag'] = true;
				break;
			}
		}
	
		return $source;
	}
	
	/**
	 * makeIdKey - make a word id key
	 */
	function makeIdKey($url)
	{
		$urlpart = str_replace('http://', '', $url);
		$urlpart = str_replace('www.', '', $urlpart);

		// avoid some problem matches  things like  oai.pensoft.eu  create false matches
		$urlpart = str_replace('oai:', '', $urlpart);
		$urlpart = str_replace('oai.', '', $urlpart);
		
		$parts = explode('.', $urlpart);
	
		// peel this apart:  http://www.GetThisPart.xyz.com
		// key = GetThisPart
		$key = $parts[0];
		
		return $key;
	}
	
	/**
	 * sourceProvidersArray - create arrays of org, prj, url data source providers info
	 */
	function sourceProvidersArray($keys = false)
	{
		static $source = array();
		static $src = array();
		static $urlNeedles = array();
		
		if (!$source) {
			$data = $this->readProvidersDataSource();
			foreach ($data as $dat) {
				$org = $dat['org'];
				$prj = $dat['prj'];
				$url = $dat['url'];
				$key = $this->makeIdKey($url);
				$source[] = compact('org', 'prj', 'url');
				$src[$key] = compact('org', 'prj', 'url');
				$urlNeedles[] = $key;
			}
		
			$org = 'NA';
			$prj = 'unknown';
			$url = 'none';
			$key = 'empty';
			$source[] = compact('org', 'prj', 'url');
			$src[$key] = compact('org', 'prj', 'url');
			$urlNeedles[] = $key;
		}
		
		$ret = '';
		
		// give back the type of list we ask for
		switch ($keys)
		{
			case 'keys':
				$ret = $src;
				break;
	
			case 'needles':
				$ret = $urlNeedles;
				break;
	
			default:
			case 'list':
				$ret = $source;
				break;
		}
		
		return $ret;
	}
	
	/**
	 * readProvidersDataSource - read database table
	 */
	function readProvidersDataSource()
	{
		$source = array();
		
		// ** db handling **
		$sql = "SELECT * FROM {oaiharvester_providers}";
		$result = db_query($sql);
	
		while ($data = db_fetch_object($result)) {
	
			$key = $data->provider_id;
	
			// parse out name, org and prj
			$name = $data->name;
			$nameCount = (substr_count($name, ':'));
			
			if ($nameCount) {
				$names = explode(':', $name);
				$orgName = $names[1];
				$prjName = $names[0];
			} else {
				$orgName = $data->name;
				$part = explode(' ', $orgName);
				$prjName = $part[0];
			}
			
			$org = $orgName;
			$prj = $prjName;
			$url = $data->oai_provider_url;
			$source[$key] = compact('org', 'prj', 'url');
		}
		// ** db handling **
		
		return $source;
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************
