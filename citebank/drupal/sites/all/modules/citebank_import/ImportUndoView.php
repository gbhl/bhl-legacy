<?php
// $Id: ImportUndoHandlerView.php,v 1.0.0.0 2010/12/23 4:44:44 dlheskett $

/** ImportUndoHandlerView class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 12/23/2010
 *
 */

// display the undo features

$includePath = dirname(__FILE__) . '/';
require_once($includePath . 'ImportUndoHandler.php');

$importUndo = new ImportUndoHandler();

$list = $importUndo->findBatchList();

$selectedFlag = true;

$undo_batch_id = $importUndo->undo_batch_id;

echo 'LAST BATCH ID: ' . ($undo_batch_id - 1);
echo '<br>';
echo '<br>';

echo '<br>';
echo '<br>';

$workToDo = false;

$batchId = -1;

if ($_POST['batch'] > 0) {
	$batchId = $_REQUEST['batch'];
	$workToDo = true;
}


if (!$workToDo) {

	$showTable = true;

	if (($undo_batch_id - 1) == 0) {
		$showTable = false;
	}
	
	if ($showTable) {

		echo '<table border="1">';
		
		echo '<tr>';
		
		echo '<td>';
		//Filename       Batch Id     Created
			echo 'Filename';
		echo '</td>';
		echo '<td>';
			echo 'Batch Id';
		echo '</td>';
		
		echo '<td>';
			echo 'Created';
		echo '</td>';
		
		echo '<tr>';
	
		echo '<tr>';
		echo '</tr>';
		
		echo '<form name="undo" action="" method="post">';
		
		foreach ($list as $key => $val) {
			echo '<tr>';
	
			echo '<td>';
			// auto select the first one
			if ($selectedFlag) {
				echo '<input type="radio" name="batch" checked="checked" value="'.$val['undo_batch_id'].'">';
				$selectedFlag = false;
			} else {
				echo '<input type="radio" name="batch" value="'.$val['undo_batch_id'].'">';
			}
	
				echo $val['import_file'];
			echo '</td>';
		
			echo '<td>';
				echo $val['undo_batch_id'];
			echo '</td>';
		
			echo '<td>';
				echo $val['created'];
			echo '</td>';
	
			echo '</tr>';
	
		}
	
		if ($selectedFlag) {
			echo '<tr>';
	
			echo '<td>';
				echo '<input type="radio" name="batch" checked="checked" value="'.'0'.'"> None';
			echo '</td>';
			echo '<td>';
			echo '</td>';
				echo ' ';
			echo '<td>';
				echo ' ';
			echo '</td>';
	
			echo '</tr>';
	
			$selectedFlag = false;
		} else {
	
			echo '<tr>';
	
			echo '<td>';
				echo '<input type="radio" name="batch" value="'.'0'.'"> None';
			echo '</td>';
			echo '<td>';
				echo ' ';
			echo '</td>';
			echo '<td>';
				echo ' ';
			echo '</td>';
	
			echo '</tr>';
	
		}
		echo '<tr>';
		echo '</tr>';
	
		echo '<td>';
			echo '<input name="Submit" type="submit" value="Perform Undo">';
		echo '</td>';
		echo '<td>';
			echo ' ';
		echo '</td>';
		echo '<td>';
			echo ' ';
		echo '</td>';
	
		echo '</form>';
	
		echo '</table>';
		echo '<br>';
	} else {
		echo 'Nothing to Undo';
	}
	
} else {


	echo 'Performing Undo';
	echo '<br>';
	
	echo 'Clearing Batch Number: [' . $batchId . ']';

	$importUndo->performUndo($batchId);
}

?>
