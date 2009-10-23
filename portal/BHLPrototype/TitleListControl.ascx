<%@ Control Language="C#" AutoEventWireup="true" Codebehind="TitleListControl.ascx.cs" Inherits="MOBOT.BHL.Web.TitleListControl" %>
<table cellpadding="2" cellspacing="2" id="browseOptionsTable">
	<tr>
		<td align="right" valign="top" class="Rust">
			<b>Title:</b></td>
		<td valign="top">
			<a href="/browse/titles/A">A</a> | <a href="/browse/titles/B">B</a> | <a href="/browse/titles/C">C</a> | <a href="/browse/titles/D">
				D</a> | <a href="/browse/titles/E">E</a> | <a href="/browse/titles/F">F</a> | <a href="/browse/titles/G">G</a> | <a href="/browse/titles/H">
					H</a> | <a href="/browse/titles/I">I</a> | <a href="/browse/titles/J">J</a> | <a href="/browse/titles/K">K</a> | <a href="/browse/titles/L">
						L</a> | <a href="/browse/titles/M">M</a> | <a href="/browse/titles/N">N</a> | <a href="/browse/titles/O">O</a> | <a href="/browse/titles/P">
							P</a> | <a href="/browse/titles/Q">Q</a> | <a href="/browse/titles/R">R</a> | <a href="/browse/titles/S">S</a> | <a href="/browse/titles/T">
								T</a> | <a href="/browse/titles/U">U</a> | <a href="/browse/titles/V">V</a> | <a href="/browse/titles/W">W</a> | <a href="/browse/titles/X">
									X</a> | <a href="/browse/titles/Y">Y</a> | <a href="/browse/titles/Z">Z</a> | <a href="/browse/titles/ALL">ALL</a></td>
	</tr>
</table>
<div id="browseInnerDiv" style="height: 100%; overflow: auto;">
    <asp:Literal ID="titleList" runat="server" EnableViewState="false" />
</div>
