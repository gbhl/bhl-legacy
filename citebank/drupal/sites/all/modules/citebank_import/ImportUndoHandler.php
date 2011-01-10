<?php
// $Id: ImportUndoHandler.php,v 1.0.0.0 2010/12/23 4:44:44 dlheskett $

/** ImportUndoHandler class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 12/23/2010
 *
 */

$includePath = dirname(__FILE__) . '/';
require_once($includePath . 'DBInterfaceController.php');

/*
// to undo 

// knowing nid, we have most of it

// get fid from upload.fid where upload.nid = nid
// get cid from biblio_contributor.cid where biblio_contributor.nid = nid

// delete from node where node.nid = nid
// delete from biblio where biblio.nid = nid
// delete from biblio_contributor where biblio_contributor.nid = nid
// delete from node_access where node_access.nid = nid
// delete from upload where upload.nid = nid

// delete from files where files.fid = fid

// delete from biblio_contributor_data where biblio_contributor_data.cid = cid



// read list of undo numbers
$sql = 'SELECT LAST_INSERT_ID()';
// http://dev.mysql.com/doc/refman/5.0/en/information-functions.html#function_last-insert-id

// create list of undo numbers, identify by import file?  how?
$nid = 0;
$now = date('YmdHis');
$importFile = '';
$nodeList = array();

// in the loop that makes the biblio entry and so on...
$nodeList[] = $nid;


Undo database

table: import_undo

fields:
undo_id          - for each entry
undo_batch_id    - same number for the entire batch
nid              - the node id, with it, you can delete the related table entries
created          - date time stamp
import_file      - the import file name
undid            - 0 default, 1 = we processed this entry for deletion of the records for that nid.  we can later purge all undid entries

*/



/** 
 * class ImportUndoHandler - handle removing import data to provide an UNDO feature for an import process
 * 
 */
class ImportUndoHandler
{
	public $className;

	public $undo_id;       // - for each entry
	public $undo_batch_id; // - same number for the entire batch
	public $nid;           // - the node id, with it, you can delete the related table entries
	public $created;       // - date time stamp
	public $import_file;   // - the import file name
	public $undid;         // - 0 default, 1 = we processed this entry for deletion of the records for that nid.  we can later purge all undid entries
	public $nodeList;      // - list of nids
	public $dbi;

	const CLASS_NAME    = 'ImportUndoHandler';
	const UNDO_TABLE    = 'import_undo';

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
		$this->created       = date('YmdHis');
		$this->undo_id       = 0;
		$this->undo_batch_id = 0;
		$this->nid           = 0;
		$this->import_file   = '';
		$this->undid         = 0;
		$this->nodeList      = array();
		
		$this->dbi = new DBInterfaceController();
		
		$this->className = self::CLASS_NAME;
		
		$x = $this->findLast();
		$this->undo_batch_id = $x + 1;  // set this batch id, last one plus one
	}

	/**
	 * stub - 
	 */
	function stub()
	{
		//$this->x = 'x';

		//return $this->x;
	}
	// ****************************************
	// ****************************************

	/**
	 * makeUndoNid - 
	 */
	function makeUndoNid($nid, $importFile)
	{
		//insert into `import_undo` (`undo_id`, `undo_batch_id`, `nid`, `created`, `import_file`, `undid`) values('1','1','72717','2010-12-21 04:04:04','testfile','1');
		$importFile = trim($importFile, '"');
		
		// either a db or a file
		$sql = 'INSERT INTO ' . self::UNDO_TABLE . ' SET nid = ' . $nid . ', undo_batch_id = ' . $this->undo_batch_id . ', created = ' . $this->created . ', import_file = ' . "'" . $importFile . "'" . ' ';
		//watchdog('ImportUndoHandler', $sql);  
		$this->dbi->select($sql);
	}

	/**
	 * makeUndo - 
	 */
	function makeUndo($nodeList, $importFile)
	{
		// either a db or a file
		$count = count($nodeList);
		if ($count > 0) {
			foreach ($nodeList as $key => $nid) {
				$this->makeUndoNid($nid, $importFile);
			}
		}
	}

