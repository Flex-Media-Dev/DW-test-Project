<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="QueryEditor.ascx.vb" Inherits="Dynamicweb.Admin.Repositories.Controls.QueryEditor" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<%= AddInSelector_CodeProvider.Jscripts()%>

<style type="text/css">
    .w-30 {
        width: 30%;
    }
</style>

<div ng-show="usesContainsExtended()" class="ng-cloak">
    <dw:Infobar Type="Warning" Message="{{containsExtendedWarning}}" runat="server"></dw:Infobar>
</div>

<!--Name -->
<dwc:GroupBox ID="NameGroup" runat="server" Title="Indstillinger" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Name" runat="server" />
            </td>
            <td>
                <input type="text" class="std" ng-model="query.Name" />
            </td>
        </tr>
    </table>
</dwc:GroupBox>

<dwc:GroupBox ID="GroupBox1" runat="server" Title="Query" DoTranslation="true">
    <dwc:GroupBox ID="SourceGroupBox" runat="server" Title="Source" Expandable="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel Text="Source" runat="server" />
                </td>
                <td>
                    <select class="std" ng-change="updateDataModel();" ng-model="query.Source" ng-options="ds.Item group by ds.Repository for ds in datasources track by ds.Item">
                    </select>
                </td>
            </tr>
        </table>
    </dwc:GroupBox>
    <dwc:GroupBox ID="ParametersGroupBox" runat="server" Title="Parameters" Expandable="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel Text="Parameters" runat="server" />
                </td>
                <td>
                    <div class="items">
                        <ul>
                            <li class="header">
                                <span class="w-30"><%=Translate.Translate("Value")%></span>
                                <span class="w-30"><%=Translate.Translate("Type")%></span>
                                <span class="w-30"><%=Translate.Translate("Default Value")%></span>
                            </li>
                        </ul>

                        <ul id="items2">
                            <li class="item-field" ng-click="openParameterDialog(param);" ng-repeat="param in query.Parameters">
                                <span class="w-30">{{param.Name}}</span>
                                <span class="w-30">{{param.Type}}</span>
                                <span class="w-30">{{param.DefaultValue}}</span>
                                <span class="pull-right"><a class="btn" href="" ng-click="removeQueryParameter($index);" title="<%=Translate.Translate("Delete parameter") %>"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete)%>"></i></a></span>
                            </li>
                        </ul>
                    </div>

                    <div>
                        <button type="button" class="btn" runat="server" ng-click="openParameterDialog();"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i>&nbsp;<%=Translate.Translate("Add parameter")%></button>
                    </div>
                </td>
            </tr>
        </table>
    </dwc:GroupBox>
    <dwc:GroupBox ID="ExpressionsGroupBox" runat="server" Title="Expressions" Expandable="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel Text="Expressions" runat="server" />
                </td>
                <td>
                    <div class="main-content clearfix">
                        <div class="container" style="max-width:1000px;border: 1px solid #e0e0e0;">
                            <div ng-include="'Expression2.html'" ng-repeat="expr in [query.Expression]"></div>
                            <div ng-show="!haveExpressions()">
                                <button type="button" ng-click="addExpressionGroup();" class="btn"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i>&nbsp;<%=Translate.Translate("Add group")%></button>
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </dwc:GroupBox>
    <dwc:GroupBox ID="SortByGroupBox" runat="server" Title="Sort By" Expandable="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel Text="Sort By" runat="server" />
                </td>
                <td>
                    <div class="items">
                        <ul>
                            <li class="header">
                                <span class="C1" style="min-width: 300px"><%=Translate.Translate("Field")%></span>
                                <span class="C2"><%=Translate.Translate("Direction")%></span>
                            </li>
                        </ul>
                        <ul id="items1">
                            <li class="item-field" ng-click="openSortingDialog(sort);" ng-repeat="sort in query.SortOrder">
                                <span class="C1" style="min-width: 300px">{{getFieldName(sort.Field)}}</span>
                                <span class="C2">{{sort.SortDirection}}</span>
                                <span class="C4 pull-right"><a href="" class="btn" ng-click="removeSortingParameter($index);" title="<%=Translate.Translate("Delete sorting") %>"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete)%>"></i></a></span>
                            </li>
                        </ul>
                    </div>

                    <div>
                        <button type="button" class="btn" runat="server" ng-click="openSortingDialog();"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i>&nbsp;<%=Translate.Translate("Add sorting")%></button>
                    </div>
                </td>
            </tr>
        </table>
    </dwc:GroupBox>
