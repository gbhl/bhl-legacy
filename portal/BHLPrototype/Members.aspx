<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="Members.aspx.cs"
  Inherits="MOBOT.BHL.Web.Members" Title="Biodiversity Heritage Library Members" %>

<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<%@ Register TagPrefix="MOBOT" Assembly="MOBOT.BHL.Web.Utilities" Namespace="MOBOT.BHL.Web.Utilities" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
  <div id="browseContainerDiv">
    <cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
      <div id="browseInnerDiv" style="height: 100%; overflow: auto;">
        <MOBOT:RandomImageControl ID="randomImage" runat="server" Directory="images" ImagePrefix="int_rotate"
          MinIndex="1" MaxIndex="7" FileFormat="gif" Align="right" />
        <p class="pageheader">
          Biodiversity Heritage Library Members</p>
        For questions or more information about the Biodiversity Heritage Library, please
        email <a href="mailto:BHL@si.edu">BHL@si.edu</a>
        <p>
          <ul>
            <li><a href="http://www.amnh.org/">American Museum of Natural History (New York)</a>
              <ul>
                <li><a href="http://library.amnh.org/">Department of Library Services</a></li>
              </ul>
            </li>
            <li><a href="http://www.fieldmuseum.org/">The Field Museum</a>
              <ul>
                <li><a href="http://www.fieldmuseum.org/research_collections/library/default.htm">
                  The Field Museum Library</a></li>
              </ul>
            </li>
            <li><a href="http://www.harvard.edu/">Harvard University</a>
              <ul>
                <li><a href="http://www.huh.harvard.edu/libraries/">Harvard University Botany Libraries</a></li>
                <li><a href="http://library.mcz.harvard.edu/">Ernst Mayr Library of the Museum of
                  Comparative Zoology</a></li>
              </ul>
            </li>
            <li><a href="http://www.mblwhoilibrary.org/">Marine Biological Laboratory and Woods
              Hole Oceanographic Institution Library</a></li>
            <li><a href="http://www.mobot.org/">Missouri Botanical Garden</a>
              <ul>
                <li><a href="http://www.mobot.org/MOBOT/molib/">Library</a></li>
              </ul>
            </li>
            <li><a href="http://www.nhm.ac.uk/">Natural History Museum, London</a>
              <ul>
                <li><a href="http://www.nhm.ac.uk/research-curation/library/">Library &amp; Archives</a></li>
              </ul>
            </li>
            <li><a href="http://www.nybg.org/">The New York Botanical Garden</a>
              <ul>
                <li><a href="http://library.nybg.org/">The LuEsther T. Mertz Library</a></li>
              </ul>
            </li>
            <li><a href="http://www.rbgkew.org.uk/">Royal Botanic Garden, Kew</a>
              <ul>
                <li><a href="http://www.rbgkew.org.uk/library/index.html">Library &amp; Archives</a></li>
              </ul>
            </li>
            <li><a href="http://www.si.edu/">Smithsonian Institution</a>
              <ul>
                <li><a href="http://www.sil.si.edu/">Smithsonian Institution Libraries</a></li>
              </ul>
            </li>
          </ul>
          <p>
            <strong>Contributing Member</strong></p>
          <ul>
            <li>University of Illinois at Urbana-Champaign, <a href="http://www.library.uiuc.edu/">
              University Library</a></li>
          </ul>
        </p>
      </div>
    </cc:ContentPanel>
  </div>
</asp:Content>
