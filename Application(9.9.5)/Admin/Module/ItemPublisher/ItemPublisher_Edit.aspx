<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ItemPublisher_Edit.aspx.vb" Inherits="Dynamicweb.Admin.ItemPublisher_Edit" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.ItemPublisher" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.Management.Content.Nodes" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<dw:ModuleSettings ModuleSystemName="ItemPublisher" Value="ItemType, ListSourceType, ListSourceArea, ListSourcePage, SourceItemEntries, NamedListPageID, TargetNamedList, ListTemplate, ListPageSize, ItemFields, ItemFieldsList, ListOrderBy, ListOrderByDirection, ListSecondOrderBy, ListSecondOrderByDirection, ListViewMode, ListShowFrom, ListShowTo, AllowEditing, EditTemplate, DetailsTemplate, ValidationIncorrectFormat, ValidationEmptyField, IncludeParagraphItems, IncludeAllChildItems, IncludeInheritedItems, ShowSecurityItems, ItemRulesEditor_DataXML, ShowOnParagraph" runat="server" />
<dw:ModuleHeader ModuleSystemName="ItemPublisher" runat="server" />
<dw:ControlResources IncludeRequireJS="False" CombineOutput="True" runat="server">
    <Items>
        <dw:GenericResource Url="/Admin/Module/ItemPublisher/js/ItemPublisher_Edit.js" />
        <dw:GenericResource Url="/Admin/Link.js" />
        <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
        <dw:GenericResource Url="/Admin/Module/ItemPublisher/css/ItemPublisher_Edit.css" />
    </Items>
</dw:ControlResources>


