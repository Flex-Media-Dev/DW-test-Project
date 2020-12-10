<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ListActivities.aspx.vb" Inherits="Dynamicweb.Admin.ListActivities" %>

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
        var ActivitiesContext = function () { }

        ActivitiesContext.prototype.editActivity = function (id) {
            var url = "EditActivity.aspx?";
            if (id != null) {
                url += "id=" + id + "&";
            }
            queryString.init(location.pathname);
            queryString.set("search", $("hdSearch").value);
            queryString.set("pagenumber", $("hdPageNumber").value);
            queryString.set("pagesize", $("hdPageSize").value);
            queryString.set("sort", $("hdSort").value);
            queryString.set("sortcolid", $("hdSortColId").value);
            queryString.set("sortcoldir", $("hdSortColDir").value);
            var backUrl = escape(queryString.toString());
            url += "backUrl=" + backUrl;
            document.location = url;
        }

        ActivitiesContext.prototype.getSelectedIds = function () {
            var rows = List.getSelectedRows('ActivitiesList');
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

        ActivitiesContext.prototype.deleteActivity = function () {
            var message = '<%= Translate.JsTranslate("Are you sure you want to delete this activity?") %>';
            var ids = this.getSelectedIds();
            if (typeof (ids) != 'undefined' && ids.indexOf(',') >= 0) {
                message = '<%= Translate.JsTranslate("Are you sure you want to delete this activities?") %>';
            }
            if (confirm(message)) {
                document.location = 'ListActivities.aspx?cmd=delete&id=' + ids;
            }
        }

        onContextMenuSelectView = function (sender, args) {
            var ret = [];
            var rows = List.getSelectedRows('ActivitiesList');
            if (rows.length > 1) {
                ret.push('cmdDeleteSelected');
            }
            else {
                ret.push('cmdEdit');
                ret.push('cmdDelete');
                ret.push('cmdNew');
            }
            return ret;
        }

        var __context = new ActivitiesContext();
    </script>
</head>
<body class="screen-container">
    <form id="ActivitiesListForm" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="CardHeader1" Title="Activities"></dwc:CardHeader>
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdAdd" runat="server" Divide="None" Icon="PlusSquare" OnClientClick="__context.editActivity();" Text="Add" />
            </dw:Toolbar>
            <dw:List ID="ActivitiesList" runat="server" AllowMultiSelect="true" ShowTitle="false" Title="Activities" Personalize="true" NoItemsMessage="No activities"
                StretchContent="false" UseCountForPaging="true" HandlePagingManually="true" ContextMenuID="ActivitiesContextMenu">
                <Filters>
                    <dw:ListTextFilter ID="TextFilter" Width="250" WaterMarkText="Search for activities" Priority="1" runat="server" />
                    <dw:ListDropDownListFilter runat="server" ID="PageSizeFilter" Label="Activities per page" Width="220" AutoPostBack="true">
                        <Items>
                            <dw:ListFilterOption Text="25" Value="25" DoTranslate="false" Selected="true" />
                            <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                            <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                            <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                        </Items>
                    </dw:ListDropDownListFilter>
                </Filters>
            </dw:List>
        </dwc:Card>
        <dw:ContextMenu ID="ActivitiesContextMenu" runat="server" OnClientSelectView="onContextMenuSelectView">
            <dw:ContextMenuButton ID="cmdEdit" runat="server" Divide="None" Icon="Pencil" Text="Edit" OnClientClick="__context.editActivity(ContextMenu.callingItemID);" />
            <dw:ContextMenuButton ID="cmdDeleteSelected" runat="server" Divide="Before" Icon="Delete" Text="Delete selected" OnClientClick="__context.deleteActivity();" />
            <dw:ContextMenuButton ID="cmdDelete" runat="server" Divide="Before" Icon="Delete" Text="Delete" OnClientClick="__context.deleteActivity();" />
            <dw:ContextMenuButton ID="cmdNew" runat="server" Divide="Before" Icon="PlusSquare" Text="New activity" OnClientClick="__context.editActivity();" />
        </dw:ContextMenu>

        <input type="hidden" id="hdSearch" name="hdSearch" value="<%= GetSearchText() %>" />
        <input type="hidden" id="hdPageNumber" name="hdPageNumber" value="<%= PageNumber %>" />
        <input type="hidden" id="hdPageSize" name="hdPageSize" value="<%= PageSize %>" />
        <input type="hidden" id="hdSort" name="hdSort" value="<%= OrderBy %>" />
        <input type="hidden" id="hdSortColId" name="hdSortColId" value="<%= SortColID %>" />
        <input type="hidden" id="hdSortColDir" name="hdSortColDir" value="<%= CInt(SortColDir).ToString() %>" />
    </form>
</body>
</html>
