<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="Dynamicweb.Admin.DataPortabilityDefault" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Data Portability</title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeRequireJS="false" IncludeScriptaculous="false" IncludePrototype="false" />
    <script type="text/javascript">
        var DataPortabilityTree = new Object();
        DataPortabilityTree.contextMenu = new Object();

        DataPortabilityTree.getContentFrame = function () {
            return document.getElementById('ContentFrame');
        }
        DataPortabilityTree.setContent = function (script, args) {
            var frame = DataPortabilityTree.getContentFrame();            
            if (args != null) {
                frame.src = script + args;
            } else {
                frame.src = script;
            }            
        }
        DataPortabilityTree.contextMenu.addDataDefinition = function () {
            DataPortabilityTree.setContent('EditDataDefinition.aspx');
        }

        DataPortabilityTree.contextMenu.editDataDefinition = function (id) {
            DataPortabilityTree.setContent('EditDataDefinition.aspx?id=' + id);
        }

        DataPortabilityTree.contextMenu.addDataGroup = function (id) {
            DataPortabilityTree.setContent('EditDataGroup.aspx?definitionId=' + id);
        }

        DataPortabilityTree.contextMenu.deleteDataDefinition = function (id) {
            if (confirm('<%=Translate.JsTranslate("Are you sure you want to delete this data definition?")%>')) {
                var frm = document.getElementById("form1");
                document.getElementById("PostBackAction").value = ("DeleteDataDefinition:" + id);
                frm.submit();
            }            
        }                
        
        DataPortabilityTree.contextMenu.addDataItemType = function (id) {
            DataPortabilityTree.setContent('EditDataItemType.aspx?id=' + id);
        }

        DataPortabilityTree.contextMenu.editDataGroup = function (id) {
            DataPortabilityTree.setContent('EditDataGroup.aspx?id=' + id);
        }

        DataPortabilityTree.contextMenu.deleteDataGroup = function (id) {
            if (confirm('<%=Translate.JsTranslate("Are you sure you want to delete this data group?")%>')) {
                var frm = document.getElementById("form1");
                document.getElementById("PostBackAction").value = ("DeleteDataGroup:" + id);
                frm.submit();
            }
        }        

        DataPortabilityTree.dataGroupNodeClick = function (id) {
            navigateContent('ListDataItemTypes.aspx?id=' + id);
        }

        function navigateContent(url) {
            document.getElementById("ContentFrame").src = url;
        }

        function submitReload(type, id, edit) {
            var url = "Default.aspx?type=" + type + "&id=" + id;
            if (edit != null) {
                url += "&edit=" + edit;
            }
            document.getElementById('form1').action = url;
            document.getElementById('form1').submit();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <dw:ModuleAdmin runat="server">
            <dw:Tree ID="Tree" runat="server" Title="Data Portability" ShowSubTitle="False" ShowRoot="false" OpenAll="false" UseSelection="true" UseCookies="true" UseLines="true">
                <dw:TreeNode ID="TreeNode1" NodeID="0" runat="server" Name="Root" ParentID="-1" />
            </dw:Tree>
        </dw:ModuleAdmin>
        <dw:ContextMenu OnShow="" ID="DataDefinitionsContext" runat="server">
            <dw:ContextMenuButton ID="cbAddDataDefinition" runat="server" Divide="None" Icon="PlusSquare" Text="New data definition" OnClientClick="DataPortabilityTree.contextMenu.addDataDefinition();" />
        </dw:ContextMenu>
        <dw:ContextMenu OnShow="" ID="DataDefinitionContext" runat="server">            
            <dw:ContextMenuButton ID="ContextMenuButton1" runat="server" Divide="None" Icon="Edit" Text="Edit definition" OnClientClick="DataPortabilityTree.contextMenu.editDataDefinition(ContextMenu.callingItemID);" />
            <dw:ContextMenuButton ID="ContextMenuButton2" runat="server" Divide="None" Icon="Delete" Text="Delete definition" OnClientClick="DataPortabilityTree.contextMenu.deleteDataDefinition(ContextMenu.callingItemID);" />
            <dw:ContextMenuButton ID="ContextMenuButton3" runat="server" Divide="None" Icon="PlusSquare" Text="Add data group" OnClientClick="DataPortabilityTree.contextMenu.addDataGroup(ContextMenu.callingItemID);" />
        </dw:ContextMenu>        
        <dw:ContextMenu OnShow="" ID="DataGroupContext" runat="server">            
            <dw:ContextMenuButton ID="ContextMenuButton4" runat="server" Divide="None" Icon="Edit" Text="Edit group" OnClientClick="DataPortabilityTree.contextMenu.editDataGroup(ContextMenu.callingItemID);" />
            <dw:ContextMenuButton ID="ContextMenuButton5" runat="server" Divide="None" Icon="Delete" Text="Delete group" OnClientClick="DataPortabilityTree.contextMenu.deleteDataGroup(ContextMenu.callingItemID);" />
            <dw:ContextMenuButton ID="ContextMenuButton6" runat="server" Divide="None" Icon="PlusSquare" Text="Add data item type" OnClientClick="DataPortabilityTree.contextMenu.addDataItemType(ContextMenu.callingItemID);" />
        </dw:ContextMenu>
        <dw:Overlay ID="waitOverlay" runat="server" ShowWaitAnimation="true" />
        <asp:HiddenField ID="PostBackAction" runat="server" />
    </form>
</body>
</html>
