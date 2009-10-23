<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="AdvancedSearch.aspx.cs" 
    Inherits="MOBOT.BHL.Web.AdvancedSearch" Title="Biodiversity Heritage Library" %>

<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
    <cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
		<div class="BlackHeading">
			Advanced Search
		</div>
		<br />
		<table cellpadding="3">
			<tr>
				<td align="right">
					Find:
				</td>
				<td>
					<asp:TextBox ID="txtFind" runat="server" Width="200px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td align="right" valign="top">
					Categories:
				</td>
				<td style="height: 23px">
				    <asp:CheckBox runat="server" ID="chkAuthor" Checked="true" Text="Authors" /><br />
				    <asp:CheckBox runat="server" ID="chkName" Checked="true" Text="Names" /><br />
				    <asp:CheckBox runat="server" ID="chkSubject" Checked="true" Text="Subjects" /><br />
				    <asp:CheckBox runat="server" ID="chkTitle" Checked="true" Text="Titles" /><br />
				</td>
			</tr>
			<tr>
				<td align="right">
					Search titles written in:
				</td>
				<td>
				    <asp:DropDownList runat="server" ID="ddlLanguage" DataTextField="LanguageName" DataValueField="LanguageCode"></asp:DropDownList>
				</td>
			</tr>
			<tr>
			    <td align="right">
			        Include secondary titles:
			    </td>
			    <td>
			        <asp:CheckBox runat="server" ID="chkSecondary" Checked="true" Text="" />&nbsp;<a href="#" class="small" onclick="document.getElementById('divSecondary').style.display='block';">What's this?</a>
			    </td>
			</tr>
			<tr>
			    <td colspan="2">
			        <div id="divSecondary" style="border:solid;border-width:2px; border-style:inset;padding:5px;font-size:11px; display:none">
			            Volumes online at the Biodiversity Heritage Library may be<br />
			            associated with more than one title. However, only one title is<br />
			            designated as the primary title for each item.<br /><br />
			            For example, Volume 1 of the title <i>"Fieldiana. Zoology Memoirs"</i><br />
			            may also be associated with the title <i>"Siphonaptera from Central<br />
			            America and Mexico"</i>.  <i>"Fieldiana. Zoology Memoirs"</i> is designated<br />
			            as the primary title for the volume.<br /><br />
			            By default, only primary titles are displayed when browsing or<br />
			            searching the site.  By checking the box on this page next to the<br />
			            search option "Include secondary titles", you can search for both<br />
			            primary and secondary titles.<br />
			            <a href="#" class="small" onclick="document.getElementById('divSecondary').style.display='none';">Close</a>
			        </div>
			    </td>
			</tr>
			<tr>
				<td>
				</td>
				<td>
					<br /><asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
				</td>
			</tr>
		</table>
		<br />
    </cc:ContentPanel>
</asp:Content>
