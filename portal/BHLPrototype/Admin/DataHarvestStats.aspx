<%@ Page Language="C#" MasterPageFile="/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DataHarvestStats.aspx.cs" Inherits="MOBOT.BHL.Web.Admin.DataHarvestStats" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<br />
    <a href="/Admin/Dashboard.aspx">&lt; Return to Dashboard</a><br />
	<br />
	<span class="pageHeader">Data Harvest Stats</span><hr />
	<div style="position:absolute;top:100px;left:5px">
        <span class="tableHeader">Internet Archive Item Count By Status</span><br />
        <div style="overflow:auto;height:175px;width:450px;border-style:solid;border-color:Black;border-width:1px">
            <asp:GridView ID="gvItemCountByStatus" runat="server" AutoGenerateColumns="False" Width="90%" HorizontalAlign="Center" GridLines="none">
            <Columns>
                <asp:BoundField DataField="Status" HeaderText="Status" ItemStyle-VerticalAlign="top" ItemStyle-Wrap="false" HeaderStyle-HorizontalAlign="left" />
                <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-VerticalAlign="top" HeaderStyle-HorizontalAlign="left" />
                <asp:BoundField DataField="NumberOfItems" HeaderText="# Of Items" ItemStyle-VerticalAlign="top" HeaderStyle-Wrap="false" ItemStyle-HorizontalAlign=right HeaderStyle-HorizontalAlign="right" />
            </Columns>
            </asp:GridView>
        </div>
    </div>
	<div style="position:absolute;top:310px;left:5px">
	    <span class="tableHeader" style="display: inline">Internet Archive Items Pending Approval</span>
        <div style="overflow:scroll;height:175px;width:300px;border-style:solid;border-color:Black;border-width:1px">
            <asp:GridView ID="gvPendApprovalByAge" runat="server" AutoGenerateColumns="false" Width="60%" HorizontalAlign="center" GridLines="none">
            <Columns>
                <asp:BoundField DataField="AgeInDays" HeaderText="Age In Days" HeaderStyle-HorizontalAlign="left" />
                <asp:BoundField DataField="NumberOfItems" HeaderText="# Of Items" HeaderStyle-HorizontalAlign="right" HeaderStyle-Wrap="false" ItemStyle-HorizontalAlign="right" /></Columns>
            </asp:GridView>
        </div>
        <div style="position:absolute;top:20px;left:320px;height:175px;width:115px">
            <asp:HyperLink ID="hypNumItems" NavigateUrl="reportiaitemspendingapproval.aspx?age=" runat="server" Text="Download"></asp:HyperLink> to Excel the <asp:Literal ID="litNumItems" runat="server"></asp:Literal> items that have been Pending Approval for more than <asp:Literal ID="litNumDays" runat="server"></asp:Literal> days.
        </div>
    </div>
	<div style="position:absolute;top:100px;left:500px">
	    <span class="tableHeader">Internet Archive Data Ready To Be Published</span>
        <div style="overflow:auto;height:175px;width:300px;border-style:solid;border-color:Black;border-width:1px">
            <asp:GridView ID="gvIAReadyToPublish" runat="server" AutoGenerateColumns="false" Width="70%" HorizontalAlign="center" GridLines="none">
            <Columns>
                <asp:BoundField DataField="Type" HeaderText="Table" HeaderStyle-HorizontalAlign="left" />
                <asp:BoundField DataField="NumberOfItems" HeaderText="# Of Items" HeaderStyle-HorizontalAlign="right" HeaderStyle-Wrap="false" ItemStyle-HorizontalAlign="right" /></Columns>
            </asp:GridView>
        </div>
    </div>
	<div style="position:absolute;top:310px;left:500px">
	    <span class="tableHeader">Botanicus Data Ready To Be Published</span>
        <div style="overflow:auto;height:175px;width:300px;border-style:solid;border-color:Black;border-width:1px">
            <asp:GridView ID="gvBotReadyToPublish" runat="server" AutoGenerateColumns="false" Width="70%" HorizontalAlign="center" GridLines="none">
            <Columns>
                <asp:BoundField DataField="Type" HeaderText="Table" HeaderStyle-HorizontalAlign="left" />
                <asp:BoundField DataField="NumberOfItems" HeaderText="# Of Items" HeaderStyle-HorizontalAlign="right" HeaderStyle-Wrap="false" ItemStyle-HorizontalAlign="right" /></Columns>
            </asp:GridView>
        </div>
    </div>
	<div style="position:absolute;top:520px;left:5px">
	    <span class="tableHeader">Latest Import Logs (Results of Publish To Production)</span>
        <div style="overflow:scroll;height:175px;width:795px;border-style:solid;border-color:Black;border-width:1px">
            <asp:GridView ID="gvLatestPubToProdLogs" runat="server" AutoGenerateColumns="false" Width="70%" HorizontalAlign="center" GridLines="none">
            <Columns>
                <asp:BoundField DataField="ImportDate" HeaderText="Import Date" HeaderStyle-HorizontalAlign="left" HeaderStyle-Wrap="false" HeaderStyle-VerticalAlign="bottom" ItemStyle-Wrap="false"/>
                <asp:BoundField DataField="ImportSource" HeaderText="Import Source" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" />
                <asp:BoundField DataField="ImportResult" HeaderText="Result" HeaderStyle-HorizontalAlign="left" HeaderStyle-Wrap="false" HeaderStyle-VerticalAlign="bottom" />
                <asp:BoundField DataField="TitleInsert" HeaderText="Title Inserts" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleUpdate" HeaderText="Title Updates" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="CreatorInsert" HeaderText="Creator Inserts" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="CreatorUpdate" HeaderText="Creator Updates" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleCreatorInsert" HeaderText="Title Creator Inserts" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleCreatorUpdate" HeaderText="Title Creator Updates" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleTagInsert" HeaderText="Title Tag Inserts" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleTagUpdate" HeaderText="Title Tag Updates" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleTitleIdentifierInsert" HeaderText="Title ID Inserts" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleTitleIdentifierUpdate" HeaderText="Title ID Updates" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleAssociationInsert" HeaderText="Title Assoc Insert" HeaderStyle-HorizontalAlign="Left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleAssociationTitleIdentifierInsert" HeaderText="Title Assoc ID Insert" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="ItemInsert" HeaderText="Item Inserts" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="ItemUpdate" HeaderText="Item Updates" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleItemInsert" HeaderText="TitleItem Inserts" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="PageInsert" HeaderText="Page Inserts" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="PageUpdate" HeaderText="Page Updates" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="IndicatedPageInsert" HeaderText="Indicated Page Inserts" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="IndicatedPageUpdate" HeaderText="Indicated Page Updates" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="PagePageTypeInsert" HeaderText="Page Type Inserts" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="PagePageTypeUpdate" HeaderText="Page Type Updates" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="PageNameInsert" HeaderText="Page Name Inserts" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="PageNameUpdate" HeaderText="Page Name Updates" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
            </Columns>
            </asp:GridView>
        </div>
    </div>
	<div style="position:absolute;top:730px;left:5px">
	    <span class="tableHeader">Latest Import Errors (Errors Publishing To Production)</span>
        <div style="overflow:scroll;height:175px;width:795px;border-style:solid;border-color:Black;border-width:1px">
            <asp:GridView ID="gvLatestPubToProdErrors" runat="server" AutoGenerateColumns="false" Width="70%" HorizontalAlign="center" GridLines="none">
            <Columns>
                <asp:BoundField DataField="ErrorDate" HeaderText="Error Date" HeaderStyle-HorizontalAlign="left" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="Number" HeaderText="Number" HeaderStyle-HorizontalAlign="left" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="Severity" HeaderText="Severity" HeaderStyle-HorizontalAlign="left" ItemStyle-HorizontalAlign="center" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="State" HeaderText="State" HeaderStyle-HorizontalAlign="left" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="Procedure" HeaderText="Procedure" HeaderStyle-HorizontalAlign="left" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="Line" HeaderText="Line" HeaderStyle-HorizontalAlign="left" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="Message" HeaderText="Message" HeaderStyle-HorizontalAlign="left" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="KeyValue" HeaderText="Key" HeaderStyle-HorizontalAlign="left" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-VerticalAlign="top" />
            </Columns>
            </asp:GridView>
        </div>
    </div>
	<div style="position:absolute;top:940px;left:5px">
	    <span class="tableHeader">Latest Botanicus Harvest Logs (Results of Move from Botanicus to BHLImport)</span>
        <div style="overflow:scroll;height:175px;width:795px;border-style:solid;border-color:Black;border-width:1px">
            <asp:GridView ID="gvBotHarvestLog" runat="server" AutoGenerateColumns="false" Width="70%" HorizontalAlign="center" GridLines="none">
            <Columns>
                <asp:BoundField DataField="HarvestStartDate" HeaderText="From Date" HeaderStyle-HorizontalAlign="left" HeaderStyle-Wrap="false" HeaderStyle-VerticalAlign="bottom" ItemStyle-Wrap="false"/>
                <asp:BoundField DataField="HarvestEndDate" HeaderText="To Date" HeaderStyle-HorizontalAlign="left" HeaderStyle-Wrap="false" HeaderStyle-VerticalAlign="bottom" ItemStyle-Wrap="false" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" />
                <asp:BoundField DataField="AutomaticHarvest" HeaderText="Scheduled" HeaderStyle-HorizontalAlign="left" HeaderStyle-Wrap="false" HeaderStyle-VerticalAlign="bottom" />
                <asp:BoundField DataField="SuccessfulHarvest" HeaderText="Success" HeaderStyle-HorizontalAlign="left" HeaderStyle-Wrap="false" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" />
                <asp:BoundField DataField="Title" HeaderText="Titles" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center" />
                <asp:BoundField DataField="Creator" HeaderText="Creators" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleCreator" HeaderText="Title Creators" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="TitleTag" HeaderText="Title Tags" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="Item" HeaderText="Items" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="Page" HeaderText="Pages" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="IndicatedPage" HeaderText="Indicated Pages" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="PagePageType" HeaderText="Page Types" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center"/>
                <asp:BoundField DataField="PageName" HeaderText="Page Names" HeaderStyle-HorizontalAlign="left" HeaderStyle-VerticalAlign="bottom" ItemStyle-HorizontalAlign="center"/>
            </Columns>
            </asp:GridView>
        </div>
    </div>
	<div style="position:absolute;top:1150px;left:5px">
	    <span class="tableHeader">Latest Internet Archive Item Errors (Errors Moving From "Approved" To "Complete" Status)</span>
        <div style="overflow:scroll;height:175px;width:795px;border-style:solid;border-color:Black;border-width:1px">
            <asp:GridView ID="gvIAItemErrors" runat="server" AutoGenerateColumns="false" Width="70%" HorizontalAlign="center" GridLines="none">
            <Columns>
                <asp:BoundField DataField="ErrorDate" HeaderText="Error Date" HeaderStyle-HorizontalAlign="left" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="Number" HeaderText="Number" HeaderStyle-HorizontalAlign="left" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="Severity" HeaderText="Severity" HeaderStyle-HorizontalAlign="left" ItemStyle-HorizontalAlign="center" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="State" HeaderText="State" HeaderStyle-HorizontalAlign="left" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="Procedure" HeaderText="Procedure" HeaderStyle-HorizontalAlign="left" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="Line" HeaderText="Line" HeaderStyle-HorizontalAlign="left" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-HorizontalAlign="center" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="Message" HeaderText="Message" HeaderStyle-HorizontalAlign="left" ItemStyle-VerticalAlign="top" />
                <asp:BoundField DataField="IAIdentifier" HeaderText="IA ID" HeaderStyle-HorizontalAlign="left" HeaderStyle-BackColor="#EEEEEE" ItemStyle-BackColor="#EEEEEE" ItemStyle-VerticalAlign="top" />
            </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
