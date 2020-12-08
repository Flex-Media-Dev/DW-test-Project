<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="OrderBulkCapture.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.OrderBulkCapture" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/OrderBulkCapture.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="ListPanel">
            <dw:Toolbar runat="server" ID="Toolbar1" ShowEnd="false">
                <dw:ToolbarButton runat="server" ID="btnClose" Icon="TimesCircle" Text="Close" OnClientClick="opener.location.reload(); window.close();" />
            </dw:Toolbar>
            
            <dw:List runat="server" ID="List1" Title="Capture" TranslateTitle="true">
                <Columns>
                    <dw:ListColumn runat="server" Name="Order ID" EnableSorting="false" ID="ListColumn_OrderID" Width="100"/>         
                    <dw:ListColumn runat="server" Name="Capture state" EnableSorting="false" ID="ListColumn_CaptureState" Width="100" />
                    <dw:ListColumn runat="server" Name="Created" EnableSorting="false" ID="ListColumn_OrderDate" Width="150"  />           
                    <dw:ListColumn runat="server" Name="Order state" EnableSorting="false" ID="ListColumn_OrderStateName" Width="100" />
                    <dw:ListColumn runat="server" Name="Company" EnableSorting="false" ID="ListColumn_OrderCustomerCompany"  />
                    <dw:ListColumn runat="server" Name="Customer name" EnableSorting="false" ID="ListColumn_OrderCustomerName" />
                    <dw:ListColumn runat="server" Name="Price" EnableSorting="false" ID="ListColumn_PriceWithCurrencyRate" Width="125"  />
                    <dw:ListColumn runat="server" Name="Payment method" EnableSorting="false" ID="ListColumn_OrderPaymentMethod" Width="100" />
                </Columns>
            </dw:List>
        </div>
        
        <div id="CapturingPanel" style="text-align: center;">
            <div id="LoadingWheel">
                <img src="/Admin/Module/eCom_Catalog/dw7/images/ajaxloading.gif" alt="" />
            </div>
        
            <div id="CounterPanel">
                
            </div>
        </div>
    </form>
    
    <script type="text/javascript">
        var orderStateCaptured = "<%=orderStateCaptured %>";
        var orderStateAlreadyCaptured = "<%=orderStateAlreadyCaptured %>";
        var orderStateFailed = "<%=orderStateFailed %>";
        var orderStateWaiting = "<%=orderStateWaiting %>";
        var orderStateNotSupported = "<%=orderStateNotSupported %>";
        var orderStateInProgress = "<%=orderStateInProgress %>";
        var orderCaptureCounter = "<%=orderCaptureCounter %>";
        var orderCaptureStatus = "<%=orderCaptureStatus %>";
        startCapture();
    </script>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
    %>
</html>
