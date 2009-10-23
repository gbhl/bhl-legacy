<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="Search.aspx.cs" Inherits="MOBOT.BHL.Web.Search"
	Title="Biodiversity Heritage Library" %>

<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
	<div id="browseContainerDiv">
		<cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
			<div id="browseInnerDiv" style="height: 100%; overflow: auto;">
				<div>
					<span class="pageheader">Search Results for "<asp:Label ID="searchResultsLabel" runat="server"/>"</span>&nbsp;
					(<span class="pagesubheader"><a href="advancedsearch.aspx">New Search</a></span>)
				</div>
				<span runat="server" id="spanTitleSummary" visible="false">
				<a href="#Titles">Titles</a> found : <asp:Literal ID="titleOnlineCountLiteral" runat="server"></asp:Literal><br /></span>
				<span runat="server" id="spanAuthorSummary" visible="false">
				<a href="#Authors">Authors</a> found : <asp:Literal ID="txtAuthorsCount" runat="server"></asp:Literal><br /></span>
				<span runat="server" id="spanNameSummary" visible="false">
				<a href="#Names">Names</a> found : <asp:Literal ID="txtNamesCount" runat="server"></asp:Literal><br /></span>
				<span runat="server" id="spanSubjectSummary" visible="false">
				<a href="#Subjects">Subjects</a> found : <asp:Literal ID="txtSubjectCount" runat="server"></asp:Literal><br /></span>
				<br />
				<asp:Panel ID="titlesPanel" Visible="false" runat="server">
					<p class="pagesubheader">
						<a name="Titles"></a>Titles
						</p>
					<asp:Repeater ID="titlesRepeater" runat="server">
						<ItemTemplate>
							<li><a href="/bibliography/<%# Eval("TitleID")%>" class="booktitle">
								<%# Eval("FullTitle").ToString() + " " + Eval("PartNumber").ToString() + " " + Eval("PartName").ToString()%>
							</a>
								<br />
								Publication info:
								<%# Eval("PublicationDetails")%>
								<br />
								Contributed By:
								<%# Eval("InstitutionName") %>
							</li>
						</ItemTemplate>
						<HeaderTemplate>
							<ol>
						</HeaderTemplate>
						<FooterTemplate>
							</ol>
						</FooterTemplate>
					</asp:Repeater>
			        <asp:HyperLink ID="lnkTitleMore" Visible="false" runat="server" Text="more titles...<br><br>" />
			        <asp:Literal ID="litTitleRefine" Visible="false" runat="server" Text="More than 500 titles were found.  Please refine your search if you are unable to find the desired title.<br><br>" />
				</asp:Panel>
				<asp:Panel ID="creatorPanel" Visible="false" runat="server">
					<p class="pagesubheader">
						<a name="Authors"></a>Authors
						</p>
					<asp:Repeater ID="creatorRepeater" runat="server">
						<ItemTemplate>
							<li><a href="/creator/<%# Eval("CreatorID")%>">
								<%# Eval("CreatorName")%><%# Eval("MARCCreator_b") == null ? "" : " " + Eval("MARCCreator_b") %> <%# Eval("DOB") == null ? "" : (Eval("DOB").ToString().Trim() == "" ? "" : Eval("DOB") + "-") %><%# Eval("DOD") %>
							</a></li>
						</ItemTemplate>
						<HeaderTemplate>
							<ol>
						</HeaderTemplate>
						<FooterTemplate>
							</ol></FooterTemplate>
					</asp:Repeater>
			        <asp:HyperLink ID="lnkCreatorMore" Visible="false" runat="server" Text="more authors...<br><br>" />
			        <asp:Literal ID="litCreatorRefine" Visible="false" runat="server" Text="More than 500 authors were found.  Please refine your search if you are unable to find the desired author.<br><br>" />
				</asp:Panel>
				<asp:Panel ID="namesPanel" Visible="false" runat="server">
					<p class="pagesubheader">
						<a name="Names"></a>Names
						</p>
					<p>
						Biodiversity Heritage Library uses <em>taxonomic intelligence</em> tools, including <a href="http://www.ubio.org/index.php?pagename=soap_methods/taxonFinder">
							TaxonFinder</a> developed by <a href="http://www.ubio.org">uBio.org</a>, to locate, verify, and record scientific names located
						within the text of each digitized page. <b>Note:</b> The text used for this identification is uncorrected OCR, so may not include
						all results expected or visible in the page.</p>
					<asp:Repeater ID="nameRepeater" runat="server">
						<ItemTemplate>
							<li><a href="/name/<%# Eval("NameConfirmed").ToString().Replace(' ', '_') %>">
								<%# Eval("NameConfirmed") %>
							</a>(<%# Eval("PageCount") %>) </li>
						</ItemTemplate>
						<HeaderTemplate>
							<ol>
						</HeaderTemplate>
						<FooterTemplate>
							</ol></FooterTemplate>
					</asp:Repeater>
			        <asp:HyperLink ID="lnkNameMore" Visible="false" runat="server" Text="more names...<br><br>" />
			        <asp:Literal ID="litNameRefine" Visible="false" runat="server" Text="More than 500 names were found.  Please refine your search if you are unable to find the desired name.<br><br>" />
				</asp:Panel>
				<asp:Panel ID="subjectPanel" Visible="false" runat="server">
					<p class="pagesubheader">
						<a name="Subjects"></a>Subjects
						</p>
					<asp:Repeater ID="subjectRepeater" runat="server">
						<ItemTemplate>
							<li><a href="/subject/<%# Eval("MarcDataFieldTag")%>">
								<%# Eval( "TagText" )%>
							</a></li>
						</ItemTemplate>
						<HeaderTemplate>
							<ol>
						</HeaderTemplate>
						<FooterTemplate>
							</ol></FooterTemplate>
					</asp:Repeater>
			        <asp:HyperLink ID="lnkSubjectMore" Visible="false" runat="server" Text="more subjects...<br><br>" />
			        <asp:Literal ID="litSubjectRefine" Visible="false" runat="server" Text="More than 500 subjects were found.  Please refine your search if you are unable to find the desired subject.<br><br>" />
				</asp:Panel>
			</div>
		</cc:ContentPanel>
	</div>
</asp:Content>
