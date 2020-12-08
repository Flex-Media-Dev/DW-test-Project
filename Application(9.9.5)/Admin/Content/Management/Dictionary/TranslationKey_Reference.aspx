<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TranslationKey_Reference.aspx.vb" Inherits="Dynamicweb.Admin.TranslationKey_Reference" %>

<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>
        <dw:TranslateLabel ID="lbTitle" Text="Translation keys" runat="server" UseLabel="false" />
    </title>

    <!-- Default control resources -->
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script type="text/javascript" src="/Admin/Content/JsLib/scriptaculous-js-1.9/src/scriptaculous.js?load=effects,dragdrop,slider,controls"></script>
        <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js"></script>
        <script type="text/javascript" src="/Admin/Content/JsLib/dw/Ajax.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/List/List.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/WaterMark.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Dialog/Dialog.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/EditableGrid/EditableGrid.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
        <script type="text/javascript" src="/Admin/Content/JsLib/require.js"></script>
        <script type="text/javascript" src="/Admin/Content/Management/Dictionary/Dictionary.js"></script>
    </dwc:ScriptLib>

    <style type="text/css">
        #RegionsGrid .header {
            background-color: #f5f5f5;
        }

        #RegionsGrid tr.highlightRow:hover {
            background-color: #f5f5f5;
        }

        #RegionsGrid textarea {
            background-color: #fff;
        }

        .colKeyNamec{
            overflow: hidden; 
            text-overflow: ellipsis;
        }
    </style>

    <script type="text/javascript">
        function onEnterDown(e) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13) { //Enter keycode
                e.preventDefault();
                doSearch();
                return false;
            }
        }

        function doSearch() {
            /// <summary>
            /// Does the search.
            /// </summary>
            var searchText = $('SearchText').value;
            var targetTable = $('RegionsGrid');
            var targetTableColCount = 2; //targetTable.rows.item(0).cells.length;

            //Loop through table rows
            for (var rowIndex = 2; rowIndex < targetTable.rows.length - 1; rowIndex++) {
                var rowData = '';

                //Process data rows. (rowIndex >= 1)
                for (var colIndex = 0; colIndex < targetTableColCount; colIndex++) {
                    var cellText = '';
                    var cell = $(targetTable.rows.item(rowIndex).cells.item(colIndex));

                    if (cell) {
                        if (colIndex == 0) cellText = cell.innerText;
                        else if (colIndex == 1) {
                            var textArea = cell.down("TextArea");
                            if (textArea) cellText = textArea.value;
                        }
                    }

                    rowData += cellText;
                }

                // Make search case insensitive.
                rowData = rowData.toLowerCase();
                searchText = searchText.toLowerCase();

                //If search term is not found in row data then hide the row, else show
                if (rowData.indexOf(searchText) == -1)
                    targetTable.rows.item(rowIndex).hide();
                else
                    targetTable.rows.item(rowIndex).show();
            }
        }

        function reloadPage(clearSearch) {
            location.reload(true);
        }
    </script>
</head>

<body class="area-blue">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" ID="cardHeader" Title="Translations" DoTranslate="false"></dwc:CardHeader>
                <input type="hidden" id="hDesignName" runat="server" value="" />
                <input type="hidden" id="hAreaID" runat="server" value="" />

                <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="cmdAdd" runat="server" Icon="PlusSquare" Divide="None" Text="Add translation key" OnClientClick="Dictionary.TranslationKey_Reference.add();" />
                    <dw:ToolbarButton ID="cmdRefresh" runat="server" Divide="None" Icon="Refresh" Text="Refresh" OnClientClick="location.reload();" />
                </dw:Toolbar>

                <dwc:CardBody runat="server">
                    <dwc:GroupBox runat="server" Title="Translation keys">
                        <label>
                            <dw:Label runat="server" ID="lblSubtitle" doTranslation="false" />
                        </label>
                        <div class="form-group" id="ToolbarFilters">
                            <div class="input-group">
                                <div class="form-group-input">
                                    <input type="text" class="textInput form-control" onkeydown="return onEnterDown(event);" id="SearchText" name="SearchText" placeholder="Search" />
                                </div>
                                <span class="input-group-addon last"><i class="fa fa-search" onclick="doSearch();"></i></span>
                            </div>
                        </div>

                        <dw:Infobar runat="server" ID="dictionaryNotExists" Type="Information" Message="Create shared or design dictionary in management center first" Title="Dictionary doesn't exist" Visible="false">
                        </dw:Infobar>

                        <dw:EditableGrid ID="RegionsGrid" AllowMultiSelect="true" AllowAddingRows="false" AllowDeletingRows="false" ShowPaging="true" ShowTitle="true" runat="server" PageSize="10">
                            <Columns>
                                <asp:TemplateField ItemStyle-Width="300">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="colKeyName" CssClass="control-label colKeyNamec" Style="" />                                        
                                        <small runat="server" ID="colKeyDefaultValue" Style="padding: 5px 0 0 5px; display: block;"></small>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:TextBox TextMode="MultiLine" Rows="2" runat="server" ID="colTranslation" Text="" CssClass="NewUIinput form-control" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="colScopeName" CssClass="control-label" />
                                        <asp:HiddenField runat="server" ID="colScope" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </dw:EditableGrid>

                        <asp:Button ID="SaveButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>

            <dwc:ActionBar ID="ActionBar1" runat="server">
                <dw:ToolbarButton ID="cmdSave" runat="server" Image="NoImage" Divide="None" Text="Save" OnClientClick="Dictionary.TranslationKey_Reference.saveTranslations();" />
                <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Image="NoImage" Divide="None" Text="Save and close" OnClientClick="Dictionary.TranslationKey_Reference.saveTranslations(true);" />
            </dwc:ActionBar>
            <dw:Overlay runat="server" ID="overlay"></dw:Overlay>
        </form>
    </div>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
