<%@ Page Language="C#" MasterPageFile="/Admin/Admin.Master" AutoEventWireup="true" Codebehind="PageTypeEdit.aspx.cs" 
Inherits="MOBOT.BHL.Web.Admin.PageTypeEdit"	ValidateRequest="false" %>
<%@ Register Src="/Admin/Controls/ErrorControl.ascx" TagName="ErrorControl" TagPrefix="mobot" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
	<a href="/Admin/Dashboard.aspx">&lt; Return to Dashboard</a><br />
	<br />
	<span class="pageHeader">Page Types</span><hr />
	<br />	
		<div>
		Page Types:
		<asp:DropDownList ID="ddlPageTypes" runat="server" OnSelectedIndexChanged="ddlPageTypes_SelectedIndexChanged" AutoPostBack="True" />
	</div>
	<br />
	<mobot:ErrorControl runat="server" id="errorControl"></mobot:ErrorControl>
	<br />
	<div class="box" style="padding: 5px;margin-right:5px">
		<table cellpadding="4px" width="100%">
			<tr>
				<td style="white-space: nowrap" align="right">
					ID:
				</td>
				<td width="100%">
					<asp:Label ID="idLabel" runat="server"></asp:Label>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Name:
				</td>
				<td>
					<asp:TextBox ID="nameTextBox" runat="server" MaxLength="30"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Description:
				</td>
				<td>
					<asp:TextBox ID="descriptionTextBox" runat="server" Width="400px" MaxLength="255"></asp:TextBox>
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
