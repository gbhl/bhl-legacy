<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="Tools.aspx.cs" Inherits="MOBOT.BHL.Web.Tools"
	Title="Biodiversity Heritage Library" %>

<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<%@ Register TagPrefix="MOBOT" Assembly="MOBOT.BHL.Web.Utilities" Namespace="MOBOT.BHL.Web.Utilities" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
	<div id="browseContainerDiv">
		<cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
			<div id="browseInnerDiv" style="height: 100%; overflow: auto;">
				<table border="0" cellspacing="5" cellpadding="5">
					<tr valign="top">
						<td>
							<MOBOT:RandomImageControl ID="randomImage" runat="server" Directory="images" ImagePrefix="int_rotate" MinIndex="1" MaxIndex="7"
								FileFormat="gif" Align="right" />
							<div>
								<p class="pageheader">
									Developer Tools</p>
								<p>
									<a href="#names">Names</a> 
									| <a href="#urls">URLs</a> 
									| <a href="#citations">Citations</a>
								</p>
								<p>
									BHL is building APIs to allow individual users and data providers to remix and reuse BHL content. The following APIs are currently
									available or under development. To suggest an API or enhancement, please use our <a href="http://www.biodiversitylibrary.org/Feedback.aspx">
										Feedback</a>. <a name="names"></a>
									<p class="pageheader">
										Scientific Names</p>
									<p>
										BHL uses <a href="http://www.ubio.org/index.php?pagename=xml_services">TaxonFinder</a>, a taxonomic intelligence tool developed
										by collaborators at <a href="http://www.ubio.org">uBio.org</a>, to locate and identify scientific names within the text of digitized
										books. This names-based index is an incredibly valuable tool for organismal research, and is easily incorporated into external
										web sites through two different methods of access.</p>
									<p>
										<strong>1. Bibliography by URL</strong>
										<br />
										To easily link into a list of all pages containing a given scientific name, use the following URL:</p>
									<p>
										http://www.biodiversitylibrary.org/name/<i>Scientific_name</i></p>
									Where <i>Scientific_name</i> is any uninomial, binomial, or trinomial. Replace spaces with the underscore ( _ )character.
									<p>
										Examples:</p>
									<ul>
										<li><a href="http://www.biodiversitylibrary.org/name/Orchidaceae">http://www.biodiversitylibrary.org/name/Orchidaceae</a> (Orchid
											family)
											<li><a href="http://www.biodiversitylibrary.org/name/Carcharodon_carcharias">http://www.biodiversitylibrary.org/name/Carcharodon_carcharias</a>
												(Great white shark)
												<li><a href="http://www.biodiversitylibrary.org/name/Phalacrocorax_carbo_maroccanus">http://www.biodiversitylibrary.org/name/Phalacrocorax_carbo_maroccanus</a>
										(Great Cormorant)
									</ul>
									<p>
										<strong>2. BHL Name Services</strong>
										<br />
										The BHL Name Services are XML-based web services that can be invoked via SOAP or HTTP GET/POST requests. Responses can be received
										in one of three formats: XML wrapped in a SOAP envelope, XML, or JSON.</p>
									<p>
										If you want to use SOAP to invoke the service methods, you can navigate to <a href="http://www.biodiversitylibrary.org/services/name/NameService.asmx">
											http://www.biodiversitylibrary.org/services/name/NameService.asmx</a> to view the available methods. From that page, you can
										view the WSDL document for the web service, or click on each method to see detailed information about invoking the method and
										about the data that is returned.</p>
									<p>
										If you are using HTTP to invoke the methods, the services are located at <a href="http://www.biodiversitylibrary.org/services/name/NameService.ashx">
											http://www.biodiversitylibrary.org/services/name/NameService.ashx</a>. Note the difference in the extension on the service
										URL: ASHX for HTTP vs. ASMX for SOAP.</p>
									<p>
										Full documentation on the BHL Name Services is available at:
										<br />
										<a href="http://docs.google.com/Doc?id=dgvjvvkz_1x5qbm3">http://docs.google.com/Doc?id=dgvjvvkz_1x5qbm3</a></p>
									<a name="urls"></a>
									<p class="pageheader">
										Stable URLs</p>
									<p>
										BHL produces stable URLs for our content and will ensure viability of these URLs. Stable URLs are available for the following
										areas of content, with examples:</p>
									<p>
										Subject: Insects
										<br />
										<a href="http://www.biodiversitylibrary.org/subject/Insects">http://www.biodiversitylibrary.org/subject/Insects</a></p>
									<p>
										Author: Darwin, Charles, (1809 - 1882)
										<br />
										<a href="http://www.biodiversitylibrary.org/creator/93">http://www.biodiversitylibrary.org/creator/93</a></p>
									<p>
										Title: <i>The Journal of the Linnean Society</i>
										<br />
										<a href="http://www.biodiversitylibrary.org/title/350">http://www.biodiversitylibrary.org/title/350</a></p>
									<p>
										Item/Book: <i>The Journal of the Linnean Society</i>, v. 8 1865
										<br />
										<a href="http://www.biodiversitylibrary.org/item/8361">http://www.biodiversitylibrary.org/item/8361</a></p>
									<p>
										Page/Article: Bentham, G. (1865). On the Genera <i>Sweetia</i>, Sprengle, and <i>Glycine</i>, Linn., simultaneously published
										under the name of <i>Leptolobium</i>.<i>The Journal of the Linnean Society, 8</i>: 259-267.
										<br />
										<a href="http://www.biodiversitylibrary.org/page/226820">http://www.biodiversitylibrary.org/page/226820</a></p>
									<a name="citations"></a>
									<p class="pageheader">
										Citation Linking</p>
									<p>
										Data providers can include links to literature using our stable URLs for scanned pages. The URL is displayed below "Link to this
										page". For example, to cite the original description of <i>Zea mays</i>:</p>
									<p>
										Citation: Carl Linnaeus' <i>Species Plantarum</i>. 2 : 971. 1753.
										<br />
										<a href="http://www.biodiversitylibrary.org/page/358992">http://www.biodiversitylibrary.org/page/358992</a></p>
									<p>
										<strong>Coming Soon</strong> - Data providers will be able to query BHL to determine if a given journal article or book has been
										digitized. Plans are underway to use OpenURL to facilitate linking.</p>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</cc:ContentPanel>
	</div>
</asp:Content>
