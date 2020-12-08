<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomRelatedProducts.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomRelatedProducts" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeScriptaculous="true" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
        </Items>
    </dw:ControlResources>

    <style>
        .related-products-group .filter {
            width: 10%;
            font: normal normal normal 14px/1 FontAwesome;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="Cmd" name="Cmd" />
        <input type="hidden" id="relatedGroupId" name="relatedGroupId"/>
        <input type="hidden" id="relatedProductId" name="relatedProductId"/>

        <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
            <dw:ToolbarButton ID="cmdAddRelatedProductGroup" runat="server" Divide="None" Icon="GroupWork" Text="Add related product" OnClientClick="RelatedProductsEdit.showRelatedProductGroupsMenu(event);" ShowOptions="true" ShowOptionsSeparator="false" />
        </dw:Toolbar>
        <dw:Infobar runat="server" ID="infoNoGroups" Type="Warning" Visible="false" TranslateMessage="true" Message="No related products found. Add groups from dropdown." />
        <dw:Infobar runat="server" ID="infoSaveProduct" Type="Warning" Visible="false" TranslateMessage="true" Message="You need to save the product to use this." />
        <div>
            <asp:Literal ID="relatedData" runat="server" />
        </div>

        <dw:Dialog ID="NewRelatedProductGroup" runat="server" Title="Create relation group" Size="Medium" ShowOkButton="true" ShowCancelButton="true" OkAction="RelatedProductsEdit.createProductRelatedGroup();">
            <dwc:GroupBox runat="server" DoTranslation="true" Title="Relation group">                    
                <dwc:InputText id="RelatedProductGroupName" runat="server" Label="Name" />
            </dwc:GroupBox>
        </dw:Dialog>
    </form>

    <dw:ContextMenu ID="RelatedProductsMenu" runat="server" MaxHeight="650"></dw:ContextMenu>

    <dw:Dialog runat="server" ID="AddGroupsDialog" Size="Medium" HidePadding="True">
        <iframe id="AddGroupsDialogFrame"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="RelatedLimitationDialog" runat="server" Title="Limitations" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true">
        <iframe id="RelatedLimitationDialogFrame"></iframe>
    </dw:Dialog>

    <script>
        $(document).observe('dom:loaded', function () {
            RelatedProductsEdit.initialization();
        });

        function AddRelatedRows() {
            dialog.hide("AddGroupsDialog");
            dialog.set_contentUrl("AddGroupsDialog", "");

            RelatedProductsEdit.submitCommand("AddRelatedProducts");
        }

        var RelatedProductsEdit = {
            theForm: null,
            relatedLimitationRow: null,

            initialization: function () {
                var self = this;
                this.theForm = $("form1");

                document.observe("RelatedLimitations:changed", this.onRelatedLimitations_changed.bind(this));

                Position.includeScrollOffsets = true;

                $$('.related-products-group').each(function (el) {
                    Sortable.create(el, {
                        tag: 'tr',
                        onUpdate: function () {
                            var relatedProductIds = '';
                            el.select('tr').each(function (tr) {
                                relatedProductIds += tr.dataset.product + ',';
                            });

                            $('relatedGroupId').value = el.dataset.group;
                            $('relatedProductId').value = relatedProductIds;

                            self.theForm.request({
                                parameters: { Cmd: "SaveSortOrder" }
                            });
                        }
                    });
                });
            },

            submitCommand: function(cmd){
                this.theForm.Cmd.value = cmd;
                this.theForm.submit();
            },

            showRelatedProductGroupsMenu: function (event) {
                ContextMenu.show(event, 'RelatedProductsMenu', '', '', 'BottomLeft');
            },

            openNewRelatedProductGroups: function () {
                dialog.show('NewRelatedProductGroup');
            },

            createProductRelatedGroup: function () {
                var self = this;
                dialog.hide('NewRelatedProductGroup');

                this.theForm.request({
                    parameters: { Cmd: "CreateProductRelatedGroup" },
                    onSuccess: function (response) {
                        if (response.responseText) {
                            var groupName = $("RelatedProductGroupName").value;
                            self.updateRelatedProductGroups(groupName, response.responseText);
                        }
                    }
                });
            },

            updateRelatedProductGroups: function (groupName, groupID){
                var ctnr = $('RelatedProductsMenu').getElementsByClassName("container containerFixed")[0];
                var newGrp = document.createElement("a");
                newGrp.href = "javascript:void(0);";            
                newGrp.onclick = function () { RelatedProductsEdit.showAddRelatedProducts(groupID); };
                var innerspan = document.createElement("span");
                innerspan.className = "item";
                var innerImg = document.createElement("i");
                innerImg.className = "<%= KnownIconInfo.ClassNameFor(KnownIcon.Check, True) %>";
                innerspan.appendChild(innerImg);
                innerspan.innerHTML += groupName;
                newGrp.appendChild(innerspan);
                var outerSpan = document.createElement("span");
                outerSpan.appendChild(newGrp);
                ctnr.insertBefore(outerSpan, ctnr.firstChild);
            },

            showAddRelatedProducts: function (grpId) {
                $('relatedGroupId').value = grpId;
                var caller = "parent.document.getElementById('form1').relatedProductId";
                dialog.setTitle('AddGroupsDialog', '<%=Translate.Translate("Add related product")%>');
                var url = "/Admin/Module/Ecom_Catalog/dw7/edit/EcomGroupTree.aspx?CMD=ShowProd&MasterProdID=<%=ProductIdEncoded%>&caller=" + caller + "&RelgrpID=" + grpId;                
                <%If FromPim Then%>
                url += "&shopsToShow=ProductWarehouseOnly";
                <%end If%>
                dialog.show('AddGroupsDialog', url);
            },

            delRelatedProduct: function (grpId, prdId) {
                var message = "<%=Translate.JsTranslate("Slet?")%>";
                if (confirm(message)) {
                    $('relatedGroupId').value = grpId;
                    $('relatedProductId').value = prdId;

                    this.submitCommand("DelRelatedProduct");
                }
            },

            openRelatedProduct: function (productId, variantId, queryId, groupId) {
                var url = '';
                <%If FromPim Then%>
                url = "PimProduct_Edit.aspx?ID=" + productId + "&VariantID=" + variantId + "&QueryId=<%=QueryId%>&GroupId=<%=GroupId%>";
                <%else%>
                url = "/Admin/Module/eCom_Catalog/dw7/edit/EcomProduct_Edit.aspx?ID=" + productId + "&VariantID=" + variantId + "&GroupId=<%=GroupId%>";
                <%end If%>
                parent.location = url;
            },

            openRelatedLimitationDialog: function (rowID, productID, relatedProductID, relatedVariantID, relatedGroupID) {
                this.relatedLimitationRow = rowID; 

                var url = '/Admin/Module/Ecom_Catalog/dw7/edit/EcomProductRelatedLimitations_Edit.aspx?';
                url += 'productID=' + encodeURIComponent(productID);
                url += '&relatedProductID=' + encodeURIComponent(relatedProductID);
                url += '&relatedVariantID=' + encodeURIComponent(relatedVariantID);
                url += '&relatedGroupID=' + encodeURIComponent(relatedGroupID);
                <%If FromPim Then%>
                url += '&FromPIM=True'
                <%end If%>

                dialog.show("RelatedLimitationDialog", url);
            },

            onRelatedLimitations_changed: function (event) {
                dialog.hide("RelatedLimitationDialog");
                var limits = event.memo;
                if (!!limits) {
                    var cells = $(this.relatedLimitationRow).childElements();

                    if (cells[1].hasClassName("fa-filter")) {
                        if (!limits.variant) { cells[1].removeClassName("fa-filter"); }
                    } else if (limits.variant) { cells[1].addClassName("fa-filter"); }

                    if (cells[2].hasClassName("fa-filter")) {
                        if (!limits.lang) { cells[2].removeClassName("fa-filter"); }
                    } else if (limits.lang) { cells[2].addClassName("fa-filter"); }

                    if (cells[3].hasClassName("fa-filter")) {
                        if (!limits.country) { cells[3].removeClassName("fa-filter"); }
                    } else if (limits.country) { cells[3].addClassName("fa-filter"); }

                    if (cells[4].hasClassName("fa-filter")) {
                        if (!limits.shop) { cells[4].removeClassName("fa-filter"); }
                    } else if (limits.shop) { cells[4].addClassName("fa-filter"); }
                }
            }

        }
 
    </script>
</body>
</html>
