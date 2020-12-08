<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="QueryPublisher_edit.aspx.vb" Inherits="Dynamicweb.Admin.QueryPublisher.QueryPublisher_edit" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
    <Items>
        <dw:GenericResource Url="/Admin/Module/QueryPublisher/queryPublisher.js" />
    </Items>
</dw:ControlResources>

<dw:ModuleHeader ID="headerModule" runat="server" ModuleSystemName="QueryPublisher" />
<input type="hidden" name="QueryPublisher_settings" value="Query,Facets,Template,PageSize,ShowFacetOptionsWithNoResults,QueryConditions,QuerySortByParams,FieldToSpellCheck,ParameterToSpellCheck,TrackQueries" />

<dw:GroupBox ID="grpQuerySelector" Title="Queries" runat="server">
    <table class="formsTable">
        <tr>
            <td><%= Translate.Translate("Query")%></td>
            <td>
                <select id="ddlQuerySelect" name="Query" class="std" onchange="backend.indexQueryChanged();">
                    <asp:literal id="litQueryOptions" runat="server"></asp:literal>
                </select>
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
            <td><%= Translate.Translate("Facets")%></td>
            <td id="selectionBoxContainer">
                <dw:SelectionBox runat="server"
                    ID="selectFacets" />
            </td>
            <input type="hidden" id="facets" name="Facets" value="" />
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
                    <span onclick="backend.loadDefaultQueryParameters()" class="btn restore">
                        <%=Translate.Translate("Reset")%>
                    </span>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Sort by" />
            </td>
            <td>
                <dw:EditableList ID="QuerySortByParams" runat="server" AllowPaging="true" AllowSorting="false" AutoGenerateColumns="false" EnableLegacyRendering="True" AllowAddNewRow="True" AllowDeleteRow="True">
                </dw:EditableList>
                <div style="text-align: right">
                    <span onclick="backend.loadDefaultQuerySortBy()" class="btn restore">
                        <%=Translate.Translate("Reset")%>
                    </span>
                </div>
            </td>
        </tr>
        <tr>
            <td><%=Translate.Translate("Items per page")%></td>
            <td>
                <input type="text" runat="server" id="PageSize" name="PageSize" value="0" class="std" style="width: 50px;" />
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

<dw:GroupBox ID="grpTemplateSelector" Title="Template" runat="server">
    <table class="formsTable">
        <tr>
            <td><%= Translate.Translate("Template")%></td>
            <td>
                <dw:FileManager ID="Template" Folder="/Templates/QueryPublisher" FullPath="True" runat="server" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<script type="text/javascript">

    backend.initialisation();

</script>
