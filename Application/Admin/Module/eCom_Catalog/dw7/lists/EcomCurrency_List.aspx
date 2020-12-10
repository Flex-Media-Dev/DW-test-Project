<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomCurrency_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomCurrency_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server">
            <input type="hidden" name="selctedRowID" id="selctedRowID" />
            <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
            <dw:List ID="List1" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                <Filters></Filters>
                <Columns>
                    <dw:ListColumn ID="colCode" runat="server" Name="Valutakode" EnableSorting="true" Width="150" />
                    <dw:ListColumn ID="colName" runat="server" Name="Navn" EnableSorting="true" />
                    <dw:ListColumn ID="colCulture" runat="server" Name="Regional info" EnableSorting="true" Width="150" />
                    <dw:ListColumn ID="colSymbol" runat="server" Name="Symbol" EnableSorting="true" Width="100" />
                    <dw:ListColumn ID="colDisplay" runat="server" Name="Positive pattern" EnableSorting="true" Width="150" />
                    <dw:ListColumn ID="colDisplayNegative" runat="server" Name="Negative pattern" EnableSorting="true" Width="150" />
                    <dw:ListColumn ID="colKurs" runat="server" Name="Kurs" EnableSorting="true" />
                    <dw:ListColumn ID="colStandard" runat="server" Name="Standard" EnableSorting="true" />
                </Columns>
            </dw:List>
        </form>
    </div>
</body>
</html>