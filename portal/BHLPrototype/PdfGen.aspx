<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="PdfGen.aspx.cs" Inherits="MOBOT.BHL.Web.PdfGen" 
    Title="Biodiversity Heritage Library" %>
<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
    <div id="browseContainerDiv">
        <cc:ContentPanel ID="browseContentPanel" runat="server" TableID="browseContentPanel">
			<div id="browseInnerDiv" style="overflow: auto;">
			    <div class="pageheader">Generate a PDF <span id="spanStep" style="font-size:small">(Step 1 of 2)</span>&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:Red; font-weight:bold">BETA</span></div>
                <div class="ErrorText"><asp:Literal ID="litError" runat="server"></asp:Literal></div>
			    <div id="page1">
			        <p>This page allows you to generate a downloadable PDF from only the pages that you 
			        select.</p>
			        <p><b>PDF generation is limited to 50 pages.</b>&nbsp;&nbsp;<asp:Literal runat="server" ID="litDownloadLink"></asp:Literal></p>
			        <div class="BlackHeading">Select page images&nbsp;&nbsp;<input type="button" id="btnNext" value="Next" /></div>
			        <br /><a id="SelectAll" class="small" href="#">Select All</a>&nbsp;&nbsp;<a id="ClearAll" class="small" href="#">Clear All</a>
			        <br />
                    <asp:DataList ID="dlPages" runat="server" RepeatDirection="Vertical" RepeatColumns="3" CellPadding="3" Width="600px">
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <input class="pgChkBx" type="checkbox" runat="server" id="chkPage" value='<%# Eval("PageID") %>' />
                        <%# (Eval("IndicatedPages").ToString().Trim() == "") ? Eval("PageTypes") : Eval("IndicatedPages") %>
                        &nbsp;<img onmouseover="swapImgOver(this)" onmouseout="swapImgOut(this)" class="imgView" id="img<%# Eval("PageID") %>" src="/images/textpage.png" />
                    </ItemTemplate>
                    <FooterTemplate>
                    </FooterTemplate>
                    </asp:DataList>
                </div>
                <div id="page2" style="display:none">
                    <div>
                        <br /><input type="button" id="btnPrevious" value="Previous" />&nbsp;&nbsp;
                        <asp:Button runat="server" ID="btnDone1" Text="Done" OnClick="btnDone_Click" /><br /><br />
                    </div>
                    <p>Please enter the email address to which you would like a link to the PDF to be sent.  If 
                    you want to share the link with others, enter their email addresses as well.</p>
                    <div class="BlackHeading">
                        Email Address: <asp:TextBox runat="server" Columns="40" ID="txtEmail"></asp:TextBox>
                    </div>
                    <br />
                    <div class="BlackHeading">
                        Share With: <asp:TextBox runat="server" Columns="80" ID="txtShareWith" style="color:gray"  Text="Enter email addresses, separated by commas" onfocus="if (this.value.indexOf('Enter email addresses') > -1) this.value='';this.style.color='#000000';" ></asp:TextBox>
                    </div>
                    <br />
                    <div>
                        <span class="BlackHeading">Include:&nbsp;</span><asp:RadioButton ID="rdoImages" GroupName="grpImageOCR" runat="server" Text="Page images only" Checked=true />&nbsp;&nbsp;<asp:RadioButton ID="rdoImagesOCR" GroupName="grpImageOCR" runat="server" Text="Page images and OCR text" />
                    </div>
                    <div style="margin:30px;">
                        Are you generating a PDF containing the text of a single journal article or book chapter?  If so, please help us
                        out by providing the following information!<br /><br />
                        <div style="border-style:solid; border-width:1px; padding:10px; background-color:#f6f2d9">
                            <div class="BlackHeading">
                                Article/Chapter Title:&nbsp;<asp:TextBox runat="server" ID="txtArticleTitle" Columns="60" /><br /><br />
                            </div>
                            <div class="BlackHeading">
                                Author(s):
                                <asp:TextBox runat="server" ID="txtAuthors" Columns="55" Rows="2" TextMode="MultiLine" style="color:gray" Text="Enter names, separated by commas (example: First Last, First Last, First Last)" onfocus="if (this.value.indexOf('Enter names') > -1) this.value='';this.style.color='#000000';" />
                            </div>
                            <br />
                            <div class="BlackHeading">
                                Subject(s):
                                <asp:TextBox runat="server" ID="txtSubjects" Columns="55" Rows="2" TextMode="MultiLine" style="color:gray" Text="Enter subjects, separated by commas" onfocus="if (this.value.indexOf('Enter subjects') > -1) this.value='';this.style.color='#000000';" />
                            </div>
                        </div>
                    </div>
                    <div>
                        <asp:Button runat="server" ID="btnDone2" Text="Done" OnClick="btnDone_Click" />
                    </div>
                </div>
                <div id="imagePopup">
                    <a id="imageZoomIcon"><img alt="See Detail" src="/images/view_page.gif" /></a>
                    <a id="imagePopupClose" class="imagePopupClose">x</a>
                    <img id="pageImage" height="300" width="200" />
                </div>
                <div id="imageZoom">
                    <a id="imagePopupZoomClose" class="imagePopupClose">x</a>
                    <img id="pageImageZoom" height="600" width="400" />
                </div>
                <div id="imagePopupBackground"></div>
			</div>
		</cc:ContentPanel>
	</div>
	<script>

	    $(document).ready(function() {
	        $("#btnNext").click(function() { $("#spanStep").html("(Step 2 of 2)"); $("#page1").toggle(200); $("#page2").toggle(200); return false; });
	        $("#btnPrevious").click(function() { $("#spanStep").html("(Step 1 of 2)"); $("#page2").toggle(200); $("#page1").toggle(200); return false; });
	        $("#SelectAll").click(function() {
	            if ($("input.pgChkBx").size() > 50) {
	                alert('Please select 50 pages or less.');
	            }
	            else {
	                $("input.pgChkBx").attr("checked", true);
	            }
	            return false;
	        });
	        $("input.pgChkBx").click(function() {
	            if ($("input.pgChkBx:checked").size() > 50) {
	                alert("Please select 50 pages or less.");
	                $(this).attr("checked", false);
	            }
	        });
	        $("#ClearAll").click(function() { $("input.pgChkBx").attr("checked", false); return false; });
	        $("img.imgView").click(function() {
	            $("#pageImage").attr("src", "/getpagethumb.ashx?PageID=" + $(this).attr('id').replace('img', ''));
	            centerPopup("#imagePopup");
	            loadPopup("#imagePopup");
	            return false;
	        });
	        $("#imageZoomIcon").click(function() {
	            disablePopup();
	            $("#pageImageZoom").attr("src", $("#pageImage").attr("src") + "&h=600&w=400");
	            centerPopup("#imageZoom");
	            loadPopup("#imageZoom");
	            return false;
	        });
	        $("#imagePopupClose").click(function() { disablePopup(); });
	        $("#imagePopupZoomClose").click(function() { disablePopup(); });
	        $(document).keypress(function(e) { if (e.keyCode == 27 && popupStatus == 1) { disablePopup(); } });
	    });
	
    var popupStatus = 0;
    function loadPopup(popup){if(popupStatus==0){$("#imagePopupBackground").fadeIn("fast");$(popup).fadeIn("fast");popupStatus = 1;}}
    function disablePopup(){if(popupStatus==1){$("#imagePopupBackground").fadeOut("fast");$("#imagePopup").fadeOut("fast");$("#imageZoom").fadeOut("fast");popupStatus = 0;}}
    function centerPopup(popup){
        var windowWidth = document.documentElement.clientWidth;
        var windowHeight = document.documentElement.clientHeight;
        var popupHeight = $(popup).height();
        var popupWidth = $(popup).width();

        $(popup).css({"position": "absolute","top": windowHeight/2-popupHeight/2,"left": windowWidth/2-popupWidth/2});
        $("#imagePopupBackground").css({"height":windowHeight});
    }

    function swapImgOver(img) {
        img.src = "/images/textpageblk.png";
    }
    function swapImgOut(img) {
        img.src = "/images/textpage.png";
    }
    </script>
</asp:Content>
