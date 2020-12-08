<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="eCom_Catalog_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eCom_Catalog_Edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Ecommerce.Extensibility.Controls" Assembly="Dynamicweb.Ecommerce" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
    <Items>
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
        <dw:GenericResource Url="/Admin/Module/OMC/js/NumberSelector.js" />
        <dw:GenericResource Url="/Admin/Module/OMC/css/NumberSelector.css" />
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/functions.js" />
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/AjaxAddInParameters.js" />
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ecomParagraph.js" />
    </Items>
</dw:ControlResources>

<script type="text/javascript">
    const deprecateOldImages = <%=IsOldImagesDeprecated.ToString().ToLower()%>;
    var basePath = '/dw7';
    var groupTreeBasePath = '/dw7/Edit';

    function ReturnSettings() {
        var obj = document.forms.paragraph_edit.Show;
        for (var i = 0; i < obj.length; i++) {
            if (obj[i].checked) {
                GetSettings(obj[i]);
            }
        }
    }

    function GetSettings(obj) {
        switch (obj.value)  {
            case "List":
                document.getElementById('ProductListBox').style.display = 'block';
                document.getElementById('ProductBox').style.display = 'none';
                document.getElementById('ProductIndexBox').style.display = 'none';
                document.getElementById('SearchForEditors').style.display = 'none';
                document.getElementById('NolistTemplateTR').style.display = 'none';


                document.getElementById('GroupSelector').style.display = 'table-row';

                document.getElementById('TemplateListTR').style.display = 'table-row';
                document.getElementById('TemplateListTR2').style.display = 'table-row';
                document.getElementById('TemplateSearchTR').style.display = 'table-row';
                document.getElementById('TemplateGrpTR').style.display = 'table-row';
                document.getElementById('TemplateCompareTR').style.display = 'table-row';
                document.getElementById('TemplateNoProdTR').style.display = 'table-row';
                document.getElementById('ProdSorting').style.display = 'block';
                document.getElementById('ProdSortingPageSizeTR').style.display = 'table-row';
                document.getElementById('ProdSortingRemoveDuplicatesTR').style.display = 'table-row';

                document.getElementById('PrintPublisher').style.display = 'block';
                document.getElementById('ProductSearch').style.display = 'block';

                document.getElementById('AdditionalSettingsIgnoreUrlTR').style.display = 'table-row';
                document.getElementById('AdditionalSettingsMetaFirstPageAsCanonicalTR').style.display = 'table-row';
                document.getElementById('OptimizedEnableTR').style.display = 'table-row';
                document.getElementById('OptimizedCacheEnableTR').style.display = 'table-row';
                document.getElementById('OptimizedCacheDisplayDurationTR').style.display = 'table-row';

                break;
            case "Context":
                document.getElementById('ProductListBox').style.display = 'none';
                document.getElementById('ProductBox').style.display = 'none';
                document.getElementById('ProductIndexBox').style.display = 'none';
                document.getElementById('SearchForEditors').style.display = 'none';
                document.getElementById('NolistTemplateTR').style.display = 'none';
                document.getElementById('GroupSelector').style.display = 'none';

                document.getElementById('TemplateListTR').style.display = 'table-row';
                document.getElementById('TemplateListTR2').style.display = 'table-row';
                document.getElementById('TemplateSearchTR').style.display = 'none';
                document.getElementById('TemplateGrpTR').style.display = 'none';
                document.getElementById('TemplateCompareTR').style.display = 'none';
                document.getElementById('TemplateNoProdTR').style.display = 'none';
                document.getElementById('ProdSorting').style.display = 'block';
                document.getElementById('ProdSortingPageSizeTR').style.display = 'none';
                document.getElementById('ProdSortingRemoveDuplicatesTR').style.display = 'none';

                document.getElementById('PrintPublisher').style.display = 'none';
                document.getElementById('ProductSearch').style.display = 'none';

                document.getElementById('AdditionalSettingsIgnoreUrlTR').style.display = 'none';
                document.getElementById('AdditionalSettingsMetaFirstPageAsCanonicalTR').style.display = 'none';
                document.getElementById('OptimizedEnableTR').style.display = 'none';
                document.getElementById('OptimizedCacheEnableTR').style.display = 'none';
                document.getElementById('OptimizedCacheDisplayDurationTR').style.display = 'none';

                break;
            case "Product":
                document.getElementById('ProductListBox').style.display = "none";
                document.getElementById('ProductIndexBox').style.display = 'none';
                document.getElementById('SearchForEditors').style.display = 'none';
                document.getElementById('ProductBox').style.display = 'block';
                document.getElementById('NolistTemplateTR').style.display = 'none';
                document.getElementById('GroupSelector').style.display = "none";

                document.getElementById('TemplateListTR').style.display = "none";
                document.getElementById('TemplateListTR2').style.display = 'none';
                document.getElementById('TemplateSearchTR').style.display = "none";
                document.getElementById('TemplateGrpTR').style.display = "none";
                document.getElementById('TemplateCompareTR').style.display = 'table-row';
                document.getElementById('TemplateNoProdTR').style.display = "table-row";
                document.getElementById('ProdSorting').style.display = 'none';

                document.getElementById('PrintPublisher').style.display = 'block';
                document.getElementById('ProductSearch').style.display = 'block';

                document.getElementById('AdditionalSettingsIgnoreUrlTR').style.display = 'table-row';
                document.getElementById('AdditionalSettingsMetaFirstPageAsCanonicalTR').style.display = 'table-row';
                document.getElementById('OptimizedEnableTR').style.display = 'table-row';
                document.getElementById('OptimizedCacheEnableTR').style.display = 'table-row';
                document.getElementById('OptimizedCacheDisplayDurationTR').style.display = 'table-row';

                break;
            case "Index":
                document.getElementById('ProductListBox').style.display = 'none';
                document.getElementById('ProductBox').style.display = 'none';
                document.getElementById('ProductIndexBox').style.display = 'block';
                document.getElementById('SearchForEditors').style.display = 'none';
                document.getElementById('NolistTemplateTR').style.display = 'none';
                document.getElementById('GroupSelector').style.display = 'none';

                document.getElementById('TemplateListTR').style.display = 'table-row';
                document.getElementById('TemplateListTR2').style.display = 'table-row';
                document.getElementById('TemplateSearchTR').style.display = 'table-row';
                document.getElementById('TemplateGrpTR').style.display = 'none';
                document.getElementById('TemplateCompareTR').style.display = 'table-row';
                document.getElementById('TemplateNoProdTR').style.display = 'table-row';
                document.getElementById('ProdSorting').style.display = 'block';
                document.getElementById('ProdSortingPageSizeTR').style.display = 'table-row';
                document.getElementById('ProdSortingRemoveDuplicatesTR').style.display = 'table-row';

                document.getElementById('PrintPublisher').style.display = 'block';
                document.getElementById('ProductSearch').style.display = 'none';

                document.getElementById('AdditionalSettingsIgnoreUrlTR').style.display = 'table-row';
                document.getElementById('AdditionalSettingsMetaFirstPageAsCanonicalTR').style.display = 'table-row';
                document.getElementById('OptimizedEnableTR').style.display = 'none';
                document.getElementById('OptimizedCacheEnableTR').style.display = 'none';
                document.getElementById('OptimizedCacheDisplayDurationTR').style.display = 'none';

                break;
            case "SearchForEditors":
                document.getElementById('ProductListBox').style.display = 'none';
                document.getElementById('ProductBox').style.display = 'none';
                document.getElementById('ProductIndexBox').style.display = 'none';
                document.getElementById('SearchForEditors').style.display = 'block';
                document.getElementById('NolistTemplateTR').style.display = 'none';
                document.getElementById('GroupSelector').style.display = 'none';

                document.getElementById('TemplateListTR').style.display = 'table-row';
                document.getElementById('TemplateListTR2').style.display = 'table-row';
                document.getElementById('TemplateSearchTR').style.display = 'table-row';
                document.getElementById('TemplateGrpTR').style.display = 'none';
                document.getElementById('TemplateCompareTR').style.display = 'table-row';
                document.getElementById('TemplateNoProdTR').style.display = 'table-row';
                document.getElementById('ProdSorting').style.display = 'block';
                document.getElementById('ProdSortingPageSizeTR').style.display = 'table-row';
                document.getElementById('ProdSortingRemoveDuplicatesTR').style.display = 'table-row';

                document.getElementById('PrintPublisher').style.display = 'block';
                document.getElementById('ProductSearch').style.display = 'none';

                document.getElementById('AdditionalSettingsIgnoreUrlTR').style.display = 'table-row';
                document.getElementById('AdditionalSettingsMetaFirstPageAsCanonicalTR').style.display = 'table-row';
                document.getElementById('OptimizedEnableTR').style.display = 'none';
                document.getElementById('OptimizedCacheEnableTR').style.display = 'none';
                document.getElementById('OptimizedCacheDisplayDurationTR').style.display = 'none';

                break;
            case "DoNotListProducts":
                document.getElementById('ProductListBox').style.display = "none";
                document.getElementById('ProductIndexBox').style.display = 'none';
                document.getElementById('SearchForEditors').style.display = 'none';
                document.getElementById('ProductBox').style.display = 'none';
                document.getElementById('NolistTemplateTR').style.display = 'table-row';
                document.getElementById('GroupSelector').style.display = "none";

                document.getElementById('TemplateListTR').style.display = "none";
                document.getElementById('TemplateListTR2').style.display = 'none';
                document.getElementById('TemplateSearchTR').style.display = "none";
                document.getElementById('TemplateGrpTR').style.display = "none";
                document.getElementById('TemplateCompareTR').style.display = 'none';
                document.getElementById('TemplateNoProdTR').style.display = "none";
                document.getElementById('ProdSorting').style.display = 'none';

                document.getElementById('PrintPublisher').style.display = 'none';
                document.getElementById('ProductSearch').style.display = 'none';

                document.getElementById('AdditionalSettingsIgnoreUrlTR').style.display = 'none';
                document.getElementById('AdditionalSettingsMetaFirstPageAsCanonicalTR').style.display = 'none';
                document.getElementById('OptimizedEnableTR').style.display = 'none';
                document.getElementById('OptimizedCacheEnableTR').style.display = 'none';
                document.getElementById('OptimizedCacheDisplayDurationTR').style.display = 'none';

                break;
            default:
            //Nothing	
        }
        ChangeTemplateGroups();
    }


    function Toggle_UseAltImage(obj) {
        if (obj.checked) {
            document.getElementById('UseAltImageSection').style.display = 'table';
        } else {
            document.getElementById('UseAltImageSection').style.display = 'none';
        }
    }

    function Toggle_UseCatalog(obj) {
        if (obj.checked) {
            document.getElementById('PrintPublisherTable').style.display = 'table';
        } else {
            document.getElementById('PrintPublisherTable').style.display = 'none';
        }
    }


    function ChangeTemplateSearch() {
        var obj = document.getElementById('TemplateSearchBox');

        if (obj.checked) {
            document.getElementById('TemplateSearchDiv').style.display = "";
        } else {
            document.getElementById('TemplateSearchDiv').style.display = "none";
        }
    }

    function ChangeTemplateGroups() {
        var obj = document.getElementById('ShowGroups');
        var isParentVisible = document.getElementById('TemplateGrpTR').style.display != "none";

        if (isParentVisible && obj.checked) {
            document.getElementById('TemplateGroupDiv').style.display = "";
        } else {
            document.getElementById('TemplateGroupDiv').style.display = "none";
        }
    }


    function AddProduct(fieldName) {
        if (fieldName != "") {
            var caller = 'opener.document.forms.paragraph_edit.' + fieldName;
            window.open("/Admin/Module/eCom_Catalog" + groupTreeBasePath + "/EcomGroupTree.aspx?CMD=ShowProd&AddCaller=1&caller=" + caller, "", "displayWindow,width=460,height=400,scrollbars=no");
        }
    }

    function RemoveProduct(fieldName) {
        if (fieldName != "") {
            document.getElementById("ID_" + fieldName).value = '';
            document.getElementById("VariantID_" + fieldName).value = '';
            document.getElementById('Name_' + fieldName).value = '<%=Translate.JsTranslate("No product selected") %>';

        }
    }

    function togglePagedQueriesOptionsVisibility(isVisible) {
        var chk = null, row = null;

        if (typeof (isVisible) == 'undefined' || isVisible == null) {
            chk = document.getElementById('chkPagedQueries');
            if (chk != null) {
                isVisible = chk.checked;
            }
        }

        row = document.getElementById('rowForcePagedQueries');
        if (row) {
            row.style.display = isVisible ? '' : 'none';
        }
    }

    function checkDisplayCachingExpiration(checkbox) {
        var expInput = document.getElementById("FrontendCachingExpiration");
        if (checkbox.checked && (expInput.value == "" || expInput.value == "0"))
            expInput.value = "1";
    }

    document.addEventListener("DOMContentLoaded", function (event) {
        const imagesPaneEl = document.getElementById("gbImages");
        imagesPaneEl.style.display = deprecateOldImages ? "none" : "block";
    });
