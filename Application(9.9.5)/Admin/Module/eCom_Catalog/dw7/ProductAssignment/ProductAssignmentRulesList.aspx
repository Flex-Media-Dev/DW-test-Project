<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ProductAssignmentRulesList.aspx.vb" Inherits="Dynamicweb.Admin.ProductAssignmentRulesList" %>


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
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/ProductAssignment/ProductAssignmentRulesList.js" />
        </Items>
    </dw:ControlResources>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Product assignment rules" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdNew" Icon="PlusSquare" Text="New rule" runat="server" OnClientClick="currentPage.createAssignmentRule(event);" />
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" />
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dw:List runat="server" ID="lstAssignmentRulesList" AllowMultiSelect="false" HandleSortingManually="false" ShowPaging="true" ShowTitle="false" PageSize="25" NoItemsMessage="No assignment rules found">
                    <Columns>
                        <dw:ListColumn ID="colName" EnableSorting="true" Name="Name" runat="server" />
                        <dw:ListColumn ID="colIsActive" ItemAlign="Center" HeaderAlign="Right" Name="Active" Width="45" runat="server" />
                        <dw:ListColumn ID="colDelete" ItemAlign="Center" HeaderAlign="Right" Name="Slet" Width="45" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
