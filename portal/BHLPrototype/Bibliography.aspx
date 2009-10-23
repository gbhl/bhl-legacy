<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="Bibliography.aspx.cs" Inherits="MOBOT.BHL.Web.Bibliography"
	Title="Biodiversity Heritage Library" %>

<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<%@ Register src="COinSControl.ascx" tagname="COinSControl" tagprefix="uc1" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">

    <script>
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
	<div id="browseContainerDiv">
		<cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
			<div id="browseInnerDiv" style="overflow: auto;">
				<table width="99%">
					<tr>
						<td style="width: 60%;" valign="top">
							<b class="accent"><asp:Literal ID="fullTitleLiteral" runat="server"></asp:Literal></b>
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
							</div>
							<p>
								<b>By:</b><br />
								<asp:Repeater ID="authorsRepeater" runat="server">
									<ItemTemplate>
										<b><a href="/creator/<%# Eval("CreatorID") %>">
											<%# Eval("MARCCreator_Full")%>
										</a></b>
										<br />
									</ItemTemplate>
								</asp:Repeater>
								<asp:Repeater ID="additionalAuthorsRepeater" runat="server">
									<ItemTemplate>
										<a href="/creator/<%# Eval("CreatorID") %>">
											<%# Eval("MARCCreator_Full") %>
										</a>
										<br />
									</ItemTemplate>
								</asp:Repeater>
							</p>
							<p>
								<b>Publication info:</b><br />
								<asp:Literal ID="publicationInfoLiteral" runat="server"></asp:Literal>
							</p>
							<asp:Panel ID="callNumberPanel" runat="server">
								<p>
									<b>Call Number:</b><br />
									<asp:Literal ID="callNumberLiteral" runat="server"></asp:Literal>
								</p>
							</asp:Panel>
							<asp:Panel ID="subjectPanel" runat="server">
								<p>
									<b>Subjects:</b><br />
									<asp:Literal ID="subjectLiteral" runat="server"></asp:Literal>
								</p>
							</asp:Panel>
							<%--<p>
								<b>Contributing Library:</b><br />
								<asp:PlaceHolder ID="attributionPlaceHolder" runat="server" />
							</p>--%>
							<p>&nbsp;</p>
							<p>
								<asp:HyperLink CssClass="large" ID="localLibraryLink" runat="server" NavigateUrl="http://worldcatlibraries.org/">Find in a local library<br /></asp:HyperLink>
                        		<uc1:COinSControl ID="COinSControl1" runat="server" />
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
						<td>
							<img src="/images/blank.gif" alt="" width="10" height="1" /></td>
						<td style="width: 40%;" valign="top">
							<img src="/images/rpterror.png" align="texttop" title="Report an error" />&nbsp;<asp:LinkButton ID="lnkFeedback" runat="server" Text="Report an error" PostBackUrl="/Feedback.aspx"></asp:LinkButton>
							<asp:HiddenField ID="hidTitleID" runat="server" /><br /><br />							
						    <img src="/images/bib_plus3.gif"/> = show details&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/icon_book_open.gif" /> = read book<br /><br />
							<b>View:</b>&nbsp;&nbsp;<a id="expand" class="small" href="#">Expand All</a><a id="collapse" class="small" href="#" style="display:none">Collapse All</a><br />
							<asp:Repeater ID="itemRepeater" runat="server">
								<ItemTemplate>
								    <img class="expandImg" alt="" src="/images/bib_plus3.gif" onclick="toggleItem(this, document.getElementById('item<%#Eval("ItemID")%>'));" />
									<a href="/item/<%# Eval("ItemID") %>" class="large"><img src="/images/icon_book_open.gif" /></a>
									<a href="/item/<%# Eval("ItemID") %>"><%# Eval("Volume") %></a>
									<div id="item<%#Eval("ItemID")%>" class="itemDetailDiv">
									<b>Download:</b>
									<div style="margin-left:7px"><%# Eval("DownloadUrl").ToString().Trim() == String.Empty ? "" : (Eval("ItemSourceID").ToString().Trim() == "1" ? "<a href='http://www.archive.org/download/" + Eval("BarCode") + "/" + Eval("BarCode") + ".pdf'>PDF</a>&nbsp;|&nbsp;<a href='http://www.archive.org/download/" + Eval("BarCode") + "/" + Eval("BarCode") + "_djvu.txt'>OCR</a>&nbsp;|&nbsp;<a href='http://www.archive.org/download/" + Eval("BarCode") + "/" + Eval("BarCode") + "_jp2.zip'>Images</a>&nbsp;|&nbsp;<a target='_blank' href='" + Eval("DownloadUrl") + "'>All</a>" : "&nbsp;<a href='#' onclick=\"javascript:window.open('" + Eval("DownloadUrl") + "','pdf','width=400,height=200,status=no,toolbar=no,menubar=no,resizeable=no');\">PDF</a>")%></div>
									<b>Contributing Library:</b>
									<div style="margin-left:7px"><%# Eval("InstitutionUrl").ToString().Trim() == String.Empty ? Eval("InstitutionName") : "<a target='_blank' href='" + Eval("InstitutionUrl") + "'>" + Eval("InstitutionName") + "</a>"%></div>
									<b>Sponsor:</b>
									<div style="margin-left:7px"><%# Eval("Sponsor") %></div>
									<b>Date Scanned:</b>
									<%# Eval("ScanningDate") == null ? "" : "&nbsp;" +
										((MOBOT.BHL.DataObjects.Item)Container.DataItem).ScanningDate.Value.ToString("MM/dd/yyyy")%>
									<br /><br />
									<b>--Copyright and Usage--</b><br />
									<div style="margin-left:7px"><%# (Eval("LicenseUrl") != "" || 
				                                    Eval("Rights") != "" || 
				                                    Eval("DueDiligence") != "" ||
				                                    Eval("CopyrightStatus") != "" ||
				                                    Eval("CopyrightRegion").ToString().Trim() != "" ||
				                                    Eval("CopyrightComment") != "" ||
				                                    Eval("CopyrightEvidence") != "") ? "" : "Not specified"%></div>
                                    <%# (Eval("LicenseUrl") == "") ? "" : "<b>License Type:</b><div style='margin-left:7px'>" + Eval("LicenseUrl") + "</div>"%>
                                    <%# (Eval("Rights") == "") ? "" : "<b>Rights:</b><div style='margin-left:7px'>" + Eval("Rights") + "</div>"%>
									<%# (Eval("DueDiligence") == "") ? "" : "<b>Due Diligence:</b><div style='margin-left:7px'>" + Eval("DueDiligence") + "</div>"%>
									<%# (Eval("CopyrightStatus") == "") ? "" : "<b>Copyright Status:</b><div style='margin-left:7px'>" + Eval("CopyrightStatus") + "</div>"%>
									<%# (Eval("CopyrightRegion").ToString().Trim() == "") ? "" : "<b>Copyright Region:</b><div style='margin-left:7px'>" + Eval("CopyrightRegion") + "</div>"%>
									<%# (Eval("CopyrightComment") == "") ? "" : "<b>Copyright Comments:</b><div style='margin-left:7px'>" + Eval("CopyrightComment") + "</div>"%>
									<%# (Eval("CopyrightEvidence") == "") ? "" : "<b>Copyright Evidence:</b><div style='margin-left:7px'>" + Eval("CopyrightEvidence") + "</div>"%>
									</div>
									<br />
								</ItemTemplate>
							</asp:Repeater>
						</td>
						<td align="right" valign="top">
							<asp:HyperLink ID="editTitleLink" runat="server" ImageUrl="/images/pencil.png" ToolTip="Edit Title">
							</asp:HyperLink>
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
	});
	</script>
</asp:Content>