//	/**
//	 * findBatchId - given a filename, find the associated batch
//	 */
//	function findBatchId($filename)
//	{
//		//SELECT undo_batch_id FROM import_undo WHERE import_file = 'testfile' LIMIT 1
//		$sql = 'SELECT undo_batch_id FROM ' . self::UNDO_TABLE . ' WHERE import_file = ' . "'" . $filename . "'" . ' LIMIT 1';
//		
//		$data = $this->dbi->fetch($sql);
//
//		$undo_batch_id = ($data[0] ? $data[0] : 0);
//		
//		return $undo_batch_id;
//	}

	/**
	 * findBatchList - find list of files/batchids of undo entries
	 */
	function findBatchList()
	{
		//SELECT DISTINCT import_file, undo_batch_id, created FROM import_undo WHERE 1 ORDER BY undo_batch_id
		$sql = 'SELECT DISTINCT import_file, undo_batch_id, created FROM import_undo WHERE 1 ORDER BY undo_batch_id';
		
		$batchList = $this->dbi->fetch($sql);

		return $batchList;
	}

	/**
	 * getFid - 
	 */
	function getFid($nid)
	{
		$table = 'upload';
		$sql = 'SELECT fid FROM ' . $table . ' WHERE nid = ' . $nid . '';
		
		$rows = $this->dbi->fetch($sql);
		
		$fid = ($rows[0]['fid'] ? $rows[0]['fid'] : 0);
		
		return $fid;
	}

	/**
	 * getCid - 
	 */
	function getCid($nid)
	{
		$table = 'biblio_contributor';
		$sql = 'SELECT cid FROM ' . $table . ' WHERE nid = ' . $nid . '';
		
		$rows = $this->dbi->fetch($sql);
		
		$fid = ($rows[0]['cid'] ? $rows[0]['cid'] : 0);
		
		return $fid;
	}

	/**
	 * markUndone - 
	 */
	function markUndone($nid)
	{
		$table = 'import_undo';
		$sql = 'UPDATE ' . $table . ' SET undid = 1 WHERE nid = ' . $nid . '';
		
		$this->dbi->update($sql);
	}

	/**
	 * deleteX - 
	 */
	function deleteX($table, $nid)
	{
		$sql = 'DELETE FROM ' . $table . ' WHERE nid = ' . $nid . '';
		
		$this->dbi->select($sql);
	}

	/**
	 * deleteXFile - 
	 */
	function deleteXFile($table, $fid)
	{
		$sql = 'DELETE FROM ' . $table . ' WHERE fid = ' . $fid . '';
		
		$this->dbi->select($sql);
	}

	/**
	 * deleteXAuthor - 
	 */
	function deleteXAuthor($table, $cid)
	{
		$sql = 'DELETE FROM ' . $table . ' WHERE cid = ' . $cid . '';
		
		$this->dbi->select($sql);
	}

	/**
	 * performUndo - remove entries for a batch
	 */
	function performUndo($batchId)
	{
		$table = self::UNDO_TABLE;
		$sql = 'SELECT nid FROM ' . $table . ' WHERE undo_batch_id = ' . $batchId;
		
		$rows = $this->dbi->fetch($sql);
		
		foreach ($rows as $key => $row) {
			$nid = $row['nid'];
//			echo '<br>';
//			echo $nid;
//			echo ' ';

			// get fid from upload.fid where upload.nid = nid
			$fid = $this->getFid($nid);
//			echo $fid;
//			echo ' ';

			// get cid from biblio_contributor.cid where biblio_contributor.nid = nid
			$cid = $this->getCid($nid);
//			echo $cid;
//			echo ' ';
			

			//echo '<br>';

			// delete from node where node.nid = nid
			$this->deleteX('node', $nid);
			// delete from biblio where biblio.nid = nid
			$this->deleteX('biblio', $nid);
			// delete from biblio_contributor where biblio_contributor.nid = nid
			$this->deleteX('biblio_contributor', $nid);
			// delete from node_access where node_access.nid = nid
			$this->deleteX('node_access', $nid);
			$this->deleteX('node_revisions', $nid);
			// delete from upload where upload.nid = nid
			$this->deleteX('upload', $nid);
			
			// delete from files where files.fid = fid
			if ($fid) {
				$this->deleteXFile('files', $fid);
			}
			
			// delete from biblio_contributor_data where biblio_contributor_data.cid = cid
			if ($cid) {
				$this->deleteXAuthor('biblio_contributor_data', $cid);
			}
			
			$this->markUndone($nid);
		}
		
		$this->purge();
		
	}

	/**
	 * purge - clear undid entries
	 */
	function purge()
	{
		$sql = 'DELETE FROM ' . self::UNDO_TABLE . ' WHERE undid = 1';
		
		$this->dbi->select($sql);
		
	}

	/**
	 * findLast - get the last id in the database.
	 */
	function findLast($resolverFlag = false)
	{
		$nid = 0;
		$sql = '';
		
		$tbl =  self::UNDO_TABLE;
		$openBrace = ($resolverFlag ? '{' : '');
		$clseBrace = ($resolverFlag ? '}' : '');
		
		//SELECT undo_batch_id FROM import_undo WHERE 1 ORDER BY undo_batch_id DESC LIMIT 1
		$sql .= 'SELECT undo_batch_id FROM ' . $openBrace . $tbl . $clseBrace . ' WHERE 1 ORDER BY undo_batch_id DESC LIMIT 1';
		
		$row = $this->dbi->fetch($sql);
		$undo_batch_id = ($row[0]['undo_batch_id'] ? $row[0]['undo_batch_id'] : 0);
		
		return $undo_batch_id;
	}

	// ****************************************
	// ****************************************
	/**
	 * _toString - stringify
	 */
	function __toString()
	{
		$info = '';
		$info .= $this->className;

		return $info;
	}
	
}  // end class
// ****************************************
// ****************************************
// ****************************************

?>
