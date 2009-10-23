<%@ Control Language="C#" AutoEventWireup="true" Codebehind="BrowseByYearControl.ascx.cs" Inherits="MOBOT.BHL.Web.BrowseByYearControl" %>
<table cellpadding="2" cellspacing="2" id="browseOptionsTable">
	<tr>
		<td align="right" valign="top" class="Rust">
			<b>Start&nbsp;Year:</b></td>
		<td valign="top">
			<a href="/browse/year/1450-1699">1450-1699</a> | <a href="/browse/year/1700-1799">1700-1799</a> | <a href="/browse/year/1800-1849">
				1800-1849</a> | <a href="/browse/year/1850-1899">1850-1899</a> | <a href="/browse/year/1900-1949">1900-1949</a>
				 | <a href="/browse/year/1950-">1950-Current</a>
				</td>
	</tr>
</table>
<div id="browseInnerDiv" style="overflow: auto;">
	<asp:Literal ID="titleLiteral" runat="server" EnableViewState="false" />
</div>
