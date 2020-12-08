<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EndpointsList.aspx.vb" Inherits="Dynamicweb.Admin.EndpointsList" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/queryString.js"></script>
    <script type="text/javascript">
        var EndpointsContext = function () { }

        EndpointsContext.prototype.editEndpoint = function (id) {
            var url = generateUrl("EditEndpoint.aspx", id);
            document.location = url;
        }

        EndpointsContext.prototype.editEndpoints = function () {
            var url = generateUrl("EndpointListEditing.aspx", null);
            url += "&OrderBy=<%=OrderBy%>";
            document.location = url;
        }

        EndpointsContext.prototype.testEndpoint = function (id) {
            var url = generateUrl("TestEndpoint.aspx", id);
            document.location = url;
        }

        EndpointsContext.prototype.getSelectedIds = function () {
            var rows = List.getSelectedRows('EndpointsList');
            return getSelectedIds(rows);
            return ret;
        }

        EndpointsContext.prototype.deleteEndpoint = function () {
            var message = '<%= Translate.JsTranslate("Are you sure you want to delete this endpoint?") %>';
            var ids = this.getSelectedIds();
            if (typeof (ids) != 'undefined' && ids.indexOf(',') >= 0) {
                message = '<%= Translate.JsTranslate("Are you sure you want to delete this endpoints?") %>';
            }
            if (confirm(message)) {
                document.location = 'EndpointsList.aspx?cmd=deleteEndpoint&id=' + ids;
            }
        }

        var AuthenticationContext = function () { }

        AuthenticationContext.prototype.editEndpointAuthentication = function (id) {
            var url = generateUrl("EditEndpointAuthentication.aspx", id);
            document.location = url;
        }

        AuthenticationContext.prototype.getSelectedIds = function () {
            var rows = List.getSelectedRows('AuthenticationsList');
            return getSelectedIds(rows);
            return ret;
        }

        AuthenticationContext.prototype.deleteEndpointAuthentication = function () {
            var message = '<%= Translate.JsTranslate("Are you sure you want to delete this authentication?") %>';
                var ids = this.getSelectedIds();
                if (typeof (ids) != 'undefined' && ids.indexOf(',') >= 0) {
                    message = '<%= Translate.JsTranslate("Are you sure you want to delete this authentications?") %>';
            }
            if (confirm(message)) {
                document.location = 'EndpointsList.aspx?cmd=deleteAuthentication&id=' + ids;
            }
        }

        onEndpointsContextMenuSelectView = function (sender, args) {
            var ret = [];
            var rows = List.getSelectedRows('EndpointsList');
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

        onAuthenticationsContextMenuSelectView = function (sender, args) {
            var ret = [];
            var rows = List.getSelectedRows('AuthenticationsList');
            if (rows.length > 1) {
                ret.push('cmdDeleteSelectedAuthentication');
            }
            else {
                ret.push('cmdEdiAuthenticationt');
                ret.push('cmdDeleteAuthentication');
                ret.push('cmdNewAuthentication');
            }
            return ret;
        }

        generateUrl = function (url, id) {
            url = url + "?";
            if (id != null) {
                url += "id=" + id + "&";
            }
            queryString.init(location.pathname);
            queryString.set("pagenumber", $("hdPageNumber").value);
            queryString.set("pagesize", $("hdPageSize").value);
            queryString.set("sort", $("hdSort").value);
            queryString.set("sortcolid", $("hdSortColId").value);
            queryString.set("sortcoldir", $("hdSortColDir").value);

            queryString.set("apagenumber", $("hdAuthenticationPageNumber").value);
            queryString.set("apagesize", $("hdAuthenticationPageSize").value);
            queryString.set("asort", $("hdAuthenticationSort").value);
            queryString.set("asortcolid", $("hdAuthenticationSortColId").value);
            queryString.set("asortcoldir", $("hdAuthenticationSortColDir").value);

            var backUrl = escape(queryString.toString());
            url += "backUrl=" + backUrl;
            return url;
        }

        getSelectedIds = function (rows) {            
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

        var __endpointContext = new EndpointsContext();
        var __authenticationContext = new AuthenticationContext();
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <dwc:Card runat="server">
                <!--<dwc:CardHeader runat="server" ID="CardHeader1" Title="Endpoints"></dwc:CardHeader>-->
                <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="cmdAdd" runat="server" Divide="None" Icon="PlusSquare" OnClientClick="__endpointContext.editEndpoint();" Text="Add Endpoint" />
                    <dw:ToolbarButton ID="cmdBulkEdit" runat="server" Divide="None" Icon="Edit" OnClientClick="__endpointContext.editEndpoints();" Text="Edit endpoints" />
                    <dw:ToolbarButton ID="ToolbarButton1" runat="server" Divide="None" Icon="PlusSquare" OnClientClick="__authenticationContext.editEndpointAuthentication();" Text="Add authentication" />
                </dw:Toolbar>
                <dwc:GroupBox runat="server" ID="EndpointsListGroupBox" Title="Endpoints">
                    <dw:List ID="EndpointsList" runat="server" AllowMultiSelect="true" ShowTitle="false" Title="Endpoints" Personalize="true" NoItemsMessage="No endpoints"
                        StretchContent="false" UseCountForPaging="true" HandlePagingManually="true" ContextMenuID="EndpointsContextMenu" OnPageIndexChanged="EndpointPageIndexChanged">
                        <Columns>
                            <dw:ListColumn ID="EndpointName" runat="server" Name="Name" EnableSorting="true" Width="300" />
                            <dw:ListColumn ID="EndpointDescription" runat="server" Name="Description" EnableSorting="true" />
                            <dw:ListColumn ID="EndpointUrl" runat="server" Name="Url" EnableSorting="true" />
                            <dw:ListColumn ID="EndpointAuthentication" runat="server" Name="Authentication" EnableSorting="true" />
                            <dw:ListColumn ID="colTest" Width="30" runat="server" Name="Test" HeaderAlign="Center" ItemAlign="Center" CssClass="pointer" />
                        </Columns>
                        <Filters>
                            <dw:ListDropDownListFilter runat="server" ID="PageSizeFilter" Label="Endpoints per page" Width="220" AutoPostBack="true">
                                <Items>
                                    <dw:ListFilterOption Text="10" Value="10" DoTranslate="false" Selected="true" />
                                    <dw:ListFilterOption Text="20" Value="25" DoTranslate="false" />
                                    <dw:ListFilterOption Text="30" Value="50" DoTranslate="false" />
                                </Items>
                            </dw:ListDropDownListFilter>
                        </Filters>
                    </dw:List>
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" ID="AuthenticationsListGroupBox" Title="Authentications" Expandable="true" IsCollapsed="false">
                    <dw:List ID="AuthenticationsList" runat="server" AllowMultiSelect="true" ShowTitle="false" Title="Authentications" Personalize="true" NoItemsMessage="No endpoint authentications"
                        StretchContent="false" UseCountForPaging="true" HandlePagingManually="true" ContextMenuID="EndpointAuthenticationsContextMenu" OnPageIndexChanged="AuthenticationPageIndexChanged">
                        <Columns>
                            <dw:ListColumn ID="EndpointAuthenticationName" runat="server" Name="Name" EnableSorting="true" />
                            <dw:ListColumn ID="EndpointAuthenticationType" runat="server" Name="Type" EnableSorting="true" />
                        </Columns>
                        <Filters>
                            <dw:ListDropDownListFilter runat="server" ID="AuthenticationPageSizeFilter" Label="Authentications per page" Width="220" AutoPostBack="true">
                                <Items>
                                    <dw:ListFilterOption Text="10" Value="10" DoTranslate="false" Selected="true" />
                                    <dw:ListFilterOption Text="20" Value="25" DoTranslate="false" />
                                    <dw:ListFilterOption Text="30" Value="50" DoTranslate="false" />
                                </Items>
                            </dw:ListDropDownListFilter>
                        </Filters>
                    </dw:List>
                </dwc:GroupBox>
            </dwc:Card>

            <dw:ContextMenu ID="EndpointsContextMenu" runat="server" OnClientSelectView="onEndpointsContextMenuSelectView">
                <dw:ContextMenuButton ID="cmdEdit" runat="server" Divide="None" Icon="Pencil" Text="Edit" OnClientClick="__endpointContext.editEndpoint(ContextMenu.callingItemID);" />
                <dw:ContextMenuButton ID="cmdDeleteSelected" runat="server" Divide="Before" Icon="Delete" Text="Delete selected" OnClientClick="__endpointContext.deleteEndpoint();" />
                <dw:ContextMenuButton ID="cmdDelete" runat="server" Divide="Before" Icon="Delete" Text="Delete" OnClientClick="__endpointContext.deleteEndpoint();" />
                <dw:ContextMenuButton ID="cmdNew" runat="server" Divide="Before" Icon="PlusSquare" Text="New endpoint" OnClientClick="__endpointContext.editEndpoint();" />
            </dw:ContextMenu>

            <dw:ContextMenu ID="EndpointAuthenticationsContextMenu" runat="server" OnClientSelectView="onAuthenticationsContextMenuSelectView">
                <dw:ContextMenuButton ID="cmdEditAuthentication" runat="server" Divide="None" Icon="Pencil" Text="Edit" OnClientClick="__authenticationContext.editEndpointAuthentication(ContextMenu.callingItemID);" />
                <dw:ContextMenuButton ID="cmdDeleteSelectedAuthentication" runat="server" Divide="Before" Icon="Delete" Text="Delete selected" OnClientClick="__authenticationContext.deleteEndpointAuthentication();" />
                <dw:ContextMenuButton ID="cmdDeleteAuthentication" runat="server" Divide="Before" Icon="Delete" Text="Delete" OnClientClick="__authenticationContext.deleteEndpointAuthentication();" />
                <dw:ContextMenuButton ID="cmdNewAuthentication" runat="server" Divide="Before" Icon="PlusSquare" Text="New authentication" OnClientClick="__authenticationContext.editEndpointAuthentication();" />
            </dw:ContextMenu>

            <input type="hidden" id="hdPageNumber" name="hdPageNumber" value="<%= PageNumber %>" />
            <input type="hidden" id="hdPageSize" name="hdPageSize" value="<%= PageSize %>" />
            <input type="hidden" id="hdSort" name="hdSort" value="<%= OrderBy %>" />
            <input type="hidden" id="hdSortColId" name="hdSortColId" value="<%= SortColID %>" />
            <input type="hidden" id="hdSortColDir" name="hdSortColDir" value="<%= CInt(SortColDir).ToString() %>" />

            <input type="hidden" id="hdAuthenticationPageNumber" name="hdAuthenticationPageNumber" value="<%= AuthenticationPageNumber %>" />
            <input type="hidden" id="hdAuthenticationPageSize" name="hdAuthenticationPageSize" value="<%= AuthenticationPageSize %>" />
            <input type="hidden" id="hdAuthenticationSort" name="hdAuthenticationSort" value="<%= AuthenticationOrderBy %>" />
            <input type="hidden" id="hdAuthenticationSortColId" name="hdAuthenticationSortColId" value="<%= AuthenticationSortColID %>" />
            <input type="hidden" id="hdAuthenticationSortColDir" name="hdAuthenticationSortColDir" value="<%= CInt(AuthenticationSortColDir).ToString() %>" />
        </form>
    </div>
</body>
</html>