</dwc:GroupBox>

<script type="text/ng-template" id="GroupExpression.html">
    AND
    <div>
    <ul>
        <li ng-include="'Expression.html'" ng-repeat="expr in expr.Expressions"></li>
    </ul>
    </div>
</script>

<script type="text/ng-template" id="Expression2.html">

        <table class="expression" ng-if="expr.class == 'GroupExpression'" border="0" width="100%" cellpadding="0" cellspacing="0">
            <tr class="expressionrow">
                <td valign="bottom" class="row-margin row-top"><div></div></td>
                <td class="row-content">
    			    <span>
                        <select class="std connector" ng-model="expr.Operator">
                            <option value="And"><%=Translate.Translate("And")%></option>
                            <option value="Or"><%=Translate.Translate("Or")%></option>
                        </select>
	    		    </span>
                    <span class="negate-check">
                        <input type="checkbox" id="{{expr.$$hashKey + $index}}" class="checkbox" ng-model="expr.Negate" />
                        <label for="{{expr.$$hashKey + $index}}"><%=Translate.Translate("Negate")%></label>
                    </span>
                    <span class="pull-right">
                        <a href="" class="btn" ng-click="deleteExpressionGroup($parent, $index);" title="<%=Translate.Translate("Delete expression") %>"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete)%>"></i></a>
                    </span>
                </td>
            </tr>
            <tr ng-repeat="expr in expr.Expressions" class="expressionrow">
                <td class="row-margin row-center"><div></div></td>
                <td ng-include="'Expression2.html'" draggable="true" ng-dragstart="sortExpressionsDragStart($event, expr, $parent);" ng-dragover="sortExpressionsDragOver($event, expr);" ng-drop="sortExpressionsDrop($event, expr);"></td>
            </tr>
            <tr>
                <td valign="top" class="row-margin row-bottom"><div></div></td>
                <td class="row-buttons">
                    <button type="button" ng-click="addExpression(expr)" class="btn"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i>&nbsp;<%=Translate.Translate("Add expression")%></button>
					<button type="button" ng-click="addExpressionGroup(expr);" class="btn"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i>&nbsp;<%=Translate.Translate("Add group")%></button>
               </td>
            </tr>
        </table>

		<div ng-if="expr && expr.class != 'GroupExpression'">
			<span ng-class="{'element-disabled': expr.Disabled}">
                <select class="std fieldname" ng-model="expr.Left.Field" ng-options="field.SystemName as (field.Name + ' (' + field.Type + ')') group by field.Group for field in model.Fields  | orderBy:['Group','Name']" ng-disabled="expr.Disabled">
                </select>
            </span>
            <span ng-class="{'element-disabled': expr.Disabled}">
				<select class="std operator" ng-model="expr.Operator" ng-options="operator as operator for operator in getFieldBySystemName(expr.Left.Field).OperatorTypes" ng-disabled="expr.Disabled"></select>
            </span>
            <span ng-class="{'element-disabled': expr.Disabled}">
                <div class="input-group termSelectWrap">
                    <input class="std value" ng-disabled="expr.Operator == 'IsEmpty'" ng-model="expr.Right.DisplayValue" ng-change="setValue(expr)" placeholder="Value" ng-if="showTextBox(expr)"/>
				    <input class="std value" disabled="disabled" ng-model="expr.Right.VariableName" placeholder="Value" ng-if="expr.Right.class == 'ParameterExpression'" />
				    <input class="std value" disabled="disabled" ng-model="expr.Right.LookupString" placeholder="VariableName" ng-if="expr.Right.class == 'MacroExpression'" />
                    <div class="std termSelect" ng-click="toggleTermSelector(expr, $event)" ng-if="(showTermSelector(expr))" >
                        <input ng-model="expr.Right.DisplayValue" ng-change="setTerms(getFieldBySystemName(expr.Left.Field))" type="text" style="border-style: none; height: 22px" Class="std" disabled />
                    </div>
                    <button type="button" class="input-group-addon" ng-click="editExpression(expr);" ng-if="expr.Operator != 'IsEmpty'" ng-disabled="expr.Disabled"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Pencil)%>"></i></button>
                    <div id="termDropDown" class="std termSelect-options termSelect-options-hidden">
                        <dw:Overlay ID="wait" runat="server" ShowWaitAnimation="True"></dw:Overlay>
                        <table>
                            <tr>
                            <th class="checkBoxColumn"></th>
                                <th class="termHeader" ng-click="sortBy('Value')" ng-class="{'sorting-desc': propertyName == 'Value' && reverse, 'sorting-asc': propertyName == 'Value' && !reverse}"><%=Translate.JsTranslate("Term")%></th>
                                <th class="termHeader" ng-click="sortBy('Occurrences')" ng-class="{'sorting-desc': propertyName == 'Occurrences' && reverse, 'sorting-asc': propertyName == 'Occurrences' && !reverse}"><%=Translate.JsTranslate("Occurrences")%></th>
                            </tr>
                            <tr ng-repeat="term in expr.Terms.Terms | orderBy:propertyName:reverse" class="termSelect-option"> 
                                <td class="checkBoxColumn">
                                    <input type="checkbox" class="checkbox" ng-attr-id="{{expr.$$hashKey + '-' + $index}}" ng-model="term.selected" ng-change="selectTerm(getFieldBySystemName(expr.Left.Field), expr, term)" style="margin: 5px"/>
                                    <label for="{{expr.$$hashKey + '-' + $index}}"></label>
                                </td>
                                <td>
                                    <label for="{{expr.$$hashKey + '-' + $index}}">{{term.Value}}</label>
                                </td>
                                <td>
                                    <label for="{{expr.$$hashKey + '-' + $index}}">{{term.Occurrences}}</label>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
			</span>
            <span class="pull-right">
                <a class="btn" href="javascript:void(0);" ng-click="toggleExpression(expr);" ng-attr-title="{{expr.Disabled ? '<%=Translate.Translate("Enable expression") %>' : '<%=Translate.Translate("Disable expression") %>'}}">
                    <i ng-class="{'<%=KnownIconInfo.ClassNameFor(KnownIcon.Close) %>': expr.Disabled, '<%=KnownIconInfo.ClassNameFor(KnownIcon.Check) %>': !expr.Disabled}" ng-style="{'color': (expr.Disabled ? 'red' : 'green')}"></i>
                </a>
                <a class="btn" href="" ng-click="deleteExpression($parent, $index);" title="<%=Translate.Translate("Delete expression") %>"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete)%>"></i></a>
            </span>
    	</div>

