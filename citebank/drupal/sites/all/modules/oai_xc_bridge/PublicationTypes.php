<?php
// $Id: PublicationTypes.php,v 1.0.0.0 2010/09/15 4:44:44 dlheskett $

/* PublicationTypes.php
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 09/15/2010
 *
 */

/** 
 * class PublicationTypes - biblio Publication Types 
 * 
 */
class PublicationTypes
{
	/**
	 * _construct - constructor
	 */
	function __construct()
	{
	}

	/**
	 *  loadPublicationTypes - get number values for word values of publication types
	 */
	function loadPublicationTypes()
	{
		static $biblioTypes = array();
		
		if ($biblioTypes) {
			; // done
		} else {
			$sql = 'SELECT * FROM {biblio_types}';
			$res = db_query($sql);
	
			if ($res) {
			
				while ($data = db_fetch_object($res)) {
					$key  = $data->tid;
					$name = $data->name;
	
					$biblioTypes[strtolower($name)] = $key;
				}
				
				// add a couple items that are not in the given set
				$biblioTypes['series']               = $biblioTypes['book'];
				$biblioTypes['article']              = $biblioTypes['journal article'];

			} else {
				// failed, so fall back on bad hard coding
				// these should match what is in table: biblio_types
				//   and match what biblio_install, _add_publication_types() sets up
				$biblioTypes['book']                 = 100;
				$biblioTypes['journal article']      = 102;
	
				$biblioTypes['series']               = $biblioTypes['book'];
				$biblioTypes['article']              = $biblioTypes['journal article'];
	
				$biblioTypes['journal']              = 131;
				$biblioTypes['original description'] = 132;
				$biblioTypes['treatment']            = 133;
			}
		}
		
		return $biblioTypes;
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************
