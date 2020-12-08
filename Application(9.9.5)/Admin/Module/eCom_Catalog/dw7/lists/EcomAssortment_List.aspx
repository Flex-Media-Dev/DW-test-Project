<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master" AutoEventWireup="false" CodeBehind="EcomAssortment_List.aspx.vb" Inherits="Dynamicweb.Admin.EcomAssortment_List" %>

<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript" src="../images/layermenu.js"></script>
    <script type="text/javascript" src="../js/AssortmentList.js"></script>
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <dw:Toolbar ID="MainToolbar" runat="server" ShowStart="true" ShowEnd="false">
        <dw:ToolbarButton ID="cmdAdd" runat="server" Divide="None" Icon="PlusSquare" Text="New assortment" OnClientClick="assortmentList.addAssortment();"></dw:ToolbarButton>
    </dw:Toolbar>
    <div class="breadcrumb">
        <asp:Literal ID="Breadcrumb" runat="server" /></div>
    <dw:Infobar runat="server" ID="ibAssortDisabled" Type="Warning" Message="Assortments is not activated in frontend" />
    <dw:List ID="AssortmentList" StretchContent="true" ShowTitle="false" runat="server" PageSize="25">
        <Columns>
            <dw:ListColumn ID="ListColumn1" runat="server" EnableSorting="true" Name="Number" TranslateName="true" />
            <dw:ListColumn ID="ListColumn2" runat="server" EnableSorting="true" Name="Name" TranslateName="true" />
            <dw:ListColumn ID="ListColumn3" runat="server" EnableSorting="true" Name="Last built" TranslateName="true" />
            <dw:ListColumn ID="ListColumn4" runat="server" EnableSorting="true" Name="Active" TranslateName="true" />
        </Columns>
    </dw:List>

    <dw:ContextMenu ID="AssortmentListMenu" runat="server" OnClientSelectView="assortmentList.onAssortmentListSelectView">
        <dw:ContextMenuButton ID="cmdEditAssortment" runat="server" Divide="None" Icon="Pencil" Text="Edit assortment" OnClientClick="assortmentList.editAssortment();" />
        <dw:ContextMenuButton ID="cmdDeleteAssortment" runat="server" Divide="After" Icon="Delete" Text="Delete assortment" OnClientClick="assortmentList.deleteAssortment();" />
        <dw:ContextMenuButton ID="cmdAssortmentAttachShop" runat="server" Divide="None" Icon="AttachFile" Text="Attach shops" OnClientClick="assortmentList.attachShop();" />
        <dw:ContextMenuButton ID="cmdAssortmentAttachGroup" runat="server" Divide="None" Icon="AttachFile" Text="Attach groups" OnClientClick="assortmentList.attachGroup();" />
        <dw:ContextMenuButton ID="cmdAssortmentAttachProduct" runat="server" Divide="After" Icon="AttachFile" Text="Attach products" OnClientClick="assortmentList.attachProduct();" />
        <dw:ContextMenuButton ID="cmdRebuildAssortment" runat="server" OnClientGetState="assortmentList.onAssortmentListRebuildGetState" Divide="None" Icon="RotateLeft" Text="Rebuild assortment" OnClientClick="assortmentList.rebuildAssortment();" />
        <dw:ContextMenuButton ID="cmdAssortmentPermissions" Text="Permissions" OnClientClick="assortmentList.newPermissions();" Icon="Lock" runat="server" Divide="Before" Visible="false" />
    </dw:ContextMenu>

    <dw:ContextMenu ID="AssortmentListMenuDisabled" runat="server">
        <dw:ContextMenuButton ID="cmdEditAssortment2" runat="server" Divide="None" Icon="Pencil" Text="Edit assortment" OnClientClick="assortmentList.editAssortment();" />
    </dw:ContextMenu>
</asp:Content>
