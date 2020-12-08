<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GiftCardTransactionsList.aspx.vb" Inherits="Dynamicweb.Admin.GiftCards.GiftCardTransactionsList" %>


<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <link href="../css/Main.css" rel="stylesheet" />
    <style type="text/css" >
        .subheader div{
            float:right !important;
            margin-right: 5px;
        }
    </style>
    <script type="text/javascript">
        function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("", "administration.managementcenter.eCommerce.orders.giftcards")%>
        }
        function returnToList() {
            location.href = 'GiftCardsList.aspx';
        }
    </script>
</head>
<body>
<div style="overflow:auto; min-width:600px;">
    <form id="form2" runat="server">

        <dw:List ID="GiftCardTransactionsLst" ShowFooter="true" runat="server" TranslateTitle="True" StretchContent="true" PageSize="25" ShowPaging="true" AllowMultiSelect="true" Title="Transactions">
            <Columns>
			    <dw:ListColumn ID="colOrderID" runat="server" Name="OrderID" EnableSorting="true" WidthPercent="58"/>
			    <dw:ListColumn ID="colDate" runat="server" Name="Date" EnableSorting="true" WidthPercent="27" />
			    <dw:ListColumn ID="colAmount" runat="server" Name="Amount" EnableSorting="true" ItemAlign="Right" WidthPercent="10" />
            </Columns>
        </dw:List>

        <%Translate.GetEditOnlineScript()%>
    </form>
   </div> 
</body>
</html>