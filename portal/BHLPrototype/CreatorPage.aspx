<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="CreatorPage.aspx.cs"
  Inherits="MOBOT.BHL.Web.CreatorPage" Title="Biodiversity Heritage Library" %>

<%@ Register TagPrefix="cc" Namespace="MOBOT.BHL.Web" Assembly="MOBOT.BHL.Web" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
  <div id="browseContainerDiv">
    <cc:ContentPanel ID="authorContentPanel" runat="server">
      <div id="browseInnerDiv" style="height: 100%; overflow: auto;">
        <table width="80%" cellpadding="5" cellspacing="5" border="0">
          <tr>
            <td colspan="2">
              <p class="pageheader">
                <asp:Literal ID="creatorNameLiteral" runat="server"></asp:Literal><br />
                <asp:Literal ID="lifespanLiteral" runat="server"></asp:Literal></p>
            </td>
          </tr>
          <asp:Repeater ID="titlesRepeater" runat="server">
            <ItemTemplate>
              <tr>
                <td valign="top">
                  <a href="/bibliography/<%# Eval("TitleID") %>" class="booktitle">
                    <%# Eval("FullTitle").ToString() + " " + Eval("PartNumber").ToString() + " " + Eval("PartName").ToString()%>
                  </a>
                  <br />
                  Publication Info:
                  <%# Eval("PublicationDetails")%>
                  <br />
                  Contributed By:
                  <%# Eval("InstitutionName")%>
                </td>
              </tr>
            </ItemTemplate>
          </asp:Repeater>
          <tr>
            <td>
              <asp:Literal ID="biographyLiteral" runat="server"></asp:Literal></td>
          </tr>
        </table>
      </div>
    </cc:ContentPanel>
  </div>
</asp:Content>
