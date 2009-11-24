<?php

/**
 * Implementation of hook_feedapi_rdf_map()
 *
 * @param $op
 *   Operation that is being invoked. Can be either 'list' or 'map':
 * 
 *   'list'
 *   Return an array of available map types on 'list'. Use keys as identifier
 *   and values as human readable names. Users can configure listed map types
 *   as enabled or disabled on content types and feed nodes.
 * 
 *   'map'
 *   Return mapping of the type requested by $map_type.
 *   
 * @param $map_type 
 *   Type of mapping that is being invoked. The type of mapping can be one of 
 *   the mappings that _any_ hook_feedapi_rdf_map() lists _and_ that is 
 *   configured active by the user for the current feed.
 *   
 * @return
 *  An array of mappings. Keys should be predecates using registered 
 *  namespaces.
 *  The value of each element must be an array and have the key 'location'.
 *  The location may be a string or array that describes the location of the
 *  value on the feed item.
 *  Optionally a 'callback' element may be supplied that can be used to
 *  generate statement(s) before it is saved. The callback will be provided
 *  With four arguments, subject, predicate, object and the feed_item. The
 *  callback should return an array of subject, predicate, object arrays.
 * 
 *  If you use namespace handles, register the namespace with RDF API and use 
 *  the _local_ RDF API handle, not the feed's namespace handle.
 */
function feedapi_rdf_feedapi_rdf_map($op, $map_type = NULL) {

  switch ($op) {
    case 'list':
      return array(
        'kml_placemarks' => t('KML placemarks to RDF'),
        'rss' => t('RSS/Atom to RDF'),
        );
    case 'map': 
      switch ($map_type) {
        case 'kml_placemarks':
          return _feedapi_rdf_map_kml_placemarks();
        case 'rss':
        default:
          return _feedapi_rdf_map_rss_atom();
      }
      break;
  }
  return array();
}

/**
 * Mapping rules for RSS and Atom.
 */
function _feedapi_rdf_map_rss_atom() {
  return array(
    'dc:title' => array('location' => 'title'),
    'dc:description' => array('location' => 'description'),
    'dc:creator' => array('location' => array('options', 'original_author')),
    'ag:timestamp' => array(
      'location' => array('options', 'timestamp'),
      'callback' => 'feedapi_rdf_datetime'),
  );
}

// Callback to format date, wrapper around rdf_datetime.
function feedapi_rdf_datetime($subject, $predicate, $object, $feed_item) {
  return array(array($subject, $predicate, rdf_datetime($object)));
}

/**
 * Mapping rules for KML.
 */
function _feedapi_rdf_map_kml_placemarks() {
  return array(
    'geo:lat' => array('location' => array('options', 'location', 'latitude', 0)),
    'geo:lon' => array('location' => array('options', 'location', 'longitude', 0)),
    'rss:link' => array('location' => array('options', 'original_url')),
    // rvns:city_name: 'rvns' will be translated to the feed's namespace handle by FeedAPI RDF.
    'rvns:city_name' => array('location' => array('options', 'metadata', 'rvns:city_name', 0)),
  );
}