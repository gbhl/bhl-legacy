<%@ Page Language="C#" MasterPageFile="~/BHL-AU.master" AutoEventWireup="true" Codebehind="Bibliography.aspx.cs" Inherits="MOBOT.BHL.Web.Bibliography"
	Title="Biodiversity Heritage Library" %>

<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<%@ Register src="COinSControl.ascx" tagname="COinSControl" tagprefix="uc1" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">

    <script language="javascript" type="text/javascript">
    
    resizeBrowseDiv = function() {
        var topRowHeight = $("#topRow").height();
        var contentHeight = $("#mainContentDiv").height();	            
        var delta = $("#browse_container_outer").height() - $("#browse_container_inner").height();
        var targetHeight = contentHeight - (topRowHeight + delta);
        
        $("#browseContentPanel").css("width", "100%");
        
        if (targetHeight > 0) {	            	            	            
            $("#browse_container_inner").css("height", targetHeight + "px");	                
        }
    }

    $(document).ready(function() {
        resizeBrowseDiv();
        $(window).resize(resizeBrowseDiv);                
    });
    
    readBook = function(itemId) {
        window.location = "/item/" + itemId;        
    }
    
    
    function ToggleView(viewType)
    {
        var basicLink = document.getElementById("spanBasic");
        var expandedLink = document.getElementById("spanExpanded");
        var marcLink = document.getElementById("spanMarc");
        var bibtexLink = document.getElementById("spanBibTeX");
        var endnoteLink = document.getElementById("spanEndnote");
        var basicView = document.getElementById("basicview");
        var expandedView = document.getElementById("expandedview");
        var marcView = document.getElementById("marcview");
        var bibtexView = document.getElementById("bibtexview");
        var endnoteView = document.getElementById("endnoteview");
        
        switch(viewType)
        {
            case 0:
            {   basicLink.style.display = basicView.style.display = "";
                if (expandedLink) expandedLink.style.display = expandedView.style.display = "none";
                if (marcLink) marcLink.style.display = marcView.style.display = "none";
                bibtexLink.style.display = bibtexView.style.display = "none";
                endnoteLink.style.display = endnoteView.style.display = "none";
                break;
            }
            case 1:
            {   basicLink.style.display = basicView.style.display = "none";
                expandedLink.style.display = expandedView.style.display = "";
                marcLink.style.display = marcView.style.display = "none";
                bibtexLink.style.display = bibtexView.style.display = "none";
                endnoteLink.style.display = endnoteView.style.display = "none";
                break;
            }
            case 2:
            {   basicLink.style.display = basicView.style.display = "none";
                expandedLink.style.display = expandedView.style.display = "none";
                marcLink.style.display = marcView.style.display = "";
                bibtexLink.style.display = bibtexView.style.display = "none";
                endnoteLink.style.display = endnoteView.style.display = "none";
                break;
            }
            case 3:
            {   basicLink.style.display = basicView.style.display = "none";
                if (expandedLink) expandedLink.style.display = expandedView.style.display = "none";
                if (marcLink) marcLink.style.display = marcView.style.display = "none";
                bibtexLink.style.display = bibtexView.style.display = "";
                endnoteLink.style.display = endnoteView.style.display = "none";
                break;
            }
            case 4:
            {   basicLink.style.display = basicView.style.display = "none";
                if (expandedLink) expandedLink.style.display = expandedView.style.display = "none";
                if (marcLink) marcLink.style.display = marcView.style.display = "none";
                bibtexLink.style.display = bibtexView.style.display = "none";
                endnoteLink.style.display = endnoteView.style.display = "";
                break; }
        }
    }
    </script>
    
	<div id="browse_container_outer" style="overflow: auto; width: 100%">
		<cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
			<div id="browse_container_inner" style="overflow: auto;">
				<table width="100%" style="height:100%" cellpadding="0" cellspacing="0">
					<tr>
						<td style="margin:5px; padding: 10px; border-right: 1px solid #3C3B37; border-bottom: 1px solid #3C3B37" valign="top">
							<b class="accent"><asp:Literal ID="fullTitleLiteral" runat="server"></asp:Literal></b>
							<br />
							<asp:Repeater ID="authorsRepeater" runat="server">
								<ItemTemplate>
									<b><a href="/creator/<%# Eval("CreatorID") %>">
										<%# Eval("MARCCreator_Full")%>
									</a></b>
									<br />
								</ItemTemplate>
							</asp:Repeater>													
						</td>
						<td style="border-bottom: 1px solid #3C3B37" valign="top">
						    <center>
						        <br />
							    <img src="/images/rpterror.png" align="texttop" title="Report an error" alt="Report an error"/>&nbsp;<asp:LinkButton ID="lnkFeedback" runat="server" Text="Report an error" PostBackUrl="/Feedback.aspx"></asp:LinkButton>
							    <br />
							    <asp:HyperLink ID="editTitleLink" runat="server" ToolTip="Fix this entry" Text="Fix this entry"></asp:HyperLink>
							    <asp:HiddenField ID="hidTitleID" runat="server" />
							</center>
						</td>
					</tr>
					<tr>
						<td style="border-right: 1px solid #3C3B37" valign="top">							
							<asp:Repeater ID="itemRepeater" runat="server">
								<ItemTemplate>
								    <table width="100%" cellpadding="10" cellspacing="5">
								        <tr>
								            <td style="width:120px;text-align:center" valign="top">								                								                
							                    <div class="BookThumb">
							                        <div class="BookThumbItemID" style="display: none"><%#Eval("ItemID")%></div>
							                        <div style="height:150px; width: 100px">
							                            <center>
							                                <img style="margin-top:50px" src="/Images/PageLoading.gif" width="31" height="31" alt="loading book thumbnail"/>
                                                        </center>							            
							                        </div>
							                    </div>		
							                    <br />					                    
							                    <input type="button" value="View Book" onclick="readBook('<%# Eval("ItemID") %>')" />
								            </td>
								            <td valign="top">
								                <p>
									                <b>Volume:</b> <%# Eval("Volume") %>
									            </p>									           
									            <b>Contributed by</b>
									            <div style=""><%# Eval("InstitutionUrl").ToString().Trim() == String.Empty ? Eval("InstitutionName") : "<a target='_blank' href='" + Eval("InstitutionUrl") + "'>" + Eval("InstitutionName") + "</a>"%></div>
									            <br />
									            <b>Abstract</b>
									            <div style="">...</div>									            
								            </td>
								        </tr>
								    </table>								    							    
								</ItemTemplate>
								
								<SeparatorTemplate>
                                    <hr style="width:80%"></hr>
                                </SeparatorTemplate>
							</asp:Repeater>
							
						</td>
						<td valign="top" style="padding: 10px">
							<b>Additional authors:</b><br />
							<asp:Repeater ID="additionalAuthorsRepeater" runat="server">
								<ItemTemplate>
									<a href="/creator/<%# Eval("CreatorID") %>">
										<%# Eval("MARCCreator_Full") %>
									</a>
									<br />
								</ItemTemplate>
							</asp:Repeater>
							
							<asp:Panel ID="relatedPanel" runat="server">
							    <p>
							        <b>Related Titles:</b><br />
							        <asp:Repeater ID="associationsRepeater" runat="server">
							            <ItemTemplate>
							                <i><%# Eval("TitleAssociationLabel") %>:</i>
							                <%# Eval("AssociatedTitleID") == null ? "" : "<a href='/bibliography/" + Eval("AssociatedTitleID").ToString() + "'>"%>
							                <%# Eval("Title") %> <%# Eval("Section") %> <%# Eval("Volume") %> <%# Eval("Heading") %> <%# Eval("Publication") %> <%# Eval("Relationship") %>
							                <%# Eval("AssociatedTitleID") == null ? "" : "</a>"%>
							                <br />
							            </ItemTemplate>
							        </asp:Repeater>
							    </p>
							</asp:Panel>
							
							<asp:Panel ID="callNumberPanel" runat="server">
								<p>
									<b>Call Number:</b><br />
									<asp:Literal ID="callNumberLiteral" runat="server"></asp:Literal>
								</p>
							</asp:Panel>
							
							<asp:Panel ID="publicationInfoPanel" runat="server">
							    <p>
								    <b>Publication info:</b><br />
								    <asp:Literal ID="publicationInfoLiteral" runat="server"></asp:Literal>
							    </p>
							</asp:Panel>
						
                            <asp:Panel ID="subjectPanel" runat="server">
								<p>
									<b>Subjects:</b><br />
									<asp:Literal ID="subjectLiteral" runat="server"></asp:Literal>
								</p>
							</asp:Panel>
							<div id="viewcontrol" runat="server" visible="false">
							    <p>
							    <span id="spanBasic">Brief | <a href="#" onclick="ToggleView(1);">Detailed</a> | <a href="#" onclick="ToggleView(2);">MARC</a> | <a href="#" onclick="ToggleView(3);">BibTeX</a> | <a href="#" onclick="ToggleView(4);">EndNote</a></span>
							    <span id="spanExpanded" style="display:none"><a href="#" onclick="ToggleView(0);">Brief</a> | Detailed | <a href="#" onclick="ToggleView(2);">MARC</a> | <a href="#" onclick="ToggleView(3);">BibTeX</a> | <a href="#" onclick="ToggleView(4);">EndNote</a></span>
							    <span id="spanMarc" style="display:none"><a href="#" onclick="ToggleView(0);">Brief</a> | <a href="#" onclick="ToggleView(1);">Detailed</a> | MARC | <a href="#" onclick="ToggleView(3);">BibTeX</a> | <a href="#" onclick="ToggleView(4);">EndNote</a></span>
							    <span id="spanBibTeX" style="display:none"><a href="#" onclick="ToggleView(0);">Brief</a> | <a href="#" onclick="ToggleView(1);">Detailed</a> | <a href="#" onclick="ToggleView(2);">MARC</a> | BibTeX | <a href="#" onclick="ToggleView(4);">EndNote</a></span>
							    <span id="spanEndnote" style="display:none"><a href="#" onclick="ToggleView(0);">Brief</a> | <a href="#" onclick="ToggleView(1);">Detailed</a> | <a href="#" onclick="ToggleView(2);">MARC</a> | <a href="#" onclick="ToggleView(3);">BibTeX</a> | EndNote</span>
							    </p>
							</div>
							<div id="viewcontrolnomarc" runat="server" visible="false">
							    <p>
							    <span id="spanBasic">Brief | <a href="#" onclick="ToggleView(3);">BibTeX</a> | <a href="#" onclick="ToggleView(4);">EndNote</a></span>
							    <span id="spanBibTeX" style="display:none"><a href="#" onclick="ToggleView(0);">Brief</a> | BibTeX | <a href="#" onclick="ToggleView(4);">EndNote</a></span>
							    <span id="spanEndnote" style="display:none"><a href="#" onclick="ToggleView(0);">Brief</a> | <a href="#" onclick="ToggleView(3);">BibTeX</a> | EndNote</span>
							    </p>
							</div>
							<div id="basicview">
							<div id="associationsDiv" runat="server">
							</div>
							<p>&nbsp;</p>
							<p>
							    <center>
								    <asp:HyperLink CssClass="large" ID="localLibraryLink" runat="server" NavigateUrl="http://worldcatlibraries.org/">Find in a local library<br /></asp:HyperLink>
                        		    <uc1:COinSControl ID="COinSControl1" runat="server" />
                        		</center>
							</p>
							</div>
							<div id="expandedview" style="display:none">
							    <asp:Literal ID="litExpanded" runat="server"></asp:Literal>
							</div>
							<div id="marcview" style="display:none">
							    <asp:Literal ID="litMarc" runat="server"></asp:Literal>
							</div>
							<div id="bibtexview" style="display:none">
							    <asp:HyperLink ID="hypBibTex" runat="server" Text="Download BibTeX citations" NavigateUrl="/BibTeXDownload.ashx?id=" /><br /><br />
							    <asp:Literal ID="litBibTeX" runat="server"></asp:Literal>
							</div>
							<div id="endnoteview" style="display:none">
							    <asp:HyperLink ID="hypEndNote" runat="server" Text="Download EndNote citations" NavigateUrl="/EndNoteDownload.ashx?id=" /><br /><br />
							    <asp:Literal ID="litEndNote" runat="server"></asp:Literal>
							</div>
							
						</td>
					</tr>
				</table>
			</div>
		</cc:ContentPanel>
	</div>
	<script>
	function toggleItem(image, itemDiv)
	{
	    if (itemDiv.style.display != 'block') 
	    {
	        itemDiv.style.display = 'block';
	        image.src = '/images/bib_minus3.gif';
	    }
	    else
	    {
	        itemDiv.style.display = 'none';
	        image.src = '/images/bib_plus3.gif';
	    }
	}
	
	$(document).ready(function(){
	    $("#expand").click(function(){$("div.itemDetailDiv:hidden").toggle();$("img.expandImg").attr("src", "/images/bib_minus3.gif");$("#expand").toggle();$("#collapse").toggle();return false;});
	    $("#collapse").click(function(){$("div.itemDetailDiv:visible").toggle();$("img.expandImg").attr("src", "/images/bib_plus3.gif");$("#expand").toggle();$("#collapse").toggle();return false;});
	    

        $(".BookThumbItemID").each(function() {
            var itemId = $(this).html();
            $(this).closest(".BookThumb").each(function() {
                var imagediv = $(this);
        	    $.getJSON("http://" + document.domain + ':' + location.port + "/Services/PageSummaryService.ashx?op=FirstPageSummarySelectForViewerByItemID&itemID=" + itemId, function(data) {
    	            var imageURI = getPageImageURI(data[0]);
    	            imagediv.html('<img src="' + imageURI + '" height="150"></img>');
	            })
	        });	    
                
        });	    	   
	    
	});
	
    getPageImageURI = function(pageRecord) {
        var url = "";

        if (pageRecord != null) {
            if (pageRecord.AltExternalUrl != "" && pageRecord.AltExternalUrl != null) {
                url = 'http://www.archive.org/download/' + pageRecord.BarCode + '/' + pageRecord.BarCode + '_jp2.zip/' + pageRecord.BarCode + '_jp2/' + pageRecord.BarCode + pageRecord.AltExternalUrl;
            } else {
                if (pageRecord.RareBooks) {
                    if (pageRecord.Illustration) {
                        var item = pageRecord.FileRootFolder + '/' + pageRecord.BarCode + '/' + pageRecord.FileNamePrefix + '.jp2';
                        url = 'http://images.biodiversitylibrary.org/adore-djatoka/resolver?url_ver=Z39.88-2004&rft_id=http://mbgserv09:8057/' + pageRecord.WebVirtualDirectory + '/' + item + '&svc_id=info:lanl-repo/svc/getRegion&svc_val_fmt=info:ofi/fmt:kev:mtx:jpeg2000&svc.format=image/jpeg&svc.scale=200';
                    } else {
                        url = 'http://www.botanicus.org/' + pageRecord.WebVirtualDirectory + '/' + pageRecord.FileRootFolder + '/' + pageRecord.BarCode + '/fullsize/' + pageRecord.FileNamePrefix + '.jpg';
                    }
                } else {
                    var item = pageRecord.FileRootFolder + '/' + pageRecord.BarCode + '/jp2' + '/' + pageRecord.FileNamePrefix + '.jp2';
                    url = 'http://images.biodiversitylibrary.org/adore-djatoka/resolver?url_ver=Z39.88-2004&rft_id=http://mbgserv09:8057/' + pageRecord.WebVirtualDirectory + '/' + item + '&svc_id=info:lanl-repo/svc/getRegion&svc_val_fmt=info:ofi/fmt:kev:mtx:jpeg2000&svc.format=image/jpeg&svc.scale=200';
                }
            }
        }

        //alert(url);
        return url;
    }	
	</script>
</asp:Content>
