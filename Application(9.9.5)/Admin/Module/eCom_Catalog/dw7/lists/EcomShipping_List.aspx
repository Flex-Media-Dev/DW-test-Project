<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomShipping_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomShipping_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
    <script type="text/javascript">
        function copyShipping() {
            document.location = 'EcomShipping_List.aspx?copyShipping=true&shippingID=' + ContextMenu.callingItemID;
        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <input type="hidden" name="selctedRowID" id="selctedRowID" />
            <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>

            <dw:ContextMenu ID="ShippingContext" runat="server">
                <dw:ContextMenuButton ID="cmdCreateCopy" runat="server" Divide="None" Icon="Copy" Text="Create copy" OnClientClick="copyShipping();" />
            </dw:ContextMenu>

            <div>

                <dw:List ID="ShippingsList" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                    <Filters></Filters>
                    <Columns>
                        <dw:ListColumn ID="colName" runat="server" Name="Navn" EnableSorting="true" />
                        <dw:ListColumn ID="colActive" runat="server" Name="Active" EnableSorting="true" Width="300" />
                    </Columns>
                </dw:List>

            </div>
        </form>
    </div>
</body>
</html>