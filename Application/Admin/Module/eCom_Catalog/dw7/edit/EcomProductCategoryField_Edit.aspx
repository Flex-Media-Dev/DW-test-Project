<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="EcomProductCategoryField_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomProductCategoryField_Edit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" TagName="FieldOptionsList" Src="~/Admin/Module/eCom_Catalog/dw7/controls/FieldOptionsList/FieldOptionsList.ascx" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
		<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
		<dwc:ScriptLib runat="server" ID="ScriptLib">
            <script type="text/javascript" src="/Admin/Content/JsLib/dw/Ajax.js"></script>    
            <script src="/Admin/Images/Ribbon/UI/EditableGrid/EditableGrid.js" type="text/javascript"></script>
            <script src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js" type="text/javascript"></script>
            <script src="/Admin/Module/eCom_Catalog/dw7/js/Watcher.js" type="text/javascript"></script>
            <script type="text/javascript" src="/Admin/Filemanager/Upload/js/EventsManager.js"></script>
            <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Richselect/Richselect.js"></script>
            <script src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" type="text/javascript"></script>  
            <script src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js" type="text/javascript"></script>   
            <script src="/Admin/Module/eCom_Catalog/dw7/controls/FieldOptionsList/FieldOptionsList.js" type="text/javascript"></script>
        </dwc:ScriptLib>
    
        <link rel="StyleSheet" href="/Admin/Images/Ribbon/UI/Richselect/Richselect.css" type="text/css" />
        <link rel="StyleSheet" href="/Admin/Module/eCom_Catalog/dw7/controls/FieldOptionsList/FieldOptionsList.css" type="text/css" />

		<style>
            .richselectitem .description {
                font-size: 11px;
                margin-top: 4px;
            }

		    .warning-icon {
		        width: 16px;
		        height: 16px;
                display: inline-block;
                vertical-align: middle;
		        background-repeat: no-repeat;
		        background-image: url(/Admin/Images/Ribbon/Icons/Small/warning.png);
		    }
		    /*.btn-group.bootstrap-select {
                display:block !important;
		    }
            .hide {
                display: none !important;
            }*/
		</style>
    
		<script type="text/javascript">
            var listTypeID = <%= ListTypeID %>;
            var checkBoxTypeID = <%= CheckBoxTypeID %>;
            var categoryId = '<%= FieldCategoryId %>';
            var allCategoryFieldsIds = <%= Core.Converter.Serialize(GetCategoryFieldsIds()) %>;
            var isNewField = <%= Core.Converter.Serialize(IsNew) %>;
            var initDone = false;

            $(document).observe('dom:loaded', function () {
                document.getElementById('Name').focus();
                
                //set fields system names autofill
                var fieldNameEditor = document.getElementById("Name");
                var systemNameEditor = document.getElementById("SystemName");
                var fieldTagEditor = document.getElementById("TemplateTag");

                fieldNameEditor.addEventListener("blur", function () {
                    if (!systemNameEditor.disabled) {          
                        setSystemName(fieldNameEditor, systemNameEditor);     
                    }
                    setSystemName(fieldNameEditor, fieldTagEditor);
                });

                systemNameEditor.addEventListener("blur", function () {                
                    setSystemName(fieldNameEditor, systemNameEditor);
                });

                fieldTagEditor.addEventListener("blur", function () {                
                    setSystemName(fieldNameEditor, fieldTagEditor);
                });            

                function setSystemName(fromObject, toObject) {
                    if (!toObject.value.trim()) {
                        toObject.value = fromObject.value.strip().replace(/\s+/g, "_").replace(/[^a-zA-Z0-9_]+/g, "");
                    } else {
                        toObject.value = toObject.value.strip().replace(/\s+/g, "_").replace(/[^a-zA-Z0-9_]+/g, "");
                    }
                }
                initDone = true;
            });
            
            function save(close) {
                if (!validateForm()) {
                    return false;
                }
                document.getElementById("Close").value = close ? 1 : 0;
                document.getElementById('fieldForm').SaveButton.click();
            }
            function deleteField() {
                if (confirm('<%= Translate.JsTranslate("Do you want delete field?") %>')) {
                    document.getElementById('fieldForm').DeleteButton.click(); 
                }
            }

            function checkFieldType(selectPicker) {
                var optionsContainer = document.getElementById("rowOptions");
                optionsContainer.style.display = selectPicker.value == listTypeID ? "block" : "none";
                var presentationTypeContainer = document.getElementById("rowPresentationType");
                presentationTypeContainer.style.display = selectPicker.value == listTypeID ? "block" : "none";
                var checkboxDefaultValueContainer = document.getElementById("rowCheckbox");
                checkboxDefaultValueContainer.style.display = selectPicker.value == checkBoxTypeID ? "block" : "none";
            }
            
            function validateForm() {  
                var nameMessage = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Please fill name")%>';
                var systemNameMessage = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Please fill system name")%>';
                var systemNameAlreadyExistsMessage = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("A field with the same system name already exists")%>';
                var tagMessage = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Please fill tag name")%>';
                var result = validateInput("TemplateTag", tagMessage) & validateInput("SystemName", systemNameMessage) & isSystemNameIsUnique(systemNameAlreadyExistsMessage)
                    & validateInput("Name", nameMessage) & FieldOptionsList.validate();

                var fieldDataTypeReferenceEl = document.getElementById("FieldDataType_2" /*"FieldDataTypeReference"*/);
                if (fieldDataTypeReferenceEl.checked) {
                    var referenceMessage = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Select reference field to add")%>';
                    var selector = document.querySelector("select.selectpicker[name=systemFieldsSelector]");
                    if (!selector.value.trim()) {
                        var selectorContainer = document.getElementById("systemFieldsSelector");
                        dwGlobal.showControlErrors(selectorContainer, referenceMessage);
                        selectorContainer.focus();
                        result = false;
                    } else {
                        result = result & true;
                    }                    
                }
                return result;
            }

            function isSystemNameIsUnique(message) {
                if (isNewField) {
                    var sysNameEl = document.getElementById("SystemName");
                    if (allCategoryFieldsIds.findIndex(id => id.toLowerCase() == sysNameEl.value.toLowerCase()) > -1) {
                        dwGlobal.showControlErrors(sysNameEl, message);
                        sysNameEl.focus();
                        return false;
                    }
                }
                return true;
            }
            
            function validateInput(id, message) {               
                var input = document.getElementById(id);
                if (!input.value.trim()) {
                    dwGlobal.showControlErrors(input, message);
                    input.focus();
                    return false;
                } else {
                    return true;
                }
            }
            
            function referenceFieldChanged(selectedValue, selectorInitialize) {   
                if (!selectorInitialize) {
                    if (selectedValue) {
                        var fieldSelector = document.querySelector("select.selectpicker[name=systemFieldsSelector]");
                        var categoryHidden = document.getElementById('SystemFieldCategory');
                        categoryHidden.value = fieldSelector.options[fieldSelector.selectedIndex].getAttribute("foreign-group-id");   
                        location.href = `EcomProductCategoryField_Edit.aspx?categoryId=${categoryId}&refCategoryId=${categoryHidden.value}&refFieldId=${selectedValue}`
                    } else {
                        location.href = `EcomProductCategoryField_Edit.aspx?categoryId=${categoryId}`
                    }
                }
            }

            function setFieldDataTypeToOrdinary() {
                var selectPicker = jQuery("#systemFieldsSelector").find(".selectpicker");
                selectPicker.prop("disabled", true);
                selectPicker.val("");
                selectPicker.selectpicker('refresh');
                document.getElementById('SystemFieldCategory').value = ''; 
                location.href = `EcomProductCategoryField_Edit.aspx?categoryId=${categoryId}`
            }

            function setFieldDataTypeToReference() {
                var selectPicker = jQuery("#systemFieldsSelector").find(".selectpicker");
                selectPicker.prop("disabled", false);
                selectPicker.selectpicker('refresh');
            }

            function storeFieldDisplayGroups() {
                const fieldsIds = SelectionBox.getElementsRightAsArray("FieldDisplayGroups");
                const storageEl = document.getElementById("FieldDisplayGroupsIDs");
                storageEl.value = fieldsIds;
            }

            function convertToReferenceFieldShowDialog() {
                dialog.show("ConvertToReferenceFieldDialog");
            }          

            function convertToReferenceField() {
                var msg = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Select reference collection")%>';
                if (validateInput("ReferenceCategory", msg)) {
                    document.getElementById('fieldForm').ConvertToReferenceFieldButton.click();
                }
            }

            function showUsageDialog() {
                dialog.show("ReferenceFieldUsageDialog");
            }

            function closeUsageDialog() {
                dialog.hide("ReferenceFieldUsageDialog");
            }
		</script>
