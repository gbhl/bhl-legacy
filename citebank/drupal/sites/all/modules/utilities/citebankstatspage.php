<?php
global $user;
$showFlag = true;
// security check
if (!($user->uid == 1 || $user->uid == 3 || $user->uid == 60 || $user->uid == 52)) {
 //print_r('No stats available');
 //return;
$showFlag = false;
}

$includePath = dirname(__FILE__) . '/';
$modulesPath = $includePath . '../sites/all/modules/citebank_importer/';
require_once($modulesPath . 'DBInterfaceController.php');

/**
 * class DBInterfaceController  - database interface to simplify database setup and calling
 *
 */
class DBInterfaceController_stats extends DBInterfaceController
{
}

$dbi = new DBInterfaceController_stats();


statsEchoLine();
statsEchoDate();
statsEchoLine();

if ($showFlag) {

// total citations
$msg = '	* Total citations: ';
$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE n.type = 'biblio'";
$totalCitations = getStat($dbi, $msg, $sql);

//	* Citations with PDFs from BHL: 
//$msg = '	* Citations with PDFs from BHL: ';
//$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND c.link LIKE '%.pdf' AND c.link LIKE '%biodiversity%'";
//$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND c.link LIKE '%.pdf'";
//$sql = "SELECT COUNT(DISTINCT c.nid) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND b.biblio_label LIKE '%biodiversity%' AND (b.biblio_type = 100 OR b.biblio_type = 102 OR b.biblio_type = 131) AND c.link LIKE '%.pdf'";
//getStat($dbi, $msg, $sql);

//	* Citations without PDFs attached: 
//$msg = '	* Citations without PDFs attached: ';
//$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND c.link NOT LIKE '%.pdf'";
//$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND (c.link NOT LIKE '%.pdf' AND c.link NOT LIKE '%archive.org%' AND c.link NOT LIKE '%citebank.org%')";
//getStat($dbi, $msg, $sql);

//	* Citations from BHL: 
//SELECT COUNT(*) FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE TYPE = 'biblio' AND b.biblio_url LIKE '%biodiversity%'
$msg = '	* BHL Digitized Titles (All): ';
$sql = "SELECT COUNT(*) AS total FROM biblio WHERE biblio_label LIKE '%biodiversity%'";
getStat($dbi, $msg, $sql);

$msg = '	* BHL Digitized Titles (Book records): ';
$sql = "SELECT COUNT(*) AS total FROM biblio WHERE biblio_label LIKE '%biodiversity%' AND biblio_type = 100";getStat($dbi, $msg, $sql);

$msg = '	* BHL Digitized Titles (Journal Article records) Citations with PDFs from BHL: ';
$sql = "SELECT COUNT(*) AS total FROM biblio WHERE biblio_label LIKE '%biodiversity%' AND biblio_type = 102";
getStat($dbi, $msg, $sql);

$msg = '	* BHL Digitized Titles (Journal records): ';
$sql = "SELECT COUNT(*) AS total FROM biblio WHERE biblio_label LIKE '%biodiversity%' AND biblio_type = 131";
getStat($dbi, $msg, $sql);

//$msg = '	* BHL Digitized Titles (Book and Journal records): ';
//$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND c.link LIKE '%biodiversity%'";
//getStat($dbi, $msg, $sql);

//	* Citations from Scielo: 
$msg = '	* Citations from Scielo: ';
$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND c.link LIKE '%scielo%'";
getStat($dbi, $msg, $sql);

//	* Citations from various sources: 
$msg = '	* Citations from various sources: ';
$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND c.link LIKE '%handle.net%'";
getStat($dbi, $msg, $sql);

//	* Citations from Pensoft: 
$msg = '	* Citations from Pensoft: ';
//$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND b.biblio_label LIKE '%pensof%'";
$sql = "SELECT COUNT(*) AS total FROM biblio WHERE biblio_label LIKE '%Pensoft%'";
getStat($dbi, $msg, $sql);

//	* Citations from Zookeys: 
$msg = '	* Citations from Zookeys: ';
$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND c.link LIKE '%zookey%' AND b.biblio_label LIKE '%pensof%'";
getStat($dbi, $msg, $sql);

//	* Citations from Journal of the American Mosquito Control Association: 
$msg = '	* Citations from Journal of the American Mosquito Control Association: ';
$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND b.biblio_label LIKE '%Journal of the American Mosquito Control Association%'";
getStat($dbi, $msg, $sql);

//	* Citations from AMNH: 
$msg = '	* Citations from AMNH (American Museum of Natural History): ';
$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND b.biblio_label LIKE '%AMNH%'";
getStat($dbi, $msg, $sql);

//	* Citations from AMNH: 
$msg = '	* Citations from AMNH (Journal of the American Mosquito Control Association): ';
$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND b.biblio_label LIKE '%AMNH%'";
getStat($dbi, $msg, $sql);

//	* Citations from AMNH: 
$msg = '	* Citations from AMNH (AMNH Scientific Publications Library): ';
$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND b.biblio_label LIKE '%Scientific Publications Library%'";
getStat($dbi, $msg, $sql);


//SELECT COUNT(*) AS total FROM biblio WHERE biblio_remote_db_provider LIKE '%CSIC%';
//	* Citations from Biblioteca Digital del Real Jardín Botánico de Madrid - CSIC: 
$msg = '	* Citations from Biblioteca Digital del Real Jardín Botánico de Madrid - CSIC: ';
$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) JOIN citebank_unique_identifier as c ON (b.nid = c.nid) WHERE n.type = 'biblio' AND b.biblio_remote_db_provider LIKE '%CSIC%'";
getStat($dbi, $msg, $sql);


