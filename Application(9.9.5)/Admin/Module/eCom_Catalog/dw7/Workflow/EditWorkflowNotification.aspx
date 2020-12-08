<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditWorkflowNotification.aspx.vb" Inherits="Dynamicweb.Admin.EditWorkflowNotification" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
    <script>
        function createEditWorkflowNotificationPage(opts) {
            var options = opts;
            var notificationSenderEmailEl = document.getElementById(options.ids.senderEmail);
            var hasValue = function (el) {
                return !!el.value;
            };
            var validate = function () {
                if (!hasValue(notificationSenderEmailEl)) {
                    dwGlobal.showControlErrors(notificationSenderEmailEl, options.labels.emptySenderEmail);
                    notificationSenderEmailEl.focus();
                    return false;
                } else if (!validateEmailAddress(notificationSenderEmailEl.value)) {
                    dwGlobal.showControlErrors(notificationSenderEmailEl, options.labels.invalidSenderEmail);
                    notificationSenderEmailEl.focus();
                    return false;
                }
                    return true;
            };
            var validateEmailAddress = function (address) {
                var regExp = /^[\w\-_]+(\.[\w\-_]+)*@[\w\-_]+(\.[\w\-_]+)*\.[a-z]{2,4}$/i;
                return address == '' || regExp.test(address);
            }
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },

                save: function (close) {
                    if (validate()) {
                        var cmd = document.getElementById('cmdSubmit');
                        cmd.value = close ? "SaveAndClose" : "Save";
                        cmd.click();
                    }
                },

                cancel: function () {
                    Action.Execute(this.options.actions.workflowStateEdit);
                }
            };
            obj.init(opts);
            return obj;
        }
    </script>
    <style type="text/css">
        .notification-id-column {
            width: 40px;
            text-align: center !important;
        }

        .notification-remove-row-column {
            width: 50px;
            text-align: center !important;
        }
    </style>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Edit Workflow State" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(true);" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="TimesCircle" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dwc:CardBody runat="server">
                    <dwc:GroupBox runat="server" Title="Notification">
                        <dwc:InputText ID="NotificationSubject" runat="server" Label="Subject" MaxLength="255" />
                        <div class="form-group">
                            <label class="control-label">
                                <dw:TranslateLabel runat="server" Text="Users" />
                            </label>
                            <dw:UserSelector ID="UsersToNotify" runat="server" />
                        </div>
                        <dw:FileManager ID="NotificationTemplate" runat="server" Label="Template" FullPath="true" Folder="/Templates/PIM/Workflow Notifications" />
                        <dwc:InputText ID="NotificationSender" runat="server" Label="Sender" ValidationMessage="" MaxLength="255" />
                        <dwc:InputText ID="NotificationSenderName" runat="server" Label="Sender Name" MaxLength="255" />
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
            <input type="hidden" id="RedirectTo" name="RedirectTo" value="" />
            <input type="hidden" id="DeletedNotifications" name="DeletedNotifications" value="" />
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>


