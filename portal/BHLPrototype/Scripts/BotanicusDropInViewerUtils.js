function goto_url(url) {
	if (url !="") {   
		location.href=url
	}
}

function loadViewer(viewerURL) {
	var elementViewer = document.getElementById("viewer");
	if (elementViewer) {
		elementViewer.innerHTML = "<iframe id='GBFrame' src='" + viewerURL + "' frameborder='no' scrolling='no' width='100%' height='100%'></iframe>";
	}
//	var windowWidth = 0;
//	if (window.innerWidth) {
//		windowWidth = window.innerWidth;
//	}
//	else {
//		windowWidth = (document.compatMode == 'CSS1Compat' ? document.documentElement.clientWidth : document.body.clientWidth);
//	}
//	elementViewer.style.width = (windowWidth - parseInt(elementViewer.style.left) - 2) + "px";

	document.body.style.overflowX = "hidden";
	document.body.style.overflowY = "hidden";
    
    resizeViewerHeight(157);
}

var maximized = 0;
//var rightPos = 0;

function resizeViewerHeight(viewerTop){
    //var headerHidden = (document.getElementById('tabsHeader').style.display == 'none');
    //offset the value that was passed in based on whether or not the header is visible
    if(headerHidden)
        viewerTop -= 50;

	var elementViewer = document.getElementById("viewer");
	//var elementPageControls =  document.getElementById("pageListDiv");
	var elementPageControls =  document.getElementById("pageListTable");
	//var elementNamesFound = document.getElementById("nameListDiv");
	var elementNamesFound = document.getElementById("nameListTable");
	var elementTextPage = document.getElementById("textPage");
	var elementLeft = document.getElementById("leftDiv");
	var elementPageList = document.getElementById("pageListContainerDiv");
	var elementNamesFoundInnerDiv = document.getElementById("namesFound");
	
	// Note:
	// See Jay for more info about Firefox problems with returning a proper value
	// for window.innerWidth.  Kludge was made with hidden div to get better
	// (but still not ideal) value for the window size.
	var elementKludge = document.getElementById("firefoxKludge");
	
	var windowHeight = 0;
	var windowWidth = 0;
	if (window.innerWidth) {
		windowHeight = elementKludge.scrollHeight;
		windowWidth = elementKludge.scrollWidth;
	}
	else {
		windowHeight = (document.compatMode == 'CSS1Compat' ? document.documentElement.clientHeight : document.body.clientHeight);
		windowWidth = (document.compatMode == 'CSS1Compat' ? document.documentElement.clientWidth : document.body.clientWidth);
	}
	
	var viewerHeight = 0;
	var margin = 20;
	if (maximized == 0) {
		viewerHeight = windowHeight - viewerTop - margin;
	}
	else {
		viewerHeight = windowHeight - margin;
	}
	if (viewerHeight < 0) viewerHeight = 0;

    var viewerWidth = 0;
    
//    if(maximized == 0)
//        viewerWidth = windowWidth - 375;
//    else
        viewerWidth = windowWidth - 20;
//        
    if(viewerWidth < 0) viewerWidth = 0;
    
    if(headerHidden)
    {
        if(elementTitleListDiv) elementTitleListDiv.style.top = (viewerTop - 3) + "px";
        if(elementItemListDiv) elementItemListDiv.style.top = (viewerTop - 3) + "px";
    }
    else
    {
        if(elementTitleListDiv) elementTitleListDiv.style.top = (viewerTop + 3) + "px";
        if(elementItemListDiv) elementItemListDiv.style.top = (viewerTop + 3) + "px";
    }
    
    if(elementPaginatorPageList)
    {
	    if(headerHidden)
	    {
            elementPaginatorPageList.style.top = (viewerTop + 9) + "px";
            elementViewer.style.top = (viewerTop + 9) + "px";
        }
        else
        {
            elementPaginatorPageList.style.top = (viewerTop + 15) + "px";
            elementViewer.style.top = (viewerTop + 15) + "px";
        }
            
        if(!isBrowserIE())
        {
            elementPaginatorPageListTbody.style.height = (viewerHeight - 212) + "px";
            elementPaginatorPageList.style.height = (viewerHeight - 189) + "px";
        }
        else
        {
            elementPaginatorPageList.style.height = (viewerHeight - 201) + "px";
        }
    }

	if (elementViewer) {
	    /*if(headerHidden)
	        elementViewer.style.top = (viewerTop + 9) + "px";
	    else
	        elementViewer.style.top = (viewerTop + 15) + "px";*/
	        
		elementViewer.style.height = viewerHeight + "px";
		elementViewer.style.width = viewerWidth + "px";
		
		if(elementTextPage) elementTextPage.style.height = (viewerHeight - 16) + "px";
		
		if (elementLeft) {
		    //elementLeft.style.height = (viewerHeight - 16) + "px";
		    var leftHeight = viewerHeight + 37;
		    var subtractAmount = -2;
		    if (isBrowserIE()){
		        if(ie6Below()) subtractAmount = 4;
		        else subtractAmount = 40;
		    }
		    //var panelHeight = (viewerHeight - subtractAmount) / 2;
		    var panelHeight = (leftHeight - subtractAmount) / 2;
		    if (panelHeight < 0) panelHeight = 0;
		    if(elementPageControls) elementPageControls.style.height = panelHeight + "px";
		    //if (elementTabControls) elementTabControls.style.height = panelHeight + "px";
		    
		    subtractAmount = 0;
		    //if (ie6Below()) subtractAmount = 65;
		    var listHeight = panelHeight - subtractAmount;
		    if (listHeight < 0) listHeight = 0;
		    //if(elementTextPage) resizePageList(listHeight);
		    if(elementPageList) elementPageList.style.height = (panelHeight - 50) + "px";
		    
		    subtractAmount = 0;
		    if (ie6Below()) subtractAmount = 0;
		    var namesListHeight = panelHeight - subtractAmount;
		    if (namesListHeight < 0) namesListHeight = 0;
		    if(elementNamesFound) elementNamesFound.style.height = namesListHeight + "px";
		    if(elementNamesFoundInnerDiv) elementNamesFoundInnerDiv.style.height = (namesListHeight - 45) + "px";
		    
		}
		
		
  	    var viewerWidth = windowWidth - parseInt(elementViewer.style.left) - 12;
	    if (viewerWidth < 0) viewerWidth = 0;
		
		elementViewer.style.width = viewerWidth + "px";
		
	}
	
}

