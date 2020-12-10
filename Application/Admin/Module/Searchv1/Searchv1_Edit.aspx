<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Searchv1_Edit.aspx.vb" ValidateRequest="false" Inherits="Dynamicweb.Admin.Searchv1_Edit" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Security" %>
<%@ Import Namespace="Dynamicweb.Security.UserManagement" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Modules" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Ecommerce.Extensibility.Controls" Assembly="Dynamicweb.Ecommerce" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<dw:ModuleSettings ID="ModuleSettings" runat="server" ModuleSystemName="searchv1" Value="Searchv1Method, Searchv1SearchPages, Searchv1SearchNews, Searchv1Area, Searchv1AreaID, Searchv1News, Searchv1NewsPageID, Searchv1NewsParagraphID, Searchv1SearchNewsUseDate, Searchv1NewsCategoryID, Searchv1PageSize, Searchv1ButtonForward, Searchv1ButtonForwardText, Searchv1ButtonForwardPicture, Searchv1ButtonBack, Searchv1ButtonBackText, Searchv1ButtonBackPicture, Searchv1TemplateSearch, Searchv1TemplateNoresult, Searchv1TemplateList, Searchv1TemplateListElement, Searchv1SearchCalender, Searchv1Calender, Searchv1CalenderPageID, Searchv1CalenderParagraphID, Searchv1SearchCalenderUseDate, Searchv1CalenderCategoryID, Searchv1SearchShop, Searchv1Shop, Searchv1ShopPageID, Searchv1ShopParagraphID, Searchv1ShopProductGroupID, Searchv1SearchPageUseDescription, SearchKeywords, WeightTitle, WeightText, WeightDescription, WeightKeywords, Searchv1MediaDBPageID, Searchv1MediaDBParagraphID, Searchv1MediaDB, Searchv1MediaDBGroupID, Searchv1SearchMediaDB, Searchv1PageID, Searchv1SearchFiles, Searchv1FilesCatalog, Searchv1FilesStartIn, Searchv1FilesExtensions, Searchv1FilesSearchSubfolders, Searchv1SearchNewsDontUseM, Searchv1SearchCalenderDontUseM, Searchv1SearchShopDontUseM, Searchv1SearchMediaDBDontUseM, Searchv1FilesAllwaysUseFilenameAsTitle, LegendInclude, LegendIncludeLink, LegendIncludeArea, LegendIncludeAreaFrontpage, Searchv1SearcheCom, Searchv1eComPageID, Searchv1eComParagraphID, Searchv1SearcheComDontUseM, Searchv1eComIncludeExtendedVariants, ProductAndGroupsSelector, IncludeSubgroups, Searchv1eComUseAllCustomField, Searchv1eComUseAllCustomGroupField, Searchv1IntranoteIntegration, SearchParagraphHeader, SearchIncludeItemLists, UseTitle" />
<dw:ModuleHeader ID="ModuleHeader" runat="server" ModuleSystemName="searchv1" />

<link rel="Stylesheet" type="text/css" href="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
<script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/images/functions.js"></script>
<script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/images/AjaxAddInParameters.js"></script>

