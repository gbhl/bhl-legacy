<?php
// $Id: BiblioNode.php,v 1.1.0.0 2010/11/15 4:44:44 dlheskett $

/**  BiblioNode class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 11/15/2010
 *
 */

$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'BiblioNodeData.php');

/** 
 * class BiblioNode - holds a biblio node data item, adding sql generation, for entry into database
 * todo: add contributor and keywords tables, plus whatever else biblio entry save node does
 * 
 */
class BiblioNode extends BiblioNodeData
{
	public $nid        = 0;
	public $vid        = 0;
	public $biblio_md5 = 0;
	public $filename   = '';
	public $dirPath    = '';
	public $linkPath   = '';
	public $node       = array();

	public $fld = array();
	public $formatType   = self::STRING_TO_CSV;  // 1 = csv, 0 = html
	public $titleRowFlag = true;
	public $strhtm       =  -1;

	const CLASS_NAME    = 'BiblioNode';
	const BIBLIO_NODE_TABLE  = 'biblio';

	const STRING_TO_CSV    = 1;
	const STRING_TO_HTML   = 0;
	const STRING_TO_STR    = 2;
	const STRING_TO_STRHTM = 3;

	/**
	 * _construct - constructor
	 */
	function __construct()
	{
		parent::__construct();
		$this->initDefaults();
	}

	/**
	 * initDefaults - set defaults
	 */
	function initDefaults()
	{
		parent::initDefaults();
		$this->initFields();
		$this->titleRowFlag = true;
		$this->strhtm = -1;  // starts string htm
	}

	/**
	 * initDefaults - set defaults
	 */
	function initFields()
	{
		$this->fld['data_abst_e']               = 'abst_e';
		$this->fld['data_abst_f']               = 'abst_f';
		$this->fld['data_access_date']          = 'Access Date';
		$this->fld['data_accession_number']     = 'Accession Number';
		$this->fld['data_alternate_title']      = 'Alternate Title';
		$this->fld['data_auth_address']         = 'Auth Address';
		$this->fld['data_call_number']          = 'Call Number';
		$this->fld['data_citekey']              = 'Citekey';
		$this->fld['data_coins']                = 'Coins';
		$this->fld['data_contributors']         = 'Contributors';
		$this->fld['data_custom1']              = 'custom1';
		$this->fld['data_custom2']              = 'custom2';
		$this->fld['data_custom3']              = 'custom3';
		$this->fld['data_custom4']              = 'custom4';
		$this->fld['data_custom5']              = 'custom5';
		$this->fld['data_custom6']              = 'custom6';
		$this->fld['data_custom7']              = 'custom7';
		$this->fld['data_date']                 = 'Date';
		$this->fld['data_doi']                  = 'DOI';
		$this->fld['data_edition']              = 'Edition';
		$this->fld['data_full_text']            = 'Full Text';
		$this->fld['data_isbn']                 = 'ISBN';
		$this->fld['data_issn']                 = 'ISSN';
		$this->fld['data_issue']                = 'Issue';
		$this->fld['data_keywords']             = 'Keywords';
		$this->fld['data_label']                = 'Label';               //
		$this->fld['data_lang']                 = 'Language';
		$this->fld['data_notes']                = 'Notes';
		$this->fld['data_number']               = 'Number';
		$this->fld['data_number_of_volumes']    = 'Number of Volumes';
		$this->fld['data_original_publication'] = 'Original Publication';
		$this->fld['data_other_number']         = 'Other Number';
		$this->fld['data_pages']                = 'Pages';
		$this->fld['data_place_published']      = 'Place Published';
		$this->fld['data_publisher']            = 'Publisher';
		$this->fld['data_refereed']             = 'Refereed';
		$this->fld['data_remote_db_name']       = 'Remote DB Name';      // 
		$this->fld['data_remote_db_provider']   = 'Remote DB Provider';  //
		$this->fld['data_reprint_edition']      = 'Reprint Edition';
		$this->fld['data_research_notes']       = 'Research Notes';
		$this->fld['data_secondary_title']      = 'Secondary Title';
		$this->fld['data_section']              = 'Section';
		$this->fld['data_short_title']          = 'Short Title';
		$this->fld['data_tertiary_title']       = 'Tertiary Title';
		$this->fld['data_title']                = 'Title';
		$this->fld['data_translated_title']     = 'Translated Title';
		$this->fld['data_type']                 = 'Type';
		$this->fld['data_type_of_work']         = 'Type of Work';
		$this->fld['data_url']                  = 'Url';
		$this->fld['data_volume']               = 'Volume';
		$this->fld['data_year']                 = 'Year';
	
		$this->fld['data_source_org']           = 'Organization';
		$this->fld['data_source_prj']           = 'Project';
		$this->fld['data_source_url']           = 'Source';
	}

