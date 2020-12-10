<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Maps_edit.aspx.vb" Inherits="Dynamicweb.Admin.Maps_edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<dw:ModuleSettings ID="ModuleSettings" runat="server" ModuleSystemName="Maps" Value="LocationGroupshidden, LocationGroupsUseSubgroups, LocationSmartSearchhidden, LocationUsershidden, MapZoomLevel, MapType, MapWidth, MapHeight, MapCenterLat, MapCenterLng, MarkerShowInfoWindowAction, MarkerImage, ClustererEnabled, ClustererGridSize, ClustererClusterSmallImage, ClustererClusterSmallTextColor, ClustererClusterSmallTextSize, ClustererClusterMediumImage, ClustererClusterMediumTextColor, ClustererClusterMediumTextSize, ClustererClusterLargeImage, ClustererClusterLargeTextColor, ClustererClusterLargeTextSize, ListPosition, ListShowInfoWindowAction, ListShowInfoWindowZoom, TemplateFilename, JavascriptFilename, GoogleMapsAPIKey, GoogleMapsClientID, DisableInitScript, DisableGoogleApi" />
<dw:ModuleHeader ID="ModuleHeader" runat="server" ModuleSystemName="Maps" />

<dw:GroupBox ID="Groups" runat="server" Title="Groups" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="LocationGroups" />
            </td>
            <td>
                <dw:UserSelector runat="server" ID="LocationGroups" show="Groups">
                </dw:UserSelector>
            </td>
        </tr>
        <tr>
            <td />
            <td>
                <dw:Checkbox ID="LocationGroupsUseSubgroups" runat="server" />
            </td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox ID="Users" runat="server" Title="Users" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Users" />
            </td>
            <td>
                <dw:UserSelector runat="server" ID="LocationUsers">
                </dw:UserSelector>
            </td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox ID="SmartSearches" runat="server" Title="Smart search" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Smart search" />
            </td>
            <td>
                <dw:UserSelector runat="server" ID="LocationSmartSearch" show="SmartSearches">
                </dw:UserSelector>
            </td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox ID="MapSettings" runat="server" Title="Map Settings" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Map size" />
                (<dw:TranslateLabel runat="server" Text="Width" />)
            </td>
            <td>
                <input type="text" id="MapWidth" size="8" runat="server" class="std length" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Map size" />
                (<dw:TranslateLabel runat="server" Text="Height" />)
            </td>
            <td>
                <input type="text" id="MapHeight" size="8" runat="server" class="std length" />
            </td>
        </tr>
        <tr>
            <td>
                <label for="MapType">
                    <dw:TranslateLabel runat="server" Text="Map type" />
                </label>
            </td>
            <td>
                <select id="MapType" runat="server" class="std">
                    <option value="ROADMAP">Roadmap</option>
                    <option value="SATELLITE">Satellite</option>
                    <option value="HYBRID">Hybrid</option>
                    <option value="TERRAIN">Terrain</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>
                <label for="MapZoomLevel">
                    <dw:TranslateLabel runat="server" Text="Zoom level" />
                </label>
            </td>
            <td>
                <select id="MapZoomLevel" runat="server" class="std">
                    <option value="0">0</option>
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                    <option value="13">13</option>
                    <option value="14">14</option>
                    <option value="15">15</option>
                    <option value="16">16</option>
                    <option value="17">17</option>
                    <option value="18">18</option>
                    <option value="19">19</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Map center" />
                (<dw:TranslateLabel runat="server" Text="Lat" />)
            </td>
            <td>
                <input type="text" id="MapCenterLat" size="8" runat="server" class="std number" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Map center" />
                (<dw:TranslateLabel runat="server" Text="Lng" />)
            </td>
            <td>
                <input type="text" id="MapCenterLng" size="8" runat="server" class="std number" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <button type="button" id="GeoLocationShowOnMap">
                    <dw:TranslateLabel runat="server" Text="Show location on map" />
                </button>
            </td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox ID="MarkerSettings" runat="server" Title="Marker Settings" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Activation" />
            </td>
            <td>
                <select id="MarkerShowInfoWindowAction" runat="server" class="std">
                    <option value="click">Click</option>
                    <option value="dblclick">Double click</option>
                    <option value="mouseover">Mouse over</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>
                <label for="MarkerImage">
                    <dw:TranslateLabel runat="server" Text="Marker Image" />
                </label>
            </td>
            <td>
                <dw:FileManager id="MarkerImage" runat="server" Extensions="jpg,png,gif,svg,gif,svg" FullPath="true" AllowBrowse="True" />
            </td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox ID="ClustererSettings" runat="server" Title="Clusterer Settings" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td />
            <td>
                <label>
                    <dw:Checkbox ID="ClustererEnabled" value="true" runat="server" />
                </label>
            </td>
        </tr>
    </table>
    <table id="ClustererSettingsUI" class="formsTable">
        <% If False Then%>
        <tr>
            <td>
                <label for="ClustererGridSize">
                    <dw:TranslateLabel runat="server" Text="Clusterer Grid Size" />
                </label>
            </td>
            <td>
                <input type="text" id="ClustererGridSize" size="60" runat="server" class="std" />
            </td>
        </tr>
        <% End If%>
        <tr>
            <td>
                <label for="ClustererClusterSmallImage">
                    <dw:TranslateLabel runat="server" Text="Small Cluster Image" />
                </label>
            </td>
            <td>
                <dw:FileManager id="ClustererClusterSmallImage" runat="server" Extensions="jpg,png,gif,svg" FullPath="true" AllowBrowse="True" />
            </td>
        </tr>
        <tr>
            <td>
                <label for="ClustererClusterSmallTextColor">
                    <dw:TranslateLabel runat="server" Text="Small Cluster Text Color" />
                </label>
            </td>
            <td>
                <input type="text" id="ClustererClusterSmallTextColor" size="60" runat="server" class="std" />
            </td>
        </tr>
        <tr>
            <td>
                <label for="ClustererClusterSmallTextSize">
                    <dw:TranslateLabel runat="server" Text="Small Cluster Text Size" />
                </label>
            </td>
            <td>
                <input type="text" id="ClustererClusterSmallTextSize" size="60" runat="server" class="std" />
            </td>
        </tr>
        <tr>
            <td>
                <label for="ClustererClusterMediumImage">
                    <dw:TranslateLabel runat="server" Text="Medium Cluster Image" />
                </label>
            </td>
            <td>
                <dw:FileManager id="ClustererClusterMediumImage" runat="server" Extensions="jpg,png,gif,svg" FullPath="true" AllowBrowse="True" />
            </td>
        </tr>
        <tr>
            <td>
                <label for="ClustererClusterMediumTextColor">
                    <dw:TranslateLabel runat="server" Text="Medium Cluster Text Color" />
                </label>
            </td>
            <td>
                <input type="text" id="ClustererClusterMediumTextColor" size="60" runat="server" class="std" />
            </td>
        </tr>
        <tr>
            <td>
                <label for="ClustererClusterMediumTextSize">
                    <dw:TranslateLabel runat="server" Text="Medium Cluster Text Size" />
                </label>
            </td>
            <td>
                <input type="text" id="ClustererClusterMediumTextSize" size="60" runat="server" class="std" />
            </td>
        </tr>
        <tr>
            <td>
                <label for="ClustererClusterLargeImage">
                    <dw:TranslateLabel runat="server" Text="Large Cluster Image" />
                </label>
            </td>
            <td>
                <dw:FileManager id="ClustererClusterLargeImage" runat="server" Extensions="jpg,png,gif,svg" FullPath="true" AllowBrowse="True" />
            </td>
        </tr>
        <tr>
            <td>
                <label for="ClustererClusterLargeTextColor">
                    <dw:TranslateLabel runat="server" Text="Large Cluster Text Color" />
                </label>
            </td>
            <td>
                <input type="text" id="ClustererClusterLargeTextColor" size="60" runat="server" class="std" />
            </td>
        </tr>
        <tr>
            <td>
                <label for="ClustererClusterLargeTextSize">
                    <dw:TranslateLabel runat="server" Text="Large Cluster Text Size" />
                </label>
            </td>
            <td>
                <input type="text" id="ClustererClusterLargeTextSize" size="60" runat="server" class="std" />
            </td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox ID="LocationListSettings" runat="server" Title="Location List Settings" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <label for="ListPosition">
                    <dw:TranslateLabel runat="server" Text="List position" />
                </label>
            </td>
            <td>
                <select id="ListPosition" runat="server" class="std">
                    <option value="">Hidden</option>
                    <option value="left">Left</option>
                    <option value="right">Right</option>
                    <option value="below">Below</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Show Info Window Action" />
            </td>
            <td>
                <select id="ListShowInfoWindowAction" runat="server" class="std">
                    <option value=""></option>
                    <option value="click">Click</option>
                    <option value="dblclick">Double click</option>
                    <option value="mouseover">Mouse over</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Show Info Window Zoom Level" />
            </td>
            <td>
                <select id="ListShowInfoWindowZoom" runat="server" class="std">
                    <option value="0">0</option>
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                    <option value="13">13</option>
                    <option value="14">14</option>
                    <option value="15">15</option>
                    <option value="16">16</option>
                    <option value="17">17</option>
                    <option value="18">18</option>
                    <option value="19">19</option>
                </select>
            </td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox ID="TemplateSettings" runat="server" Title="Template" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Template" />
            </td>
            <td>
                <dw:FileManager runat="server" id="TemplateFilename" Extensions="html,cshtml" Folder="Templates/Maps/templates/" FullPath="True" />
            </td>
        </tr>
        <% If False Then%>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Javascript" />
            </td>
            <td>
                <dw:FileManager runat="server" id="JavascriptFilename" Extensions="js" Folder="Templates/Maps/javascripts/" FullPath="True" AllowBrowse="True" />
            </td>
        </tr>
        <% End If%>
    </table>
