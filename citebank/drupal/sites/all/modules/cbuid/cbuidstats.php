<?php

	/**
	 * cleanse - clean up the input to avoid hackery
	 */
	function cleanse($val)
	{
		// clean the input
		$val = htmlspecialchars(stripslashes($val));
		$val = str_ireplace('script', 'blocked', $val);
		//$val = mysql_real_escape_string($val);
		
		return $val;
	}


//$stampStart = date('YmdHis');

$runflag = $_GET['run'];

if ($runflag == 1) {
	;
//	echo 'Go run it';
} else {
//	echo 'Not run';
	return;
}

//$loVal = $_GET['lo'];
//$hiVal = $_GET['hi'];
//
//$lo = cleanse($loVal);
//$hi = cleanse($hiVal);
//if ($lo <= 131852 || $hi <= 131852) {
//	return;
//} else {
//
//	echo '<br>';
//	
//	echo 'lo: [';
//	echo $lo;
//	echo ']';
//	echo '<br>';
//	
//	echo 'hi: [';
//	echo $hi;
//	echo ']';
//	echo '<br>';
//}



$includePath = dirname(__FILE__) . '/';

require_once($includePath . 'CitebankUniqueIdentifierProcessor.php');

require_once($includePath . 'DBInterfaceController.php');
$dbi = new DBInterfaceController();


$x = new CitebankUniqueIdentifierProcessor();
$x->setDb($dbi);

#$msg = 'begin cbuid';
#$x->model->watchdog($msg);


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

?>