	/**
	 * makeSql - create the sql to add node to table
	 */
	function makeSql($node, $resolverFlag = false)
	{
		$sql = '';
		$skipCommaFlag = false;
		
		$tbl = self::BIBLIO_NODE_TABLE;
		$openBrace = ($resolverFlag ? '{' : '');
		$clseBrace = ($resolverFlag ? '}' : '');
		
//		$node->nid = $this->nid;
//		$node->vid = $this->vid;
		$node['nid'] = $this->nid;
		$node['vid'] = ($this->vid ? $this->vid : $this->nid);
		$this->vid = ($this->vid ? $this->vid : $this->nid);
		
		$this->biblio_md5 = md5($this->data_url);
//		$node->biblio_md5 = $this->biblio_md5;
		$node['biblio_md5'] = $this->biblio_md5;
		
		$sql .= 'INSERT INTO ' . $openBrace . $tbl . $clseBrace . ' SET';
		foreach ($node as $key => $val) {

			switch ($key)
			{
				case 'data_contributors':
				case 'data_keywords':
				case 'data_title':  // drop this one, as we use title instead.  it's a biblio drupal design decision to be obtuse.
				case 'biblio_contributors':
				case 'biblio_keywords':
				case 'biblio_title':
				case 'title':
				case 'filename':
					$skipCommaFlag = true;
					break;

				case 'data_type':
				case 'biblio_type':
					$val = ($val ? $val : 100);
					$sql .= ' ' . $key . ' = ' . $val;              // numbers are not quoted
					break;

				case 'nid':
				case 'vid':
				case 'data_full_text':
				case 'biblio_full_text':
					$val = ($val ? $val : 0);
					$sql .= ' ' . $key . ' = ' . $val;              // numbers are not quoted
					break;

				default:
					$key = str_replace('data_', 'biblio_', $key);   // force the key to biblio table fields
					// quote all
					$sql .= ' ' . $key . ' = ' . "'" . $val . "'";  // strings are quoted
					break;
			}

			if($skipCommaFlag) {
				$skipCommaFlag = false;
			} else {
				$sql .= ','; // add commas
			}
		}
		
		$sql = rtrim($sql, ','); // drop the trailing comma
		
		return $sql;
	}