statsEchoLine();

//	* Registerered CiteBank users: 
$msg = '	* Registerered CiteBank users: ';
$sql = "SELECT COUNT(*) AS total FROM users WHERE STATUS = 1";
getStat($dbi, $msg, $sql);

//	* Registerered CiteBank users: 
$msg = '	* Active Registerered CiteBank users: ';
$sql = "SELECT COUNT(*) AS total FROM users WHERE STATUS = 1 AND access > 0 AND login > 0";
getStat($dbi, $msg, $sql);

statsEchoLine();

// total citations sent to IA
$msg = '	* Total citations sent to IA (Citebank hosted data): ';
$sql = "SELECT COUNT(DISTINCT nid) AS total FROM citebank_internet_archive_records WHERE archive_status > 0";
$totalIACitations = getStat($dbi, $msg, $sql);

$percentageToIA = round(($totalIACitations / $totalCitations) * 100);
	echo '<br>';
	$msg = '	* Percentage Citations sent to IA: ';
	echo $msg . $percentageToIA . '%';

// total citations in queue for IA
$msg = '	* Total citations in queue to IA: ';
$sql = "SELECT COUNT(DISTINCT nid) AS total FROM citebank_internet_archive_records WHERE archive_status = 0";
getStat($dbi, $msg, $sql);

// total citations on hold for IA
$msg = '	* Total citations on hold for IA: ';
$sql = "SELECT COUNT(DISTINCT nid) AS total FROM citebank_internet_archive_records WHERE archive_status < -1";
getStat($dbi, $msg, $sql);

$totalCitationsExternallyHosted = $totalCitations - $totalIACitations;
echo '<br>';
$msg = '	* Total Citations Externally Hosted: ';
echo $msg . $totalCitationsExternallyHosted;

// ****************************************
// ****************************************
// ****************************************

} else { // just public stats
// total citations
$msg = '	* Total citations: ';
$sql = "SELECT COUNT(*) AS total FROM node AS n JOIN biblio AS b ON (n.nid = b.nid) WHERE n.type = 'biblio'";
getStat($dbi, $msg, $sql);



}

statsEchoLine();


/*
 *
 */
function getStat($dbi, $msg, $sql)
{
	$rows = $dbi->fetch($sql);
	$count = 0;
	if (count($rows) > 0) {
		$count = $rows[0]['total'];
	}
	
	echo '<br>';
	echo $msg . $count;
	
	return $count;
}

/*
 *
 */
function statsEchoLine()
{
	echo '<br>';
	echo '<hr>';
//	echo '-----------------------------------------------------------------------';
	echo '<br>';
	
}

/*
 *
 */
function statsEchoDate()
{
	//citestats - CiteBank stats updated Thu Nov 17 01:01:01 CST 2011	
	echo '<br>';
	echo 'citestats - CiteBank stats updated ' .  date('D M d Y H:i:s T') . ' 	';
	echo '<br>';
	echo 'note: numbers are not currently entirely accurate, work in progress';
	echo '<br>';

	
}

?>
