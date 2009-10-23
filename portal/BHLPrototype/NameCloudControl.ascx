<%@ Control Language="C#" AutoEventWireup="true" Codebehind="NameCloudControl.ascx.cs"
  Inherits="MOBOT.BHL.Web.NameCloudControl" %>
<table cellpadding="2" cellspacing="2" id="browseOptionsTable">
  <tr>
    <td align="right" valign="top" class="Rust">
      <b>Show:</b></td>
    <td valign="top">
      <a href="/browse/names/500">Top 500</a> 
      | <a href="/browse/names/250">Top 250</a>
      | <a href="/browse/names/100">Top 100</a>
      | <a href="/browse/names/25">Top 25</a>
      | <a href="/Tools.aspx">About</a>
     </td>
  </tr>
</table>
<div id="browseInnerDiv" style="height: 100%; overflow: auto;">
  <asp:Literal ID="nameCountLiteral" runat="server" Visible="false" />
  <asp:PlaceHolder ID="titleTagCloudPlaceHolder" runat="server" />
</div>
