<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NamedItemListEdit.aspx.vb" Inherits="Dynamicweb.Admin.NamedItemListEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>
        <dw:TranslateLabel ID="lblTitle" runat="server" Text="Item lists" />
    </title>
    <dw:ControlResources CombineOutput="false" IncludePrototype="true" IncludeScriptaculous="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
            <dw:GenericResource Url="/Admin/Link.js" />
            <dw:GenericResource Url="/Admin/Content/Items/js/NamedItemListEdit.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Validation.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
            <dw:GenericResource Url="/Admin/Content/Items/css/NamedItemListEdit.css" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Item lists" ID="cardTitle"></dwc:CardHeader>
        <dwc:CardBody runat="server">
    <form id="MainForm" runat="server">
        <input type="hidden" id="cmd" name="cmd" value="" />
        <input type="hidden" id="SortIndex" name="SortIndex" value="" />
        <input type="hidden" id="SortOrder" name="SortOrder" value="" />
        <input type="hidden" id="PageNumber" name="PageNumber" value="1" runat="server" />
        <input type="hidden" id="PageSize" name="PageSize" value="20" />

        <dw:Toolbar runat="server" ID="toolbar1" ShowEnd="false" ShowStart="false">
            <dw:ToolbarButton runat="server" Icon="Cancel" Text="Cancel" Translate="false" ID="btnClose" OnClientClick="Dynamicweb.Items.NamedListItemEdit.get_current().close();" />
            <dw:ToolbarButton runat="server" Icon="Delete" Text="Delete selected list" Translate="false" ID="btnDeleteList" OnClientClick="Dynamicweb.Items.NamedListItemEdit.get_current().deleteItemList();" />
            <dw:ToolbarButton runat="server" Icon="PlusSquare" Text="Add list" ID="btnNewList" OnClientClick="Dynamicweb.Items.NamedListItemEdit.get_current().showAddNamedItemListDialog();" />
        </dw:Toolbar>

        <div class="subtitle">
            <label><dw:TranslateLabel ID="TranslateLabel1" Text="List" runat="server" /></label>
            <select id="lstNamedItemLists" class="std" onchange="Dynamicweb.Items.NamedListItemEdit.get_current().loadNamedList();" runat="server"></select>
            <div id="divSearch" runat="server" class="input-group"><div class="form-group-input">
                <label><dw:TranslateLabel ID="TranslateLabel2" Text="Search in list" runat="server" /></label>
                <input id="txtFilter" class="std form-control" runat="server" placeholder="Search" type="text" />
                <button id="btnFilter" type="button" class="btn btn-default input-group-addon" onclick="Dynamicweb.Items.NamedListItemEdit.get_current().loadNamedList();"><i class="<%=Dynamicweb.Core.UI.Icons.KnownIconInfo.ClassNameFor(Dynamicweb.Core.UI.Icons.KnownIcon.Search, True)%>"></i></button>
            </div></div>
        </div>
        <div id="content">
            <asp:Literal ID="litFields" runat="server" />
        </div>

        <dw:Dialog runat="server" ID="AddNamedItemListDialog" Width="460" Title="New named item list" ShowOkButton="true" ShowCancelButton="true" OkAction="Dynamicweb.Items.NamedListItemEdit.get_current().addNamedItemList();">
            <dw:GroupBox ID="GroupBox3" runat="server" Title="Named item list">
                <table style="border-top-width: 0px;">
                    <tr>
                        <td style="width: 170px">
                            <dw:TranslateLabel ID="TranslateLabel3" Text="Name" runat="server" />
                        </td>
                        <td>
                            <input class="std" maxlength="255" style="width: 299px;" id="NamedListName" runat="server" type="text" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 170px">
                            <dw:TranslateLabel ID="TranslateLabel4" Text="Item type" runat="server" />
                        </td>
                        <td>
                            <dw:Richselect ID="NamedListItemType" runat="server" Height="60" Itemheight="60" Width="300" Itemwidth="300">
                            </dw:Richselect>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </dw:Dialog>

    </form>
        </dwc:CardBody>
    </dwc:Card>
    <dw:ContextMenu ID="SortingContextMenu" runat="server">
        <dw:ContextMenuButton ID="cmdSortAscending" Icon="SortAmountAsc" Text="Sort ascending" runat="server" OnClientClick="Dynamicweb.Items.NamedListItemEdit.get_current().sortAscending();" />
        <dw:ContextMenuButton ID="cmdDeselectAll" Icon="SortAmountDesc" Text="Sort descending" runat="server" OnClientClick="Dynamicweb.Items.NamedListItemEdit.get_current().sortDescending();" />
    </dw:ContextMenu>

    <dw:ContextMenu ID="languageSelectorContext" runat="server" MaxHeight="400">
    </dw:ContextMenu>

    <%Translate.GetEditOnlineScript()%>
</body>
</html>
