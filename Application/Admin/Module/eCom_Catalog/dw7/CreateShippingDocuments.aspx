<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CreateShippingDocuments.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.CreateShippingDocuments" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/CreateShippingDocuments.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="ListPanel">
            <dw:Toolbar runat="server" ID="Toolbar" ShowEnd="false">
                <dw:ToolbarButton runat="server" ID="btnClose" Icon="TimesCircle" Text="Close" OnClientClick="opener.location.reload(); window.close();" />
            </dw:Toolbar>

            <dw:List runat="server" ID="OrderList" Title="Shipping documents" TranslateTitle="true">
                <Columns>
                    <dw:ListColumn runat="server" Name="Order ID" EnableSorting="false" ID="ListColumn_OrderID" Width="100"/>
                    <dw:ListColumn runat="server" Name="Created" EnableSorting="false" ID="ListColumn_OrderDate" Width="150"  />
                    <dw:ListColumn runat="server" Name="Order state" EnableSorting="false" ID="ListColumn_OrderStateName" Width="100" />
                    <dw:ListColumn runat="server" Name="Company" EnableSorting="false" ID="ListColumn_OrderCustomerCompany"  />
                    <dw:ListColumn runat="server" Name="Customer name" EnableSorting="false" ID="ListColumn_OrderCustomerName" />
                    <dw:ListColumn runat="server" Name="Price" EnableSorting="false" ID="ListColumn_PriceWithCurrencyRate" Width="125"  />
                    <dw:ListColumn runat="server" Name="Shipping method" EnableSorting="false" ID="ListColumn_ShippingMethod" Width="100" />
                    <dw:ListColumn runat="server" Name="Shipping document info" EnableSorting="false" ID="ListColumn_ShippingDocumentInfo" Width="100" />
                </Columns>
            </dw:List>
        </div>

        <div id="ProgressPanel" style="text-align: center; position: fixed; top: 25%; left: 25%; width: 50%; background: white">
            <div id="LoadingWheel">
                <img src="/Admin/Module/eCom_Catalog/dw7/images/ajaxloading.gif" alt="" />
            </div>

            <div id="CounterPanel">

            </div>
        </div>
    </form>

    <script type="text/javascript">
			var orderProcessingMessage = "<%= Dynamicweb.Core.Helpers.StringHelper.JSEnable(orderProcessingMessage) %>";
      var processingCompletedMessage = "<%= Dynamicweb.Core.Helpers.StringHelper.JSEnable(processingCompletedMessage) %>";
    </script>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
    %>
</html>
