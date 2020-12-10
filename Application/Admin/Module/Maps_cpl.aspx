<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="Maps_cpl.aspx.vb" Inherits="Dynamicweb.Admin.Maps.Maps_cpl" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    function selectAllGroups() {
	        jQuery('#GroupIDsContainer').find('li').addClass('selected');
	    }

	    function toggleSelectedGroups() {
	        jQuery('#GroupIDsContainer').find('li').removeClass('selected');
	    }

	    (function () {
	        var selectedGroupsChanged = function () {
	            Form.Element.disable('btnUpdateGeoLocations');
	            $$('#GroupIDs option').each(function (option) {
	                if (option.selected) {
	                    Form.Element.enable('btnUpdateGeoLocations');
	                }
	            });
	        },

            selectAllGroups = function () {
                $$('#GroupIDs option').each(function (option) {
                    option.selected = true;
                });
                selectedGroupsChanged();
            },

            toggleSelectedGroups = function () {
                $$('#GroupIDs option').each(function (option) {
                    option.selected = false;
                });
                selectedGroupsChanged();
            },

		    onSubmitUpdate = function () {
		        document.getElementById('MainForm').action = "";
		    };

	        Event.observe(window, 'load', function () {
	            $('btnSelectAllGroups').observe('click', selectAllGroups);
	            $('btnToggleSelectedGroups').observe('click', toggleSelectedGroups);
	            $('btnUpdateGeoLocations').observe('click', onSubmitUpdate);
				$('GroupIDs').observe('change', selectedGroupsChanged);
				selectedGroupsChanged();

				var page = SettingsPage.getInstance();
				page.onSave = function () {
				        document.getElementById('MainForm').submit();
				    }
			});
		}());

	</script>
    <style>
        #GroupIDs{
            height:150px !important;
        }
    </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>            
            <li><a href="#">Control panel</a></li>
            <li class="active">Store Locator</li>
        </ol>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Maps" />

        <dwc:CardBody runat="server">
	        <dwc:GroupBox ID="Settings" runat="server" Title="Settings" DoTranslation="true">
                <dwc:InputText runat="server" id="GoogleMapsAPIKey" Name="/Globalsettings/Settings/GoogleMaps/GoogleMapsAPIKey" label="Google Maps API key" />
                <dwc:InputText runat="server" id="GoogleMapsClientID" Name="/Globalsettings/Settings/GoogleMaps/GoogleMapsClientID" label="Google Maps Client ID" />
	        </dwc:GroupBox>
	        <dwc:GroupBox ID="BatchUpdate" runat="server" Title="Batch update" DoTranslation="true">
                <div id="GroupIDsContainer">
                    <dwc:SelectPicker ID="GroupIDs" Name="GroupIDs" Label="Groups" runat="server" ClientIDMode="Static" Multiple="true" Height="100%" />
                </div>
		        
                <div class="form-inline">
                    <dwc:Button ID="btnSelectAllGroups" Name="btnSelectAllGroups" ActionType="button" Title="Select all" runat="server" />
                    <dwc:Button ID="btnToggleSelectedGroups" Title="Deselect all" runat="server" />
                    <dwc:Button ID="btnUpdateGeoLocations" Name="Action" runat="server" ActionType="submit" Title="Update" Value="Update" />
		        </div>

		        <dw:List ID="LocationsList" runat="server" Title="Locations" ShowPaging="false" Visible="false">
		        </dw:List>
	        </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
<% Translate.GetEditOnlineScript() %>
</asp:Content>
