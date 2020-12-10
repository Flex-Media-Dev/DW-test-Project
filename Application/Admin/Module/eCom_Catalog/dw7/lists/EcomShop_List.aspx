<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomShop_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomShop_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ecomLists.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        var act = <%= New Dynamicweb.Management.Actions.ShowPermissionsAction(New Dynamicweb.Ecommerce.Shops.Shop()).ToJson() %>;
        function openPermissionsDialog(shopId) {
            act.PermissionKey = shopId;
            Action.Execute(act);            
        }
        
        function openAllShopsPermissionsDialog() {
            <%= GetVirtualPermissionsShowAction() %>
        }   
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <input type="hidden" name="selctedRowID" id="selctedRowID" />
            <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>

            <dw:List ID="List1" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                <Filters></Filters>
                <Columns>
                    <dw:ListColumn ID="colName" runat="server" Name="Navn" EnableSorting="true" Width="300" />
                    <dw:ListColumn ID="colCreated" runat="server" Name="Oprettet" EnableSorting="true" />
                    <dw:ListColumn ID="colStandard" runat="server" Name="Standard" EnableSorting="true" />
                </Columns>
            </dw:List>

        </form>
    </div>

    <dw:ContextMenu runat="server" ID="ShopContextMenu">
        <dw:ContextMenuButton ID="PermissionsContextMenuButton" Icon="Lock" Text="Permissions" OnClientClick="openPermissionsDialog(ContextMenu.callingItemID);" runat="server"></dw:ContextMenuButton>
    </dw:ContextMenu>

    <%If Dynamicweb.Context.Current.Request("didDeleteAll") = "False" Then%>
    <script type="text/javascript">
        alert('<%=Translate.JsTranslate("Not all items were deleted due to insufficient permissions.") %>');
    </script>
    <%End If%>
</body>
</html>
