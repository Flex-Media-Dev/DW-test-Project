<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/PIM/PimMaster.Master" CodeBehind="PimMultiEdit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.PimMultiEdit" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript">
        function help() {
		    <%=Gui.Help("", "ecom.pimmultiedit", "en") %>
        }

        var controlRows = [];
        var currentlyFocused = "";
    </script>
    <script src="/Admin/Filemanager/Browser/FileList.js"></script>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="ContentHolder" runat="server">
    <div id="ProductsContainer" runat="server" class="pcm-wrap" style="height: 100%">
        <div class="pcm-list-item pcm-wrap-header">
            <div class="pcm-list-item-body">
                <div class="pcm-list-left">
                    <div class="pcm-list-check-all">
                        <dwc:CheckBox runat="server" ID="SelectAll" OnClick="Dynamicweb.PIM.BulkEdit.get_current().selectProduct(this,'');" ClientIDMode="Static" />
                    </div>
                </div>
                <div class="pcm-list-fields pcm-list-fields--head flag-header">
                    <table class="pcm-list-fields-table">
                        <thead>
                            <tr>
                                <td></td>
                                <asp:Repeater ID="LanguagesRepeater" runat="server" EnableViewState="false">
                                    <ItemTemplate>
                                        <td>
                                            <div class="pcm-list-flag"><i class="<%#GetFlagIcon(Container.DataItem) %>" title="<%# CType(Container.DataItem, Dynamicweb.Ecommerce.International.Language).Name %>"></i></div>
                                        </td>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Repeater ID="FieldNamesRepeater" runat="server" EnableViewState="false" Visible="false">
                                    <ItemTemplate>
                                        <td>
                                            <%#Container.DataItem%>
                                        </td>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
        <div id="listContainer" class="pcm-list">
            <dw:Infobar runat="server" ID="NoProductsInfobar" Message="Ingen data" Visible="false" />
            <asp:Repeater ID="ProductsRepeater" runat="server" EnableViewState="false">
                <ItemTemplate>
                    <div class="pcm-list-item <%#GetAlternate(string.IsNullOrEmpty(CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product).VariantId)) %> <%#If(HideAfterValidation(CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product)), "hidden", "")%>">
                        <div class="pcm-list-item-body">
                            <div class="pcm-list-state" id="state1"></div>
                            <div class="pcm-list-left">
                                <div class="updated-header-fill clearfix">
                                    <div class="pcm-list-check pull-left" onclick="event.stopPropagation();">
                                        <dwc:CheckBox runat="server" ID="SelectedProduct" CssClass="pcm-list-check"  ClientIDMode="Static" />
                                    </div>
                                    <div class="pull-left">
                                        <%#GetProductDraftInfo(CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product)) %>
                                    </div>
                                </div>
                                <div onclick="<%#GetProductOnClick(CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product)) %>" class="pcm-list-item-header cursor-pointer">
                                    <div class="pcm-thumb">
                                        <%#GetProductImage(Ctype(Container.DataItem, Dynamicweb.Ecommerce.Products.Product)) %>
                                    </div>
                                    <div class="pcm-list-left-info pull-left">
                                        #<%#CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product).Id%>
                                    </div>
                                    <div class="pcm-list-left-info pull-left">
                                        <%#GetProductCreated(CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product)) %>
                                    </div>
                                </div>
                                <div class="pcm-list-left-info  align-center">
                                    <%#GetProductVariansIcon(CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product)) %>
                                </div>
                                <div class="pcm-list-left-info  align-center">
                                    <%#GetProductVariantsCount(CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product)) %>
                                </div>
                            </div>
                            <div style="width: 100%;">
                                <div class="pcm-list-fields-header-info">
                                    <table class="pcm-list-fields-table">
                                        <thead>
                                            <tr>
                                                <td>
                                                    <div class="pcm-list-item-header-title" title="<%#Container.DataItem.Name%>">
                                                        <%#Container.DataItem.Name%>
                                                    </div>
                                                </td>
                                                <asp:Repeater ID="ProductUpdatedInfo" runat="server" EnableViewState="false">
                                                    <ItemTemplate>
                                                        <td>
                                                            <div class="product-updated-info">
                                                                <%#Container.DataItem%>
                                                            </div>
                                                        </td>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                                <div class="pcm-list-fields">
                                    <%#GetProductFieldsOutput(CType(Container.DataItem, Dynamicweb.Ecommerce.Products.Product)) %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="pcm-list-item pcm-list-fill">
                        <div class="pcm-list-item-body">
                            <div class="pcm-list-left">
                            </div>                                    
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <%=GetPaging() %>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </div>

    <dw:Dialog ID="EditorDialog" ShowOkButton="true" Size="large" HidePadding="true" ShowCancelButton="true" ShowClose="true" OkAction="Dynamicweb.PIM.BulkEdit.get_current().closeEditorDialog();" runat="server">
        <dwc:GroupBox runat="server">
            <div class="pcm-editor-container">
                <asp:Repeater ID="EditorDialogRepeater" runat="server" EnableViewState="false">
                    <ItemTemplate>
                        <div class="pcm-editor">
                            <div class="pcm-editor-flag"><i class="<%#GetFlagIcon(Container.DataItem) %>" title="<%# CType(Container.DataItem, Dynamicweb.Ecommerce.International.Language).Name %>"></i></div>
                            <div class="pcm-editor-content"><%#GetEditorContent(CType(Container.DataItem, Dynamicweb.Ecommerce.International.Language)) %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </dwc:GroupBox>
    </dw:Dialog>

    <dw:Dialog ID="ProductImagesPicker" Title="Select images" ShowOkButton="true" Size="Medium" ShowCancelButton="true" ShowClose="true" OkAction="Dynamicweb.PIM.BulkEdit.get_current().changeImages();" runat="server">
        <dwc:GroupBox runat="server" DoTranslation="true" Title="Product images">
            <dw:FileManager runat="server" ID="ProductImageSmall" AllowBrowse="true" Extensions="jpg,gif,png,swf,webp" FullPath="true" />
            <dw:FileManager runat="server" ID="ProductImageMedium" AllowBrowse="true" Extensions="jpg,gif,png,swf,webp" FullPath="true" />
            <dw:FileManager runat="server" ID="ProductImageLarge" AllowBrowse="true" Extensions="jpg,gif,png,swf,webp" FullPath="true" />
        </dwc:GroupBox>
    </dw:Dialog>

    <dw:Dialog ID="SelectImageGroupDialog" runat="server" Title="Assign to image category" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" OkAction="Dynamicweb.PIM.BulkEdit.get_current().assignImageGroup();">
        <dwc:GroupBox runat="server">
            <dwc:SelectPicker ID="ImageGroupPicker" runat="server" Label="Image category" ClientIDMode="Static"></dwc:SelectPicker>
        </dwc:GroupBox>
    </dw:Dialog>
    
    <dw:Dialog ID="ImageManagementDialog" Size="Large" runat="server" Title="Manage images" HidePadding="True" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
        <iframe id="ImageManagementDialogFrame"></iframe>
    </dw:Dialog>
            
    <dw:Dialog runat="server" ID="VideoDetailPreview" Title="Video detail preview" HidePadding="True" Size="Large" >
        <div id="VideoDetailPreviewContainer"></div>
    </dw:Dialog>   

