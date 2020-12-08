<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="Dynamicweb.Admin.DataProcessingDefault" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Data Processing</title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeRequireJS="false" IncludeScriptaculous="false" IncludePrototype="false" />
    <script type="text/javascript">
        var DataProcessingTree = new Object();
        DataProcessingTree.contextMenu = new Object();

        DataProcessingTree.getContentFrame = function () {
            return document.getElementById('ContentFrame');
        }
        DataProcessingTree.setContent = function (script, args) {
            var frame = DataProcessingTree.getContentFrame();            
            if (args != null) {
                frame.src = script + args;
            } else {
                frame.src = script;
            }            
        }
        DataProcessingTree.contextMenu.addActivity = function () {
            DataProcessingTree.setContent('EditActivity.aspx');
        }
        DataProcessingTree.activitiesNodeClick = function () {
            navigateContent('ListActivities.aspx');
        }
        DataProcessingTree.consentsNodeClick = function () {
            navigateContent('ListConsents.aspx');
        }

        function navigateContent(url) {
            document.getElementById("ContentFrame").src = url;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <dw:ModuleAdmin runat="server">
            <dw:Tree ID="Tree" runat="server" Title="Data Processing" ShowSubTitle="False" ShowRoot="false" OpenAll="false" UseSelection="true" UseCookies="true" UseLines="true">
                <dw:TreeNode ID="TreeNode1" NodeID="0" runat="server" Name="Root" ParentID="-1" />
            </dw:Tree>
        </dw:ModuleAdmin>
        <dw:ContextMenu OnShow="" ID="ActivitiesContext" runat="server">
            <dw:ContextMenuButton ID="cbAddActivity" runat="server" Divide="None" Icon="PlusSquare" Text="New activity" OnClientClick="DataProcessingTree.contextMenu.addActivity();" />
        </dw:ContextMenu>
        <dw:Overlay ID="waitOverlay" runat="server" ShowWaitAnimation="true" />
    </form>
</body>
</html>
