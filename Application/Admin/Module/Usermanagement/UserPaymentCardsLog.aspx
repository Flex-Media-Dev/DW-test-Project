<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UserPaymentCardsLog.aspx.vb" Inherits="Dynamicweb.Admin.UserPaymentCardsLog" %>
<%@ Register assembly="Dynamicweb.Controls" namespace="Dynamicweb.Controls" tagprefix="dw" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="DeleteTokenID" name="DeleteTokenID" value="0" />
        <dw:List ID="LogList" runat="server" PageSize ="25" SortDirection="Ascending" Title="Saved Card log">
	    <Columns>
		    <dw:ListColumn ID="DateClmn" runat ="server" Name="Date" Width="150" TranslateName="true" EnableSorting="true">
		    </dw:ListColumn>
		    <dw:ListColumn ID="OrderIDClmn" runat="server" Name="Order" Width="150" TranslateName="true"  EnableSorting="true">
		    </dw:ListColumn>
		    <dw:ListColumn ID="MessageClmn" runat="server" Name="Message" TranslateName="true"  EnableSorting="true">
		    </dw:ListColumn>
		</Columns>
        </dw:List>
    </form>
</body>
</html>