	/**
	 * setDataByNode - set the data by a biblio type array node
	 */
	function setDataByNodeX($node)
	{
	  // Add the identifiers to the data
		$this->data_abst_e                      = (isset($node['biblio_abst_e']) ? $node['biblio_abst_e'] : '');
		$this->data_abst_f                      = (isset($node['biblio_abst_f']) ? $node['biblio_abst_f'] : '');
		$this->data_access_date                 = (isset($node['biblio_access_date']) ? $node['biblio_access_date'] : '');
		$this->data_accession_number            = (isset($node['biblio_accession_number']) ? $node['biblio_accession_number'] : '');
		$this->data_alternate_title             = (isset($node['biblio_alternate_title']) ? $node['biblio_alternate_title'] : '');
		$this->data_auth_address                = (isset($node['biblio_auth_address']) ? $node['biblio_auth_address'] : '');
		$this->data_call_number                 = (isset($node['biblio_call_number']) ? $node['biblio_call_number'] : '');
		$this->data_citekey                     = (isset($node['biblio_citekey']) ? $node['biblio_citekey'] : '');
		$this->data_coins                       = (isset($node['biblio_coins']) ? $node['biblio_coins'] : '');
		$this->data_contributors                = (isset($node['biblio_contributors']) ? $node['biblio_contributors'] : array());
		$this->data_custom1                     = (isset($node['biblio_custom1']) ? $node['biblio_custom1'] : '');
		$this->data_custom2                     = (isset($node['biblio_custom2']) ? $node['biblio_custom2'] : '');
		$this->data_custom3                     = (isset($node['biblio_custom3']) ? $node['biblio_custom3'] : '');
		$this->data_custom4                     = (isset($node['biblio_custom4']) ? $node['biblio_custom4'] : '');
		$this->data_custom5                     = (isset($node['biblio_custom5']) ? $node['biblio_custom5'] : '');
		$this->data_custom6                     = (isset($node['biblio_custom6']) ? $node['biblio_custom6'] : '');
		$this->data_custom7                     = (isset($node['biblio_custom7']) ? $node['biblio_custom7'] : '');
		$this->data_date                        = (isset($node['biblio_date']) ? $node['biblio_date'] : '');
		$this->data_doi                         = (isset($node['biblio_doi']) ? $node['biblio_doi'] : '');
		$this->data_edition                     = (isset($node['biblio_edition']) ? $node['biblio_edition'] : '');
		$this->data_full_text                   = (isset($node['biblio_full_text']) ? $node['biblio_full_text'] : '');
		$this->data_isbn                        = (isset($node['biblio_isbn']) ? $node['biblio_isbn'] : '');
		$this->data_issn                        = (isset($node['biblio_issn']) ? $node['biblio_issn'] : '');
		$this->data_issue                       = (isset($node['biblio_issue']) ? $node['biblio_issue'] : '');
		$this->data_keywords                    = (isset($node['biblio_keywords']) ? $node['biblio_keywords'] : array());
		$this->data_label                       = (isset($node['biblio_label']) ? $node['biblio_label'] : ''); //$node['biblio_label']
		$this->data_lang                        = (isset($node['biblio_lang']) ? $node['biblio_lang'] : '');
		$this->data_notes                       = (isset($node['biblio_notes']) ? $node['biblio_notes'] : '');
		$this->data_number                      = (isset($node['biblio_number']) ? $node['biblio_number'] : '');
		$this->data_number_of_volumes           = (isset($node['biblio_number_of_volumes']) ? $node['biblio_number_of_volumes'] : '');
		$this->data_original_publication        = (isset($node['biblio_original_publication']) ? $node['biblio_original_publication'] : '');
		$this->data_other_number                = (isset($node['biblio_other_number']) ? $node['biblio_other_number'] : '');
		$this->data_pages                       = (isset($node['biblio_pages']) ? $node['biblio_pages'] : '');
		$this->data_place_published             = (isset($node['biblio_place_published']) ? $node['biblio_place_published'] : '');
		$this->data_publisher                   = (isset($node['biblio_publisher']) ? $node['biblio_publisher'] : '');
		$this->data_refereed                    = (isset($node['biblio_refereed']) ? $node['biblio_refereed'] : '');
		$this->data_remote_db_name              = (isset($node['biblio_remote_db_name']) ? $node['biblio_remote_db_name'] : ''); //$node['biblio_remote_db_name']       
		$this->data_remote_db_provider          = (isset($node['biblio_remote_db_provider']) ? $node['biblio_remote_db_provider'] : ''); //$node['biblio_remote_db_provider']   
		$this->data_reprint_edition             = (isset($node['biblio_reprint_edition']) ? $node['biblio_reprint_edition'] : '');
		$this->data_research_notes              = (isset($node['biblio_research_notes']) ? $node['biblio_research_notes'] : '');
		$this->data_secondary_title             = (isset($node['biblio_secondary_title']) ? $node['biblio_secondary_title'] : '');
		$this->data_section                     = (isset($node['biblio_section']) ? $node['biblio_section'] : '');
		$this->data_short_title                 = (isset($node['biblio_short_title']) ? $node['biblio_short_title'] : '');
		$this->data_tertiary_title              = (isset($node['biblio_tertiary_title']) ? $node['biblio_tertiary_title'] : '');
		//$this->data_title                       = (isset($node['biblio_title']) ? $node['biblio_title'] : '');
		$this->data_title                       = (isset($node['title']) ? $node['title'] : (isset($node['biblio_title']) ? $node['biblio_title'] : ''));
		$this->data_translated_title            = (isset($node['biblio_translated_title']) ? $node['biblio_translated_title'] : '');
		$this->data_type                        = (isset($node['biblio_type']) ? $node['biblio_type'] : self::PUBLICATION_TYPE_BOOK);
		$this->data_type_of_work                = (isset($node['biblio_type_of_work']) ? $node['biblio_type_of_work'] : '');
		$this->data_url                         = (isset($node['biblio_url']) ? $node['biblio_url'] : '');
		$this->data_volume                      = (isset($node['biblio_volume']) ? $node['biblio_volume'] : '');
		$this->data_year                        = (isset($node['biblio_year']) ? $node['biblio_year'] : self::DEFAULT_YEAR);

		$this->data_source_org                  = (isset($node['biblio_remote_db_provider']) ? $node['biblio_remote_db_provider'] : '');
		$this->data_source_prj                  = (isset($node['biblio_label']) ? $node['biblio_label'] : '');
		$this->data_source_url                  = (isset($node['biblio_remote_db_name']) ? $node['biblio_remote_db_name'] : '');
		$this->data_remote_db_provider          = (isset($node['biblio_remote_db_provider']) ? $node['biblio_remote_db_provider'] : '');
		$this->data_label                       = (isset($node['biblio_label']) ? $node['biblio_label'] : '');
		$this->data_remote_db_name              = (isset($node['biblio_remote_db_name']) ? $node['biblio_remote_db_name'] : '');
	}

