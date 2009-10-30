<%@ Page Title="Biodiversity Heritage Library" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="OpenUrlMultiple.aspx.cs" Inherits="MOBOT.BHL.Web.OpenUrlMultiple" %>
<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
  <div id="browseContainerDiv">
    <cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
      <div id="browseInnerDiv">
          <p class="pageheader">OpenUrl Results</p>
          <p>Select one of the items below to find the desired citation.</p>
          <p>
            <table runat="server" id="tblPages" cellpadding="2" cellspacing="2">
                <tr align="left"><th>Title</th><th>Volume</th><th>Issue</th><th>Year</th><th>Page</th></tr>
            </table>
          </p>
      </div>
    </cc:ContentPanel>
  </div>
</asp:Content>