<script>
    function initValidators() {
        window["paragraphEvents"].setValidator(function () {
            var ret = true;
            var emptyPages = [];
            var firstSelector = null;
            var checked = $$('#search-in input:checked');

            checked.each(function (c) {
                var m = new RegExp('Searchv1((Search)*)(.+)').exec(c.id);

                if (m != null && m.length > 3) {
                    var pageSelectorId = 'Searchv1' + m[3] + 'PageID';
                    var pageSelector = $(pageSelectorId);

                    if (pageSelector && (!pageSelector.value || !pageSelector.value.length)) {
                        emptyPages.push(c.next('label').innerHTML);

                        if (!firstSelector) {
                            firstSelector = $('Link_' + pageSelectorId);
                        }
                    }
                }
            });

            if (emptyPages.length) {
                if (firstSelector) {
                    try {
                        firstSelector.focus();
                    } catch (ex) { }
                }

                alert('<%=Translate.Translate("Please specify %% for: ", "%%", """Show on page""")%>' + '\n\n' + emptyPages.join('\n'));

                ret = false;
            }

            return ret;
        });
    }

    function CheckeComSettings() {
        //Custom product fields
        try {
            var cpf = null;
            for (i = 0; i < document.paragraph_edit.Searchv1eComUseAllCustomField.length; i++) {
                if (document.paragraph_edit.Searchv1eComUseAllCustomField[i].checked == true) {
                    cpf = document.paragraph_edit.Searchv1eComUseAllCustomField[i].value;
                }
            }
            if (cpf == null) {
                for (i = 0; i < document.paragraph_edit.Searchv1eComUseAllCustomField.length; i++) {
                    if (document.paragraph_edit.Searchv1eComUseAllCustomField[i].value == "ALL") {
                        document.paragraph_edit.Searchv1eComUseAllCustomField[i].checked = true;
                    }
                }
            }
        } catch (e) {
            //Nothing
        }

        //Custom group fields
        try {
            var cgf = null;
            for (i = 0; i < document.paragraph_edit.Searchv1eComUseAllCustomGroupField.length; i++) {
                if (document.paragraph_edit.Searchv1eComUseAllCustomGroupField[i].checked == true) {
                    cgf = document.paragraph_edit.Searchv1eComUseAllCustomGroupField[i].value;
                }
            }
            if (cgf == null) {
                for (i = 0; i < document.paragraph_edit.Searchv1eComUseAllCustomGroupField.length; i++) {
                    if (document.paragraph_edit.Searchv1eComUseAllCustomGroupField[i].value == "ALL") {
                        document.paragraph_edit.Searchv1eComUseAllCustomGroupField[i].checked = true;
                    }
                }
            }
        } catch (e) {
            //Nothing
        }
    }
</script>

<style type="text/css">
    .notice {
        font-size: smaller;
        color: #8c8c8c;
        padding-left: 22px;
    }

    .p-l-20 {
        padding-left: 20px;
    }
</style>

<dw:GroupBox runat="server" Title="Søgemetode">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Søg efter" runat="server" />
            </td>
            <td>
                <div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1Method"), "Searchv1Method", "1")%><label for="Searchv1Method1"><%=Translate.Translate("Hele ordet - del af ordet hvis hele ordet ikke findes")%></label></div>
                <div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1Method"), "Searchv1Method", "2")%><label for="Searchv1Method2"><%=Translate.Translate("Hele ordet og del af ordet")%></label></div>
                <div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1Method"), "Searchv1Method", "3")%><label for="Searchv1Method3"><%=Translate.Translate("Hele ordet")%></label></div>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox Title="Søg i" runat="server">
    <table id="search-in" class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Søg i" runat="server" />
            </td>
            <td>
                <dw:CheckBox ID="Searchv1SearchPages" FieldName="Searchv1SearchPages" runat="server" />
            </td>
        </tr>
        <%If (Authorization.UserHasAccess("News", "") AndAlso Dynamicweb.Extensibility.ServiceLocator.Current.GetModuleService().GetBySystemName("News") IsNot Nothing) OrElse (Authorization.UserHasAccess("NewsV2", "") AndAlso Dynamicweb.Extensibility.ServiceLocator.Current.GetModuleService().GetBySystemName("NewsV2") IsNot Nothing) Then%>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="Searchv1SearchNews" FieldName="Searchv1SearchNews" runat="server" />
            </td>
        </tr>
        <%End If%>
        <%If Licensing.LicenseManager.LicenseHasFeature("Ecommerce") Then%>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="Searchv1SearcheCom" FieldName="Searchv1SearcheCom" runat="server" />
            </td>
        </tr>
        <%End If%>
        <%=GetCustomModulesList()%>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="Searchv1SearchFiles" FieldName="Searchv1SearchFiles" runat="server" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox Title="Vægtning" runat="server">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Titel" runat="server" />
            </td>
            <td><%=Gui.SpacListExt(prop.Value("WeightTitle"), "WeightTitle", 0, 10, 1, "")%></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Tekst" runat="server" />
            </td>
            <td><%=Gui.SpacListExt(prop.Value("WeightText"), "WeightText", 0, 10, 1, "")%></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Beskrivelse" runat="server" />
            </td>
            <td><%=Gui.SpacListExt(prop.Value("WeightDescription"), "WeightDescription", 0, 10, 1, "")%></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Nøgleord" runat="server" />
            </td>
            <td><%=Gui.SpacListExt(prop.Value("WeightKeywords"), "WeightKeywords", 0, 10, 1, "")%></td>
        </tr>
    </table>
</dw:GroupBox>

