<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="Permissions.aspx.cs"
  Inherits="MOBOT.BHL.Web.About" Title="Biodiversity Heritage Library" %>

<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<%@ Register TagPrefix="MOBOT" Assembly="MOBOT.BHL.Web.Utilities" Namespace="MOBOT.BHL.Web.Utilities" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
  <div id="browseContainerDiv">
    <cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
      <div id="browseInnerDiv" style="height: 100%; overflow: auto;">
        <table border="0" cellspacing="5" cellpadding="5">
          <tr valign="top">
            <td>
              <div>
                <p class="pageheader">
                  Negotiated Rights and Permissions
                </p>
                <p>
                  The Biodiversity Heritage Library strives to establish a major corpus of digitized
                  publications on the Web drawn from historical biodiversity literature. This material
                  will be available for open access and responsible use as a part of a global Biodiversity
                  Commons. We will work with the global taxonomic community, rights holders, and other
                  interested parties to ensure that this legacy literature is available to all.</p>
              </div>
            </td>
          </tr>
        </table>
      </div>
    </cc:ContentPanel>
  </div>
</asp:Content>
