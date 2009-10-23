<%@ Page Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MOBOT.BHL.Web._Default" Title="Biodiversity Heritage Library" %>
<%@ Register TagPrefix="cc" Namespace="MOBOT.BHL.Web" Assembly="MOBOT.BHL.Web" %>
<asp:Content ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
   <div id="browseContainerDiv">
        <cc:ContentPanel ID="browseContentPanel" runat="server">
        <!--<div class="BlackHeading">
            Browse By:&nbsp;&nbsp; 
            <a href="/Default.aspx?browseType=cloud">Subject/Tags</a>&nbsp;&nbsp; 
            <a href="/Default.aspx?browseType=title">Title</a>&nbsp;&nbsp;
            <a href="/Default.aspx?browseType=author">Author</a>&nbsp;&nbsp;
            <a href="/Default.aspx?browseType=map">Map</a><br /><br />
        </div>-->
            <asp:PlaceHolder ID="browseControlPlaceHolder" runat="server" />
        </cc:ContentPanel>
    </div>
</asp:Content>
