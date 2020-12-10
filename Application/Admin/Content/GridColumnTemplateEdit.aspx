<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GridColumnTemplateEdit.aspx.vb" Inherits="Dynamicweb.Admin.GridColumnTemplateEdit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc"%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludePrototype="true" IncludeUIStylesheet="true" CombineOutput="false" />
    <script type="text/javascript">
        function changeCategoryType() {
            var categoryTypeNew = document.querySelectorAll('input[name="TemplateCategoryType"][value="new"]')[0];

            if (categoryTypeNew.checked) {
                document.getElementById("TemplateNewCategoryDiv").style.display = '';
                document.getElementById("TemplateExistingCategoriesDiv").style.display = 'none';
            }
            else {
                document.getElementById("TemplateNewCategoryDiv").style.display = 'none';
                document.getElementById("TemplateExistingCategoriesDiv").style.display = '';
            }
        }
    </script>
</head>
<body>
    <div class="card">
        <form runat="server" action="GridColumnTemplateEdit.aspx" method="post">
            <input type="hidden" name="ID" value="<%=paragraphId %>" />

            <dwc:GroupBox runat="server">
                <dwc:InputText runat="server" ID="TemplateName" Label="Navn" ValidationMessage="" MaxLength="255" />
                <dwc:InputText runat="server" ID="TemplateDescription" Label="Beskrivelse" MaxLength="255" />
                <dw:FileManager runat="server" ID="TemplateImage" Name="TemplateImage"  Label="Image" Extensions="jpg,gif,png,swf,webp" />
                <dwc:RadioGroup runat="server" ID="TemplateCategoryType" Name="TemplateCategoryType" Label="Categories" Info="" SelectedValue="new" >
                    <dwc:RadioButton runat="server" ID="TemplateCategoryTypeNew" Label="New" FieldValue="new" OnClick="changeCategoryType()" />
                    <dwc:RadioButton runat="server" ID="TemplateCategoryTypeExisting" Label="Existing" FieldValue="existing" OnClick="changeCategoryType()" />
                </dwc:RadioGroup>
                <div id="TemplateNewCategoryDiv">
                    <dwc:InputText runat="server" ID="TemplateNewCategory" Label="Category name" ValidationMessage="" MaxLength="255" />
                </div>
                <div id="TemplateExistingCategoriesDiv" style="display: none;">
                    <dwc:SelectPicker ID="TemplateCategory" runat="server" Label="Category name"></dwc:SelectPicker>
                </div>
            </dwc:GroupBox>
        </form>
    </div>
</body>
</html>
