<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/PIM/PimMaster.Master"
    AutoEventWireup="false" CodeBehind="PimProductList.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.PimProductList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>
<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <link rel="Stylesheet" href="../css/productList.css" />

    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/ProductListEditingExtended.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/productMenu.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/ProductList.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/EditorWrapper.js"></script>

    <script type="text/javascript">
        var openScreenAction = <%=New Dynamicweb.Management.Actions.OpenScreenAction("", "").ToJson()%>;
        var containerId = '<%=ProductListContent.ClientID%>';
        
        <% If Dynamicweb.Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "selectnode" Then %>
        document.addEventListener("DOMContentLoaded", function () {
            dwGlobal.getPimNavigator().expandAncestors(<%= AncestorsNodesIds.Value %>, <%= AncestorsNodesIds.Value %>);
        });
        <%End If%>
        document.observe("dom:loaded", function () {
            <%=Dynamicweb.Controls.KeyboardShortcutManager.CreateKeyboardShortcutObserver("ctrl+delete", "productMenu.deleteProduct()") %>
        <%If ProductList.PageNumber > 1 Then 'prev page %>
            window.focus();
            var prevButton = $(containerId).select(".prev-page")[0];
            var prevButtonAction = function () { };
            if (prevButton && prevButton.onclick) {
                prevButtonAction = prevButton.onclick;
            }
            prevButton.title = 'Ctrl + Shift + PageDown';
            prevButton.focus();
            <%=Dynamicweb.Controls.KeyboardShortcutManager.CreateKeyboardShortcutObserver("ctrl+shift+pagedown", "prevButtonAction()")%>
        <%End If%>
        <%If ProductList.PageNumber < ProductList.PageCount Then 'next page %>
            window.focus();
            var nextButton = $(containerId).select(".next-page")[0];
            var nextButtonAction = function () { };
            if (nextButton && nextButton.onclick) {
                nextButtonAction = nextButton.onclick;
            }
            nextButton.title = 'Ctrl + Shift + PageUp';
            nextButton.focus();
            <%=Dynamicweb.Controls.KeyboardShortcutManager.CreateKeyboardShortcutObserver("ctrl+shift+pageup", "nextButtonAction()")%>
        <%End If%>
        });
    </script>
</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    
    <div id="ProductListContent" class="list-wrap" runat="server">
        <dw:List ID="ProductList" ShowTitle="false" runat="server" Personalize="True"
            HandlePagingManually="True" HandleSortingManually="True" UseCountForPaging="True"
            AllowMultiSelect="true" OnRowExpand="OnRowExpand" OnClientSelect="Dynamicweb.PIM.BulkEdit.get_current().productListItemSelected();" PageSize="25">
        </dw:List>
        <dw:List ID="VariantsProductList" ClientIDMode="Static" ShowTitle="false" runat="server" Personalize="True" Visible="false">
        </dw:List>
    </div>
    <dw:ContextMenu ID="ProductContext" runat="server" OnClientSelectView="productMenu.onContextMenuView">
        <dw:ContextMenuButton ID="editProductButton" Views="common,ungroup" runat="server" Icon="Pencil" Text="Edit product" OnClientClick="productMenu.editProduct();" Divide="After" />
        
        <dw:ContextMenuButton ID="copyProductButton" Views="common" runat="server" Icon="ContentCopy" OnClientClick="productMenu.copyProduct();" Text="Copy" />
        <dw:ContextMenuButton ID="moveProductButton" Views="common" runat="server" Icon="ArrowRight" OnClientClick="productMenu.moveProduct();" Text="Move" />
        
        <dw:ContextMenuButton ID="activateProductsButton" Views="common,ungroup" runat="server" Icon="Check" IconColor="Default" OnClientClick="productMenu.activateProduct();" Text="Activate" Divide="Before" />
        <dw:ContextMenuButton ID="deactivateProductsButton" Views="common,ungroup" runat="server" Icon="Times" IconColor="Default" OnClientClick="productMenu.deactivateProduct();" Text="Deactivate" />

        <dw:ContextMenuButton ID="attachProductsButton" Views="common,ungroup" runat="server" Icon="AttachFile" OnClientClick="productMenu.attachMultipleProducts();" Text="Add to group" Divide="Before" />
        <dw:ContextMenuButton ID="detachProductsButton" Views="common,ungroup" runat="server" Icon="NotInterested" OnClientClick="productMenu.detachProduct();" Text="Detach from group" />

        <dw:ContextMenuButton ID="deleteProductButton" Views="common,ungroup" runat="server" Icon="Delete" Text="Delete" OnClientClick="productMenu.deleteProduct();" OnClientGetState="productMenu.getStateForDeleteAction();" Divide="Before" />
    </dw:ContextMenu>
    
    <dw:Dialog ID="VariantDialog" Size="Large" HidePadding="True" Title="Variants" TranslateTitle="true" runat="server">
          <iframe id="VariantDialogFrame" style="height: 100vh"></iframe>
    </dw:Dialog>
    
</asp:Content>

<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterHolder" runat="server">
    <script type="text/javascript">        

        new overlay('__ribbonOverlay').hide();

        Dynamicweb.PIM.BulkEdit.get_current().initialize({
            viewMode: "<%= GetListViewMode()%>",
            isReadOnly: <%= IsReadOnly.ToString().ToLower() %>,
            actions: {
                openDialog: <%= New OpenDialogAction("").ToJson() %>
            },
            permissions: <%= GetPermissions()%>
        });

        Dynamicweb.PIM.BulkEdit.get_current().terminology["NavigateToRelated"] = "<%=Translate.translate("Not saved changes will be lost, navigate to %% product?").Replace("%%", Translate.Translate("related"))%>";
        
        Dynamicweb.PIM.BulkEdit.get_current().confirmAction = <%=New ConfirmMessageAction(Translate.Translate("Confirm Action"), "").ToJson()%>;
        Dynamicweb.PIM.BulkEdit.get_current().openScreenAction = <%=New OpenScreenAction("", "").ToJson()%>;        
        	    
	    function help(){
		    <%=Dynamicweb.SystemTools.Gui.Help("", "ecom.pimproductlist", "en") %>
	    }

        productMenu._warningAssortmentsMessage = '<%= Translate.JsTranslate("Assortments module is not installed. Only ungrouped products will processed.")%>';
	    productMenu._successCopyMessage = '<%= Translate.JsTranslate("The selected products were successfully copied.")%>';
	    productMenu._confirmCopyFromNonPromaryGroup = '<%= Translate.JsTranslate("Current group is not primary. Product will be related to this group during related groups copying.")%>';
	    productMenu._failureCopyMessage = '<%= Translate.JsTranslate("Errors occurred when copying the products. Some products may have been copied. Error message:")%>';
        productMenu._deleteMessage = '<%= Translate.JsTranslate("Slet?")%>';
        productMenu._deleteMessage2 = '<%= Translate.JsTranslate("Slet?")%>';
        productMenu._detachMessage = '<%= Translate.JsTranslate("Do you want to detach the selected products? This will remove all language versions of the selected products from the group!")%>';
	    productMenu._failureDetachMessage = '<%= Translate.JsTranslate("Errors occurred when detaching the products. Some products may have been detached.")%>';
        <%If String.IsNullOrWhiteSpace(EcomGroupId) Then %>
        productMenu._queryId = '<%=QueryId%>';
        productMenu._groupId = '<%=GroupId%>';
        <%End If%>
    </script>
</asp:Content>
