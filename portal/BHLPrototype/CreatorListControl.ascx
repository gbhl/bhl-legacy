<%@ Control Language="C#" AutoEventWireup="true" Codebehind="CreatorListControl.ascx.cs"
  Inherits="MOBOT.BHL.Web.CreatorListControl" %>
<table cellpadding="2" cellspacing="2" id="browseOptionsTable">
  <tr>
    <td align="right" valign="top" class="Rust">
      <b>Author:</b></td>
    <td valign="top">
      <a href="/browse/authors/A">A</a> | <a href="/browse/authors/B">B</a> | <a href="/browse/authors/C">
        C</a> | <a href="/browse/authors/D">D</a> | <a href="/browse/authors/E">E</a>
      | <a href="/browse/authors/F">F</a> | <a href="/browse/authors/G">G</a> | <a href="/browse/authors/H">
        H</a> | <a href="/browse/authors/I">I</a> | <a href="/browse/authors/J">J</a>
      | <a href="/browse/authors/K">K</a> | <a href="/browse/authors/L">L</a> | <a href="/browse/authors/M">
        M</a> | <a href="/browse/authors/N">N</a> | <a href="/browse/authors/O">O</a>
      | <a href="/browse/authors/P">P</a> | <a href="/browse/authors/Q">Q</a> | <a href="/browse/authors/R">
        R</a> | <a href="/browse/authors/S">S</a> | <a href="/browse/authors/T">T</a>
      | <a href="/browse/authors/U">U</a> | <a href="/browse/authors/V">V</a> | <a href="/browse/authors/W">
        W</a> | <a href="/browse/authors/X">X</a> | <a href="/browse/authors/Y">Y</a>
      | <a href="/browse/authors/Z">Z</a> | <a href="/browse/authors">ALL</a></td>
  </tr>
</table>
<div id="browseInnerDiv" style="height: 100%; overflow: auto;">
  <asp:Literal ID="creatorList" runat="server" EnableViewState="false" />
  <asp:Literal ID="creatorListAllLiteral" runat="server" />
</div>