</asp:Content>

<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterHolder" runat="server">
    <script type="text/javascript">        

        new overlay('__ribbonOverlay').hide();

        Dynamicweb.PIM.BulkEdit.get_current().initialize({
            viewMode:'TableView',
            urls: {
                taskRunner: "/Admin/Module/eCom_Catalog/dw7/PIM/Task.aspx"
            },
            actions: {
                openDialog: <%= New OpenDialogAction("").ToJson() %>
            },
            permissions: <%= GetPermissions()%>
        });

        Dynamicweb.PIM.BulkEdit.get_current().terminology["NavigateToRelated"] = "<%=Translate.translate("Not saved changes will be lost, navigate to %% product?").Replace("%%", Translate.Translate("related"))%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["SelectPickerNoneOptionText"] = "<%=Translate.translate("None")%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["SetDefaultImage"] = "<%=Translate.Translate("Set as default")%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["RemoveDefaultImage"] = "<%=Translate.Translate("Remove as default")%>"; 
        
        Dynamicweb.PIM.BulkEdit.get_current().confirmAction = <%=New ConfirmMessageAction(Translate.Translate("Confirm Action"), "").ToJson()%>;
        Dynamicweb.PIM.BulkEdit.get_current().openScreenAction = <%=New OpenScreenAction("", "").ToJson()%>;

        document.onkeydown = checkKey;            

        var controlRowsMapped = controlRows.map(function (row) {
            return row.map(function(column) {
                return column.controlId;
            });
        });

        var openScreenAction = <%=New Dynamicweb.Management.Actions.OpenScreenAction("", "").ToJson()%>

        //controls keyboard navigate handler
        function checkKey(e) {
            e = e || window.event;
            if (document.activeElement && document.activeElement.id) {
                currentlyFocused = document.activeElement.id;
            }
            if (currentlyFocused) {
                if (e.keyCode == '38' || e.keyCode == '40') {
                    // up arrow
                    var index = [-1, -1];

                    controlRowsMapped.some(function (sub, posX) {
                        var posY = sub.indexOf(currentlyFocused);

                        if (posY !== -1) {
                            index[0] = posX;
                            index[1] = posY;
                            return true;
                        }

                        return false;
                    });

                    if (index[0] != -1 && index[1] != -1) {
                        var nextControlIndex = index[0];
                        if (e.keyCode == '40' && index[0] != controlRowsMapped.length - 1) {
                            nextControlIndex = index[0] + 1;
                        } else if (e.keyCode == '38' && index[0] != 0) {
                            nextControlIndex = index[0] - 1;
                        }
                        var nextFocusedControlId = controlRowsMapped[nextControlIndex][index[1]];
                        var nextFocusedControl = $(nextFocusedControlId);
                        if (nextFocusedControl) {
                            currentlyFocused = nextFocusedControlId;
                            if ($$("span.focused")[0]) {
                                $$("span.focused")[0].removeClassName("focused");
                            } else {
                                document.activeElement.blur();
                            }
                            if (nextFocusedControl.tagName == "SPAN") {
                                nextFocusedControl.addClassName("focused");
                            } else {
                                nextFocusedControl.focus();
                            }
                            e.stopPropagation();
                            e.preventDefault();
                        }
                    }
                }
            }
        }

        var header = $$(".pcm-wrap-header")[0];
        var list = $$(".pcm-list")[0];

        list.on('scroll', function () {
            header.scrollLeft = list.scrollLeft;
        });
    </script>
</asp:Content>
