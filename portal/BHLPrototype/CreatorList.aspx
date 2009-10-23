<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="CreatorList.aspx.cs" Inherits="MOBOT.BHL.Web.CreatorList" Title="Biodiversity Heritage Library" %> 
<%@ Register TagPrefix="UC" TagName="CreatorListControl" Src="CreatorListControl.ascx" %> 
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
<UC:CreatorListControl ID="creatorListControl" runat="server" />
</asp:Content>
