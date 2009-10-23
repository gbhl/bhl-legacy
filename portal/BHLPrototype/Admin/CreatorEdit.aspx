<%@ Page Language="C#" MasterPageFile="/Admin/Admin.Master" AutoEventWireup="true" Codebehind="CreatorEdit.aspx.cs" Inherits="MOBOT.BHL.Web.Admin.CreatorEdit"
	ValidateRequest="false" %>

<%@ Register TagPrefix="FCKeditorV2" Namespace="FredCK.FCKeditorV2" Assembly="FredCK.FCKeditorV2" %>
<%@ Register Src="/Admin/Controls/ErrorControl.ascx" TagName="ErrorControl" TagPrefix="mobot" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
	<a href="/Admin/Dashboard.aspx">&lt; Return to Dashboard</a><br />
	<br />
	<span class="pageHeader">Creators</span><hr />
	<br />	
	<div>
		Creators:
		<asp:DropDownList ID="ddlAuthors" runat="server" OnSelectedIndexChanged="ddlAuthors_SelectedIndexChanged" AutoPostBack="True" />
		<asp:Button ID="titlesButton" runat="server" Text="Show Titles" OnClick="titlesButton_Click" />
	</div>
	<br />
	<mobot:ErrorControl runat="server" id="errorControl"></mobot:ErrorControl>
	<br />
	<asp:Panel ID="titlePanel" runat="server" Height="200px" ScrollBars="Auto" Visible="false" CssClass="box" style="margin-right:5px">
		<asp:GridView ID="gvwResults" runat="server" AutoGenerateColumns="False" CellSpacing="0" CellPadding="5" GridLines="None" AlternatingRowStyle-BackColor="#F7FAFB"
			RowStyle-BackColor="white" Width="100%">
			<Columns>
				<asp:BoundField DataField="TitleID" HeaderText="ID" ItemStyle-VerticalAlign="top" />
				<asp:HyperLinkField HeaderText="Title" DataNavigateUrlFields="TitleID" DataNavigateUrlFormatString="/Admin/TitleEdit.aspx?id={0}"
					DataTextField="FullTitle" NavigateUrl="/Admin/TitleEdit.aspx" />
				<asp:BoundField DataField="CreatorRoleType" HeaderText="Creator Type" ItemStyle-Wrap="false" ItemStyle-VerticalAlign="top" />
			</Columns>
			<HeaderStyle HorizontalAlign="Left" CssClass="SearchResultsHeader" />
		</asp:GridView>
	</asp:Panel>
	<div class="box" style="padding: 5px;margin-right:5px">
		<table cellpadding="4">
			<tr>
				<td style="white-space: nowrap" align="right">
					ID:
				</td>
				<td>
					<asp:TextBox ID="idTextBox" runat="server" ReadOnly="true"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Name:
				</td>
				<td>
					<asp:TextBox ID="creatorNameTextBox" runat="server" Width="400px" MaxLength="255"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					First Name First:
				</td>
				<td>
					<asp:TextBox ID="firstNameFirstTextBox" runat="server" Width="400px" MaxLength="255"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Simple Name:
				</td>
				<td>
					<asp:TextBox ID="simpleNameTextBox" runat="server" Width="400px" MaxLength="255"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Date of Birth:
				</td>
				<td>
					<asp:TextBox ID="dobTextBox" runat="server" MaxLength="50"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Date of Death:
				</td>
				<td>
					<asp:TextBox ID="dodTextBox" runat="server" MaxLength="50"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top">
					Biography:
				</td>
				<td style="width: 100%">
					<FCKeditorV2:FCKeditor ID="bioTextBox" runat="server" BasePath="/Admin/controls/FCKeditor/" />
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Creator Note:
				</td>
				<td>
					<asp:TextBox ID="creatorNoteTextBox" runat="server" Width="400px" MaxLength="255"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					MARC Data Field Tag:
				</td>
				<td>
					<asp:TextBox ID="marcDataFieldTagTextBox" runat="server" Width="30px" MaxLength="3"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					MARC Creator a:
				</td>
				<td>
					<asp:TextBox ID="marcCreatorATextBox" runat="server" Width="400px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					MARC Creator b:
				</td>
				<td>
					<asp:TextBox ID="marcCreatorBTextBox" runat="server" Width="400px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					MARC Creator c:
				</td>
				<td>
					<asp:TextBox ID="marcCreatorCTextBox" runat="server" Width="400px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					MARC Creator d:
				</td>
				<td>
					<asp:TextBox ID="marcCreatorDTextBox" runat="server" Width="400px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					MARC Creator Full:
				</td>
				<td>
					<asp:TextBox ID="marcCreatorFullTextBox" runat="server" Width="400px"></asp:TextBox>
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
