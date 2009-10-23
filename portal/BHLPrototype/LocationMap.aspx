<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LocationMap.aspx.cs" Inherits="MOBOT.BHL.Web.LocationMap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>BHL Location Map</title>
    <script src="/scripts/querystring.js" type="text/javascript"></script>
    <asp:Literal ID="mapsScriptTag" runat="server" />
    <script type="text/javascript">
    
    function initialize() {
      if (GBrowserIsCompatible()) {
        // read the lat and long from the querystring
        var qs = new Querystring();
        var lat = qs.get("lat", 0);
        var lng = qs.get("lng", 0);

        // show the location on the map
        var map = new GMap2(document.getElementById("map_canvas"));
        map.addControl(new GSmallMapControl()); // pan, zoom
        map.setCenter(new GLatLng(lat, lng), 3);
        var latlng = new GLatLng(lat, lng);
        map.addOverlay(new GMarker(latlng));
      }
    }

    </script>
</head>
<body onload="initialize()" onunload="GUnload()">
    <form id="form1" runat="server">
    <div id="map_canvas" style="width: 400px; height: 300px"></div>
    <div style="text-align:center"><a href="javascript:window.close();">Close Window</a></div>
    </form>
</body>
</html>
