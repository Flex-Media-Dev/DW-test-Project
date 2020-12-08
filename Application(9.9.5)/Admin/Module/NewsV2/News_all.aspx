<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="News_all.aspx.vb" Inherits="Dynamicweb.Admin.NewsV2.News_all" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <link rel="Stylesheet" href="css/main.css" />
    <script type="text/javascript" src="js/main.js"></script>
    <script type="text/javascript" src="js/news.js"></script>
    <script type="text/javascript" src="js/category.js"></script>
    <script type="text/javascript">
        function help() {
		<%=Dynamicweb.SystemTools.Gui.Help("newsv2", "modules.newsv2.general.news.all")%>
	}

        news.filters = '<% = GetFilters() %>';

    </script>
</head>
<body class="area-deeppurple">
    <div class="screen-container">
        <form id="form1" runat="server">
            <input type="hidden" name="prevpage" id="prevpage" value="<% = Me.pageNumber%>" />
            <input type="hidden" name="showitems" id="showitems" value="<% = Me.showItems %>" />
            <input type="hidden" name="selectedItems" id="selectedItems" value="<% = Me.SelectedItemsStr %>" />
            <dw:StretchedContainer ID="OuterContainer" Scroll="Hidden" Stretch="Fill" Anchor="document"
                runat="server">
                <dw:Toolbar ID="AllNewsTool" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="help" runat="server" OnClientClick="help();" Icon="Help" Text="Help">
                    </dw:ToolbarButton>
                </dw:Toolbar>
                <dw:List ID="List1" StretchContent="true" Title="All news" runat="server" AllowMultiSelect="true"
                    UseCountForPaging="true" HandlePagingManually="true" Personalize="true" PageSize="25">
                    <Filters>
                        <dw:ListTextFilter runat="server" ID="TextFilter" WaterMarkText="Search" Width="175"
                            ShowSubmitButton="True" Divide="None" />
                        <dw:ListDropDownListFilter ID="PageSizeFilter" Width="150" Label="News per page"
                            AutoPostBack="true" Priority="3" runat="server">
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
                        <dw:ListColumn ID="NewsName" runat="server" EnableSorting="true" Name="Name"></dw:ListColumn>
                        <dw:ListColumn ID="NewsActive" runat="server" Name="Active" EnableSorting="true"
                            ItemAlign="Center" HeaderAlign="Center" Width="50"></dw:ListColumn>
                        <dw:ListColumn ID="NewsDate" runat="server" EnableSorting="true" Name="Date" ItemAlign="Center"
                            HeaderAlign="Center" Width="160"></dw:ListColumn>
                        <dw:ListColumn ID="NewsUpdated" runat="server" EnableSorting="true" Name="Updated"
                            ItemAlign="Center" HeaderAlign="Center" Width="160"></dw:ListColumn>
                    </Columns>
                </dw:List>
            </dw:StretchedContainer>
            <dw:ContextMenu ID="NewsMenu" OnClientSelectView="news.listControl.contextMenuView" runat="server">
                <dw:ContextMenuButton ID="EditNewsActive" Views="active_arc,unactive_arc,active_unarc,unactive_unarc"
                    runat="server" Divide="None" Icon="Edit" Text="Edit news">
                </dw:ContextMenuButton>
                <dw:ContextMenuButton ID="CopyNewsActive" Views="active_arc,unactive_arc,active_unarc,unactive_unarc"
                    runat="server" Divide="Before" Icon="Copy" Text="Copy news">
                </dw:ContextMenuButton>
                <dw:ContextMenuButton ID="MoveNewsActive" Views="active_arc,unactive_arc,active_unarc,unactive_unarc"
                    runat="server" Divide="None" Icon="ArrowRight" Text="Move news">
                </dw:ContextMenuButton>
                <dw:ContextMenuButton ID="ArcNews" runat="server" Views="active_arc,unactive_arc"
                    Divide="None" Icon="Archive" Text="Move to Archive">
                </dw:ContextMenuButton>
                <dw:ContextMenuButton ID="UnArcNews" runat="server" Views="active_unarc,unactive_unarc"
                    Divide="None" Icon="Archive" Text="Extract from Archive">
                </dw:ContextMenuButton>
                <dw:ContextMenuButton ID="ActivationNews" Views="active_arc,active_unarc" runat="server"
                    Divide="Before" Icon="Delete" Text="Deactivate">
                </dw:ContextMenuButton>
                <dw:ContextMenuButton ID="DeactivationNews" Views="unactive_arc,unactive_unarc" runat="server"
                    Divide="Before" Icon="Check" Text="Activate">
                </dw:ContextMenuButton>
                <dw:ContextMenuButton ID="DeleteNewsActive" Views="active_arc,unactive_arc,active_unarc,unactive_unarc"
                    runat="server" Divide="Before" Icon="Delete" Text="Delete news">
                </dw:ContextMenuButton>
            </dw:ContextMenu>
            <% Translate.GetEditOnlineScript()%>
        </form>
    </div>
</body>
</html>