</script>

<script type="text/ng-template" id="BinaryExpression.html">
    <div style="float:clear">
        <ng-include src="'Expression.html'" ng-repeat="expr in [expr.Left]"></ng-include>
        <select class="std" ng-model="">
            <option>{{expr.Field}}</option>
        </select>
        <ng-include src="'Expression.html'" ng-repeat="expr in [expr.Right]"></ng-include>
    </div>
</script>

<script type="text/ng-template" id="FieldExpression.html">
    <span>
        <select class="std" ng-model="expr.Field" ng-options="field.SystemName as field.Name for field in model.Fields">
        </select>
    </span>
</script>

<script type="text/ng-template" id="ParameterExpression.html">
    <span>{{expr.VariableName}}</span>
</script>

<script type="text/ng-template" id="ConstantExpression.html">
    <input type="text" ng-model="expr.DisplayValue" />
</script>

<script type="text/ng-template" id="MacroExpression.html">
    {{expr.LookupString}}
</script>

<script type="text/ng-template" id="EditConstantExpression.html">
    <table class="formsTable">
    <tr>
        <td><%=Translate.Translate("Type")%></td>
        <td>
            <select class="std" ng-model="rightExpressionDraft.Type">
                <option value="System.String">System.String</option>
                <option value="System.Boolean">System.Boolean</option>
                <option value="System.Decimal">System.Decimal</option>
                <option value="System.Single">System.Single</option>
                <option value="System.Double">System.Double</option>
                <option value="System.Int16">System.Int16</option>
                <option value="System.Int32">System.Int32</option>
                <option value="System.Int64">System.Int64</option>
                <option value="System.DateTime">System.DateTime</option>
                <option value="System.String[]">System.String[]</option>
                <option value="System.Boolean[]">System.Boolean[]</option>
                <option value="System.Decimal[]">System.Decimal[]</option>              
                <option value="System.Single[]">System.Single[]</option>
                <option value="System.Double[]">System.Double[]</option>
                <option value="System.Int16[]">System.Int16[]</option>
                <option value="System.Int32[]">System.Int32[]</option>
                <option value="System.Int64[]">System.Int64[]</option>         
                <option value="System.DateTime[]">System.DateTime[]</option>
            </select>
        </td>
    </tr> 
    <tr>
        <td><label><%=Translate.Translate("Value")%></label></td>
        <td>
            <input ng-model="rightExpressionDraft.DisplayValue" type="text" class="std" />
        </td>
    </tr>
    </table>
