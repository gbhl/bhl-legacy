<%@ Page Language="C#" MasterPageFile="/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="LocationEdit.aspx.cs" Inherits="MOBOT.BHL.Web.Admin.LocationEdit" 
    ValidateRequest="false" %>

<%@ Register Src="/Admin/Controls/ErrorControl.ascx" TagName="ErrorControl" TagPrefix="mobot" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
	<a href="/Admin/Dashboard.aspx">&lt; Return to Dashboard</a><br />
	<br />
	<span class="pageHeader">Locations</span><hr />
	<br />
	<div>
		Locations:
		<asp:DropDownList ID="ddlLocations" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlLocations_SelectedIndexChanged" />
	</div>
	<br />
	<mobot:ErrorControl runat="server" id="errorControl">
	</mobot:ErrorControl>
	<br />
	<div class="box" style="padding: 5px; margin-right: 400px">
		<table cellpadding="4" width="75%">
			<tr>
				<td style="white-space: nowrap" align="right">
					Name:
				</td>
				<td width="100%">
				    <asp:Literal ID="nameLiteral" runat="server"></asp:Literal>
					<asp:HiddenField ID="hidCode" runat="server" />
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Latitude:
				</td>
				<td>
					<asp:TextBox ID="latitudeTextBox" runat="server" Width="200px" MaxLength="20"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Longitude:
				</td>
				<td>
					<asp:TextBox ID="longitudeTextBox" runat="server" MaxLength="20" Width="200px"></asp:TextBox>
				</td>
			</tr>
			<tr>
			    <td></td>
			    <td>
			        <a href="#" onclick="openMap()">View On Map</a>
			    </td></tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Next Attempt Date:
				</td>
				<td>
				    <asp:Literal ID="nextAttemptLiteral" runat="server"></asp:Literal>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right">
					Show On Web Site:
				</td>
				<td>
				    <asp:CheckBox ID="includeInUICheckbox" runat="server" />
				</td>
			</tr>
		</table>
		<br />
		<div id="divAltLocations" runat=server visible=false>
		<span id="spanAltLocations">
		<a href="#" onclick="getLocationAlternatives('<%= ddlLocations.SelectedValue %>')">Click here to get alternate Lat/Long pairs for <%= ddlLocations.SelectedValue %></a><br />Alternate Lat/Long pairs supplied by <a href="http://www.geonames.org" target="_blank">GeoNames</a>.<br />
		</span>
		</div>
		<br />
		<asp:Button ID="saveButton" runat="server" OnClick="saveButton_Click" Text="Save" />
		<input type="reset" value="Reset" />
		<asp:Button ID="clearButton" runat="server" Text="Clear" OnClick="clearButton_Click" />
	</div>
	<script language="javascript">
	function openMap()
	{
        var latTextBox = document.getElementById('<%= latitudeTextBox.ClientID %>');
        var lngTextBox = document.getElementById('<%= longitudeTextBox.ClientID %>');
        var googleKey = document.getElementById('hidGoogleKey');
        window.open('/LocationMap.aspx?lat=' + latTextBox.value + '&lng=' + lngTextBox.value, 'LocationMap', 'left=20,top=20,width=425,height=335');
	}
	
	function getLocationAlternatives(locationName)
	{
        executeServiceCall("/services/pagesummaryservice.ashx?op=GetAlternateLocations&locationName=" + locationName, updateUI);
	}

    function updateUI(locations)
    {
	    var span = document.getElementById("spanAltLocations");
	    
	    if (locations.geonames.length > 0)
	    {
	        span.innerHTML = "Click a location in the following list to select the associated Lat/Long:<br>";
	        for(var x = 0; x < locations.geonames.length; x++)
	        {
	            var newLink = document.createElement("a");
	            var href = document.createAttribute("href");
	            newLink.setAttribute("href", "#");
	            newLink.onclick = Function("setLatLong(" + locations.geonames[x].lat + "," + locations.geonames[x].lng + ")");
	            
	            var linkText = locations.geonames[x].name;
	            if (locations.geonames[x].adminName1 != "") linkText += ", " + locations.geonames[x].adminName1;
	            linkText += ", " + locations.geonames[x].countryName;
	            linkText += " (" + locations.geonames[x].fclName + ")";

	            newLink.appendChild(document.createTextNode(linkText));
	            span.appendChild(newLink);
	            var newBreak = document.createElement("br");
	            span.appendChild(newBreak);
    	    }
	    }
	    else
	    {
	        span.innerHTML = "No alternatives found.";
	    }
    }
    
    function updateUIWithError()
    {
	    var span = document.getElementById("spanAltLocations");
        span.innerHTML = "Error retrieving data from <a href='http://www.geonames.org' target='_blank'>GeoNames</a>.";
    }
    
    function setLatLong(lat, lng)
    {
        var latTextBox = document.getElementById('<%= latitudeTextBox.ClientID %>');
        latTextBox.value = lat;
        var lngTextBox = document.getElementById('<%= longitudeTextBox.ClientID %>');
        lngTextBox.value = lng;
    }
    	
    function executeServiceCall(url, callback)
    {
        var request = createXMLHttpRequest();
        request.open("GET", url, true);
        request.onreadystatechange = function() {
            if (request.readyState == 4)
            {
                if (request.status == 200) {
                    var result;
                    try {result = eval('(' + request.responseText + ')'); 
                    }
                    catch (err) { updateUIWithError(); }
                        
                    callback(result);
                }
                else
                {
                    updateUIWithError();
                }
            }
        }
        request.send(null);
    }

    function createXMLHttpRequest() {
        if (typeof XMLHttpRequest != "undefined") {
            return new XMLHttpRequest();
        } else if (typeof ActiveXObject != "undefined") {
            return new ActiveXObject("Microsoft.XMLHTTP");
        } else {
            throw new Error("XMLHttpRequest not supported");
        }
    }
	
	</script>
</asp:Content>
