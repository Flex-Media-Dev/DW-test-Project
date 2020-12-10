<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CompletionRuleList.aspx.vb" Inherits="Dynamicweb.Admin.CompletionRuleList" %>

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
        </Items>
    </dw:ControlResources>
    <script>
        function createCompletionRulesListPage(opts) {
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },

                createRule: function () {
                    Action.Execute(this.options.actions.create);
                },

                editRule: function (evt, ruleId) {
                    Action.Execute(this.options.actions.edit, { id: ruleId });
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
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Completion rules" />
                <dw:Toolbar ID="MainToolbar" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdNew" Icon="PlusSquare" Text="New completion Rule" runat="server" OnClientClick="currentPage.createRule();" />
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" />
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dw:List runat="server" ID="lstCompletionRuleList" ShowPaging="true" ShowTitle="false" PageSize="25" NoItemsMessage="No completion rules found">
                    <Columns>
                        <dw:ListColumn ID="colName" EnableSorting="true" Name="Name" runat="server" />
                        <dw:ListColumn ID="colDescription" EnableSorting="true" Name="Description" runat="server" />
                        <dw:ListColumn ID="colFieldsCount" EnableSorting="true" Name="Fields Count" runat="server" />
                        <dw:ListColumn ID="colUsage" EnableSorting="true" Name="Usage" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
