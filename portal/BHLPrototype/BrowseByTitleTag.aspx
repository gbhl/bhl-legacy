<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="BrowseByTitleTag.aspx.cs" Inherits="MOBOT.BHL.Web.BrowseByTitleTag" Title="Biodiversity Heritage Library" %>
<%@ Register TagPrefix="cc" Namespace="MOBOT.BHL.Web" Assembly="MOBOT.BHL.Web" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
<div id="browseContainerDiv">
    <cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
        <div id="browseInnerDiv" style="height:100%; overflow:auto;">
            <asp:Label ID="pageHeaderLabel" runat="server" CssClass="pageheader" />
            
            <ol id="titleList" runat="server"></ol>
        </div>
    </cc:ContentPanel>
</div>
</asp:Content>
