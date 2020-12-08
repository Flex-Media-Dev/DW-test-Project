<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="EcomField_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomFieldEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" TagName="FieldOptionsList" Src="~/Admin/Module/eCom_Catalog/dw7/controls/FieldOptionsList/FieldOptionsList.ascx" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head>
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var listTypeID = <%=ListTypeID %>;

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();

            Event.observe('FieldTypes', 'change', function () {
                displayStyleValue = $('FieldTypes').value == listTypeID ? '' : 'none';
                $$('tr.row-presentation-type')[0].setStyle({ display: displayStyleValue });
                $('RowOptions').setStyle({ display: displayStyleValue });
            });
        });

        function isEmpty(value) {
            if (!value || value.trim().length == 0) {
                return true;
            }

            return false;
        }

        function formIsValid() {
            var name = $('NameStr');
            var systemName = $('SystemNameStr');
            var templateName = $('TemplateNameStr');
            var pattern = new RegExp("^[^0-9][0-9a-zA-Z_]+$");
            var hasErrors = false;

            if (!templateName.disabled) {
                if (isEmpty(templateName.value)) {
                    dwGlobal.controlErrors('TemplateNameStr', true, '<%= TemplateTagIsEmptyMessage %>');
                    templateName.focus();
                    hasErrors = true;
                } else if (!templateName.value.match(pattern)) {
                    dwGlobal.controlErrors('TemplateNameStr', true, '<%= TemplateIncorrectSyntaxMessage %>');
                    templateName.focus();
                    hasErrors = true;
                } else {
                    dwGlobal.controlErrors('TemplateNameStr', false);
                }
            }

            if (isEmpty(systemName.value)) {
                dwGlobal.controlErrors('SystemNameStr', true, '<%= SystemNameIsEmptyMessage %>');
                systemName.focus();
                hasErrors = true;
            } else if (!systemName.value.match(pattern)) {
                dwGlobal.controlErrors('SystemNameStr', true, '<%= SystemNameIncorrectSyntaxMessage %>');
                systemName.focus();
                hasErrors = true;
            } else {
                dwGlobal.controlErrors('SystemNameStr', false);
            }

            if (isEmpty(name.value)) {
                dwGlobal.controlErrors('NameStr', true, '<%= NameIsEmptyMessage %>');
                name.focus();
                hasErrors = true;
            } else {
                dwGlobal.controlErrors('NameStr', false);
            }
            
            return !hasErrors;
        }

        function save(close) {
            if (formIsValid()) {
                document.getElementById("Close").value = close ? 1 : 0;
                document.getElementById('Form1').SaveButton.click();
            }
        }

        var deleteMsg = '<%= DeleteMessage %>';
        function deleteProductField() {
        <%If FieldType = Admin.eComBackend.EcomFieldEdit.RequestFieldType.Products Then %>
            if (confirm(deleteMsg)) {
                document.getElementById('Form1').DeleteButton.click();
            }
		<% Else%>
            document.getElementById('Form1').DeleteButton.click();
		<% End If%>
        }


        function storeFieldDisplayGroups() {
            const fieldsIds = SelectionBox.getElementsRightAsArray("FieldDisplayGroups");
            const storageEl = document.getElementById("FieldDisplayGroupsIDs");
            storageEl.value = fieldsIds;
        }
    </script>
</head>
<body class="area-pink screen-container">
    <dwc:Card runat="server">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" onsubmit="return formIsValid();" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <asp:Literal ID="TableIsBlocked" runat="server"></asp:Literal>
            <dw:Infobar ID="SqlException" DisplayType="Error" Visible="false" runat="server"></dw:Infobar>
            <dw:Infobar ID="NoFieldsExistsForLanguageBlock" DisplayType="Warning" Message="The product field does not exist in the chosen language." Visible="false" runat="server"></dw:Infobar>
            
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <dwc:InputText ID="NameStr" Label="Navn" ValidationMessage="" runat="server" />
                <dwc:InputText ID="SystemNameStr" Label="Systemnavn" ValidationMessage="" runat="server" />
                <dwc:InputText ID="TemplateNameStr" Label="Template tag" ValidationMessage="" runat="server" />
                <div class="dw-ctrl select-picker-ctrl form-group has-error">
                    <label class="control-label"><%=Translate.Translate("Felttype") %></label>
                    <div class="form-group-input">
                        <dw:GroupDropDownList runat="server" ID="FieldTypes" ClientIDMode="Static" CssClass="selectpicker" Label=""></dw:GroupDropDownList>
                        <small class="help-block error" id="helpFieldTypes"></small>
                    </div>
                </div>
                <dwc:InputTextArea ID="DescriptionStr" Label="Description" runat="server" />                
                <dwc:InputText ID="ValidationPattern" Label="Validation pattern" runat="server" Visible="false" />                
                <dwc:InputText ID="ValidationErrorMessage" Label="Validation error message" runat="server" Visible="false" />
                <div id="DoNotRenderRow" runat="server">
                    <dwc:CheckBox runat="server" ID="DoNotRenderCheckBox" Label="Do not render" />
                </div>
                <div id="RequiredRow" runat="server">                        
                    <dwc:CheckBox runat="server" ID="ValidationRequiredCheckBox" Label="Validation required" />
                </div>
                <div style="display: none;">
                    <dwc:CheckBox runat="server" ID="Locked" Label="Lås felt" />
                </div>
                
                <table class="formsTable">
                    <tr id="RowPresentationType" class="row-presentation-type" style="display: none" runat="server">
                        <td>
                            <dw:TranslateLabel Text="Visning_som" runat="server" />
                        </td>
                        <td>
                            <dw:Richselect runat="server" ID="PresentationTypes" Height="0" Itemwidth="400" Width="400"></dw:Richselect>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" id="FieldSettings" Title="Field settings" Visible="false">  
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

            <div id="RowOptions" style="display: none" runat="server">
                <dwc:GroupBox runat="server" Title="Options" ID="OptionsGroupbox">
                    <ecom:FieldOptionsList ID="OptionsList" IsReferenceField="false" runat="server" />
                </dwc:GroupBox>
            </div>

            <asp:Button ID="SaveButton" Style="display: none" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" runat="server"></asp:Button>
        </form>
    </dwc:Card>
</body>
</html>
