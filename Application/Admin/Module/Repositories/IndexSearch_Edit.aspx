<%@ Page Language="vb" AutoEventWireup="false" EnableViewState="false" CodeBehind="IndexSearch_Edit.aspx.vb" Inherits="Dynamicweb.Admin.IndexSearch_Edit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head>
    <title>Search for editors</title>

    <%--<dwc:ScriptLib runat="server"></dwc:ScriptLib>--%>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
            <dw:GenericResource Url="/Admin/Module/OMC/js/NumberSelector.js" />
            <dw:GenericResource Url="/Admin/Module/OMC/css/NumberSelector.css" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/functions.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/AjaxAddInParameters.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ecomParagraph.js" />
            <dw:GenericResource Url="/Admin/Module/Repositories/Scripts/IndexSearch.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="Styles/IndexSearch.css" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var isAngel = '<%= Dynamicweb.Security.UserManagement.User.GetCurrentBackendUser().IsAngel.ToString().ToLower() %>';
        if (isAngel == 'true') {
            Dynamicweb.Index.IndexSearch.enableDebug();
        }
        function Redirect() {
            document.location = '/Admin/Module/Repositories/IndexSearch_List.aspx';
        }

        function storeSorting(sortByParams) {
            var toJson = function (obj) {
                var altJson = Object.toJSON(obj);
                return altJson;
            };

            var orderParameters = null;
            orderParameters = [];
            sortByParams.each(function (item) {
                if (item.get_state() != "Deleted") {
                    orderParameters.push(item.get_properties());
                }
            });
            $$("input[name=QuerySortByParams]")[0].value = toJson(orderParameters);
        }

        function beforeIndexSearchSave() {
            var sortByList = Dynamicweb.Ajax.ControlManager.get_current().findControl("QuerySortByParams");
            sortByParams = sortByList.get_dataSource();

            sortByParams.sort(function (a, b) {
                if (a.get_id() > b.get_id()) {
                    return 1;
                }
                if (a.get_id() < b.get_id()) {
                    return -1;
                }
                return 0;
            });
            storeSorting(sortByParams);
        }

        function Persist(persistAction) {
            var performAction = (persistAction != "delete" || confirm('Delete this configuration?'))
            if (performAction) {
                $('cmd').value = persistAction;
                beforeIndexSearchSave();
                document.getElementById('MainForm').submit();
            }
        }

        function help() {
            return <%= Gui.Help("searchforeditors", "modules.sfe.general")%>;
        }
    </script>
