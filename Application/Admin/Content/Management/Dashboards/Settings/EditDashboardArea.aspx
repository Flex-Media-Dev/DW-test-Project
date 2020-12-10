<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditDashboardArea.aspx.vb" Inherits="Dynamicweb.Admin.EditDashboardArea" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
    <style>
        .add-button-container {
            text-align: center;
            padding: 10px;
        }
    </style>
    <script>
        function createDashboardAreaEditPage(opts) {
            let options = opts;
            let areaNameEl = document.getElementById(options.ids.name);
            let areaNameIni = areaNameEl.value;
            let dashboardNameEl = document.getElementById(options.ids.dashboardName);
            let editDashboardNameDlgOkAction = null;

            let hasValue = function (el) {
                return !!el.value;
            };
            let hasWrongSymbols = function (el) {
                let val = el.value;
                var rx = new RegExp("^[a-zA-Z]+[a-zA-Z0-9_]*$");
                return !val.match(rx);
            };

            let validate = function () {
                if (!hasValue(areaNameEl)) {
                    dwGlobal.showControlErrors(areaNameEl, options.labels.emptyName);
                    areaNameEl.focus();
                    return false;
                } else if (hasWrongSymbols(areaNameEl)) {
                    dwGlobal.showControlErrors(areaNameEl, options.labels.incorrectName);
                    areaNameEl.focus();
                    return false;
                }
                return true;
            };

            let obj = {
                init: function (opts) {
                    this.options = opts;
                    this.deletedDasboardsIds = [];
                },

                cancel: function () {
                    Action.Execute(this.options.actions.list);
                },

                save: function (close) {
                    this._formSubmit("Save", close);
                },

                _formSubmit: function (cmd, action) {
                    if (validate()) {
                        let deletedDashboardsEl = document.getElementById('DeletedDashboards');
                        deletedDashboardsEl.value = this.deletedDasboardsIds.join();
                        let actionEl = document.getElementById('Action');
                        actionEl.value = action || "";
                        let cmdEl = document.getElementById('cmdSubmit');
                        cmdEl.value = cmd;
                        cmdEl.click();
                    }
                },

                saveBeforeDashboardEdit: function (dashboardId) {
                    this._formSubmit("SaveAndOpenDashboard", dashboardId);
                },

                confirmDeleteArea: function (evt) {
                    console.log("confirmDeleteArea");
                    Action.Execute(this.options.actions.deleteArea, { names: areaNameEl.value || areaNameIni, ids: areaNameIni});
                },

                confirmDeleteDashboard: function (evt, rowID) {
                    evt.stopPropagation();
                    let row = window.List.getRowByID(this.options.ids.list, 'row' + rowID);
                    if (row) {
                        this.deletedDasboardsIds.push(row.readAttribute("itemid"));
                        row.remove();
                    }
                },

                _createDashboard: function (evt) {
                    evt.stopPropagation();
                    if (!hasValue(dashboardNameEl)) {
                        dwGlobal.showControlErrors(dashboardNameEl, options.labels.emptyDashboardName);
                        dashboardNameEl.focus();
                    } else {
                        dialog.hide(this.options.ids.editDashboardNameDlg);
                        if (this._hasChangesOnPage()) {
                            Action.Execute(this.options.actions.confirmSaveToDashboardCreate);
                        }
                        else {
                            this.createDashboard();
                        }
                    }
                    return false;
                },

                saveBeforeDashboardCreate: function () {
                    this._formSubmit("SaveAndCreateDashboard");
                },

                createDashboard: function () {
                    this._formSubmit("CreateDashboard");
                },

                _editDashboardName: function() { },

                editDashboard: function (evt, dashboardId) {
                    if (this._hasChangesOnPage()) {
                        Action.Execute(this.options.actions.confirmSaveToDashboardEdit, { dashboardId: dashboardId });
                    }
                    else {
                        Action.Execute(this.options.actions.editDashboard, { dashboardId: dashboardId });
                    }
                    return true;
                },

                _hasChangesOnPage: function () {
                    return !this.options.areaId || this.deletedDasboardsIds.length || areaNameIni !== areaNameEl.value;
                },

                showEditDashboardName: function (createDashboard) {
                    let dlgTitle = createDashboard ? this.options.labels.createDashboard : this.options.labels.renameDashboard;
                    dwGlobal.hideControlErrors(dashboardNameEl, "");
                    dashboardNameEl.value = "";
                    dialog.setTitle(this.options.ids.editDashboardNameDlg, dlgTitle);
                    if (editDashboardNameDlgOkAction) {
                        let btn = dialog.get_okButton(this.options.ids.editDashboardNameDlg);
                        btn.removeEventListener('click', editDashboardNameDlgOkAction, false);
                    }
                    editDashboardNameDlgOkAction = createDashboard ? this._createDashboard.bind(this) : this._editDashboardName.bind(this);
                    dialog.set_okButtonOnclick(this.options.ids.editDashboardNameDlg, editDashboardNameDlgOkAction);
                    dialog.show(this.options.ids.editDashboardNameDlg);
                    dashboardNameEl.focus();
                }
            };
            obj.init(opts);
            return obj;
        }
    </script>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" ID="Header" DoTranslate="true" Title="Dashboards" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(close);" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" OnClientClick="currentPage.confirmDeleteArea(event);" />
                </dw:Toolbar>
                <dwc:GroupBox runat="server" Title="Indstillinger">
                    <dwc:InputText runat="server" ID="Name" Label="Name" ValidationMessage=""></dwc:InputText>
                    <div class="form-group">
                        <label class="control-label">Dashboards</label>
                        <div class="form-group-input">
                            <dw:List runat="server" ID="lstDashboardsList" AllowMultiSelect="false" HandleSortingManually="false" ShowPaging="false" ShowTitle="false" PageSize="500" NoItemsMessage="No dashboards found">
                                <Columns>
                                    <dw:ListColumn ID="colName" ItemAlign="Left" EnableSorting="true" Name="Name" runat="server" />
                                    <dw:ListColumn ID="colDelete" ItemAlign="Center" HeaderAlign="Right" Name="Slet" Width="45" runat="server" />
                                </Columns>
                            </dw:List>
                            <div class="add-button-container">
                                <dwc:Button runat="server" ID="AddDashboardBtn" OnClick="currentPage.showEditDashboardName(true);" Value="AddDashboard" Title="Add dashboard" DoTranslate="false"  />
                            </div>
                        </div>
                    </div>
                    <dw:Dialog ID="EditDashboardNameDialog" Title="Dashboard name" Size="Small" ShowCancelButton="true" ShowClose="false" runat="server" ShowOkButton="true" OkAction="">
                        <dwc:InputText runat="server" ID="DashboardName" Label="Dashboard name" ValidationMessage=""></dwc:InputText>
                    </dw:Dialog>
                </dwc:GroupBox>
            </dwc:Card>
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
            <input type="hidden" id="Action" name="Action" value="" />
            <input type="hidden" id="DeletedDashboards" name="DeletedDashboards" value="" />
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
