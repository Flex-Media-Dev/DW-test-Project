<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomLoyaltyUserTransaction_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomLoyaltyUserTransaction_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<!DOCTYPE html>

<html>
<head>
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="../js/ecomLists.js" />
        </Items>
    </dw:ControlResources>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server">
            <dw:List ID="tList" runat="server" PageSize="25" SortDirection="Ascending">
                <Columns>
                    <dw:ListColumn ID="utDate" runat="server" Name="Date" TranslateName="true" Width="150" EnableSorting="true"></dw:ListColumn>
                    <dw:ListColumn ID="utReward" runat="server" Name="Reward" TranslateName="true" Width="150" EnableSorting="true"></dw:ListColumn>
                    <dw:ListColumn ID="utPoints" runat="server" Name="Points" TranslateName="true" Width="150" EnableSorting="true"></dw:ListColumn>
                    <dw:ListColumn ID="utExpires" runat="server" Name="Expires" TranslateName="true" Width="150" EnableSorting="true"></dw:ListColumn>
                    <dw:ListColumn ID="utComment" runat="server" Name="Comment" TranslateName="true" Width="150" EnableSorting="true"></dw:ListColumn>
                </Columns>
            </dw:List>
            <dw:Dialog ID="NewTransactionDialog" runat="server" Title="Create new transaction" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true">
                <iframe id="NewTransactionDialogFrame" src="/Admin/Module/eCom_Catalog/dw7/edit/EcomLoyaltyUserTransaction_Edit.aspx?userID=<%=UserID %>" frameborder="0"></iframe>
            </dw:Dialog>
        </form>
    </div>
</body>
</html>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