function toggleMaximized(viewerLeft, viewerTop, maximizeLeft, maximizeTop){
	var elementViewer = document.getElementById("viewer");
	var elementMaximize = document.getElementById("maximize");
	var elementPageNav = document.getElementById("pageNav");
    var windowWidth = 0;
	if (window.innerWidth) {
		windowWidth = window.innerWidth;
	}
	else {
		windowWidth = (document.compatMode == 'CSS1Compat' ? document.documentElement.clientWidth : document.body.clientWidth);
	}


	if (maximized == 1) {
		maximized = 0;
		elementViewer.style.position = "absolute";
		elementViewer.style.left = viewerLeft + "px";
		//elementViewer.style.top = (viewerTop + 16) + "px";
		elementViewer.style.top = (viewerTop) + "px";
		elementViewer.style.width = (windowWidth - viewerLeft - 10) + "px";
		elementMaximize.style.left = maximizeLeft + "px";
		elementMaximize.style.top = (maximizeTop) + "px";
		elementPageNav.style.top =  (maximizeTop + 16) + "px";
		
		resizeViewerHeight(viewerTop);
		}
	else {
		maximized = 1;
		var margin = 0;
		var newLeft = maximizeLeft - viewerLeft + margin;
		var newTop = maximizeTop - viewerTop + margin;
		elementViewer.style.left = margin + "px";
		elementViewer.style.top = margin + "px";
		elementViewer.style.width = windowWidth - 10 + "px";
		elementMaximize.style.left = newLeft + "px";
		elementMaximize.style.top = newTop + "px";
		elementPageNav.style.top =  newTop + "px";
		resizeViewerHeight(viewerTop);
		}
}

function showHideDiv(szDivID, iState) // 1 visible, 0 hidden
{
    if(document.layers)	   //NN4+
    {
       document.layers[szDivID].visibility = iState ? "show" : "hide";
    }
    else if(document.getElementById)	  //gecko(NN6) + IE 5+
    {
        var obj = document.getElementById(szDivID);
        obj.style.visibility = iState ? "visible" : "hidden";
    }
    else if(document.all)	// IE 4
    {
        document.all[szDivID].style.visibility = iState ? "visible" : "hidden";
    }
}

function ie6Below()
{
    // IE 7, mozilla, safari, opera 9
    if (typeof document.body.style.maxHeight != "undefined")  return false;
    return true;
}

function isBrowserIE()
{
    return (navigator.userAgent.indexOf("MSIE") >= 0);
}

var elementTitleListDiv;
var elementItemListDiv;
function initializeTitleAndItemListDivs(titleListDivID, itemListDivID)
{
   elementTitleListDiv = document.getElementById(titleListDivID);
   elementItemListDiv = document.getElementById(itemListDivID); 
}


var elementPaginatorPageList;;
var elementPaginatorPageListTbody;
function initializePaginatorControls(pageListDivID, pageListTbodyDivID)
{
    elementPaginatorPageList = document.getElementById(pageListDivID);
    elementPaginatorPageListTbody = document.getElementById(pageListTbodyDivID);
}

var headerHidden = false;
function ToggleHeaderVisibility()
{
    var elementHeader = document.getElementById('tabsHeader');
    var elementLink = document.getElementById('toggleHeaderVisibilityLink');
    if(elementHeader && elementLink)
    {
        if(elementHeader.style.display == 'none')
        {
            elementHeader.style.display = '';
            elementLink.innerHTML = 'hide header';
            headerHidden = false;            
        }
        else
        {
            elementHeader.style.display = 'none';
            elementLink.innerHTML = 'show header';
            headerHidden = true;
        }
        resizeViewerHeight(157);
    }
}