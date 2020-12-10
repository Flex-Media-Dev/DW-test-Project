<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FieldsBulkEdit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.FieldsBulkEdit" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeRequireJS="False" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
            <dw:GenericResource Url="/Admin/Editor/ckeditor/ckeditor/ckeditor.js" />
            <dw:GenericResource Url="/Admin/Link.js" />

            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/Main.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ProductListEditingExtended.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/ProductListEditingExtended.css" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/ProductImageBlocks.css" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/productMenu.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/EditorWrapper.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/pickadaySetup.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/pickadayBundle.js" />
            <dw:GenericResource Url="/Admin/Filemanager/Browser/FileList.js" />
            
            <dw:GenericResource Url="/Admin/Resources/vendors/slim-select/slimselect.min.css" />
            <dw:GenericResource Url="/Admin/Resources/vendors/slim-select/slimselect.min.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwselector.js"/>
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js"/>
            <dw:GenericResource Url="/Admin/Resources/js/SettingPresets.js" />
        </Items>
    </dw:ControlResources>

    <script>
        function initFieldsBulkEditPage(opts) {
            var options = opts;
            var obj = {
                init: function () {
                    Dynamicweb.PIM.BulkEdit.get_current().initialize(options);
                    Dynamicweb.PresetSettings.get_current().initialize(options);
                },

                cancel: function () {
                    Action.Execute(options.actions.cancel);
                },

                save: function (saveAndClose) {
                    var currentPage = Dynamicweb.PIM.BulkEdit.get_current();
                    var editedFields = currentPage.getEditedFields();
                    var selectedLanguages = currentPage.getMultiEditLanguageCheckboxes(true).map(function (checkbox) { return checkbox.value; }).filter(function (selectedLang) { return selectedLang != "none" });
                    var existingLanguages = document.getElementById("ExistingLanguages").value.split(",");
                    var newLanguages = selectedLanguages.filter(function (selectedLang) { return existingLanguages.indexOf(selectedLang) == -1; });
                    var createNewLanguages = document.getElementById("CreateNonExistingLanguageProducts").checked;

                    var fieldsNames = [];
                    var productsToChangeCount = 0;
                    var affectVariants = false;
                    var affectLanguages = false;

                    for (var i = 0; i < editedFields.length; i++) {
                        var field = editedFields[i];
                        affectVariants = affectVariants || field.variantEditing;
                        affectLanguages = affectLanguages || field.languageEditing;
                        var lbl = "'" + field.label + "'";
                        if (fieldsNames.indexOf(lbl) < 0) {
                            fieldsNames.push(lbl);
                        }
                    }

                    var selectedProducts = currentPage.getSelectedProducts();
                    for (var i = 0; i < selectedProducts.length; i++) {
                        var productid = selectedProducts[i];
                        if (productid == "none") {
                            continue;
                        }

                        var productKeyParts = productid.split(";");
                        var productsInFamily = productKeyParts.length > 1 && !affectVariants ? 0 : 1;
                        if (affectVariants) {
                            var productsVariantCountHidden = document.getElementById("variantCount" + productid);
                            if (productsVariantCountHidden) {
                                var productsVariantCount = parseInt(productsVariantCountHidden.value);
                                productsInFamily += productsVariantCount;
                            }
                        }

                        if (affectLanguages) {
                            if (createNewLanguages) {
                                productsInFamily = productsInFamily * selectedLanguages.length;
                            } else {
                                productsInFamily = productsInFamily * (selectedLanguages.length - newLanguages.length);
                            }
                        }

                        productsToChangeCount = productsToChangeCount + productsInFamily;
                    }

                    var appendManyProductsWarning = productsToChangeCount > 10000;
                    var showTooManyProductsWarning = productsToChangeCount > 25000;
                    var showNewLanguagesWarning = !createNewLanguages && newLanguages.length > 0;

                    var fieldsListStr = fieldsNames.join(", ");
                    var buttons = null;
                    var cancelButtonTitle = null;
                    var msg = Action.Transform(options.labels.confirmSaveMessage, { "fields": fieldsListStr });
                    if (showTooManyProductsWarning) {
                        msg = options.labels.tooManyProducts;
                        buttons = 4;//only cancel
                        cancelButtonTitle = options.labels.OK || "OK";
                    } else if (appendManyProductsWarning) {
                        msg = options.labels.manyProducts + "\r\n" + msg + "\r\n" + options.labels.proceedConfirmMessage;
                    } else if (showNewLanguagesWarning) {
                        msg = options.labels.newLanguagesConfirmMessage;
                    }
                    currentPage.showConfirmMessage(msg, function () {
                        new overlay('__ribbonOverlay').show();
                        currentPage.setSelectedFieldsValues();
                        currentPage.submitFormWithCommand(saveAndClose ? "SaveAndClose" : "Save");
                    }, null, buttons, cancelButtonTitle);
                }
            };
            obj.init();
            return obj;
        }
    </script>
