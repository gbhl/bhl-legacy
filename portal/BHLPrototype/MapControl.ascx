<%@ Control Language="C#" AutoEventWireup="true" Codebehind="MapControl.ascx.cs"
  Inherits="MOBOT.BHL.Web.MapControl" %>
<asp:Literal ID="mapsScriptTag" runat="server" />
<div id="browseInnerDiv" style="height: 100%; overflow: auto;">
  <div id="map" style="height: 94%; width: 100%;">
  </div>
  <div style="text-align:center;">
  <input type="checkbox" id="chk10" onclick="onChecked(this, 1);" />
  <img src="/images/map_pin_blue.png" /> 1-10 titles&nbsp;&nbsp;&nbsp;&nbsp;
  <input type="checkbox" id="chk20" checked onclick="onChecked(this, 2);" />
  <img src="/images/map_pin_green.png" /> 11-20 titles&nbsp;&nbsp;&nbsp;&nbsp;
  <input type="checkbox" id="chk30" checked onclick="onChecked(this, 3);" />
  <img src="/images/map_pin_yellow.png" /> 21-30 titles&nbsp;&nbsp;&nbsp;&nbsp;
  <input type="checkbox" id="chk40" checked onclick="onChecked(this, 4);" />
  <img src="/images/map_pin_orange.png" /> 31-40 titles&nbsp;&nbsp;&nbsp;&nbsp;
  <input type="checkbox" id="chk50" checked onclick="onChecked(this, 5);" />
  <img src="/images/map_pin_red.png" /> 41 or more titles
  </div>
</div>