<script type="text/javascript">
    function LegendSettings(elm) {
        if (elm.value != "") {
            document.getElementById("LegendIncludeLinkRow").style.display = "";
            document.getElementById("LegendIncludeAreaRow").style.display = "";
            document.getElementById("LegendIncludeAreaFrontpageRow").style.display = "";
        }
        else {
            document.getElementById("LegendIncludeLinkRow").style.display = "none";
            document.getElementById("LegendIncludeAreaRow").style.display = "none";
            document.getElementById("LegendIncludeAreaFrontpageRow").style.display = "none";
        }
    }
</script>

<dw:GroupBox Title="Brødkrummesti" runat="server">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Vis" runat="server" />
            </td>
            <td>
                <dw:CheckBox ID="LegendInclude" FieldName="LegendInclude" Attributes="onchange='LegendSettings(this);'" runat="server" />
            </td>
        </tr>
        <tr id="LegendIncludeLinkRow">
            <td></td>
            <td>
                <span class="p-l-20">
                    <dw:CheckBox ID="LegendIncludeLink" FieldName="LegendIncludeLink" runat="server" />
                </span>
            </td>
        </tr>
        <%If Authorization.UserHasAccess("Area", "") Then%>
        <tr id="LegendIncludeAreaRow">
            <td></td>
            <td>
                <span class="p-l-20">
                    <dw:CheckBox ID="LegendIncludeArea" FieldName="LegendIncludeArea" runat="server" />
                </span>
            </td>
        </tr>
        <%End If%>
        <tr id="LegendIncludeAreaFrontpageRow">
            <td></td>
            <td>
                <span class="p-l-20">
                    <dw:CheckBox ID="LegendIncludeAreaFrontpage" FieldName="LegendIncludeAreaFrontpage" runat="server" />
                </span>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox ID="groupBox1" DoTranslation="false" runat="server">
    <table class="formsTable">
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="SearchKeywords" FieldName="SearchKeywords" runat="server" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="Searchv1SearchPageUseDescription" FieldName="Searchv1SearchPageUseDescription" runat="server" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="UseTitle" FieldName="UseTitle" runat="server" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="SearchParagraphHeader" FieldName="SearchParagraphHeader" runat="server" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="SearchIncludeItemLists" FieldName="SearchIncludeItemLists" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Søg i" runat="server" />
            </td>
            <td>
                <div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1Area"), "Searchv1Area", "Local")%><label for="Searchv1AreaLocal"><%=Translate.Translate("Aktuelle sproglag") %></label></div>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1Area"), "Searchv1Area", "Global")%><label for="Searchv1AreaGlobal"><%= Translate.Translate("Alle sproglag") %></label></div>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1Area"), "Searchv1Area", "Specified")%><label for="Searchv1AreaSpecified"><%= Translate.Translate("Følgende sproglag") %></label></div>
            </td>
        </tr>
        <tr>
            <td></td>
            <td><%=GetAreas()%></td>
        </tr>
        <tr>
            <td></td>
            <td>
                <div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1Area"), "Searchv1Area", "Page")%><label for="Searchv1AreaPage"><%= Translate.Translate("Denne side med undersider") %></label></div>
            </td>
        </tr>
        <tr>
            <td></td>
            <td><span class="p-l-20"><%=Gui.LinkManager(prop.Value("Searchv1PageID"), "Searchv1PageID", "")%></span></td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="Searchv1IncludeGlobalParagraph" FieldName="Searchv1IncludeGlobalParagraph" runat="server" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<%If (Authorization.UserHasAccess("News", "") AndAlso Dynamicweb.Extensibility.ServiceLocator.Current.GetModuleService().GetBySystemName("News") IsNot Nothing) OrElse (Authorization.UserHasAccess("NewsV2", "") AndAlso Dynamicweb.Extensibility.ServiceLocator.Current.GetModuleService().GetBySystemName("NewsV2") IsNot Nothing) Then%>
<dw:GroupBox ID="groupBox2" DoTranslation="false" runat="server">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Vis på side" runat="server" />
            </td>
            <td><%=Gui.LinkManager(prop.Value("Searchv1NewsPageID"), "Searchv1NewsPageID", "") %></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Afsnits ID" runat="server" />
            </td>
            <td>
                <input type="text" name="Searchv1NewsParagraphID" value="<%=prop.Value("Searchv1NewsParagraphID")%>" class="std" maxlength="10" style="width: 100px;">(<%=Translate.Translate("Indstillinger")%>)
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="Searchv1SearchNewsDontUseM" FieldName="Searchv1SearchNewsDontUseM" runat="server" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="Searchv1SearchNewsUseDate" FieldName="Searchv1SearchNewsUseDate" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Søg i" runat="server" />
            </td>
            <td>
                <div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1News"), "Searchv1News", "All")%><label for="Searchv1NewsAll"><%= Translate.Translate("Alle kategorier") %></label></div>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1News"), "Searchv1News", "Specified")%><label for="Searchv1NewsSpecified"><%= Translate.Translate("Følgende kategorier") %></label></div>
            </td>
        </tr>
        <tr>
            <td></td>
            <td><%=GetNewsCategories()%></td>
        </tr>
    </table>
