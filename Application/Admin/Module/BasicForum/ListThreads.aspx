<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ListThreads.aspx.vb" Inherits="Dynamicweb.Admin.BasicForum.ListThreads" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <link rel="stylesheet" href="css/main.css" />
    <script type="text/javascript" src="js/message.js"></script>
    <script type="text/javascript" src="js/default.js"></script>
    <script type="text/javascript" src="js/category.js"></script>
    <script type="text/javascript" src="js/listThreads.js"></script>
    <script type="text/javascript">
        function help() {
		    <%=Gui.Help("", "modules.dw8.forum.general.thread.list") %>
        }

        message.filters = '<% = GetFilters() %>';
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <form runat="server">
            <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false">
                <dw:ToolbarButton ID="NewThreadToolBar" runat="server" Divide="None" Icon="PlusSquare" Text="New thread" OnClientClick=""></dw:ToolbarButton>
                <dw:ToolbarButton ID="EditCategoryToolBar" runat="server" Divide="None" Icon="Pencil" Text="Edit category" OnClientClick="menuActions.editCategory();"></dw:ToolbarButton>
                <dw:ToolbarButton ID="CategoriesToolBar" runat="server" Divide="None" Icon="FolderO" Text="Categories" OnClientClick="message.listCategory();"></dw:ToolbarButton>
                <dw:ToolbarButton ID="HelpToolbar" runat="server" Divide="None" Icon="Help" Text="Help" OnClientClick="help();"></dw:ToolbarButton>
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dw:List ID="List1" runat="server" TranslateTitle="false" Title="Threads" PageSize="25">
                    <Filters>
                        <dw:ListTextFilter runat="server" ID="TextFilter" WaterMarkText="Search" Width="175"
                            ShowSubmitButton="True" Divide="None" Priority="1" />
                        <dw:ListDropDownListFilter ID="PageSizeFilter" Width="150" Label="Threads per page"
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
                        <dw:ListColumn ID="ListColumn6" runat="server" Name="" Width="10"></dw:ListColumn>
                        <dw:ListColumn ID="NameColumn" EnableSorting="true" runat="server" Name="Tråd" Width="0"></dw:ListColumn>
                        <dw:ListColumn ID="AuthorColumn" EnableSorting="true" runat="server" Name="Forfatter" Width="0"></dw:ListColumn>
                        <dw:ListColumn ID="ActiveColumn" EnableSorting="true" runat="server" Name="Active" HeaderAlign="Center" ItemAlign="Center" Width="60"></dw:ListColumn>
                        <dw:ListColumn ID="CreatedDateColumn" EnableSorting="true" runat="server" Name="Oprettet" Width="130"></dw:ListColumn>
                        <dw:ListColumn ID="LastReplyColumn" EnableSorting="true" runat="server" Name="Last reply" Width="130"></dw:ListColumn>
                        <dw:ListColumn ID="AnswerColumn" EnableSorting="true" runat="server" Name="Svar" HeaderAlign="Center" ItemAlign="Center" Width="50"></dw:ListColumn>
                    </Columns>
                </dw:List>
            </dwc:CardBody>
            <dw:ContextMenu ID="ThreadContextMenu" runat="server" OnClientSelectView="listThreads.listControl.contextMenuView">
                <dw:ContextMenuButton ID="EditThreadBtn" runat="server" Divide="After" Icon="Pencil" Text="Edit thread" Views="unsticky,sticky"></dw:ContextMenuButton>
                <dw:ContextMenuButton ID="UnstickyThreadBtn" runat="server" Divide="None" Icon="ThumbTack" Text="UnStick" Views="unsticky"></dw:ContextMenuButton>
                <dw:ContextMenuButton ID="StickyThreadBtn" runat="server" Divide="None" Icon="ThumbTack" Text="Sticky" Views="sticky"></dw:ContextMenuButton>
                <dw:ContextMenuButton ID="DeleteThreadBtn" runat="server" Divide="Before" Icon="Delete" Text="Delete thread" Views="unsticky,sticky"></dw:ContextMenuButton>
            </dw:ContextMenu>
            <%Translate.GetEditOnlineScript()%>
        </form>
    </dwc:Card>
</body>
</html>