<script type="text/javascript">
    var startZoom = 2;
    var map;
    var geocoder = new GClientGeocoder();
    var locations = "<%= locations %>";
    var institutionCode = "<%= institutionCode %>";
    var languageCode = "<%= languageCode %>";
    var startLatitude = 0;
    var startLongitude = 0;
    var selectedMarker;
    var markers = [];

    function initMap()
    {
        if (GBrowserIsCompatible()) {
        
            var startZoomCookie = getCookie("BotanicusMapStartZoomLevel");
            var startLatCookie = getCookie("BotanicusMapStartLatitude");
            var startLngCookie = getCookie("BotanicusMapStartLongitude");
            
            //check cookie to see if user has previously set a preferred zoom level
            if(startZoomCookie != null && startZoomCookie != "" && !isNaN(startZoomCookie))
            {
                startZoom = parseInt(startZoomCookie);
            }
            
            if(startLatCookie != null && startLatCookie != "" && !isNaN(startLatCookie))
            {
                startLatitude = startLatCookie + 0;
            }
            
            if(startLngCookie != null && startLngCookie != "" && !isNaN(startLngCookie))
            {
                startLongitude = startLngCookie + 0;
            }
           
            map = new GMap2(document.getElementById("map"));
            map.addControl(new GLargeMapControl()); // pan, zoom
		    map.addControl(new GMapTypeControl()); // map, satellite, hybrid

            map.setCenter(new GLatLng(startLatitude, startLongitude), startZoom);
            addMarkers();
            updateView(true, 2);
            updateView(true, 3);
            updateView(true, 4);
            updateView(true, 5);
          }
    }
    
    function onChecked(checkbox, category)
    {
        updateView(checkbox.checked, category);
    }
    
    function updateView(showCategory, category)
    {
        for (i=0;i<markers.length;i++) {
            if (markers[i].bhlCategory == category) {
                showCategory ? markers[i].show() : markers[i].hide();
            }
        }
    }
    
    function getMarker(latitude, longitude, tagText, numberOfTitles)
    {
        var pinImage;
        var category;
        switch((numberOfTitles/10)|0){
            case 0:{pinImage="/images/map_pin_blue.png";category=1;break;}
            case 1:{pinImage="/images/map_pin_green.png";category=2;break;}
            case 2:{pinImage="/images/map_pin_yellow.png";category=3;break;}
            case 3:{pinImage="/images/map_pin_orange.png";category=4;break;}
            default:{pinImage="/images/map_pin_red.png";category=5;break;}
        }
        
        var mapIcon = new GIcon(G_DEFAULT_ICON);
        mapIcon.iconSize = new GSize(12, 20);
        mapIcon.shadowSize = new GSize(22, 20);
        mapIcon.iconAnchor = new GPoint(5, 20);
        mapIcon.image = pinImage;
        markerOptions = { icon:mapIcon };
     
        var titleLabel = numberOfTitles + " title";
        if (numberOfTitles > 1) titleLabel += "s";
        
        var marker = new GMarker(new GLatLng(latitude, longitude),mapIcon);
        marker.bhlCategory = category;
        marker.tagText = tagText;
        marker.titleLabel = titleLabel;
        GEvent.addListener(marker, 'click',
		    function() {
		        var currentCenter = getCurrentCenter();
		        setCookie("BotanicusMapStartLatitude", currentCenter[0]);
		        setCookie("BotanicusMapStartLongitude", currentCenter[1]);
		        setCookie("BotanicusMapStartZoomLevel", map.getZoom());
                getTitles(marker);
		    }
	    );
	    
        markers.push(marker);
	    return marker;
    }
    
    function addMarkers()
    {
        if(locations != "")
        {
            var locationsArray = locations.split(";");
                       
            for(var i = 0; i < locationsArray.length; i++)
            {
                var locationArray = locationsArray[i].split(",");
                var marker = getMarker(locationArray[0], locationArray[1], locationArray[2], locationArray[3]);
                map.addOverlay(marker);
                marker.hide();
            }
        }
    }
    
    function getTitles(marker)
    {
        selectedMarker = marker;
        executeServiceCall("/services/pagesummaryservice.ashx?op=TitleSelectByTagTextInstitutionAndLanguage&tagText=" + marker.tagText + "&instCode=" + institutionCode + "&langCode=" + languageCode, showText);
    }
    
    function showText(result)
    {
        var titles = eval(result);
        var displayText = "<b>" + selectedMarker.tagText + "</b> (" + selectedMarker.titleLabel + ") <a href='/BrowseByTitleTag.aspx?tagText=" + selectedMarker.tagText + "'>Full Details</a><br>" +
            "<table height=150px cellspacing=0 cellpadding=0><tr><td><div style='height:150px;overflow: auto;'><ol>";
        for (var i = 0; i < titles.length; i++) displayText = displayText + "<li><a href='/bibliography/" + titles[i].TitleID + "'>" + titles[i].ShortTitle + "</a></li>";
        displayText = displayText + "</ol></td></tr></table></div>";
        selectedMarker.openInfoWindowHtml(displayText, {maxWidth:400});
    }
    
function setCookie(name, value) {
	document.cookie = name + "=" + value;
}

function getCookie(name) {
	var pos = document.cookie.indexOf(name + "=");
	if (pos == -1) {
		return null;
	} 	
	else {
		var pos2 = document.cookie.indexOf(";", pos);
		if (pos2 == -1) {
			return unescape(document.cookie.substring(pos + name.length + 1));
		}	
		else {
	
			return unescape(document.cookie.substring(pos + name.length + 1, pos2));
		}
	}
}

function getCurrentCenter(){
    var centerRaw = map.getCenter() + "";
    //strip beginning and ending parentheses
    centerRaw = centerRaw.substring(1);
    centerRaw = centerRaw.substring(0, centerRaw.length - 1);
    return(centerRaw.split(","));
}

function executeServiceCall(url, callback)
{
    var request = createXMLHttpRequest();
    request.open("GET", url, true);
    request.onreadystatechange = function() {
        if (request.readyState == 4)
        {
            if (request.status == 200) {
                var result = eval('(' + request.responseText + ')');
                callback(result);
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

