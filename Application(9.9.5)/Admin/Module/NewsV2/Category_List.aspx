<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Category_List.aspx.vb"
    Inherits="Dynamicweb.Admin.NewsV2.Category_List" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Category_List</title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <link rel="Stylesheet" href="css/main.css" />
    <script type="text/javascript" src="js/main.js"></script>
    <script type="text/javascript" src="js/category.js"></script>
    <script type="text/javascript" src="js/news.js"></script>
    <style type="text/css">
        .filterLabel {
            width: 120px !important;
        }
    </style>
    <script type="text/javascript">
        function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("newsv2", "modules.newsv2.general")%>
     }
    </script>
</head>
<body class="screen-container">
    <form id="form1" runat="server">        
        <dw:Toolbar ID="CategoryBar1" runat="server" ShowEnd="false">
            <dw:ToolbarButton ID="AddCategory1" runat="server" Divide="None" Icon="PlusSquare"
                Text="Ny kategori" OnClientClick="category.add();">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="ToolbarButton3" runat="server" Divide="None" Icon="Help" Text="Help"
                OnClientClick="help();">
            </dw:ToolbarButton>
        </dw:Toolbar>
        <dw:List ID="List1" runat="server" UseCountForPaging="true" HandlePagingManually="true" PageSize="25">
            <Filters>
                <dw:ListTextFilter runat="server" ID="TextFilter" WaterMarkText="Search" Width="175"
                    ShowSubmitButton="True" Divide="None" Priority="1" />
                <dw:ListDropDownListFilter ID="PageSizeFilter" Width="150" Label="Categories per page"
                    AutoPostBack="true" Priority="2" runat="server">
                    <Items>
                        <dw:ListFilterOption Text="25" Value="25" Selected="true" DoTranslate="false" />
                        <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                        <dw:ListFilterOption Text="75" Value="75" DoTranslate="false" />
                        <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                        <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                    </Items>
                </dw:ListDropDownListFilter>
            </Filters>
            <Columns>
                <dw:ListColumn ID="ListColumn4" EnableSorting="false" runat="server" Name="" Width="5"></dw:ListColumn>
                <dw:ListColumn ID="NameColumn" EnableSorting="true" runat="server" Name="Name" Width="400"></dw:ListColumn>
                <dw:ListColumn ID="NewsCountColumn" EnableSorting="false" runat="server" Name="News"
                    HeaderAlign="Center" ItemAlign="Center" Width="60"></dw:ListColumn>
                <dw:ListColumn ID="ListColumn1" runat="server" Name="Description"></dw:ListColumn>
            </Columns>
        </dw:List>

        <dw:ContextMenu ID="CategoryMenu" runat="server">
            <dw:ContextMenuButton ID="EditCategory" runat="server" Divide="None" Icon="Pencil"
                Text="Edit category">
            </dw:ContextMenuButton>
            <dw:ContextMenuButton ID="DeleteCategory" runat="server" Divide="Before" Icon="Delete"
                Text="Delete category">
            </dw:ContextMenuButton>
        </dw:ContextMenu>
        <% Translate.GetEditOnlineScript()%>
    </form>
    </body>
</html>
