<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="OrderRefund.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.OrderRefund" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Ecommerce.Orders.Gateways" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeRequireJS="True" runat="server" />
    <script type="text/javascript" src="js/OrderRefund.js"></script>
</head>
<body>
    <form id="RefundDialog" onsubmit="return validateAmount();" runat="server">
        <dw:Infobar runat="server" Type="Error" Message="Refund not allowed" ID="ErrorInfobar" Visible="false"></dw:Infobar>
        <dw:GroupBox runat="server" Title="Information" DoTranslation="true" ID="InformationGroupbox">
            <p>
                <dw:Label doTranslation="False" runat="server" ID="InformationLabel" />
            </p>
        </dw:GroupBox>
        <dwc:GroupBox runat="server" ID="RefundSettingsGroupbox">
            <dwc:RadioGroup runat="server" ID="RefundType" Name="RefundType" SelectedValue="FullRefund" Label="Refund type" >
                <dwc:RadioButton runat="server" Label="Full refund" ClientIDMode="Static" ID="FullRefund" Name="RefundType" FieldName="RefundType" FieldValue="FullRefund"  OnClick="changeAmountDisabledState(true);"/>
                <dwc:RadioButton runat="server" Label="Partial refund" ClientIDMode="Static" ID="PartialRefund" Name="RefundType" FieldName="RefundType" FieldValue="PartialRefund" OnClick="changeAmountDisabledState(false);" />
            </dwc:RadioGroup>
            <dwc:InputNumber ID="RefundAmount" Name="RefundAmount" runat="server" ClientIDMode="Static" IncrementSize="0.01" Disabled="true" Label="Refund amount" />
            <asp:HiddenField runat="server" ID="MaxRefundAmount" ClientIDMode="Static" />
            <dwc:Button runat="server" Title="Refund" ActionType="Submit" />
        </dwc:GroupBox>
        <dw:GroupBox runat="server" Title="History" DoTranslation="true" ID="RefundHistoryGroupbox">
            <dw:List runat="server" ID="OperationsHistory" NoItemsMessage="No refund operatins" Title="Refund operations">
                <Columns>
                    <dw:ListColumn runat="server" Name="Date" Width="140"></dw:ListColumn>
                    <dw:ListColumn runat="server" Name="OperationState" Width="100"></dw:ListColumn>
                    <dw:ListColumn runat="server" Name="Amount" Width="50" ItemAlign="Center"></dw:ListColumn>
                    <dw:ListColumn runat="server" Name="Message"></dw:ListColumn>
                </Columns>
            </dw:List>
        </dw:GroupBox>

        <%  Translate.GetEditOnlineScript()%>
    </form>
</body>
</html>
