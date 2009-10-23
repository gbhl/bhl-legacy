<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="PdfGenDone.aspx.cs" Inherits="MOBOT.BHL.Web.PdfGenDone" Title="Biodiversity Heritage Library" %>
<%@ Register TagPrefix="cc" Assembly="MOBOT.BHL.Web" Namespace="MOBOT.BHL.Web" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
    <cc:ContentPanel ID="browseContentPanel" runat="server">
        <p class="pageheader">PDF Request Received</p>
        <p class="">Your request has been received.</p>
        <p>The confirmation number for this request is <b><asp:Literal runat="server" ID="litPDFID"></asp:Literal></b>.  Please watch your email for a message containing a link to download the PDF.</p>
        <p class="">If you do not receive the email message, please use <a href="/feedback.aspx">our Feedback page</a> to let us know.  Thank you.</p>
    </cc:ContentPanel>
</asp:Content>
