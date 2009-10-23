<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="TitlePage.aspx.cs" Inherits="MOBOT.BHL.Web.TitlePage"
	Title="Biodiversity Heritage Library" %>

<%@ Register TagPrefix="UC" TagName="TitleVolumeSelectionControl" Src="TitleVolumeSelectionControl.ascx" %>
<%@ Register TagPrefix="cc" Namespace="MOBOT.BHL.Web" Assembly="MOBOT.BHL.Web" %>
<%@ Register src="COinSControl.ascx" tagname="COinSControl" tagprefix="uc1" %>
<asp:Content ID="leftContent" ContentPlaceHolderID="leftContentPlaceHolder" runat="server">
	<asp:HiddenField ID="hidItemID" runat="server" />
	<asp:HiddenField ID="hidPageID" runat="server" />
	<asp:HiddenField ID="hidSequenceMax" runat="server" />

	<script type="text/javascript">
    var acceptingCommands = true;
    var ocrTextErrors = false;
    var currentSelectedPageControl = null;
    var currentSequence = 1;
    var updateViewer = true;
     
    function IsInViewerMode()
    {
      var viewer = document.getElementById('viewer');
      if (viewer.style.visibility == "hidden")
        return false;
      else
        return true;
    }

    function doFetchPageUrl(pageID)
    {
        //MOBOT.BHL.Web.Services.PageSummaryService.FetchPageUrl(pageList.options[sequenceNum - 1].value, updateUI);
        executeServiceCall("/services/pagesummaryservice.ashx?op=FetchPageUrl&pageID=" + pageID, updateUI);
    }
    
    function doGetPageNameList(pageID)
    {
        //MOBOT.BHL.Web.Services.PageSummaryService.GetPageNameList( pageList[sequenceNum - 1].value, namesFound );
        executeServiceCall("/services/pagesummaryservice.ashx?op=GetPageNameList&pageID=" + pageID, namesFound);
    }
    
    function executeServiceCall(url, callback)
    {
        var request = createXMLHttpRequest();
        request.open("GET", url, true);
        request.onreadystatechange = function() {
            if (request.readyState == 4)
            {
                if (request.status == 200) {
                    var result = eval('(' + request.responseText + ')');
                    callback(result);
                }
            }
        }
        request.send(null);
    }

    function createXMLHttpRequest() {
        if (typeof XMLHttpRequest != "undefined") {
            return new XMLHttpRequest();
        } else if (typeof ActiveXObject != "undefined") {
            return new ActiveXObject("Microsoft.XMLHTTP");
        } else {
            throw new Error("XMLHttpRequest not supported");
        }
    }
    
    function loadImages(sequenceNum)
    {
      var pageList = document.getElementById('<%= pageListBox.ClientID %>');
      doFetchPageUrl(pageList.options[sequenceNum - 1].value);
    }

    function updateUI(results)
    {
      if (updateViewer)
          loadViewer(results[0]);
      else
          updateViewer = true;

      var hidPageID = document.getElementById('<%= hidPageID.ClientID %>');
      hidPageID.value = results[3];

      var pgLink = document.getElementById('<%= pageLink.ClientID %>');
      var url = 'http://' + document.domain + '/page/' + results[3];
      pgLink.innerHTML = url.replace(/www./, "").replace(/beta./, "");

      var masterFeedbackLink = document.getElementById('<%= ( (HyperLink)Master.FindControl( "masterFeedbackLink" ) ).ClientID  %>');
      masterFeedbackLink.href = "/feedback.aspx?page=" + results[3];
      var textUrl = document.getElementById('hypOcrText');
      var namesFound = document.getElementById('namesFound');
      document.getElementById('ocrText').innerHTML = results[4];
      ocrTextErrors = (results[1] == "error");

      if(results[1] != "")
      {
        toggleViewerTypeLink();
        
        textUrl.style.display = 'inline';
      }
      else
      {
        textUrl.style.display = 'none';
      }
      var textUrl = document.getElementById('hypOcrText');
      acceptingCommands = true;
    }    
    
    function setDisplayParams(newSequence)
    {
      currentSequence = parseInt(newSequence);
      if(acceptingCommands == true)
      {
        var sequenceMax = eval(document.getElementById('<%= hidSequenceMax.ClientID %>').value);
        if(newSequence > 0 && newSequence <= sequenceMax)
        {
          acceptingCommands = false;
          loadImages(newSequence);
          var textUrl = document.getElementById('hypOcrText');
          if(textUrl.style.visibility != 'hidden')
          {
            getNames(newSequence);
          }
        }
      }
    }
    
    function changePage(newSequence)
    {
      var pageListElement = document.getElementById('<%= pageListBox.ClientID %>');
      var sequenceMax = eval(document.getElementById('<%= hidSequenceMax.ClientID %>').value);
      if (newSequence > 0 && newSequence <= sequenceMax)
      {
        setDisplayParams(newSequence);
        pageListElement.selectedIndex = newSequence - 1;
      }
    }
    
    function firstPage()
    {
      changePage(1);
    }
    
    function previousPage()
    {
      changePage(currentSequence - 1);
    }
    
    function nextPage()
    {
      changePage(currentSequence + 1);
    }
    
    function lastPage()
    {
      var sequenceMax = eval(document.getElementById('<%= hidSequenceMax.ClientID %>').value);
      changePage(sequenceMax);
    }

    function showUBioText(results)
    {
      var ocrText = document.getElementById('ocrText');
      ocrText.innerHTML = results[0];
      if(results[1] != null)
      {
        var bSaf = (navigator.userAgent.indexOf('Safari') != -1);
        var bOpera = (navigator.userAgent.indexOf('Opera') != -1);
        var bMoz = (navigator.appName == 'Netscape');
        var newScript = document.createElement("script");
        newScript.type = "text/javascript";
        if ((bSaf) || (bOpera) || (bMoz))
          newScript.innerHTML = results[1];
        else 
          newScript.text = results[1];
        document.getElementsByTagName("head")[0].appendChild(newScript);
      }
    }
    
    function getNames(sequenceNum)
    {
      var pageList = document.getElementById('<%= pageListBox.ClientID %>');
      clearNames();
      document.getElementById("namesList").innerHTML = '<img src="/Images/finding.gif" alt="" />';
      doGetPageNameList(pageList[sequenceNum - 1].value);
    }
    
    function namesFound( result )
    {
      var names = document.getElementById('namesList');
      names.innerHTML = "";
      if ( result.length < 1 )
      {
        newSpan = document.createElement( "span" );
        newSpan.innerHTML = "No Names Found";
        names.appendChild( newSpan );
      }
      
      for ( var i = 0; i < result.length; i++ )
      {
        newSpan = document.createElement( "span" );
        newSpan.innerHTML = "<a href='/name/" + result[i].UrlName + "'>" + result[i].NameConfirmed + "</a><br />";
        names.appendChild( newSpan );
      }
    }
        
    function clearNames() 
    {
      var namesList = document.getElementById("namesList");
      while (namesList.childNodes.length > 0)
      {
        namesList.removeChild(namesList.firstChild);
      }
    }
    
    function clearTropicosNames() 
    {
      var namesList = document.getElementById("tropicosReferenceNamesList");
      while (namesList.childNodes.length > 0)
      {
        namesList.removeChild(namesList.firstChild);
      }
    }
    
    function toggleViewerVisible()
    {
      var viewer = document.getElementById('viewer');
      var maxim = document.getElementById('maximize');
      var textPage = document.getElementById('textPage');
      var ocrText = document.getElementById('hypOcrText');
      var pageNav = document.getElementById('pageNav');
      if (viewer.style.visibility == "hidden")
      {
        viewer.style.visibility = "visible";
        if (maxim != null) maxim.style.visibility = "visible";
        if (pageNav != null) pageNav.style.visibility = "visible";
        textPage.style.visibility = "hidden";
        viewer.style.display = "block";
        if (maxim != null) maxim.style.display = "block";
        if (pageNav != null) pageNav.style.display = "block";
        textPage.style.display = "none";          
      }
      else
      {
        viewer.style.visibility = "hidden";
        if (maxim != null) maxim.style.visibility = "hidden";
        if (pageNav != null) pageNav.style.visibility = "hidden";
        textPage.style.visibility = "visible";
        viewer.style.display = "none";
        if (maxim != null) maxim.style.display = "none";
        if (pageNav != null) pageNav.style.display = "none";
        textPage.style.display = "block";
      }
      toggleViewerTypeLink();
    }
    
    function toggleViewerTypeLink()
    {
      var viewer = document.getElementById('viewer');
      var ocrText = document.getElementById('hypOcrText');
      if (IsInViewerMode())
      {
        if(ocrTextErrors)
          ocrText.innerHTML = "View Error";
        else
          ocrText.innerHTML = "View Text";          
      }
      else
      {
        ocrText.innerHTML = "View Image";
      }
    }

    function toggleLinksVisible() {
        var linkDiv = document.getElementById('divPgLnk');
        if (linkDiv.style.display == 'none') {
            linkDiv.style.display = 'block';
        }
        else {
            linkDiv.style.display = 'none';
        }
    }

    // Poll the window location hash to see if the user has changed the page in view
    var doPolling;
    var hash = window.location.hash;
    startPolling();
    function stopPolling() { clearTimeout(doPolling); }
    function startPolling() { doPolling = setTimeout("checkHash()", 400); }
    function checkHash() {
        stopPolling();
        var newHash = window.location.hash;
        if (hash != newHash && hash != "") {
            updateViewer = false;
            if (!isNaN(newHash.replace("#", ""))) changePage(newHash.replace("#", ""));
            //window.location.hash = "";
        }
        hash = newHash;
        startPolling();
    }

	</script>

	<div id="leftDiv">
		<div align="center">
			<cc:ContentPanel ID="pageListContentPanel" runat="server">
				<div id="pageListDiv">
					<div class="BlackHeading" align="left">
						Pages</div>
					<div id="pageListContainerDiv">
						<asp:ListBox ID="pageListBox" runat="server" onchange="setDisplayParams(this.selectedIndex + 1)" Height="100%" CssClass="ListBox" />
					</div>
					<table width="99%" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td align="left">
								<span style="font-size: 11px;text-decoration:underline;color:#27638C;" onclick="toggleLinksVisible();">Link to this page</span></td>
								<td align="right">
									<a href="javascript:toggleViewerVisible()" id="hypOcrText">View Text</a></td>
						</tr>
					</table>
					<div id="divPgLnk" style="display:none;font-size: 11px"><br /><span id="pageLink" runat="server" ></span></div>
				</div>
			</cc:ContentPanel>
		</div>
		<img src="/images/blank.gif" width="1" height="10" alt="" />
		<div align="center">
			<cc:ContentPanel ID="namesListContentPanel" runat="server">
				<div id="nameListDiv">
					<table>
						<tr>
							<td class="BlackHeading" style="white-space:nowrap">
								Names on this page
							</td>
							<td align="right" style="width:100%">
								<a href="/Tools.aspx">
									<img align="right" src="/images/help.gif" alt="" />
								</a>
							</td>
						</tr>
					</table>
				</div>
				<div id="namesFound" style="overflow: auto;">
					<div id="namesList" align="left">
					</div>
					<div style="font-weight: bold; font-size: 12px; text-align: left; font-style: italic; color: #707070">
						-powered by <a href="http://www.uBio.org" target="_blank">uBio</a></div>
				</div>
				
			</cc:ContentPanel>
		</div>
	</div>
