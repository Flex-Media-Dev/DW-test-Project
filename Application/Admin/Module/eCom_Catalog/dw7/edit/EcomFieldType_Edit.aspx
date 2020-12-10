<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="EcomFieldType_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomFieldType_Edit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" TagName="FieldOptionsList" Src="~/Admin/Module/eCom_Catalog/dw7/controls/FieldOptionsList/FieldOptionsList.ascx" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <%= FieldTypeProviderSelector.Jscripts%>

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
    </style>

    <script type="text/javascript">
        onBeforeUpdateSelection = "onChangeFieldTypeProviderSelector()";

        function onChangeFieldTypeProviderSelector() {
            window.onBeforeSave = null;
        }

        function save(close) {
            var validationErrors = false;

            validationErrors |= fieldHasError('NameStr', '<%= Translate.JsTranslate("Name cannot be empty") %>');
            validationErrors |= fieldHasError('DynamicwebAliasStr', '<%= Translate.JsTranslate("SystemName cannot be empty") %>');

            if (window.onBeforeSave) {
                validationErrors |= !window.onBeforeSave(close);
            }

            if (validationErrors) {
                return false;
            };

            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('fieldForm').SaveButton.click();
        }

        function fieldHasError(elementId, errorMessage) {
            var fieldInput = document.getElementById(elementId);
            if (fieldInput.value.trim() == '') {
                dwGlobal.showControlErrors(fieldInput, errorMessage);
                return true;
            }

            return false;
        }

        function setSystemName(fromObject, toObject) {
            var nameBox;
            var sysNameBox;
            if (typeof (fromObject) == 'string' && typeof (toObject) == 'object') {
                nameBox = dwGrid_FieldsGrid.findContainingRow(toObject).findControl(fromObject);
                sysNameBox = toObject;
            } else if (typeof (fromObject) == 'object' && typeof (toObject) == 'string') {
                nameBox = fromObject;
                sysNameBox = dwGrid_FieldsGrid.findContainingRow(fromObject).findControl(toObject);
            } else if (typeof (fromObject) == 'object' && typeof (toObject) == 'object') {
                nameBox = fromObject;
                sysNameBox = toObject;
            } else { return; }

            var sysName;
            if ($F(sysNameBox).strip().empty()) {
                sysName = $F(nameBox);
            } else {
                sysName = $F(sysNameBox);
            }
            sysNameBox.value = sysName.strip().replace(/\s+/g, "_").replace(/[^a-zA-Z0-9_]+/g, "");
        }

        function initAutoFillOutSystemName() {
            var nameControl = document.getElementById('NameStr');
            var systemNameControl = document.getElementById('DynamicwebAliasStr');

            nameControl.onblur = function () { setSystemName(nameControl, systemNameControl) };
            systemNameControl.onblur = function () { setSystemName(nameControl, systemNameControl) };
        }
    </script>
</head>
<body>
    <form id="fieldForm" runat="server">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <input id="Close" type="hidden" name="Close" value="0" />
        <asp:Literal ID="TableIsBlocked" runat="server"></asp:Literal>
        <asp:Literal ID="NoFieldsExistsForLanguageBlock" runat="server"></asp:Literal>
        <dw:GroupBox runat="server" Title="Indstillinger">
            <dwc:InputText runat="server" ID="NameStr" Label="Name" ValidationMessage="" />
            <dwc:InputText runat="server" ID="DynamicwebAliasStr" Label="SystemName" ValidationMessage="" />
        </dw:GroupBox>

        <de:AddInSelector ID="FieldTypeProviderSelector" runat="server" AddInTypeName="Dynamicweb.Extensibility.Provider.FieldTypeProvider, Dynamicweb" AddInShowNothingSelected="false" />
        <%= FieldTypeProviderSelector.LoadParameters %>

        <asp:Button ID="SaveButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
        <asp:Button ID="DeleteButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
    </form>
    
    <script  type="text/javascript">
          initAutoFillOutSystemName();
    </script>
</body>
</html>
