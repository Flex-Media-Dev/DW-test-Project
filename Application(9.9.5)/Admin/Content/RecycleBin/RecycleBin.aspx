<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RecycleBin.aspx.vb" Inherits="Dynamicweb.Admin.RecycleBinPage" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>    
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/List/List.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/WaterMark.js" type="text/javascript"></script>
        <script src="/Admin/Content/JsLib/dw/Ajax.js" type="text/javascript"></script>
        <script src="/Admin/Resources/js/layout/dwglobal.js"></script>
    </dwc:ScriptLib>

    <script type="text/javascript">
        function deleteElements(id) {
            var rows = List.getSelectedRows('RecycleList');           
            if (id || rows.length > 0)
            {                
                <%Dim act As Dynamicweb.Core.UI.Actions.Action = Me.GetConfirmEmptyBinAction()
        If Not IsNothing(act) Then%>
                var action = <%=act.ToJson()%>;
                action.OnSubmitted.Function = function(){
                    $("selectedElement").value = id || rows.map(function (el) { return el.attributes['itemid'].value; }).join("|");
                    submitForm("Delete");
                }
                dwGlobal.getContentNavigatorWindow().Action.Execute(action);
                <%End If%> 
            }
        }
    </script>
    <script type="text/javascript" src="RecycleBin.js"></script>
</head>
<body class="area-blue dw8-container">
    <form id="MainForm" runat="server">
        <input type="hidden" id="cmd" name="cmd" runat="server" value="" />
        <input type="hidden" id="selectedElement" name="selectedElement" value="" />
        <dwc:Card runat="server" ID="card">
            <dwc:CardHeader runat="server" Title="Recycle bin"></dwc:CardHeader>

            <dw:Toolbar ID="MainToolbar" runat="server" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="Before" Icon="Delete" Text="Empty selected items" OnClientClick="deleteElements();" ShowWait="false" />
                <dw:ToolbarButton ID="cmdRestore" runat="server" Divide="Before" Icon="Reply" Text="Restore selected items" OnClientClick="restoreElements();" ShowWait="false" />
            </dw:Toolbar>

                <dw:List runat="server" ID="RecycleList" ShowTitle="false" OnRowExpand="OnRowExpand" AllowMultiSelect="true" PageSize="25" OnClientSelect="elementSelected();">
                    <Filters>
                        <dw:ListDropDownListFilter Label="Type" Name="ObjectTypeFilter" ID="ObjectTypeFilter" AutoPostBack="true" runat="server"></dw:ListDropDownListFilter>
                    </Filters>
                    <Columns>
                        <dw:ListColumn ID="colDescription" Width="250" runat="server" Name="Description" EnableSorting="true" />
                        <dw:ListColumn ID="colUser" Width="250" runat="server" Name="User" EnableSorting="true" />
                        <dw:ListColumn ID="colDate" Width="180" runat="server" Name="Deletion Date" EnableSorting="true" />
                        <dw:ListColumn ID="colRestore" Width="70" runat="server" Name="Restore" ItemAlign="Center" EnableSorting="false" />
                    </Columns>
                </dw:List>
            <div class="clearfix"></div>

            <dw:ContextMenu ID="RowContextMenu" runat="server">
                <dw:ContextMenuButton ID="mnuRestore" Icon="Reply" Text="Restore" runat="server" OnClientClick="restoreElements(ContextMenu.callingItemID);" />
                <dw:ContextMenuButton ID="mnuDelete" Icon="Delete" Text="Empty selected item" runat="server" OnClientClick="deleteElements(ContextMenu.callingItemID);" />
            </dw:ContextMenu>
        </dwc:Card>
    </form>
    <dw:Dialog runat="server" ID="FeedbackDialog" Title="Restored items" ShowOkButton="true">
        <ul id="restoredItems">
            <asp:Literal ID="ListItemsPlaceholder" runat="server"></asp:Literal>
        </ul>
    </dw:Dialog>
    <asp:Literal ID="ShowDialogPlaceholder" runat="server"></asp:Literal>
</body>
</html>
