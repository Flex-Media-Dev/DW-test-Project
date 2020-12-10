<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="Tracking_cpl.aspx.vb" Inherits="Dynamicweb.Admin.TrackingControlPanel" %>

<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () {
            document.getElementById('DisableStatistics').value = document.getElementById('StatisticsEnabled').checked ? 'False' : 'True';
            page.submit();
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>
            <li><a href="#">Web and HTTP</a></li>
            <li class="active"><%= Translate.Translate("Tracking") %></li>
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
        <dwc:CardHeader runat="server" Title="Tracking"></dwc:CardHeader>
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="SettingsGroupBox" Title="Statistics" runat="server">
                <input type="hidden" id="DisableStatistics" name="/Globalsettings/Modules/Statistics/DisableStatistics" />
                <dwc:CheckBox runat="server" ID="StatisticsEnabled" Label="Enable statistics" Info="Deprecated. Uses old tracking functionality and stores data in StatV2 tables." />
            </dwc:GroupBox>
            <dwc:GroupBox ID="TrackingGroupbox" Title="Tracking" runat="server">
                <dwc:CheckBox runat="server" ID="TrackingEnabled" Name="/Globalsettings/System/Tracking/TrackingEnabled" Label="Enable tracking" />
                <dwc:InputNumber Name="/Globalsettings/System/Tracking/SessionCookieExpirationMinutes" ID="SessionCookieExpirationMinutes" Label="Session expiration" IncrementSize="1" Min="1" runat="server" Placeholder="30">
                    <dwc:FieldAddOn Text="Minutes" />
                </dwc:InputNumber>
                <dwc:InputNumber Name="/Globalsettings/System/Tracking/VisitorCookieExpirationMinutes" ID="VisitorCookieExpirationMinutes" Label="Returning visitor expiration" IncrementSize="1" runat="server" Placeholder="365" Min="1">
                    <dwc:FieldAddOn Text="Days" />
                </dwc:InputNumber>

                <dwc:CheckBox runat="server" ID="DoNotTrackPersonalInformation" Name="/Globalsettings/System/Tracking/DoNotTrackPersonalInformation" Label="Do not track personal information" Info="Anonymize IP address: 192.168.1.*" />
                <dwc:CheckBox runat="server" ID="DoNotTrackDntHeader" Name="/Globalsettings/System/Tracking/DoNotTrackDntHeader" Label="Do not track visits with dnt header" Info="Do not track 'dnt=1' header" />

            </dwc:GroupBox>
            <dwc:GroupBox ID="GroupBox1" Title="Tracking limits" runat="server">

                <dwc:RadioGroup runat="server" ID="UrlInlcudeAreaType" Name="/Globalsettings/System/Tracking/Level" Label="Tracking level">
                    <dwc:RadioButton runat="server" Label="All" FieldValue="0" Info="Tracks all visits including bots" />
                    <dwc:RadioButton runat="server" Label="Do not track undetected devices and unknown bots" FieldValue="1" Info="Devicetype=0 and bottype<2" />
                    <dwc:RadioButton runat="server" Label="Do not track if device is unknown" FieldValue="2" Info="Devicetype=0" />
                </dwc:RadioGroup>

                <dwc:CheckBox runat="server" ID="DoNotTrackAcceptAllHeader" Name="/Globalsettings/System/Tracking/DoNotTrackAcceptAllHeader" Label="Do not track 'accept=*/*' header" />
                <dwc:CheckBox runat="server" ID="DoNotTrackConnectionCloseHeader" Name="/Globalsettings/System/Tracking/DoNotTrackConnectionCloseHeader" Label="Do not track 'connection=close' header" />
                <dwc:CheckBox runat="server" ID="DoNotTrackHeaderCount" Name="/Globalsettings/System/Tracking/DoNotTrackHeaderCount" Label="Do not track where header count <= {Min header count}" />
                <dwc:InputNumber Name="/Globalsettings/System/Tracking/DoNotTrackHeaderCountThreshold" ID="DoNotTrackHeaderCountThreshold" Label="Min header count" IncrementSize="1" Min="1" runat="server" Placeholder="5">
                    <dwc:FieldAddOn Text="Headers" />
                </dwc:InputNumber>

                <dwc:CheckBox runat="server" ID="DoNotTrackInternalIP" Name="/Globalsettings/System/Tracking/DoNotTrackInternalIP" Label="Do not track internal IP addresses" />
                <dwc:InputTextArea runat="server" ID="DoNotTrackInternalIPRanges" Name="/Globalsettings/System/Tracking/DoNotTrackInternalIPRanges" Label="Internal IP addresses" Info="List of ips not to track. I.e. 192.168.1.255, 192.168.2.1 - 192.168.2.90" Rows="5" MaxLength="750" />

                <dwc:CheckBox runat="server" ID="StoreNotTrackedVisits" Name="/Globalsettings/System/Tracking/StoreNotTrackedVisits" Label="Store ignored visits" Info="For debugging - will track all visits regardless of above settings and mark all visits as excluded with information on the failed test" />
            </dwc:GroupBox>
            <dwc:GroupBox ID="DebugGroupBox" Title="Debug" runat="server">
                <dwc:CheckBox runat="server" ID="LoggingEnabled" Name="/Globalsettings/System/Tracking/LoggingEnabled" Label="Enable logging" Info="Logs tracking exceptions to event viewer" />
            </dwc:GroupBox>
            <dwc:GroupBox ID="DataTablesGroupBox" Title="Tables" runat="server">
                <dwc:SelectPicker ID="TableTimeInterval" Name="/Globalsettings/System/Tracking/TableTimeInterval" Label="Table time interval" Info="Tracking tables will be split based on the selected time interval" runat="server">
                    <asp:ListItem Value="None" Text="None"></asp:ListItem>
                    <asp:ListItem Value="Year" Text="Year"></asp:ListItem>
                    <asp:ListItem Value="Month" Text="Month"></asp:ListItem>
                    <asp:ListItem Value="Day" Text="Day"></asp:ListItem>
                </dwc:SelectPicker>
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>