</head>
<body class="screen-container">
    <div class="card">        
        <asp:Literal ID="BoxStart" runat="server"></asp:Literal>                
        <form id="fieldForm" runat="server">
            <input id="Close" type="hidden" name="Close" value="false" />
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <dw:Infobar runat="server" DisplayType="Warning" ID="FieldMissedInDefaultLanguage" Visible="false"></dw:Infobar>
                <dwc:InputText runat="server" ID ="Name" Label="Name" ValidationMessage=""></dwc:InputText>
                <dwc:InputText runat="server" ID ="SystemName" Label="System name" ValidationMessage=""></dwc:InputText>
                <dwc:InputText runat="server" ID ="TemplateTag" Label="Template tag" ValidationMessage=""></dwc:InputText>
                <div class="dw-ctrl select-picker-ctrl form-group has-error">
                    <label class="control-label"><%=Translate.Translate("Felttype") %></label>
                    <div class="form-group-input">
                        <dw:GroupDropDownList runat="server" ID="FieldType" ClientIDMode="Static" CssClass="selectpicker" Label=""></dw:GroupDropDownList>
                        <small class="help-block error" id="helpFieldType"></small>
                    </div>
                </div>
                <dwc:InputTextArea runat="server" ID ="Description" Label="Description"></dwc:InputTextArea>   
                <dwc:InputText ID="ValidationPattern" Label="Validation pattern" runat="server" />                
                <dwc:InputText ID="ValidationErrorMessage" Label="Validation error message" runat="server" />
                <dwc:CheckBox runat="server" ID ="HideIfEmpty" Label="Hide if field has no value"></dwc:CheckBox>   
                <dwc:CheckBox runat="server" ID ="DoNotRender" Label="Do not render"></dwc:CheckBox>   
                <div runat="server"  id="rowPresentationType" class="dw-ctrl form-group row-presentation-type" style="display:none">     
                    <label class="control-label">
                        <dw:TranslateLabel ID="TranslateLabel1" Text="Visning_som" runat="server" />
                    </label>  
                    <div class="form-group-input">
                        <dw:Richselect runat="server" ID="ddPresentations" Height="55" Itemwidth="450" Width="450"></dw:Richselect>
                    </div>            
                </div>            
                <div id="rowCheckbox" class="row-checkbox" style="display: none" runat="server">  
                    <dwc:CheckBox runat="server" ID="DefaultValue" Label="Default value" />
                </div>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Field">
                <dwc:RadioGroup runat="server" ID="FieldDataType" Indent="true" >
                    <dwc:RadioButton runat="server" ID="FieldDataTypeOrdinary" Label="Ordinary" FieldValue="1" OnClick="setFieldDataTypeToOrdinary()" />
                    <dwc:RadioButton runat="server" ID="FieldDataTypeReference" Label="Reference"  FieldValue="2" OnClick="setFieldDataTypeToReference()" />
                </dwc:RadioGroup>
                <div class="dw-ctrl form-group">
                    <label class="control-label"><dw:TranslateLabel runat="server" Text="Reference"/></label>
                    <div class="form-group-input">
                        <dwc:SelectPicker runat="server" ID="SystemFieldsSelector" ValidationMessage="" ></dwc:SelectPicker>
                        <input runat="server" id="SystemFieldCategory" type="hidden" name="SystemFieldCategory" value="" />
                    </div>
                </div>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Field settings">  
                <dwc:CheckBox runat="server" ID ="LanguageEditing" Label="Allow change of field content across all languages"></dwc:CheckBox>
                <dwc:CheckBox runat="server" ID ="VariantEdiding" Label="Allow change of field content across all variants"></dwc:CheckBox>
                <dwc:CheckBox runat="server" ID ="IsRequired" Label="Required field"></dwc:CheckBox>
                <dwc:CheckBox runat="server" ID ="IsReadOnly" Label="Read only"></dwc:CheckBox>
                <dwc:CheckBox runat="server" ID ="IsHidden" Label="Hidden"></dwc:CheckBox>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" ID="groupBoxFieldDisplayGroups" Title="Field Display Groups" Visible="false">
                <div class="form-group">
                    <label class="control-label">&nbsp;</label>
                    <dw:SelectionBox ID="FieldDisplayGroups" runat="server" Label="" Width="250" Height="250" ShowSortRight="true" />
                    <input type="hidden" name="FieldDisplayGroupsIDs" id="FieldDisplayGroupsIDs" value="" runat="server" />
                </div>
            </dwc:GroupBox>

            <div id="rowOptions" class="row-options" style="display: none" runat="server">
                <dwc:GroupBox runat="server" Title="Options">
                    <div id="errFieldOptions" style="color: Red;"></div>
                    <ecom:FieldOptionsList ID="optionsList" runat="server" />
                </dwc:GroupBox>
            </div>
            <dw:Dialog ID="ConvertToReferenceFieldDialog" runat="server" Title="Convert to reference field" Width="250" ShowCancelButton="true" ShowClose="false"
                ShowOkButton="true" OkAction="convertToReferenceField();">
                <dw:GroupBox runat="server">
                    <dwc:SelectPicker ID="ReferenceCategory" runat="server" Label="Reference collection" ValidationMessage="" Container="body"></dwc:SelectPicker>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="ReferenceFieldUsageDialog" runat="server" Title="Usages" Width="250" ShowCancelButton="false" ShowClose="false"
                ShowOkButton="true" OkAction="closeUsageDialog();">
                <dw:List runat="server" ID="ReferenceFieldUsagesList" AllowMultiSelect="false" NoItemsMessage="This field is not used in any categories yet." Title="This field is used as reference source for" PageSize="1000">
                    <Columns>
                        <dw:ListColumn ID="colCategoryName" runat="server" Name="Category" />
                        <dw:ListColumn ID="colFieldName" runat="server" Name="Field" />
                    </Columns>
                </dw:List>
            </dw:Dialog>
            
            <asp:Button ID="SaveButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
            <asp:Button ID="ConvertToReferenceFieldButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
        </form>
    </div>
		<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
