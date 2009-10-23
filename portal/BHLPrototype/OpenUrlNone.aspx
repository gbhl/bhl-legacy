<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="OpenUrlNone.aspx.cs" 
  Inherits="MOBOT.BHL.Web.OpenUrlNone" Title="Biodiversity Heritage Library"%>
<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
  <div id="browseContainerDiv">
    <cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
      <div id="browseInnerDiv" style="height: 100%; overflow: auto;">
        <p class="pageheader">
          OpenUrl Resolution Results</p>
        <p>
        We're sorry, but we were not able to map your request to a particular title. 
        </p>
      </div>
    </cc:ContentPanel>
  </div>
</asp:Content>