</asp:Content>
<asp:Content ID="toolbarContent" ContentPlaceHolderID="toolbarContentPlaceHolder" runat="server">
	<UC:TitleVolumeSelectionControl ID="titleVolumeSelectionControl" Visible="true" runat="server" />
    <uc1:COinSControl ID="COinSControl1" runat="server" />
</asp:Content>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
	<div>
		<div id="textPage" style="display: none; overflow-y: scroll">
			<b>*This text is generated from uncorrected OCR.</b><br />
			<div id="ocrText" style="font-size: 12pt;">
			</div>
		</div>
		<div id="viewer" style="position: absolute; left: 256px; right: 12px; top: 157px; z-index: 90; border-style: solid; border-width: 1px;
			border-color: #cccccc;">
		</div>
		<!--
		<div id="maximize" style="position: absolute; left: 256px; top: 159px; z-index: 100;">
			<img src="http://images.mobot.org/viewer/images/view-fullscreen.png" title="Maximize" alt="Maximize" width="16" height="16" onclick="javascript:toggleMaximized(256,157,256,159);" />
		</div>
		<div id="pageNav" style="position: absolute; right: 33px; top: 164px; z-index: 100;">
			<img src="/Images/first.gif" title="First" alt="First Page" width="13" height="15" onclick="javascript:firstPage();" />&nbsp;&nbsp;
			<img src="/Images/previous.gif" title="Previous" alt="Previous Page" width="10" height="15" onclick="javascript:previousPage();" />&nbsp;&nbsp;
			<img src="/Images/next.gif" title="Next" alt="Next Page" width="10" height="15" onclick="javascript:nextPage();" />&nbsp;&nbsp;
			<img src="/Images/last.gif" title="Last" alt="Last Page" width="13" height="15" onclick="javascript:lastPage();" />
		</div>
		-->
	</div>
	<div id="attributionDiv" runat="server" style="right: 15px;">
		Book contributed by
		<asp:PlaceHolder ID="attributionPlaceHolder" runat="server" />
	</div>
</asp:Content>
