<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="Dynamicweb.Admin.BasicForum._Default" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <script type="text/javascript" src="js/tree.js"></script>
    <script type="text/javascript" src="js/default.js"></script>

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
<body>
    <form id="form1" runat="server" style="height: 100%;">
        <dw:ModuleAdmin runat="server">
            <dw:Tree ID="Tree1" runat="server"  ShowSubTitle="False" Title="Forum" ShowRoot="false" OpenAll="false" UseSelection="true" UseCookies="false" LoadOnDemand="true" UseLines="true">
                <dw:TreeNode NodeID="0" runat="server" Name="Root" ParentID="-1">
                </dw:TreeNode>
            </dw:Tree>
        </dw:ModuleAdmin>

        <dw:Dialog runat="server" ID="permissionEditDialog" Size="Small" Title="Edit permissions" ShowClose="true" HidePadding="true" ShowOkButton="true" ShowCancelButton="true">
            <iframe id="permissionEditDialogFrame"></iframe>
        </dw:Dialog>
    </form>

    <dw:ContextMenu ID="CategoryContext" runat="server" OnClientSelectView="menuActions.contextMenuView">
        <dw:ContextMenuButton ID="NewThreadContextMenuButton" runat="server" Divide="After" Icon="PlusSquare" Text="New Thread" OnClientClick="menuActions.addThread();" Views="activate_cat,deactivate_cat"></dw:ContextMenuButton>
        <dw:ContextMenuButton ID="EditCategoryContextMenuButton" runat="server" Divide="None" Icon="Pencil" Text="Edit category" OnClientClick="menuActions.editCategory();" Views="activate_cat,deactivate_cat"></dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ActivateCategoryContextMenuButton" runat="server" Divide="None" Icon="Check" Text="Activate category" Views="activate_cat" OnClientClick="menuActions.activateCategoryMenu(true)"></dw:ContextMenuButton>
        <dw:ContextMenuButton ID="DeactivateCAtegoryContextMenuButton" runat="server" Divide="None" Icon="Close" Text="Deactivate category" Views="deactivate_cat" OnClientClick="menuActions.activateCategoryMenu(false)"></dw:ContextMenuButton>
        <dw:ContextMenuButton ID="DeleteCategoryContextMenuButton" runat="server" Divide="Before" Icon="Delete" Text="Delete category" Views="activate_cat,deactivate_cat" OnClientClick="menuActions.deleteCategory();"></dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:ContextMenu ID="AreaContext" runat="server">
        <dw:ContextMenuButton ID="ContextMenuButton2" runat="server" Divide="None" Icon="PlusSquare" Text="New category" OnClientClick="menuActions.addCategory();"></dw:ContextMenuButton>
    </dw:ContextMenu>

    <script type="text/javascript">
        <% If Dynamicweb.Core.Converter.ToString(Dynamicweb.Context.Current.Request("CMD")) = "EditCategory" Then%>
        menuActions.editCategory(<%=Dynamicweb.Core.Converter.ToInt32(Dynamicweb.Context.Current.Request("CategoryID"))%>);
        <% Else%>
        menuActions.listCategory();
        <% End If%>
    </script>
    <% Translate.GetEditOnlineScript()%>
</body>
</html>
