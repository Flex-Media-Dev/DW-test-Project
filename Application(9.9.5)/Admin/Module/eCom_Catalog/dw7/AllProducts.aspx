<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master"
    AutoEventWireup="false" CodeBehind="AllProducts.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.AllProducts" %>

<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <link rel="Stylesheet" href="css/productList.css" />

    <script type="text/javascript" src="js/queryString.js"></script>

    <script type="text/javascript" src="js/allProducts.js"></script>

    <script type="text/javascript" src="js/ProductList.js"></script>

    <script type="text/javascript" src="js/productMenu.js"></script>

    <script type="text/javascript" language="JavaScript" src="images/layermenu.js"></script>

    <script type="text/javascript" language="JavaScript" src="Wizard/wizardstart.js"></script>

    <script type="text/javascript">
	function help(){
		<%=Dynamicweb.SystemTools.Gui.Help("", "ecom.productlist", "en") %>
	}

    this.previousValue;

    function confirmAll() {
        var selectElement = document.getElementById('ProductList:PageSizeFilter').value;
        if (selectElement == "all") {
            if (!confirm('<%= Translate.JsTranslate("Selecting All can be very slow if you have many products. Continue?")%>')) {
                document.getElementById('ProductList:PageSizeFilter').value = this.previousValue;
                return 0;
            } else {
                List._submitForm('ProductList:PageSizeFilter');
            }
        } else {
            this.previousValue = document.getElementById('ProductList:PageSizeFilter').value;
            List._submitForm('ProductList:PageSizeFilter');
        }
    }
    </script>

