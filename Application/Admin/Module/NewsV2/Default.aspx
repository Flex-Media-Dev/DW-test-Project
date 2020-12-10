<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="Dynamicweb.Admin.NewsV2._Default6" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <script type="text/javascript" src="js/main.js"></script>
    <script type="text/javascript" src="js/category.js"></script>
    <script type="text/javascript" src="js/news.js"></script>

    <script>
        function collapseTree(e) {
            var treeContainer = document.getElementById('treeContainer');
            var contentContainer = document.getElementsByClassName('ContentFrameContainer')[0];
            var cellTreeCollapsed = document.getElementById('cellTreeCollapsed');

            if (treeContainer.classList.contains('collapsed')) {
                treeContainer.classList.remove('collapsed');
                contentContainer.classList.remove('collapsed');
                cellTreeCollapsed.classList.add('hidden');
            } else {
                treeContainer.classList.add('collapsed');
                contentContainer.classList.add('collapsed');
                cellTreeCollapsed.classList.remove('hidden');
            }
        }
    </script>
</head>
<body class="area-deeppurple">
    <form id="form1" runat="server" style="height: 100%;">
    <dw:ModuleAdmin ID="ModuleAdmin1" runat="server">
        <dw:Tree ID="Tree1" runat="server" ShowSubTitle="False" Title="Navigation" ShowRoot="false"
            OpenAll="false" UseSelection="true" UseCookies="false" LoadOnDemand="true" UseLines="true"
            ClientNodeComparator="function() {return 0;}">
            <dw:TreeNode ID="Root" NodeID="0" runat="server" Name="Root" ParentID="-1" />
        </dw:Tree>
    </dw:ModuleAdmin>
    <dw:Dialog runat="server" ID="permissionEditDialog" Width="316" Title="Edit permissions"
        ShowClose="true" HidePadding="true">
        <iframe id="permissionEditDialogFrame" style="width: 100%;"></iframe>
    </dw:Dialog>
    </form>
    <dw:ContextMenu ID="CategoryContext" runat="server">
        <dw:ContextMenuButton ID="EditCategory" runat="server" Divide="None" Icon="Pencil"
            Text="Edit category">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="AddNews" runat="server" Divide="None" Icon="PlusSquare"
            Text="Ny nyhed">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="DeleteCategory" runat="server" Divide="Before" Icon="Delete"
            Text="Delete category">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="Permissions" runat="server" Divide="Before" Icon="Lock"
            Text="Edit permissions">
        </dw:ContextMenuButton>
    </dw:ContextMenu>
    <dw:ContextMenu ID="NewsContextActive" runat="server">
        <dw:ContextMenuButton ID="AddNewsAct" runat="server" Divide="None" Icon="PlusSquare"
            Text="Ny nyhed">
        </dw:ContextMenuButton>
    </dw:ContextMenu>
    <dw:ContextMenu ID="NewsContextArc" runat="server">
        <dw:ContextMenuButton ID="AddNewsArc" runat="server" Divide="None" Icon="PlusSquare"
            Text="Ny nyhed">
        </dw:ContextMenuButton>
    </dw:ContextMenu>
    <dw:ContextMenu ID="DefaultMenu" runat="server">
        <dw:ContextMenuButton ID="AddCategory" runat="server" Divide="None" Icon="PlusSquare"
            Text="New category" OnClientClick="category.addClick();">
        </dw:ContextMenuButton>
    </dw:ContextMenu>
    <% Translate.GetEditOnlineScript()%>
</body>
</html>
