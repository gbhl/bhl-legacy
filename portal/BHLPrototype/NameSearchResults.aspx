<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="NameSearchResults.aspx.cs"
  Inherits="MOBOT.BHL.Web.NameSearchResults" Title="Untitled Page" %>

<%@ Register TagPrefix="cc" Namespace="MOBOT.BHL.Web" Assembly="MOBOT.BHL.Web" %>
<asp:Content ID="leftContent" ContentPlaceHolderID="leftContentPlaceHolder" runat="server">
  <div id="progressbar" class="progressBar" style="display:none ">Please wait while the data is retrieved.<br /><img src="/Images/loading.gif" alt="" /></div>
  <table>
    <tr>
      <td width="5">
        &nbsp;</td>
      <td>
        <cc:ContentPanel ID="leftContentPanel" runat="server">
          <div id="results" style="width: 390px; height: 400px; overflow: auto;">
            <div class="pageheader" id="resultsHeader"></div>
            <!-- fix lines 37 & 51 when uncommenting this
            <div style="padding-top:3px; visibility:collapse" class="Rust">
            Filter by page type: <select id="pageTypeCombo" runat="server" class="Rust" onchange="PerformSearch()"></select>
            </div>
            -->
            <br />
            <div id="resultTree">
            </div>
          </div>
        </cc:ContentPanel>
      </td>
    </tr>
  </table>

  <script language="javascript" type="text/javascript">
    var searchDone = false;
    
    function PerformSearch()
    {
      document.getElementById("viewer").style.display = "";
      var header = document.getElementById('resultsHeader');
      var tree = document.getElementById('resultTree');
      var helperTextDiv = document.getElementById('helperTextDiv');
      var combo = document.getElementById('<%= PageTypeComboClientId %>');
      helperTextDiv.innerHTML = "Use the links at left to view pages containing '<%= name %>'";

      // Format the date string
      var monthName = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
      var currentTime = new Date();
      var dateString = currentTime.getDate() + " " + monthName[currentTime.getMonth()] + " " + currentTime.getUTCFullYear();
      var hours = currentTime.getHours();
      var suffix = "AM";
      if (hours > 11) suffix = "PM";
      if (hours == 0) 
        hours = 12;
      else if (hours > 12)
        hours = hours - 12;
      var timeString = hours + ":"
      var minutes = currentTime.getMinutes();
      if (minutes < 10) timeString = timeString + "0";
      timeString = timeString + minutes + suffix;
    
      searchDone = false;  
      doPageNameSearchForTitles();
      header.innerHTML = 'Bibliography for "<%= name %>" by Title<br />' + 
				'<span class="pagesubheader">As of ' + dateString + ' ' + timeString + ' </span>';
      //tree.innerHTML = '';
      //tree.innerHTML = 'Please wait while the data is retrieved.&nbsp;&nbsp;<img src="/Images/loading.gif" alt="" /><br><img src="/images/blank.gif" height="28" width="0">';
      if (!searchDone) document.getElementById("progressbar").style.display="";
    }
    
    var previousSelection = null;

    function doPageNameSearchForTitles()
    {
        //MOBOT.BHL.Web.Services.PageSummaryService.PageNameSearchForTitles( '<%= name %>', '<%= lang %>', fillTitlesFound );
        executeServiceCall("/services/pagesummaryservice.ashx?op=PageNameSearchForTitles&name=<%= name %>&languageCode=<%= lang %>", fillTitlesFound);
    }

    function doPageNameSearchByPageTypeAndTitle(titleID)
    {
        //MOBOT.BHL.Web.Services.PageSummaryService.PageNameSearchByPageTypeAndTitle( '<%= name %>', 0, titleID, '<%= lang %>', fillItemsFound );
        executeServiceCall("/services/pagesummaryservice.ashx?op=PageNameSearchByPageTypeAndTitle&name=<%= name %>&pageTypeID=0&titleID=" + titleID + "&languageCode=<%= lang %>", fillItemsFound);
    }

    function doFetchPageUrl(pageID)
    {
        //MOBOT.BHL.Web.Services.PageSummaryService.FetchPageUrl(pageID, updateUI);
        executeServiceCall("/services/pagesummaryservice.ashx?op=FetchPageUrl&pageID=" + pageID, updateUI);
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
         
    function fillTitlesFound( result )
    {
      searchDone = true;
      document.getElementById("progressbar").style.display="none";
      
      var combo = document.getElementById('<%= PageTypeComboClientId %>');
      var pageTypeId = 0;// combo.options[combo.selectedIndex].value;

      var header = document.getElementById('resultsHeader');
      var tree = document.getElementById('resultTree');
      var helperTextDiv = document.getElementById('helperTextDiv');
      header.innerHTML += ' <span class="pagesubheader"><a href="javascript:NewSearch();">(New Search)</a></span><br>' +
        '<span class="pagesubheader"><b>' + result.PageCount + '</b> pages found in <b>' + result.TitleCount + ' </b>titles</span><br />' +
        '<span class="pagesubheader"><%= PageNameMarkupText %></span><br />';
      
      if ( result == null || result.Titles.length < 1 )
      {
        tree.innerHTML = "No matching pages found!";
      }
      else
      {
        tree.innerHTML = "";
        helperTextDiv.style.display = "";
        for ( var i = 0; i < result.Titles.length; i++ )
        {
          titleSpan = document.createElement("span");
          titleSpan.innerHTML += '<a href="javascript:ToggleVisibility(document.getElementById(\'titleSpan' + 
            result.Titles[i].TitleID + '\'), document.getElementById(\'titleImage' + result.Titles[i].TitleID +
             '\'),' + result.Titles[i].TitleID + ');"><img src="/images/plus.gif" id="titleImage' + result.Titles[i].TitleID + '"></a>';
          titleSpan.innerHTML += 
            '<a class="NameSearch" href="javascript:ToggleVisibility(document.getElementById(\'titleSpan' + 
            result.Titles[i].TitleID + '\'), document.getElementById(\'titleImage' + result.Titles[i].TitleID + 
            '\'),' + result.Titles[i].TitleID + ');">' +
            result.Titles[i].ShortTitle + ' <b>(' + result.Titles[i].TotalPageCount + ')</b></a><br>';
          
          tree.appendChild(titleSpan);
          titleContainerSpan = document.createElement("span");
          titleContainerSpan.id = "titleSpan" + result.Titles[i].TitleID;
          titleContainerSpan.style.display = 'none';
          titleSpan.appendChild(titleContainerSpan);
        }
      }
    }
        
    function ToggleVisibility(control, image, titleID)
    {
      if(control == null)
      {
        return;
      }
      if(control.style.display == 'none')
      {
        control.style.display = '';
        image.src = '/images/minus.gif';
      }
      else
      {
        control.style.display = 'none';
        image.src = '/images/plus.gif';
      }
      
      if (control.childNodes.length == 0)
      {
        // Get item and page references for this title
        doPageNameSearchByPageTypeAndTitle(titleID);

        var titleContainerSpan = document.getElementById('titleSpan' + titleID);
        titleContainerSpan.innerHTML = '<img src="/Images/loading.gif" alt="" /><br><img src="/images/blank.gif" height="28" width="0">';
      }
    }

    function fillItemsFound( result )
    {
      var i = 0;

      var titleContainerSpan = document.getElementById('titleSpan' + result.Titles[i].TitleID);
      titleContainerSpan.innerHTML = "";

      for(var j = 0; j < result.Titles[i].Items.length; j++)
      {
        var itemSpanPresent = false;
        if(result.Titles[i].Items[j].Volume != null && result.Titles[i].Items[j].Volume != "")
        {
          itemSpan = document.createElement("span");
          
          itemSpan.innerHTML += 
            '&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:ToggleVisibility(document.getElementById(\'itemSpan' + 
            result.Titles[i].Items[j].ItemID + '\'), document.getElementById(\'itemImage' + 
            result.Titles[i].Items[j].ItemID + '\'));"><img src="/images/plus.gif" id="itemImage' + 
            result.Titles[i].Items[j].ItemID + '"></a>';
          itemSpan.innerHTML += 
            '<a class="NameSearch" href="javascript:ToggleVisibility(document.getElementById(\'itemSpan' + 
            result.Titles[i].Items[j].ItemID + '\'), document.getElementById(\'itemImage' + 
            result.Titles[i].Items[j].ItemID + '\'));">' + result.Titles[i].Items[j].Volume + 
            ' <b>(' + result.Titles[i].Items[j].Pages.length + ')</b></a><br>';
          titleContainerSpan.appendChild(itemSpan);
          itemContainerSpan = document.createElement("span");
          itemContainerSpan.id = "itemSpan" + result.Titles[i].Items[j].ItemID;
          itemContainerSpan.style.display = 'none';
          itemSpan.appendChild(itemContainerSpan);
          itemSpanPresent = true;
        }
            
        for(var k = 0; k < result.Titles[i].Items[j].Pages.length; k++)
        {
          newSpan = document.createElement("span");
          newSpan.innerHTML += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
          newSpan.id = "pageSpan" + result.Titles[i].Items[j].Pages[k].PageID;
          if(result.Titles[i].Items[j].Pages[k].IndicatedPages != null && 
            result.Titles[i].Items[j].Pages[k].IndicatedPages != "")
          {
            newSpan.innerHTML += '<a href="javascript:loadImages(' + 
              result.Titles[i].Items[j].Pages[k].PageID + ');TogglePageLink(document.getElementById(\'pageSpan' + 
              result.Titles[i].Items[j].Pages[k].PageID + '\'));">' + 
              result.Titles[i].Items[j].Pages[k].IndicatedPages + "</a><br>";
          }
          else
          {
            newSpan.innerHTML += '<a href="javascript:loadImages(' + result.Titles[i].Items[j].Pages[k].PageID + ');">' +
             "Seq " + result.Titles[i].Items[j].Pages[k].SequenceOrder + "</a><br>";
          }
          if(itemSpanPresent == true)
          {
            itemContainerSpan.appendChild(newSpan);
          }
          else
          {
            titleContainerSpan.appendChild(newSpan);
          }
        }
      }
    }
    
    var previousPageLink = null;
    function TogglePageLink(control)
    {
      if(control == null)
        return;
      
      if(previousPageLink != null)
        previousPageLink.style.fontWeight = "";
          
      control.style.fontWeight = "bold";
      previousPageLink = control;
    }
    
    function NewSearch()
    {
      /*
      document.getElementById("nameSearchDiv").style.display = "";
      document.getElementById("bibliographyResultsDiv").style.display = "none";
      document.getElementById("viewer").style.display = "none";
      loadViewer("");
      */
      window.location = "/AdvancedSearch.aspx";
    }
        
    function ResizeNameBibliography()
    {
      //var container = document.getElementById("resultTree");
      var container = document.getElementById("results");
        
      // Note:
      // See Jay for more info about Firefox problems with returning a proper value
      // for window.innerWidth.  Kludge was made with hidden div to get better
      // (but still not ideal) value for the window size.
      var elementKludge = document.getElementById("firefoxKludge");
      
      var windowHeight = 0;
      if (window.innerWidth) {
        windowHeight = elementKludge.scrollHeight;
      }
      else {
        windowHeight = 
          (document.compatMode == 'CSS1Compat' ? document.documentElement.clientHeight : document.body.clientHeight);
      }
      
      container.style.height = (windowHeight - 142) + "px";
    }
        
    function loadImages(pageID)
    {
      var viewInContextLink = document.getElementById('viewInContextLink');
      var helperTextDiv = document.getElementById('helperTextDiv');
      viewInContextLink.style.display = "";
      helperTextDiv.style.display = "none";
      viewInContextLink.href = "/page/" + pageID;
      doFetchPageUrl(pageID);
    }
    
    function updateUI(results)
    {
		  var masterFeedbackLink = document.getElementById('<%= ( (HyperLink)Master.FindControl( "masterFeedbackLink" ) ).ClientID  %>');
      masterFeedbackLink.href = "/feedback.aspx?page=" + results[3];

      loadViewer(results[0]);
      resizeViewerHeight(97);
    }
  </script>

</asp:Content>
<asp:Content ID="mainConten" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
  <div id="viewInContextDiv" style="position: absolute; right: 15px; top: 112px; z-index: 91;
    background-color: #F1EFEF;">
    <a style="display: none;" id="viewInContextLink">View Page in Book</a></div>
  <div id="viewer" style="position: absolute; left: 430px; right: 2px; top: 105px; z-index: 90;
    display: none; border-style: solid; border-width: 1px; border-color: #cccccc;">
  </div>
  <div id="helperTextDiv" class="pagesubheader" style="position: absolute; top: 115px;
    z-index: 91; left: 450px; display: none;">
  </div>
</asp:Content>
