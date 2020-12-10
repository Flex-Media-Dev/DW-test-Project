<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SettingPresetsList.aspx.vb" Inherits="Dynamicweb.Admin.SettingPresetsList" %>

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
        function createPresetListPage(opts) {
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },

                confirmDeletePresets: function (evt, rowID) {
                    evt.stopPropagation();
                    var self = this;
                    var ids = window.List.getSelectedRows(this.options.ids.list);
                    var row = null;
                    var confirmStr = "";
                    rowID = rowID || window.ContextMenu.callingID;
                    var presetIds = [];
                    if (rowID) {
                        row = window.List.getRowByID(this.options.ids.list, 'row' + rowID);
                        if (row) {
                            confirmStr = row.children[1].innerText ? row.children[1].innerText : row.children[1].innerHTML;
                            confirmStr = confirmStr.replace('&nbsp;', "");
                            confirmStr = confirmStr.replace('&qout;', "");
                            presetIds.push(rowID);
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
                                presetIds.push(ids[i].readAttribute("itemid"));
                            }
                        }
                    }
                    confirmStr = "\'" + confirmStr + "\'";
                    Action.Execute(this.options.actions.delete, {
                        ids: presetIds,
                        names: confirmStr
                    });
                },

                presetsSelected: function () {
                    const listId = this.options.ids.list;
                    let selectedRows = List.getSelectedRows(listId);

                    const selectAllCheckbox = document.getElementById('chk_all_' + listId);
                    if (selectAllCheckbox && selectAllCheckbox.checked) {
                        selectAllCheckbox.checked = true;
                    }

                    if (List && selectedRows.length > 0) {
                        Toolbar.setButtonIsDisabled('cmdDelete', false);
                    } else {
                        Toolbar.setButtonIsDisabled('cmdDelete', true);
                    }
                }, 

                editPreset: function (evt, presetId) {
                    Action.Execute(this.options.actions.edit, { PresetId: presetId });
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
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Presets" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" OnClientClick="currentPage.confirmDeletePresets(event);" />
                </dw:Toolbar>
                <dw:List runat="server" ID="lstPresetsList" AllowMultiSelect="true" HandleSortingManually="false" ShowPaging="true" ShowTitle="false" PageSize="25" NoItemsMessage="No presets found" OnClientSelect="currentPage.presetsSelected();">
                    <Columns>
                        <dw:ListColumn ID="colProcedure" EnableSorting="true" Name="Name" runat="server" />
                        <dw:ListColumn ID="colSteps" ItemAlign="Center" EnableSorting="true" Name="Function" Width="45" runat="server" />
                        <dw:ListColumn ID="colCreated" EnableSorting="true" Name="Assigned to" Width="200" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