</script>

<style type="text/css">
    .infobar .information {
        background: #DDECFF;
        border: 1px solid #00529B;
        width: 100%;
    }

    .hide {
        display: none;
    }

    .query-props-group > div {
        padding-top: 4px;
    }

    .query-props-group .btn.restore {
        cursor: pointer;
        line-height: 20px;
        display: inline-block;
        height: 20px;
        color: #333333;
        border: 1px solid #d7dee8;
        background-color: #fafafa;
        margin-top: 4px;
        padding: 2px 4px;
    }

        .query-props-group .btn.restore:hover {
            background-color: #ddecff;
            border: 1px solid #bdcce0;
        }

    #PPUsePrintPublisher, #both {
        cursor: pointer;
    }

    #gbImages {
        display: none;
    }
</style>

<dw:ModuleHeader ID="ModuleHeader1" runat="server" ModuleSystemName="eCom_Catalog"></dw:ModuleHeader>
<dw:ModuleSettings ID="ModuleSettings1" runat="server" ModuleSystemName="eCom_Catalog" Value="RetrieveMyListsBasedOn, DisableProductDetail, IgnoreUrlParameters, UseFrontendCaching, FrontendCachingExpiration, UseOptimizedEcomFrontend, MetaFirstPageAsCanonical, Show, ProductAndGroupsSelector, IncludeSubgroups, PageSize, PageSizeForward, PageSizeForwardPicture, PageSizeForwardText, PageSizeBack, PageSizeBackPicture, PageSizeBackText, SortBy, SortOrder, ProductListTemplate, ProductListFeedTemplate, SearchTemplate, GroupListTemplate, ProductTemplate, ProductFeedTemplate, NolistTemplate, ImageFolder, ImageSearchInSubfolders, AlternativePictureBox, ID_ProductID, VariantID_ProductID, TemplateSearchBox, ShowGroups, ShortDescLength, NoProductTemplate, RemoveDuplicates, ImagePatternS, ImagePatternM, ImagePatternL, AltImagePatterns, CompareTemplate, ShowOnParagraph, SearchVariants, SearchShop, SearchSubGroups, PPFirstPageTemplate, PPLastPageTemplate, PPRegularPageTemplate, PPHeaderTemplate, PPFooterTemplate,PPEmailFormTemplate,PPEmailTemplate, PPUsePrintPublisher, WildcardSearchOnly, RelevanceSorting, EnablePagedQueries, ForcePagedQueries, MaxQuerySuggestions, FreeTextSearchField, HideEmptyOptions, IncludeExtendedVariants, IndexQuery, FacetGroups, ShowFacetOptionsWithNoResults, QueryConditions, QuerySortByParams, SearchForEditors_SearchForEditorsIndex, SearchForEditors_SearchForEditorsConfiguration, UseGroupSortInGroupContext, DynamicFacets, FieldToSpellCheck, ParameterToSpellCheck, TrackQueries" />