</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <input type="hidden" id="products_search" name="products_search" value="<%= GetSearchText() %>" />
    <input type="hidden" id="products_pagenumber" name="products_pagenumber" value="<%= _pageNumber %>" />
    <input type="hidden" id="products_pagesize" name="products_itemsperpage" value="<%= _pageSize %>" />
    <input type="hidden" id="products_sort" name="products_sort" value="<%= OrderBy %>" />
    <input type="hidden" id="products_sortColId" name="products_sortColId" value="<%= _sortColID %>" />
    <input type="hidden" id="products_sortColDir" name="products_sortColDir" value="<%= CInt(_sortColDir).ToString() %>" />
    <input type="hidden" id="show_only_ecom_products" name="show_only_ecom_products" value="<%= Request("ShowOnlyEcomProducts") %>" />
    <dw:Overlay ID="__ribbonOverlay" runat="server"></dw:Overlay>

    <dw:Toolbar ID="AllProducsTool" runat="server" ShowStart="true" ShowEnd="false" >
    </dw:Toolbar>
    <div class="breadcrumb"><asp:Literal ID="Breadcrumb" runat="server" /></div>
    <ecom:LanguageMenu ID="LangMenu" runat="server" MenuID="langMn" OnClientSelect="selectLang" />
    <dw:Infobar runat="server" ID="ibAssortDisabled" Type="Warning" Message="Assortments is not activated in frontend" Visible="False" />
    <dw:Infobar runat="server" ID="AssortRebuildInProcess" Type="Warning" Message="Assortments are currently rebuilding" Visible="False" />
    <div id="ProductListContent" style="overflow: auto;">
        <dw:List ID="ProductList" ShowTitle="false" runat="server"
            AllowMultiSelect="true" OnRowExpand="OnRowExpand" OnClientSelect="productSelected();"
            UseCountForPaging="true" HandleSortingManually="true" HandlePagingManually="true" Personalize="true" PageSize="25">
            <Filters>
                <dw:ListTextFilter runat="server" ID="TextFilter" WaterMarkText="Search" Width="175"
                    ShowSubmitButton="True" Divide="None" />
            	<dw:ListFlagFilter ID="SearchAllFields" runat="server" Label=" Search in all fields" IsSet="false" Divide="none" LabelFirst="false" />            
                <dw:ListDropDownListFilter ID="PageSizeFilter" Width="150" Label="Products per page"
                    AutoPostBack="true" Priority="3" runat="server" OnClientChange="confirmAll() && ">
                    <Items>
                        <dw:ListFilterOption Text="25" Value="25" Selected="true" DoTranslate="false" />
                        <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                        <dw:ListFilterOption Text="75" Value="75" DoTranslate="false" />
                        <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                        <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                        <dw:ListFilterOption Text="All" Value="all" DoTranslate="True"/>
                    </Items>
                </dw:ListDropDownListFilter>
                <dw:ListDropDownListFilter ID="ShowProducts" Label="Show" autopostback="true" runat="server">
                    <Items>
                        <dw:ListFilterOption Text="Included in &quot;All products&quot;" value="included" selected="true"  />
                        <dw:ListFilterOption Text="Excluded from &quot;All products&quot;" value="excluded"  />
                        <dw:ListFilterOption Text="Everything" value="everything"  />
                    </Items>
                </dw:ListDropDownListFilter>
            </Filters>
        </dw:List>
        <dw:List ID="VariantsProductList" ClientIDMode="Static" ShowTitle="false" runat="server" Personalize="True" Visible="false">
        </dw:List>
    </div>
    <dw:ContextMenu ID="ProductContext" runat="server" OnClientSelectView="productMenu.onContextMenuView">
        <dw:ContextMenuButton ID="copyProductButton" Views="common" runat="server" Icon="Copy" OnClientClick="productMenu.copyProduct();"
            Text="Copy" />
         <dw:ContextMenuButton ID="attachMultipleProductsButton" Views="common,ungroup" runat="server" Icon="Exchange" OnClientClick="productMenu.moveMultipleProducts();"
            Text="Add to group" />
        <dw:ContextMenuButton ID="editProductButton" Views="common,ungroup" runat="server" Icon="Pencil"
            Text="Edit product" OnClientClick="productMenu.editProduct();" />
        <dw:ContextMenuButton ID="deleteProductButton" Views="common,ungroup" runat="server" Icon="Delete"
            Text="Delete" OnClientClick="productMenu.deleteProduct();" OnClientGetState="productMenu.getStateForDeleteAction();" />
        <dw:ContextMenuButton ID="ContextMenuButton1" Views="common,ungroup" runat="server" Divide="Before" Icon="Check" IconColor="Default"
            OnClientClick="productMenu.activateProduct();" Text="Activate" />
        <dw:ContextMenuButton ID="ContextMenuButton2" Views="common,ungroup" runat="server" Icon="Close"
            OnClientClick="productMenu.deactivateProduct();" Text="Deactivate" />
    </dw:ContextMenu>

    <dw:Dialog ID="VariantDialog" Size="Large" HidePadding="True" Title="Variants" TranslateTitle="true" runat="server">
          <iframe id="VariantDialogFrame" style="height: 100vh"></iframe>
    </dw:Dialog>

    <script type="text/javascript">

        // Set Grid height
        window.onload = window.onresize = function () {

            var elemGrid = document.getElementById('ProductListContent');
            if (elemGrid) {

                var toolbarH = document.getElementById('AllProducsTool') ? document.getElementById('AllProducsTool').offsetHeight : 0;
                var langMenuH = document.getElementById('LangMenu') ? document.getElementById('LangMenu').offsetHeight : 0;
                var ibAssortDisabledH = document.getElementById('InfoBar_ibAssortDisabled') ? document.getElementById('InfoBar_ibAssortDisabled').offsetHeight + 32 : 0;
                var assortRebuildInProcessH = document.getElementById('InfoBar_AssortRebuildInProcess') ? document.getElementById('InfoBar_AssortRebuildInProcess').offsetHeight : 0;
                
                var gridHeight = document.body.clientHeight - toolbarH - langMenuH - ibAssortDisabledH - assortRebuildInProcessH;

                if (gridHeight < 0) {
                    gridHeight = 0;
                }

                elemGrid.style.height = (gridHeight - 59) + 'px';
            }
        }

	    function help(){
		    <%=Dynamicweb.SystemTools.Gui.Help("", "ecom.productlist", "en") %>
	    }

        productMenu._warningAssortmentsMessage = '<%= Translate.JsTranslate("Assortments module is not installed. Only ungrouped products will processed.")%>';
	    productMenu._successCopyMessage = '<%= Translate.JsTranslate("The selected products were successfully copied.")%>';
	    productMenu._failureCopyMessage = '<%= Translate.JsTranslate("Errors occurred when copying the products. Some products may have been copied. Error message:")%>';
        productMenu._deleteMessage = '<%= Translate.JsTranslate("Slet?")%>';
        productMenu._deleteMessage2 = '<%= Translate.JsTranslate("Slet?")%>';

        this.previousValue = document.getElementById('ProductList:PageSizeFilter').value;
    </script>
    
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
    %>

</asp:Content>
