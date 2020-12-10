<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewQuery.aspx.vb" Inherits="Dynamicweb.Admin.Repositories.ViewQuery" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="rp" TagName="QueryEditor" Src="~/Admin/Module/Repositories/Controls/QueryEditor.ascx" %>
<%@ Register TagPrefix="rp" TagName="Infobar" Src="~/Admin/Module/Repositories/Controls/Infobar.ascx" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" ng-app="app">
<head runat="server">
    <title></title>
    <dw:ControlResources IncludePrototype="true" IncludeRequireJS="false" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/vendors/slim-select/slimselect.min.css" />
            <dw:GenericResource Url="/Admin/Resources/vendors/slim-select/slimselect.min.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwselector.js"/>
        </Items>
    </dw:ControlResources>

    <!-- Controls resources start -->
    <link rel="stylesheet" type="text/css" href="/Admin/Content/Items/css/Default.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Content/Items/css/ItemTypeEdit.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Content/Items/css/LanguageSelector.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Module/Repositories/Styles/Repository.css?v=<%=System.IO.File.GetLastWriteTime(Server.MapPath("/Admin/Module/Repositories/Styles/Repository.css")).Ticks %>" />

    <!-- Controls resources end -->
    <link rel="stylesheet" type="text/css" href="/Admin/Images/Ribbon/UI/Dialog/Tabular/Dialog.css" />

