<%@ Control Language="C#" AutoEventWireup="true" Codebehind="TitleTagCloudControl.ascx.cs"
  Inherits="MOBOT.BHL.Web.TitleTagCloudControl" %>
<table cellpadding="2" cellspacing="2" id="browseOptionsTable">
  <tr>
    <td align="right" valign="top" class="Rust">
      <b>Show:</b></td>
    <td valign="top">
      <a href="/browse/subject/10000000">ALL</a> | <a href="/browse/subject/500">Top 500</a>
      | <a href="/browse/subject/250">Top 250</a> | <a href="/browse/subject/100">Top 100</a>
      | <a href="/browse/subject/25">Top 25</a></td>
  </tr>
</table>
<div id="browseInnerDiv" style="height: 100%; overflow: auto;">
  <asp:Literal ID="subjectCountLiteral" runat="server" Visible="false" />
  <asp:PlaceHolder ID="titleTagCloudPlaceHolder" runat="server" />
</div>
