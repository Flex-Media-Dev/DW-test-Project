<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ItemTypeUsage.aspx.vb" Inherits="Dynamicweb.Admin.ItemTypeUsage" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/List/List.css" />
            <dw:GenericResource Url="/Admin/Content/Items/js/ItemTypeUsage.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/ItemTypeList.css" />
        </Items>
    </dw:ControlResources>
</head>
<body class="screen-container">
    <div class="card">
        <div class="card-header">
            <h2 class="subtitle">
                <dw:TranslateLabel ID="TranslateLabel1" Text="Item type usages" runat="server" />
            </h2>
        </div>
        <form id="MainForm" runat="server">
            <input type="hidden" id="PostBackAction" name="PostBackAction" value="" />
            <input type="hidden" id="PostBackArgument" name="PostBackArgument" value="" />
            <input type="hidden" id="ItemSystemNames" name="ItemSystemNames" value="" />
            <input type="hidden" id="SelectedItems" name="SelectedItems" runat="server" value="" />
            <input type="hidden" id="SelectedSystemName" name="SelectedSystemName" runat="server" value="" />
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />

            <dw:Toolbar ID="Toolbar1" runat="server" ShowStart="true" ShowEnd="false">
                <dw:ToolbarButton ID="cmdBack" Icon="ArrowBack" OnClientClick="Dynamicweb.Items.ItemTypeUsage.close();" Text="Back" runat="server" />
                <dw:ToolbarButton ID="cmdAply" Icon="CheckCircle" OnClientClick="Dynamicweb.Items.ItemTypeUsage.apply();" Text="Apply" runat="server" />
                <dw:ToolbarButton ID="cmdHelp" Icon="Help" OnClientClick="Dynamicweb.Items.ItemTypeUsage.help();" Text="Help" runat="server" Divide="Before" />
            </dw:Toolbar>

            <dw:List ID="ItemTypeUsageList" ShowTitle="false" NoItemsMessage="No item types used" ShowPaging="true" PageSize="25" AllowMultiSelect="true" runat="server">
                <Columns>
                    <dw:ListColumn runat="server" Name="Link to item" Width="300" EnableSorting="true" />
                    <dw:ListColumn runat="server" Name="Item type" EnableSorting="true" />
                    <dw:ListColumn runat="server" Name="Website" EnableSorting="true" />
                    <dw:ListColumn runat="server" Name="Used in" EnableSorting="true" />
                </Columns>
                <Filters>
                    <dw:ListDropDownListFilter runat="server" ID="ItemTypeDropDownListFilter" Label="Select item type" Width="200"></dw:ListDropDownListFilter>
                    <dw:ListDropDownListFilter runat="server" ID="AreaDropDownListFilter" Label="Select language/area" Width="200"></dw:ListDropDownListFilter>
                    <dw:ListDropDownListFilter runat="server" ID="UsedInListFilter" Label="Used in" Width="200"></dw:ListDropDownListFilter>
                </Filters>
            </dw:List>

            <dw:Overlay ID="PleaseWait" runat="server" />
            <input type="hidden" id="ItemTypeListFilterDefaultValue" value="" runat="server" />
            <input type="hidden" id="AreaListFilterDefaultValue" value="" runat="server" />
            <input type="hidden" id="UsedInListFilterDefaultValue" value="" runat="server" />
        </form>
    </div>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
