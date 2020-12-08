<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="Filemanager_cpl.aspx.vb" Inherits="Dynamicweb.Admin.Filemanager_cpl" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="/Admin/Validation.js"></script>

    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function() {
            page.submit();
        }

        function editMetafields() {
            window.location = "/Admin/Filemanager/Metadata/ConfigurationEdit.aspx?folder=/";
        }
    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>            
            <li><a href="#">Control Panel</a></li>
            <li class="active">File manager</li>
        </ol>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Filarkiv"></dwc:CardHeader>
        <dwc:CardBody runat="server">
            <dwc:GroupBox Title="Upload" runat="server">
                <dwc:CheckBox runat="server" Id="chkReplaceSpace" Name="/Globalsettings/Modules/Filemanager/Upload/ReplaceSpace" Label="Erstat [Space] med [dash]" />
                <dwc:CheckBox runat="server" Id="chkLatinNormalize" Name="/Globalsettings/Modules/Filemanager/Upload/LatinNormalize" Label="Normalize latin characters" />
            </dwc:GroupBox>

            <dwc:GroupBox Title="Performance" GroupWidth="6" runat="server">
                <dwc:InputNumber runat="server" Name="/Globalsettings/Modules/Filemanager/AllowedFolders" Label="Allowed folder amount" Placeholder="500" />
            </dwc:GroupBox>

            <dwc:GroupBox Title="System metafields" runat="server">
                <dwc:Button Title="Edit system metafields" id="cfGeneral" OnClick="editMetafields();" runat="server" />
            </dwc:GroupBox>
            
            <% Translate.GetEditOnlineScript() %>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
