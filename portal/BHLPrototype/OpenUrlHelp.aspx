<%@ Page Title="Biodiversity Heritage Library" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="True" CodeBehind="OpenUrlHelp.aspx.cs" Inherits="MOBOT.BHL.Web.OpenUrlHelp" %>
<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
  <div id="browseContainerDiv">
    <cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
      <div id="browseInnerDiv">
        <p class="pageheader">OpenUrl Resolver Help</p>
        <p><asp:Literal runat="server" ID="litMessage"></asp:Literal></p>
        <p>
            The Biodiversity Heritage Library's OpenURL query interface is available 
            at <b>http://www.biodiversitylibrary.org/openurl</b>.
        </p>
        <p>
            Both OpenURL 0.1 and OpenURL 1.0 queries are supported.
        </p>
        <div class="pagesubheader">Request Parameters</div>
        <p>
            The following table summarizes the parameters that are accepted by the OpenURL 0.1 and 1.0 
            query interfaces.
        </p>
        <table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr><th align="left" width="22%">OpenURL 0.1</th><th align="left" width="40%">&nbsp;</th><th align="left">OpenURL 1.0</th></tr>
        <tr><td>&nbsp;</td><td>Indicates OpenURL version</td><td>url_ver=z39.88-2004</td></tr>
        <tr><td>title</td><td>Book/Journal title</td><td>&nbsp;</td></tr>
        <tr><td>&nbsp;</td><td>Book title</td><td>rft.btitle</td></tr>
        <tr><td>&nbsp;</td><td>Journal title</td><td>rft.jtitle</td></tr>
        <tr><td>au</td><td>Author name ("last, first" or "corporation")</td><td>rft.au</td></tr>
        <tr><td>aulast</td><td>Author last name</td><td>rft.aulast</td></tr>
        <tr><td>aufirst</td><td>Author first name</td><td>rft.aufirst</td></tr>
        <tr><td>&nbsp;</td><td>Author name (corporation)</td><td>rft.aucorp</td></tr>
        <tr><td>publisher</td><td>Publication details</td><td>rft.publisher</td></tr>
        <tr><td>&nbsp;</td><td>Publisher name</td><td>rft.pub</td></tr>
        <tr><td>&nbsp;</td><td>Publication place</td><td>rft.place</td></tr>
        <tr><td>date</td><td>Publication date (YYYY or YYYY-MM or YYYY-MM-DD)</td><td>rft.date</td></tr>
        <tr><td>issn</td><td>ISSN</td><td>rft.issn</td></tr>
        <tr><td>isbn</td><td>ISBN</td><td>rft.isbn</td></tr>
        <tr><td>coden</td><td>CODEN</td><td>rft.coden</td></tr>
        <tr><td>stitle</td><td>Abbreviation</td><td>rft.stitle</td></tr>
        <tr><td>volume</td><td>Volume</td><td>rft.volume</td></tr>
        <tr><td>issue</td><td>Issue</td><td>rft.issue</td></tr>
        <tr><td>spage</td><td>Start page</td><td>rft.spage</td></tr>
        <tr><td>pid=oclcnum:XXXX</td><td>OCLC number (where XXXX is the ID value)</td><td>rft_id=info:oclcnum/XXXX</td></tr>
        <tr><td>pid=lccn:XXXX</td><td>Lib. of Congress ID (where XXXX is the ID value)</td><td>rft_id=info:lccn/XXXX</td></tr>
        <tr><td>pid=title:XXXX</td><td>BHL title ID (where XXXX is the ID value)</td><td>rft_id=http://www.biodiversitylibrary.org/bibliography/XXXX</td></tr>
        <tr><td>pid=page:XXXX</td><td>BHL page ID (where XXXX is the ID value)</td><td>rft_id=http://www.biodiversitylibrary.org/page/XXXX</td></tr>
        </table>
        <div class="pagesubheader">Response Formats</div>
        <p>
            By default, the query interface will (if possible) redirect to the 
            Biodiversity Heritage Library page containing the citation described 
            by the query arguments.  If more than one possible citation is found, 
            the query interface redirects to a page from which the appropriate 
            citation can be selected.
        </p>
        <p>
            There are several additional ways that results from the query interface 
            can be returned: JSON, XML, and HTML.  To get the citation data in 
            those formats, add the "format" argument to the end of the OpenURL 
            query with one of the following values: "json", "xml", "html".
        </p>
        <div class="pagesubheader">Examples</div>
        <p>
            Following are some example queries and responses.
        </p>
            <div style="font-weight:bold">OpenUrl 0.1</div>
            <p>
                The following query references Samual Wendell Williston, <i>Manual of North American Diptera</i> (New Haven :J.T. Hathaway) 16.
            </p>
            <div style="font-family:Courier New">
                /openurl?<br />
                &amp;genre=book<br />
                &amp;title=Manual+of+North+American+Diptera<br />
                &amp;aufirst=Samuel Wendell<br />
                &amp;aulast=Williston<br />
                &amp;publisher=New+Haven+:J.T.+Hathaway,<br />
                &amp;date=1908<br />
                &amp;spage=16<br />
            </div>
            <p><a href="/openurl?genre=book&amp;title=Manual+of+North+American+Diptera&amp;aufirst=Samuel+Wendell&amp;aulast=Williston&amp;publisher=New+Haven+:J.T.+Hathaway,&amp;date=1908&amp;spage=16">Click here to try it</a></p>
            <div style="font-weight:bold">OpenURL 1.0</div>
            <p>
                Here's the same query, using the OpenURL 1.0 specification.
            </p>
            <div style="font-family:Courier New">
            /openurl?url_ver=Z39.88-2004<br />
            &amp;ctx_ver=Z39.88-2004<br />
            &amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook<br />
            &amp;rft.genre=book<br />
            &amp;rft.btitle=Manual+of+North+American+Diptera<br />
            &amp;rft.aufirst=Samuel Wendell<br />
            &amp;rft.aulast=Williston<br />
            &amp;rft.publisher=New+Haven+:J.T.+Hathaway,<br />
            &amp;rft.date=1908<br />
            &amp;rft.spage=16<br />
            </div>
            <p><a href="/openurl?url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=book&amp;rft.btitle=Manual+of+North+American+Diptera&amp;rft.aufirst=Samuel+Wendell&amp;rft.aulast=Williston&amp;rft.publisher=New+Haven+:J.T.+Hathaway,&amp;rft.date=1908&amp;rft.spage=16">Click here to try it</a></p>
            <div style="font-weight:bold">Response in JSON</div>
            <p>
                To receive the response in JSON, append "&amp;format=json" to the end of the query, as shown here.
                This example shows the OpenURL 0.1 query syntax, but it will also work for OpenURL 1.0 queries.
            </p>
            <div style="font-family:Courier New">
                /openurl?<br />
                &amp;genre=book<br />
                &amp;title=Manual+of+North+American+Diptera<br />
                &amp;aufirst=Samuel Wendell<br />
                &amp;aulast=Williston<br />
                &amp;publisher=New+Haven+:J.T.+Hathaway,<br />
                &amp;date=1908<br />
                &amp;spage=16<br />
                <span style="font-weight:bold; color:Blue">&amp;format=json</span><br />
            </div>
            <p><a href="/openurl?genre=book&amp;title=Manual+of+North+American+Diptera&amp;aufirst=Samuel+Wendell&amp;aulast=Williston&amp;publisher=New+Haven+:J.T.+Hathaway,&amp;date=1908&amp;spage=16&amp;format=json">Click here to try it</a></p>
            <div style="font-weight:bold">Response in XML</div>
            <p>
                To receive the response in XML, append "&amp;format=xml" to the end of the query, as shown here.
                Again, this will work for both OpenURL 0.1 and OpenURL 1.0 queries.
            </p>
            <div style="font-family:Courier New">
                /openurl?<br />
                &amp;genre=book<br />
                &amp;title=Manual+of+North+American+Diptera<br />
                &amp;aufirst=Samuel Wendell<br />
                &amp;aulast=Williston<br />
                &amp;publisher=New+Haven+:J.T.+Hathaway,<br />
                &amp;date=1908<br />
                &amp;spage=16<br />
                <span style="font-weight:bold; color:Blue">&amp;format=xml</span><br />
            </div>
            <p><a href="/openurl?genre=book&amp;title=Manual+of+North+American+Diptera&amp;aufirst=Samuel+Wendell&amp;aulast=Williston&amp;publisher=New+Haven+:J.T.+Hathaway,&amp;date=1908&amp;spage=16&amp;format=xml">Click here to try it</a></p>
            <div style="font-weight:bold">Response in HTML</div>
            <p>
                To receive the response as an HTML fragment, append "&amp;format=html" to the end of the query, as shown here.
                As with JSON and XML responses, this will work for both OpenURL 0.1 and OpenURL 1.0 queries.
            </p>
            <div style="font-family:Courier New">
                /openurl?<br />
                &amp;genre=book<br />
                &amp;title=Manual+of+North+American+Diptera<br />
                &amp;aufirst=Samuel Wendell<br />
                &amp;aulast=Williston<br />
                &amp;publisher=New+Haven+:J.T.+Hathaway,<br />
                &amp;date=1908<br />
                &amp;spage=16<br />
                <span style="font-weight:bold; color:Blue">&amp;format=html</span><br />
            </div>
            <p><a href="/openurl?genre=book&amp;title=Manual+of+North+American+Diptera&amp;aufirst=Samuel+Wendell&amp;aulast=Williston&amp;publisher=New+Haven+:J.T.+Hathaway,&amp;date=1908&amp;spage=16&amp;format=html">Click here to try it</a></p>
      </div>
    </cc:ContentPanel>
  </div>
</asp:Content>
