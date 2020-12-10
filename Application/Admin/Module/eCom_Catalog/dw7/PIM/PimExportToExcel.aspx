<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PimExportToExcel.aspx.vb" Inherits="Dynamicweb.Admin.PimExportToExcel" %>

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
    <dwc:ScriptLib runat="server" ID="ScriptLib">
    </dwc:ScriptLib>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeScriptaculous="true" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ProductListEditingExtended.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/EditorWrapper.js" />
            <dw:GenericResource Url="/Admin/Resources/js/SettingPresets.js" />
        </Items>
    </dw:ControlResources>
    <style type="text/css">
        .form-group .control-label {
            width: 100px !important;
        }

        .tablePickerDiv .input-group-addon {
            padding: 0px;
        }

        .form-group .left-indent {
            margin-left: 0px !important;
        }
    </style>
    <script>
        function initSettingPresets(options) {
            Dynamicweb.PresetSettings.get_current().initialize(options);
        }
    </script>
</head>
<body class="area-red">
    <form id="form1" runat="server">
        <dw:Infobar runat="server" ID="WarningBar" Visible="false" TranslateMessage="False" Type="Warning" />
        <asp:HiddenField ID="viewLanguages" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="viewFields" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="ids" ClientIDMode="Static" runat="server" />
        <input type="hidden" id="Cmd" name="Cmd" />

        <div class="groupbox">
            <dwc:SelectPicker runat="server" ID="ExportFormatSelector" Label="Export format" onchange="exportFormatChanged(this);">
                <asp:ListItem Text="Excel (Dynamicweb structured)" Value="Dynamicweb"></asp:ListItem>
                <asp:ListItem Text="Excel (Unstructured)" Value="Raw"></asp:ListItem>
            </dwc:SelectPicker>
            <dwc:CheckBox runat="server" ID="SelectAllProducts" Header="All products" Label="(Will include all products in list)"  />            
            <dwc:SelectPicker runat="server" ID="SettingPresets" Label="Preset" onchange="presetChanged(this);"></dwc:SelectPicker>
            <dw:SelectionBox ID="LanguagesList" runat="server" Width="200" Label="Languages" LeftHeader="Excluded languages" RightHeader="Included languages" ShowSortRight="true" Height="250"></dw:SelectionBox>
            <dw:SelectionBox ID="FieldList" runat="server" Width="200" Label="Fields" LeftHeader="Excluded fields" RightHeader="Included fields" ShowSortRight="true" Height="250" ShowSearchBox="true"></dw:SelectionBox>
        </div>
        <dw:Dialog runat="server" ID="PresetSaveDialog" OkAction="savePreset()" ShowOkButton="true" ShowCancelButton="true" Title="Save Preset">
            <dwc:InputText runat="server" ID ="PresetName" Label="Preset name" ValidationMessage=""></dwc:InputText>
        </dw:Dialog>
    </form>

    <script type="text/javascript">
        function URL_add_parameter(url, param, value) {
            var hash = {};
            var parser = document.createElement('a');

            parser.href = url;

            var parameters = parser.search.split(/\?|&/);

            for (var i = 0; i < parameters.length; i++) {
                if (!parameters[i])
                    continue;

                var ary = parameters[i].split('=');
                hash[ary[0]] = ary[1];
            }

            hash[param] = value;

            var list = [];
            Object.keys(hash).forEach(function (key) {
                list.push(key + '=' + hash[key]);
            });

            parser.search = '?' + list.join('&');
            return parser.href;
        }


        function presetChanged(selectpicker) {
            var selectedValue = selectpicker.value;
            var frm = document.querySelector("form");
            frm.action = URL_add_parameter(location.href, 'preset', selectedValue);
            frm.submit();
        }


        function LanguagesList_onChange() {
            var defaultLanguageId = '<%=DefaultLanguageId%>';
            var selectionBoxID = "LanguagesList";
            var lstLeft = document.getElementById(selectionBoxID + "_lstLeft");
            var lstRight = document.getElementById(selectionBoxID + "_lstRight");
            var arrIndex = new Array;

            for (var i = 0; i < lstLeft.length; i++) {
                var option = lstLeft.options[i];
                if (option.value == defaultLanguageId) {
                    SelectionBox.insertOption(option, lstRight);
                    arrIndex.push(i);
                }
            }
            var length = arrIndex.length;
            for (var i = 0; i < length; i++) {
                lstLeft.remove(arrIndex.pop());
            }

            SelectionBox.setNoDataRight(selectionBoxID);
        }
        function exportToExcel() {
            $("viewFields").value = SelectionBox.getElementsRightAsArray("FieldList").join();
            $("viewLanguages").value = SelectionBox.getElementsRightAsArray("LanguagesList").join();
            $("Cmd").value = "Export";
            var theForm = document.forms["form1"];
            theForm.submit();
        }

        function openPresetSaveDialog() {
            dialog.show('PresetSaveDialog');
        }

        function savePreset() {
            $("viewFields").value = SelectionBox.getElementsRightAsArray("FieldList").join();
            $("viewLanguages").value = SelectionBox.getElementsRightAsArray("LanguagesList").join();

            Dynamicweb.PresetSettings.get_current().savePreset(document.getElementById('PresetName'));
        }

        function exportFormatChanged(selectpicker) {
            const selectCheckbox = document.getElementById("SelectAllProducts");
            if (selectpicker.value === "Dynamicweb") {
                selectCheckbox.setAttribute("disabled", "true");
            } else {
                selectCheckbox.removeAttribute("disabled");
            }
        }
    </script>
</body>
</html>
