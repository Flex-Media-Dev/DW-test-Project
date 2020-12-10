<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="EcomAdvExportOrderSettings_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvExportOrderSettings_Edit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script language="javascript" type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function () {
            if (IsValidRecipientEmails()) {
                document.getElementById('MainForm').submit();
            }
        }

        page.onHelp = function () {
            <%=Dynamicweb.SystemTools.Gui.Help("", "administration.controlpanel.ecom.general") %>
        }

        function IsValidRecipientEmails() {
            var control = document.getElementById("/Globalsettings/Ecom/Order/ExportSettings/EmailRecipientsList");
            var regex = /([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})/;
            if (control && control.value) {
                var emails = control.value.split(";");
                for (var i = 0; i < emails.length; i++) {
                    if (!regex.test(emails[i])) {
                        alert('Please check recipients e-mails list');
                        control.focus();
                        return false;
                    }
                }
            }
            return true;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Export order"></dwc:CardHeader>

        <dwc:CardBody runat="server" ID="PageContent">
            <dwc:GroupBox runat="server" Title="Settings">
                <dwc:CheckBox runat="server" Label="Enable Order export to XML" ID="EnableOrdersExport" Name="/Globalsettings/Ecom/Order/ExportSettings/EnableOrdersExport" />
                <dwc:CheckBox runat="server" Label="Update Order IsExported field after export to xml" ID="UpdateOrderIsExported" Name="/Globalsettings/Ecom/Order/ExportSettings/UpdateOrderIsExported" />

                <div class="form-group">
                    <label class="control-label"><dw:TranslateLabel runat="server" Text="Output folder" /></label>
                    <%= IIf(String.IsNullOrEmpty(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Order/ExportSettings/OutputFolder")),
                                                                                                        Gui.FolderManager(Dynamicweb.Content.Files.FilesAndFolders.GetFilesFolderName(), "/Globalsettings/Ecom/Order/ExportSettings/OutputFolder"),
                                                                                                        Gui.FolderManager(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Order/ExportSettings/OutputFolder"), "/Globalsettings/Ecom/Order/ExportSettings/OutputFolder"))%>
                    
                </div>

                <div class="form-group">
                    <label class="control-label"><dw:TranslateLabel runat="server" Text="XSL file" /></label>
                    <%= Dynamicweb.SystemTools.Gui.FileManager(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Order/ExportSettings/XslFile"), Dynamicweb.Content.Files.FilesAndFolders.GetFilesFolderName(), "/Globalsettings/Ecom/Order/ExportSettings/XslFile", "/Globalsettings/Ecom/Order/ExportSettings/XslFile", "xsl,xslt", True, "", True, Nothing)%>
                </div>

            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="E-mail settings">
                <dwc:CheckBox runat="server" Label="Enable E-mails with order" ID="EnableSendExportedOrders" Name="/Globalsettings/Ecom/Order/ExportSettings/EnableSendExportedOrders" />
                <dwc:InputText runat="server" Label="Recipient e-mails" Info="Separated by semicolon" ID="EmailRecipientsList" Name="/Globalsettings/Ecom/Order/ExportSettings/EmailRecipientsList" />
                <dwc:InputText runat="server" Label="Sender name" ID="EmailSenderName" Name="/Globalsettings/Ecom/Order/ExportSettings/EmailSenderName" />
                <dwc:InputText runat="server" Label="Sender E-mail" ID="SenderEmail" Name="/Globalsettings/Ecom/Order/ExportSettings/SenderEmail" />
                <dwc:InputText runat="server" Label="Subject" ID="EmailSubject" Name="/Globalsettings/Ecom/Order/ExportSettings/EmailSubject" />
                <dwc:InputTextArea runat="server" Label="Body" ID="EmailBody" Name="/Globalsettings/Ecom/Order/ExportSettings/EmailBody" />
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>

     <% Translate.GetEditOnlineScript() %>

</asp:Content>
