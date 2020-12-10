<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditWorkflowState.aspx.vb" Inherits="Dynamicweb.Admin.EditWorkflowState" %>

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
        function createEditWorkflowStatePage(opts) {
            var options = opts;
            var getSelectedCheckboxesValues = function (checkdoxName) {
                var checkedValues = Array.prototype.reduce.call(document.querySelectorAll("input[name='" + checkdoxName + "']:checked"), function (accomulator, chb, index, array) {
                    accomulator.push(chb.value);
                    return accomulator;
                }, []);
                return checkedValues;
            }
            var workflowStateNameEl = document.getElementById(options.ids.name);
            var workflowStateNameIni = workflowStateNameEl.value;
            var nextLevelStatesIni = getSelectedCheckboxesValues(options.ids.nextLevelStates);

            var hasValue = function (el) {
                return !!el.value;
            };
            var validate = function () {
                if (!hasValue(workflowStateNameEl)) {
                    dwGlobal.showControlErrors(workflowStateNameEl, options.labels.emptyName);
                    workflowStateNameEl.focus();
                    return false;
                }
                return true;
            };

            var obj = {
                init: function (opts) {
                    this.options = opts;
                    this.deletedNotificationsIds = [];
                    dwGrid_NotificationsList.onRowAdding = this.editNotification.bind(this);
                    dwGrid_NotificationsList.onRowsDeletedCompleted = this._deleteNotification.bind(this);
                },

                editNotification: function (evt, notificationId) {
                    if (this._hasChangesOnPage()) {
                        Action.Execute(this.options.actions.confirmSaveToNotificationEdit, { StateId: this.options.workflowStateId, NotificationId: notificationId });
                    }
                    else {
                        Action.Execute(this.options.actions.notificationEdit, { StateId: this.options.workflowStateId, NotificationId: notificationId });
                    }
                    return true;
                },

                _deleteNotification: function (rows) {
                    for (var i = 0; i < rows.length; i++) {
                        this.deletedNotificationsIds.push(rows[i].element.getAttribute("ItemId"));
                    }
                },

                _hasChangesOnPage: function() {
                    var res = this.options.workflowStateId < 1 || this.deletedNotificationsIds.length || workflowStateNameIni !== workflowStateNameEl.value;
                    if (!res) {
                        var nextLevelStates = getSelectedCheckboxesValues(options.ids.nextLevelStates);
                        res = nextLevelStates.join(",") !== nextLevelStatesIni.join(",");
                    }
                    return res;
                },

                save: function(close, redirectToEditNotification) {
                    if (validate()) {
                        if (close) {
                            document.getElementById('RedirectTo').value = typeof (redirectToEditNotification) == "undefined" ? "workflow" : redirectToEditNotification;
                        }
                        var deletedNotificationsEl = document.getElementById('DeletedNotifications');
                        deletedNotificationsEl.value = this.deletedNotificationsIds.join();
                        var cmd = document.getElementById('cmdSubmit');
                        cmd.value = "Save";
                        cmd.click();
                    }
                },

                saveBeforeEditNotification: function () {
                    this.save(true, 0)
                },

                cancel: function () {
                    Action.Execute(this.options.actions.workflowEdit);
                },
                deleteNotificationsListRows: function (evt, el) {
                    evt.stopPropagation();
                    dwGrid_NotificationsList.deleteRows([dwGrid_NotificationsList.findContainingRow(el)]);
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
                    <dwc:GroupBox ID="gbSettings" Title="State settings" runat="server">
                        <dwc:InputText ID="WorkflowStateId" runat="server" Label="ID" Disabled="true" />
                        <dwc:InputText ID="WorkflowStateName" runat="server" Label="State Name" ValidationMessage="" MaxLength="255" />
                        <dwc:CheckBoxGroup ID="NextLevelStates" runat="server" Label="Available states" />
                        <div class="form-group">
                            <label class="control-label">State notifications</label>
                            <div class="form-group-input">
                                <dw:EditableGrid runat="server" ID="NotificationsList" AllowAddingRows="true" AllowDeletingRows="true" NoRowsMessage="No Notifications" AddNewRowMessage="Add new state notification" RowStyle-CssClass="pointer">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Name" ItemStyle-CssClass="notification-name-column">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="NotificationName" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Delete" ItemStyle-CssClass="row-delete notification-remove-row-column" HeaderStyle-CssClass="notification-remove-row-column">
                                            <ItemTemplate>
                                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>" onclick="currentPage.deleteNotificationsListRows(event, this);"></i>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </dw:EditableGrid>
                                <dw:Infobar ID="SaveNotification" DisplayType="Warning" Message="Save the state" Visible="false" runat="server"></dw:Infobar>
                            </div>
                        </div>
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

