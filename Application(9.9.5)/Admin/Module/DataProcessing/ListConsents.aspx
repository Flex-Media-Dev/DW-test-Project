<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ListConsents.aspx.vb" Inherits="Dynamicweb.Admin.ListConsents" %>

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
        var ConsentsContext = function () { }

        ConsentsContext.prototype.editConsent = function (id) {
            var url = "EditConsent.aspx?";
            if (id != null) {
                url += "id=" + id + "&";
            }
            var backUrl = escape(this.initQueryString(location.pathname));
            url += "backUrl=" + backUrl;
            document.location = url;
        }

        ConsentsContext.prototype.getSelectedIds = function () {
            var rows = List.getSelectedRows('ConsentsList');
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

        ConsentsContext.prototype.deleteConsent = function () {
            var message = '<%= Translate.JsTranslate("Are you sure you want to delete this consent?") %>';
            var ids = this.getSelectedIds();
            if (typeof (ids) != 'undefined' && ids.indexOf(',') >= 0) {
                message = '<%= Translate.JsTranslate("Are you sure you want to delete this consents?") %>';
            }
            if (confirm(message)) {
                var url = this.initQueryString('ListConsents.aspx?cmd=delete&id=' + ids);
                document.location = url;
            }
        }

        ConsentsContext.prototype.initQueryString = function (loc) {
            queryString.init(loc);
            queryString.set("search", $("hdSearch").value);
            queryString.set("pagenumber", $("hdPageNumber").value);
            queryString.set("pagesize", $("hdPageSize").value);
            queryString.set("sort", $("hdSort").value);
            queryString.set("sortcolid", $("hdSortColId").value);
            queryString.set("sortcoldir", $("hdSortColDir").value);
            return queryString.toString();
        }

        onContextMenuSelectView = function (sender, args) {
            var ret = [];
            var rows = List.getSelectedRows('ConsentsList');
            if (rows.length > 1) {
                ret.push('cmdDeleteSelected');
            }
            else {
                ret.push('cmdEdit');
                ret.push('cmdDelete');
            }
            return ret;
        }

        var __context = new ConsentsContext();
    </script>
</head>
<body class="screen-container">
    <form id="ConsentsListForm" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="CardHeader1" Title="Consents"></dwc:CardHeader>
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
            </dw:Toolbar>
            <dw:List ID="ConsentsList" runat="server" AllowMultiSelect="true" ShowTitle="false" Personalize="true" NoItemsMessage="No consents"
                StretchContent="false" UseCountForPaging="true" HandlePagingManually="true" ContextMenuID="ConsentsContextMenu">
                <Filters>
                    <dw:ListTextFilter ID="TextFilter" Width="250" WaterMarkText="Search for consents" Priority="1" runat="server" />
                    <dw:ListDropDownListFilter runat="server" ID="PageSizeFilter" Label="Consents per page" Width="220" AutoPostBack="true">
                        <Items>
                            <dw:ListFilterOption Text="10" Value="10" DoTranslate="false" />
                            <dw:ListFilterOption Text="25" Value="25" DoTranslate="false" Selected="true" />
                            <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                            <dw:ListFilterOption Text="75" Value="75" DoTranslate="false" />
                            <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                            <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                        </Items>
                    </dw:ListDropDownListFilter>
                </Filters>
            </dw:List>
        </dwc:Card>
        <dw:ContextMenu ID="ConsentsContextMenu" runat="server" OnClientSelectView="onContextMenuSelectView">
            <dw:ContextMenuButton ID="cmdEdit" runat="server" Divide="None" Icon="ViewAgenda" Text="View" OnClientClick="__context.editConsent(ContextMenu.callingItemID);" />
            <dw:ContextMenuButton ID="cmdDeleteSelected" runat="server" Divide="Before" Icon="Delete" Text="Delete selected" OnClientClick="__context.deleteConsent();" />
            <dw:ContextMenuButton ID="cmdDelete" runat="server" Divide="Before" Icon="Delete" Text="Delete" OnClientClick="__context.deleteConsent();" />
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
