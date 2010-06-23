function ResizeBrowseDivs()
{
    var elementBrowseContainerDiv = document.getElementById("browseContainerDiv");
    var elementBrowseInnerDiv = document.getElementById("browseInnerDiv");
    var elementBrowseOptionsTable = document.getElementById("browseOptionsTable");
    // Note:
	// See Jay for more info about Firefox problems with returning a proper value
	// for window.innerWidth.  Kludge was made with hidden div to get better
	// (but still not ideal) value for the window size.
	var elementKludge = document.getElementById("firefoxKludge");
	
	var windowHeight = 0;
	var windowWidth = 0;
	if (window.innerWidth) 
	{
		windowHeight = elementKludge.scrollHeight;
		windowWidth = elementKludge.scrollWidth;
	}
	else 
	{
		windowHeight = (document.compatMode == 'CSS1Compat' ? document.documentElement.clientHeight : document.body.clientHeight);
		windowWidth = (document.compatMode == 'CSS1Compat' ? document.documentElement.clientWidth: document.body.clientWidth);
	}
	
	var containerDivHeight = windowHeight - 112;
	var addAmount = 0;
	//if(isBrowserIE()) addAmount += 20;
	
	if (containerDivHeight < 0) containerDivHeight = 0;
	
	var subtractAmount;
	
	if(elementBrowseOptionsTable)
	    subtractAmount = 156;
	else
	    subtractAmount = 131;
	    
    subtractAmount += 20;	    
	    
	//if(elementBrowseContainerDiv) elementBrowseContainerDiv.style.height = (containerDivHeight + addAmount) + "px";
	if(elementBrowseInnerDiv)
	{
	    elementBrowseInnerDiv.style.height = (windowHeight - subtractAmount) + "px";
	    //elementBrowseInnerDiv.style.width = (windowWidth - 287) + "px";
	}
}