</dw:GroupBox>
<dw:GroupBox runat="server" ID="GoogleMapsAPISettings" Title="Google Maps API Settings" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Google Maps API Key" />
            </td>
            <td>
                <input type="text" id="GoogleMapsAPIKey" size="60" runat="server" class="std" />
                <% If Not String.IsNullOrEmpty(DefaultGoogleMapsAPIKey) Then%>
                <br />
                <span class="default-value">(<dw:TranslateLabel runat="server" Text="Default value" />:
					<%= DefaultGoogleMapsAPIKey %>)</span>
                <% End If%>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Google Maps Client ID" />
            </td>
            <td>
                <input type="text" id="GoogleMapsClientID" size="60" runat="server" class="std" />
                <% If Not String.IsNullOrEmpty(DefaultGoogleMapsClientID) Then%>
                <br />
                <span class="default-value">(<dw:TranslateLabel runat="server" Text="Default value" />:
					<%= DefaultGoogleMapsClientID %>)</span>
                <% End If%>
            </td>
        </tr>
    </table>
</dw:GroupBox>
<dw:GroupBox runat="server" ID="APISettings" Title="API Settings" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td />
            <td>
                <label>
                    <dw:Checkbox ID="DisableInitScript" value="true" runat="server" />
                </label>
            </td>
        </tr>
        <tr>
            <td />
            <td>
                <label>
                    <dw:Checkbox ID="DisableGoogleApi" value="true" runat="server" />
                </label>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<script type="text/javascript">/*<![CDATA[*/function ModuleMap() {
    var numberFormat = {
        numberGroupSeparator: '<%= StringHelper.JSEnable(CurrentCulture.NumberFormat.NumberGroupSeparator) %>',
        numberDecimalSeparator: '<%= StringHelper.JSEnable(CurrentCulture.NumberFormat.NumberDecimalSeparator) %>'
    },

	parseDouble = function (value) {
	    var d = parseFloat(value);
	    return isNaN(d) ? 0 : d;
	},

	formatDouble = function (value) {
	    var formatted = value.toFixed(6);

	    // Paragraph settings are not (yet) locale aware
	    formatted = formatted
		// Replace point with localized decimal separator
			.replace('.', numberFormat.numberDecimalSeparator);

	    return formatted;
	},

	getDouble = function (value) {
	    value = value
		// Remove all group separators
			.replace(numberFormat.numberGroupSeparator, '')
		// Replace decimal separator with point
			.replace(numberFormat.numberDecimalSeparator, '.');

	    return parseDouble(value);
	},

	showLocationOnMap = function () {
	    var name, value,
		fieldMap = {
		    'lat': 'MapCenterLat',
		    'lng': 'MapCenterLng',
		    'zoom': 'MapZoomLevel'
		},
		url = '/Admin/Module/Maps/ShowOnMap.aspx?action=show';

	    for (name in fieldMap) if (fieldMap.hasOwnProperty(name)) {
	        if ($(fieldMap[name])) {
	            value = Form.Element.getValue(fieldMap[name]);
	            if ((name == 'lat') || (name == 'lng')) {
	                value = getDouble(value);
	            }
	            url += '&' + name + '=' + encodeURIComponent(value);
	        }
	    }
	    url += '&Name=' + encodeURIComponent('<dw:TranslateLabel runat="server" Text="Map center" />');
	    url += '&editable=true';

	    (function () {
	        var width = screen.width / 2,
			height = screen.height / 2,
			left = screen.width / 4,
			top = screen.height / 4;

	        open(url, 'geolocation', 'left=' + left +
			 ", top=" + top +
			 ", screenX=" + left +
			 ", screenY=" + top +
			 ", width=" + width +
			 ", height=" + height +
			 ", resizable=yes" +
			 ", scrollbars=yes");
	    }());
	},

	setGeoLocation = function (info, fromAPI) {
	    var lat = parseDouble(info.lat),
		lng = parseDouble(info.lng),
		zoom;
	    Form.Element.setValue('MapCenterLat', formatDouble(lat));
	    Form.Element.setValue('MapCenterLng', formatDouble(lng));

	    if (typeof info.zoom != 'undefined') {
	        zoom = parseInt(info.zoom);
	        if (!isNaN(zoom)) {
	            Form.Element.setValue('MapZoomLevel', zoom);
	        }
	    }
	},

	showClustererSettings = function () {
	    var enabled = $('ClustererEnabled').checked;
	    if (enabled) {
	        $('ClustererSettingsUI').show();
	    } else {
	        $('ClustererSettingsUI').hide();
	    }
	},

	setFileOption = function (dropDownName, optionName) {
	    var pathName = '/Files/' + optionName;

	    var dropDown = document.getElementById('FM_' + dropDownName);
	    dropDown.options.length++;
	    var option = dropDown.options[dropDown.options.length - 1];
	    option.value = optionName;
	    option.text = optionName;
	    option.setAttribute('fullPath', pathName);
	    dropDown.selectedIndex = dropDown.options.length - 1;

	    document.getElementById(dropDownName + '_path').value = pathName;
	}

    // Expose for use in popup
    window.setGeoLocation = setGeoLocation;

    document.observe('dom:loaded', function () {
        $('GeoLocationShowOnMap').observe('click', showLocationOnMap);
        $('ClustererEnabled').observe('change', showClustererSettings);
        showClustererSettings();

		<% If Not String.IsNullOrEmpty(DefaultModuleStyleSheet) Then%>
        setFileOption('ParagraphModuleCSS', '<%= StringHelper.JSEnable(DefaultModuleStyleSheet) %>');
        <% End If%>
		<% If Not String.IsNullOrEmpty(DefaultModuleJavaScript) Then%>
        setFileOption('ParagraphModuleJS', '<%= StringHelper.JSEnable(DefaultModuleJavaScript) %>');
		<% End If%>
    });
};
    var moduleMap = new ModuleMap();
    /*]]>*/</script>
