<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UserAndGroupTypeList.aspx.vb" Inherits="Dynamicweb.Admin.UserAndGroupTypeList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <dw:ControlResources CombineOutput="False" IncludeClientSideSupport="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <title></title>
    <script>
        function editUserType(systemName) {
            systemName = systemName || '';
            document.location.href = 'UserAndGroupTypeEdit.aspx?SystemName=' + systemName;
        }

        function deleteUserType(systemName) {
            document.location.href = 'UserAndGroupTypeList.aspx?cmd=deleteUserType&SystemName=' + systemName;
        }

        function help() {
            <%= Gui.HelpPopup("", "UserAndGroupTypes.List") %>
        }
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="User and group types" />
        <dw:Toolbar runat="server">
            <dw:ToolbarButton runat="server" Icon="PlusSquare" Text="New user and group type" OnClientClick="editUserType();" />
            <dw:ToolbarButton runat="server" Icon="Help" Text="Help" OnClientClick="help();" />
        </dw:Toolbar>
        <dwc:CardBody runat="server">
            <form id="form1" runat="server">
                <dw:List runat="server" ID="UserAndGroupTypes" ShowTitle="false">
                    <Columns>
                        <dw:ListColumn runat="server" Name="Name" EnableSorting="true" />
                        <dw:ListColumn runat="server" Name="System name" EnableSorting="true" />
                    </Columns>
                </dw:List>
            </form>
        </dwc:CardBody>
    </dwc:Card>

    <dw:ContextMenu runat="server" ID="ListActions">
        <dw:ContextMenuButton runat="server" ID="EditUserTypeCmd" Icon="Pencil" Text="Edit user and group type" OnClientClick="editUserType(ContextMenu.callingItemID);" />
        <dw:ContextMenuButton runat="server" ID="DeleteUserTypeCmd" Icon="Delete" Text="Delete" OnClientClick="deleteUserType(ContextMenu.callingItemID);" />
    </dw:ContextMenu>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
