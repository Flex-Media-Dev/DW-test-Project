
<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="SystemGeneral_cpl.aspx.vb" Inherits="Dynamicweb.Admin.SystemGeneral_cpl" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Imaging" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Dynamicweb.controls" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="/Admin/Validation.js"></script>

    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function () {
            var eml = document.getElementById("CommonInformationEmail");
            var ret = true;

            if (eml.value.length > 0) {
                ret = IsEmailValid(eml);
                if (!ret) {
                    dwGlobal.showControlErrors(eml, "<%=Translate.JSTranslate("Ugyldig_værdi_i:_%%", "%%", Translate.Translate("E-mail"))%>");                    
                    hideOverlay();                                        
                }
            }

            if (ret) {
                document.getElementById('MainForm').submit();
            }
        }

        function hideOverlay() {
            if (__o != null) {
                _o.hide();
            } else {
                var overlay = document.getElementById("__ribbonOverlay");
                if (overlay != null) {
                    overlay.style.display = "none";
                }
            }
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>
            <li><a href="#">System</a></li>
            <li class="active"><%= Translate.Translate("Solution settings") %></li>
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
        <dwc:CardHeader runat="server" Title="Solution settings"></dwc:CardHeader>
        <dwc:CardBody runat="server">
            <input id="hiddenOpenTo" type="hidden" name="OpenTo" value="" />

            <dwc:GroupBox ID="GroupBox3" runat="server" Title="Generel information" GroupWidth="6">
                <dwc:InputText runat="server" ID="SolutionTitle" Name="/Globalsettings/Settings/CommonInformation/SolutionTitle" Label="Løsningstitel" />
                <dwc:InputText runat="server" ID="CommonInformationEmail" ClientIDMode="Static" Name="/Globalsettings/Settings/CommonInformation/Email" DoTranslate="false" ValidationMessage="" />
                <dwc:InputTextArea runat="server" ID="CopyrightMetaInformation" Name="/Globalsettings/Settings/CommonInformation/CopyrightMetaInformation" Label="Copyright" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox1" runat="server" Title="Login screen" GroupWidth="6">
                <dw:FileManager runat="server" ID="SolutionLoginInfoLogo" File="/Globalsettings/Settings/CommonInformation/SolutionLoginInfoLogo" Name="/Globalsettings/Settings/CommonInformation/SolutionLoginInfoLogo" AllowBrowse="true" Folder="System" Extensions="jpg,gif,png" Label="Licensed to Logo" Info="Max w 170 x h 110 px" />
                <dwc:InputText runat="server" ID="Partner" Name="/Globalsettings/Settings/CommonInformation/Partner" Label="Partner" MaxLength="255" />
                <dwc:InputTextArea runat="server" ID="SolutionLoginInfo" Name="/Globalsettings/Settings/CommonInformation/SolutionLoginInfo" Label="Solution login info" MaxLength="255" />
                <dwc:InputText runat="server" ID="PartnerEmail" Name="/Globalsettings/Settings/CommonInformation/PartnerEmail" Label="Partner e-mail" MaxLength="255" />
            </dwc:GroupBox>

            <%If Dynamicweb.Security.UserManagement.User.GetCurrentBackendUser().IsAngel OrElse Dynamicweb.Security.UserManagement.User.GetCurrentBackendUser().Type = Dynamicweb.Security.UserManagement.UserType.SystemAdministrator Then%>
            <dwc:GroupBox ID="GroupBox9" runat="server" Title="Non-Administrator users" GroupWidth="6">
                <dwc:CheckBox runat="server" Name="/Globalsettings/Settings/CustomerAccess/HideRememberFeatures" ID="HideRememberFeatures" Value="True" Label="Disable save username and password." />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Settings/CustomerAccess/LockTemplateFolder" ID="LockTemplateFolder" Value="True" DoTranslate="True" Label="Lock Template Folder" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Settings/CustomerAccess/LockSystemFolder" ID="LockSystemFolder" Value="True" DoTranslate="True" Label="Lock System Folder" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Settings/CustomerAccess/LockDeveloperTools" ID="LockDeveloperTools" Value="True" DoTranslate="True" Label="Lock Developer (Settings)" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Settings/CustomerAccess/LockMgmtCenter" ID="LockMgmtCenter" Value="True" DoTranslate="True" Label="Lock Settings" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Settings/CustomerAccess/LockAccessToItems" ID="LockAccessToItems" Value="True" DoTranslate="True" Label="Lock access to Items" />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Settings/CustomerAccess/HideLayoutSelectorEditLink" ID="HideLayoutSelectorEditLink" Value="True" DoTranslate="True" Label="Disable Edit link in Layout selectors" />
            </dwc:GroupBox>
            <%End If%>
            <%If Dynamicweb.Security.UserManagement.User.GetCurrentBackendUser().IsAngel%>
            <dwc:GroupBox runat="server" ID="DisableSolutionGroupbox" Title="Disable solution">
                <dwc:CheckBox runat="server" ID="dblgnforna" Name="/Globalsettings/System/dblgnforna" Label="Disable backend login for non-angel and warn." DoTranslate="false" />
                <dwc:CheckBox runat="server" ID="dblgnfornafe" Name="/Globalsettings/System/dblgnfornafe" Label="Shutdown frontend." DoTranslate="false" />
                <dwc:InputText runat="server" ID="dblgnfornafemsg" Name="/Globalsettings/System/dblgnfornafemsg" Label="Message (Frontend and Backend)" DoTranslate="false" MaxLength="255" />
            </dwc:GroupBox>
            <%End If%>

            <dwc:GroupBox ID="GroupBox11" runat="server" Title="Brugerdefinerede fejlsider" GroupWidth="6">
                <div class="form-group">
                    <label class="control-label"><dw:TranslateLabel runat="server" Text="HTTP 404"></dw:TranslateLabel></label>
                    <dw:LinkManager runat="server" Name="PageNotFoundRedirectTo" ID="PageNotFoundRedirectTo" />
                </div>
            </dwc:GroupBox>

             <dwc:GroupBox ID="GroupBox2" runat="server" Title="Auditing" GroupWidth="6">
                <dwc:CheckBox runat="server" Name="/Globalsettings/Settings/Auditing/EnableAuditing" ID="EnableAuditing" Value="True" Label="Enable auditing" Info="Auditing tracks changes to e.g. products & shops. Activating this has no impact on the UI, but will lead to a significantly larger database" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox14" runat="server" Title="Security" GroupWidth="6">
                <dwc:CheckBox runat="server" Name="/Globalsettings/Settings/ForceSSL4Admin" ID="ForceSSL4Admin" Value="True" Label="Force ssl on /Admin" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox15" runat="server" Title="Pdf" GroupWidth="6">
                <dwc:SelectPicker runat="server" Name="/Globalsettings/Settings/Pdf/PageSize" ID="PageSize" Label="Page size" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox4" runat="server" Title="Scheduled tasks" GroupWidth="6">
                <dwc:CheckBox runat="server" Name="/Globalsettings/System/ScheduledTasks/DisableNotFoundWarning" ID="DisableNotFoundWarning" Value="True" Label="Disable 'Windows scheduled task is not found' warning" />
            </dwc:GroupBox>

            <%If Dynamicweb.Security.UserManagement.User.GetCurrentBackendUser().IsAngel AndAlso Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/System/Filesystem/ImagesFolderName") <> "Images" Then%>
            <dwc:GroupBox ID="GroupBox16" runat="server" Title="File System" GroupWidth="6">
                <dwc:SelectPicker runat="server" Name="/Globalsettings/System/Filesystem/ImagesFolderName" ID="ImagesFolderName" Label="Images folder name">
                    <asp:ListItem Text="Not set (Billeder)" Value="" />
                    <asp:ListItem Text="Billeder" Value="Billeder" />
                    <asp:ListItem Text="Images" Value="Images" />
                </dwc:SelectPicker>
            </dwc:GroupBox>
            <%End If%>
            <%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript() %>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
