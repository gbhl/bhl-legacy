function ResizeContentPanel(tableID, subtractWidth)
{
  var elementTable = document.getElementById(tableID);
  // Note:
	// See Jay for more info about Firefox problems with returning a proper value
	// for window.innerWidth.  Kludge was made with hidden div to get better
	// (but still not ideal) value for the window size.
	var elementKludge = document.getElementById("firefoxKludge");
	
	var windowWidth = 0;
	if (window.innerWidth) 
	{
		windowWidth = elementKludge.scrollWidth;
	}
	else 
	{
		windowWidth = (document.compatMode == 'CSS1Compat' ? document.documentElement.clientWidth: document.body.clientWidth);
	}
	
	var tableWidth = windowWidth - subtractWidth;
	
	if(tableWidth < 0) tableWidth = 0;
	
	if(elementTable)
	{
	  elementTable.style.width = (tableWidth) + "px";
	}
}

function SetContentPanelWidth(tableID, width)
{
  var elementTable = document.getElementById(tableID);	
	var tableWidth = width;
	
	if(tableWidth < 0) tableWidth = 0;
	
	if(elementTable)
	{
	  elementTable.style.width = (tableWidth) + "px";
	}
}

function ResizeContentPanelHeight(tableID, subtractHeight)
{
  var elementTable = document.getElementById(tableID);
  // Note:
	// See Jay for more info about Firefox problems with returning a proper value
	// for window.innerWidth.  Kludge was made with hidden div to get better
	// (but still not ideal) value for the window size.
	var elementKludge = document.getElementById("firefoxKludge");
	
	var windowHeight = 0;
	if (window.innerHeight) 
	{
		windowHeight = elementKludge.scrollHeight;
	}
	else 
	{
		windowHeight = (document.compatMode == 'CSS1Compat' ? document.documentElement.clientHeight: document.body.clientHeight);
	}
	
	var tableHeight = windowHeight - subtractHeight;
	
	if(tableHeight < 0) tableHeight = 0;
	
	if(elementTable)
	{
	  elementTable.style.height = (tableHeight) + "px";
	}
}