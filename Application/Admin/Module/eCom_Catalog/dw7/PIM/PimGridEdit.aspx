<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/PIM/PimMaster.Master"
    AutoEventWireup="false" CodeBehind="PimGridEdit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.PimGridEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>
<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <link rel="Stylesheet" href="../css/productList.css" />
    <link rel="Stylesheet" href="PimGridEdit.css" />
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/ProductListEditingExtended.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/productMenu.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/ProductList.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/PIM/PimGridEdit.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/EditorWrapper.js"></script>

    <script type="text/javascript">
        var openScreenAction = <%=New Dynamicweb.Management.Actions.OpenScreenAction("", "").ToJson()%>;        

        var controlRows = [];
    </script>
</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <input type="hidden" name="ids" value="<%=Request("ids")%>" />
    <input type="hidden" id="currentProductRow" value="" />
    <input type="hidden" id="currentFieldType" value="" />
    <input type="hidden" id="currentFieldId" value="" />
    <asp:HiddenField ID="FocusedFieldId" ClientIDMode="Static" runat="server" />

    <div id="ProductListContent" class="list-wrap" runat="server">
        <div class="main-content">
            <table class="cells" id="productsContainer">
                <thead>
                    <tr class="row header-row">
                        <asp:Repeater runat="server" ID="FieldsRepeater">
                            <ItemTemplate>
                                <th class="column-header <%# GetCellClasses(CType(Container.DataItem, Dynamicweb.Admin.eComBackend.ProductList.Field)) %>">
                                    <div class="column-header-text"><%# CType(Container.DataItem, Dynamicweb.Admin.eComBackend.ProductList.Field).Name %></div>
                                    <span id="<%# CType(Container.DataItem, Dynamicweb.Admin.eComBackend.ProductList.Field).Id %>_Filter" class="column-header-adornment filtering-adornment hidden"><%=KnownIconInfo.GetIconHtml(KnownIcon.Filter)%></span>
                                    <span id="<%# CType(Container.DataItem, Dynamicweb.Admin.eComBackend.ProductList.Field).Id %>_ASC" class="column-header-adornment sorting-adornment hidden"><%=KnownIconInfo.GetIconHtml(KnownIcon.ArrowDown)%></span>
                                    <span id="<%# CType(Container.DataItem, Dynamicweb.Admin.eComBackend.ProductList.Field).Id %>_DESC" class="column-header-adornment sorting-adornment hidden"><%=KnownIconInfo.GetIconHtml(KnownIcon.ArrowUp)%></span>
                                    <%# GetColumnFunctionsIcon(CType(Container.DataItem, Dynamicweb.Admin.eComBackend.ProductList.Field))%>
                                </th>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater runat="server" ID="ProductsRepeater">
                        <ItemTemplate>
                            <tr class="row<%# GetproductRowClass(CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product))%>" data-product-id="<%# CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product).Id%>" data-variant-id="<%# CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product).VariantId%>" data-language-id="<%# CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product).LanguageId%>" data-original-sorting="<%# Container.ItemIndex %>">
                                <%#GetProductFieldsOutput(CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product)) %>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </div>
    <dw:ContextMenu ID="FunctionsContextMenu" runat="server" OnClientSelectView="onGridContextMenuView">
        <dw:ContextMenuButton runat="server" ID="SetValueContextMenuButton" Text="Set Values" OnClientClick="showSetValueDialog();" icon="Pencil" Views="common,filtering,sorting,filteringAndSorting,Replace,sortingReplace,filteringReplace,filteringAndSortingReplace"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="ReplaceContextMenuButton" Text="Search and replace" OnClientClick="showReplaceDialog();" icon="FindReplace" Views="Replace,sortingReplace,filteringReplace,filteringAndSortingReplace"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="FilterContextMenuButton" Text="Filter" OnClientClick="showFilteringDialog();" icon="Filter" Divide="Before" Views="common,filtering,sorting,filteringAndSorting,Replace,sortingReplace,filteringReplace,filteringAndSortingReplace"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="SortAscContextMenuButton" Text="Sort ascending" OnClientClick="sortAsc();" icon="SortAmountAsc" Divide="Before" Views="common,filtering,sorting,filteringAndSorting,Replace,sortingReplace,filteringReplace,filteringAndSortingReplace"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="SortDescContextMenuButton" Text="Sort descending" OnClientClick="sortDesc();" icon="SortAmountDesc" Views="common,filtering,sorting,filteringAndSorting,Replace,sortingReplace,filteringReplace,filteringAndSortingReplace"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="ClearFilterContextMenuButton" Text="Reset filter" OnClientClick="removeFiltering();" icon="Close" Divide="Before" Views="filtering,filteringAndSorting,filteringReplace,filteringAndSortingReplace"></dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" ID="ClearSortContextMenuButton" Text="Remove sorting" OnClientClick="removeSorting();" icon="Close" Divide="Before" Views="sorting,filteringAndSorting,sortingReplace,filteringAndSortingReplace"></dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:Dialog ID="SetValueDialog" runat="server" ShowOkButton="true" OkAction="updateFieldValues()" Title="Set values" ShowCancelButton="true">
        <dwc:GroupBox runat="server">
            <div id="editorsContainer" class="editorsContainer">
                <dwc:InputText runat="server" ID="TextFieldEditor" Label="Value" />
                <dw:Editor runat="server" ID="EditorTextFieldEditor" Height="200" Label="Value" />
                <dwc:InputTextArea runat="server" ID="TextLongFieldEditor" Rows="5" Label="Value" />
                <dwc:SelectPicker runat="server" ID="SelectFieldEditor" Label="Value" />
                <dwc:SelectPicker runat="server" ID="MultiSelectListFieldEditor" Label="Value" AllowSearch="true" Multiple="true"/>
                <dwc:InputNumber runat="server" ID="IntegerFieldEditor" IncrementSize="1" ClientIDMode="Static" Label="Value" />
                <dwc:InputNumber runat="server" ID="DoubleFieldEditor" IncrementSize="0.01" ClientIDMode="Static" Label="Value" />
                <dw:LinkManager runat="server" ID="LinkFieldEditor" Label="Value" />
                <dw:DateSelector runat="server" ID="DateFieldEditor" Label="Value" IncludeTime="False" />
                <dw:DateSelector runat="server" ID="DateTimeFieldEditor" Label="Value" IncludeTime="True" />
            </div>
        </dwc:GroupBox>
    </dw:Dialog>

    <dw:Dialog ID="FilterDialog" runat="server" ShowOkButton="true" OkAction="filterRows()" Title="Filtering" ShowCancelButton="true">
        <dwc:GroupBox runat="server">
            <dwc:InputText runat="server" ID="FilterText" Label="Value" />
        </dwc:GroupBox>
    </dw:Dialog>

    <dw:Dialog ID="ReplaceDialog" runat="server" ShowOkButton="true" OkAction="replaceValues()" Title="Search and replace" ShowCancelButton="true">
        <dwc:GroupBox runat="server">
            <dwc:InputText runat="server" ID="SearchValue" Label="Search value" />
            <dwc:InputText runat="server" ID="ReplacementValue" Label="Replacement" />
        </dwc:GroupBox>
    </dw:Dialog>

