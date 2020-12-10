<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" ClientIDMode="Static" CodeBehind="SecuritySetup_cpl.aspx.vb" Inherits="Dynamicweb.Admin.SecuritySetup_cpl" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="/Admin/Validation.js"></script>

    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () {
            var eml = document.getElementById("FormAntiSpamReportTo");
            if (IsEmailValid(eml,
			    "<%=Translate.JsTranslate("Ugyldig_værdi_i:_%%", "%%", Translate.JsTranslate("Send kopi til e-mail"))%>")) {
                page.submit();
            }
            return false;
        };

            (function ($) {
                $(function () {
                    $("#DisableSQLInjectionCheck").on("change", function () {
                        $("#SQLInjectionSkip").prop("disabled", $(this).is(":checked"));
                    }).trigger("change");
                });
            })(jQuery);
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>
            <li><a href="#">Web and HTTP</a></li>
            <li class="active">Security</li>
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
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Security" />
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="GroupBox1" Title="Formular" runat="server">
                <dwc:CheckBox runat="server" ID="FormAntiSpam" Name="/Globalsettings/System/Security/FormAntiSpam" Label="Aktiver antispam funktion" Info="Forms" />
                <dwc:CheckBox runat="server" ID="FormAntiSpamEnableForUserCreate" Name="/Globalsettings/System/Security/FormAntiSpamEnableForUserCreate" Label="Aktiver antispam funktion" Info="Users" />
                <dwc:CheckBox runat="server" ID="FormAntiSpamEnableForCommentCreate" Name="/Globalsettings/System/Security/FormAntiSpamEnableForCommentCreate" Label="Aktiver antispam funktion" Info="Comment" />
                <dwc:InputText runat="server" ID="FormAntiSpamReportTo" Name="/Globalsettings/System/Security/FormAntiSpamReportTo" Label="Send kopi til e-mail" MaxLength="255" />
                <dwc:InputNumber runat="server" ID="FormAntiSpamMinSeconds" Name="/Globalsettings/System/Security/FormAntiSpamMinSeconds" Label="Seconds before post" MaxLength="3" Placeholder="2" />
                <dwc:InputNumber runat="server" ID="FormAntiSpamMaxIpSubmits" Name="/Globalsettings/System/Security/FormAntiSpamMaxIpSubmits" Label="Submits from same IP" MaxLength="3" Placeholder="15" />
                <dwc:InputNumber runat="server" ID="FormAntiSpamMaxIpSubmitsQuarantine" Name="/Globalsettings/System/Security/FormAntiSpamMaxIpSubmitsQuarantine" Label="IP quarantine in hours" MaxLength="3" Placeholder="24" />
                <dwc:CheckBox runat="server" ID="FormAntiSpamDisableExtended" Name="/Globalsettings/System/Security/FormAntiSpamDisableExtended" Label="Disable extended checks" />

            </dwc:GroupBox>

            <dwc:GroupBox ID="gbInjection" Title="SQL injection check" runat="server">
                <dwc:CheckBox runat="server" ID="DisableSQLInjectionCheck" Name="/Globalsettings/System/http/DisableSQLInjectionCheck" Label="Disable" />
                <dwc:CheckBox runat="server" ID="DoNotBanIps" Name="/Globalsettings/System/Security/DoNotBanIps" Label="Do not ban IPs" />
                <dwc:InputNumber runat="server" ID="InputNumber1" Name="/Globalsettings/System/Security/BanIpsDays" Label="Days to ban IP" MaxLength="3" Placeholder="30" />
                <dwc:InputTextArea runat="server" ID="SQLInjectionSkip" Name="/Globalsettings/System/Security/SQLInjectionSkip" Label="Ignore the following fields" Info="Use comma to separate field names." />
                <dwc:InputTextArea runat="server" ID="SQLInjectionIpWhitelist" Name="/Globalsettings/System/Security/SQLInjectionIpWhitelist" Label="Ignore the following IPs" Info="Use comma to separate ips." />
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox3" Title="SQL injection emails" runat="server">
                <dwc:InputTextArea runat="server" Name="/Globalsettings/System/Security/SQLInjectionEmailRecipients" Label="List of recipients" Info="Use comma to separate email addresses." Placeholder="Email" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox5" Title="Security headers" runat="server">
                <dwc:CheckBox runat="server" ID="XXSSProtection" Name="/Globalsettings/System/Security/Headers/XXSSProtection" Label="Enable 'X-XSS-Protection: 1; mode=block' header" Info="Blocks rendering if supporting browsers detect XSS attacks" />
                <dwc:CheckBox runat="server" ID="XContentTypeOptions" Name="/Globalsettings/System/Security/Headers/XContentTypeOptions" Label="Enable 'X-Content-Type-Options: nosniff' header" Info="Instructs browsers to use mime-type from response headers" />
                <dwc:CheckBox runat="server" ID="XFrameOptions" Name="/Globalsettings/System/Security/Headers/XFrameOptions" Label="Enable 'X-Frame-Options: sameorigin' header" Info="Prevents browsers from rendering a page in a frame, iframe, embed or object element on other websites." />
                <dwc:SelectPicker runat="server" ID="ReferrerPolicy" Name="/Globalsettings/System/Security/Headers/ReferrerPolicy" Label="Referrer-Policy" Info="Referrer-Policy: no-referrer-when-downgrade is browser default">
                    <asp:ListItem runat="server" Text="Intet valgt" Value="" />
                    <asp:ListItem runat="server" Text="no-referrer-when-downgrade" Value="no-referrer-when-downgrade" />
                    <asp:ListItem runat="server" Text="no-referrer" Value="no-referrer" />
                    <asp:ListItem runat="server" Text="origin" Value="origin" />
                    <asp:ListItem runat="server" Text="origin-when-cross-origin" Value="origin-when-cross-origin" />
                    <asp:ListItem runat="server" Text="same-origin" Value="same-origin" />
                    <asp:ListItem runat="server" Text="strict-origin" Value="strict-origin" />
                    <asp:ListItem runat="server" Text="strict-origin-when-cross-origin" Value="strict-origin-when-cross-origin" />
                    <asp:ListItem runat="server" Text="unsafe-url" Value="unsafe-url" />
                </dwc:SelectPicker>
                <dwc:CheckBox runat="server" ID="StrictTransportSecurity" Name="/Globalsettings/System/Security/Headers/StrictTransportSecurity" Label="Enable 'Strict-Transport-Security: max-age={expire-time}' header" Info="Default expire-time is 2592000 seconds, which is 30 days. This header will cause problems if SSL certificate expires." />
                <dwc:InputNumber runat="server" ID="StrictTransportSecurityExpireTime" Name="/Globalsettings/System/Security/Headers/StrictTransportSecurityExpireTime" Label="Strict-Transport-Security max-age" MaxLength="9" Placeholder="2592000" Info="The time, in seconds, that the browser should remember that a site is only to be accessed using HTTPS." />
                <dwc:InputTextArea runat="server" Name="/Globalsettings/System/Security/Headers/CustomHeaders" Label="Custom headers" Info="Use the format 'header-name: header-value'. Seperate headers with ; Use for i.e. Content-Security-Policy headers." Placeholder="x-custom-header: custom value;x-other-header: value 2" Rows="5" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox4" Title="Debugging" runat="server">
                <dwc:CheckBox runat="server" ID="DisableDebug" Name="/Globalsettings/Settings/DwInclude/DisableDebug" Label="Disable" Info="Disables the use of ?debug=true, dbstat=true etc. for users not logged in to the administration" />
                <dwc:CheckBox runat="server" ID="ThrowExceptionOnOutputErrorModules" Name="/Globalsettings/Settings/Modules/ThrowExceptionOnOutputError" Label="Throw exception for modules" Info="Throws a .NET exception if ContentModule.GetContent() has exceptions instead of rendering the exception on the page. Requires iisreset." />
                <dwc:CheckBox runat="server" ID="ThrowExceptionOnOutputErrorTemplates" Name="/Globalsettings/Settings/Templates/ThrowExceptionOnOutputError" Label="Throw exception for templates" Info="Throws a .NET exception if a Razor template has any errors at compile or runtime instead of rendering the exception on the page. Requires iisreset." />
                <dwc:CheckBox runat="server" ID="ShowFriendlyErrormessageOnOutputError" Name="/Globalsettings/Settings/Templates/ShowFriendlyErrormessageOnOutputError" Label="Display friendly error message for templates and modules" Info="Displays a friendly error message in frontend when a module or template exception occurs. Disables regular exceptions" />
                <dwc:InputText runat="server" ID="FriendlyErrormessageOnOutputError" Name="/Globalsettings/Settings/Templates/FriendlyErrormessageOnOutputError" Label="Friendly error message" MaxLength="255" Placeholder="An error has occured. See log for information." />
            </dwc:GroupBox>

            <%If Session("DW_Admin_UserType") = 0 Or Session("DW_Admin_UserType") = 1 Or Session("DW_Admin_UserType") = 3 Then%>
            <dwc:GroupBox ID="GroupBox2" Title="Dynamicweb support" runat="server">
                <dwc:CheckBox runat="server" ID="AngelLocked" Name="/Globalsettings/System/Security/AngelLocked" Label="Restrict access for support users" />
            </dwc:GroupBox>
            <%End If%>
            <% Translate.GetEditOnlineScript() %>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
