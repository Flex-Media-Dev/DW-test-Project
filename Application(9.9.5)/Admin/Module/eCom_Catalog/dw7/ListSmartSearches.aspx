<%@ Page Title="" Language="vb" AutoEventWireup="false" CodeBehind="ListSmartSearches.aspx.vb" Inherits="Dynamicweb.Admin.ListSmartSearches" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeRequireJS="True" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />

            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/Main.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ProductListEditingExtended.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/productMenu.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/EditorWrapper.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript" src="js/ProductListEditingExtended.js"></script>
    <script type="text/javascript">
        function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("", "ecom.productlist.edit.bulk", "en") %>
        }

        var controlRows = [];
        var currentlyFocused = "";
    </script>
</head>
<body>
    <div class="screen-container">
        <div class="card">
            <div class="card-header">
                <h2>
                    <dw:TranslateLabel Text="Queries" runat="server" />
                </h2>
            </div>
            <form runat="server">
                <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton runat="server" Divide="None" Icon="PlusSquare" Text="New Query" ID="cmdNew" />
                </dw:Toolbar>
                <dw:List ID="SmartSearchList" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                    <Filters></Filters>
                    <Columns>
                        <dw:ListColumn ID="NameColumn" runat="server" Name="Navn" EnableSorting="true" />
                        <dw:ListColumn ID="IdColumn" runat="server" Name="ID" EnableSorting="true" />
                    </Columns>
                </dw:List>
            </form>
        </div>
    </div>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
