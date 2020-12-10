<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ListDataItemTypes.aspx.vb" Inherits="Dynamicweb.Admin.ListDataGroups" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" />
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/queryString.js"></script>
    <script type="text/javascript">
        var DataItemTypesContext = function () { }

        DataItemTypesContext.prototype.editDataItemType = function (id) {
            var url = "EditDataItemType.aspx?";
            if (id != null) {
                url += "id=" + id;
            }
            var backUrl = escape(this.initQueryString(location.pathname));
            url += "&backUrl=" + backUrl;
            document.location = url;
        }

        DataItemTypesContext.prototype.getSelectedIds = function () {
            var rows = List.getSelectedRows('DataItemTypesList');
            var ret = '', id = '';

            if (rows && rows.length > 0) {
                for (var i = 0; i < rows.length; i++) {
                    id = rows[i].id;
                    if (id != null && id.length > 0) {
                        ret += (id + ',')
                    }
                }
            }

            if (ret.length > 0) {
                ret = ret.substring(0, ret.length - 1);
            }
            else {
                ret = ContextMenu.callingItemID;
            }

            return ret;
        }

        DataItemTypesContext.prototype.deleteDataItemType = function () {
            var message = '<%= Translate.JsTranslate("Are you sure you want to delete this Data Item Type?") %>';
            var ids = this.getSelectedIds();
            if (typeof (ids) != 'undefined' && ids.indexOf(',') >= 0) {
                message = '<%= Translate.JsTranslate("Are you sure you want to delete this Data Item Types?") %>';
            }
            if (confirm(message)) {
                var url = this.initQueryString('ListDataItemTypes.aspx?cmd=delete');
                url += '&deleteIds=' + ids;
                url += '&id=<%=GetDataGroupIdentifier(CurrentDataGroup) %>';
                document.location = url;                
            }
        }

        DataItemTypesContext.prototype.addDataItemType = function () {       
            var url = 'EditDataItemType.aspx?id=<%=GetDataGroupIdentifier(CurrentDataGroup) %>';                
            var backUrl = escape(this.initQueryString(location.pathname));
            url += "&backUrl=" + backUrl;
            document.location = url;            
        }

        DataItemTypesContext.prototype.initQueryString = function (loc) {
            queryString.init(loc);            
            queryString.set("pagenumber", $("hdPageNumber").value);                        
            return queryString.toString();
        }

        onContextMenuSelectView = function (sender, args) {
            var ret = [];
            var rows = List.getSelectedRows('DataItemTypesList');
            if (rows.length > 1) {
                ret.push('cmdDeleteSelected');
            }
            else {
                ret.push('cmdEdit');
                ret.push('cmdDelete');
            }
            return ret;
        }

        var __context = new DataItemTypesContext();
    </script>
</head>
<body class="screen-container">
    <form id="ListDataItemTypesForm" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="CardHeader1" Title="Data Item Types"></dwc:CardHeader>
             <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdAdd" runat="server" Divide="None" Icon="PlusSquare" OnClientClick="__context.addDataItemType();" Text="Add" />
            </dw:Toolbar>
            <dw:List ID="DataItemTypesList" runat="server" AllowMultiSelect="true" ShowTitle="false" Personalize="true" NoItemsMessage="No data item types"
                StretchContent="false" HandlePagingManually="false" ContextMenuID="DataItemTypesContextMenu">
            </dw:List>
        </dwc:Card>
        <dw:ContextMenu ID="DataItemTypesContextMenu" runat="server" OnClientSelectView="onContextMenuSelectView">
            <dw:ContextMenuButton ID="cmdEdit" runat="server" Divide="None" Icon="ViewAgenda" Text="Edit" OnClientClick="__context.editDataItemType(ContextMenu.callingItemID);" />
            <dw:ContextMenuButton ID="cmdDeleteSelected" runat="server" Divide="Before" Icon="Delete" Text="Delete selected" OnClientClick="__context.deleteDataItemType();" />
            <dw:ContextMenuButton ID="cmdDelete" runat="server" Divide="Before" Icon="Delete" Text="Delete" OnClientClick="__context.deleteDataItemType();" />
        </dw:ContextMenu>

        <input type="hidden" id="hdPageNumber" name="hdPageNumber" value="<%= PageNumber %>" />                        
    </form>
</body>
</html>
