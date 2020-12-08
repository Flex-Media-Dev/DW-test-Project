<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WorkflowsList.aspx.vb" Inherits="Dynamicweb.Admin.WorkflowsList" %>

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
        function createWorkflowListPage(opts) {
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },
                confirmDeleteWorkflows: function (evt, rowID) {
                    evt.stopPropagation();
                    var self = this;
                    var ids = window.List.getSelectedRows(this.options.ids.list);
                    var row = null;
                    var confirmStr = "";
                    rowID = rowID || window.ContextMenu.callingID;
                    var workflowIds = [];
                    var workflowsInUse = false;
                    if (rowID) {
                        row = window.List.getRowByID(this.options.ids.list, 'row' + rowID);
                        if (row) {
                            confirmStr = row.children[0].innerText ? row.children[0].innerText : row.children[0].innerHTML;
                            confirmStr = confirmStr.replace('&nbsp;', "");
                            confirmStr = confirmStr.replace('&qout;', "");
                            workflowIds.push(rowID);
                            workflowsInUse = row.classList.contains("workflow-in-use");
                        }
                    } else if (ids.length > 0) {
                        for (var i = 0; i < ids.length; i++) {
                            if (i != 0) {
                                confirmStr += " ' , '";
                            }
                            row = window.List.getRowByID(this.options.ids.list, ids[i].id);
                            if (row) {
                                confirmStr += row.children[0].innerText ? row.children[0].innerText : row.children[0].innerHTML;
                                confirmStr = confirmStr.replace('&nbsp;', "");
                                confirmStr = confirmStr.replace('&qout;', "");
                                workflowIds.push(ids[i].readAttribute("itemid"));
                                if (!workflowsInUse) {
                                    workflowsInUse = row.classList.contains("workflow-in-use");
                                }
                            }
                        }
                    }
                    if (!workflowsInUse) {
                        confirmStr = "\'" + confirmStr + "\'";
                        Action.Execute(this.options.actions.delete, {
                            ids: workflowIds,
                            names: confirmStr
                        });
                    }
                },

                createWorkflow: function () {
                    Action.Execute(this.options.actions.edit, { id: "" });
                },

                editWorkflow: function (evt, workflowId) {
                    Action.Execute(this.options.actions.edit, { WorkflowId: workflowId });
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
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Workflows" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdNew" Icon="PlusSquare" Text="New workflow" runat="server" OnClientClick="currentPage.createWorkflow();" />
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" />
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dw:List runat="server" ID="lstWorkflowsList" AllowMultiSelect="false" HandleSortingManually="false" ShowPaging="true" ShowTitle="false" PageSize="25" NoItemsMessage="No workflows found">
                    <Columns>
                        <dw:ListColumn ID="colProcedure" EnableSorting="true" Name="Procedure" runat="server" />
                        <dw:ListColumn ID="colSteps" ItemAlign="Center" EnableSorting="true" Name="States" Width="45" runat="server" />
                        <dw:ListColumn ID="colCreated" EnableSorting="true" Name="Oprettet" Width="200" runat="server" />
                        <dw:ListColumn ID="colInUse" ItemAlign="Center" HeaderAlign="Right" Name="I brug" Width="45" runat="server" />
                        <dw:ListColumn ID="colDelete" ItemAlign="Center" HeaderAlign="Right" Name="Slet" Width="45" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