</script>

<script type="text/ng-template" id="EditParameterExpression.html">
    <table class="formsTable">
    <tr>
        <td><label><%=Translate.Translate("Parameter")%></label></td>
        <td>
            <select class="std" ng-model="rightExpressionDraft.VariableName" ng-options="param.Name as param.Name for param in query.Parameters">
            </select>
        </td>
    </tr>
    </table>
</script>

<script type="text/ng-template" id="EditMacroExpression.html">
    <table class="formsTable">
    <tr>
        <td><label><%=Translate.Translate("Macros")%></label></td>
        <td>
            <select class="std" ng-model="rightExpressionDraft.LookupString" ng-options="ds.original as ds.name group by ds.namespace for ds in supportedActions">
            </select>
        </td>
    </tr>
    </table>
</script>

<script type="text/ng-template" id="EditTermExpression.html">
    <table class="formsTable">
    <tr>
        <td><label><%=Translate.Translate("Value")%></label></td>
        <td>
            <div class="std termSelect" ng-click="toggleTermSelector(rightExpressionDraft, $event)">
                <input ng-model="rightExpressionDraft.DisplayValue" type="text" style="border-style: none; height: 22px" class="std" disabled />
            </div>
            <div id="termDropDown" class="std termSelect-options termSelect-options-hidden" >
                <dw:Overlay ID="dialogWait" runat="server" ShowWaitAnimation="True"></dw:Overlay>
                    <table>
                        <tr>
                            <th class="checkBoxColumn"></th>
                            <th class="termHeader" ng-click="sortBy('Value')" ng-class="{'sorting-desc': propertyName == 'Value' && reverse, 'sorting-asc': propertyName == 'Value' && !reverse}"><%=Translate.JsTranslate("Term")%></th>
                            <th class="termHeader" ng-click="sortBy('Occurrences')" ng-class="{'sorting-desc': propertyName == 'Occurrences' && reverse, 'sorting-asc': propertyName == 'Occurrences' && !reverse}"><%=Translate.JsTranslate("Occurrences")%></th>
                        </tr>
                        <tr ng-repeat="term in rightExpressionDraft.Terms.Terms | orderBy:propertyName:reverse" class="termSelect-option"> 
                            <td class="checkBoxColumn">
                                <input type="checkbox" class="checkbox" ng-attr-id="{{'t' + $index}}" ng-model="term.selected" ng-change="selectTerm(getFieldBySystemName(expr.Left ? expr.Left.Field : expr.Terms.Field), rightExpressionDraft, rightExpressionDraft.Terms.Terms[$index])" style="margin: 5px"/>
                                <label for="{{'t' + $index}}"></label>
                            </td>
                            <td>
                                <label for="{{'t' + $index}}">{{term.Value}}</label>
                            </td>
                            <td>
                                <label for="{{'t' + $index}}">{{term.Occurrences}}</label>
                            </td>
                         </tr>
                    </table>
            </div>
        </td>
    </tr>
    </table>
