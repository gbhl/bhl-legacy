<?php
// $Id: FedoraFoxXmlController.php,v 1.0.0.0 2010/10/12 4:44:44 dlheskett $

/** FedoraFoxXmlController class
 *
 * Copyright (c) 2010 Missouri Botanical Garden 
 *
 * @author David L. Heskett (contractor: Adaptive Solutions Group)
 * @date Created: 10/12/2010
 *
 */

//$includePath = dirname(__FILE__) . '/';


// FEDORA -  Flexible Extensible Digitial Object and Repository Architecture
/*
http://www.infrae.com/download/fedoracommons/fcrepo

state:
A means active
I means inactive
D means deleted



view-source:https://wiki.duraspace.org/download/attachments/4718716/foxml_reference_example.xml?version=1&modificationDate=1217847185364

    At ingest, each datastream MUST have following attributes: 
      - ID          (required) a unique identifier for the datastream within this object.  User can provide it,
                or if not provided, the system will assign one.
      - STATE      (Required) The datastream state can be Active (A), Inactive (I), or Deleted (D)
      - CONTROL_GROUP (required) indicates the kind of datastream, either Externally Referenced Content (E), 
                Redirected Content (R), Managed Content (M) or Inline XML (X) 
      - MIME        (required per version) user-assigned MIME type of the bytestream.
      
    And at ingest, it may have these optional attributes: 
      - LABEL      (optional per version) user-assigned descriptive label for the datastream 
      - ALT_IDS      (optional per version) user-assigned set of alternative identifiers for the datastream, 
                with the identifiers separated by spaces
      - FORMAT_URI    (optional per version) user-assigned URI used to identify the media type of the bytestream 
                (more specific than MIME type).
      - SIZE        (optional per version) size of the bytestream.
                User can provide it, or Fedora can be configured to calculate it.  
                
    The system will assign these attributes (they should not be put in the ingest file):
      - VERSIONABLE    (system-assigned)  a true/false indication as to whether the datastream should 
                be versioned by the Fedora repository service.  In Fedora 2.0, all datastreams are set to 
                VERSIONABLE="true".  In a future release, selective datastream versioning will be enabled and
                this attribute can then be user-assigned.
      - CREATED      (system-assigned per version) creation date for the datastream version, to the millisecond
      
*/

/** 
 * class FedoraFoxXmlController - build FOXXML, Fedora XML file format
 * 
 */
class FedoraFoxXmlController
{
	public $className;
	public $foxXml;
	
	public $subjectName;
	public $state;
	public $iaBase;
	public $pidName;
	public $pid;         // The maximum length of a PID is 64 characters.  https://wiki.duraspace.org/display/FCR30/Fedora+Identifiers
	public $controlGrp;
	public $baseUrl;
	public $ext;

	public $data;

	public $title;
	public $creator;
	public $subject;
	public $description;
	public $publisher;
	public $identifier;
	public $contributor;
	public $date;
	public $type;
	public $format;
	public $source;
	public $language;
	public $relation;
	public $coverage;
	public $rights;
	
	const CLASS_NAME    = 'FedoraFoxXmlController';

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
		$this->className = self::CLASS_NAME;

		$this->foxXml = '';
		
		$this->ext         = '';
		$this->subjectName = 'subject';
		$this->state       = 'state';
		$this->iaBase      = 'iabase';
		$this->pidName     = 'pidname';
		$this->pid         = 'pid';
		$this->controlGrp  = 'controlGrp';
		$this->baseUrl     = 'baseurl';

		$this->title       = '';
		$this->creator     = '';
		$this->subject     = '';
		$this->description = '';
		$this->publisher   = '';
		$this->identifier  = '';
		$this->contributor = '';
		$this->date        = '';
		$this->type        = '';
		$this->format      = '';
		$this->source      = '';
		$this->language    = '';
		$this->relation    = '';
		$this->coverage    = '';
		$this->rights      = '';
		
