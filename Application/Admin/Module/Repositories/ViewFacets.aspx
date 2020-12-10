<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewFacets.aspx.vb" Inherits="Dynamicweb.Admin.Repositories.ViewFacets" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="rp" TagName="Infobar" Src="~/Admin/Module/Repositories/Controls/Infobar.ascx" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Content.Management" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" ng-app="app">
<head runat="server">
    <title></title>
    <dw:ControlResources IncludePrototype="true" runat="server"></dw:ControlResources>

    <!-- Controls resources start -->
    <link rel="stylesheet" type="text/css" href="/Admin/Content/Items/css/Default.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Content/Items/css/ItemTypeEdit.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Content/Items/css/LanguageSelector.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Module/Repositories/Styles/Repository.css" />
    <!-- Controls resources end -->

    <style type="text/css">
        .w-10 {
            width: 10%;
        }

        .item-field .std {
            padding: 0 4px;
            font-size: 12px;
            width: 130px !important;
        }

        .termIcon{
            float: right !important;
            padding-top: 11px;
        }
    </style>
</head>
<body class="area-black screen-container">

    <script type="text/javascript" src="/Admin/Content/jsLib/Angular/angular.min.js"></script>
    <script type="text/javascript" src="/Admin/Module/Repositories/Scripts/DragDropDirectives.js"></script>

    <script type="text/javascript">
        var repositoryclean = '<%=Request("Repository")%>';
        var repository = '<%=Request("Repository").Replace(".","-")%>';
        var item = '<%=Request("Item").Replace(".","-")%>';
        var app = angular.module('app', ['ngDrag']);
        app.location = [{}];

        function save() {
            angular.element(document.forms[0]).scope().setFacets();
            var __o = new overlay('__ribbonOverlay');
            __o.show();
            setTimeout("document.getElementById('__ribbonOverlay').style.display = 'none';", <%=cmdSave.WaitTimeout%>)
        }
        <%= Dynamicweb.Controls.KeyboardShortcutManager.CreateKeyboardShortcutObserver("ctrl+s", "save()") %>
    </script>

    <script type="text/javascript" src="/Admin/Module/Repositories/Scripts/FacetsRepository.js?v=1"></script>
    <script type="text/javascript" src="/Admin/Module/Repositories/Scripts/FacetsController.js?v=1"></script>

    <form id="MainForm" onsubmit="" runat="server" ng-controller="facetsController" style="margin: 0px">
        <div class="card" ng-init="init('<%=Convert.ToBase64String(Encoding.Default.GetBytes(Installation.Checksum()))%>')">

            <dw:RibbonBar runat="server" ID="myribbon">
                <dw:RibbonBarTab Active="true" Name="Facets" runat="server">
                    <dw:RibbonBarGroup runat="server" ID="grpTools" Name="Funktioner">
                        <dw:RibbonBarButton runat="server" Text="Save" Size="Small" Icon="Save" ID="cmdSave" NgClick="setFacets();" ShowWait="true" WaitTimeout="500"></dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Save and close" Size="Small" Icon="Save" ID="cmdSaveAndClose" NgClick="setFacetsAndExit()" ShowWait="true" WaitTimeout="500"></dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Cancel" Size="Small" Icon="Cancel" ID="cmdCancel" OnClientClick="document.location.href = '/Admin/Module/Repositories/ViewRepository.aspx?id='+repositoryclean" ShowWait="false" WaitTimeout="500">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="RibbonbarButton1" runat="server" Size="Large" Text="Help" Icon="Help" OnClientClick="window.open('http://manual.net.dynamicweb.dk/Default.aspx?ID=1&m=keywordfinder&keyword=administration.managementcenter.Repositories.Facets&LanguageID=en', 'dw_help_window', 'location=no,directories=no,menubar=no,toolbar=yes,top=0,width=1024,height=' + (screen.availHeight-100) + ',resizable=yes,scrollbars=yes');"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <div id="breadcrumb">
                <a href="/Admin/Blank.aspx"><%=Translate.Translate("Management")%></a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="#"><%=Translate.Translate("Repositories")%></a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="/Admin/Module/Repositories/ViewRepository.aspx?id=<%=Request("Repository")%>"><%=Request("Repository")%></a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="#"><b><%=Request("Item")%></b></a>
            </div>


            <!-- LIST -->
            <div class="list" ng-if="!preview">
                <div id="_contentWrapper">
                    <dwc:GroupBox ID="GroupBox8" runat="server" Title="Query" DoTranslation="true">
                        <table>
                            <tr>
                                <td class="left-label">
                                    <dw:TranslateLabel Text="Query" runat="server" />
                                </td>
                                <td>
                                    <select class="std" ng-if="datasources.length == 0" value="{{facets.Source.Item}}">
                                        <option>{{facets.Source.Item}}</option>
                                    </select>
                                    <select class="std" ng-if="datasources" ng-change="onFacetsSourceChanged();" ng-model="facets.Source" ng-options="ds.Item group by ds.Repository for ds in datasources track by ds.Item">
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </dwc:GroupBox>

                    <!-- Facets-->
                    <dwc:GroupBox ID="GroupBox9" runat="server" Title="Facets" DoTranslation="true">
                        <div id="items">
                            <ul>
                                <li class="header" style="width: 100%">
                                    <span class="w-10"></span>
                                    <span class="w-10"><%=Translate.Translate("Name")%></span>
                                    <span class="w-10"><%=Translate.Translate("Field")%></span>
                                    <span class="w-10"><%=Translate.Translate("Terms count")%></span>
                                    <span class="w-10"><%=Translate.Translate("Type")%></span>
                                    <span class="w-10"><%=Translate.Translate("Query Parameter")%></span>
                                    <span class="w-10"><%=Translate.Translate("Render type")%></span>
                                    <span class="w-10"></span>
                                    <span class="w-10"></span>
                                </li>
                            </ul>
                            <ul>
                                <li style="width: 100%" draggable="true" ng-dragstart="sortFacetsDragStart($event, facet);" ng-dragover="sortFacetsDragOver($event);" ng-drop="sortFacetsDrop($event, facet);" class="item-field" ng-class="{'item-field-no-longer-available': isNoLongerAvailable(facet)}" ng-repeat="facet in facets.Items">
                                    <span class="w-10" ng-click="openFacetDialog(facet);"><a href="javascript:void(0);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.WbIrradescent) %>"></i></a></span>
                                    <span class="w-10" ng-click="openFacetDialog(facet);">{{facet.Name}}</span>
                                    <span class="w-10" ng-click="openFacetDialog(facet);">{{facet.Field}}</span>
                                    <span class="w-10" ng-click="openFacetDialog(facet);">{{facets.FieldsTermsCount[facet.Field]}}</span>
                                    <span class="w-10" ng-click="openFacetDialog(facet);">{{facet.Type}}</span>
                                    <span class="w-10" ng-click="openFacetDialog(facet);">{{facet.QueryParameter}}</span>
                                    <span class="w-10" ng-click="openFacetDialog(facet);">{{facet.RenderType.Name}}</span>
                                    <span class="w-10"><img class="termIcon ng-hide" ng-show="exceedFieldsTermsCount(facet)" src="/Admin/Images/Ribbon/Icons/Small/warning.png" alt="Warning" title="<%= Translate.Translate("Facets with many options can impact performance") %>" /></span>
                                    <span class="w-10 pull-right"><a href="javascript:void();" ng-click="removeFacet($index);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                                </li>
                            </ul>
                        </div>

                        <div class="text-center">
                            <button type="button" class="btn" runat="server" ng-click="newFacetDialog({Name:'Facet1', Type: 'Field'});"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, true, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add field facet")%></button>
                            <button type="button" class="btn" runat="server" ng-click="newFacetDialog({Name:'Facet1', Type: 'List', Options:[]});"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, true, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add list facet")%></button>
                            <button type="button" class="btn" runat="server" ng-click="newFacetDialog({Name:'Facet1', Type: 'Term'});"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, true, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add term facet")%></button>
                        </div>
                    </dwc:GroupBox>

                </div>
            </div>
        </div>
        <dw:Dialog ID="FacetDialog" Title="Facet" Size="Medium" ShowClose="true" ShowOkButton="true" ShowCancelButton="True" OkAction="document.getElementById('okFacetDialog').click();" runat="server">
            <button style="display: none;" id="okFacetDialog" type="button" class="dialog-button-ok" ng-click="saveFacetDialog();">OK</button>
            <dwc:GroupBox ID="GroupBox10" runat="server">
                <table border="0">
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Name" runat="server" />
                        </td>
                        <td>
                            <input ng-model="draftFacet.Name" type="text" class="std" /></td>
                    </tr>
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Field" runat="server" />
                        </td>
                        <td>
                            <select class="std" ng-model="draftFacet.Field" ng-options="field.SystemName as (field.Name) group by field.Group for field in model.Fields  | orderBy:['Group','Name']">
                            </select>                        
                            <small class="help-block info"><dw:TranslateLabel Text="Facets with many options can impact performance" runat="server" /></small>
                        </td>
                    </tr>
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Query parameters" runat="server" />
                        </td>
                        <td>
                            <select class="std" ng-model="draftFacet.QueryParameter" ng-options="param.Name as param.Name for param in parameters">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Render type" runat="server" />
                        </td>
                        <td>
                            <select class="std" ng-model="draftFacet.RenderType" ng-options="renderType as renderType.Name for renderType in renderTypes track by renderType.SystemName"></select>
                        </td>
                    </tr>
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Show" runat="server" />
                        </td>
                        <td>
                            <div class="dw-ctrl form-group radio-group">
                                <div class="form-group-input">
                                    <div class="radio">
                                        <input name="Visibility" id="Visibility_1" ng-model="draftFacet.Visibility.Status" type="radio" value="AlwaysVisible" />
                                        <label class="control-label" for="Visibility_1"><dw:TranslateLabel Text="Always" runat="server" /></label>
                                    </div>
                                    <div class="radio">
                                        <input name="Visibility" id="Visibility_2" ng-model="draftFacet.Visibility.Status" type="radio" value="Conditionally">
                                        <label class="control-label" for="Visibility_2"><dw:TranslateLabel Text="Conditionally" runat="server" /></label>
                                    </div>
			                    </div>
		                    </div>
                        </td>
                    </tr>
                    <tr ng-if="draftFacet.Visibility.Status == 'Conditionally'">
                        <td class="left-label">
                            <dw:TranslateLabel Text="Query parameter" runat="server" />
                        </td>
                        <td>
                            <select class="std" ng-model="draftFacet.Visibility.QueryParameter" ng-options="param.Name as param.Name for param in parameters"></select>
                        </td>
                    </tr>
                    <tr ng-if="draftFacet.Visibility.Status == 'Conditionally'">
                        <td class="left-label"></td>
                        <td>
                            <div class="dw-ctrl form-group radio-group">
                                <div class="form-group-input">
                                    <div class="radio">
                                        <input name="Condition" id="Condition_1" ng-model="draftFacet.Visibility.Condition" type="radio" value="HasValue">
                                        <label class="control-label" for="Condition_1"><dw:TranslateLabel Text="Has value" runat="server" /></label>
                                    </div>
                                    <div class="radio">
                                        <input name="Condition" id="Condition_2" ng-model="draftFacet.Visibility.Condition" type="radio" value="HasSpecificValue">
                                        <label class="control-label" for="Condition_2"><dw:TranslateLabel Text="Has specific value" runat="server" /></label>
                                    </div>
			                    </div>
		                    </div>
                        </td>
                    </tr>
                    <tr ng-if="draftFacet.Visibility.Status == 'Conditionally' && draftFacet.Visibility.Condition == 'HasSpecificValue'">
                        <td class="left-label">
                            <dw:TranslateLabel Text="Value" runat="server" />
                        </td>
                        <td>
                            <input type="text" class="std" ng-model="draftFacet.Visibility.MatchValue" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <div class="list list-options" ng-if="draftFacet.Type == 'List'">
                <dwc:GroupBox ID="GroupBox11" runat="server" Title="Facets" DoTranslation="true">
                    <div id="items" height: 200px; overflow-x: hidden;">
                        <ul>
                            <li class="header">
                                <span class="C1"><%=Translate.Translate("Name")%></span>
                                <span class="C2"><%=Translate.Translate("Value")%></span>
                            </li>
                        </ul>
                        <ul>
                            <li class="item-field" ng-repeat="option in draftFacet.Options">
                                <span class="C1">&nbsp;&nbsp;<input type="text" ng-model="option.Name" class="std" /></span>
                                <span class="C2">
                                    <input type="text" ng-model="option.Value" class="std" /></span>
                                <span class="C3"><a href="" class="btn" ng-click="removeFacetOption($index);">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                            </li>
                        </ul>
                    </div>
                    <div class="text-center"><button type="button" class="btn" ng-click="draftFacet.Options.push({})"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, true, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add")%></button></div>
               </dwc:GroupBox>
            </div>
        </dw:Dialog>



        <rp:Infobar runat="server" Model="facets" Name="{{facets.Name}}" Type="Facets" FileName="{{facets.FileName}}"></rp:Infobar>


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