</head>

<body class="area-red screen-container" data-dwselector-supperess-auto-initialization="true">
    <dw:Overlay ID="__ribbonOverlay" runat="server"></dw:Overlay>
    <script type="text/javascript"> 
        new overlay('__ribbonOverlay').show();
    </script>
    <div class="dw8-container fields-bulk-edit-containter">
        <form id="Form1" runat="server">
            <input type="hidden" id="Cmd" name="Cmd" />
            <input type="hidden" id="Ids" name="ids" runat="server" />
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Multiple fields edit" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="true">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save()" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(true)" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" IconColor="Danger" Text="Cancel" runat="server" OnClientClick="currentPage.cancel()" />
                </dw:Toolbar>
                <dwc:CardBody runat="server">
                    <dw:Overlay runat="server" ID="screenLoaderOverlay"></dw:Overlay>
                    <dwc:GroupBox runat="server">
                        <table class="formsTable">
                            <tr>
                                <td>
                                    <dw:TranslateLabel runat="server" Text="Languages" />
                                </td>
                                <td>
                                    <div id="LanguagesTree" runat="server" class="variant-selection-tree with-variants"></div>
                                </td>
                            </tr>
                        </table>
                    </dwc:GroupBox>
                    <dwc:GroupBox runat="server" ID="VariantsTreeGroupbox" Visible="False">
                        <table class="formsTable">
                            <tr>
                                <td>
                                    <dw:TranslateLabel ID="TreeLabel" runat="server" Text="Affected Products" />
                                </td>
                                <td>
                                    <dwc:InputText runat="server" ID="ProductSearchInput" Placeholder="search products" Visible="false">
                                        <AddOns>
                                            <dwc:FieldAddOn Icon="Search" IconColor="Default" OnClick="Dynamicweb.PIM.BulkEdit.get_current().filterProductsBySearchText();" />
                                            <dwc:FieldAddOn Icon="Remove" IconColor="Danger" Title="Reset filter" OnClick="Dynamicweb.PIM.BulkEdit.get_current().resetSearchTextFilter();" />
                                        </AddOns>
                                    </dwc:InputText>
                                    <dwc:Button ID="ClearAllSelection" runat="server" Title="Clear selection" OnClick="Dynamicweb.PIM.BulkEdit.get_current().clearAllSelection();" Visible="false"/>
                                    <div id="ProductsTree" runat="server" class="variant-selection-tree with-variants"></div>
                                </td>
                            </tr>
                        </table>
                    </dwc:GroupBox>
                    <dwc:GroupBox runat="server" ID="SettingsGroupbox" Title="Settings">
                        <dwc:CheckBox runat="server" ID="CreateNonExistingProperties" Label="Add missing property fields" Visible="true" Info="Adds included product property fields to all products included in the bulk-edit" />
                        <dwc:CheckBox runat="server" ID="CreateNonExistingLanguageProducts" Label="Create missing language versions" Info="Creates a language version of all included products for each language included in the bulk-edit" />
                    </dwc:GroupBox>
                    <dwc:GroupBox runat="server">
                        <table class="formsTable">
                            <tr>
                                <td>
                                    <dw:TranslateLabel runat="server" Text="Fields" />
                                </td>
                                <td>
                                    <div style="display: none">
                                        <%-- INFO: Don't remove it! this is initial ckeeditor initialization to support editor from editablegrid--%>
                                        <dw:Editor runat="server" ID="DontRemoveIt1" />
                                        <dw:DateSelector id="DontRemoveItToo2" IncludeTime="true" runat="server" />
                                        <dw:FileManager runat="server" ID="DontRemoveItToo3" AllowBrowse="true" />
                                    </div>
                                    <dw:EditableGrid runat="server" ID="FieldsGrid" AllowAddingRows="true" AllowDeletingRows="true" NoRowsMessage="No Fields" >
                                        <Columns>
                                            <asp:TemplateField ItemStyle-CssClass="multi-edit-field-selector-column" ItemStyle-Width="25%" ItemStyle-VerticalAlign="Top">
                                                <ItemTemplate>
                                                    <dwc:SelectPicker runat="server" ID="Fields" data-dwselector-transform="true"></dwc:SelectPicker>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField ItemStyle-CssClass="multi-edit-field-selector-column">
                                                <ItemTemplate>
                                                    <div id="editorsContainer" runat="server" class="editorsContainer hidden">
                                                        <dwc:InputText runat="server" ID="TextFieldEditor" />
                                                        <dwc:InputTextArea runat="server" ID="TextLongFieldEditor" Rows="5" />
                                                        <dw:Editor runat="server" ID="EditorTextFieldEditor" Height="200" />

                                                        <dwc:SelectPicker runat="server" ID="SelectFieldEditor" />
                                                        <dwc:SelectPicker Multiple="True" DropdownSize="15" CssClass="multiple-list" runat="server" ID="MultiSelectListFieldEditor" />
                                                        <dwc:RadioGroup runat="server" ID="RadioButtonListFieldEditor" Indent="false" />
                                                        <dwc:CheckBoxGroup runat="server" ID="CheckBoxListFieldEditor" />

                                                        <dwc:CheckBox runat="server" ID="BoolFieldEditor" Indent="false" />
                                                        <dwc:CheckBox runat="server" ID="CheckBoxFieldEditor" Indent="false" />

                                                        <dwc:InputNumber runat="server" ID="IntegerFieldEditor" IncrementSize="1" ClientIDMode="Static" />
                                                        <dwc:InputNumber runat="server" ID="DoubleFieldEditor" IncrementSize="0.01" ClientIDMode="Static" />

                                                        <dw:FileManager runat="server" ID="FilemanagerFieldEditor" AllowBrowse="true" FullPath="false" Folder="Images" />
                                                        <dw:LinkManager runat="server" ID="LinkFieldEditor" />
                                                        <div class="form-group">
                                                            <div class="form-group-input">
                                                                <dw:GroupDropDownList runat="server" ID="GroupDropDownListFieldEditor" CssClass="selectpicker" />
                                                            </div>
                                                        </div>

                                                        <asp:Literal ID="ImagesFieldEditor" runat="server" />
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField ItemStyle-CssClass="multi-edit-remove-row-column" ItemStyle-Width="75px" ItemStyle-VerticalAlign="Top" ItemStyle-HorizontalAlign="Center">
                                                <ItemTemplate>
                                                    <div style="padding-top: 8px;">
                                                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>" onclick="dwGrid_FieldsGrid.deleteRows([dwGrid_FieldsGrid.findContainingRow(this)]);"></i>
                                                        <div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </dw:EditableGrid>
                                </td>
                            </tr>
                        </table>

                        <dw:Dialog ID="SelectImageGroupDialog" runat="server" Title="Assign to image category" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" OkAction="Dynamicweb.PIM.BulkEdit.get_current().assignImageGroup();">
                            <dwc:GroupBox runat="server">
                                <dwc:SelectPicker ID="ImageGroupPicker" runat="server" Label="Image category" ClientIDMode="Static"></dwc:SelectPicker>
                            </dwc:GroupBox>
                        </dw:Dialog>

                        <dw:Dialog ID="SavePresetDialog" runat="server" Title="Save preset" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" OkAction="Dynamicweb.PresetSettings.get_current().savePreset();">
                            <dwc:GroupBox runat="server">
                                <dwc:InputText ID="PresetName" runat="server" Label="Name" ClientIDMode="Static" ValidationMessage=""></dwc:InputText>
                            </dwc:GroupBox>
                        </dw:Dialog>
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
        </form>
    </div>
    <script type="text/javascript">
        new overlay('__ribbonOverlay').hide();
    </script>
</body>
</html>
