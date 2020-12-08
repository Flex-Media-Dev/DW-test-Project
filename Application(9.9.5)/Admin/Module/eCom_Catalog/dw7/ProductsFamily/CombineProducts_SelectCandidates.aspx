<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CombineProducts_SelectCandidates.aspx.vb" EnableViewState="false" Inherits="Dynamicweb.Admin.CombineProducts_SelectCandidates" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title><dw:TranslateLabel runat="server" Text="Variants" /></title>
    <dw:ControlResources runat="server" IncludePrototype="true" IncludeUIStylesheet="true">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="ProductsFamily.js" />
        </Items>
    </dw:ControlResources>

    <script>
        var MODE_VARIANTS = <%=Dynamicweb.Admin.CombineProductsData.CombineProductsMode.Variants%>;
        var MODE_FAMILY = <%=Dynamicweb.Admin.CombineProductsData.CombineProductsMode.Family%>

            function toggleElements(radioButton){
                var selectedValue = radioButton.value;
                var variantGroupSelector = document.getElementById("variantGroupWrapper");

                if(selectedValue == MODE_FAMILY){
                    if(variantGroupSelector != null){
                        variantGroupSelector.style.display = "none";
                    }
                }
                else
                {
                    if(variantGroupSelector != null){
                        variantGroupSelector.style.display = "block";
                    }
                }
            }

        function products_RowDeleting(list, args) {
            var productInfo = args.row.get_properties();
            if (productInfo.DisableDeleteCommand) {
                args.cancel = true;
                ShowImpossibleDeleteMasterProductInfoBox();
                return;
            }
        }

        function products_showProductsSelector(list, args) {
            var id = args.row.get_id();
            args.cancel = true;
            if (!id) { // new row
                showProductsSelector(list);
            }
        }

        function initPage(options) {
            hideOverlay('wait');
            document.body.querySelector(".modal-dialog.dialog-md").className = "modal-dialog dialog-lg";

            var allModes = document.querySelectorAll(".dw-ctrl.radio-group input[name=ModeGroup]");
            var el = document.querySelector(".dw-ctrl.radio-group input[name=ModeGroup]:checked");
            if (!el) {
                el = allModes[0];
            }
            if (options.disableModeSelector) {
                for(var i = 0; i < allModes.length; i++) {
                    allModes[i].setAttribute("disabled", "disabled");
                }
            }
            else if (el) {
                dwGlobal.Dom.triggerEvent(el, "click");
            }
        }

        function extractProduct(variant, column) {
            showOverlay('wait');
            var variantPage = "<%= GetExtractProductUrl() %>";
            variantPage = variantPage + "&ExtractProduct=" + variant.get_properties().VariantId;
            location.href = variantPage;
        }

        function showExplodeFamilyConfirmationMessage() {
            dialog.show("ExplodeFamilyConfirmationMessage");
        }

        function explodeFamily() {
            var removeMainProduct = document.getElementById("RemoveMainContainer").checked;
            dialog.hide("ExplodeFamilyConfirmationMessage");
            showOverlay('wait');
            var variantPage = "<%= GetExtractProductUrl() %>";
            variantPage = variantPage + "&ExplodeFamily=true";
            variantPage = variantPage + "&RemoveMainProduct=" + removeMainProduct;
            location.href = variantPage;
        }
    </script>
    <style>
        .unlink:before {
            font-family: "FontAwesome";
            font-weight: 900;
            content: "\f127";
        }
    </style>
</head>
<dwc:DialogLayout runat="server" Title="Combine products" HidePadding="True">
    <Content>
        <div class="col-md-0">
            <div runat="server" id="ModeSelectorContainer">
                <dwc:RadioGroup ID="ModeGroup" Name="ModeGroup" Indent="True" runat="server" Label="Mode" SelectedValue="variants" >
                    <dwc:RadioButton ID="VariantsMode" Label="Create variants" runat="server" FieldValue="variants" OnClick="javascript:toggleElements(this)"></dwc:RadioButton>
                    <dwc:RadioButton ID="FamilyMode" Label="Create family" runat="server" FieldValue="family" OnClick="javascript:toggleElements(this)"></dwc:RadioButton>
                </dwc:RadioGroup>
            </div>
            <dw:InfoBar runat="server" ID="ModeWarning" Type="Information" Visible="false"></dw:InfoBar>
            <div id="variantGroupWrapper">
                <dw:SelectionBox Label="Variant Groups" ID="VariantGroups" ShowSortRight="true" RightHeader="Selected groups" LeftHeader="All groups" NoDataTextLeft="No groups" NoDataTextRight="No groups" TranslateNoDataText="true" TranslateHeaders="true" runat="server" ClientIDMode="Static"></dw:SelectionBox>
            </div>
                <dwc:GroupBox runat="server" Title="Products">
                <dw:EditableList  ID="SelectedProducts" runat="server" AllowEditing="true" AllowAddNewRow="true" AllowDeleteRow="true" AllowPaging="true" AllowSorting="false" AddNewRowCaption="Click here to add a product" AutoGenerateColumns="false" OnClientDialogOpening="products_showProductsSelector" OnClientRowDeleting="products_RowDeleting">
                    <Pager PageSize="5" />
                </dw:EditableList>
            </dwc:GroupBox>
        </div>
        <input type="hidden" id="json" name="json" value="" />
        <dw:Dialog runat="server" ID="ProductsSelectorDialog" HidePadding="True">
            <iframe id="ProductsSelectorDialogFrame" name="ProductsSelectorDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>

        <dw:Dialog runat="server" ID="ExplodeFamilyConfirmationMessage" Title="Extract All" OkAction="explodeFamily();" ShowOkButton="True" ShowCancelButton="True" >
            <dw:TranslateLabel runat="server" Text="You are about to split this family into its individual pieces. It will not be possible to undo this later. Are you sure you want to continue?" />
            <dwc:Checkbox runat="server" ID="RemoveMainContainer" Label="Remove main product/container" Indent="false" />
        </dw:Dialog>
        <dw:Overlay ID="wait" runat="server"></dw:Overlay>
    </Content>
    <Footer>
        <a href="javascript:void(0)"  id="ExtractAllButton" runat="server" class="btn btn-link waves-effect" visible="false"><dw:TranslateLabel runat="server" Text="Extract All" /></a>
        <a class="btn btn-link waves-effect" id="CombineNextButton" runat="server"><dw:TranslateLabel runat="server" Text="Next" /></a>
    </Footer>