<dw:GroupBox Title="Data" runat="server">
    <table class="formsTable">
        <tr>
            <td class="leftColHigh">
                <dw:TranslateLabel Text="Item type" runat="server" />
            </td>
            <td><%=RenderItemTypeSelector(Converter.ToString(Properties("ItemType")))%></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Select items from" runat="server" />
            </td>
            <td>
                <div class="radio-field clearfix">
                    <div class="radio">
                        <input type="radio" id="ListSourceArea" name="ListSourceType" value="Area" <%=If(String.Compare(Converter.ToString(Properties("ListSourceType")), "Area", StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                        <label for="ListSourceArea">
                            <dw:TranslateLabel Text="Select items from the following language/area" runat="server" />
                        </label>
                    </div>
                </div>
            </td>
        </tr>
        <tr class="list-source-type list-source-type-area">
            <td>&nbsp;</td>
            <td><%=RenderAreaSelector(Converter.ToInt32(Properties("ListSourceArea")))%></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <div class="radio-field clearfix">
                    <div class="radio">
                        <input type="radio" id="ListSourceCurrentArea" name="ListSourceType" value="SelfArea" <%=If(String.Compare(Converter.ToString(Properties("ListSourceType")), "SelfArea", StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                        <label for="ListSourceCurrentArea">
                            <dw:TranslateLabel Text="Select items from the current language/area" runat="server" />
                            &nbsp;(<dw:TranslateLabel Text="Current area: " runat="server" /><%=GetCurrentAreaName()%>)</label>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <div class="radio-field clearfix">
                    <div class="radio">
                        <input type="radio" id="ListSourceTypeSelfPage" name="ListSourceType" value="SelfPage" <%=If(String.Compare(Converter.ToString(Properties("ListSourceType")), "SelfPage", StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                        <label for="ListSourceTypeSelfPage">
                            <dw:TranslateLabel Text="Select items under the current page" runat="server" />
                            &nbsp;(<dw:TranslateLabel Text="Page name" runat="server" />:&nbsp;<%=GetCurrentPageName()%>)</label>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>

                <div class="radio-field clearfix">
                    <div class="radio">
                        <input type="radio" id="ListSourceTypePage" name="ListSourceType" value="Page" <%=If(String.Compare(Converter.ToString(Properties("ListSourceType")), "Page", StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                        <label for="ListSourceTypePage">
                            <dw:TranslateLabel Text="Select items under the following pages" runat="server" />
                        </label>
                    </div>
                </div>
            </td>
        </tr>
        <tr class="list-source-type list-source-type-page">
            <td>&nbsp;</td>
            <td>
                <table id="ListSourcePage_Control">
                    <tr>
                        <td class="list-source-type-page-content">
                            <ul class="std <%=If(String.Compare(Converter.ToString(Properties("ListSourceType")), "Page", StringComparison.InvariantCultureIgnoreCase) = 0, "enabled", String.Empty)%>"><%=RenderSourcePages()%></ul>
                        </td>
                        <td class="list-source-type-page-toolbar">
                            <ul>
                                <li>
                                    <a href="javascript:void(0);" data-action="select"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.FileO, True)%>"></i></a>
                                </li>
                                <li>
                                    <a href="javascript:void(0);" data-action="remove" class="last"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove, True)%>"></i></a>
                                </li>
                            </ul>
                        </td>
                    </tr>
                </table>
                <input type="hidden" id="ListSourcePage" name="ListSourcePage" value="<%=Properties.Value("ListSourcePage") %>" />
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <div class="radio-field clearfix">
                    <div class="radio">
                        <input type="radio" id="ListSourceTypeItemEntries" name="ListSourceType" value="ItemEntries" <%=If(String.Compare(Converter.ToString(Properties("ListSourceType")), "ItemEntries", StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                        <label for="ListSourceTypeItemEntries">
                            <dw:TranslateLabel Text="Select specific items" runat="server" />
                        </label>
                    </div>
                </div>
            </td>
        </tr>
        <tr class="list-source-type list-source-type-itementries">
            <td>&nbsp;</td>
            <td>
                <table id="SourceItemEntries_Control">
                    <tr>
                        <td class="list-source-type-itementries-content">
                            <ul class="std <%=If(String.Compare(Converter.ToString(Properties("ListSourceType")), "ItemEntries", StringComparison.InvariantCultureIgnoreCase) = 0, "enabled", String.Empty)%>"><%=RenderSourceItemEntries()%></ul>
                        </td>
                        <td class="list-source-type-itementries-toolbar">
                            <ul>
                                <li>
                                    <a href="javascript:void(0);" data-action="select" data-type="page"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.FileO, True)%>"></i></a>
                                </li>
                                <li>
                                    <a href="javascript:void(0);" data-action="select" data-type="paragraph"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.FileTextO, True)%>"></i></a>
                                </li>
                                <li>
                                    <a href="javascript:void(0);" data-action="remove" class="last"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove, True)%>"></i></a>
                                </li>
                            </ul>
                        </td>
                    </tr>
                </table>
                <input type="hidden" id="SourceItemEntries_Selector" />
                <input type="hidden" id="SourceItemEntries" name="SourceItemEntries" value="<%=Properties.Value("SourceItemEntries")%>" />
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <div class="radio-field clearfix">
                    <div class="radio">
                        <input type="radio" id="ListSourceTypeNamedList" name="ListSourceType" value="NamedList" <%=If(String.Compare(Converter.ToString(Properties("ListSourceType")), "NamedList", StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                        <label for="ListSourceTypeNamedList">
                            <dw:TranslateLabel Text="Named item list" runat="server" />
                        </label>
                    </div>
                </div>
            </td>
        </tr>
        <tr class="list-source-type list-source-type-namedlist">
            <td>&nbsp;</td>
            <td>
                <div class="link-manager clearfix">
                    <div id="NamedListPageID_Control">
                        <input type="text" id="NamedListPageIdText" class="std" readonly="readonly" /><a href="javascript:Dynamicweb.Items.ParagraphSettings.get_current().selectNamedListPage();" title="<%Translate.Translate("Select page")%>"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.FileO, True)%>"></i></a>
                        <input type="hidden" id="NamedListPageID" name="NamedListPageID" value="<%=Properties("NamedListPageID")%>" />
                    </div>
                </div>
                <select class="std" id="TargetNamedList" name="TargetNamedList">
                    <option value="<%=Properties("NamedItemList")%>"></option>
                </select>
            </td>
        </tr>
        <tr>
            <td />
            <td>
                <div id="IncludeParagraphItems_Control">
                    <dw:CheckBox runat="server" id="IncludeParagraphItems_View"></dw:CheckBox>
                    <input type="hidden" id="IncludeParagraphItems" name="IncludeParagraphItems" value="<%=Properties("IncludeParagraphItems")%>" />
                    <label for="IncludeParagraphItems_View">
                        <dw:TranslateLabel Text="Include paragraph items" runat="server" />
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <td />
            <td>
                <div id="IncludeAllChildItems_Control">
                    <dw:CheckBox runat="server" id="IncludeAllChildItems_View"></dw:CheckBox>
                    <input type="hidden" id="IncludeAllChildItems" name="IncludeAllChildItems" value="<%=Properties("IncludeAllChildItems") %>" />
                    <label for="IncludeAllChildItems_View">
                        <dw:TranslateLabel Text="Include all child itemss" runat="server" />
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <td />
            <td>
                <div id="IncludeInheritedItems_Control">
                    <dw:CheckBox runat="server" id="IncludeInheritedItems_View"></dw:CheckBox>
                    <input type="hidden" id="IncludeInheritedItems" name="IncludeInheritedItems" value="<%=Properties("IncludeInheritedItems")%>" />
                    <label for="IncludeInheritedItems_View">
                        <dw:TranslateLabel Text="Include inherited items" runat="server" />
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <td />
            <td>
                <div id="ShowSecurityItems_Control">
                    <dw:CheckBox runat="server" id="ShowSecurityItems_View"></dw:CheckBox>
                    <input type="hidden" id="ShowSecurityItems" name="ShowSecurityItems" value="<%=Properties("ShowSecurityItems") %>" />
                    <label for="ShowSecurityItems_View">
                        <dw:TranslateLabel Text="Allow to show items under security" runat="server" />
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <dw:TranslateLabel Text="Item fields - list" runat="server" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" id="ItemFieldsListAll" name="ItemFieldsList" value="*" <%=If(Converter.ToString(Properties("ItemFieldsList")).StartsWith("*"), " checked=""checked""", String.Empty)%> />
                    <label for="ItemFieldsListAll">
                        <dw:TranslateLabel Text="All" runat="server" />
                    </label>
                </div>
                <div class="radio">
                    <input type="radio" id="ItemFieldsListSelected" name="ItemFieldsList" value="<%=Properties("ItemFieldsList")%>" <%=If(Not Converter.ToString(Properties("ItemFieldsList")).StartsWith("*"), " checked=""checked""", String.Empty)%> />
                    <label for="ItemFieldsListSelected">
                        <dw:TranslateLabel Text="Selected" runat="server" />
                    </label>
                </div>
                <div id="ItemFieldsListSelectorWrapper">
                    <dw:SelectionBox runat="server" ID="ItemFieldsListSelector" Width="250" Height="110" ContentChanged="Dynamicweb.Items.ParagraphSettings.get_current().onItemFieldsListChange();" CssClass="std selection-box" LeftHeader="Deselected field(s)" RightHeader="Selected field(s)" NoDataTextLeft="Nothing selected" NoDataTextRight="Nothing selected" ShowSortRight="true" TranslateNoDataText="true" />
                </div>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <dw:TranslateLabel Text="Item fields - details" runat="server" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" id="ItemFieldsAll" name="ItemFields" value="*" <%=If(Converter.ToString(Properties("ItemFields")).StartsWith("*"), " checked=""checked""", String.Empty)%> />
                    <label for="ItemFieldsAll">
                        <dw:TranslateLabel Text="All" runat="server" />
                    </label>
                </div>
                <div class="radio">
                    <input type="radio" id="ItemFieldsSelected" name="ItemFields" value="<%=Properties("ItemFields")%>" <%=If(Not Converter.ToString(Properties("ItemFields")).StartsWith("*"), " checked=""checked""", String.Empty)%> />
                    <label for="ItemFieldsSelected">
                        <dw:TranslateLabel Text="Selected" runat="server" />
                    </label>
                </div>
                <div id="ItemFieldsSelectorWrapper">
                    <dw:SelectionBox runat="server" ID="ItemFieldsSelector" Width="250" Height="110" ContentChanged="Dynamicweb.Items.ParagraphSettings.get_current().onItemFieldsChange();" CssClass="std selection-box" LeftHeader="Deselected field(s)" RightHeader="Selected field(s)" NoDataTextLeft="Nothing selected" NoDataTextRight="Nothing selected" ShowSortRight="true" TranslateNoDataText="true" />
                </div>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox Title="List" ClassName="list-settings" runat="server">
    <table class="formsTable">
        <tr>
            <td class="leftColHigh">
                <dw:TranslateLabel Text="Template" runat="server" />
            </td>
            <td>
                <dw:FileManager ID="ListTemplate" Folder="Templates/ItemPublisher/List/" FullPath="True" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Order by" runat="server" />
            </td>
            <td>
                <select class="std" id="ListOrderBy" name="ListOrderBy" disabled="disabled">
                    <option value="">
                        <dw:TranslateLabel Text="No item fields found" runat="server" />
                    </option>
                </select>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <div class="radio">
                    <input type="radio" id="ListOrderByDirectionAscending" name="ListOrderByDirection" value="Ascending" <%=If(String.Compare(Converter.ToString(Properties("ListOrderByDirection")), "Ascending", StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                    <label for="ListOrderByDirectionAscending">
                        <dw:TranslateLabel Text="Asc" runat="server" />
                    </label>
                </div>
                <div class="radio">
                    <input type="radio" id="ListOrderByDirectionDescending" name="ListOrderByDirection" value="Descending" <%=If(String.Compare(Converter.ToString(Properties("ListOrderByDirection")), "Descending", StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                    <label for="ListOrderByDirectionDescending">
                        <dw:TranslateLabel Text="Desc" runat="server" />
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Second order by" runat="server" />
            </td>
            <td>
                <select class="std" id="ListSecondOrderBy" name="ListSecondOrderBy" disabled="disabled">
                    <option value="">
                        <dw:TranslateLabel Text="No item fields found" runat="server" />
                    </option>
                </select>

            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <div class="radio">
                    <input type="radio" id="ListSecondOrderByDirectionAscending" name="ListSecondOrderByDirection" value="Ascending" <%=If(String.Compare(Converter.ToString(Properties("ListSecondOrderByDirection")), "Ascending", StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                    <label for="ListSecondOrderByDirectionAscending">
                        <dw:TranslateLabel Text="Asc" runat="server" />
                    </label>
                </div>
                <div class="radio">
                    <input type="radio" id="ListSecondOrderByDirectionDescending" name="ListSecondOrderByDirection" value="Descending" <%=If(String.Compare(Converter.ToString(Properties("ListSecondOrderByDirection")), "Descending", StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                    <label for="ListSecondOrderByDirectionDescending">
                        <dw:TranslateLabel Text="Desc" runat="server" />
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="List view type" runat="server" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" id="ListViewTypePaging" name="ListViewMode" data-model="ListViewMode" value="<%=ItemPublisher.ListViewModes.Normal.ToString()%>" <%=If(String.Compare(Converter.ToString(Properties("ListViewMode")), Itempublisher.ListViewModes.Normal.ToString(), StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                    <label for="ListViewTypePaging">
                        <dw:TranslateLabel Text="Normal" runat="server" />
                    </label>
                </div>
                <div class="radio">
                    <input type="radio" id="ListViewTypePartial" name="ListViewMode" data-model="ListViewMode" value="<%=Itempublisher.ListViewModes.Partial.ToString() %>" <%=If(String.Compare(Converter.ToString(Properties("ListViewMode")), Itempublisher.ListViewModes.Partial.ToString(), StringComparison.InvariantCultureIgnoreCase) = 0, " checked=""checked""", String.Empty)%> />
                    <label for="ListViewTypePartial">
                        <dw:TranslateLabel Text="Partial" runat="server" />
                    </label>
                </div>
            </td>
        </tr>
    </table>

    <table class="formsTable list-view-selected-<%=Converter.ToString(Properties("ListViewMode")).ToLower() %>" data-view="ListViewMode" data-class="list-view-selected">
        <tr class="list-view-normal">
            <td class="leftColHigh">
                <dw:TranslateLabel Text="Page size" runat="server" />
            </td>
            <td>
                <input type="text" class="std" id="ListPageSize" name="ListPageSize" data-type="number" data-default-value="10" value="<%=Converter.ToInt32(Properties.Value("ListPageSize"))%>" />
            </td>
        </tr>
        <tr class="list-view-partial">
            <td class="leftColHigh">
                <dw:TranslateLabel Text="Item from" runat="server" />
            </td>
            <td>
                <input type="text" class="std" id="ListShowFrom" name="ListShowFrom" data-type="number" data-min-value="1" data-max-value="#ListShowTo" data-default-value="1" value="<%=Properties("ListShowFrom")%>" />
            </td>
        </tr>
        <tr class="list-view-partial">
            <td>
                <dw:TranslateLabel Text="Item to" runat="server" />
            </td>
            <td>
                <input type="text" class="std" id="ListShowTo" name="ListShowTo" data-type="number" data-min-value="#ListShowFrom" data-default-value="5" value="<%=Properties("ListShowTo")%>" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox Title="Details" runat="server">
    <table class="formsTable">
        <tr>
            <td class="leftColHigh">
                <dw:TranslateLabel Text="Template" runat="server" />
            </td>
            <td>
                <dw:FileManager ID="DetailsTemplate" Folder="Templates/ItemPublisher/Details/" FullPath="True" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="leftColHigh">
                <dw:TranslateLabel Text="Show on paragraph" runat="server" />
            </td>
            <td>
                <dw:LinkManager runat="server" id="ShowOnParagraph" EnablePageSelector="False" DisableFileArchive="True"></dw:LinkManager></td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox Title="Filtering" ClassName="filtering-settings" runat="server">
    <input type="hidden" id="ItemRulesEditor_DataXML" name="ItemRulesEditor_DataXML" />

    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Rules" runat="server" />
            </td>
            <td>
                <dw:RulesEditor ID="ItemRulesEditor" runat="server"></dw:RulesEditor>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Rules combination" runat="server" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" runat="server" id="RulesCombinationAnd" name="RulesCombination" value="AND" onchange="Dynamicweb.Items.ParagraphSettings.get_current().onRuleCombinationChanged(2);" />
                    <label for="RulesCombinationAnd">
                        <dw:TranslateLabel Text="AND" runat="server" />
                    </label>
                </div>
                <div class="radio">
                    <input type="radio" runat="server" id="RulesCombinationOr" name="RulesCombination" value="OR" onchange="Dynamicweb.Items.ParagraphSettings.get_current().onRuleCombinationChanged(1);" />
                    <label for="RulesCombinationAnd">
                        <dw:TranslateLabel Text="OR" runat="server" />
                    </label>
                </div>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox Title="Edit" runat="server">
    <table class="formsTable">
        <tr>
            <td class="leftColHigh">
                <dw:TranslateLabel Text="Access" runat="server" />
            </td>
            <td>
                <div class="checkbox-field clearfix">
                    <dw:CheckBox id="AllowEditing" name="AllowEditing" Checked="True" runat="server"></dw:CheckBox>
                    <label for="AllowEditing">
                        <dw:TranslateLabel Text="Allow editing of items" runat="server" />
                    </label>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Template" runat="server" />
            </td>
            <td>
                <dw:FileManager ID="EditTemplate" Folder="Templates/ItemPublisher/Edit" FullPath="True" runat="server" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<div id="errorMessages">
    <dw:GroupBox Title="Error messages" runat="server">
        <table class="formsTable">
            <tr>
                <td class="leftColHigh">
                    <dw:TranslateLabel Text="Incorrect format" runat="server" />
                </td>
                <td>
                    <input type="text" class="std" id="ValidationIncorrectFormat" name="ValidationIncorrectFormat" value="<%=Properties.Value("ValidationIncorrectFormat")%>" />
                </td>
            </tr>
            <tr>
                <td>
                    <dw:TranslateLabel Text="Empty field" runat="server" />
                </td>
                <td>
                    <input type="text" class="std" id="ValidationEmptyField" name="ValidationEmptyField" value="<%=Properties.Value("ValidationEmptyField")%>" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>

<script type="text/javascript">
    document.observe('dom:loaded', function () {
        var instance = Dynamicweb.Items.ParagraphSettings.get_current();
        instance.set_areaId(<%=Converter.ToInt32(Request("AreaID"))%>);
        instance.set_pageId(<%=Converter.ToInt32(Request("PageID"))%>);
        instance.set_paragraphId(<%=Converter.ToInt32(Request("ID"))%>);
        instance.set_pageTypes(<%=CType(ContentNodeType.Page Or ContentNodeType.PageFolder Or ContentNodeType.Item, Integer)%>),
        instance.set_translation('Error', '<%=Translate.Translate(InternalError)%>');
        instance.set_translation('Nothing', '<%=Translate.Translate("Nothing")%>');
        instance.set_expression(<%=ItemRulesEditor.ClientInstanceName%>);
        instance.initialize({
            namedListPage: <%=RenderPage(Converter.ToInt32(Properties("NamedListPageID")))%>,
            namedItemList: '<%=HttpUtility.JavaScriptStringEncode(Properties("TargetNamedList"))%>'
        });
    });
</script>
