<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="ExternalLoginProviderEdit.aspx.vb" Inherits="Dynamicweb.Admin.ExternalLoginProviderEdit" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <title>
        <dw:TranslateLabel ID="lbTitle" Text="Edit external login provider" runat="server" />
    </title>
    
    <script src="/Admin/Images/Controls/UserSelector/UserSelector.js" type="text/javascript"></script>
    <script src="/Admin/Content/Management/Pages/ExternalLoginProviderEdit.js" type="text/javascript"></script>
    <script src="/Admin/Validation.js" type="text/javascript"></script>
    <script src="/Admin/Link.js" type="text/javascript"></script>

    <asp:Literal ID="addInSelectorScripts" runat="server" />

    <script type="text/javascript">
        (function ($) {
            $(function () {
                Dynamicweb.ExternalLogin.ProviderEdit.terminology = {
                    ProviderNameRequired: '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Please specify the name of the login provider.")%>',
                    ProviderRequired: '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Please specify the external login provider.")%>',
                    DeleteConfirm: '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Are you sure you want to delete this login provider?")%>'
                };

                $('#div_Dynamicweb.Security.UserManagement.ExternalAuthentication.ExternalLoginProvider_parameters').on('keydown', function (event) {
                    if (event.target.tagName === 'INPUT') {
                        $$('.notification').each(Element.hide);
                    }
                });

                $('#cbProviderActive').on('click', function (event) {
                    Dynamicweb.ExternalLogin.ProviderEdit.showLeaveConfirmation();
                });

                $('.card-body').on('keydown', function (event) {
                    Dynamicweb.ExternalLogin.ProviderEdit.showLeaveConfirmation();
                });

                var page = SettingsPage.getInstance();
                page.save = function () { return Dynamicweb.ExternalLogin.ProviderEdit.save() };
                page.saveAndClose = function () { return Dynamicweb.ExternalLogin.ProviderEdit.saveAndClose() };
                page.cancel = function () { return Dynamicweb.ExternalLogin.ProviderEdit.cancel() };
            });
        })(jQuery);
    </script>
</asp:Content>
<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <div id="breadcrumb"></div>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Edit provider" />

        <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">            
            <dw:ToolbarButton ID="cmdDelete" runat="server" Icon="Delete" Text="Delete" OnClientClick="Dynamicweb.ExternalLogin.ProviderEdit.deleteProvider();" />
        </dw:Toolbar>

        <dwc:CardBody runat="server">
            <input type="hidden" id="Cmd" name="Cmd" value="" />
            <dwc:GroupBox ID="gbGeneral" Title="General" runat="server">
                <dwc:InputText ID="txtProviderName" Name="txtProviderName" Label="Name" ClientIDMode="Static" ValidationMessage="" runat="server" />
                <dwc:CheckBox ID="cbProviderActive" Name="cbProviderActive" Checked="true" Label="Active" ClientIDMode="Static" runat="server" />                
                <dwc:CheckBox ID="useForBackendLogOn" Label="Enable for backend" runat="server" />
            </dwc:GroupBox>

            <de:AddInSelector ID="addInSelector" runat="server" AddInGroupName="Login Providers" UseLabelAsName="False" AddInBreakFieldsets="False" onafterUpdateSelection="Dynamicweb.ExternalLogin.ProviderEdit.afterEditorChanged();"
                AddInShowNothingSelected="true" NoParametersMessage="No provider selected." AddInTypeName="Dynamicweb.Security.UserManagement.ExternalAuthentication.ExternalLoginProvider" />
            <asp:Literal ID="addInSelectorLoadScript" runat="server"></asp:Literal>

            <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True"></dw:Overlay>

            <dwc:ActionBar runat="server">
                <dw:ToolbarButton ID="cmdSave" runat="server" Text="Save" OnClientClick="page.save();" />
                <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Text="Save and close" OnClientClick="page.saveAndClose();" />
                <dw:ToolbarButton ID="cmdCancel" runat="server" Text="Cancel" OnClientClick="page.cancel()" />
            </dwc:ActionBar>
            <% Translate.GetEditOnlineScript() %>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
