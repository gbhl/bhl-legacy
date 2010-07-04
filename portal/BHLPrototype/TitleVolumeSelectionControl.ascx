<%@ Control Language="C#" AutoEventWireup="true" Codebehind="TitleVolumeSelectionControl.ascx.cs"
  Inherits="MOBOT.BHL.Web.TitleVolumeSelectionControl" %>
<%@ Register TagPrefix="cc" Namespace="MOBOT.BHL.Web" Assembly="MOBOT.BHL.Web" %>

<cc:ContentPanel ID="titleSelectionContentPanel" runat="server">
  <table cellpadding="0" cellspacing="0" width="100%">
    <tr>
      <td class="title" nowrap="nowrap" width="1%">
        <asp:DropDownList ID="ddlTitles" runat="server" EnableViewState="false" CssClass="TextBox"
          Visible="false">
        </asp:DropDownList>
        <div class="BlackHeading">
          <asp:Literal ID="titleLiteral" runat="server" /></div>
      </td>
      <td class="volume" nowrap="nowrap" width="1%">
        <img src="/images/blank.gif" width="8" height="1" alt="" /><asp:DropDownList ID="ddlItem"
          Visible="false" runat="server" EnableViewState="false" CssClass="TextBox">
        </asp:DropDownList>&nbsp;&nbsp;
      </td>
        <td width="90%">
            <ul id="itemdd">
            <li class="headlink">
                <a id="linkAbout" runat="server" href="#">Download/About this book <img style="padding-bottom:3px;vertical-align:bottom" src="/images/down.gif" /></a>
                    <ul>
                    <li><a id="linkBib" runat="server" href="#">&nbsp;Bibliographic Information&nbsp;</a></li>
                    <li><a id="linkPDFGen" runat="server" href="#">&nbsp;Select pages to download&nbsp;</a></li>
                    <li><a id="linkPDF" runat="server" href="#">&nbsp;Download PDF&nbsp;</a></li>
                    <li><a id="linkOCR" runat="server" href="#">&nbsp;Download OCR&nbsp;</a></li>
                    <li><a id="linkImages" runat="server" href="#">&nbsp;Download Images&nbsp;</a></li>
                    <li><a id="linkAll" target="_blank" runat="server" href="#">&nbsp;Download All&nbsp;</a></li>
                </ul>
            </li>
            </ul>
        </td>
        <td align="right" width="5%">
            <asp:LinkButton ID="lnkFeedback" runat="server" Text="<img src='/images/rpterror.png' align='texttop' title='Report an error' />" PostBackUrl="/Feedback.aspx"></asp:LinkButton>
        </td>
    </tr>
  </table>
  <script>
      var timeout = 50; var closetimer = 0; var ddmenuitem = 0;

      function itemdd_open() 
      { itemdd_canceltimer(); itemdd_close(); ddmenuitem = $(this).find('ul').css('visibility', 'visible'); }

      function itemdd_close()
      { if (ddmenuitem) ddmenuitem.css('visibility', 'hidden'); }

      function itemdd_timer()
      { closetimer = window.setTimeout(itemdd_close, timeout); }

      function itemdd_canceltimer() 
      { if (closetimer) { window.clearTimeout(closetimer); closetimer = null; } }

      $(document).ready(function() {
          // DOESN'T WORK IN IE6
          //$('#itemdd > li').bind('mouseover', itemdd_open)
          //$('#itemdd > li').bind('mouseout', itemdd_timer)
          
          $('#titleSelectionContentPanel').css("width", "100%");

          $('li.headlink').hover(
            function() { $('ul', this).css('display', 'block'); },
            function() { $('ul', this).css('display', 'none'); });
      });

      document.onclick = itemdd_close;
  </script>
</cc:ContentPanel>
