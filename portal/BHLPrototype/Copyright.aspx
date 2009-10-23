<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" Codebehind="Copyright.aspx.cs"
  Inherits="MOBOT.BHL.Web.Copyright" Title="Biodiversity Heritage Library" %>

<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<%@ Register TagPrefix="MOBOT" Assembly="MOBOT.BHL.Web.Utilities" Namespace="MOBOT.BHL.Web.Utilities" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
  <div id="browseContainerDiv">
    <cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
      <div id="browseInnerDiv" style="height: 100%; overflow: auto;">
        <MOBOT:RandomImageControl ID="randomImage" runat="server" Directory="images" ImagePrefix="int_rotate"
          MinIndex="1" MaxIndex="7" FileFormat="gif" Align="right" />
        <p class="pageheader">
          Can I use your images?</p>
        <p>
          Yes, please! All of the images on BiodiversityLibrary.org are free for non-commercial
          use, as long as you abide by the terms set down in the <a href="http://creativecommons.org/licenses/by-nc/2.5/">
            Creative Commons Attribution-Noncommercial 2.5</a> license. As more materials
          are added to the Biodiversity Heritage Library our usage terms will evolve to allow
          multiple licensing models. The Biodiversity Heritage Library is committed to keeping
          public domain materials in the public domain.
        </p>
        <!--Creative Commons License-->
        <a rel="license" href="http://creativecommons.org/licenses/by-nc/2.5/">
          <img alt="Creative Commons License" border="0" src="http://creativecommons.org/images/public/somerights20.png" /></a><!--/Creative Commons License--><!-- <rdf:RDF xmlns="http://web.resource.org/cc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	<Work rdf:about="">
		<license rdf:resource="http://creativecommons.org/licenses/by-nc/2.5/" />
	</Work>
	<License rdf:about="http://creativecommons.org/licenses/by-nc/2.5/"><permits rdf:resource="http://web.resource.org/cc/Reproduction"/><permits rdf:resource="http://web.resource.org/cc/Distribution"/><requires rdf:resource="http://web.resource.org/cc/Notice"/><requires rdf:resource="http://web.resource.org/cc/Attribution"/><prohibits rdf:resource="http://web.resource.org/cc/CommercialUse"/><permits rdf:resource="http://web.resource.org/cc/DerivativeWorks"/></License></rdf:RDF> -->
        <p class="pageheader">
          How do I download an image?</p>
        <p>
          Clicking the "Save" icon
          <img src="/viewer/images/document-save.png" alt="Save" />
          on any page will open a new window with an image in JPG format, optimized for printing.</p>
        <p class="pageheader">
          What does the Creative Commons (CC) license allow me to do?</p>
        <p>
          Here's a summary of the license rules:</p>
        <ul>
          <li><b>No commercial use</b> - you cannot use our images to make money, or for any
            commercial endeavor, <b>without prior approval</b>. Please feel free to use our
            images for your presentations, academic materials, non-profit publications, or non-profit
            web sites. If you want to include our images on your commercial web site, please
            read our commercial licensing provisions below.</li>
          <li><b>Provide attribution</b> - we prefer &quot;<b>Image courtesy Biodiversity Heritage
            Library. <a href="http://www.biodiversitylibrary.org">http://www.biodiversitylibrary.org</a></b>&quot;.</li>
        </ul>
        <p>
          This license applies only to images stored within the Biodiversity Heritage Library.
          It does not apply to image files at other sites that are linked from the Biodiversity
          Heritage Library.</p>
        <p class="pageheader">
          What about commercial licensing?</p>
        <p>
          We negotiate commercial licensing based on a variety of factors. Please <a href="mailto:bhl@si.edu">
            contact us</a> with details of your project, including:</p>
        <ul>
          <li>Image(s) requested</li>
          <li>Intended audience</li>
          <li>Intended use</li>
          <li>Broadcast or distribution method</li>
          <li>Resolution required</li>
          <li>Deadline</li>
        </ul>
      </div>
    </cc:ContentPanel>
  </div>
</asp:Content>