	/**
	 * setDataByNodeXData - set the data by a biblio type array node using 'data_' fields
	 */
	function setDataByNodeXData($node)
	{
	  // Add the identifiers to the data
		$this->data_abst_e                      = (isset($node['data_abst_e']) ? $node['data_abst_e'] : '');
		$this->data_abst_f                      = (isset($node['data_abst_f']) ? $node['data_abst_f'] : '');
		$this->data_access_date                 = (isset($node['data_access_date']) ? $node['data_access_date'] : '');
		$this->data_accession_number            = (isset($node['data_accession_number']) ? $node['data_accession_number'] : '');
		$this->data_alternate_title             = (isset($node['data_alternate_title']) ? $node['data_alternate_title'] : '');
		$this->data_auth_address                = (isset($node['data_auth_address']) ? $node['data_auth_address'] : '');
		$this->data_call_number                 = (isset($node['data_call_number']) ? $node['data_call_number'] : '');
		$this->data_citekey                     = (isset($node['data_citekey']) ? $node['data_citekey'] : '');
		$this->data_coins                       = (isset($node['data_coins']) ? $node['data_coins'] : '');
		$this->data_contributors                = (isset($node['data_contributors']) ? $node['data_contributors'] : array());
		$this->data_custom1                     = (isset($node['data_custom1']) ? $node['data_custom1'] : '');
		$this->data_custom2                     = (isset($node['data_custom2']) ? $node['data_custom2'] : '');
		$this->data_custom3                     = (isset($node['data_custom3']) ? $node['data_custom3'] : '');
		$this->data_custom4                     = (isset($node['data_custom4']) ? $node['data_custom4'] : '');
		$this->data_custom5                     = (isset($node['data_custom5']) ? $node['data_custom5'] : '');
		$this->data_custom6                     = (isset($node['data_custom6']) ? $node['data_custom6'] : '');
		$this->data_custom7                     = (isset($node['data_custom7']) ? $node['data_custom7'] : '');
		$this->data_date                        = (isset($node['data_date']) ? $node['data_date'] : '');
		$this->data_doi                         = (isset($node['data_doi']) ? $node['data_doi'] : '');
		$this->data_edition                     = (isset($node['data_edition']) ? $node['data_edition'] : '');
		$this->data_full_text                   = (isset($node['data_full_text']) ? $node['data_full_text'] : '');
		$this->data_isbn                        = (isset($node['data_isbn']) ? $node['data_isbn'] : '');
		$this->data_issn                        = (isset($node['data_issn']) ? $node['data_issn'] : '');
		$this->data_issue                       = (isset($node['data_issue']) ? $node['data_issue'] : '');
		$this->data_keywords                    = (isset($node['data_keywords']) ? $node['data_keywords'] : array());
		$this->data_label                       = (isset($node['data_label']) ? $node['data_label'] : ''); //$node['data_label']
		$this->data_lang                        = (isset($node['data_lang']) ? $node['data_lang'] : '');
		$this->data_notes                       = (isset($node['data_notes']) ? $node['data_notes'] : '');
		$this->data_number                      = (isset($node['data_number']) ? $node['data_number'] : '');
		$this->data_number_of_volumes           = (isset($node['data_number_of_volumes']) ? $node['data_number_of_volumes'] : '');
		$this->data_original_publication        = (isset($node['data_original_publication']) ? $node['data_original_publication'] : '');
		$this->data_other_number                = (isset($node['data_other_number']) ? $node['data_other_number'] : '');
		$this->data_pages                       = (isset($node['data_pages']) ? $node['data_pages'] : '');
		$this->data_place_published             = (isset($node['data_place_published']) ? $node['data_place_published'] : '');
		$this->data_publisher                   = (isset($node['data_publisher']) ? $node['data_publisher'] : '');
		$this->data_refereed                    = (isset($node['data_refereed']) ? $node['data_refereed'] : '');
		$this->data_remote_db_name              = (isset($node['data_remote_db_name']) ? $node['data_remote_db_name'] : ''); //$node['data_remote_db_name']       
		$this->data_remote_db_provider          = (isset($node['data_remote_db_provider']) ? $node['data_remote_db_provider'] : ''); //$node['data_remote_db_provider']   
		$this->data_reprint_edition             = (isset($node['data_reprint_edition']) ? $node['data_reprint_edition'] : '');
		$this->data_research_notes              = (isset($node['data_research_notes']) ? $node['data_research_notes'] : '');
		$this->data_secondary_title             = (isset($node['data_secondary_title']) ? $node['data_secondary_title'] : '');
		$this->data_section                     = (isset($node['data_section']) ? $node['data_section'] : '');
		$this->data_short_title                 = (isset($node['data_short_title']) ? $node['data_short_title'] : '');
		$this->data_tertiary_title              = (isset($node['data_tertiary_title']) ? $node['data_tertiary_title'] : '');
		//$this->data_title                       = (isset($node['data_title']) ? $node['data_title'] : '');
		$this->data_title                       = (isset($node['title']) ? $node['title'] : (isset($node['data_title']) ? $node['data_title'] : ''));
		$this->data_translated_title            = (isset($node['data_translated_title']) ? $node['data_translated_title'] : '');
		$this->data_type                        = (isset($node['data_type']) ? $node['data_type'] : self::PUBLICATION_TYPE_BOOK);
		$this->data_type_of_work                = (isset($node['data_type_of_work']) ? $node['data_type_of_work'] : '');
		$this->data_url                         = (isset($node['data_url']) ? $node['data_url'] : '');
		$this->data_volume                      = (isset($node['data_volume']) ? $node['data_volume'] : '');
		$this->data_year                        = (isset($node['data_year']) ? $node['data_year'] : self::DEFAULT_YEAR);

		$this->data_source_org                  = (isset($node['data_remote_db_provider']) ? $node['data_remote_db_provider'] : '');
		$this->data_source_prj                  = (isset($node['data_label']) ? $node['data_label'] : '');
		$this->data_source_url                  = (isset($node['data_remote_db_name']) ? $node['data_remote_db_name'] : '');
		$this->data_remote_db_provider          = (isset($node['data_remote_db_provider']) ? $node['data_remote_db_provider'] : '');
		$this->data_label                       = (isset($node['data_label']) ? $node['data_label'] : '');
		$this->data_remote_db_name              = (isset($node['data_remote_db_name']) ? $node['data_remote_db_name'] : '');
	}

