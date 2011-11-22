<?php

$stampStart = date('YmdHis');

// simple check to prevent running just by anything hitting it
$runflag = $_GET['run'];

if ($runflag == 1) {
	; // Go run it
} else {
	//	Not run
	return;
}

$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'CitebankUniqueIdentifierProcessor.php');

require_once($includePath . 'DBInterfaceController.php');
$dbi = new DBInterfaceController();


$x = new CitebankUniqueIdentifierProcessor();
$x->setDb($dbi);

$msg = 'begin CBUID processor';
$x->model->watchdog($msg);


// count of items not like 'http://citebank.org/uid'
$count = $x->model->getCountNewItems();
echo 'Count: [';
echo $count;
echo ']';

// get range of new items
$range = $x->model->getLowNidHighNid();

$end = $range['end'];
$lo = $range['lo'];
$hi = $range['hi'];
echo '<br>';
echo 'lo: [';
echo $lo;
echo ']';
echo '<br>';

echo 'hi: [';
echo $hi;
echo ']';
echo '<br>';

echo 'end: [';
echo $end;
echo ']';
echo '<br>';

$total = $x->model->getTotalNewItems();
echo '<br>';
echo 'new items total: [';
echo $total;
echo ']';

if ($lo == $hi) {
	return;
}
// loop for range
// we need nid, url, ....?
// figure out low and high range for ONE TIME process to set the existing CBUID entries.


$list = $x->model->getRecentListRange($lo, $hi);
if ($list) {
	foreach ($list as $listItem) {

		$nid       = $listItem['nid'];
		$biblioUrl = $listItem['url'];
		$oldUrl    = $listItem['oldurl'];

		echo 'insertBiblioUrlToBackup biblioUrl ';
		echo $biblioUrl;
		echo '<br>';
		// BACKUP BIBLIO URL
		$x->model->insertBiblioUrlToBackup($nid, $biblioUrl);
		// live needs some, while staging has none
		// and live range is not match with CBUID items.
	}	
}

$list = $x->model->getRecentListRange($lo, $hi);
if ($list) {
	foreach ($list as $listItem) {

		$nid       = $listItem['nid'];
		$biblioUrl = $listItem['url'];
		$oldUrl    = $listItem['oldurl'];

		// BACKUP BIBLIO URL
		//$x->model->insertBiblioUrlToBackup($nid, $biblioUrl);
		// live needs some, while staging has none
		// and live range is not match with CBUID items.

		echo 'updateBiblioOtherNumber oldUrl ';
		echo $oldUrl;
		echo '<br>';
		$x->model->updateBiblioOtherNumber($nid, $oldUrl);
		
		// IA DETAILS TO DOWNLOAD
		//	add IA details url to citebank_unique_identifier entry
		//	create/change IA details to IA download url
		//	add IA download url to citebank_unique_identifier entry
		//	skip IA items still in queue?
		echo 'biblioUrl ';
		echo $biblioUrl;
		echo '<br>';
		$newIADownloadUrl = $x->model->createIADownloadUrl($biblioUrl);
		echo 'newIADownloadUrl ';
		echo $newIADownloadUrl;
		echo '<br>';
		// ADD CBUID
		//	copy biblio.biblio_url to citebank_unique_identifier.link
		$x->model->add($nid, $biblioUrl);  // put in IA Details url in CBUID
		if ($biblioUrl != $newIADownloadUrl) {
			//$x->model->updateIADetailsUrl($nid, $newIADownloadUrl);
			// ADD CBUID
			$x->model->add($nid, $newIADownloadUrl);
		}
		
		// MAKE BIBLIO URL TO TINY URL
		//	set biblio.biblio_url to tiny citebank url
		echo 'Nid to tiny url ';
		echo $nid;
		echo '<br>';
		$x->model->createTinyUrlupdateBiblioUrl($nid);
	}
}

// count of items not like 'http://citebank.org/uid'
$count = $x->model->getCountNewItems();
echo 'Count: [';
echo $count;
echo ']';



$stampLast = date('YmdHis');
echo '<br>';
echo '<br>';
echo 'Start: [';
echo $stampStart;
echo '] ';
echo '<br>';
echo 'Stop: [';
echo $stampLast;
echo ']';

$msg = 'Start: [' . $stampStart . '] ' . 'Stop: [' . $stampLast . ']';
$x->model->watchdog($msg);

$msg = 'end CBUID processor';
$x->model->watchdog($msg);

?>
