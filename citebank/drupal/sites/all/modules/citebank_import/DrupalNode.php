<?php
// $Id: DrupalNode.php,v 1.0.0.0 2010/11/15 4:44:44 dlheskett $

/**  DrupalNode class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author: David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 11/15/2010
 *
 */

/** 
 * class DrupalNode - holds a drupal node data item
 * 
 */
class DrupalNode
{
	public $nid       = 0;
	public $vid       = 0;
	public $type      = self::DRUPAL_NODE_TYPE;
	public $language  = '';
	public $title     = '';
	public $uid       = 0;
	public $status    = self::DRUPAL_NODE_STATUS;
	public $created   = 0;
	public $changed   = 0;

	public $comment   = 0;
	public $promote   = 1;
	public $moderate  = 0;
	public $sticky    = 0;
	public $tnid      = 0;
	public $translate = 0;
	public $mimeTypeList = array();
	//public $xc_type   = '';
	//public $xc_id     = '';

	const CLASS_NAME    = 'DrupalNode';
	const DRUPAL_NODE_TYPE    = 'biblio'; // for biblio entries which we will mostly be doing for this
	const DRUPAL_NODE_STATUS  = 1;        // 1 is ?  drupal, what does that value mean?
	const DRUPAL_NODE_TABLE   = 'node';
	const DRUPAL_FILE_STORAGE = 'sites/default/files/';
	/*
		status = 1   to publish, 0 no publish
		
		promote = 1   to promote to front page, 0 to not
		
		sticky = 0    1 if do not wnat content sticky
	*/

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
	}

	/**
	 * processNode - process the node, store it or something
	 */
	function processNode($node)
	{
		foreach ($node as $key => $val) {
			;
		}
	}

	/**
	 * mimetypes - make a mime type list, based on file extension
	 */
	function mimetypes()
	{
		// MIME (Multipurpose Internet Mail Extensions)
		// http://www.w3schools.com/media/media_mimeref.asp
		//
		// see also  http://www.iana.org/assignments/media-types/
		//           http://www.feedforall.com/mime-types.htm
		//           http://www.htmlquick.com/reference/mime-types.html
		//

		$mimetype['']        = 'application/octet-stream';
		$mimetype['323']     = 'text/h323';
		$mimetype['acx']     = 'application/internet-property-stream';
		$mimetype['ai']      = 'application/postscript';
		$mimetype['aif']     = 'audio/x-aiff';
		$mimetype['aifc']    = 'audio/x-aiff';
		$mimetype['aiff']    = 'audio/x-aiff';
		$mimetype['asc']     = 'text/plain';
		$mimetype['asf']     = 'video/x-ms-asf';
		$mimetype['asr']     = 'video/x-ms-asf';
		$mimetype['asx']     = 'video/x-ms-asf';
		$mimetype['atom']    = 'application/atom+xml';
		$mimetype['au']      = 'audio/basic';
		$mimetype['avi']     = 'video/x-msvideo';
		$mimetype['axs']     = 'application/olescript';
		$mimetype['bas']     = 'text/plain';
		$mimetype['bcpio']   = 'application/x-bcpio';
		$mimetype['bin']     = 'application/octet-stream';
		$mimetype['bmp']     = 'image/bmp';
		$mimetype['c']       = 'text/plain';
		$mimetype['cat']     = 'application/vnd.ms-pkiseccat';
		$mimetype['cdf']     = 'application/x-cdf';
		$mimetype['cer']     = 'application/x-x509-ca-cert';
		$mimetype['cgm']     = 'image/cgm';
		$mimetype['class']   = 'application/octet-stream';
		$mimetype['clp']     = 'application/x-msclip';
		$mimetype['cmx']     = 'image/x-cmx';
		$mimetype['cod']     = 'image/cis-cod';
		$mimetype['cpio']    = 'application/x-cpio';
		$mimetype['cpt']     = 'application/mac-compactpro';
		$mimetype['crd']     = 'application/x-mscardfile';
		$mimetype['crl']     = 'application/pkix-crl';
		$mimetype['crt']     = 'application/x-x509-ca-cert';
		$mimetype['csh']     = 'application/x-csh';
		$mimetype['css']     = 'text/css';
		$mimetype['dcr']     = 'application/x-director';
		$mimetype['der']     = 'application/x-x509-ca-cert';
		$mimetype['dif']     = 'video/x-dv';
		$mimetype['dir']     = 'application/x-director';
		$mimetype['djv']     = 'image/vnd.djvu';
		$mimetype['djvu']    = 'image/vnd.djvu';
		$mimetype['dll']     = 'application/x-msdownload';
		$mimetype['dmg']     = 'application/octet-stream';
		$mimetype['dms']     = 'application/octet-stream';
		$mimetype['doc']     = 'application/msword';
		$mimetype['dot']     = 'application/msword';
		$mimetype['dtd']     = 'application/xml-dtd';
		$mimetype['dv']      = 'video/x-dv';
		$mimetype['dvi']     = 'application/x-dvi';
		$mimetype['dxr']     = 'application/x-director';
		$mimetype['eps']     = 'application/postscript';
		$mimetype['etx']     = 'text/x-setext';
		$mimetype['evy']     = 'application/envoy';
		$mimetype['exe']     = 'application/octet-stream';
		$mimetype['ez']      = 'application/andrew-inset';
		$mimetype['fif']     = 'application/fractals';
		$mimetype['flr']     = 'x-world/x-vrml';
		$mimetype['gif']     = 'image/gif';
		$mimetype['gram']    = 'application/srgs';
		$mimetype['grxml']   = 'application/srgs+xml';
		$mimetype['gtar']    = 'application/x-gtar';
		$mimetype['gz']      = 'application/x-gzip';
		$mimetype['h']       = 'text/plain';
		$mimetype['hdf']     = 'application/x-hdf';
		$mimetype['hlp']     = 'application/winhlp';
		$mimetype['hqx']     = 'application/mac-binhex40';
		$mimetype['hta']     = 'application/hta';
		$mimetype['htc']     = 'text/x-component';
		$mimetype['htm']     = 'text/html';
		$mimetype['html']    = 'text/html';
		$mimetype['htt']     = 'text/webviewhtml';
		$mimetype['ice']     = 'x-conference/x-cooltalk';
		$mimetype['ico']     = 'image/x-icon';
		$mimetype['ics']     = 'text/calendar';
		$mimetype['ief']     = 'image/ief';
		$mimetype['ifb']     = 'text/calendar';
		$mimetype['iges']    = 'model/iges';
		$mimetype['igs']     = 'model/iges';
		$mimetype['iii']     = 'application/x-iphone';
		$mimetype['ins']     = 'application/x-internet-signup';
		$mimetype['isp']     = 'application/x-internet-signup';
		$mimetype['jfif']    = 'image/pipeg';
		$mimetype['jnlp']    = 'application/x-java-jnlp-file';
		$mimetype['jp2']     = 'image/jp2';
		$mimetype['jpe']     = 'image/jpeg';
		$mimetype['jpeg']    = 'image/jpeg';
		$mimetype['jpg']     = 'image/jpeg';
		$mimetype['js']      = 'application/x-javascript';
		$mimetype['kar']     = 'audio/midi';
		$mimetype['latex']   = 'application/x-latex';
		$mimetype['lha']     = 'application/octet-stream';
		$mimetype['lsf']     = 'video/x-la-asf';
		$mimetype['lsx']     = 'video/x-la-asf';
		$mimetype['lzh']     = 'application/octet-stream';
		$mimetype['m13']     = 'application/x-msmediaview';
		$mimetype['m14']     = 'application/x-msmediaview';
		$mimetype['m3u']     = 'audio/x-mpegurl';
		$mimetype['m4a']     = 'audio/mp4a-latm';
		$mimetype['m4b']     = 'audio/mp4a-latm';
		$mimetype['m4p']     = 'audio/mp4a-latm';
		$mimetype['m4u']     = 'video/vnd.mpegurl';
		$mimetype['m4v']     = 'video/x-m4v';
		$mimetype['mac']     = 'image/x-macpaint';
		$mimetype['man']     = 'application/x-troff-man';
		$mimetype['mathml']  = 'application/mathml+xml';
		$mimetype['mdb']     = 'application/x-msaccess';
		$mimetype['me']      = 'application/x-troff-me';
		$mimetype['mesh']    = 'model/mesh';
		$mimetype['mht']     = 'message/rfc822';
		$mimetype['mhtml']   = 'message/rfc822';
		$mimetype['mid']     = 'audio/midi';
		$mimetype['midi']    = 'audio/midi';
		$mimetype['mif']     = 'application/vnd.mif';
		$mimetype['mny']     = 'application/x-msmoney';
		$mimetype['mov']     = 'video/quicktime';
		$mimetype['movie']   = 'video/x-sgi-movie';
		$mimetype['mp2']     = 'audio/mpeg';
		$mimetype['mp3']     = 'audio/mpeg';
		$mimetype['mp4']     = 'video/mp4';
		$mimetype['mpa']     = 'video/mpeg';
		$mimetype['mpe']     = 'video/mpeg';
		$mimetype['mpeg']    = 'video/mpeg';
		$mimetype['mpg']     = 'video/mpeg';
		$mimetype['mpga']    = 'audio/mpeg';
		$mimetype['mpp']     = 'application/vnd.ms-project';
		$mimetype['mpv2']    = 'video/mpeg';
		$mimetype['ms']      = 'application/x-troff-ms';
		$mimetype['msh']     = 'model/mesh';
		$mimetype['mvb']     = 'application/x-msmediaview';
		$mimetype['mxu']     = 'video/vnd.mpegurl';
		$mimetype['nc']      = 'application/x-netcdf';
		$mimetype['nws']     = 'message/rfc822';
		$mimetype['oda']     = 'application/oda';
		$mimetype['ogg']     = 'application/ogg';
		$mimetype['p10']     = 'application/pkcs10';
		$mimetype['p12']     = 'application/x-pkcs12';
		$mimetype['p7b']     = 'application/x-pkcs7-certificates';
		$mimetype['p7c']     = 'application/x-pkcs7-mime';
		$mimetype['p7m']     = 'application/x-pkcs7-mime';
		$mimetype['p7r']     = 'application/x-pkcs7-certreqresp';
		$mimetype['p7s']     = 'application/x-pkcs7-signature';
		$mimetype['pbm']     = 'image/x-portable-bitmap';
		$mimetype['pct']     = 'image/pict';
		$mimetype['pdb']     = 'chemical/x-pdb';
		$mimetype['pdf']     = 'application/pdf';
		$mimetype['pfx']     = 'application/x-pkcs12';
		$mimetype['pgm']     = 'image/x-portable-graymap';
		$mimetype['pgn']     = 'application/x-chess-pgn';
		$mimetype['pic']     = 'image/pict';
		$mimetype['pict']    = 'image/pict';
		$mimetype['pko']     = 'application/ynd.ms-pkipko';
		$mimetype['pma']     = 'application/x-perfmon';
		$mimetype['pmc']     = 'application/x-perfmon';
		$mimetype['pml']     = 'application/x-perfmon';
		$mimetype['pmr']     = 'application/x-perfmon';
		$mimetype['pmw']     = 'application/x-perfmon';
		$mimetype['png']     = 'image/png';
		$mimetype['pnm']     = 'image/x-portable-anymap';
		$mimetype['pnt']     = 'image/x-macpaint';
		$mimetype['pntg']    = 'image/x-macpaint';
		$mimetype['pot,']    = 'application/vnd.ms-powerpoint';
		$mimetype['ppm']     = 'image/x-portable-pixmap';
		$mimetype['pps']     = 'application/vnd.ms-powerpoint';
		$mimetype['ppt']     = 'application/vnd.ms-powerpoint';
		$mimetype['prf']     = 'application/pics-rules';
		$mimetype['ps']      = 'application/postscript';
		$mimetype['psd']     = 'application/octet-stream';
		$mimetype['pub']     = 'application/x-mspublisher';
		$mimetype['qt']      = 'video/quicktime';
		$mimetype['qti']     = 'image/x-quicktime';
		$mimetype['qtif']    = 'image/x-quicktime';
		$mimetype['ra']      = 'audio/x-pn-realaudio';
		$mimetype['ram']     = 'audio/x-pn-realaudio';
		$mimetype['ras']     = 'image/x-cmu-raster';
		$mimetype['rdf']     = 'application/rdf+xml';
		$mimetype['rgb']     = 'image/x-rgb';
		$mimetype['rm']      = 'application/vnd.rn-realmedia';
		$mimetype['rmi']     = 'audio/mid';
		$mimetype['roff']    = 'application/x-troff';
		$mimetype['rtf']     = 'application/rtf';
		$mimetype['rtx']     = 'text/richtext';
		$mimetype['scd']     = 'application/x-msschedule';
		$mimetype['sct']     = 'text/scriptlet';
		$mimetype['setpay']  = 'application/set-payment-initiation';
		$mimetype['setreg']  = 'application/set-registration-initiation';
		$mimetype['sgm']     = 'text/sgml';
		$mimetype['sgml']    = 'text/sgml';
		$mimetype['sh']      = 'application/x-sh';
		$mimetype['shar']    = 'application/x-shar';
		$mimetype['silo']    = 'model/mesh';
		$mimetype['sit']     = 'application/x-stuffit';
		$mimetype['skd']     = 'application/x-koan';
		$mimetype['skm']     = 'application/x-koan';
		$mimetype['skp']     = 'application/x-koan';
		$mimetype['skt']     = 'application/x-koan';
		$mimetype['smi']     = 'application/smil';
		$mimetype['smil']    = 'application/smil';
		$mimetype['snd']     = 'audio/basic';
		$mimetype['so']      = 'application/octet-stream';
		$mimetype['spc']     = 'application/x-pkcs7-certificates';
		$mimetype['spl']     = 'application/futuresplash';
		$mimetype['src']     = 'application/x-wais-source';
		$mimetype['sst']     = 'application/vnd.ms-pkicertstore';
		$mimetype['stl']     = 'application/vnd.ms-pkistl';
		$mimetype['stm']     = 'text/html';
		$mimetype['sv4cpio'] = 'application/x-sv4cpio';
		$mimetype['sv4crc']  = 'application/x-sv4crc';
		$mimetype['svg']     = 'image/svg+xml';
		$mimetype['swf']     = 'application/x-shockwave-flash';
		$mimetype['t']       = 'application/x-troff';
		$mimetype['tar']     = 'application/x-tar';
		$mimetype['tcl']     = 'application/x-tcl';
		$mimetype['tex']     = 'application/x-tex';
		$mimetype['texi']    = 'application/x-texinfo';
		$mimetype['texinfo'] = 'application/x-texinfo';
		$mimetype['tgz']     = 'application/x-compressed';
		$mimetype['tif']     = 'image/tiff';
		$mimetype['tiff']    = 'image/tiff';
		$mimetype['tr']      = 'application/x-troff';
		$mimetype['trm']     = 'application/x-msterminal';
		$mimetype['tsv']     = 'text/tab-separated-values';
		$mimetype['txt']     = 'text/plain';
		$mimetype['uls']     = 'text/iuls';
		$mimetype['ustar']   = 'application/x-ustar';
		$mimetype['vcd']     = 'application/x-cdlink';
		$mimetype['vcf']     = 'text/x-vcard';
		$mimetype['vrml']    = 'x-world/x-vrml';
		$mimetype['vxml']    = 'application/voicexml+xml';
		$mimetype['wav']     = 'audio/x-wav';
		$mimetype['wbmp']    = 'image/vnd.wap.wbmp';
		$mimetype['wbmxl']   = 'application/vnd.wap.wbxml';
		$mimetype['wcm']     = 'application/vnd.ms-works';
		$mimetype['wdb']     = 'application/vnd.ms-works';
		$mimetype['wks']     = 'application/vnd.ms-works';
		$mimetype['wmf']     = 'application/x-msmetafile';
		$mimetype['wml']     = 'text/vnd.wap.wml';
		$mimetype['wmlc']    = 'application/vnd.wap.wmlc';
		$mimetype['wmls']    = 'text/vnd.wap.wmlscript';
		$mimetype['wmlsc']   = 'application/vnd.wap.wmlscriptc';
		$mimetype['wps']     = 'application/vnd.ms-works';
		$mimetype['wri']     = 'application/x-mswrite';
		$mimetype['wrl']     = 'x-world/x-vrml';
		$mimetype['wrz']     = 'x-world/x-vrml';
		$mimetype['xaf']     = 'x-world/x-vrml';
		$mimetype['xbm']     = 'image/x-xbitmap';
		$mimetype['xht']     = 'application/xhtml+xml';
		$mimetype['xhtml']   = 'application/xhtml+xml';
		$mimetype['xla']     = 'application/vnd.ms-excel';
		$mimetype['xlc']     = 'application/vnd.ms-excel';
		$mimetype['xlm']     = 'application/vnd.ms-excel';
		$mimetype['xls']     = 'application/vnd.ms-excel';
		$mimetype['xlt']     = 'application/vnd.ms-excel';
		$mimetype['xlw']     = 'application/vnd.ms-excel';
		$mimetype['xml']     = 'application/xml';
		$mimetype['xof']     = 'x-world/x-vrml';
		$mimetype['xpm']     = 'image/x-xpixmap';
		$mimetype['xsl']     = 'application/xml';
		$mimetype['xslt']    = 'application/xslt+xml';
		$mimetype['xul']     = 'application/vnd.mozilla.xul+xml';
		$mimetype['xwd']     = 'image/x-xwindowdump';
		$mimetype['xyz']     = 'chemical/x-xyz';
		$mimetype['z']       = 'application/x-compress';
		$mimetype['zip']     = 'application/zip';		

		$this->mimeTypeList = $mimetype;
		
		return $this->mimeTypeList;
	}
	
	/**
	 * getMimeTypeName - get mime type based on file extension
	 */
	function getMimeTypeName($type)
	{
		static $mimeTypeListFlag = false;  // we only want to build the list once
		
		$mimeType = '';
		
		if ($mimeTypeListFlag) {
			$mimeType = $this->mimeTypeList[$type];
		} else {
			$this->mimetypes();  // load the list once
			$mimeTypeListFlag = true;
			
			$mimeType = $this->mimeTypeList[$type];
		}
		
		return $mimeType;
	}

	/**
	 * getMimeType - get mime type based on file extension
	 */
	function getMimeType($filename)
	{
		$mimetype = '';
		$filebits = explode('.', $filename);
		$n = count($filebits) - 1;
		$ext = $filebits[$n]; // get the extension
		$ext = strtolower($ext);
		
		// no ext, let's go for text then, not ideal, but we don't really know what it is then either
		if ($n == 0) {
			$mimetype = 'text/plain';
			return $mimetype;
		}
		
		// find common mimetypes, or do lookup from list
		switch ($ext)
		{
			case 'pdf':
				$mimetype = 'application/pdf';
				break;

			case 'gif':
				$mimetype = 'image/gif';
				break;

			case 'jpg':
				$mimetype = 'image/jpeg';
				break;

			case 'png':
				$mimetype = 'image/png';
				break;

			case 'xml':
				$mimetype = 'text/xml';
				break;

			case 'zip':
				$mimetype = 'application/zip';
				break;

			case 'tar':
				$mimetype = 'application/tar';
				break;

			case 'txt':
				$mimetype = 'text/plain';
				break;

			default:
				$mimetype = $this->getMimeTypeName($ext);
				break;
		}
		
		return $mimetype;
	}

	// INSERT INTO files AS f SET f.uid = 242, f.filename = '', f.filepath = '', f.filemime = 'application/pdf', f.filesize = 32000, f.status = 1, f.timestamp = 1234560
	/**
	 * makeSqlDBFiles - create the sql to add node to table
	 */
	function makeSqlForDBFiles($filename, $filesize, $uid = 0, $filemime = null, $path = self::DRUPAL_FILE_STORAGE, $resolverFlag = false)
	{
		$sql = '';
		
		$filepath = $path . $filename;
		
		if ($filemime == null) {
			$filemime = $this->getMimeType($filename);
		}

		$openBrace = ($resolverFlag ? '{' : '');
		$clseBrace = ($resolverFlag ? '}' : '');

		$sql = 'INSERT INTO '. $openBrace . 'files' . $clseBrace . ' SET uid = ' . $uid . ', filename = ' . "'" . $filename . "'" . ', filepath = ' . "'" . $filepath . "'" . ', filemime = ' . "'" . $filemime . "'" . ', filesize = ' . $filesize . ', status = 1, timestamp = ' . time() . '';

		return $sql;
	}

	// SELECT f.fid FROM files AS f WHERE f.uid = ' . $uid . ' AND f.filename = ' . $filename . ''
	/**
	 * getFilesFid - create the sql to add node to table
	 */
	function getFilesFid($filename, $uid = 0, $resolverFlag = false)
	{
		$sql = '';

		$openBrace = ($resolverFlag ? '{' : '');
		$clseBrace = ($resolverFlag ? '}' : '');

		if ($uid > 0) {
			// { table }  braces for drupals database name resolver
			$sql = 'SELECT fid FROM '. $openBrace . 'files' . $clseBrace . ' WHERE uid = ' . $uid . ' AND filename = ' . "'" . $filename . "'" . '';
		} else {
			// { table }  braces for drupals database name resolver
			$sql = 'SELECT fid FROM '. $openBrace . 'files' . $clseBrace . ' WHERE filename = ' . "'" . $filename . "'" . '';
		}

		return $sql;
	}

	// INSERT INTO upload AS u SET u.fid = ' . $fid . ', u.nid = ' . $nid . ', u.description = ' . $filename . ', u.list = 1, u.weight = 0
	/**
	 * makeSqlDBUpload - create the sql to add node to table
	 */
	function makeSqlForDBUpload($fid, $nid, $filename, $resolverFlag = false)
	{
		$sql = '';

		$openBrace = ($resolverFlag ? '{' : '');
		$clseBrace = ($resolverFlag ? '}' : '');

		// { table }  braces for drupals database name resolver
		//$sql = 'INSERT INTO '. $openBrace . 'upload' . $clseBrace . ' SET fid = ' . $fid . ', nid = ' . $nid . ', description = ' . "'" . $filename . "'" . ', list = 1, weight = 0';
		// FIXME: does vid need to be independantly set?  [vid = ' . $nid]
		$sql = 'INSERT INTO '. $openBrace . 'upload' . $clseBrace . ' SET fid = ' . $fid . ', nid = ' . $nid . ', vid = ' . $nid . ', description = ' . "'" . $filename . "'" . ', list = 1, weight = 0';

		return $sql;
	}

	/**
	 * makeSqlForNodeAccess - create the sql to add node access
	 */
	function makeSqlForNodeAccess($nid, $resolverFlag = false)
	{
		$sql = '';

		$openBrace = ($resolverFlag ? '{' : '');
		$clseBrace = ($resolverFlag ? '}' : '');

		// { table }  braces for drupals database name resolver
		// "INSERT INTO {node_access} VALUES (0, 0, 'all', 1, 0, 0)"
		$sql = 'INSERT INTO '. $openBrace . 'node_access' . $clseBrace . ' SET nid = ' . $nid . ', gid = ' . '0' . ', realm = '  . "'" . 'all' .  "'" . ', grant_view = ' . '1' . ', grant_update = 0, grant_delete = 0';

		return $sql;
	}

	/**
	 * makeSql - create the sql to add node to table
	 */
	function makeSql($node, $resolverFlag = false)
	{
		$sql = '';
		
		// { table }  braces for drupals database name resolver
		$tbl =  self::DRUPAL_NODE_TABLE;
		$openBrace = ($resolverFlag ? '{' : '');
		$clseBrace = ($resolverFlag ? '}' : '');
		
		$sql .= 'INSERT INTO ' . $openBrace . $tbl . $clseBrace . ' SET';

		foreach ($node as $key => $val) {

			switch ($key)
			{
				case 'type':
				case 'title':
				case 'language':
				case 'xc_type':
				case 'xc_id':
					$sql .= ' ' . $key . ' = ' . "'" . $val . "'";  // strings are quoted
					break;
					
				default:
					$sql .= ' ' . $key . ' = ' . $val;              // numbers are not quoted
					break;
			}

			$sql .= ','; // add commas
		}
		
		$sql = rtrim($sql, ','); // drop the trailing comma
		
		return $sql;
	}

	/**
	 * displayNode - show it, mostly for dev testing
	 */
	function displayNode($node)
	{
		foreach ($node as $key => $val) {
			echo $key;
			echo ': [';
			echo $val;
			echo ']';
			echo '<br>';
			echo "\n";
		}
	}

	/**
	 * makeNode - set a nodes title and user id if specified, use defaults.
	 */
	function makeNode($title = '', $uid = 0)
	{
		$nid       = $this->nid;
		$vid       = ($this->vid ? $this->vid : $this->nid);  // if vid use that, else use the Nid
		$type      = $this->type; //'biblio'
		$language  = $this->language;
		$title     = ($title ? $title : $this->title);
		$uid       = ($uid ? $uid : $this->uid);
		$status    = $this->status;
		$created   = time();
		$changed   = $created;
		
		$comment   = $this->comment;
		$promote   = $this->promote;
		$moderate  = $this->moderate;
		$sticky    = $this->sticky;
		$tnid      = $this->tnid;
		$translate = $this->translate;
		//$xc_type   = $this->xc_type;
		//$xc_id     = $this->xc_id;
		
		$node['nid']       = $nid;
		$node['vid']       = $vid;
		$node['type']      = $type;
		$node['language']  = $language;
		$node['title']     = $title;
		$node['uid']       = $uid;
		$node['status']    = $status;
		$node['created']   = $created;
		$node['changed']   = $changed;
		$node['comment']   = $comment;
		$node['promote']   = $promote;
		$node['moderate']  = $moderate;
		$node['sticky']    = $sticky;
		$node['tnid']      = $tnid;
		$node['translate'] = $translate;
		//$node['xc_type']   = $xc_type;
		//$node['xc_id']     = $xc_id;
		
		return $node;
	}
	
	/**
	 * findLastNidSql - get the last nid in the database.
	 */
	function findLastNidSql($resolverFlag = false)
	{
		$nid = 0;
		$sql = '';
		
		$tbl =  self::DRUPAL_NODE_TABLE;
		$openBrace = ($resolverFlag ? '{' : '');
		$clseBrace = ($resolverFlag ? '}' : '');
		
		$sql .= 'SELECT nid FROM ' . $openBrace . $tbl . $clseBrace . ' WHERE 1 ORDER BY nid DESC LIMIT 1';

		return $sql;
	}

}  // end class
// ****************************************
// ****************************************
// ****************************************