		$this->data = '';
	}

	/**
	 * clearData - set defaults
	 */
	function clearData()
	{
		$this->foxXml = '';
		
		$this->ext         = '';
		$this->subjectName = '';
		$this->state       = '';
		$this->iaBase      = '';
		$this->pidName     = '';
		$this->pid         = '';
		$this->controlGrp  = '';
		$this->baseUrl     = '';

		$this->title       = '';
		$this->creator     = '';
		$this->subject     = '';
		$this->description = '';
		$this->publisher   = '';
		$this->identifier  = '';
		$this->contributor = '';
		$this->date        = '';
		$this->type        = '';
		$this->format      = '';
		$this->source      = '';
		$this->language    = '';
		$this->relation    = '';
		$this->coverage    = '';
		$this->rights      = '';
		
		$this->data = '';
	}

	/**
	 * buildFoxXml - 
	 */
	function buildFoxXml($ext)
	{
		$this->foxXml = $this->foxXmlHeader();

		$this->data .= $this->foxXmlRegular();

		$this->foxXml .= $this->foxXmlHeaderMain();

		$this->foxXml .= $this->foxXmlData($ext);
		
		$this->foxXml .= $this->foxXmlFooter();
		
		return $this->foxXml;
	}

	/**
	 * foxXmlHeader - 
	 */
	function foxXmlHeader()
	{
		$str = '<' . '?' . 'xml version="1.0" encoding="UTF-8"' . '?' . '>';
		
		return $str;
	}

	/**
	 * foxXmlSetDefault - 
	 */
	function foxXmlSetDefault()
	{
		$this->data = ''; // $this->foxXmlSetData();
	}

	/**
	 * foxXmlHeaderMain - 
	 */
	function foxXmlHeaderMain()
	{
		$data = $this->data;
		
		$str = "\n" . 
	 '<foxml:digitalObject PID="'.$this->pidName.':'.$this->pid.'" VERSION="1.1" xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="info:fedora/fedora-system:def/foxml# http://www.fedora.info/definitions/1/0/foxml1-1.xsd">
		<foxml:objectProperties> 
			<foxml:property NAME="info:fedora/fedora-system:def/model#state" VALUE="A"/>
			<foxml:property NAME="info:fedora/fedora-system:def/model#label" VALUE="'.$this->subjectName.'"/>
			<foxml:property NAME="info:fedora/fedora-system:def/model#ownerId" VALUE="fedoraAdmin"/>
		</foxml:objectProperties>
		<foxml:datastream CONTROL_GROUP="'.$this->controlGrp.'" ID="'.$this->subjectName.'_dc.xml" STATE="'.$this->state.'" VERSIONABLE="true">
			<foxml:datastreamVersion ID="DC.0" LABEL="Dublin Core" MIMETYPE="text/xml">
				<foxml:contentDigest DIGEST="none" TYPE="DISABLED"/>
					<foxml:xmlContent>
						<oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/">' . 
							$data . 
						'						' . 
						'</oai_dc:dc>
				</foxml:xmlContent>
			</foxml:datastreamVersion>
		</foxml:datastream>'
			. "\n" 
        ;
		
		return $str;
	}

	/**
	 * foxXml - 
	 */
	function foxXmlData($x)
	{
		$str = '';
		$ext      = '';
		$version  = '';
		$mimeType = '';
		$label    = '';

		switch ($x) 
		{
			case 'djvu':
				$ext      = 'djvu';
				$version  = 'DJVU.0';
				$mimeType = 'image/vnd.djvu';
				$label    = 'DjVu';
				break;
		
			case 'gif':
				$ext      = 'gif';
				$version  = 'GIF.0';
				$mimeType = 'image/gif';
				$label    = 'Animated GIF';
				break;

			case 'pdf':
				$ext      = 'pdf';
				$version  = 'PDF.0';
				$mimeType = 'application/pdf';
				$label    = 'Standard LuraTech PDF';
				break;

			case 'abbyy.gz':
				$ext      = '_abbyy.gz';
				$version  = 'ABBYYGZ.0';
				$mimeType = 'application/octet-stream';
				$label    = 'Abbyy GZ';
				break;

			case '_bw.pdf':
			case 'bw.pdf':
				$ext      = '_bw.pdf';
				$version  = 'BWPDF.0';
				$mimeType = 'application/pdf';
				$label    = 'Grayscale LuraTech PDF';
				break;

			case '_djvu.txt':
			case 'djvu.txt':
				$ext      = '_djvu.txt';
				$version  = 'DJVUTXT.0';
				$mimeType = 'text/plain';
				$label    = 'DjVuTXT';
				break;

			case '_djvu.xml':
			case 'djvu.xml':
				$ext      = '_djvu.xml';
				$version  = 'DJVUXML.0';
				$mimeType = 'application/xml';
				$label    = 'DjVu XML';
				break;

			case '_files.xml':
			case 'files.xml':
				$ext      = '_files.xml';
				$version  = 'XML.0';
				$mimeType = 'application/xml';
				$label    = 'Metadata';
				break;

			case '_flippy.zip':
			case 'flippy.zip':
				$ext      = '_flippy.zip';
				$version  = 'FLIPPYZIP.0';
				$mimeType = 'application/zip';
				$label    = 'Flippy Zip';
				break;

			case '_marc.xml':
			case 'marc.xml':
				$ext      = '_marc.xml';
				$version  = 'MARC.0';
				$mimeType = 'application/xml';
				$label    = 'MARC';
				break;

			case '_meta.mrc':
			case 'meta.mrc':
				$ext      = '_meta.mrc';
				$version  = 'MARCMRC.0';
				$mimeType = 'application/octet-stream';
				$label    = 'MARC Binary';
				break;

			case '_meta.xml':
			case 'meta.xml':
				$ext      = '_meta.xml';
				$version  = 'METAXML.0';
				$mimeType = 'application/xml';
				$label    = 'Metadata';
				break;

			case '_metasource.xml':
			case 'metasource.xml':
				$ext      = '_metasource.xml';
				$version  = 'METASOURCEXML.0';
				$mimeType = 'application/xml';
				$label    = 'MARC Source';
				break;

			case '_jp2.zip':
			case 'jp2.zip':
				$ext      = '_jp2.zip';
				$version  = 'JP2ZIP.0';
				$mimeType = 'application/zip';
				$label    = 'Single Page Processed JP2 ZIP';
				break;

			case '_pure_jp2.zip':
			case 'pure_jp2.zip':
				$ext      = '_pure_jp2.zip';
				$version  = 'PUREJP2ZIP.0';
				$mimeType = 'application/zip';
				$label    = 'Single Page Processed JP2 ZIP';
				break;

			case '_raw_jp2.zip':
			case 'raw_jp2.zip':
				$ext      = '_raw_jp2.zip';
				$version  = 'RAWJP2ZIP.0';
				$mimeType = 'application/zip';
				$label    = 'Single Page Processed JP2 ZIP';
				break;

			case '_orig_jp2.tar':
			case 'orig_jp2.tar':
				$ext      = '_orig_jp2.tar';
				$version  = 'ORIGJP2TAR.0';
				$mimeType = 'application/tar';
				$label    = 'Single Page Original JP2 Tar';
				break;

			case '_scanfactors.xml':
			case 'scanfactors.xml':
				$ext      = '_scanfactors.xml';
				$version  = 'SCANFACTORSXML.0';
				$mimeType = 'text/xml';
				$label    = 'Scan Factors';
				break;

			case '_scandata.xml':
			case 'scandata.xml':
				$ext      = '_scandata.xml';
				$version  = 'SCANDATAXML.0';
				$mimeType = 'text/xml';
				$label    = 'Scandata';
				break;

			case '_scandata.zip':
			case 'scandata.zip':
				$ext      = '_scandata.zip';
				$version  = 'SCANDATAZIP.0';
				$mimeType = 'text/xml';
				$label    = 'Scandata';
				break;

			default:
				break;
		}

		$this->ext = $ext;

//'		<foxml:datastream CONTROL_GROUP="'.$this->controlGrp.'" ID="'.$this->subjectName.''.$ext.'" STATE="'.$this->state.'"> 
//					<foxml:contentLocation REF="'.$this->baseUrl.'/'.$this->subjectName.'/'.$this->subjectName.'.'.$ext.'" TYPE="URL"/> 

		if (substr_count($this->baseUrl, '.pdf', strlen($this->baseUrl) - 5 )) {
			$str = $this->addDataFile($version, $mimeType, $label);
		} else {
			$str = 
				'		<foxml:datastream CONTROL_GROUP="'.$this->controlGrp.'" ID="'.$this->subjectName.''.''.'" STATE="'.$this->state.'"> 
				<foxml:datastreamVersion ID="'.$version.'" MIMETYPE="'.$mimeType.'" LABEL="'.$label.'">
					<foxml:xmlContent>
						<foxml:contentLocation REF="'.$this->baseUrl.'" TYPE="URL"/> 
					</foxml:xmlContent>
				</foxml:datastreamVersion>
			</foxml:datastream>'
			.	"\n"
			;
		}

		return $str;
	}

	/**
	 * addDataFile - 
	 */
	function addDataFile($version, $mimeType, $label)
	{
		$str = 
		'		<foxml:datastream CONTROL_GROUP="'.'M'.'" ID="'.$this->subjectName.''.''.'" STATE="'.$this->state.'"> 
			<foxml:datastreamVersion ID="'.$version.'" MIMETYPE="'.$mimeType.'" LABEL="'.$label.'">
				<foxml:xmlContent>
					<foxml:contentLocation REF="'.$this->baseUrl.'" TYPE="URL"/> 
				</foxml:xmlContent>
			</foxml:datastreamVersion>
		</foxml:datastream>'
		.	"\n";

		return $str;
	}

	/**
	 * foxXmlFooter - 
	 */
	function foxXmlFooter()
	{
		$str = '</foxml:digitalObject>'
		.	"\n";
		
		return $str;
	}

	/**
	 * foxXmlAssignData - 
	 */
	function foxXmlAssignData($title, $creator, $subject, $description, $publisher, $identifier, $contributor, $date, $type, $format, $source, $language, $relation, $coverage, $rights)
	{
		$data['title']        = $title;
		$data['creator']      = $creator;
		$data['subject']      = $subject;
		$data['description']  = $description;
		$data['publisher']    = $publisher;
		$data['identifier']   = $identifier;
		$data['contributor']  = $contributor;
		$data['date']         = $date;
		$data['type']         = $type;
		$data['format']       = $format;
		$data['source']       = $source;
		$data['language']     = $language;
		$data['relation']     = $relation;
		$data['coverage']     = $coverage;
		$data['rights']       = $rights;
	}
	
	/**
	 * foxXmlSetData - 
	 */
	function foxXmlSetData($data)
	{
		$title       = $data['title'];
		$creator     = $data['creator'];
		$subject     = $data['subject'];
		$description = $data['description'];
		$publisher   = $data['publisher'];
		$identifier  = $data['identifier'];
		$contributor = $data['contributor'];
		$date        = $data['date'];
		$type        = $data['type'];
		$format      = $data['format'];
		$source      = $data['source'];
		$language    = $data['language'];
		$relation    = $data['relation'];
		$coverage    = $data['coverage'];
		$rights      = $data['rights'];
		
		$str = 
			'<dc:title>'.$title . '</dc:title>' .
			'<dc:creator>'.$creator . '</dc:creator>' .
			'<dc:subject>'.$subject . '</dc:subject>' . 
			'<dc:description>'.$description . '</dc:description>' . 
			'<dc:publisher>'.$publisher . '</dc:publisher>' . 
			'<dc:identifier>'.$identifier . '</dc:identifier>' . 
			'<dc:contributor>'.$contributor . '</dc:contributor>' . 
			'<dc:date>'.$date . '</dc:date>' . 
			'<dc:type>'.$type . '</dc:type>' . 
			'<dc:format>'.$format . '</dc:format>' . 
			'<dc:source>'.$source . '</dc:source>' . 
			'<dc:language>'.$language . '</dc:language>' . 
			'<dc:relation>'.$relation . '</dc:relation>' . 
			'<dc:coverage>'.$coverage . '</dc:coverage>' . 
			'<dc:rights>'.$rights . '</dc:rights>' .
			'';

		return $str;
	}

	/**
	 * foxXmlRegular - 
	 */
	function foxXmlRegular()
	{
		$str = 
			"\n" .
			'							' .
			'<dc:title>'.$this->title.'</dc:title>' .
			"\n" . 
			'							' .
			'<dc:creator>'.$this->creator.'</dc:creator>' .
			"\n" . 
			'							' .
			'<dc:subject>'.$this->subject.'</dc:subject>' . 
			"\n" . 
			'							' .
			'<dc:description>'.$this->description.'</dc:description>' . 
			"\n" . 
			'							' .
			'<dc:publisher>'.$this->publisher.'</dc:publisher>' . 
			"\n" . 
			'							' .
			'<dc:identifier>'.$this->identifier.'</dc:identifier>' . 
			"\n" . 
			'							' .
			'<dc:contributor>'.$this->contributor.'</dc:contributor>' . 
			"\n" . 
			'							' .
			'<dc:date>'.$this->date.'</dc:date>' . 
			"\n" . 
			'							' .
			'<dc:type>'.$this->type.'</dc:type>' . 
			"\n" . 
			'							' .
			'<dc:format>'.$this->format.'</dc:format>' . 
			"\n" . 
			'							' .
			'<dc:source>'.$this->source.'</dc:source>' . 
			"\n" . 
			'							' .
			'<dc:language>'.$this->language.'</dc:language>' . 
			"\n" . 
			'							' .
			'<dc:relation>'.$this->relation.'</dc:relation>' . 
			"\n" . 
			'							' .
			'<dc:coverage>'.$this->coverage.'</dc:coverage>' . 
			"\n" . 
			'							' .
			'<dc:rights>'.$this->rights.'</dc:rights>' .
			"\n" . 
			'';

		return $str;
	}

	/**
	 * foxXmlRegular - 
	 */
	function xfoxXmlRegular()
	{
		$str = 
			'<dc:title>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:title>' .
			'<dc:creator>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:creator>' .
			'<dc:subject>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:subject>' . 
			'<dc:description>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:description>' . 
			'<dc:publisher>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:publisher>' . 
			'<dc:identifier>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:identifier>' . 
			'<dc:contributor>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:contributor>' . 
			'<dc:date>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:date>' . 
			'<dc:type>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:type>' . 
			'<dc:format>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:format>' . 
			'<dc:source>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:source>' . 
			'<dc:language>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:language>' . 
			'<dc:relation>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:relation>' . 
			'<dc:coverage>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:coverage>' . 
			'<dc:rights>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:rights>' .
			'';

		return $str;
	}

	/**
	 * foxXmlSolr - 
	 */
	function foxXmlSolr()
	{
		$str = 
			'<add>' . 
			'	<doc>' . 
			'  	<field name="id">'.$this->pidName.':'.$this->pid.'</field>' . 
			'	<field name="title"><dc:title>'.$this->title.'</dc:title></field>' .
			'	<filed name="creator"><dc:creator>'.$this->creator.'</dc:creator></field>' .
			'	<field name="subject"><dc:subject>'.$this->subject.'</dc:subject></field>' . 
			'	<field name="description"><dc:description>'.$this->description.'</dc:description></field>' . 
			'	<field name="publisher"><dc:publisher>'.$this->publisher.'</dc:publisher></field>' . 
			'	<field name="identifier"><dc:identifier>'.$this->identifier.'</dc:identifier></field>' . 
			'	<field name="contributor"><dc:contributor>'.$this->contributor.'</dc:contributor></field>' . 
			'	<field name="date"><dc:date>'.$this->date.'</dc:date></field>' . 
			'	<field name="type"><dc:type>'.$this->type.'</dc:type></field>' . 
			'	<field name="format"><dc:format>'.$this->format.'</dc:format></field>' . 
			'	<field name="source"><dc:source>'.$this->source.'</dc:source></field>' . 
			'	<field name="language"><dc:language>'.$this->language.'</dc:language></field>' . 
			'	<field name="relation"><dc:relation>'.$this->relation.'</dc:relation></field>' . 
			'	<field name="coverage"><dc:coverage>'.$this->coverage.'</dc:coverage></field>' . 
			'	<field name="rights"><dc:rights>'.$this->rights.'</dc:rights></field>' .
			'	</doc>' . 
			'</add>';

		
		return $str;
	}

	/**
	 * foxXmlSolr - 
	 */
	function xfoxXmlSolr()
	{
		$str = 
			'<add>' . 
			'	<doc>' . 
			'  	<field name="id">'.$this->pidName.':'.$this->pid.'</field>' . 
			'	<field name="title"><dc:title>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:title></field>' .
			'	<filed name="creator"><dc:creator>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:creator></field>' .
			'	<field name="subject"><dc:subject>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:subject></field>' . 
			'	<field name="description"><dc:description>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:description></field>' . 
			'	<field name="publisher"><dc:publisher>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:publisher></field>' . 
			'	<field name="identifier"><dc:identifier>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:identifier></field>' . 
			'	<field name="contributor"><dc:contributor>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:contributor></field>' . 
			'	<field name="date"><dc:date>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:date></field>' . 
			'	<field name="type"><dc:type>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:type></field>' . 
			'	<field name="format"><dc:format>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:format></field>' . 
			'	<field name="source"><dc:source>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:source></field>' . 
			'	<field name="language"><dc:language>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:language></field>' . 
			'	<field name="relation"><dc:relation>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:relation></field>' . 
			'	<field name="coverage"><dc:coverage>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:coverage></field>' . 
			'	<field name="rights"><dc:rights>'.$this->iaBase.'/'.$this->subjectName.'/'.$this->subjectName.'_dc.xml' . '</dc:rights></field>' .
			'	</doc>' . 
			'</add>';

		
		return $str;
	}

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