</dwc:DialogLayout>
<script>
    function nextWizardPage(e, url) {
        e.stopPropagation();
        var variantGroups = SelectionBox.getElementsRightAsArray("VariantGroups");
        var mode = getSelectedMode();
        if (mode == MODE_VARIANTS && !variantGroups.length) {
            ShowVariantGroupsIsNotSelectedInfoBox();
            return false;
        }
        var jsonObj = <%=GetDataJson()%>;
        jsonObj.VariantGroupsIds = variantGroups;
        jsonObj.Mode = mode;
        var prods = getSelectedProducts();
        jsonObj.Products = prods;
        var jsonData = toQueryString(jsonObj, false);
        document.getElementById("json").value = jsonData;
        window.document.forms[0].setAttribute("action", url);
        Action.Execute({'Name':'Submit'})
        return false;
    }

    function showProductsSelector() {
        var disabledProducts = getSelectedProducts().collect(function(prod) {
            return prod.ProductId + "." + prod.VariantId;
        });
        var model = {
            DisabledProducts: disabledProducts.join()
        };
        var action = "<%=ShowProductSelector()%>";
        Action.openWindowWithVerb("POST", action, model, "ProductsSelectorDialogFrame")
        showLoader("ProductsSelectorDialogFrame");
        dialog.setTitle("ProductsSelectorDialog", "<%=Translate.Translate("Add products")%>");
        dialog.show("ProductsSelectorDialog");
    }

    function showLoader(windowName) {
        const wnd = window.frames[windowName];
        var overlay = wnd.document.getElementById("screenLoaderOverlay");
        if (!overlay) {
            const cnt = wnd.document.body;
            if (cnt) {
                wnd.document.head.insertAdjacentHTML("afterbegin", '<link rel="stylesheet" href="/Admin/Resources/css/dw8stylefix.css" type="text/css" />');
                const overlayHtml = '<div class="overlay-container" id="screenLoaderOverlay"><div class="overlay-panel"><i class="fa fa-refresh fa-3x fa-spin"></i></div></div> ';
                cnt.insertAdjacentHTML("afterbegin", overlayHtml);
            }
        } else {
            overlay.style.display = "";
        }
    }

    function addNewProductToList(products) {
        var idx = {};
        products.each(function (p) {
            var autoId = p.autoId;
            var prodId = p.id;
            var variantId = p.variantId;
            var name = p.name;
            var number = p.number;
            var pid = prodId + "." + variantId;
            if (!idx[pid]) {
                idx[pid] = true;
                    <%=SelectedProducts.ClientInstanceName%>.addRow({
                    AutoId: autoId,
                    ProductId: prodId,
                    VariantId: variantId,
                    Name: name,
                    Number: number
                });
            }
        });

        dialog.hide('ProductsSelectorDialog');
    }

    function getSelectedProducts(deletedItemFn) {
        deletedItemFn = deletedItemFn || function() {};
        var list = <%=SelectedProducts.ClientInstanceName%>;
        var rows = list.get_dataSource();
        var items = [];
        rows.each(function(row, index) {
            if (row.get_state() == Dynamicweb.Controls.EditableList.Enums.ModelState.DELETED)
            {
                deletedItemFn(row);
                return;
            }
            var obj = row.get_properties();
            items.push(obj);
        });
        return items;
    }

    function ShowImpossibleDeleteMasterProductInfoBox() {
        showMessageBox("<%=Translate.JsTranslate("Impossible delete master product")%>", "<%=Translate.JsTranslate("Information")%>");
    }

    function ShowVariantGroupsIsNotSelectedInfoBox() {
        showMessageBox("<%=Translate.JsTranslate("At least one variant group should be selected")%>", "<%=Translate.JsTranslate("Information")%>");
    }

    function getSelectedMode()
    {
        var results = document.getElementsByName("ModeGroup");

        if(results != null && results.length >= 1)
        {
            for(var i = 0; i < results.length; i++)
            {
                if(results[i].checked == true){
                    return results[i].value;
                }
            }
        }

        return MODE_VARIANTS;
    }
</script>
</html>
<%
    Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
%>