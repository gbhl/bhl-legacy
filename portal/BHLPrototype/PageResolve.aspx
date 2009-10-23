<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="PageResolve.aspx.cs"
  Inherits="MOBOT.BHL.Web.PageResolve" Title="Biodiversity Heritage Library - Page Search Results" %>

<%@ Register TagPrefix="cc" Namespace="MOBOT.BHL.Web" Assembly="MOBOT.BHL.Web" %>
<asp:Content ID="Content3" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
  <div id="browseContainerDiv">
    <cc:ContentPanel ID="browseContentPanel" runat="server">
      <p class="pageheader">
        Page Search Results</p>
      You were trying to locate:<br />
      <br />
      <b>Title:</b>
      <asp:Literal ID="titleLiteral" runat="server" /><br />
      <b>Volume:</b>
      <asp:Literal ID="volumeLiteral" runat="server" /><br />
      <b>Issue:</b>
      <asp:Literal ID="issueLiteral" runat="server" /><br />
      <b>Year:</b>
      <asp:Literal ID="yearLiteral" runat="server" /><br />
      <b>Start Page:</b>
      <asp:Literal ID="startPageLiteral" runat="server" /><br />
      <br />
      <asp:Literal ID="resultMessageLiteral" runat="server" />
      <asp:Literal ID="similarResultsLiteral" runat="server" />
    </cc:ContentPanel>
  </div>
</asp:Content>
