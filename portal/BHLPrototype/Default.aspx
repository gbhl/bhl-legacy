<%@ Page Language="C#" MasterPageFile="~/BHL-AU.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MOBOT.BHL.Web._Default" Title="Biodiversity Heritage Library" %>
<%@ Register TagPrefix="cc" Namespace="MOBOT.BHL.Web" Assembly="MOBOT.BHL.Web" %>
<%@ Register TagPrefix="MOBOT" Assembly="MOBOT.BHL.Web.Utilities" Namespace="MOBOT.BHL.Web.Utilities" %>

<asp:Content ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
    <script language="javascript" type="text/javascript">
    
            resizeBrowseDiv = function() {
                var topRowHeight = $("#topRow").height();
                var contentHeight = $("#mainContentDiv").height();	            
	            var browseByHeight = $("#browse_by_outer").height();
	            var searchHeight = $("#search_outer").height();
	            var delta = $("#browse_container_outer").height() - $("#browse_container_inner").height();
	            var targetHeight = contentHeight - (searchHeight + browseByHeight + topRowHeight + delta + 50);
	            
	            if (targetHeight > 0) {	            	            	            
	                $("#browse_container_inner").css("height", targetHeight + "px");
	                $("#browseInnerDiv").css("height", (targetHeight - 30) + "px");
	            }
            }
    	
	        $(document).ready(function() {
                $(".LHSContentPanel").attr("width", "100%");
                resizeBrowseDiv();
                $(window).resize(resizeBrowseDiv);
                $("#"+searchBoxId).keyup(function(event) {
                    if (event.keyCode == '13') {
                        event.preventDefault();
                        Search(searchBoxId);
                    }
                });
                
	        });
	        
	        var searchBoxId = "<%= MainSearchBox.ClientID %>";	        
	        
	        
    </script>

<div>
    <table width="100%" border="0" cellspacing="10" cellpadding="10">
        <tr id="topRow">
            <td>
                <div id="intro_text">
                The Biodiversity Heritage Library (BHL) Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                <a class="HeaderLinks" href="/About.aspx">Learn more about BHL</a>
                </div>
                <br />
            </td>
            <td align="right">
                <cc:ContentPanel ID="get_involved_panel" runat="server" TableID="get_involved_table" Width="300">
                    <center>
                        <div style="font-size:larger"><a href="Members.aspx">Get involved in the BHL Project</a></div>                        
                    </center>
                </cc:ContentPanel>
            </td>
        </tr>
        <tr>
            <td width="100%" valign="top">
                <div id="search_outer">
                    
                    <cc:ContentPanel ID="fffsearchBoxPanel" runat="server" TableID="searchBoxTable" Class="LHSContentPanel">                   
                        <div style="font-family:Arial,Helvetica,Verdana,Times,serif; font-size: 16px">Search our collection</div>
                        <div style="">Find:&nbsp;
                        <asp:TextBox ID="MainSearchBox" CssClass="TextBox" Style="height: 22px; font-size: 16px;" runat="server" Height="15" Width="200" />
				        <input type="button" onclick="Search(searchBoxId);" value="Go" /></div>
			            <div>
			                <a class="small" style="float:right" href="/advancedsearch.aspx">Advanced Search</a>
			            </div>		                    
                    </cc:ContentPanel>                
                    <br />
                </div>
                <div id="browse_by_outer">
                    <cc:ContentPanel ID="browse_by" runat="server" TableID="browse_by_table" Class="LHSContentPanel">
                        <div id="browse_by_inner" style="font-family:Arial,Helvetica,Verdana,Times,serif; font-size: 16px;">Browse by:
                            <table width="300px" border="0" cellpadding="10" cellspacing="10">
                                <tr>
                                    <td style="border: 1px solid black;" align="center"><a href="/browse/titles" class="ButtonLinks">Titles</a></td>
                                    <td style="border: 1px solid black;" align="center"><a href="/browse/authors/A" class="ButtonLinks">Authors</a></td>
                                    <td style="border: 1px solid black;" align="center"><a href="/browse/subject" class="ButtonLinks">Subjects</a></td>
                                </tr>
                                <tr>
                                    <td style="border: 1px solid black;" align="center"><a href="/browse/names" class="ButtonLinks">Names</a></td>
                                    <td style="border: 1px solid black;" align="center"><a href="/browse/map" class="ButtonLinks">Maps</a></td>
                                    <td style="border: 1px solid black;" align="center"><a href="/browse/year" class="ButtonLinks">Year</a></td>
                                </tr>
                            </table>
                        </div>                    
                    </cc:ContentPanel>
                </div>

                <div id="browse_container_outer">        
                    <cc:ContentPanel ID="browseContentPanel" runat="server" Class="LHSContentPanel">
                        <div id="browse_container_inner">
                            <asp:PlaceHolder ID="browseControlPlaceHolder" runat="server" />        
                        </div>
                    </cc:ContentPanel>
                </div>                            
                        
            </td>
            <td align="right" valign="top">
                
                <cc:ContentPanel ID="featured_book_panel" runat="server" TableID="featured_book_table" Width="300">
                    <table width="100%" border="0" cellpadding="5" cellspacing="0">
                        <tr>
                            <td align="center">
                                Featured Book 
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="feature_book_content">
                                ...
                                </div>
                            </td>
                        </tr>
                    </table>
                </cc:ContentPanel>
                <br />		                
                <cc:ContentPanel ID="latest_content_panel" runat="server" TableID="latest_content_table" Width="300">
                    <table width="100%" cellpadding="5" cellspacing="0">
                        <tr>
                            <td align="center">
                                Latest Content&nbsp;<img id="rss_image" src="/images/rss_feed.gif" alt="RSS" style="float: right"/>
                                <hr id="latest_content_hr" />
                            </td>
                        </tr>
                        <tr>
                            <td>
								<MOBOT:RssFeedControl ID="rssFeed" runat="server" MaxRecords="5" Target="_blank" NoItemsFoundText="No BHL news items found." ShowDescription="false" />		                            		                            
                            </td>
                        </tr>
                    </table>
                </cc:ContentPanel>
            </td>
        </tr>
    </table>    
    
</div>
</asp:Content>