</head>
<body class="area-black screen-container">

    <script type="text/javascript" src="/Admin/Content/jsLib/Angular/angular.min.js"></script>
    <script type="text/javascript" src="/Admin/Module/Repositories/Scripts/DragDropDirectives.js"></script>

    <script type="text/javascript">
        function help() {
		    <%=Gui.HelpPopup("repositories", "modules.repositories.query")%>
        }

        var repositoryclean = '<%=Request("Repository")%>';
        var calledFrom = '<%=Request("calledFrom")%>';

        if (calledFrom == "") {
            calledFrom = "undefined";
        }
        var repository = '<%=Request("Repository").Replace(".", "-")%>';
        var item = '<%=Request("Item").Replace(".", "-")%>';
        var app = angular.module('app', ['ngDrag']);
        app.location = [{}];
        _invalidQueryNameSymbols = <%= GetInvalidQueryNameSymbols() %>;
        var invalidQueryNameSymbolsLabel = "'" + _invalidQueryNameSymbols.join("\x00").replace(/[^\x20-\x7E]+/g, '') + "'"; // remove non printable
        var _messages = {
            saveQueryWithWrongExpression: '<%=Translate.JsTranslate("Please fill all parts of the expression")%>',
            invalidQueryName: "<%=Translate.JsTranslate("Only use valid characters in query name. Symbols %% are invalid.")%>".replace("%%",  invalidQueryNameSymbolsLabel)
        };        
        
        <% If Converter.ToBoolean(Dynamicweb.Context.Current.Request("NavigatorSync")) Then
            Dim ancestors As IEnumerable(Of String) = GetAncestorsNodeIds()
            Dim ancestorsToForceReload As IEnumerable(Of String) = ancestors.Take(1)
        %>
        
        dwGlobal.getPimNavigator().expandAncestors(<%= Converter.SerializeCompact(ancestors) %>, <%= Converter.SerializeCompact(ancestorsToForceReload) %>);
        <% End If %>
        
        function save() {
            angular.element(document.forms[0]).scope().setQuery();
            var __o = new overlay('__ribbonOverlay');
            __o.show();
            setTimeout("document.getElementById('__ribbonOverlay').style.display = 'none';", <%=cmdSave.WaitTimeout%>)
        }
        <%= Dynamicweb.Controls.KeyboardShortcutManager.CreateKeyboardShortcutObserver("ctrl+s", "save()") %>
    </script>

    <script type="text/javascript" src="/Admin/Module/Repositories/Scripts/QueryRepository.js?v=<%=System.IO.File.GetLastWriteTime(Server.MapPath("/Admin/Module/Repositories/Scripts/QueryRepository.js")).Ticks %>"></script>
    <script type="text/javascript" src="/Admin/Module/Repositories/Scripts/QueryController.js?v=<%=System.IO.File.GetLastWriteTime(Server.MapPath("/Admin/Module/Repositories/Scripts/QueryController.js")).Ticks %>"></script>
    <script type="text/javascript" src="/Admin/Resources/js/layout/dwglobal.js"></script>

    <form id="MainForm" name="MainForm" runat="server" ng-submit="setIndex()" ng-controller="queryController">
        <input type="hidden" ng-init="init('<%=Convert.ToBase64String(Encoding.Default.GetBytes(Dynamicweb.Content.Management.Installation.Checksum()))%>')" />

        <div class="card">
            <dw:RibbonBar runat="server" ID="myribbon">
                <dw:RibbonBarTab Active="true" Name="Query" runat="server">
                    <dw:RibbonBarGroup runat="server" ID="grpTools" Name="Funktioner">
                        <dw:RibbonBarButton runat="server" Text="Save" Size="Small" Icon="Save" ID="cmdSave" NgClick="setQuery();" ShowWait="true" WaitTimeout="500"></dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Save and close" Size="Small" Icon="Save" ID="cmdSaveAndClose" NgClick="setQueryAndExit()" ShowWait="true" WaitTimeout="500"></dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Cancel" Size="Small" Icon="Cancel" ID="cmdCancel" NgClick="onCancel()" ShowWait="false" WaitTimeout="500">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" ID="RibbonbarGroup2" Name="Settings">
                        <dw:RibbonBarButton runat="server" Text="Source index" Size="Small" Icon="Book" NgClick="openSourceDialog()"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="RibbonbarButton1" runat="server" Size="Large" Text="Help" Icon="Help" OnClientClick="help();"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <div id="breadcrumb" runat="server">
                <a href="/Admin/Blank.aspx"><%=Translate.Translate("Management")%></a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="#"><%=Translate.Translate("Repositories")%></a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="/Admin/Module/Repositories/ViewRepository.aspx?id=<%=Request("Repository")%>"><%=Request("Repository")%></a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="#"><b><%=Request("Item")%></b></a>
            </div>


            <!-- LIST -->
            <div class="list" ng-if="!preview">
                <div id="_contentWrapper">
                    <rp:QueryEditor ID="QueryEditor" runat="server"></rp:QueryEditor>
                </div>
            </div>
        </div>

        <rp:Infobar runat="server" Model="query" Name="{{query.Name}}" Type="Query" FileName="{{query.FileName}}"></rp:Infobar>

        <dw:Dialog ID="ParameterDialog" Title="Parameter" Size="Small" ShowClose="true" ShowOkButton="true" ShowCancelButton="True" OkAction="document.getElementById('okParameterDialog').click();" runat="server">
            <button style="display: none;" id="okParameterDialog" type="button" class="btn dialog-button-ok" ng-click="saveParameterDialog();">OK</button>
            <dwc:GroupBox ID="GroupBox10" runat="server">
                <table class="formsTable">
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Name" runat="server" />
                        </td>
                        <td>
                            <input ng-model="draftParam.Name" type="text" class="std" /></td>
                    </tr>
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Type" runat="server" />
                        </td>
                        <td>
                            <select class="std" ng-model="draftParam.Type">
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
                        <td class="left-label">
                            <dw:TranslateLabel Text="Default value" runat="server" />
                        </td>
                        <td>
                            <input ng-model="draftParam.DefaultValue" type="text" class="std" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </dw:Dialog>

        <dw:Dialog ID="SortOrderDialog" Title="Sort By" Size="Medium" ShowClose="true" ShowOkButton="true" ShowCancelButton="True" OkAction="document.getElementById('okSortingDialog').click();" runat="server">
            <button style="display: none;" id="okSortingDialog" type="button" class="btn dialog-button-ok" ng-click="saveSortingDialog();">OK</button>
            <dwc:GroupBox ID="GroupBox1" runat="server">
                <table class="formsTable">
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Field" runat="server" />
                        </td>
                        <td>
                            <select class="std" ng-model="draftSort.Field" ng-options="field.SystemName as field.Name group by field.Group for field in model.SortFields | orderBy:['Group','Name']">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Direction" runat="server" />
                        </td>
                        <td>
                            <select class="std" ng-model="draftSort.SortDirection">
                                <option value="Descending"><%=Translate.Translate("Descending")%></option>
                                <option value="Ascending"><%=Translate.Translate("Ascending")%></option>
                            </select>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </dw:Dialog>

        <dw:Dialog ID="EditExpressionDialog" Title="Edit expression" Size="Medium" ShowClose="true" ShowOkButton="true" ShowCancelButton="True" OkAction="document.getElementById('okEditExpressionDialog').click();" runat="server">
            <button style="display: none;" id="okEditExpressionDialog" type="button" class="btn dialog-button-ok" ng-click="saveEditExpressionDialog();">OK</button>
            <dwc:GroupBox ID="GroupBox2" runat="server">
                <div>
                    <table class="formsTable">
                        <tr>
                            <td class="left-label">
                                <dw:TranslateLabel Text="Right expression" runat="server" />
                            </td>
                            <td>
                                <select class="std" ng-model="rightExpressionDraft.class">
                                    <option value="ConstantExpression"><%=Translate.Translate("Constant")%></option>
                                    <option value="ParameterExpression"><%=Translate.Translate("Parameter")%></option>
                                    <option value="MacroExpression"><%=Translate.Translate("Macro")%></option>
                                    <option value="TermExpression"><%=Translate.Translate("Term") %></option>
                                    <option value="CodeExpression"><%=Translate.Translate("Code")%></option>
                                </select>
                            </td>
                        </tr>
                    </table>
                </div>
                <div ng-if="rightExpressionDraft.class == 'ConstantExpression'">
                    <div ng-include="'EditConstantExpression.html'"></div>
                </div>
                <div ng-if="rightExpressionDraft.class == 'ParameterExpression'">
                    <div ng-include="'EditParameterExpression.html'"></div>
                </div>
                <div ng-if="rightExpressionDraft.class == 'MacroExpression'">
                    <div ng-include="'EditMacroExpression.html'"></div>
                </div>
                <div ng-if="rightExpressionDraft.class == 'TermExpression'">
                    <div ng-include="'EditTermExpression.html'"></div>
                </div>
                <div ng-if="rightExpressionDraft.class == 'CodeExpression'">
                    <div ng-include="'EditCodeExpression.html'"></div>
                </div>
            </dwc:GroupBox>
        </dw:Dialog>

        <dw:Dialog ID="SourceDialog" Title="Source" Size="Medium" ShowClose="true" ShowOkButton="true" ShowCancelButton="True" OkAction="document.getElementById('okSourceDialog').click();" runat="server">
            <button style="display: none;" id="okSourceDialog" type="button" class="btn dialog-button-ok" ng-click="saveSourceDialog();">OK</button>
            <dwc:GroupBox ID="GroupBox3" runat="server">
                <table class="formsTable">
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Query" runat="server" />
                        </td>
                        <td>
                            <select class="std" ng-change="updateDataModel();" ng-model="query.Source" ng-options="ds.Item group by ds.Repository for ds in datasources track by ds.Item">
                            </select>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </dw:Dialog>

    </form>

    <dw:Overlay ID="ItemTypeEditOverlay" runat="server"></dw:Overlay>

    <!-- Controls resources start -->
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/Ribbon.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Dialog/Dialog.js"></script>
    <script type="text/javascript" src="/Admin/Filemanager/Upload/js/EventsManager.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Ajax.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Observable.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/require.js"></script>
    <script type="text/javascript" src="/Admin/Content/Items/js/Default.js"></script>
    <script type="text/javascript" src="/Admin/Content/Items/js/ItemTypeEdit.js"></script>
    <!-- Controls resources end -->

    <%Translate.GetEditOnlineScript()%>

    <script type="text/javascript">
        Dynamicweb.Ajax.ControlManager.get_current().initialize();
    </script>

</body>
</html>