</script>

<script type="text/ng-template" id="EditCodeExpression.html">

    <table class="formsTable">
    <tr>
    <td colspan="2">
        <div ng-bind-html="Editor" compile-template></div>
    </td>
    </tr>
    <tr>
        <td colspan="2"><de:AddInSelector ClientID="test" ID="AddInSelector_CodeProvider" UseLabelAsName="True" AddInTypeName="Dynamicweb.Extensibility.CodeProviderBase, Dynamicweb" runat="server" ></de:AddInSelector></td>
        <asp:Literal ID="AddinSelectorLoadScripts" runat="server"></asp:Literal>
    </tr>
    </table>
</script>



<dwc:GroupBox ID="DisplayFieldsGroup" runat="server" Title="Edit view mode" DoTranslation="true">
    <dw:Infobar Type="Information" Message="Here you can configure which fields and languages, that will be displayed in the PIM Multi edit view" runat="server"></dw:Infobar>
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Field display groups" runat="server" />
            </td>
            <td>                
                <select name="PresetSelector" class="std" ng-change="changePreset();" ng-options="preset.Name for preset in presets" ng-model="model.selectedPreset" ></select>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Fields" runat="server" />
            </td>
            <td>
                <dw:SelectionBox ID="ViewFieldList" runat="server" LeftHeader="Excluded fields" RightHeader="Included fields" ShowSortRight="true" ShowSearchBox="true" Height="400"></dw:SelectionBox>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Languages" runat="server" />
            </td>
            <td>
                <dw:SelectionBox ID="ViewLanguagesList" runat="server" LeftHeader="Excluded languages" RightHeader="Included languages" ShowSortRight="true" NoDataTextRight="All languages"></dw:SelectionBox>
            </td>
        </tr>
    </table>
</dwc:GroupBox>

<dwc:GroupBox ID="ListViewFieldsGroup" runat="server" Title="List view mode" DoTranslation="true">
    <dw:Infobar Type="Information" Message="Here you can configure which fields will be displayed in ListView" runat="server"></dw:Infobar>
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Fields" runat="server" />
            </td>
            <td>
                <dw:SelectionBox ID="ListViewFieldList" runat="server" LeftHeader="Excluded fields" RightHeader="Included fields" ShowSortRight="true" ShowSearchBox="true" Height="400"></dw:SelectionBox>
            </td>
        </tr>
    </table>
</dwc:GroupBox>

<dwc:GroupBox ID="CompletionGroup" runat="server" Title="Edit completion rules" DoTranslation="true">
    <dw:Infobar Type="Information" Message="Here you can configure which fields and languages, that will be used in the calculation of completion status" runat="server"></dw:Infobar>
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel Text="Include completeness-based expressions to the query" runat="server" />
            </td>
            <td>
                <dwc:CheckBox runat="server" ID="AppendCompletionExpessions" Indent="false"/>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Rules" runat="server" />
            </td>
            <td>
                <dw:SelectionBox ID="CompletionRules" runat="server" LeftHeader="Excluded rules" RightHeader="Included rules" ShowSortRight="true" ShowSearchBox="true" Height="400"></dw:SelectionBox>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel Text="Languages" runat="server" />
            </td>
            <td>
                <dw:SelectionBox ID="CompletionLanguages" runat="server" LeftHeader="Excluded languages" RightHeader="Included languages" ShowSortRight="true" NoDataTextRight="All languages"></dw:SelectionBox>
            </td>
        </tr>
    </table
</dwc:GroupBox>

<dwc:GroupBox ID="GroupingGroup" runat="server" Title="Grouping" DoTranslation="true">
</dwc:GroupBox>

<dwc:GroupBox ID="ProjectionGroup" runat="server" Title="Projection" DoTranslation="true">
</dwc:GroupBox>

