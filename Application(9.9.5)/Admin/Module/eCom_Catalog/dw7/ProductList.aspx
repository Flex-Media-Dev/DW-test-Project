<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master"
    AutoEventWireup="false" CodeBehind="ProductList.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.ProductList" %>
    
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">

    <link rel="Stylesheet" href="css/productList.css" />

    <script type="text/javascript" src="js/ProductList.js"></script>
    <script type="text/javascript" src="js/productMenu.js"></script>
    <script type="text/javascript" language="JavaScript" src="images/layermenu.js"></script>
    <script type="text/javascript" language="JavaScript" src="Wizard/wizardstart.js"></script>
    
    <style type="text/css">
        .list table.main_stretcher tr.header,
        .list table.main_stretcher tr.header > td
        {
	        visibility: visible;
        }        
    </style>

    <script type="text/javascript">
        this.previousValue;

        function confirmAll() {
            var selectElement = document.getElementById('ProductList:fNumRows').value;
            if (selectElement == "all") {
                if (!confirm('<%= Translate.JsTranslate("Selecting All can be very slow if you have many products. Continue?")%>')) {
                    document.getElementById('ProductList:fNumRows').value = this.previousValue;
                    return 0;
                } else {
                    List._submitForm('ProductList:fNumRows');
                }
            } else {
                this.previousValue = document.getElementById('ProductList:fNumRows').value;
                List._submitForm('ProductList:fNumRows');
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">

    <input id="productIds" name="productIds" type="hidden" value="" />
    <input id="productColumns" name="productColumns" type="hidden" value="<%= GetProductColumns() %>" />
    <input id="productListState" name="productListState" type="hidden" value="<%= ProductList.GetControlState() %>" />

<asp:Panel runat="server" ID="ContentPanel">

    <!-- Ribbon bar start -->
    <div style="min-width:1000px;overflow:hidden;">
    <dw:RibbonBar ID="Ribbon1" runat="server">
        <dw:RibbonBarTab ID="RibbonBarTab1" Name="Products" runat="server">
            
            <dw:RibbonBarGroup ID="RibbonBarGroup10" Name="Tools" runat="server">
                <%--<dw:RibbonBarButton ID="RibbonBarButton7" Text="Move to group" Image="FolderInto"
                    runat="server" Size="Small">
                </dw:RibbonBarButton>
                <dw:RibbonBarButton ID="RibbonBarButton2" Text="Attach to group" runat="server" Image="FolderAdd"
                    Size="Small">
                </dw:RibbonBarButton>--%>
                <dw:RibbonBarButton ID="cmdDelete" Text="Delete" runat="server" Icon="Delete" Size="Small" />
                <dw:RibbonBarButton ID="cmdDelocalize" Text="Delocalize" Icon="NotInterested" runat="server" Size="Small" />
                <dw:RibbonBarButton ID="cmdLocalize" Text="Localize" Icon="Globe" runat="server" Size="Small" />
                <dw:RibbonBarButton ID="ShowProductsFamilyToolButton" Text="Combine products as family" Size="Small" runat="server" Icon="Bank" IconColor="Modules" Visible="false" />
                <dw:RibbonBarButton ID="ImportButton" Text="Import products" Icon="SignIn" Size="Small" runat="server" />    
            </dw:RibbonBarGroup>
            
            <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Insert" runat="server">
                
                <dw:RibbonBarButton ID="cmdNewProduct" Text="New product" Icon="PlusSquare" runat="server" Size="Large" OnClientClick="newProduct();" />
                <dw:RibbonBarButton ID="cmdBulkCreate" Text="Create multiple products" Icon="Layers" runat="server" Size="Large" OnClientClick="createMultipleProducts();" />
            </dw:RibbonBarGroup>
            
            <dw:RibbonBarGroup ID="RibbonBarGroup2" Name="Edit" runat="server">
                <dw:RibbonBarButton ID="EditProducts" Text="Edit products" Icon="Pencil" Size="Small" runat="server" OnClientClick="productListEditing();" />
                <dw:RibbonBarButton ID="SortProducts" Text="Sort products" Icon="Sort" Size="Small" runat="server" OnClientClick="productListSorting();" />
                <dw:RibbonBarButton ID="cmdEditGroup" Text="Edit group" Icon="Pencil" runat="server" Size="Small" OnClientClick="editGroup();" />
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup ID="RibbonGroupLanguage" Name="Language" runat="server">
                <ecom:LanguageSelector ID="langSelector" OnClientSelect="selectLang" runat="server" />
             </dw:RibbonBarGroup>
             
            <dw:RibbonBarGroup ID="RibbonBarGroup3" Name="Help" runat="server">
                <dw:RibbonBarButton ID="RibbonBarButton6" Icon="Help" runat="server" Text="Help" OnClientClick="help();" />
            </dw:RibbonBarGroup>
            
        </dw:RibbonBarTab>
    </dw:RibbonBar>
    </div>
    <!-- Ribbon bar end -->

    <!-- List start -->
    <div id="ListContent" style="overflow: auto;">
    <dw:List runat="server"
        ID="ProductList"  
        Title="» Bikes » Road bikes"
        ShowCount="false"
        AllowMultiSelect="true"
        OnRowExpand="OnRowExpand"
        HandlePagingManually="true"
        HandleSortingManually="true"
        AllowToRemoveSorting="true"
        OnClientSelect="productSelected();"
        Personalize="true"
        PageSize="25">
        <Filters>
            <dw:ListTextFilter runat="server" ID="TextFilter" WaterMarkText="Search" Width="175" ShowSubmitButton="True" Divide="None" />
            <dw:ListFlagFilter ID="SearchAllFields" runat="server" Label=" Search in all fields" IsSet="false" Divide="none" LabelFirst="false" /> 
            <dw:ListDropDownListFilter ID="fNumRows" Width="150" Label="Products per page" AutoPostBack="true" Priority="3" runat="server" OnClientChange="confirmAll() && ">
                <Items>
                    <dw:ListFilterOption Text="25" Value="25" Selected="true" DoTranslate="false" />
                    <dw:ListFilterOption Text="50" Value="50" DoTranslate="false"/>
                    <dw:ListFilterOption Text="75" Value="75" DoTranslate="false"/>
                    <dw:ListFilterOption Text="100" Value="100" DoTranslate="false"/>
                    <dw:ListFilterOption Text="200" Value="200" DoTranslate="false"/>
                    <dw:ListFilterOption Text="All" Value="all" DoTranslate="True"/>
                </Items>
            </dw:ListDropDownListFilter>
        </Filters>
    </dw:List>
    <dw:List ID="VariantsProductList" ClientIDMode="Static" ShowTitle="false" runat="server" Personalize="True" Visible="false">
    </dw:List>
    </div>
    <dw:Overlay ID="__ribbonOverlay" runat="server"></dw:Overlay>
    <dw:Overlay ID="ProductsLayout" Message="Please wait" runat="server"></dw:Overlay>
    <!-- List end -->

    <!-- Context menu start -->
    <dw:ContextMenu ID="ProductContext" runat="server">
        <dw:ContextMenuButton ID="editProductButton" runat="server" Icon="Pencil" Text="Edit product" OnClientClick="productMenu.editProduct();" />
        <dw:ContextMenuButton ID="copyProductButton" runat="server" Divide="Before" Icon="ContentCopy" OnClientClick="productMenu.copyProduct();" Text="Copy" />
        <dw:ContextMenuButton ID="moveProductButton" runat="server" Icon="ArrowRight" OnClientClick="productMenu.moveProduct();" Text="Move" />
        <dw:ContextMenuButton ID="activateProductButton" runat="server" Divide="Before" Icon="Check" IconColor="Default" OnClientClick="productMenu.activateProduct();" Text="Activate" />
        <dw:ContextMenuButton ID="deactivateProductButton" runat="server" Icon="Times" IconColor="Default" OnClientClick="productMenu.deactivateProduct();" Text="Deactivate" />
        <dw:ContextMenuButton ID="attachMultipleProductsButton" Views="common,ungroup" runat="server" Divide="Before" Icon="AttachFile" OnClientClick="productMenu.attachMultipleProducts();" Text="Add to group" />
        <dw:ContextMenuButton ID="removeProductButton" runat="server" Icon="NotInterested" OnClientClick="productMenu.detachProduct();" Text="Detach from group" />
        <dw:ContextMenuButton ID="deleteProductButton" runat="server" Divide="Before" Icon="Delete" Text="Delete" OnClientClick="productMenu.deleteProduct();" OnClientGetState="productMenu.getStateForDeleteAction();" />
    </dw:ContextMenu>
    <!-- Context menu end -->

    <dw:Dialog 
        ID="LocalizationDialog" 
        runat="server" 
        Title="Localization" 
        TranslateTitle="true"
        ShowClose="true"
        HidePadding="true" 
        Width="420">
        <div style="margin: 5px">
            <dw:TranslateLabel ID="TranslateLabel3" runat="server" text="Do you want to localize all selected products to the current language?" />
            <br />
            <asp:CheckBox id="deactivateProducts" runat="server" Text="Deactivate products after localization" />
        </div>
        <div style="text-align:right;">
	        <asp:Button ID="btnLocalize" CssClass="newUIbutton" style="max-width:50px" runat="server" OnClick="cmdLocalize_Click" Text="OK" />
	        <button type="button" class="dialog-button-cancel" onclick="dialog.hide('LocalizationDialog');return false;"><dw:TranslateLabel ID="TranslateLabel5" runat="server" text="Cancel" /></button>
	    </div>
    </dw:Dialog>

    <dw:Dialog ID="VariantDialog" Size="Large" HidePadding="True" Title="Variants" TranslateTitle="true" runat="server">
          <iframe id="VariantDialogFrame" style="height: 100vh"></iframe>
    </dw:Dialog>

</asp:Panel>
    
	<script type="text/javascript">
    // Set Grid height
    window.onload = function () {
        var deferredStretchedContainerRecalc = dwGlobal.debounce(function () {
            resizeContentPane("ListContent", 'Ribbon1');
        }, 200);
        window.onresize = deferredStretchedContainerRecalc;
        Ribbon.add_stateChanged(deferredStretchedContainerRecalc);
        window.onresize();
    }
    
    function resizeContentPane(contentPaneID, ribbonBarID) {
        var elemGrid = document.getElementById(contentPaneID);
        if (elemGrid) {
            var ribbonHeight = 0;
            var elemRibbon = document.getElementById(ribbonBarID);
            if (elemRibbon) {
                ribbonHeight = elemRibbon.offsetHeight;
            }
       
            var gridHeight = document.body.clientHeight - ribbonHeight;
            if (gridHeight < 0) {
                gridHeight = 0;
            }

            elemGrid.style.height = (gridHeight - 32) + 'px';
        }
    }

	function help(){
		<%=Dynamicweb.SystemTools.Gui.Help("", "ecom.productlist", "en") %>
	}
        
        var combineProducsDialogAction = <%=ProductEdit.GetCombineProductsAsFamilyActionWithPageRefresh(String.Empty, False).ToJson()%>;
        
        function ShowCombineDialog() {
            if(combineProducsDialogAction){                
                var dialogAction = combineProducsDialogAction.constructor();
                for (var attr in combineProducsDialogAction) {
                    if (combineProducsDialogAction.hasOwnProperty(attr)) dialogAction[attr] = combineProducsDialogAction[attr];
                }
                var productIds = List.getSelectedRows('ProductList').map(function (row) { return row.getAttribute("itemid"); });
                dialogAction.Url += "&ProductIds=" + productIds;
                Action.Execute(dialogAction);
            }
        }

    	productMenu._successCopyMessage = '<%= Translate.JsTranslate("The selected products were successfully copied.")%>';
	    productMenu._failureCopyMessage = '<%= Translate.JsTranslate("Errors occurred when copying the products. Some products may have been copied. Error message:")%>';
	    productMenu._deleteMessage = '<%= Translate.JsTranslate("Do you want to delete the selected products? This will delete all language versions!")%>';
	    productMenu._deleteMessage2 = '<%= Translate.JsTranslate("Do you want to delete the selected products? This will delete all language versions and from all groups!")%>';
	    productMenu._detachMessage = '<%= Translate.JsTranslate("Do you want to detach the selected products? This will remove all language versions of the selected products from the group!")%>';
	    productMenu._failureDetachMessage = '<%= Translate.JsTranslate("Errors occurred when detaching the products. Some products may have been detached.")%>';

	    this.previousValue = document.getElementById('ProductList:fNumRows').value;
	</script>
    
    <span id="spDelocalizeMsg" style="display: none"><dw:TranslateLabel id="lbDelocalizeMsg" Text="Do you want to delocalize the selected products?" runat="server" /></span>
    <span id="spDeleteMsg" style="display: none"><dw:TranslateLabel id="TranslateLabel1" Text="Do you want to delete the selected products? This will delete all language versions!" runat="server" /></span>
    
    <%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript() %>
    
</asp:Content>
