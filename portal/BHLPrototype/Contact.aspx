<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="Contact.aspx.cs"
  Inherits="MOBOT.BHL.Web.Contact" Title="Biodiversity Heritage Library" %>

<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<%@ Register TagPrefix="MOBOT" Assembly="MOBOT.BHL.Web.Utilities" Namespace="MOBOT.BHL.Web.Utilities" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
  <div id="browseContainerDiv">
    <cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
      <div id="browseInnerDiv" style="height: 100%; overflow: auto;">
        <MOBOT:RandomImageControl ID="randomImage" runat="server" Directory="images" ImagePrefix="int_rotate"
          MinIndex="1" MaxIndex="7" FileFormat="gif" Align="right" />
        <p class="pageheader">
          Contact the Biodiversity Heritage Library</p>
        For questions or more information about the Biodiversity Heritage Library, please
        email <a href="mailto:bhl@oeb.harvard.edu">bhl@oeb.harvard.edu</a>
        <p>
        Are you an author or publisher and would like more information about including your 
        copyright protected works in the Biodiversity Heritage Library? Please take a moment 
        to complete our questionnaire 
        <a href="/Docs/BHL Permissions Questionnaire.pdf">BHL Permissions Questionnaire.pdf</a> 
        and contact our collections coordinator, Bianca Lipscomb 
        (<a href="mailto:lipscombb@si.edu">lipscombb@si.edu</a>). You may also wish to review 
        our standard permission form <a href="/Docs/BHL Permissions Form.pdf">BHL Permissions Form.pdf</a>.
        </p>
        <p>
        Scanning is done at no cost to you and makes your work available for use by researchers 
        and scientists around the world. We welcome your participation in the BHL! 
        </p>
      </div>
    </cc:ContentPanel>
  </div>
</asp:Content>
