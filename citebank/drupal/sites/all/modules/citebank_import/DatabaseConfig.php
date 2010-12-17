<?php

	/**
	 * MySQL Database Credentials
	 */
	switch ($useDB)
	{
		case 'localhost':
			// localhost
			define('DB_HOST', 'localhost'); 
			define('DB_USER', 'root');
			define('DB_PASS', '');
			define('DEF_DATABASE', 'citebanktest');
			break;

		case 'dev5':
			// DEV 5
			define('DB_HOST', '172.16.17.194'); 
			define('DB_USER', 'dheskett');
			define('DB_PASS', 'm0b0t1234');
			define('DEF_DATABASE', 'demo');
			break;

		case 'dev4':
		case 'dev4devtest':
			// DEV 4
			define('DB_HOST', '172.16.17.197'); 
			define('DB_USER', 'dheskett');
			define('DB_PASS', 'm0b0t1234');
			//define('DEF_DATABASE', 'test1');
			//define('DEF_DATABASE', 'test2');
			define('DEF_DATABASE', 'test3');
			break;

		case 'dev4web':
			// DEV 4
			define('DB_HOST', '172.16.17.197'); 
			define('DB_USER', 'importer');
			define('DB_PASS', '@dd0n1y!');
			//define('DEF_DATABASE', 'test1');
			//define('DEF_DATABASE', 'test2');
			define('DEF_DATABASE', 'test3');
			break;

		default:
		case 'dev4a':
			// DEV 5 really
			define('DB_HOST', '172.16.17.194'); 
			define('DB_USER', 'root');
			define('DB_PASS', 'w2ffl3s1');
			//define('DEF_DATABASE', 'test1');
			//define('DEF_DATABASE', 'test2');
			define('DEF_DATABASE', 'test3');
			break;
	}
