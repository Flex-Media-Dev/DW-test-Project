<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CookieCategoryList.aspx.vb" Inherits="Dynamicweb.Admin.CookieCategoryList" %>
<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources CombineOutput="false" IncludePrototype="false" runat="server">
    </dw:ControlResources>
    <script>
        function addCategoryOkAction() {
            var systemName = document.getElementById('CategorySystemName').value;
            saveCategory(systemName);
        }

        function saveCategory(systemName) {
            location.href = '/Admin/Content/Management/Pages/CookieCategoryList.aspx?SystemName=' + systemName + '&Command=Save';
        }

        function deleteCategory(systemName) {
            location.href = '/Admin/Content/Management/Pages/CookieCategoryList.aspx?SystemName=' + systemName + '&Command=Delete';
        }

        function contextDeleteCategory()
        {
            var systemName = ContextMenu.callingItemID;
            deleteCategory(systemName);
        }

        function showAddCategoryDialog() {
            var categorySystemNameInput = document.getElementById('CategorySystemName');
            categorySystemNameInput.value = '';
            categorySystemNameInput.onkeyup = function (event) {
                categorySystemNameInput.value = makeSystemName(categorySystemNameInput.value);
                if (event.key === 'Enter') {
                    saveCategory(categorySystemNameInput.value);
                }
            };

            dialog.show('AddCategoryDialog');
            categorySystemNameInput.focus();
        }

        function makeSystemName(name) {
            var ret = name;

            if (ret && ret.length) {
                ret = ret.replace(/[^0-9a-zA-Z_\s]/gi, '_'); // Replacing non alphanumeric characters with underscores
                while (ret.indexOf('_') == 0) ret = ret.substr(1); // Removing leading underscores

                ret = ret.replace(/\s+/g, ' '); // Replacing multiple spaces with single ones
                ret = ret.replace(/\s([a-z])/g, function (str, g1) { return g1.toUpperCase(); }); // Camel Casing
                ret = ret.replace(/\s/g, '_'); // Removing spaces

                if (ret.length > 1) ret = ret.substr(0, 1).toUpperCase() + ret.substr(1); else ret = ret.toUpperCase();
            }

            return ret;
        }
    </script>
</head>
<body class="screen-container">
    <form id="MainForm" runat="server" onsubmit="return false;">
        <dwc:Card runat="server">
            <dwc:CardHeader Title="Cookie categories" runat="server"></dwc:CardHeader>
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdAdd" runat="server" Icon="PlusSquare" OnClientClick="showAddCategoryDialog();" Text="Add category" />
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dw:List ID="CookieCategoriesList" ShowCount="false" ShowHeader="true" ShowFooter="false" ShowPaging="false" ShowTitle="false" ShowCollapseButton="false" runat="server">
                    <Columns>
                        <dw:ListColumn Name="Name" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:CardBody>
        </dwc:Card>
        <dw:ContextMenu ID="CookieCategoryContextMenu" runat="server">
            <dw:ContextMenuButton ID="cmdDelete" Icon="Delete" Text="Delete" OnClientClick="contextDeleteCategory();" runat="server" />
        </dw:ContextMenu>
        <dw:Dialog ID="AddCategoryDialog" Title="Add category" TranslateTitle="true" ShowCancelButton="true" ShowOkButton="true" OkAction="addCategoryOkAction()" runat="server">
            <dw:GroupBox runat="server">
                <dwc:InputText ID="CategorySystemName" Name="CategorySystemName" Label="Name" runat="server"></dwc:InputText>
            </dw:GroupBox>
        </dw:Dialog>
    </form>
</body>
</html>