<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DashboardAreasList.aspx.vb" Inherits="Dynamicweb.Admin.DashboardAreasList" %>

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
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
    <script>
        function createDashboardAreasListPage(opts) {
            let obj = {
                init: function (opts) {
                    this.options = opts;
                    let rows = window.List.getAllRows(this.options.ids.list);
                    rows.each(row => {
                        if (row.classList.contains("system-area")) {
                            row.querySelector(".checkbox").disabled  = true;
                        }
                    });
                },
                confirmDeleteArea: function (evt, rowID) {
                    evt.stopPropagation();
                    let self = this;
                    let ids = window.List.getSelectedRows(this.options.ids.list);
                    let row = null;
                    let confirmStr = "";
                    console.log("confirmDeleteArea");
                    let areasIds = [];
                    if (rowID) {
                        row = window.List.getRowByID(this.options.ids.list, 'row' + rowID);
                        if (row) {
                            confirmStr = row.children[1].innerText ? row.children[1].innerText : row.children[1].innerHTML;
                            confirmStr = confirmStr.replace('&nbsp;', "");
                            confirmStr = confirmStr.replace('&qout;', "");
                            areasIds.push(row.readAttribute("itemid"));
                        }
                    } else if (ids.length > 0) {
                        for (var i = 0; i < ids.length; i++) {
                            if (i != 0) {
                                confirmStr += " ' , '";
                            }
                            row = window.List.getRowByID(this.options.ids.list, ids[i].id);
                            if (row) {
                                confirmStr += row.children[1].innerText ? row.children[1].innerText : row.children[1].innerHTML;
                                confirmStr = confirmStr.replace('&nbsp;', "");
                                confirmStr = confirmStr.replace('&qout;', "");
                                areasIds.push(ids[i].readAttribute("itemid"));
                            }
                        }
                    }
                    confirmStr = "\'" + confirmStr + "\'";
                    Action.Execute(this.options.actions.delete, {
                        ids: areasIds,
                        names: confirmStr
                    });
                },

                areaSelected: function () {
                    if (List && List.getSelectedRows('lstAreasList').length > 0) {
                        Toolbar.setButtonIsDisabled('cmdDelete', false);
                    } else {
                        Toolbar.setButtonIsDisabled('cmdDelete', true);
                    }
                },

                createArea: function () {
                    Action.Execute(this.options.actions.edit, { areaId: "" });
                },

                editArea: function (evt, areaId) {
                    Action.Execute(this.options.actions.edit, { areaId: areaId });
                },

                showPermissionsDialog: function () {
                    Action.Execute(this.options.actions.showPermissions);
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
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Dashboards" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdNew" Icon="PlusSquare" Text="New area" runat="server" OnClientClick="currentPage.createArea();" />
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" OnClientClick="currentPage.confirmDeleteArea(event);" />
                    <dw:ToolbarButton ID="cmdPermissions" Icon="Lock" Text="Permissions" runat="server" Disabled="true" OnClientClick="currentPage.showPermissionsDialog(event);" />
                </dw:Toolbar>
                <dw:List runat="server" ID="lstAreasList" AllowMultiSelect="true" HandleSortingManually="false" ShowPaging="true" ShowTitle="false" PageSize="25" NoItemsMessage="No dashboard areas found" OnClientSelect="currentPage.areaSelected();">
                    <Columns>
                        <dw:ListColumn ID="colName" ItemAlign="Left" EnableSorting="true" Name="Name" runat="server" />
                        <dw:ListColumn ID="colDelete" ItemAlign="Center" HeaderAlign="Right" Name="Slet" Width="45" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>

