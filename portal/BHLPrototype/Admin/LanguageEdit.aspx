<%@ Page Language="C#" MasterPageFile="/Admin/Admin.Master" AutoEventWireup="true" Codebehind="LanguageEdit.aspx.cs" Inherits="MOBOT.BHL.Web.Admin.LanguageEdit"
	ValidateRequest="false" %>

<%@ Register Src="/Admin/Controls/ErrorControl.ascx" TagName="ErrorControl" TagPrefix="mobot" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
	<a href="/Admin/Dashboard.aspx">&lt; Return to Dashboard</a><br />
	<br />
	<span class="pageHeader">Languages</span><hr />
	<br />
	<div>
		Languages:
		<asp:DropDownList ID="ddlLanguages" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlLanguages_SelectedIndexChanged" />
	</div>
	<br />
	<mobot:ErrorControl runat="server" id="errorControl">
	</mobot:ErrorControl>
	<br />
	<div class="box" style="padding: 5px; margin-right: 5px">
		<table cellpadding="4" width="100%">
			<tr>
				<td style="white-space: nowrap" align="right">
					Code:
				</td>
				<td width="100%">
					<asp:TextBox ID="codeTextBox" runat="server" Width="60px" MaxLength="10"></asp:TextBox>
					<asp:HiddenField ID="hidCode" runat="server" />
					(Codes cannot be changed once they are saved)
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Name:
				</td>
				<td>
					<asp:TextBox ID="nameTextBox" runat="server" Width="400px" MaxLength="255"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Note:
				</td>
				<td>
					<asp:TextBox ID="noteTextBox" runat="server" MaxLength="255" Width="400px"></asp:TextBox>
				</td>
			</tr>
		</table>
		<br />
		<br />
		<asp:Button ID="saveButton" runat="server" OnClick="saveButton_Click" Text="Save" />
		<asp:Button ID="clearButton" runat="server" Text="Clear" OnClick="clearButton_Click" />
		<asp:Button ID="saveAsNewButton" runat="server" Text="Save As New" OnClick="saveAsNewButton_Click" />
	</div>
</asp:Content>
