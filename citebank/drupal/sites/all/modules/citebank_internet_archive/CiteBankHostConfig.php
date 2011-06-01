<?php

if (!defined('CITEBANK_HOST')) {
	$pwd = getenv('PWD');
	$pwdArray = explode('/', $pwd);
	$server_host = $pwdArray[3];
	define('CITEBANK_HOST', $server_host);  // dynamically find the host web server
}


?>