<dw:GroupBox runat="server" Title="Indstillinger" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" text="Vis" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" runat="server" id="ShowProduct" name="Show" value="Product" onclick="GetSettings(this);" />
                    <label for="ShowProduct">
                        <dw:TranslateLabel runat="server" text="Produkt" />
                    </label>
                    <br />
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="ShowList" name="Show" value="List" onclick="GetSettings(this);" />
                    <label for="ShowList">
                        <dw:TranslateLabel runat="server" text="Varegrupper" />
                    </label>
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="ShowProductContext" name="Show" value="Context" onclick="GetSettings(this);" />
                    <label for="ShowProductContext">
                        <dw:TranslateLabel runat="server" text="Products (context)" />
                    </label>
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="ShowIndex" name="Show" value="Index" onclick="GetSettings(this);" />
                    <label for="ShowIndex">
                        <dw:TranslateLabel runat="server" text="Index" />
                    </label>
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="ShowSearchForEditors" name="Show" value="SearchForEditors" onclick="GetSettings(this);" />
                    <label for="ShowSearchForEditors">
                        <dw:TranslateLabel runat="server" text="Search for editors" />
                    </label>
                    <br />
                </div>

                <div class="radio" style="display: none;">
                    <input type="radio" runat="server" id="ShowDoNotListProducts" name="Show" value="DoNotListProducts" onclick="GetSettings(this);" />
                    <label for="ShowDoNotListProducts" title="<%= Translate.Translate("Call page with ProductId parameter to show product details") %>">
                        <dw:TranslateLabel runat="server" text="Product details only" />
                    </label>
                </div>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<div id="ProductListBox">
    <dw:GroupBox runat="server" Title="Grupper" DoTranslation="true">

        <table class="formsTable">
            <tr id="GroupSelector">
                <td><%=Translate.Translate("Varegrupper")%></td>
                <td>
                    <de:ProductsAndGroupsSelector runat="server" OnlyGroups="true" ShowSearches="true" ID="ProductAndGroupsSelector" CallerForm="paragraph_edit" Width="250px" Height="100px" />
                    <br />
                    <br />
                    <dw:CheckBox runat="server" id="IncludeSubgroups" name="IncludeSubgroups" IsChecked="True" />
                    <label for="IncludeSubgroups">
                        <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Include subgroups" />
                    </label>
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<div id="ProductBox" style="display: block;">
    <dw:GroupBox runat="server" Title="Visning" DoTranslation="True">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel id="Translatelabel27" runat="server" Text="Produkt" />
                </td>
                <td>
                    <div class="input-group">
                        <div class="form-group-input">
                            <input type="hidden" id="ID_ProductID" runat="server" />
                            <input type="hidden" id="VariantID_ProductID" runat="server" />
                            <input type="text" id="Name_ProductID" class="form-control NewUIinput" runat="server" />
                        </div>
                        <span class="input-group-addon" onclick="javascript:AddProduct('DW_REPLACE_ProductID');" title="Add">
                            <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Plus, True, Core.UI.KnownColor.Success) %>" alt="<%=Translate.JsTranslate("Produkter")%>"></i>
                        </span><span class="input-group-addon last" onclick="javascript:RemoveProduct('ProductID');" title="Delete">
                            <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Remove, True, Core.UI.KnownColor.Danger) %>" alt="<%=Translate.JsTranslate("Slet")%>"></i>
                        </span>
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<div id="ProductIndexBox">
    <dw:GroupBox runat="server" Title="Index">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Query" />
                </td>
                <td>
                    <asp:literal runat="server" id="QuerySelectLiteral"></asp:literal>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <dw:CheckBox runat="server" ID="TrackQueries" />
                    <label for="TrackQueries">
                        <dw:TranslateLabel runat="server" Text="Track queries for statistics" />
                    </label>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;">
                    <dw:TranslateLabel runat="server" Text="Facet groups" />
                    <input type="hidden" id="facets" name="FacetGroups" value="" />
                </td>
                <td id="selectionBoxContainer">
                    <dw:SelectionBox runat="server" ID="selectFacets" />
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <dw:CheckBox runat="server" id="ShowFacetOptionsWithNoResults" name="ShowFacetOptionsWithNoResults" IsChecked="True" />
                    <label for="ShowFacetOptionsWithNoResults">
                        <dw:TranslateLabel runat="server" Text="Show facet options with no results" />
                    </label>
                </td>
            </tr>

            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Override standard parameters" />
                </td>
                <td>
                    <dw:EditableList ID="QueryConditions" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" EnableLegacyRendering="True" AllowAddNewRow="False" AllowDeleteRow="False">
                    </dw:EditableList>
                    <div style="text-align: right">
                        <span onclick="loadDefaultQueryParameters()" class="btn restore">
                            <%=Translate.Translate("Reset")%>
                        </span>
                    </div>

                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Sort By" />
                </td>
                <td>
                    <dw:EditableList ID="QuerySortByParams" runat="server" AllowPaging="true" AllowSorting="false" AutoGenerateColumns="false" EnableLegacyRendering="True">
                    </dw:EditableList>
                    <div style="text-align: right">
                        <span onclick="loadDefaultSortByParams()" class="btn restore">
                            <%=Translate.Translate("Reset")%>
                        </span>
                    </div>
                    <div>
                        <dw:CheckBox runat="server" ID="UseGroupSortInGroupContext" />
                        <label for="UseGroupSortInGroupContext">
                            <dw:TranslateLabel runat="server" Text="Use group sort in group context" />
                        </label>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Dynamic facets" />
                </td>
                <td>
                    <div class="radio">
                        <input type="radio" runat="server" id="DoNotAllowDynamicFacets" name="DynamicFacets" value="None" />
                        <label for="AllowDynamicFacetsFromExistingFacetGroups">
                            <dw:TranslateLabel runat="server" Text="Do not allow dynamic facets" />
                        </label>
                    </div>
                    <div class="radio">
                        <input type="radio" runat="server" id="AllowDynamicFacetsFromExistingFacetGroups" name="DynamicFacets" value="Existing" />
                        <label for="AllowDynamicFacetsFromExistingFacetGroups">
                            <dw:TranslateLabel runat="server" Text="Allow dynamic facets from existing facet groups" />
                        </label>
                    </div>
                    <div class="radio">
                        <input type="radio" runat="server" id="AllowDynamicFacetsFromAllFields" name="DynamicFacets" value="AllFields" />
                        <label for="AllowDynamicFacetsFromAllFields">
                            <dw:TranslateLabel runat="server" Text="Allow dynamic facets for all fields" />
                        </label>
                    </div>
                </td>
            </tr>
        </table>
    </dw:GroupBox>
    <dw:GroupBox ID="grpSpellChecker" Title="Spell check" runat="server">
        <table class="formsTable">
            <tr>
                <td><%= Translate.Translate("Field to check")%></td>
                <td>
                    <select id="FieldToSpellCheck" name="FieldToSpellCheck" runat="server" class="std"></select>
                </td>
            </tr>
            <tr>
                <td><%= Translate.Translate("Query parameter")%></td>
                <td>
                    <select id="ParameterToSpellCheck" name="ParameterToSpellCheck" runat="server" class="std"></select>
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<div id="SearchForEditors">
    <dw:GroupBox runat="server" Title="Search for editors">
        <table class="formsTable">            
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Index" />
                </td>
                <td>
                    <asp:literal runat="server" id="SearchForEditorsIndex"></asp:literal>
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Configuration" />
                </td>
                <td>
                    <asp:literal runat="server" id="SearchForEditorsConfiguration"></asp:literal>
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<div id="ProdSorting" style="display: block;">
    <dw:GroupBox runat="server" Title="Visning" DoTranslation="true">
        <table class="formsTable">
            <tr id="ProdSortingPageSizeTR">
                <td><%=Translate.Translate("Varer pr. side")%></td>
                <td>
                    <input type="text" runat="server" id="PageSize" name="PageSize" value="0" class="std" style="width: 50px;" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:translatelabel id="Translatelabel5" runat="server" text="Teaser tekst" />
                </td>
                <td><%=Translate.Translate("Vis de første %% tegn", "%%", "<input type=""number"" ID=""ShortDescLength"" name=""ShortDescLength"" runat=server class=""std"" min=""0"" size=""6"" value=""" & ParagraphSettings.ShortDescriptionLength.ToString & """>")%></td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel id="Translatelabel19" runat="server" text="Sorter efter" />
                </td>
                <td>
                    <asp:literal id="SortEnum" runat="server"></asp:literal>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;">
                    <dw:TranslateLabel runat="server" text="Sorteringsrækkefølge" />
                </td>
                <td>
                    <div class="radio">
                        <input type="radio" runat="server" id="SortOrderASC" name="SortOrder" value="ASC" />
                        <label for="SortOrderASC">
                            <dw:TranslateLabel runat="server" text="Stigende" />
                        </label>
                    </div>

                    <div class="radio">
                        <input type="radio" runat="server" id="SortOrderDESC" name="SortOrder" value="DESC" />
                        <label for="SortOrderDESC">
                            <dw:TranslateLabel runat="server" text="Faldende" />
                        </label>
                    </div>
                </td>
            </tr>

            <tr id="ProdSortingRemoveDuplicatesTR">
                <td />
                <td>
                    <dw:CheckBox runat="server" ID="RemoveDuplicates" name="RemoveDuplicates" IsChecked="True" />
                    <label for="RemoveDuplicates">
                        <dw:TranslateLabel runat="server" Text="Remove duplicate products" />
                    </label>
                </td>
            </tr>

        </table>
    </dw:GroupBox>
</div>

<dw:GroupBox runat="server" ID="gbImages" Title="Billeder" DoTranslation="true">
    <input id="ImagePatternInit" name="ImagePatternInit" runat="server" type="hidden" value="" />
    <input id="AltImagePatterns" name="AltImagePatterns" runat="server" type="hidden" value="" />

    <div id="PatternsWarningContainer" runat="server">
        <dw:Infobar runat="server" Type="Warning" Message="Using search in subfolders option can cause bad performance"></dw:Infobar>
        <br />
    </div>

    <table class="formsTable">
        <tr>
            <td></td>
            <td><%=strUseAltImage%></td>
        </tr>
    </table>

    <table id="UseAltImageSection" class="formsTable" style="<%=IIF(ParagraphSettings.AlternativePictureBox = 1, "display:table;", "display:none;")%>">
        <tr id="AlternativePictureA">
            <td>
                <dw:translatelabel id="Translatelabel1" runat="server" text="Billed mappe" />
            </td>
            <td>
                <dw:foldermanager id="ImageFolder" name="ImageFolder" runat="server"></dw:foldermanager>
                <div class="p-t-10">
                    <dw:CheckBox ID="ImageSearchInSubfolders" name="ImageSearchInSubfolders" runat="server" OnClick="backend.toggleSearchInSubfolders(this);" />
                    <label for="ImageSearchInSubfolders">
                        <dw:TranslateLabel runat="server" Text="Search in subfolders" />
                    </label>
                </div>
            </td>
        </tr>
        <tr id="AlternativePictureB">
            <td height="5" colspan="2" style="font-weight: bold;"><%=Translate.Translate("Filnavnsmønster")%></td>
        </tr>
        <tr id="AlternativePictureC">
            <td>
                <dw:translatelabel id="Translatelabel10" runat="server" text="Lille" />
            </td>
            <td>
                <input type="text" runat="server" name="ImagePatternS" id="ImagePatternS" class="std" value="" /></td>
        </tr>
        <tr id="AlternativePictureD">
            <td>
                <dw:translatelabel id="Translatelabel24" runat="server" text="Medium" />
            </td>
            <td>
                <input type="text" runat="server" name="ImagePatternM" id="ImagePatternM" class="std" value="" /></td>
        </tr>
        <tr id="AlternativePictureE">
            <td>
                <dw:translatelabel id="Translatelabel25" runat="server" text="Stor" />
            </td>
            <td>
                <input type="text" runat="server" name="ImagePatternL" id="ImagePatternL" class="std" value="" /></td>
        </tr>

        <tr>
            <td></td>
            <td>
                <table style="width: 60%;">
                    <thead>
                        <tr id="AlternativePictureHeader" style="display: none;">
                            <td colspan="2" style="font-weight: bold;"><%=Translate.Translate("User defined patterns")%></td>
                            <td width="50" style="font-weight: bold;"><%=Translate.Translate("Width")%></td>
                            <td width="50" style="font-weight: bold;"><%=Translate.Translate("Height")%></td>
                            <td width="20"></td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr id="AlternativePicture" style="display: none;">
                            <td style="width: 100px;">
                                <input name="ImagePatternName" id="ImagePatternName" type="text" class="std" style="width: 100px;" value="" /></td>
                            <td style="padding-left: 3px;">
                                <input name="ImagePattern" id="ImagePattern" type="text" class="std" value="" style="width: 100%;" /></td>
                            <td style="padding-left: 3px;">
                                <input name="ImagePatternWidth" id="ImagePatternWidth" type="text" class="std" style="width: 100%;" value="" /></td>
                            <td style="padding-left: 3px;">
                                <input name="ImagePatternHeight" id="ImagePatternHeight" type="text" class="std" style="width: 100%;" value="" /></td>
                            <td><i id="imagePatternDelete" class="<% KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare) %>" alt='<%=Translate.Translate("Delete image")%>' onclick="if(confirm('<%=Translate.JsTranslate("Delete image pattern?")%>')){ backend.deleteImage(this); };" style="cursor: pointer;"></i></td>
                        </tr>
                        <tr id="imagePatternBottom" style="display: none;">
                            <td colspan="5"></td>
                        </tr>
                    </tbody>
                </table>
            </td>
        </tr>
        <tr id="addImagePattern">
            <td></td>
            <td>
                <button type="button" class="btn btn-flat" onclick="backend.addPattern();">
                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Core.UI.KnownColor.Success) %>"></i>Add pattern
                </button>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<div id="Templates" style="display: block;">
    <dw:GroupBox runat="server" Title="Templates">
        <table class="formsTable">
            <tr id="TemplateListTR">
                <td>
                    <dw:TranslateLabel id="Translatelabel3" runat="server" Text="Liste" />
                </td>
                <td>
                    <dw:FileManager runat="server" id="ProductListTemplate" Folder="Templates/eCom/Productlist/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="TemplateListTR2">
                <td>
                    <dw:TranslateLabel id="Translatelabel9" runat="server" Text="List feed" />
                </td>
                <td>
                    <dw:FileManager runat="server" id="ProductListFeedTemplate" Folder="Templates/eCom/Productlist/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="TemplateGrpTR">
                <td>
                    <dw:TranslateLabel id="Translatelabel4" runat="server" Text="Grupper" />
                </td>
                <td>
                    <dw:CheckBox runat="server" id="ShowGroups" name="ShowGroups" IsChecked="True" AttributesParm="onclick='ChangeTemplateGroups();'" />
                    <br />
                </td>
            </tr>
            <tr id="TemplateGroupDiv" style="display: none;">
                <td></td>
                <td>
                    <dw:FileManager runat="server" id="GroupListTemplate" Folder="Templates/eCom/GroupList/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="TemplateProdTR">
                <td>
                    <dw:TranslateLabel id="Translatelabel6" runat="server" Text="Vare" />
                </td>
                <td>
                    <dw:FileManager runat="server" id="ProductTemplate" Folder="Templates/eCom/Product/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="TemplateProdTR2">
                <td>
                    <dw:TranslateLabel id="Translatelabel11" runat="server" Text="Product feed" />
                </td>
                <td>
                    <dw:FileManager runat="server" id="ProductFeedTemplate" Folder="Templates/eCom/Product/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="NolistTemplateTR">
                <td>
                    <dw:TranslateLabel id="Translatelabel8" runat="server" Text="No list template" />
                </td>
                <td>
                    <dw:FileManager runat="server" id="NolistTemplate" Folder="Templates/eCom/Nolist/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="TemplateSearchTR">
                <td>
                    <dw:TranslateLabel id="Translatelabel7" runat="server" Text="Søgning" />
                </td>
                <td>
                    <dw:CheckBox runat="server" id="TemplateSearchBox" name="TemplateSearchBox" IsChecked="True" AttributesParm="onclick='ChangeTemplateSearch();'" />
                    <br />
                </td>
            </tr>
            <tr id="TemplateSearchDiv" style="display: none;">
                <td></td>
                <td>
                    <dw:FileManager runat="server" id="SearchTemplate" Folder="Templates/eCom/Search/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="TemplateCompareTR">
                <td><%= Translate.Translate("Compare")%></td>
                <td>
                    <dw:FileManager runat="server" id="CompareTemplate" Folder="Templates/eCom/Productlist/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="TemplateNoProdTR">
                <td><%=Translate.Translate("Ingen produkter fundet")%></td>
                <td>
                    <dw:FileManager runat="server" id="NoProductTemplate" Folder="Templates/eCom/Productlist/" FullPath="True"></dw:FileManager></td>
            </tr>
        </table>
    </dw:GroupBox>

</div>

<div id="PrintPublisher" style="display: block;">
    <dw:GroupBox runat="server" Title="Catalog publishing">
        <table class="formsTable">
            <tr>
                <td></td>
                <td><%=strUseCatalog%></td>
            </tr>
        </table>

        <table class="formsTable" id="PrintPublisherTable" style="<%=styleDisplay %>">
            <tr id="FirstPage">
                <td><%= Translate.Translate("First Page")%></td>
                <td>
                    <dw:FileManager runat="server" id="PPFirstPageTemplate" Folder="Templates/eCom/CatalogPublishing/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="LastPage">
                <td><%= Translate.Translate("Last Page")%></td>
                <td>
                    <dw:FileManager runat="server" id="PPLastPageTemplate" Folder="Templates/eCom/CatalogPublishing/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="RegularPage">
                <td><%= Translate.Translate("Regular Page")%></td>
                <td>
                    <dw:FileManager runat="server" id="PPRegularPageTemplate" Folder="Templates/eCom/CatalogPublishing/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="Header">
                <td><%= Translate.Translate("Header")%></td>
                <td>
                    <dw:FileManager runat="server" id="PPHeaderTemplate" Folder="Templates/eCom/CatalogPublishing/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="Footer">
                <td><%= Translate.Translate("Footer")%></td>
                <td>
                    <dw:FileManager runat="server" id="PPFooterTemplate" Folder="Templates/eCom/CatalogPublishing/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="Tr2">
                <td><%= Translate.Translate("Email Form")%></td>
                <td>
                    <dw:FileManager runat="server" id="PPEmailFormTemplate" Folder="Templates/eCom/CatalogPublishing/Email/" FullPath="True"></dw:FileManager></td>
            </tr>
            <tr id="Tr1">
                <td><%= Translate.Translate("Email")%></td>
                <td>
                    <dw:FileManager runat="server" id="PPEmailTemplate" Folder="Templates/eCom/CatalogPublishing/Email/" FullPath="True"></dw:FileManager></td>
            </tr>

        </table>
    </dw:GroupBox>
</div>

<div id="ProductSearch">
    <dw:GroupBox runat="server" Title="Ecommerce search" DoTranslation="True">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" text="Show" />
                </td>
                <td>
                    <dw:CheckBox runat="server" id="IncludeExtendedVariants" name="IncludeExtendedVariants" IsChecked="True" />
                    <label for="IncludeExtendedVariants">
                        <dw:TranslateLabel runat="server" Text="Include extended variants" />
                    </label>
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<div id="AdditionalSettings" style="display: block;">
    <dw:GroupBox ID="gbSettings" runat="server" Title="Additional settings">
        <table class="formsTable">
            <tr id="AdditionalSettingsIgnoreUrlTR">
                <td></td>
                <td>
                    <dw:CheckBox runat="server" id="IgnoreUrlParameters" name="IgnoreUrlParameters" IsChecked="True" />
                    <label for="IgnoreUrlParameters">
                        <dw:TranslateLabel runat="server" text="Ignore URL parameters" />
                    </label>
                    <br />
                </td>
            </tr>

            <tr id="OptimizedEnableTR">
                <td></td>
                <td>
                    <dw:CheckBox runat="server" id="UseOptimizedEcomFrontend" name="UseOptimizedEcomFrontend" IsChecked="True" />
                    <input type="hidden" name="UseOptimizedEcomFrontend" value="dummy" />
                    <label for="UseOptimizedEcomFrontend">
                        <dw:TranslateLabel runat="server" text="Enable optimized product retrieval" />
                    </label>
                    <br />
                </td>
            </tr>
            <tr id="OptimizedCacheEnableTR">
                <td></td>
                <td>
                    <dw:CheckBox runat="server" id="UseFrontendCaching" name="UseFrontendCaching" onchange="checkDisplayCachingExpiration(this);" IsChecked="True" />
                    <label for="UseFrontendCaching">
                        <dw:TranslateLabel runat="server" text="Enable display caching" />
                    </label>
                    <br />
                </td>
            </tr>
            <tr id="OptimizedCacheDisplayDurationTR">
                <td>
                    <dw:TranslateLabel runat="server" text="Display caching expiration" />
                </td>
                <td>
                    <input type="text" runat="server" id="FrontendCachingExpiration" name="FrontendCachingExpiration" value="0" class="std" style="width: 50px;" />
                </td>
            </tr>

            <tr id="AdditionalSettingsMetaFirstPageAsCanonicalTR">
                <td></td>
                <td>
                    <dw:CheckBox runat="server" id="MetaFirstPageAsCanonical" name="MetaFirstPageAsCanonical" IsChecked="True" />
                    <label for="MetaFirstPageAsCanonical">
                        <dw:TranslateLabel runat="server" text="Use first page in list as canonical URL" />
                    </label>
                    <br />
                </td>
            </tr>
            <tr id="ShowOnParagraphTR">
                <td>
                    <dw:TranslateLabel runat="server" text="Show on paragraph" />
                </td>
                <td>
                    <dw:LinkManager runat="server" id="ShowOnParagraph" EnablePageSelector="False" DisableFileArchive="True"></dw:LinkManager></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <dw:CheckBox runat="server" id="DisableProductDetail" name="DisableProductDetail" IsChecked="True" />
                    <label for="DisableProductDetail">
                        <dw:TranslateLabel runat="server" text="Do not allow product detail (404)" />
                    </label>
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel ID="TranslateLabel20" runat="server" Text="Retrieve My Lists based on:" />
                </td>
                <td>
                    <div class="radio">
                        <input type="radio" runat="server" id="RetrieveMyListsBasedOn_UseUserID" name="RetrieveMyListsBasedOn" value="UseUserID" />
                        <label for="RetrieveMyListsBasedOn_UseUserID">
                            <dw:TranslateLabel ID="TranslateLabel21" runat="server" Text="User id" />
                        </label>
                    </div>

                    <div class="radio">
                        <input type="radio" runat="server" id="RetrieveMyListsBasedOn_UseCustomerNumber" name="RetrieveMyListsBasedOn" value="UseCustomerNumber" />
                        <label for="RetrieveMyListsBasedOn_UseCustomerNumber">
                            <dw:TranslateLabel ID="TranslateLabel22" runat="server" Text="Customer number" />
                        </label>
                    </div>
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>


<script type="text/javascript">
    function indexQueryChanged() {
        var querySelector = document.getElementById("IndexQuery");
        var query = querySelector[querySelector.selectedIndex];
        if (!query.value) {
            hideQueryParameters();
        }

        loadQueryInfo("GetQueryInfo", query.value, function (responseText) {
            document.getElementById("selectionBoxContainer").innerHTML = responseText;
            SelectionBox.setNoDataLeft("selectFacets");
            SelectionBox.setNoDataRight("selectFacets");
            serializeFacets();
            var info = JSON.parse($("query-info").innerHTML);
            fillQueryInfo(info, {
                fetchParameters: true,
                fetchSortBy: true
            });
            toggleQueryParameters(!!query.value);
        });
    }

    function serializeFacets() {
        var facets = SelectionBox.getElementsRightAsArray("selectFacets");
        var values = "";

        for (var i = 0; i < facets.length; i++) {
            if (i > 0)
                values += ",";
            values += facets[i];
        }

        document.getElementById("facets").value = values;
    }

    backend.setBeforeSave();
    backend.initPatternImages();
    ReturnSettings();
    ChangeTemplateSearch();
    ChangeTemplateGroups();
    togglePagedQueriesOptionsVisibility();

    serializeFacets();
    SelectionBox.setNoDataLeft("selectFacets");
    SelectionBox.setNoDataRight("selectFacets");
    toggleQueryParameters($("IndexQuery").value);
</script>
