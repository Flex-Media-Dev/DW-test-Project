<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FavoriteLists.aspx.vb" Inherits="Dynamicweb.Admin.FavoriteLists" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <title></title>

    <dw:ControlResources ID="ControlResources1" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="js/FavoriteLists.js" />
        </Items>
    </dw:ControlResources>
</head>
<body>
<form id="form1" runat="server">
    <input type="hidden" runat="server" id="Action" value="" />
    <input type="hidden" runat="server" id="SelectedList" value="" />
    <div class="card-header">
        <h2 class="subtitle"><%=Translate.Translate("Favorite lists") %></h2>
    </div>
    <dw:Toolbar ID="MainToolbar" runat="server" ShowStart="true" ShowEnd="false" >
        <dw:ToolbarButton ID="cmdAdd" runat="server" Divide="None" Icon="PlusSquare" Text="Add" OnClientClick="favoriteList.addNew();"></dw:ToolbarButton>
    </dw:Toolbar>
    <dw:List ID="FavoriteList" StretchContent="true" ShowTitle="false" runat="server" PageSize="25"
      UseCountForPaging="True" HandleSortingManually="True" HandlePagingManually="True" Personalize="true">
        <Filters>
            <dw:ListTextFilter ID="TextSearchFilter" runat="server" WaterMarkText="Search" />
            <dw:ListUserFilter ID="UserFilter" runat="server" Label="User" AutoPostBack="true"></dw:ListUserFilter>
        </Filters>
        <Columns>
            <dw:ListColumn ID="ListColumn1" runat="server" EnableSorting="true" Name="Name" TranslateName="true" />
            <dw:ListColumn ID="ListColumn2" runat="server" EnableSorting="true" Name="Description" TranslateName="true" />
            <dw:ListColumn ID="ListColumn3" runat="server" EnableSorting="true" Name="Published" TranslateName="true" />
            <dw:ListColumn ID="ListColumn7" runat="server" EnableSorting="true" Name="Published to" TranslateName="true" />
            <dw:ListColumn ID="ListColumn4" runat="server" EnableSorting="true" Name="Type" TranslateName="true" />
            <dw:ListColumn ID="ListColumn5" runat="server" EnableSorting="true" Name="Default" TranslateName="true" />
            <dw:ListColumn ID="ListColumnUser" runat="server" EnableSorting="true" Name="User" TranslateName="true" />
        </Columns>
    </dw:List>

    <dw:ContextMenu ID="FavoriteListMenu" runat="server">
        <dw:ContextMenuButton ID="cmdShowProducts" runat="server" Divide="After" Icon="Search" Text="Show products" OnClientClick="favoriteList.showProducts();" />
        <dw:ContextMenuButton ID="cmdEditList" runat="server" Divide="None" Icon="Pencil" Text="Edit list" OnClientClick="favoriteList.edit();" />
        <dw:ContextMenuButton ID="cmdCopyToUsers" runat="server" Divide="None" Icon="Copy" Text="Copy to users" OnClientClick="favoriteList.copy();" />
        <dw:ContextMenuButton ID="cmdDeleteList" runat="server" Divide="Before" Icon="Delete" Text="Delete" OnClientClick="favoriteList.delete();" />
    </dw:ContextMenu>

    <dw:Dialog ID="CopyDialog" runat="server" Size="Medium" ShowOkButton="True" ShowCancelButton="True" Title="Copy favorite list" OkText="Copy" OkAction="favoriteList.copyComplete();">
        <dwc:GroupBox ID="GroupBox1" runat="server">
            <div class="dw-ctrl input-ctrl form-group">
                <label class="control-label"><dw:TranslateLabel Text="Name" runat="server" /></label>
	            <div class="form-group-input">
                    <span id="OriginalListName"></span>
        	    </div>
            </div>
            <div class="dw-ctrl input-ctrl form-group">
                <label class="control-label"><dw:TranslateLabel Text="Number of products" runat="server" /></label>
	            <div class="form-group-input">
                    <span id="OriginalListProducts"></span>
        	    </div>
            </div>
            <dwc:InputText ID="FavoriteListName" runat="server" Label="New name" ></dwc:InputText>
            <div class="dw-ctrl input-ctrl form-group">
                <label class="control-label"><dw:TranslateLabel ID="CopyToUsersLabel" Text="Select users and/or groups" runat="server" /></label>
	            <div class="form-group-input">
                    <dw:UserSelector ID="CopyToUsers" runat="server"></dw:UserSelector>
                    <span class="help-block error"></span>
        	    </div>
            </div>
        </dwc:GroupBox>
<%--        <iframe id="CopyDialogFrame"></iframe>--%>
    </dw:Dialog>

    <script type="text/javascript">
        favoriteList.action = $('<%= Action.ClientID %>');
        favoriteList.selectedList = $('<%= SelectedList.ClientID %>');
        favoriteList.deleteQuestion = "<%= DeleteQuestion %>";
        favoriteList.isGroupFavorite = "<%= IsGroupFavorite %>" === "True";
    </script>
</form>
</body>
</html>
