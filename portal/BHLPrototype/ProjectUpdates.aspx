<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="ProjectUpdates.aspx.cs"
  Inherits="MOBOT.BHL.Web.ProjectUpdates" Title="Biodiversity Heritage Library News" %>

<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<%@ Register TagPrefix="MOBOT" Assembly="MOBOT.BHL.Web.Utilities" Namespace="MOBOT.BHL.Web.Utilities" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
  <div id="browseContainerDiv">
    <cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
      <div id="browseInnerDiv" style="overflow: auto;">
        <p class="pageheader">
          Biodiversity Heritage Library Updates</p>
        <MOBOT:RssFeedControl ID="rssFeed" runat="server" MaxRecords="25" Target="_blank"
          NoItemsFoundText="No BHL news items found." ShowDescription="true" SeparateItems="true"
          ShowDate="true" />
      </div>
    </cc:ContentPanel>
  </div>
</asp:Content>