</asp:Content>

<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterHolder" runat="server">
    <script type="text/javascript">        


        Dynamicweb.PIM.BulkEdit.get_current().initialize({
            viewMode: 'GridEditView',
            isReadOnly: <%= IsReadOnly.ToString().ToLower() %>,
            actions: {
                openDialog: <%= New OpenDialogAction("").ToJson() %>,
                closeAction: <%=New OpenScreenAction(Dynamicweb.Core.Converter.ToString(Request("returnUrl")) + "&KeepListSettings=true").ToJson()%>
            }
        });

        Dynamicweb.PIM.BulkEdit.get_current().terminology["NavigateToRelated"] = "<%=Translate.translate("Not saved changes will be lost, navigate to %% product?").Replace("%%", Translate.Translate("related"))%>";
        
        Dynamicweb.PIM.BulkEdit.get_current().confirmAction = <%=New ConfirmMessageAction(Translate.Translate("Confirm Action"), "").ToJson()%>;
        Dynamicweb.PIM.BulkEdit.get_current().openScreenAction = <%=New OpenScreenAction("", "").ToJson()%>;

        Dynamicweb.PIM.BulkEdit.get_current().DateFieldEditorId = "<%=DateFieldEditor.UniqueID%>";
        Dynamicweb.PIM.BulkEdit.get_current().DateTimeFieldEditorId = "<%=DateTimeFieldEditor.UniqueID%>";

        function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("", "ecom.pimpgridedit", "en") %>
        };

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

        setButtonsTooltip("FunctionsContextMenu", "<%=Translate.JsTranslate("Function available in viewmode: Simple view.")%>");

        if (window.CKEDITOR) {
            CKEDITOR.instances['EditorTextFieldEditor'].on("instanceReady", function () {
                new overlay('__ribbonOverlay').hide();
            });
        } else {
            new overlay('__ribbonOverlay').hide();
        }

</script>
</asp:Content>