	/**
	 * getDataAsNode - set the data by a biblio type array node
	 */
	function getDataAsNode($data)
	{
		$this->setDataByNodeXData($data);
		$node = $this->processNode(null);
		$this->node = $node;
		return $node;
	}

	/**
	 * _toString - stringify
	 */
	function __toString()
	{
		$info = '';

		//$info .= '<br>';
		//$info .= "\n";

		//$info .= var_export($this, true);
		
		switch ($this->formatType)
		{
			// a handy csv comma delimited string
			case self::STRING_TO_CSV:
				// make a CSV
				if ($this->titleRowFlag) {
					$this->titleRowFlag = false;
					foreach ($this->fld as $key => $label) {	
						$info .= $label;
						$info .= ',';
					}
					$info = rtrim($info, ',');
					$info .= "\n";
				}
	
				foreach ($this->fld as $key => $label) {	
					if (is_array($this->$key)) {
						// handle array fields
						foreach ($this->$key as $itemKey => $item) {
							$info .= '"';
							$info .= $item;
							$info .= '"';
							$info .= ';';
						}
						$info .= ',';
					} else {
						$info .= '"';
						$info .= $this->$key;
						$info .= '"';
					}
					$info .= ',';
				}
				$info = rtrim($info, ',');
				$info .= "\n";
				break;

			// fancy html mode
			case self::STRING_TO_HTML:
				// make as HTML
				if ($this->strhtm == -1) {
					$this->strhtm = 0;
					$info .= '<html>';
					$info .= '<title>';
					$info .= 'Review Data';
					$info .= '</title>';
					$info .= '<body>';
			
					$info .= '<table border="1">';
				}

				if ($this->strhtm == 0) {
					if ($this->titleRowFlag) {
						$this->titleRowFlag = false;
	
						$info .= '<tr>';
	
						foreach ($this->fld as $key => $label) {	
							$info .= '<td>';
							//$info .= ' ';
							$info .= $label;
							$info .= '</td>';
						}
	
						$info .= '</tr>';
						$info .= "\n";
					} else {
						$info .= '<tr>';
						foreach ($this->fld as $key => $label) {	
							$info .= '<td>';
							$info .= ' ';
							//$info .= $label . ': ';
							//$info .= $this->$key;
							if (is_array($this->$key)) {
								// handle array fields
								foreach ($this->$key as $itemKey => $item) {
									$info .= $item;
									$info .= ',';
								}
							} else {
								$info .= $this->$key;
							}
							$info .= '</td>';
						}
				
						$info .= '</tr>';
						
						// last row should set, to 1
						//$this->strhtm = 1;
					}
				}

		
				if ($this->strhtm == 1) {
					$info .= '</table>';
					$info .= '</body>';
					$info .= '</html>';
				}
				break;

			// just a raw string broken up by newlines
			case self::STRING_TO_STR:
				// make as String
				foreach ($this->fld as $key => $label) {	
						$info .= ' ';
						$info .= $label . ': ';
						//$info .= $this->$key;
						if (is_array($this->$key)) {
							// handle array fields
							foreach ($this->$key as $itemKey => $item) {
								$info .= $item;
								$info .= ',';
							}
						} else {
							$info .= $this->$key;
						}

						$info .= "\n";
					}
					
					$info .= "\n";
			
				break;

			// strings, but nicely viewable on a web page, with the "br"s added
			case self::STRING_TO_STRHTM:
				// make as String
				foreach ($this->fld as $key => $label) {	
						$info .= ' ';
						$info .= '<strong>';
						$info .= $label . ': ';
						$info .= '</strong>';

						if (is_array($this->$key)) {
							// handle array fields
							foreach ($this->$key as $itemKey => $item) {
								$info .= $item;
								$info .= ',';
							}
						} else {
							$info .= $this->$key;
						}

						$info .= "<br>";
						$info .= "\n";
					}
					
					$info .= "<br>";
					$info .= "\n";
			
				break;
		}
		

		return $info;
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
