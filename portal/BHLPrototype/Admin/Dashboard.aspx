<%@ Page Language="C#" MasterPageFile="/Admin/Admin.Master" AutoEventWireup="true" Codebehind="Dashboard.aspx.cs" Inherits="MOBOT.BHL.Web.Admin.Dashboard" %>
<%@ Register TagPrefix="cc" Namespace="MOBOT.BHL.Web" Assembly="MOBOT.BHL.Web" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<br />
	<cc:ContentPanel ID="contentPanel" runat="server">
	<span class="pageHeader">Dashboard </span>
	<table cellspacing="25px" cellpadding="0px">
		<tr>
			<td class="box" style="width: 200px; background-color:White">
				<table width="100%" cellspacing="0px"  cellpadding="3px">
					<tr>
						<td class="boxHeader" align="center">
							Admin Functions
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="/Admin/AlertEdit.aspx">Alert Message </a>
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="/Admin/InstitutionEdit.aspx">Institutions</a>
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="/Admin/LanguageEdit.aspx">Languages</a>
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="/Admin/LocationEdit.aspx">Locations</a>
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="/Admin/PageTypeEdit.aspx">Page Types</a>
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="/Admin/VaultEdit.aspx">Vaults</a>
						</td>
					</tr>
				</table>
			</td>
			<td class="box" style="width: 200px;background-color:White" valign="top">
				<table width="100%" cellspacing="0px" cellpadding="3px">
					<tr>
						<td class="boxHeader" align="center">
							Library Functions
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="/Admin/TitleSearch.aspx">Titles</a>
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="/Admin/ItemEdit.aspx">Items</a>
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="/Admin/TitleSearch.aspx?redir=p">Pagination</a>
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="/Admin/CreatorEdit.aspx">Creators </a>
						</td>
					</tr>
				</table>
			</td>
			<td class="box" style="width: 200px;background-color:White" valign="top">
				<table width="100%" cellspacing="0px" cellpadding="3px">
					<tr>
						<td class="boxHeader" align="center">
							Science Functions
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="/Admin/PageNameEdit.aspx">Names (Taxa)</a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="box" style="width: 200px;background-color:White" valign="top">
				<table width="100%" cellspacing="0px">
					<tr>
						<td class="boxHeader" align="center">
							Library Stats
						</td>
					</tr>
					<tr>
						<td>
							<table>
								<tr>
									<td width="34%">
										&nbsp;
									</td>
									<td align="center" style="white-space: nowrap; width: 33%; border-bottom: 1px solid black">
										All Records
									</td>
									<td align="center" style="white-space: nowrap; width: 33%; border-bottom: 1px solid black">
										Active
									</td>
								</tr>
								<tr>
									<td>
										Titles
									</td>
									<td align="right" class="liveData" runat="server" id="titlesAllCell">
									</td>
									<td align="right" class="liveData" runat="server" id="titlesActiveCell">
									</td>
								</tr>
								<tr>
									<td>
										<table width="100%" cellpadding="0" cellspacing="0" style="border: 1px black solid">
											<tr>
												<td style="background-color: green; height: 3px" runat="server" id="titlesGreenBar">
													<img src="/images/blank.gif" /></td>
												<td style="background-color: white; height: 3px" runat="server" id="titlesWhiteBar">
													<img src="/images/blank.gif" /></td>
											</tr>
										</table>
									</td>
									<td>
									</td>
									<td>
									</td>
								</tr>
								<tr>
									<td>
										Items
									</td>
									<td align="right" class="liveData" runat="server" id="itemsAllCell">
									</td>
									<td align="right" class="liveData" runat="server" id="itemsActiveCell">
									</td>
								</tr>
								<tr>
									<td>
										<table width="100%" cellpadding="0" cellspacing="0" style="border: 1px black solid">
											<tr>
												<td style="background-color: green; height: 3px" runat="server" id="itemsGreenBar">
													<img src="/images/blank.gif" /></td>
												<td style="background-color: white; height: 3px" runat="server" id="itemsWhiteBar">
													<img src="/images/blank.gif" /></td>
											</tr>
										</table>
									</td>
									<td>
									</td>
									<td>
									</td>
								</tr>
								<tr>
									<td>
										Pages
									</td>
									<td align="right" class="liveData" runat="server" id="pagesAllCell">
									</td>
									<td align="right" class="liveData" runat="server" id="pagesActiveCell">
									</td>
								</tr>
								<tr>
									<td>
										<table width="100%" cellpadding="0" cellspacing="0" style="border: 1px black solid">
											<tr>
												<td style="background-color: green; height: 3px" runat="server" id="pagesGreenBar">
													<img src="/images/blank.gif" /></td>
												<td style="background-color: white; height: 3px" runat="server" id="pagesWhiteBar">
													<img src="/images/blank.gif" /></td>
											</tr>
										</table>
									</td>
									<td>
									</td>
									<td>
									</td>
								</tr>
								<tr>
								    <td colspan="3" align="center"><a id="namesShowLink" href="#" onclick="showNames();">Show Unique Names</a>
								    </td>
								</tr>
								<tr>
									<td>
										<span id="nameLabel" style="display:none">Unique Names</span>
									</td>
									<td align="right" class="liveData" runat="server" id="uniqueAllCell">
									    <span id="uniqueAllSpan" style="display:none"></span>
									</td>
									<td align="right" class="liveData" runat="server" id="uniqueActiveCell">
									    <span id="uniqueActiveSpan" style="display:none"></span>
									</td>
								</tr>
								<tr>
									<td>
									    <img id="imgLoading" src="/images/loading.gif" style="display:none">
										<table id="tblNameGraph" width="100%" cellpadding="0" cellspacing="0" style="border: 1px black solid;display:none">
											<tr>
												<td style="background-color: green; height: 3px" runat="server" id="uniqueGreenBar">
													<img src="/images/blank.gif" /></td>
												<td style="background-color: white; height: 3px" runat="server" id="uniqueWhiteBar">
													<img src="/images/blank.gif" /></td>
											</tr>
										</table>
									</td>
									<td>
									</td>
									<td>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
					<td align="center"><br /><a href="Stats.aspx">Expanded Library Stats</a></td>
					</tr>
				</table>
			</td>
			<td class="box" style="width: 200px;background-color:White" valign="top">
				<table width="100%" cellspacing="0px">
					<tr>
						<td class="boxHeader" align="center" colspan="2">
							Growth Stats
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<table>
								<tr>
									<td>&nbsp;</td>
									<td align="center" style="white-space: nowrap; width: 33%; border-bottom: 1px solid black">
										New<br />This Year
									</td>
									<td align="center" style="white-space: nowrap; width: 33%; border-bottom: 1px solid black">
										New<br />This Month
									</td>
								</tr>
								<tr>
									<td>Titles</td>
									<td align="right" runat="server" id="titlesThisYear">0</td>
									<td align="right" runat="server" id="titlesThisMonth">0</td>
								</tr>
								<tr>
									<td>Items</td>
									<td align="right" runat="server" id="itemsThisYear">0</td>
									<td align="right" runat="server" id="itemsThisMonth">0</td>
								</tr>
								<tr>
									<td>Pages</td>
									<td align="right" runat="server" id="pagesThisYear">0</td>
									<td align="right" runat="server" id="pagesThisMonth">0</td>
								</tr>
								<tr>
									<td>Names</td>
									<td align="right" runat="server" id="namesThisYear">0</td>
									<td align="right" runat="server" id="namesThisMonth">0</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
					    <td align=center colspan="2">
                            <a href="/Admin/GrowthStats.aspx">Expanded Growth Stats</a>
                        </td>
                    </tr>
				</table>
			</td>
			<td class="box" style="width: 200px;background-color:White" valign="top">
				<table width="100%" cellspacing="0px">
					<tr>
						<td class="boxHeader" align="center" colspan="2">
							PDF Generation Stats
						</td>
					</tr>
					<tr>
						<td colspan="2">
                            <asp:GridView ID="gvPDFGeneration" runat="server" AutoGenerateColumns=False GridLines=none Width=90% HorizontalAlign=center CellSpacing=3 HeaderStyle-Font-Underline=true>
                            <Columns>
                            <asp:BoundField HeaderText="Status" HeaderStyle-HorizontalAlign=left DataField="PdfStatusName" />
                            <asp:BoundField HeaderText="# Of PDFs" HeaderStyle-HorizontalAlign=right DataField="NumberofPdfs" ItemStyle-HorizontalAlign=right />
                            </Columns>
                            </asp:GridView>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
					    <td align=center colspan="2">
                            <a href="/Admin/PdfStats.aspx">Expanded PDF Stats</a>
                        </td>
                    </tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="box" style="width: 200px;background-color:White" valign="top">
				<table width="100%" cellspacing="0px">
					<tr>
						<td class="boxHeader" align="center" colspan="2">
							Data Harvest Stats
						</td>
					</tr>
					<tr>
						<td colspan="2">
                            <asp:GridView ID="gvItemStatus" runat="server" AutoGenerateColumns=False GridLines=none Width=90% HorizontalAlign=center CellSpacing=3 HeaderStyle-Font-Underline=true>
                            <Columns>
                            <asp:BoundField HeaderText="IA Item Status" HeaderStyle-HorizontalAlign=left DataField="Status" />
                            <asp:BoundField HeaderText="# Of Items" HeaderStyle-HorizontalAlign=right DataField="NumberOfItems" ItemStyle-HorizontalAlign=right />
                            </Columns>
                            </asp:GridView>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
					    <td>
					        &nbsp;&nbsp;Items Pending Approval<br />&nbsp;&nbsp;More 
                            Than <asp:Literal ID="litNumDays" runat="server"></asp:Literal> Days
					    </td>
					    <td><asp:HyperLink ID="hypNumItems" NavigateUrl="reportiaitemspendingapproval.aspx?age=" runat="server"></asp:HyperLink></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
					    <td align=center colspan="2">
                            Expanded Data Harvest Stats
                        </td>
                    </tr>
				</table>
		    </td>
		    <td></td>
			<td class="box" style="width: 200px;background-color:White" valign="top">
				<table width="100%" cellspacing="0px" cellpadding="3px">
					<tr>
						<td class="boxHeader" align="center">
							Reports
						</td>
					</tr>
					<tr>
						<td align="center">
							<a href="ReportItemPagination.aspx">Item Pagination</a>
						</td>
					</tr>
					<tr>
					    <td align="center">
					        <a href="TitleImportHistory.aspx">Title Import History</a>
					    </td>
					</tr>
					<tr>
					    <td align="center">
					        <a href="ReportCharacterEncodingProblems.aspx">Character Encoding Problems</a>
					    </td>
					</tr>
				</table>
		    </td>
		</tr>
	</table>
	<script>
	    function showNames() {
	        document.getElementById('imgLoading').style.display = 'block';
	        document.getElementById('namesShowLink').style.display = 'none';
	        
	        // Make AJAX call to get the name statistics
	        executeServiceCall("services/statsservice.ashx?op=SelectExpandedNames", updateUI);
	    }

	    function updateUI(results) {
	        var uniqueAll;
	        var uniqueActive;

	        uniqueAll = results.UniqueTotal;
	        uniqueActive = results.UniqueCount;

	        document.getElementById('uniqueAllSpan').innerHTML = uniqueAll;
	        document.getElementById('uniqueActiveSpan').innerHTML = uniqueActive;

	        document.getElementById('nameLabel').style.display = 'block';
	        document.getElementById('uniqueAllSpan').style.display = 'block';
	        document.getElementById('uniqueActiveSpan').style.display = 'block';
	        document.getElementById('tblNameGraph').style.display = 'block';
	        document.getElementById('imgLoading').style.display = 'none';
	    }

	    function executeServiceCall(url, callback) {
	        var request = createXMLHttpRequest();
	        request.open("GET", url, true);
	        request.onreadystatechange = function() {
	            if (request.readyState == 4) {
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

	</script>
	</cc:ContentPanel>
</asp:Content>

