<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NotificationSettings.aspx.vb" Inherits="Dynamicweb.Admin.NotificationSettings" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true">
    </dw:ControlResources>

    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>

    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/Base.css" type="text/css" />
    <style>
        .groupbox {
            border-bottom: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <dw:Infobar runat="server" TranslateMessage="true" Type="Information" CssClass="m-b-0"
            Message="The notification is sent after the activity has been executed, notifying the recipients about the status of the activity execution including an activity log"></dw:Infobar>
        <dw:Infobar runat="server" ID="errorInfoBar" Visible="false" CssClass="m-b-0"></dw:Infobar>

        <dwc:GroupBox runat="server">          
            <dwc:InputText runat="server" ID="txtSenderDisplayName" Label="Sender name" />
            <dwc:InputText runat="server" ID="txtSenderEmail" Label="Sender e-mail" />
            <dwc:InputText runat="server" ID="txtRecipients" Label="Recipients list" Info="Separate e-mails by semicolon" />
            <div class="form-group">
                <label class="control-label">
                    <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Notification e-mail template" />
                </label>
                <dw:FileManager ID="templateSelector" runat="server" FixFieldName="true" ShowPreview="false" Folder="Templates/DataIntegration/Notifications" />
            </div>
            <dwc:CheckBox runat="server" ID="chkOnFailure" Label="On failure only" />
        </dwc:GroupBox>
        <div class="footer">
            <button class="dialog-button-ok btn btn-clean"><%=Translate.Translate("Save changes")%></button>
        </div>
    </form>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
