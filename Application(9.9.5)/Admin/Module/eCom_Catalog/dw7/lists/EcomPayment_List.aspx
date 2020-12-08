<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomPayment_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomPayment_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
    <script type="text/javascript">
        function copyPayment() {
            document.location = 'EcomPayment_List.aspx?copyPayment=true&paymentID=' + ContextMenu.callingItemID;
        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <input type="hidden" name="selctedRowID" id="selctedRowID" />
<ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
            <asp:Literal ID="BoxStart" runat="server"></asp:Literal>
            <dw:List ID="List1" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="50">
                <Filters></Filters>
                <Columns>
                    <dw:ListColumn ID="colName" runat="server" Name="Navn" EnableSorting="true" />
                    <dw:ListColumn ID="colActive" runat="server" Name="Active" EnableSorting="true" Width="200" />
                    <dw:ListColumn ID="colProvider" runat="server" Name="Checkout Handler" EnableSorting="true" />
                    <dw:ListColumn ID="colCountryrates" runat="server" Name="Lande" EnableSorting="true" />
                </Columns>
            </dw:List>

            <dw:ContextMenu ID="PaymentContextMenu" runat="server">
                <dw:ContextMenuButton ID="cmdCreateCopy" runat="server" Divide="None" Icon="Copy" Text="Create copy" OnClientClick="copyPayment();" />
            </dw:ContextMenu>
        </form>
    </div>
</body>
</html>