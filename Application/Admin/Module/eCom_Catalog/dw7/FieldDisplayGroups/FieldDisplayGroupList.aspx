<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FieldDisplayGroupList.aspx.vb" Inherits="Dynamicweb.Admin.FieldDisplayGroupList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

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
        </Items>
    </dw:ControlResources>
    <script>
        function createEditFieldDisplayGroupPage(opts) {
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },

                createPreset: function () {
                    Action.Execute(this.options.actions.create);
                },

                editPreset: function (evt, PresetId) {
                    Action.Execute(this.options.actions.edit, { id: PresetId });
                },

                presetSelected: function () {
                    if (List && List.getSelectedRows('lstFieldDisplayGroupList').length > 0) {
                        Toolbar.setButtonIsDisabled('cmdDelete', false);
                    } else {
                        Toolbar.setButtonIsDisabled('cmdDelete', true);
                    }
                },
                confirmDeletePreset: function (evt) {
                    evt.stopPropagation();
                    var ids = window.List.getSelectedRows(this.options.ids.list);
                    var row = null;
                    var confirmStr = "";
                    var presetIds = [];
                    if (ids.length > 0) {
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
                        name: confirmStr
                    });
                },
                sortPresets: function (evt) {
                    evt.stopPropagation();
                    location.href='../Lists/EcomSortList.aspx?CMD=FieldDisplayGroup'
                },
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
                <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dw:List runat="server" ID="lstFieldDisplayGroupList" AllowMultiSelect="false" ShowPaging="true" ShowTitle="false" PageSize="25" NoItemsMessage="No field display groups found" OnClientSelect="currentPage.presetSelected();">
                    <Columns>
                        <dw:ListColumn ID="colName" EnableSorting="true" Name="Name" runat="server" />
                        <dw:ListColumn ID="colSystemName" EnableSorting="true" Name="System Name" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
