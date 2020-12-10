<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ProductVersionsList.aspx.vb" Inherits="Dynamicweb.Admin.ProductVersionsList" %>

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
</head>

<body>
    <form id="MainForm" runat="server">
        <dwc:Card runat="server">
            <dw:List runat="server" ID="lstWorkflowsList" ShowPaging="true" Title="Product versions" ShowTitle="true" PageSize="25" NoItemsMessage="No versions found">
                <Filters>
                    <dw:ListDropDownListFilter runat="server" ID="LanguageFilter" Label="Language" Width="150" AutoPostBack="true" />
                    <dw:ListDropDownListFilter runat="server" ID="VariantFilter" Label="Variant" Width="150" AutoPostBack="true" />
                </Filters>
                <Columns>
                    <dw:ListColumn ID="colProcedure" ItemAlign="Center" Name="Version" Width="40" runat="server" />
                    <dw:ListColumn ID="colLanguage" ItemAlign="Center" HeaderAlign="Center" Name="Language" runat="server" />
                    <dw:ListColumn ID="colVariant" Name="Variant" runat="server" />
                    <dw:ListColumn ID="colCreated" Name="Modified" runat="server" />
                    <dw:ListColumn ID="colPublished" Name="Published" runat="server" />
                    <dw:ListColumn ID="colStatus" Name="Status" runat="server" />
                    <dw:ListColumn ID="colCompare" ItemAlign="Center" HeaderAlign="Center" Name="Compare" Width="40" CssClass="pointer" runat="server" />
                    <dw:ListColumn ID="colRollback" ItemAlign="Center" HeaderAlign="Center" Name="Rollback" Width="40" runat="server" />
                </Columns>
            </dw:List>
        </dwc:Card>
    </form>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
