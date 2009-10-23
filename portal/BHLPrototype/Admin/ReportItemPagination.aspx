<%@ Page Language="C#" MasterPageFile="/Admin/Admin.Master" AutoEventWireup="true" Codebehind="ReportItemPagination.aspx.cs" Inherits="MOBOT.BHL.Web.Admin.ReportItemPagination"
	ValidateRequest="false" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
	<a href="/Admin/Dashboard.aspx">&lt; Return to Dashboard</a><br />
	<br />
	<span class="pageHeader">Pagination Report</span><hr />
	<br />
	<asp:GridView ID="itemList" runat="server" AutoGenerateColumns="False" CellPadding="5" GridLines="None" AllowSorting="true" AlternatingRowStyle-BackColor="#F7FAFB"
		Width="700px" CssClass="boxTable" OnSorting="itemList_Sorting" OnRowDataBound="itemList_RowDataBound" >
		<Columns>
			<asp:BoundField DataField="ItemID" HeaderText="Item ID" SortExpression="ItemID" ItemStyle-Width="100px" />
			<asp:BoundField DataField="BarCode" HeaderText="Barcode" SortExpression="BarCode" />
			<asp:BoundField DataField="PaginationStatusName" HeaderText="Pagination Status" SortExpression="PaginationStatusName" />
			<asp:BoundField DataField="PaginationStatusDate" HeaderText="Pagination Date" SortExpression="PaginationStatusDate" />
		</Columns>
		<HeaderStyle HorizontalAlign="Left" CssClass="SearchResultsHeader" />
	</asp:GridView>
</asp:Content>
