<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShowOnMap.aspx.vb" Inherits="Dynamicweb.Admin.Maps.ShowOnMap" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="<%= Dynamicweb.Environment.ExecutingContext.GetCulture() %>">
<head runat="server">
    <title><%=Translate.Translate("Maps")%></title>
    <style type="text/css">
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        #info {
            position: fixed;
            background: white;
            border: solid 1px #aaa;
            z-index: 100;
            width: 50%;
            left: 25%;
            padding: .25em .5em;
        }

        #infoWindowContent .latlng {
            font-size: 75%;
        }
    </style>
</head>
<body>
    <div id="info">
        <dw:TranslateLabel runat="server" Text="Drag marker to change location." />
        <button type="button" id="btnSaveLocation" style="visibility: hidden">
            <dw:TranslateLabel runat="server" Text="Save location" />
        </button>
    </div>
    <div id="infoWindowContent" style="display: none">
        <div class="name"><%= GetQueryValue("Name") %></div>
        <% If Not GetQueryValue("Address") Is Nothing Then %>
        <div class="adr">
            <div class="street-address"><%= GetQueryValue("Address") %></div>
            <div class="extended-address"><%= GetQueryValue("Address2") %></div>
            <span class="locality"><%= GetQueryValue("City") %></span>,
				<span class="postal-code"><%= GetQueryValue("Zip") %></span>
            <div class="country-name"><%= GetQueryValue("Country") %></div>
        </div>
        <% End If %>
        <div class="latlng">
            <dw:TranslateLabel runat="server" Text="Location" />
            : (<span id="lat">0</span>, <span id="lng">0</span>)
        </div>
    </div>
    <div id="map" style="width: 100%; height: 100%"></div>
    <script src='//maps.googleapis.com/maps/api/js?key=<%= GoogleMapsAPIKey %>&amp;sensor=false'></script>
    <script type='text/javascript'>/*<![CDATA[*/google.maps.event.addDomListener(window, 'load', function() {
		var debug = function() {
			if ((typeof(console) != 'undefined') && (typeof(console.debug) == 'function')) {
				;;; console.debug.apply(console, arguments);
			}
		},

		btnSaveLocation,
		location = new google.maps.LatLng(<%= GetQueryValue("lat") %>, <%= GetQueryValue("lng") %>),
		map = new google.maps.Map(document.getElementById('map'), {
			center: location,
			zoom: <%= GetQueryValue("zoom") %>,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		}),
		marker = new google.maps.Marker({
			draggable: <%= If(True Or Request.QueryString("editable") = "true", "true", "false") %>,
			position: location,
			map: map,
			title: '<%= Request.QueryString("title") %>'
		}),
		infoWindow = new google.maps.InfoWindow({
			content: document.getElementById('infoWindowContent')
		}),

		showLocation = function(location) {
			document.getElementById('lat').innerHTML = location.lat().toFixed(6);
			document.getElementById('lng').innerHTML = location.lng().toFixed(6);
		}

		google.maps.event.addListener(marker, 'click', function() {
			infoWindow.open(map, marker);
		});

		google.maps.event.addListener(marker, 'position_changed', function() {
			var location = this.getPosition();
			showLocation(location);
		});

		google.maps.event.addListener(marker, 'dragstart', function() {
			btnSaveLocation.style.visibility = 'hidden';
		});

		google.maps.event.addListener(marker, 'dragend', function() {
			var location = this.getPosition();
			map.panTo(location);
			if (opener && opener.setGeoLocation) {
				btnSaveLocation.style.visibility = 'visible';
			}
		});

		google.maps.event.addListener(map, 'zoom_changed', function() {
			if (opener && opener.setGeoLocation) {
				btnSaveLocation.style.visibility = 'visible';
			}
		});

		document.getElementById('infoWindowContent').style.display = 'block';
		infoWindow.open(map, marker);
		btnSaveLocation = document.getElementById('btnSaveLocation');

		google.maps.event.addDomListener(btnSaveLocation, 'click', function() {
			var location = marker.getPosition();
			if (opener && opener.setGeoLocation) {
				opener.setGeoLocation({
					lat: location.lat(),
					lng: location.lng(),
					zoom: map.getZoom()
				});
				close();
			}
		});

		showLocation(marker.getPosition());

	});/*]]>*/</script>
    <% Translate.GetEditOnlineScript() %>
</body>
</html>
