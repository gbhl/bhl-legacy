<%@ Page Language="C#" MasterPageFile="/Admin/Admin.Master" AutoEventWireup="true" Codebehind="PageNameEdit.aspx.cs" Inherits="MOBOT.BHL.Web.Admin.PageNameEdit"
	Title="BHL Admin - Names (Taxa)" %>
<%@ Register Src="/Admin/Controls/ErrorControl.ascx" TagName="ErrorControl" TagPrefix="mobot" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
	<a href="/Admin/Dashboard.aspx">&lt; Return to Dashboard</a><br />
	<br />
	<span class="pageHeader">Names (Taxa)</span><hr />
	<br />
	<table>
		<tr>
			<td>
				Page ID:
				<asp:TextBox ID="pageIdTextBox" runat="server"></asp:TextBox>
			</td>
			<td style="padding-left: 10px">
				<asp:Button ID="searchButton" runat="server" Text="Search" OnClick="searchButton_Click" />
			</td>
		</tr>
	</table>
	<br />
	<mobot:ErrorControl runat="server" id="errorControl"></mobot:ErrorControl>
	<br />
	<table width="100%" class="box">
		<tr>
			<td style="width: 500px;" valign="top">
				<table cellpadding="4">
					<tr>
						<td style="white-space: nowrap" align="right" class="dataHeader">
							Page ID:
						</td>
						<td width="100%">
							<asp:Label ID="pageIdLabel" runat="server" ForeColor="Blue"></asp:Label>
						</td>
					</tr>
					<tr>
						<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
							Title (Title ID):
						</td>
						<td>
							<asp:HyperLink ID="titleLink" runat="server"></asp:HyperLink>
						</td>
					</tr>
					<tr>
						<td style="white-space: nowrap" align="right" class="dataHeader">
							Volume:
						</td>
						<td>
							<asp:HyperLink ID="itemLink" runat="server"></asp:HyperLink>
						</td>
					</tr>
					<tr>
						<td style="white-space: nowrap" align="right" class="dataHeader">
							Description:
						</td>
						<td>
							<asp:Label ID="descriptionLabel" runat="server" ForeColor="Blue"></asp:Label>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<asp:GridView ID="pageNameList" runat="server" AutoGenerateColumns="False" CssClass="boxTable" AllowSorting="true" HeaderStyle-Wrap="false"
								CellPadding="5" GridLines="None" RowStyle-BackColor="white" AlternatingRowStyle-BackColor="#F7FAFB" Width="500px" OnRowCancelingEdit="pageNameList_RowCancelingEdit"
								OnRowEditing="pageNameList_RowEditing" OnRowUpdating="pageNameList_RowUpdating" OnRowCommand="pageNameList_RowCommand" OnSorting="pageNameList_Sorting"
								OnRowDataBound="pageNameList_RowDataBound" DataKeyNames="PageNameID,NameFound,NameConfirmed,NameBankID,Active">
								<Columns>
									<asp:ButtonField ButtonType="Link" Text="Remove" CommandName="RemoveButton" ItemStyle-Width="50px" />
									<asp:TemplateField HeaderText="Name Found" SortExpression="NameFound">
										<ItemTemplate>
											<%# Eval("NameFound") %>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:TextBox ID="nameFoundTextBox" runat="server" Text='<%# Eval("NameFound") %>' ReadOnly="<%# SetNameFoundRO( Container.DataItem ) %>"></asp:TextBox>
										</EditItemTemplate>
									</asp:TemplateField>
									<asp:BoundField DataField="NameConfirmed" HeaderText="Name Confirmed" SortExpression="NameConfirmed" ReadOnly="true" />
									<asp:BoundField DataField="NameBankID" HeaderText="Name Bank ID" SortExpression="NameBankID" ReadOnly="true" />
									<asp:TemplateField HeaderText="Active" ItemStyle-Width="50px" SortExpression="Active">
										<ItemTemplate>
											<asp:CheckBox ID="activeCheckBox" runat="server" Checked='<%# Eval( "Active" ) %>' Enabled="false" />
										</ItemTemplate>
										<EditItemTemplate>
											<asp:CheckBox ID="activeCheckBox" runat="server" Checked='<%# Eval( "Active" ) %>' Enabled="true" />
										</EditItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField ItemStyle-Width="130px">
										<ItemTemplate>
											<asp:LinkButton ID="editPageNameButton" runat="server" CommandName="Edit" Text="Edit"></asp:LinkButton>
										</ItemTemplate>
										<EditItemTemplate>
											<asp:LinkButton ID="updatePageNameButton" runat="server" CommandName="Update" Text="Update"></asp:LinkButton>
											<asp:LinkButton ID="cancelPageNameButton" runat="server" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
										</EditItemTemplate>
									</asp:TemplateField>
								</Columns>
								<HeaderStyle HorizontalAlign="Left" CssClass="SearchResultsHeader" />
							</asp:GridView>
							<br />
							<asp:Button ID="addPageNameButton" runat="server" Text="Add Name" OnClick="addPageNameButton_Click" Enabled="false" />
						</td>
					</tr>
				</table>
			</td>
			<td id="pageViewer" valign="top" style="border-style: solid; border-width: 1px; border-color: #cccccc;" runat="server">
				<iframe id="pageFrame" frameborder="0" scrolling="no" width="100%" height="600px" runat="server"></iframe>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Button ID="saveButton" runat="server" OnClick="saveButton_Click" Text="Save" Enabled="false" />
			</td>
		</tr>
	</table>
</asp:Content>
