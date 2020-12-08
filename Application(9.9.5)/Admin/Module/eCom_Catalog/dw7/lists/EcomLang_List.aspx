<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomLang_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomLang_List" %>

<%@ Import Namespace="Dynamicweb.Security.Permissions" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript" src="../js/ecomLists.js"></script>
    <script>
        var act = <%= New Dynamicweb.Management.Actions.ShowPermissionsAction(New Dynamicweb.Ecommerce.International.Language()).ToJson() %>;
        function openPermissionsDialog(languageId) {
            act.PermissionKey = languageId;
            Action.Execute(act);            
        }
        
        function openVirtualPermissionsDialog() {
            <%= GetVirtualPermissionsShowAction() %>
        }        
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server">
            <input type="hidden" name="selctedRowID" id="selctedRowID" />
            <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
            <dw:List ID="List1" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                <Filters></Filters>
                <Columns>
                    <dw:ListColumn ID="colName" runat="server" Name="Navn" EnableSorting="true" Width="300" />
                    <dw:ListColumn ID="colNativeName" runat="server" Name="Egennavn" EnableSorting="true" />
                    <dw:ListColumn ID="colIsDefault" runat="server" Name="Standard" EnableSorting="true" />
                </Columns>
            </dw:List>
        </form>
    </div>

    <dw:ContextMenu runat="server" ID="LanguageContextMenu">
        <dw:ContextMenuButton ID="PermissionsContextMenuButton" Icon="Lock" Text="Permissions" OnClientClick="openPermissionsDialog(ContextMenu.callingItemID);" runat="server"></dw:ContextMenuButton>
    </dw:ContextMenu>
</body>
</html>