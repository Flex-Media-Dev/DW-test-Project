<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ItemTypeList.aspx.vb" Inherits="Dynamicweb.Admin.ItemTypeList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <dw:ControlResources CombineOutput="False" IncludeClientSideSupport="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
            <dw:GenericResource Url="/Admin/Content/Items/js/ItemTypeList.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/ItemTypeList.css" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        function deleteItemType(itemTypes) {
            var prefix = '<%=ItemTypeNodePrefix%>';
            var act = <%=GetDeleteItemTypeAction()%>;
            var itemIds;

            if(!itemTypes){
                var ids = Dynamicweb.Items.ItemTypeList.get_current().getSelectedItems().split(",");
                for(i=0;i<ids.length;i++){                    
                    ids[i]= prefix + ids[i];
                }
                itemIds = ids.join();
            } else {
                itemIds = prefix + itemTypes;
            }
            if (act) {
                act.Url = act.Url.substring(0, act.Url.indexOf(prefix)) + itemIds;
                Action.Execute(act);
            }
        }
    </script>
</head>
<body class="screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <input type="hidden" id="PostBackAction" name="PostBackAction" value="" />
            <input type="hidden" id="PostBackArgument" name="PostBackArgument" value="" />
            <input type="hidden" id="ItemSystemNames" name="ItemSystemNames" value="" />
            <input type="hidden" id="SelectedItems" name="SelectedItems" runat="server" value="" />

            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Item types"></dwc:CardHeader>
                <dw:Toolbar runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdNew" Icon="PlusSquare" Text="New item type" runat="server" />
                    <dw:ToolbarButton ID="cmdSync" Icon="Refresh" OnClientClick="Dynamicweb.Items.ItemTypeList.get_current().initiatePostBack('Refresh');" Text="Refresh" Divide="After" runat="server" />
                    <dw:ToolbarButton ID="cmdUsage" Icon="AreaChart" OnClientClick="location.href = '/Admin/Content/Items/ItemTypes/ItemTypeUsage.aspx';" Text="Item type usage" Divide="After" runat="server" />
                    <dw:ToolbarButton ID="cmdHelp" Icon="Help" OnClientClick="Dynamicweb.Items.ItemTypeList.help();" Text="Help" runat="server" />
                </dw:Toolbar>
                <dw:Infobar ID="infError" runat="server" Type="Error" Visible="False" TranslateMessage="False"></dw:Infobar>
                <dw:List ID="lstItemTypes" ShowTitle="false" NoItemsMessage="No item types found" ShowPaging="true" PageSize="25" AllowMultiSelect="true" runat="server">
                    <Columns>
                        <dw:ListColumn Name="Name" Width="220" EnableSorting="true" />
                        <dw:ListColumn Name="System name" Width="220" EnableSorting="true" />
                        <dw:ListColumn Name="Inherited from" Width="220" EnableSorting="true" />
                        <dw:ListColumn ItemAlign="Center" ID="Del" HeaderAlign="Center" EnableSorting="false" Name="Delete" Width="80" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
    <dw:ContextMenu ID="cmItem" runat="server" OnClientSelectView="Dynamicweb.Items.ItemTypeList.onContextMenuView">
        <dw:ContextMenuButton ID="cmiEdit" Views="mixed,common" Icon="Pencil" Text="Edit item type" OnClientClick="Dynamicweb.Items.ItemTypeList.get_current().openEditDialog(ContextMenu.callingItemID);" runat="server" />
        <dw:ContextMenuButton ID="cmiCopy" Views="mixed,common" Icon="ContentCopy" Text="Copy" OnClientClick="Dynamicweb.Items.ItemTypeList.get_current().copy(ContextMenu.callingItemID);" runat="server" />
        <dw:ContextMenuButton ID="cmiDelete" Views="common" Icon="Delete" Text="Delete" Divide="Before" OnClientClick="deleteItemType(ContextMenu.callingItemID);" runat="server" />
        <dw:ContextMenuButton ID="cmiDeleteAll" Views="mixed,selection" Icon="Remove" Text="Delete selected" Divide="Before" OnClientClick="deleteItemType();" runat="server" />
    </dw:ContextMenu>

    <dw:Overlay ID="PleaseWait" runat="server" />
</body>
<%Translate.GetEditOnlineScript()%>
</html>
