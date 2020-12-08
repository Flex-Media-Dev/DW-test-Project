<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="LicenseInformation.aspx.vb" Inherits="Dynamicweb.Admin.LicenseInformation" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Configuration" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();

function insertParam(key, value)
{
    key = encodeURI(key); value = encodeURI(value);

    var kvp = document.location.search.substr(1).split('&');

    var i=kvp.length; var x; while(i--) 
    {
        x = kvp[i].split('=');

        if (x[0]==key)
        {
            x[1] = value;
            kvp[i] = x.join('=');
            break;
        }
    }

    if(i<0) {kvp[kvp.length] = [key,value].join('=');}

    //this will reload the page, it's likely better to store this until finished
    document.location.search = kvp.join('&'); 
}      

        function doUpdate() {
            var loader = new overlay("__ribbonOverlay");
            loader.show();
            document.forms[0].action = document.location.toString();
            document.forms[0].submit();
        };
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <br />
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>
            <li><a href="#">System</a></li>
            <li class="active"><%= Translate.Translate("System information") %></li>
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
        <dwc:CardHeader runat="server" Title="License information" />
        <dwc:CardBody runat="server">
            <dwc:GroupBox runat="server" ID="groupbox12" Title="General">
                <asp:Literal ID="licenseGroup" runat="server" />
                <dwc:Button ID="RefreshLicenseBtn" runat="server" ClientIDMode="Static" Title="Refresh License" />
                <dwc:Button ID="InstallLicenseBtn" runat="server" ClientIDMode="Static" Title="Install License" />
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" ID="groupbox1" Title="Features">
                <asp:Literal ID="featureGroup" runat="server" />
            </dwc:GroupBox>
            <% Translate.GetEditOnlineScript()%>
        </dwc:CardBody>
    </dwc:Card>
    <script type="text/javascript">
(function(){
    var refreshButton = document.getElementById("RefreshLicenseBtn");
        refreshButton.onclick = function(){
                insertParam("RefreshLicense", "true");
    };
    var installButton = document.getElementById("InstallLicenseBtn");
    installButton.onclick = function () {
        insertParam("InstallLicense", "true");
    };
})();
    </script>
</asp:Content>