</dw:GroupBox>
<%End If%>

<!--eCom-->
<%If Licensing.LicenseManager.LicenseHasFeature("Ecommerce") Then%>
<dw:GroupBox ID="groupBox3" DoTranslation="false" runat="server">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Vis på side" runat="server" />
            </td>
            <td><%=Gui.LinkManager(prop.Value("Searchv1eComPageID"), "Searchv1eComPageID", "") %></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Afsnits ID" runat="server" />
            </td>
            <td>
                <input type="text" name="Searchv1eComParagraphID" value="<%=prop.Value("Searchv1eComParagraphID")%>" class="std" maxlength="10" style="width: 100px;">(<%=Translate.Translate("Indstillinger")%>)
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="Searchv1SearcheComDontUseM" FieldName="Searchv1SearcheComDontUseM" runat="server" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="Searchv1eComIncludeExtendedVariants" FieldName="Searchv1eComIncludeExtendedVariants" runat="server" />
            </td>
        </tr>
        <tr id="GroupSelector">
            <td>
                <dw:TranslateLabel Text="Varegrupper" runat="server" />
            </td>
            <td>
                <de:ProductsAndGroupsSelector runat="server" OnlyGroups="true" ShowSearches="false" ID="ProductAndGroupsSelector" CallerForm="paragraph_edit" Width="250px" Height="100px" />
                <%If License.IsModuleAvailable("eCom_MultiShopAdvanced") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("eCom_MultiShopAdvanced") Then%>
                <dw:CheckBox runat="server" ID="IncludeSubgroups" FieldName="IncludeSubgroups" Value="true" />
                <%End If%>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="udv. varefelter" runat="server" />
            </td>
            <td>
                <div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1eComUseAllCustomField"), "Searchv1eComUseAllCustomField", "ALL")%><label for="Searchv1eComUseAllCustomFieldALL"><%=Translate.Translate("Alle")%></label></div>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1eComUseAllCustomField"), "Searchv1eComUseAllCustomField", "SPECIFIED")%><label for="Searchv1eComUseAllCustomFieldSPECIFIED"><%= Translate.Translate("Følgende varefelter") %></label></div>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <asp:literal id="CustomProductFieldList" runat="server"></asp:literal>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Brugerdefinerede varegruppefelter" runat="server" />
            </td>
            <td><div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1eComUseAllCustomGroupField"), "Searchv1eComUseAllCustomGroupField", "ALL")%><label for="Searchv1eComUseAllCustomGroupFieldALL"><%=Translate.Translate("Alle")%></label></div></td>
        </tr>
        <tr>
            <td></td>
            <td><div class="radio"><%=Gui.RadioButton(prop.Value("Searchv1eComUseAllCustomGroupField"), "Searchv1eComUseAllCustomGroupField", "SPECIFIED")%><label for="Searchv1eComUseAllCustomGroupFieldSPECIFIED"><%=Translate.Translate("Følgende varegruppefelter")%></label></div></td>
        </tr>
        <tr>
            <td></td>
            <td>
                <asp:literal id="CustomGroupFieldList" runat="server"></asp:literal>
            </td>
        </tr>
    </table>
</dw:GroupBox>
<%End If%>

<%=GetCustomModulesSettings()%>

