<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomLoyaltyUserTransaction_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomLoyaltyUserTransaction_Edit" %>
<%@ Register assembly="Dynamicweb.Controls" namespace="Dynamicweb.Controls" tagprefix="dw" %>
<%@ Register assembly="Dynamicweb.UI.Controls" namespace="Dynamicweb.UI.Controls" tagprefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server" IncludePrototype="true" IncludeUIStylesheet ="true">
        <Items>
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/EcomLoyaltyUserTransaction_Edit.js" />
        </Items>
    </dw:ControlResources>
    <script>
        var parentDialog = parent.document.getElementById('NewTransactionDialog');
        var okButton = $(parentDialog).select('button.dialog-button-ok')[0];
        var cancelButton = $(parentDialog).select('button.dialog-button-cancel')[0];
        Event.observe(okButton, 'click', function () { Dynamicweb.eCommerce.Loyalty.Transactions.createTransaction(<%=UserID %>); });
        Event.observe(cancelButton, 'click', function () { Dynamicweb.eCommerce.Loyalty.Transactions.closeWindow(); });
    </script>
</head>
<body>
    <div id="containerNP" class="hidden"><dw:Infobar runat="server" ID="NoPoints" Type="Warning"  TranslateMessage="true" Message="User does not have enough points"/></div>
    <div id="containerED" class="hidden"><dw:Infobar runat="server" ID="EmptyData"   Type="Information" TranslateMessage ="true"  Message="Points is required" /></div> 
    <form id="form1" class="border" runat="server">
        <dwc:GroupBox runat="server" Title="New transaction">
            <dwc:InputText runat="server" ID="pointsNum" Label="Points"></dwc:InputText>
            <dwc:InputText runat="server" ID="transactionComment" Label="Comment"></dwc:InputText>
        </dwc:GroupBox>
    </form>
</body>
</html>
