<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FavoriteProducts.aspx.vb" Inherits="Dynamicweb.Admin.FavoriteProducts" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ControlResources1" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="js/FavoriteProducts.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        $(document).observe('dom:loaded', function () {
            favoriteProducts.initialize(document.getElementById('form1'), <%= _listId %>, <%= GetDeleteAction().ToJson() %>, '<%= IsGroupFavorite %>' === 'True');
        });

        function AddRelatedRows() {
            dialog.hide("AddProductDialog");

            favoriteProducts.submitCommand("AddProducts");
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <input type="hidden" id="Cmd" name="Cmd" />
    <input type="hidden" id="NewProductIds" name="NewProductIds"/>
    <input type="hidden" id="FavoriteIds" name="FavoriteIds"/>
    <div class="card-header">
        <h2 class="subtitle"><%=Translate.Translate("Favorite products") %></h2>
    </div>
    <dw:Toolbar ID="MainToolbar" runat="server" ShowStart="true" ShowEnd="false" >
        <dw:ToolbarButton ID="cmdClose" runat="server" Divide="None" Icon="Cancel" Text="Cancel" OnClientClick="favoriteProducts.cancel();"></dw:ToolbarButton>
        <dw:ToolbarButton ID="cmdAdd" runat="server" Divide="None" Icon="PlusSquare" Text="Add product" OnClientClick="favoriteProducts.addProduct();"></dw:ToolbarButton>
        <dw:ToolbarButton ID="cmdAddBySKU" runat="server" Divide="None" Icon="PlusSquareO" Text="Add by SKU" OnClientClick="favoriteProducts.showAddProductDialog();"></dw:ToolbarButton>
        <dw:ToolbarButton ID="cmdEdit" runat="server" Divide="None" Icon="ModeEdit" Text="Edit" OnClientClick="favoriteProducts.edit();"></dw:ToolbarButton>
        <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="None" Icon="Delete" Text="Delete" Disabled="true" OnClientClick="favoriteProducts.delete(event);"></dw:ToolbarButton>
    </dw:Toolbar>
    <dw:List ID="FavoriteList" StretchContent="true" ShowTitle="false" runat="server" AllowMultiSelect="true" PageSize="25" OnClientSelect="favoriteProducts.productSelected();">
        <Columns>
            <dw:ListColumn ID="ListColumn1" runat="server" EnableSorting="true" Name="Product id" TranslateName="true" />
            <dw:ListColumn ID="ListColumn2" runat="server" EnableSorting="true" Name="Number" TranslateName="true" />
            <dw:ListColumn ID="ListColumn3" runat="server" EnableSorting="true" Name="Name" TranslateName="true" />
            <dw:ListColumn ID="ListColumn4" runat="server" EnableSorting="true" Name="Quantity" TranslateName="true" />
            <dw:ListColumn ID="ListColumn5" runat="server" EnableSorting="true" Name="Note" TranslateName="true" />
        </Columns>
    </dw:List>

    <dw:Dialog ID="AddProductDialog" runat="server" Size="Medium" Title="Add product">
        <iframe id="AddProductDialogFrame"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="AddProductBySCUDialog" runat="server" Size="Small" Title="Add products by SCU" OkAction="favoriteProducts.addProductBySKU();" ShowOkButton="true" ShowClose="true">
        <dw:GroupBox ID="GroupBox3" runat="server">
            <dw:TranslateLabel ID="TranslateLabel3" runat="server" text="Paste a list of SKUs and/or product ids" />
            <textarea id="productSCUs" cols="30" rows="5" class="std" style="width: 100%" runat="server"></textarea>
        </dw:GroupBox>
    </dw:Dialog>
    </form>
</body>
</html>