</head>
<body class="screen-container area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <asp:Literal ID="callbackScript" runat="server"></asp:Literal>
            <dwc:CardHeader runat="server" ID="lbHeader" Title="Search for editors"></dwc:CardHeader>

            <dw:Toolbar ID="IndexSearchToolbar" runat="server" ShowStart="true" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="tbSave" runat="server" OnClientClick="Persist('save');" Icon="Save" Text="Save" ShowWait="true"></dw:ToolbarButton>
                <dw:ToolbarButton ID="tbSaveAndClose" runat="server" OnClientClick="Persist('saveAndClose');" Icon="Save" Text="Save and close" IconColor="None" ShowWait="true"></dw:ToolbarButton>
                <dw:ToolbarButton ID="tbDelete" runat="server" OnClientClick="Persist('delete');" Icon="Save" Text="Delete" ShowWait="true"></dw:ToolbarButton>
                <dw:ToolbarButton ID="tbCancel" runat="server" OnClientClick="Redirect();" Icon="TimesCircle" Text="Cancel" ShowWait="true" Divide="After"></dw:ToolbarButton>
                <dw:ToolbarButton ID="tbRebuildIndex" runat="server" OnClientClick="Persist('rebuild');" Icon="Sync" Text="Rebuild indexes" ShowWait="true"></dw:ToolbarButton>
                <dw:ToolbarButton ID="tbCreateIndex" runat="server" OnClientClick="dialog.show('CreateIndex', null, null); return false;" Icon="PlusSquare" Text="Create index" ShowWait="true"></dw:ToolbarButton>
                <dw:ToolbarButton ID="tbExport" runat="server" OnClientClick="dialog.show('Export', null, null); return false;" Icon="SignOut" Text="Export" ShowWait="true"></dw:ToolbarButton>
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dw:Infobar Title="Exception" TranslateMessage="false" DisplayType="Error" runat="server" ID="ExceptionMessage" Visible="false"></dw:Infobar>
                <dw:Infobar Title="Conflicting names" TranslateMessage="true" DisplayType="Error" runat="server" ID="ConflictingNamesException" Visible="false" Message="Conflicting url names">
                    <br />
                    <asp:Literal runat="server" ID="ConflictingNamesInfo"></asp:Literal>
                </dw:Infobar>
                <dw:Infobar Title="Sorting ineffective" TranslateMessage="true" DisplayType="Error" runat="server" ID="SortingWarning" Visible="false" Message="Sorting only works for faceted or query searched fields">
                    <br />
                    <asp:Literal runat="server" ID="SortFieldWarning"></asp:Literal>
                </dw:Infobar>
                <dw:Infobar Title="TermCount" TranslateMessage="true" DisplayType="Warning" runat="server" ID="TermWarningMessage" Visible="false">
                    <br />
                    <asp:Literal runat="server" ID="TermWarningMessageInfo"></asp:Literal>
                </dw:Infobar>
                <dw:Infobar Title="Boost ineffective" TranslateMessage="true" Message="Boost has no effect when not sorting by 'Score'." DisplayType="Warning" runat="server" ID="BoostWarning" Visible="false"></dw:Infobar>
                <dw:Infobar Title="Index rebuild required" TranslateMessage="true" Message="Index rebuild needed to reflect the changes made." DisplayType="Warning" runat="server" ID="IndexRebuildWarning" Visible="false"></dw:Infobar>
                <dw:Infobar Title="Index rebuilding" TranslateMessage="true" Message="Indexes currently rebuilding" DisplayType="Information" runat="server" ID="IndexRebuildInfo" Visible="false">
                    <br />
                    <asp:Literal runat="server" ID="IndexesRebuilding"></asp:Literal>
                </dw:Infobar>
                <form method="post" name="MainForm" id="MainForm">
                    <input type="hidden" name="cmd" id="cmd">
                    <input type="hidden" name="oldName" id="IndexSearchOldName" runat="server">
                    <dw:GroupBox runat="server" Title="Indstillinger" DoTranslation="true">
                        <div class="dw-ctrl textbox-ctrl form-group">
                            <label class="control-label">Name</label>
                            <div class="form-group-input">
                                <input runat="server" class="form-control" type="text" id="IndexSearchName" name="IndexSearchName" autocomplete="off" maxlength="255" minlength="1">
                                <small class="help-block error" id="helpNameStr"></small>
                            </div>
                        </div>
                        <dwc:SelectPicker runat="server" ID="SchemaExtender" Name="SchemaExtender" Label="Schema extender"></dwc:SelectPicker>
                    </dw:GroupBox>
                    <dw:GroupBox runat="server" Title="Context" DoTranslation="true">
                        <div class="dw-ctrl checkboxgroup-ctrl form-group ">
                            <label class="control-label"><%= Translate.Translate("Language") %></label>
                            <div class="form-group-input">
                                <div class="radio">
                                    <input runat="server" id="IndexSearchLanguageAll" type="radio" value="All" name="IndexSearchLanguageOption" onclick="Dynamicweb.Index.IndexSearch.disableElementsByName('IndexSearchLanguage');" />
                                    <label for="IndexSearchLanguageAll"><%= Translate.Translate("All languages") %></label>
                                </div>
                                <div class="radio">
                                    <input runat="server" id="IndexSearchLanguageContext" value="Context" type="radio" name="IndexSearchLanguageOption" onclick="Dynamicweb.Index.IndexSearch.disableElementsByName('IndexSearchLanguage');" />
                                    <label for="IndexSearchLanguageContext"><%= Translate.Translate("Current language") %></label>
                                </div>
                                <div class="radio">
                                    <input runat="server" id="IndexSearchLanguageSelect" value="Selected" type="radio" name="IndexSearchLanguageOption" onclick="Dynamicweb.Index.IndexSearch.enableElementsByName('IndexSearchLanguage');" />
                                    <label for="IndexSearchLanguageSelect"><%= Translate.Translate("Selected languages") %></label>
                                </div>
                                <dwc:CheckBoxGroup runat="server" ID="IndexSearchLanguage" Name="IndexSearchLanguage"></dwc:CheckBoxGroup>
                            </div>
                        </div>
                        <div class="dw-ctrl checkboxgroup-ctrl form-group ">
                            <label class="control-label"><%= Translate.Translate("Shop") %></label>
                            <div class="form-group-input">
                                <div class="radio">
                                    <input runat="server" id="IndexSearchShopAll" type="radio" value="All" name="IndexSearchShopOption" onclick="Dynamicweb.Index.IndexSearch.disableElementsByName('IndexSearchShop');" />
                                    <label for="IndexSearchShopAll"><%= Translate.Translate("All shops") %></label>
                                </div>
                                <div class="radio">
                                    <input runat="server" id="IndexSearchShopContext" value="Context" type="radio" name="IndexSearchShopOption" onclick="Dynamicweb.Index.IndexSearch.disableElementsByName('IndexSearchShop');" />
                                    <label for="IndexSearchShopContext"><%= Translate.Translate("Current shop") %></label>
                                </div>
                                <div class="radio">
                                    <input runat="server" id="IndexSearchShopSelect" value="Selected" type="radio" name="IndexSearchShopOption" onclick="Dynamicweb.Index.IndexSearch.enableElementsByName('IndexSearchShop');" />
                                    <label for="IndexSearchShopSelect"><%= Translate.Translate("Selected shops") %></label>
                                </div>
                                <dwc:CheckBoxGroup runat="server" ID="IndexSearchShop" Name="IndexSearchShop"></dwc:CheckBoxGroup>
                            </div>
                        </div>
                        <dwc:CheckBoxGroup runat="server" ID="IncludeProducts" Label="Exclude products" Name="IncludeProducts">
                            <dwc:CheckBox runat="server" ID="IsActive" Label="Inactive" Value="IsActive" />
                            <dwc:CheckBox runat="server" ID="HasPrice" Label="No price" Value="HasPrice" />
                            <dwc:CheckBox runat="server" ID="HasStock" Label="No stock" Value="HasStock" />
                        </dwc:CheckBoxGroup>

                        <dwc:RadioGroup runat="server" ID="VariantGroup" Label="Variants" Name="VariantsSelection">
                            <dwc:RadioButton runat="server" ID="MasterOnly" FieldValue="MasterOnly" Label="Only master" />
                            <dwc:RadioButton runat="server" ID="AllVariants" FieldValue="AllVariants" Label="All variants" />
                            <dwc:RadioButton runat="server" ID="PrimaryVariant" FieldValue="PrimaryVariant" Label="Primary variant" />
                        </dwc:RadioGroup>
                    </dw:GroupBox>
                    <dw:GroupBox runat="server" Title="Fields" DoTranslation="true">
                        <asp:Literal runat="server" ID="fieldMarkup"></asp:Literal>
                    </dw:GroupBox>
                    <dw:GroupBox runat="server" Title="Sort" DoTranslation="true">
                        <input type="hidden" id="QueryConditions" name="QueryConditions" />
                        <dw:EditableList ID="QuerySortByParams" runat="server" AllowPaging="true" AllowSorting="false" AutoGenerateColumns="false" EnableLegacyRendering="True"></dw:EditableList>
                    </dw:GroupBox>
                    <dw:Dialog ID="CreateIndex" runat="server" Title="Create index" TranslateTitle="true" OkText="Create" Size="Medium" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" OkAction="Persist('createIndex');">
                        <dw:GroupBox runat="server" Title="Create index" DoTranslation="true">
                            <dwc:SelectPicker runat="server" ID="CreateIndexRepository" Name="CreateIndexRepository" Label="Repository"></dwc:SelectPicker>
                            <dwc:InputText runat="server" ID="CreateIndexName" Name="CreateIndexName" Label="Index name" Value="SearchForEditors"></dwc:InputText>
                        </dw:GroupBox>
                    </dw:Dialog>
                    <dw:Dialog ID="Export" runat="server" Title="Export index" TranslateTitle="true" OkText="Create" Size="Medium" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" OkAction="Persist('export');">
                        <dw:GroupBox runat="server" Title="Export index" DoTranslation="true">                            
                            <dwc:SelectPicker runat="server" ID="CreateIndexExport" Name="CreateIndexExport" Label="Index"></dwc:SelectPicker>
                            <dwc:InputText runat="server" ID="CreateQueryName" Name="CreateQueryName" Label="Query name" Value="SearchForEditors"></dwc:InputText>
                            <dwc:InputText runat="server" ID="CreateFacetName" Name="CreateFacetName" Label="Facet name" Value="SearchForEditors"></dwc:InputText>
                        </dw:GroupBox>
                    </dw:Dialog>
                </form>
            </dwc:CardBody>
        </dwc:Card>
    </div>

</body>
<% Translate.GetEditOnlineScript()%>
</html>
