<%@ Page Language="C#" AutoEventWireup="true" Codebehind="Recent.aspx.cs" Inherits="MOBOT.BHL.Web.Recent" MasterPageFile="~/Main.master"
	Title="BiodiversityLibrary.org: Recent Additions and Updates" %>

<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="Server">
	<div id="browseContainerDiv">
		<cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
			<table cellpadding="2" cellspacing="2" id="browseOptionsTable">
				<tr>
					<td align="right" valign="top" class="Rust">
						<b>Show:</b></td>
					<td valign="top">
						<a href="/recent/25">Last 25</a> | <a href="/recent/50">Last 50</a> | <a href="/recent/100">Last 100</a></td>
                </tr>
            </table>
			<p class="pageheader">Recent Additions
				<asp:Label ID="lblNumberDisplayed" runat="server" Text=""></asp:Label>
				<asp:Label CssClass="pagesubheader" ID="lblLanguage" runat="server" Text=""></asp:Label>
				<asp:Label CssClass="pagesubheader" ID="lblContributor" runat="server" Text=""></asp:Label></p>
			<p>
				RSS Feed location: <a id="rssFeedLink" runat="server" />&nbsp;&nbsp;&nbsp;<a id="rssFeedImageLink" runat="server"><img src="/Images/rss_feed.gif"
					alt="RSS" style="vertical-align: middle;" /></a></p>
			<asp:Repeater ID="rptRecent" runat="server">
				<ItemTemplate>
					<li><a href="/item/<%# Eval("ItemID") %>" class="booktitle">
						<%# Eval("ShortTitle") %>
						<%# Eval("Volume") %>
					</a>(added:
						<%# Eval("ScanningDate","{0:MM/dd/yyyy}") %>
						)</li>
				</ItemTemplate>
				<HeaderTemplate>
					<ol>
				</HeaderTemplate>
				<FooterTemplate>
					</ol></FooterTemplate>
			</asp:Repeater>
		</cc:ContentPanel>
	</div>
</asp:Content>
