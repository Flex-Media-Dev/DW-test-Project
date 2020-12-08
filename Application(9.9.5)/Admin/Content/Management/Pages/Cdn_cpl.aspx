<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="Cdn_cpl.aspx.vb" Inherits="Dynamicweb.Admin.cdn_cpl" %>

<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () {
            page.submit();
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>
            <li><a href="#">Web and HTTP</a></li>
            <li class="active"><%= Translate.Translate("Content Delivery Network") %></li>
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
        <dwc:CardHeader runat="server" Title="Content Delivery Network"></dwc:CardHeader>
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="gbInjection" Title="Indstillinger" runat="server">
                <dwc:CheckBox runat="server" id="active" Name="/Globalsettings/System/cdn/active" label="Active"/>
                <dwc:InputText runat="server" id="Host" Name="/Globalsettings/System/cdn/host" label="Host" MaxLength="255" info="http(s)://cdn.domain.com" />
                <dwc:InputText runat="server" id="GetImageHost" Name="/Globalsettings/System/cdn/getimagehost" label="Host" DoTranslate="false" MaxLength="255"  info="http(s)://cdn.domain.com" />
            </dwc:GroupBox>
            <% Translate.GetEditOnlineScript() %>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>

