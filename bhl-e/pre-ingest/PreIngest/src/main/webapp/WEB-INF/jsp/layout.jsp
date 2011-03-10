<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8"> 
		<tiles:insertAttribute name="scripts" />
		<title><tiles:insertAttribute name="title" ignore="true" /></title>
		<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/combo?3.3.0/build/cssreset/reset-min.css&3.3.0/build/cssfonts/fonts-min.css&3.3.0/build/cssgrids/grids-min.css&3.3.0/build/cssbase/base-min.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/layout/layout.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/<spring:theme code="css"/>" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/dynatree/skin/ui.dynatree.css" />
		<script type="text/javascript"> 
			//	Hide the menu while its dependencies are being loaded
			document.documentElement.className = "yui3-loading";
		</script>
	</head>
	<body class="yui3-skin-sam">
		<div id="header"><tiles:insertAttribute name="header" /></div>	
		<div class="yui3-g">		
	        <div id="leftcolumn" class="yui3-u-1">
	 	    	<div id="menu" class="yui3-menu yui3-menu-horizontal yui3-menubuttonnav">
	    			<div class="yui3-menu-content">
		 				<tiles:insertAttribute name="menu" />			
		    		</div>
				</div>	
	        </div>
	        <div id="rightcolumn">
	        	<div class="yui3-g">
	        		<p class="first-of-a-type" />	        			 	
	        		<div class="yui3-u-1-3"><tiles:insertAttribute name="leftcolumn" /></div>
	        		<div class="yui3-u-2-3"><tiles:insertAttribute name="rightcolumn" /></div>	        					
	 			</div>
	        </div>
	    </div>
		<div id="footer"><tiles:insertAttribute name="footer" /></div>
	</body>
</html>