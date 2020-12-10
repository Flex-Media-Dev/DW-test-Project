<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="ItemSettings_cpl.aspx.vb" Inherits="Dynamicweb.Admin.ItemSettings_cpl" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="DynamicWeb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="DynamicWeb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script>
        var page = SettingsPage.getInstance();
        page.onSave = function () {
		    document.getElementById('MainForm').submit();
        }
        
        function onMetadataSourceChange(el) {
            var method = el.value === 'all' ? 'show' : 'hide';
            $('item-types-warning')[method]();
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Item settings" />

        <dwc:CardBody runat="server">
            <dwc:GroupBox runat="server" Title="Google fonts API">
                <dwc:InputText runat="server" ID="GoogleFontsAPIKey" Name="/Globalsettings/ItemTypes/GoogleFontApiKey" Label="Google Fonts API key" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Color swatch">
                <dwc:InputNumber runat="server" ID="CountOfColors" Name="/Globalsettings/ItemTypes/ColorSwatch/CountOfColors" Label="Count of colors" />
            </dwc:GroupBox>
            <dwc:GroupBox Title="Synchronize" runat="server">
                <dwc:RadioGroup runat="server" Name="/Globalsettings/ItemTypes/MetadataSource">
                    <dwc:RadioButton runat="server" Label="All" FieldValue="all" OnClick="onMetadataSourceChange(this);" />
                    <dwc:RadioButton runat="server" Label="Files" FieldValue="files" OnClick="onMetadataSourceChange(this);" />
                    <dwc:RadioButton runat="server" Label="Database" FieldValue="database" OnClick="onMetadataSourceChange(this);" />
                </dwc:RadioGroup>
                <div id="item-types-warning" class="form-group text-danger" <%=If(String.Compare(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/ItemTypes/MetadataSource"), "all", StringComparison.InvariantCultureIgnoreCase) = 0, String.Empty, "style=""display: none;""")%>>
                    <dw:Infobar Type="Warning" Message="WARNING. Can be perfomance issues." runat="server"></dw:Infobar>
                </div>
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>

    <% Translate.GetEditOnlineScript() %>
</asp:Content>