<!--Files-->
<dw:GroupBox Title="Windows Search" runat="server">
    <dw:Infobar Visible="false" TranslateMessage="false" Message="" runat="server" Type="Information" Title="" OnClientClick="" ID="WindowsSearchServiceStatus"></dw:Infobar>
    <div id="folderOutOfIndexCnt" style="display: <%=If(prop.Value("IsWindowsSearchFolderOutOfIndex") = "1","block","none")%>">
        <dw:Infobar TranslateMessage="true" Message="The current folder out of search index" runat="server" Type="Error" OnClientClick="" ID="FolderOutOfIndex"></dw:Infobar>
    </div>
    <table class="formsTable">
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="Searchv1FilesAllwaysUseFilenameAsTitle" FieldName="Searchv1FilesAllwaysUseFilenameAsTitle" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Søg i" runat="server" />
            </td>
            <td><%=Gui.FolderManager(prop.Value("Searchv1FilesStartIn"), "Searchv1FilesStartIn")%></td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="Searchv1FilesSearchSubfolders" FieldName="Searchv1FilesSearchSubfolders" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Begræns til filtyper" runat="server" />
            </td>
            <td>
                <dw:CheckBox FieldName="Searchv1FilesExtensions" ID="Searchv1FilesExtensionsdoc" value="doc" runat="server" />
                <br>
                <dw:CheckBox FieldName="Searchv1FilesExtensions" ID="Searchv1FilesExtensionspdf" value="pdf" runat="server" />
                <br>
                <dw:CheckBox FieldName="Searchv1FilesExtensions" ID="Searchv1FilesExtensionsxls" value="xls" runat="server" />
                <br>
                <dw:CheckBox FieldName="Searchv1FilesExtensions" ID="Searchv1FilesExtensionsppt" value="ppt" runat="server" />
                <br>
                <dw:CheckBox FieldName="Searchv1FilesExtensions" ID="Searchv1FilesExtensionstxt" value="txt" runat="server" />
                <br>
                <dw:CheckBox FieldName="Searchv1FilesExtensions" ID="Searchv1FilesExtensionsrtf" value="rtf" runat="server" />
                <br>
                <%=Translate.Translate("Yderligere filtyper")%>
                <input type="text" name="Searchv1FilesExtensions" value="<%=Trim(prop.Value("Searchv1FilesExtensions"))%>" class="std">
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox Title="Sideopdeling" runat="server">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Resultater pr. side" runat="server" />
            </td>
            <td><%=Gui.SpacListExt(prop.Value("Searchv1PageSize"), "Searchv1PageSize", 1, 100, 1, "")%></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Frem knap" runat="server" />
            </td>
            <td><%= Gui.ButtonText("Searchv1ButtonForward", prop.Value("Searchv1ButtonForward"), prop.Value("Searchv1ButtonForwardPicture"), prop.Value("Searchv1ButtonForwardText"))%></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Tilbage knap" runat="server" />
            </td>
            <td><%=Gui.ButtonText("Searchv1ButtonBack", prop.Value("Searchv1ButtonBack"), prop.Value("Searchv1ButtonBackPicture"), prop.Value("Searchv1ButtonBackText"), True)%></td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox Title="Templates" runat="server">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Søgeboks" runat="server" />
            </td>
            <td><%=Gui.FileManager(prop.Value("Searchv1TemplateSearch"), "Templates/Searchv1", "Searchv1TemplateSearch")%></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Intet resultat" runat="server" />
            </td>
            <td><%=Gui.FileManager(prop.Value("Searchv1TemplateNoresult"), "Templates/Searchv1", "Searchv1TemplateNoresult")%></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Liste" runat="server" />
            </td>
            <td><%=Gui.FileManager(prop.Value("Searchv1TemplateList"), "Templates/Searchv1", "Searchv1TemplateList")%></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Element" runat="server" />
            </td>
            <td><%=Gui.FileManager(prop.Value("Searchv1TemplateListElement"), "Templates/Searchv1", "Searchv1TemplateListElement")%></td>
        </tr>
    </table>
</dw:GroupBox>

<script>
    CheckeComSettings();
    initValidators();
    document.observe("dom:loaded", function () {
        var infoBlockElem = $("folderOutOfIndexCnt");
        $('FLDM_Searchv1FilesStartIn').on("change", function () {
            var path = this.value;
            new Ajax.Request(window.location.toString() + "&CMD=checkwsfilepath&path=" + path, {
                method: 'get',
                onComplete: function (transport) {
                    infoBlockElem.style.display = transport.status == 400 ? "block" : "none";
                }
            });
        });
        var useLuceneIndexEl = $("UseStoredLuceneIndex");
        var searchIncludeItemListsEl = $("SearchIncludeItemLists");
        var checkUseItenLists = function () {
            if (useLuceneIndexEl.checked) {
                searchIncludeItemListsEl.checked = false;
                searchIncludeItemListsEl.disabled = true;
            }
            else {
                searchIncludeItemListsEl.disabled = false;
            }
        };
        useLuceneIndexEl.on("change", checkUseItenLists);
        checkUseItenLists();
    });

</script>

<%Translate.GetEditOnlineScript()%>