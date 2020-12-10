<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TranslationKey_List.aspx.vb" Inherits="Dynamicweb.Admin.TranslationKey_List" %>

<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>
        <dw:TranslateLabel ID="lbTitle" Text="Translation keys" runat="server" UseLabel="false" />
    </title>

    <dw:ControlResources IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/List/List.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/WaterMark.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" />
            <dw:GenericResource Url="/Admin/Content/Management/Dictionary/Dictionary.js" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8stylefix.css" />
        </Items>
    </dw:ControlResources>
    <% If IsItemType Then %>
    <script src="/Admin/Content/Items/js/ItemFieldTranslationsEdit.js" type="text/javascript"></script>
    <% End If %>

    <script type="text/javascript">
        document.observe('dom:loaded', function () {
            Dictionary.TranslationKey_List.initialize();
            var tbl = $$("#OuterContainer .list table");

            var arr1 = $$("#ListTable thead .header .columnCell");
            var totalWidth = 0;
            arr1.each(function (el) {
                totalWidth += el.getWidth();
            });
            var arr2 = $$("#ListTable .header .columnCell");
            for (var i = 0; i < arr1.length; i++) {
                var pw = (100 * arr1[i].getWidth()) / totalWidth;
                arr2[i].style.width = arr1[i].style.width = pw + "%";
            }

            var itemList = document.getElementById("dItemList");
            if (itemList) {
                itemList.onchange = Dynamicweb.Items.ItemFieldTranslationsEdit.prototype.itemTypeChange;
                var addItemTranslationsButton = document.getElementById("bAddMissingTranslations");
                if (addItemTranslationsButton) {
                    addItemTranslationsButton.onclick = Dynamicweb.Items.ItemFieldTranslationsEdit.prototype.addMissedTranslations;
                }
            }
        });

        function reloadPage() {
            document.location = document.location;
        }
    </script>
    <style>
        #toolbarFilters .input-group-addon {
            float: none;
        }

            #toolbarFilters .input-group-addon .fa {
                margin-top: 0px;
            }
    </style>
</head>
<body class="screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Translations" />

                <input type="hidden" id="hDesignName" runat="server" value="" />
                <input type="hidden" id="hIsGlobal" runat="server" value="" />
                <input type="hidden" id="hIsItemType" runat="server" value="" />

                <div id="dic_header" class="dic_header" runat="server">
                    <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                        <dw:ToolbarButton ID="cmdAdd" runat="server" Divide="None" Icon="PlusSquare" OnClientClick="Dictionary.TranslationKey_List.add()" Text="Add translation key" />
                        <dw:ToolbarButton ID="cmdRefresh" runat="server" Divide="None" Icon="Refresh" Text="Refresh" OnClientClick="reloadPage();" />
                        <dw:ToolbarButton ID="cmdGoBack" Visible="false" Icon="Undo" runat="server" Divide="None" Text="Go back" OnClientClick="" />
                    </dw:Toolbar>
                </div>

                <dwc:CardBody runat="server" ID="CardBody">
                    <div runat="server" id="ItemTypeHeader" visible="false">
                        <div id="SelectItemType" style="display: none;">
                            <dw:Infobar ID="wrnSelectItemType" Type="Error" runat="server" Message="Select item type first" />
                        </div>

                        <dwc:GroupBox ID="gItemTypeOptions" Title="Item type options" runat="server">
                            <dwc:SelectPicker ID="dItemList" runat="server" Label="Item type" />
                            <div class="form-group">
                                <label class="control-label">&nbsp;</label>
                                <div class="input-group">
                                    <dwc:Button ID="bAddMissingTranslations" runat="server" Title="Add missing translations for this item type" Name="bAddMissingTranslations" Value="bAddMissingTranslations" />
                                </div>
                            </div>
                        </dwc:GroupBox>
                    </div>

                    <dwc:GroupBox runat="server" Title="Translation keys" ID="ListContainer" Visible="false"></dwc:GroupBox> <%--GroupBox for list--%>
                    <dw:List ID="lstKeys" AllowMultiSelect="false" ShowPaging="true" runat="server" ShowTitle="false" PageSize="1000">
                        <Filters>
                            <dw:ListTextFilter ID="textFilter" runat="server" Label="Search in list" WaterMarkText="Search" />
                        </Filters>
                    </dw:List>
                </dwc:CardBody>
            </dwc:Card>

            <dw:Dialog runat="server" ID="translationKeyEdit" Size="Medium" HidePadding="true" Title="Translation key edit" ShowOkButton="false" ShowClose="false">
                <iframe id="translationKeyEditFrame" runat="server"></iframe>
            </dw:Dialog>
        </form>
    </div>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
