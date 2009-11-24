<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" >

<head>
	<title>BHL Image Viewer</title>
	<link rel="stylesheet" type="text/css" media="all" href="css/viewerv2.css" />
	<script type="text/javascript" src="javascript/mootools.v1.1.js"></script>
	<script type="text/javascript" src="javascript/iipmooviewer-1.0v2.js"></script>
	<script type="text/javascript"><!--
		// The iipsrv server full URL. This has to go on page, obviously, due to the JSP snippet.  I guess we could do that in javascript, but...meh
		<%
		out.println("var server = \"http://" + request.getServerName() +  "/adore-djatoka/resolver\";");
		%>
	//--></script>
	<script type="text/javascript" src="javascript/IIPViewerMods.js"></script>

</head>

<body>

	<div id="toolbar">
		<div style="width:26px;">&nbsp;</div>
		<a id="printImageButton" href="viewerPrint.jsp?imageURL=" rel="external">
			<img src="images/print.png" alt="Print" title="Print" />
		</a>
		<a id="saveImageButton" href="http://images.mobot.org/viewer/saveimage.asp" rel="external">
			<img src="images/save.png" alt="Save" title="Save" />
		</a>
		<a href="help.html" rel="external">
			<img src="images/help.png" alt="Help" title="Help" />
		</a>
		
		<img id="zoomButton" src="images/zoom.png" alt="turn Zoom on and off" class="magButtonOut" onclick="toggleMode();" />

		<div id="highResBlock">
			<img src="images/minus.png" alt="Zoom Out"  title="Zoom Out" onclick="iip.zoomOut();this.blur();" />
			<img src="images/plus.png" alt="Zoom In"  title="Zoom In" onclick="iip.zoomIn();this.blur();" />
		</div>
	</div>

	<div id="loadingContainer" style="margin-top:200px;margin-left:48%;">
		<img id="loading3" src="images/spinner2-black.gif" alt="loading the jp2"  />
		<img id="loading2" src="images/spinner3-black.gif" alt="loading the tiles"  />
	</div>

	<div id="targetframe"></div>
	<div class="openurl" id="div_oul" style="display:none;"></div>
	
	


	<script type="text/javascript"><!--
		//show controls based on image type, which should translate to hi/lo res (jpeg=lo, jp2=hi)
		document.getElementById('highResBlock').style.display='none';
		if(theActualURL.indexOf('.jp2') != -1 && imageURL != ''){//if the image we are viewing is a jp2 and there is a low res available
			document.getElementById('highResBlock').style.display='block';
			document.getElementById('zoomButton').className='magButtonIn';
		}else if(theActualURL.indexOf('.jp2') != -1 && imageURL == ''){//if the image we are viewing is a jp2 and there is no low res available
			document.getElementById('highResBlock').style.display='block';
			document.getElementById('zoomButton').style.display='none';
		}else if(imageDetailURL!='' && theActualURL.indexOf('.jpg')){//if this is a jpeg and there IS a hi res url...
			document.getElementById('zoomButton').className='magButtonOut';
		}

		//add target attribute to anchors
		var theAnchors = document.getElementsByTagName("a"),theAnchor;
		for(var i=0;i<theAnchors.length;i++){
			theAnchor=theAnchors[i];
			if(theAnchor.rel){
				if(theAnchor.rel=='external')
					theAnchor.target='_blank';
				if(theAnchor.rel=='parent')
					theAnchor.target='_parent';
			}
		}
	//--></script>
<script type="text/javascript">
	var gaJsHost = (("https:" == document.location.protocol) ?
	"https://ssl." : "http://www.");
	document.write(unescape("%3Cscript src='" + gaJsHost +
	"google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
	try {
	var pageTracker = _gat._getTracker("UA-3353213-7");
	pageTracker._trackPageview();
	} catch(err) {}</script>

</body>
</html>
