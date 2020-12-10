<%@ Page Title="" Language="vb" AutoEventWireup="false" CodeBehind="List.aspx.vb" Inherits="Dynamicweb.Admin.DirectPaths_List" %>

<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>


<html>
<head id="PageHeader" runat="server">
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script src="/Admin/Content/Management/DirectPaths/List.js" type="text/javascript"></script>
        <script src="/Admin/Content/JsLib/dw/Utilities.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/List/List.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/WaterMark.js" type="text/javascript"></script>   
        <link rel="stylesheet" type="text/css" href="/Admin/Resources/css/dw8stylefix.css" />             
    </dwc:ScriptLib>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <asp:HiddenField ID="pathIds" runat="server" />
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" ID="CardHeader1" Title="Redirects" DoTranslate="true"></dwc:CardHeader>
                <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="cmdAdd" runat="server" Disabled="true" Divide="None" Icon="PlusSquare" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdAdd')) {{ DirectPaths.editItem(0); }}" Text="Add" />
                    <dw:ToolbarButton ID="cmdBatchEdit" runat="server" Disabled="true" Divide="None" Icon="Pencil" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdBatchEdit')) {{ DirectPaths.swichToBatchEditMode(); }}" Text="Edit" />
                    <dw:ToolbarButton ID="cmdToolbarDelete" runat="server" Disabled="true" Divide="None" Icon="Delete" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdDelete')) {{ DirectPaths.deleteItems(); }}" Text="Delete" />
                </dw:Toolbar>
                <dw:TranslateLabel ID="lbNoAccess" Text="Du har ikke de nødvendige rettigheder til denne funktion." runat="server" />
                <dw:List ID="lstPaths" AllowMultiSelect="true" ShowPaging="true" ShowFooter="false" ShowTitle="false" runat="server" PageSize="100" HandleSortingManually="True">
                    <Filters>
                        <dw:ListAutomatedSearchFilter ID="sFilter" runat="server" />
                        <dw:ListDropDownListFilter ID="areaFilter" Label="Website" runat="server" AutoPostBack="true" />
                    </Filters>
                    <Columns>   
                        <dw:ListColumn ID="colPath" EnableSorting="true" Name="Path" runat="server" />
                        <dw:ListColumn ID="colLink" EnableSorting="true" Name="Link" runat="server" />
                        <dw:ListColumn ID="colArea" EnableSorting="true" Name="Website" runat="server" />
                        <dw:ListColumn ID="colStatus" ItemAlign="Center" HeaderAlign="Right" EnableSorting="true" Name="Status" Width="45" runat="server" />
                        <dw:ListColumn ID="colVisitsCount" ItemAlign="Center" HeaderAlign="Right" EnableSorting="true" Name="Visits" Width="45" runat="server" />
                    </Columns>
                </dw:List>
                <input type="hidden" id="PostBackAction" name="PostBackAction" value="" />

                <span id="jsHelp" style="display: none"><%=Dynamicweb.SystemTools.Gui.Help("", "modules.urlpath.general.list.item") %> </span>
                <span id="confirmDelete" style="display: none"><%=Translate.Translate("Slet?") %></span>
            </dwc:Card>

            <dw:ContextMenu ID="cmItem" OnClientSelectView="DirectPaths.onSelectItemContextMenuView" runat="server">
                <dw:ContextMenuButton ID="cmdEdit" Views="SingleActiveItem, SingleInactiveItem, MultipleActiveItems, MultipleInactiveItems, MixedItems" Icon="Pencil" Text="Edit" OnClientClick="DirectPaths.editItem(ContextMenu.callingID);" runat="server" />

                <dw:ContextMenuButton ID="cmdActivate" Views="SingleInactiveItem" Icon="CheckCircle" Text="Activate" OnClientClick="DirectPaths.activateItems();" runat="server" />
                <dw:ContextMenuButton ID="cmdActivateSelected" Views="MultipleInactiveItems, MixedItems" Icon="CheckSquareO" Text="Activate selected" OnClientClick="DirectPaths.activateItems();" runat="server" />
                <dw:ContextMenuButton ID="cmdDeactivate" Views="SingleActiveItem" Icon="Times" Text="Deactivate" OnClientClick="DirectPaths.deactivateItems();" runat="server" />
                <dw:ContextMenuButton ID="cmdDeactivateSelected" Views="MultipleActiveItems, MixedItems" Icon="MinusCircle" Text="Deactivate selected" OnClientClick="DirectPaths.deactivateItems();" runat="server" />
                <dw:ContextMenuButton ID="cmdSetStatus" Icon="InfoCircle" Views="SingleActiveItem, SingleInactiveItem, MultipleActiveItems, MultipleInactiveItems, MixedItems" Text="Status" ImagePath="Gear" runat="server">
                    <dw:ContextMenuButton ID="cmdSetStatus200" Text="200 OK" DoTranslate="False" Icon="File" OnClientClick="DirectPaths.setItemsStatus(200);" runat="server" />
                    <dw:ContextMenuButton ID="cmdSetStatus301" Text="301 Moved Permanently" DoTranslate="False" Icon="FileO" OnClientClick="DirectPaths.setItemsStatus(301);" runat="server" />
                    <dw:ContextMenuButton ID="cmdSetStatus302" Text="302 Moved Temporarily" DoTranslate="False" Icon="FileO" OnClientClick="DirectPaths.setItemsStatus(302);" runat="server" />
                </dw:ContextMenuButton>

                <dw:ContextMenuButton ID="cmdDelete" Views="SingleActiveItem, SingleInactiveItem" Icon="Delete" Text="Delete" Divide="Before" OnClientClick="DirectPaths.deleteItems();" runat="server" />
                <dw:ContextMenuButton ID="cmdDeleteSelected" Views="MultipleActiveItems, MultipleInactiveItems, MixedItems" Icon="Delete" Text="Delete selected" OnClientClick="DirectPaths.deleteItems();" runat="server" />
            </dw:ContextMenu>

            <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
            </dw:Overlay>
        </form>
    </div>
</body>

<%Translate.GetEditOnlineScript()%>
</html>
