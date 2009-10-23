<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="About.aspx.cs"
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
              <MOBOT:RandomImageControl ID="randomImage" runat="server" Directory="images" ImagePrefix="int_rotate"
                MinIndex="1" MaxIndex="7" FileFormat="gif" Align="right" />
              <div>
                <p class="pageheader">
                  About the Biodiversity Heritage Library
                </p>
                <p>
                  <p>
                    Ten major natural history museum libraries, botanical libraries, and research institutions
                    have joined to form the Biodiversity Heritage Library Project. The group is developing
                    a strategy and operational plan to digitize the published literature of biodiversity
                    held in their respective collections. This literature will be available through
                    a global &#8220;biodiversity commons.&#8221;</p>
                  <p>
                    <strong>Participating institutions:</strong></p>
                  <ul>
                    <li>American Museum of Natural History (New York, NY)</li>
                    <li>The Field Museum (Chicago, IL)</li>
                    <li>Harvard University Botany Libraries (Cambridge, MA)</li>
                    <li>Harvard University, Ernst Mayr Library of the Museum of Comparative Zoology (Cambridge,
                      MA)</li>
                    <li>Marine Biological Laboratory / Woods Hole Oceanographic Institution (Woods Hole,
                      MA)</li>
                    <li>Missouri Botanical Garden (St. Louis, MO)</li>
                    <li>Natural History Museum (London, UK)</li>
                    <li>The New York Botanical Garden (New York, NY)</li>
                    <li>Royal Botanic Gardens, Kew (Richmond, UK)</li>
                    <li>Smithsonian Institution Libraries (Washington, DC)</li>
                  </ul>
                  <p>
                    The participating libraries have over two million volumes of biodiversity literature
                    collected over 200 years to support the work of scientists, researchers, and students
                    in their home institutions and throughout the world.
                  </p>
                  <p>
                    The BHL will provide basic, important content for immediate research and for multiple
                    bioinformatics initiatives. For the first time in history, the core of our natural
                    history and herbaria library collections will be available to a truly global audience.
                    Web-based access to these collections will provide a substantial benefit to people
                    living and working in the developing world -- whether scientists or policymakers.
                  </p>
                  <p>
                    <strong>Contributing Members</strong></p>
                  <ul>
                    <li>The University Library of the University of Illinois at Urbana-Champaign<br />
                      UIUC has agreed to participate in the BHL as a contributing member by<br />
                      digitizing important biodiversity journals originating in the state of Illinois.<br />
                    </li>
                  </ul>
                  <p>
                    The Biodiversity Heritage Library Project will actively seek to incorporate data
                    and content from other digitization projects.
                  </p>
                  <h3>
                    Legacy Taxonomic Literature</h3>
                  <p>
                    The partner libraries collectively hold a substantial part of the world&#8217;s
                    published knowledge on biological diversity. Yet, this wealth of knowledge is available
                    only to those few who can gain direct access to these collections. This body of
                    biodiversity knowledge, in its current form, is unavailable to a broad range of
                    applications including: research, education, taxonomic study, biodiversity conservation,
                    protected area management, disease control, and maintenance of diverse ecosystems
                    services.
                  </p>
                  <p>
                    Much of this published literature is rare or has limited global distribution. From
                    a scholarly perspective, these collections are of exceptional value because the
                    domain of systematic biology depends -- more than any other science -- upon historic
                    literature. The &#8220;cited half-life&#8221; of natural history literature is longer
                    than that of any other scientific domain. The so-called &#8220;decay-rate&#8221;
                    of this literature is much slower than in other fields such as biotechnology. Mass
                    digitization projects at large research libraries lack the discipline-specific focus
                    of the Biodiversity Heritage Library Project. These other projects will fail to
                    capture significant elements of legacy taxonomic literature.</p>
                  <h3>
                    Open Access</h3>
                  <p>
                    The Biodiversity Heritage Library Project strives to establish a major corpus of
                    digitized publications on the Web drawn from the historical biodiversity literature.
                    This material will be available for open access and responsible use as a part of
                    a global Biodiversity Commons. We will work with the global taxonomic community,
                    rights holders, and other interested parties to ensure that this legacy literature
                    is available to all.
                  </p>
                  <h3>
                    Partnership</h3>
                  <p>
                    The Biodiversity Heritage Library Project must be a multi-institutional project
                    because no single natural history museum or botanical garden library holds the complete
                    corpus of legacy literature, even within the individual sub-domains of taxonomy.
                    However, taken together, the proposed consortium of collections represents a uniquely
                    comprehensive assemblage of literature.
                  </p>
                  <p>
                    The Biodiversity Heritage Library Project will immediately provide content for multiple
                    bioinformatics initiatives and research. For the first time in history, the core
                    of our natural history museum libraries and botanical garden library collections
                    will be available to a truly global audience. Web-based access to these collections
                    will provide a substantial benefit to all researchers, including those living and
                    working in the developing world.
                  </p>
                  <h3>
                    More Information</h3>
                  <ul>
                    <li>For questions or more information about the Biodiversity Heritage Library Project,
                      please email <a href="mailto:BHL@si.edu">BHL@si.edu</a></li>
                    <li><a href="http://www.sil.si.edu/bhl/supportdocuments/BHLP-prospectus10-05.pdf">
                      Biodiversity Heritage Library Prospectus</a> (PDF)</li>
                  </ul>
                </p>
              </div>
            </td>
          </tr>
        </table>
        <br />
					For users with administrative rights you may <asp:HyperLink ID="loginLink" CssClass="HeaderLinks" runat="server" NavigateUrl="/Ligustrum.aspx?send=1">login</asp:HyperLink> here.
					<br />
					<asp:Label ID="adminLabel" runat="server">
						Access to the	<asp:HyperLink ID="adminLink" NavigateUrl="/Admin/Dashboard.aspx" CssClass="HeaderLinks" runat="server">Admin Site</asp:HyperLink>.
					</asp:Label>
      </div>
    </cc:ContentPanel>
  </div>
</asp:Content>
