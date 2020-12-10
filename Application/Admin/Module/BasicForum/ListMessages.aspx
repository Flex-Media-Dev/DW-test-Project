<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ListMessages.aspx.vb"
    Inherits="Dynamicweb.Admin.BasicForum.ListMessages" %>

<%@ Import Namespace="Dynamicweb" %>
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
    <style type="text/css">
        body {
            border-left: 1px solid transparent;
            border-right: 1px solid transparent;
        }
    </style>
    <script type="text/javascript" src="js/message.js"></script>
    <script type="text/javascript" src="js/category.js"></script>
    <script type="text/javascript" src="js/default.js"></script>
    <script type="text/javascript">
        function help() {
		    <%=Gui.Help("", "forum.dw8.modules.general.post.list") %>
        }

        message.filters = '<% = GetFilters() %>';
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <form runat="server">
            <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false">
                <dw:ToolbarButton ID="NewPostToolBar" runat="server" Divide="None" Icon="PlusSquare" Text="New Post" OnClientClick="message.edit();"></dw:ToolbarButton>
                <dw:ToolbarButton ID="EditThreadToolBar" runat="server" Divide="None" Icon="Pencil" Text="Edit Thread" OnClientClick="menuActions.editCategory();"></dw:ToolbarButton>
                <dw:ToolbarButton ID="ThreadsToolBar" runat="server" Divide="None" Icon="CommentsO" Text="Threads" OnClientClick="forumCategory.showThreads();"></dw:ToolbarButton>
                <dw:ToolbarButton ID="Categories" runat="server" Divide="None" Icon="FolderO" Text="Categories" OnClientClick="message.listCategory();"></dw:ToolbarButton>
                <dw:ToolbarButton ID="HelpToolbar" runat="server" Divide="None" Icon="Help" Text="Help" OnClientClick="help();"></dw:ToolbarButton>
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dw:List ID="List1" runat="server" TranslateTitle="false" Title="Messages" PageSize="25">
                    <Filters>
                        <dw:ListTextFilter runat="server" ID="TextFilter" WaterMarkText="Search" Width="175" ShowSubmitButton="True" Divide="None" Priority="1" />
                        <dw:ListDropDownListFilter ID="PageSizeFilter" Width="150" Label="Posts per page" AutoPostBack="true" Priority="2" runat="server">
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
                        <dw:ListColumn ID="ListColumn5" runat="server" Name="" Width="10"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn1" EnableSorting="true" runat="server" Name="Post" Width="0"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn3" EnableSorting="true" runat="server" Name="Author" Width="0"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn4" EnableSorting="true" runat="server" Name="Attachments" ItemAlign="Center" HeaderAlign="Center" Width="80"></dw:ListColumn>
                        <dw:ListColumn ID="ListColumn2" EnableSorting="true" runat="server" Name="Published" Width="130"></dw:ListColumn>
                    </Columns>
                </dw:List>
            </dwc:CardBody>
            <dw:ContextMenu ID="MessagesContext" runat="server">
                <dw:ContextMenuButton ID="EditMessageBtn" runat="server" Divide="None" Icon="Pencil" Text="Edit post"></dw:ContextMenuButton>
                <dw:ContextMenuButton ID="DeleteMessageBtn" runat="server" Divide="None" Icon="Delete" Text="Delete post"></dw:ContextMenuButton>
            </dw:ContextMenu>
        </form>
    </dwc:Card>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
