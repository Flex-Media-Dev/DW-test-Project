<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewIndex.aspx.vb" Inherits="Dynamicweb.Admin.Repositories.ViewIndex" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="rp" TagName="Infobar" Src="~/Admin/Module/Repositories/Controls/Infobar.ascx" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.Management.Actions"%>
<%@ Import Namespace="Dynamicweb.Management.Common.Dialogs" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" ng-app="app">
<head runat="server">
    <title></title>
    <dw:ControlResources IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <link rel="stylesheet" type="text/css" href="/Admin/Images/Ribbon/UI/Dialog/Tabular/Dialog.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Content/Items/css/Default.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Content/Items/css/ItemTypeEdit.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Content/Items/css/LanguageSelector.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Module/Repositories/Styles/Repository.css" />
</head>
<body class="area-black screen-container">

    <script type="text/javascript" src="/Admin/Resources/js/layout/Actions.js"></script>
    <script type="text/javascript" src="/Admin/Content/jsLib/Angular/angular.min.js"></script>

    <script type="text/javascript">
        if (Action) {
            Action.showCurrentScreenLoader(true);
        }
        function help() {
		    <%=Gui.HelpPopup("repositories", "modules.repositories.index")%>
        }

        var repositoryclean = '<%=Request("Repository")%>';
        var repository = '<%=Request("Repository").Replace(".","-")%>';
        var item = '<%=Request("Item").Replace(".","-")%>';
        var defaultInstanceType = '<%=DefaultInstanceType%>';
        var defaultBuildType = '<%=DefaultBuildType%>';
        var app = angular.module('app', []);
        app.location = [{}];

        var _messages = {
            foundDuplicateNames: '<%=Translate.JsTranslate("Found duplicate settings names")%>',
            saveIndexBeforeBuild: '<%=Translate.JsTranslate("Please save the Index before build")%>'
        };

        // Used to display error messages for failed builds
        var confirmMessageAction = <%=(New ConfirmMessageAction("{Title}", "{Content}", ConfirmDialogButtons.SubmitOk.ToString())).ToJson()%>;

        function save() {
            angular.element(document.forms[0]).scope().setIndex();
            var __o = new overlay('__ribbonOverlay');
            __o.show();
            setTimeout("document.getElementById('__ribbonOverlay').style.display = 'none';", <%=cmdSave.WaitTimeout%>)
        }
        <%= Dynamicweb.Controls.KeyboardShortcutManager.CreateKeyboardShortcutObserver("ctrl+s", "save()") %>
    </script>

    <script type="text/javascript" src="/Admin/Module/Repositories/Scripts/IndexRepository.js"></script>
    <script type="text/javascript" src="/Admin/Module/Repositories/Scripts/IndexController.js"></script>
    <script type="text/javascript" src="/Admin/Module/Repositories/Scripts/Filters.js"></script>


    <form id="MainForm" name="MainForm" ng-submit="setIndex()" ng-controller="indexController" ng-cloak>
        <input type="hidden" ng-init="init('<%=Convert.ToBase64String(Encoding.Default.GetBytes(Dynamicweb.Content.Management.Installation.Checksum()))%>')" />
        <!-- RIBBON-->
        <div class="card">
            <dw:RibbonBar runat="server" ID="myribbon">
                <dw:RibbonBarTab Active="true" Name="Index" runat="server">
                    <dw:RibbonBarGroup runat="server" ID="grpTools" Name="Funktioner">
                        <dw:RibbonBarButton runat="server" Text="Save" Size="Small" Icon="Save" ID="cmdSave" NgClick="setIndex();" ShowWait="true" WaitTimeout="500"></dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Save and close" Size="Small" Icon="Save" ID="cmdSaveAndClose" NgClick="setIndexAndExit()" ShowWait="true" WaitTimeout="500"></dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Cancel" Size="Small" Icon="Cancel" ID="cmdCancel" OnClientClick="document.location.href = '/Admin/Module/Repositories/ViewRepository.aspx?id='+repositoryclean" ShowWait="false" WaitTimeout="500">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" ID="RibbonBarGroup2" Name="Index">
                      <dw:RibbonBarButton runat="server" Text="Balancer" Size="Small" Icon="VerticalAlignCenter" ID="RibbonbarButton6" NgClick="openBalancerDialog(null);"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="RibbonbarButton1" runat="server" Size="Large" Text="Help" Icon="Help" OnClientClick="help();"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <!-- BREADCRUMB -->
            <div id="breadcrumb">
                <a href="/Admin/Blank.aspx"><%=Translate.Translate("Management")%></a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="#"><%=Translate.Translate("Repositories")%></a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="/Admin/Module/Repositories/ViewRepository.aspx?id=<%=Request("Repository")%>"><%=Request("Repository")%></a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="#"><b><%=Request("Item")%></b></a>
            </div>

            <!-- CONTENT -->

            <div class="list" ng-if="!preview">
                <div id="_contentWrapper">
                    <dwc:GroupBox ID="GroupBox1" runat="server" Title="Instances" DoTranslation="true">
                        <div class="infobar" ng-if="getNumberOfInstances() == 0">
                            <div class="alert-container"><%=Translate.Translate("No instances")%></div>
                        </div>

                        <div id="items" ng-if="getNumberOfInstances() &gt; 0">
                            <ul>
                                <li class="header">
                                    <span class="C15p"><%=Translate.Translate("Name")%></span>
                                    <span class="C2-progress"><%=Translate.Translate("Status")%></span>
                                    <span class="C15p"><%=Translate.Translate("Current")%></span>
                                    <span class="C10p"><%=Translate.Translate("Start time")%></span>
                                    <span class="C10p"><%=Translate.Translate("End time")%></span>
                                    <span class="C10p"><%=Translate.Translate("Run time")%></span>
                                    <span class="C10p"><%=Translate.Translate("Messages")%></span>
                                    <span class="C5p pull-right"><%=Translate.Translate("Actions")%></span> 
                                </li>
                            </ul>

                            <ul id="items">
                                <li class="item-field" ng-repeat="(name, value) in index.Instances">
                                    <span class="C15p"><a ng-click="openInstanceDialog(name);" href="javascript:void(0);"><span class="inner field-name">{{name}}</span></a></span>
                                    <span class="C2-progress">
                                        <a ng-click="openInstanceDialog(name);" href="javascript:void(0);" ng-repeat="info in [status[name]]">

                                            <!-- NEVER BUILT -->
                                            <div ng-if="!info.Status">
                                                <progress class="state-never progress" ng-value="0" max="100"></progress>
                                                <span class="state-text-never progress-text"><%=Translate.Translate("Never built")%></span>
                                            </div>

                                            <!-- BUILD COMPLETED -->
                                            <div ng-if="info.Status && info.Status.State == 0">
                                                <progress class="state-completed progress" ng-value="info.Status.CurrentCount+1" max="{{info.Status.TotalCount}}"></progress>
                                                <span class="state-text-completed progress-text"><%=Translate.Translate("Completed")%></span>
                                            </div>

                                            <!-- BUILD FAILED -->
                                            <div ng-if="info.Status && info.Status.State == 1">
                                                <progress class="state-failed progress" ng-value="info.Status.CurrentCount+1" max="{{info.Status.TotalCount}}"></progress>
                                                <span class="state-text-failed progress-text"><%=Translate.Translate("Failed")%></span>
                                            </div>

                                            <!-- BUILD FIRST -->
                                            <div ng-if="info.Status && info.Status.State == 2 && (!info.LastStatus)">
                                                <progress class="state-running-first progress" ng-value="info.Status.CurrentCount+1" max="{{info.Status.TotalCount}}"></progress>
                                                <span class="state-text-running-first progress-text">{{100* info.Status.CurrentCount / info.Status.TotalCount | number:2}}%</span>
                                            </div>

                                            <!-- BUILD FORM COMPLETED -->
                                            <div ng-if="info.Status && info.Status.State == 2 && info.LastStatus && info.LastStatus.State == 0">
                                                <progress class="state-running-from-completed progress" ng-value="info.Status.CurrentCount+1" max="{{info.Status.TotalCount}}"></progress>
                                                <span class="state-text-running-from-completed progress-text">{{100* info.Status.CurrentCount / info.Status.TotalCount | number:2}}%</span>
                                            </div>

                                            <!-- BUILD FORM FAILED -->
                                            <div ng-if="info.Status && info.Status.State == 2 && info.LastStatus.State && info.LastStatus.State == 1">
                                                <progress class="state-running-from-failed progress" ng-value="info.Status.CurrentCount+1" max="{{info.Status.TotalCount}}"></progress>
                                                <span class="state-text-running-from-failed progress-text">{{100* info.Status.CurrentCount / info.Status.TotalCount | number:2}}%</span>
                                            </div>
                                        </a>
                                    </span>
                                    <span class="C15p" ng-repeat-start="info in [status[name]]">
                                        <a ng-click="openInstanceDialog(name);" href="javascript:void(0);">
                                            <span class="inner field-name" ng-if="info.Status.CurrentCount > 0">{{info.Status.CurrentCount | number}} / {{info.Status.TotalCount | number}}</span>
                                        </a>
                                    </span>
                                    <span class="C10p">
                                        <a ng-click="openInstanceDialog(name);" href="javascript:void(0);"><span class="inner field-name">{{info.Status.StartTime | date : "<%=Dynamicweb.Core.Helpers.DateHelper.DateFormatStringShort%>"}}</span></a>
                                    </span>
                                    <span class="C10p" ng-if="info.Status.EndTime > info.Status.StartTime">
                                        <a ng-click="openInstanceDialog(name);" href="javascript:void(0);"><span class="inner field-name">{{info.Status.EndTime | date : "<%=Dynamicweb.Core.Helpers.DateHelper.DateFormatStringShort%>"}}</span></a>
                                    </span>
                                    <span class="C10p" ng-if="info.Status.EndTime <= info.Status.StartTime"></span>
                                    <span class="C10p" ng-repeat-end>
                                        <a ng-click="openInstanceDialog(name);" href="javascript:void(0);"><span class="inner field-name">{{info.Status.Runtime | timespan : '<%=Translate.Translate("hours")%>' : '<%=Translate.Translate("minutes")%>' : '<%=Translate.Translate("seconds")%>'}}</span></a>
                                    </span>
                                    <span class="C10p">
                                        <a ng-click="showMessage(name);" href="javascript:void(0);">
                                            <span class="inner field-name" ng-if="status[name].Status && status[name].Status.State == 2">{{status[name].Status.LatestLogInformation}}
                                            </span>
                                            <span class="inner field-name" ng-if="status[name].Status && status[name].Status.State == 1">
                                                <span title="{{status[name].Status.FailExceptionStackTrace}}">{{status[name].Status.FailExceptionMessage}}</span>
                                            </span>
                                        </a>
                                    </span>
                                    <span class="C10p pull-right">
                                        <button class="btn" ng-if="!status[name].IsActive && status[name].Status && status[name].Status.State == 1 && status[name].Resumable" ng-click="resumeIndex(name, status[name].Status.Meta)">&nbsp;Resume&nbsp;</button>
                                        <a href="javascript:void();" class="btn pull-right" ng-click="deleteInstance(name);">
                                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>" title="<%=Translate.Translate("Delete") %>"></i>
                                        </a>
                                    </span>
                                </li>
                            </ul>
                        </div>

                        <div class="text-center"><button type="button" class="btn" runat="server" ng-click="openInstanceDialog(null);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, true, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add instance")%></button></div>
                    </dwc:GroupBox>

                    <!-- BUILDS -->
                    <dwc:GroupBox ID="GroupBox7" runat="server" Title="Builds" DoTranslation="true">
                        <div class="infobar" ng-if="getNumberOfBuilds() == 0">
                            <div class="alert-container"><%=Translate.Translate("No builds")%></div>
                        </div>

                        <div id="items" ng-if="getNumberOfBuilds() &gt 0">
                            <ul>
                                <li class="header">
                                    <span class="C15p"><%=Translate.Translate("Name")%></span>
                                    <span class="C40p"><%=Translate.Translate("Builder")%></span>
                                    <span class="C10p"><%=Translate.Translate("Build")%></span>
                                    <span class="C10p"></span>
                                </li>
                            </ul>
                            <ul id="items">
                                <li class="item-field" ng-repeat="build in index.Builds">
                                    <span class="C15p"><a ng-click="openBuildDialog(build.Name);" href="javascript:void(0);"><span class="inner field-name">{{build.Name}}</span></a></span>
                                    <span class="C40p"><a ng-click="openBuildDialog(build.Name);" href="javascript:void(0);"><span class="inner field-name" title="{{build.Type}}">{{getTypeName(build.Type)}}</span></a></span>
                                    <span class="C10p" style="width: inherit;"><span class="inner field-name">
                                        <button type="button" class="btn btn-build" ng-repeat="instance in index.Instances" ng-disabled="status[instance.Name].IsActive" ng-click="buildIndex(instance.Name, build.Name)">
                                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlayCircle)%>" ng-if="status[instance.Name].IsActive == false"></i>
                                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.CircleONotch)%> fa-spin" ng-if="status[instance.Name].IsActive"></i>  
                                            {{instance.Name}}
                                        </button></span></span>
                                    <span class="C10p pull-right"><a href="javascript:void(0);" class="btn pull-right" ng-click="deleteBuild(build.Name);">
                                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                                </li>
                            </ul>
                        </div>

                        <div class="text-center"><button type="button" class="btn" runat="server" ng-click="openBuildDialog(null);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, true, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add build")%></button></div>
                    </dwc:GroupBox>

                    <!-- FIELDS -->
                    <dwc:GroupBox ID="GroupBox8" runat="server" Title="Fields" DoTranslation="true">
                        <div class="infobar" ng-if="!index.Schema.FieldsFromIndexDefinition || index.Schema.FieldsFromIndexDefinition.length &lt; 1">
                            <div class="alert-container"><%=Translate.Translate("No fields")%></div>
                        </div>

                        <div id="items" ng-if="index.Schema.FieldsFromIndexDefinition.length &gt; 0">
                            <ul>
                                <li class="header">
                                    <span class="C20p"><%=Translate.Translate("Name")%></span>
                                    <span class="C20p"><%=Translate.Translate("System Name")%></span>
                                    <span class="C20p"><%=Translate.Translate("Source")%></span>
                                    <span class="C10p"><%=Translate.Translate("Type")%></span>
                                    <span class="C10p"><%=Translate.Translate("Settings")%></span>
                                    <span class="C5p"></span>
                                </li>
                            </ul>
                            <ul class="items-list">
                                <li class="item-field" ng-repeat="field in index.Schema.FieldsFromIndexDefinition">

                                    <div ng-if="field.class == 'FieldDefinition'">
                                        <span ng-click="openFieldDialog(field);" class="C20p" >{{field.Name}}</span>
                                        <span ng-click="openFieldDialog(field);" class="C20p" title="{{field.SystemName}}">{{getTypeName(field.SystemName)}}</span>
                                        <span ng-click="openFieldDialog(field);" class="C20p" ng-if="field.Source.Name">{{field.Source.Name}}</span>                                       
                                        <span ng-click="openFieldDialog(field);" class="C20p" ng-if="!field.Source.Name">{{field.Source}}</span>                                       
                                        <span ng-click="openFieldDialog(field);" class="C10p">{{field.Type}}</span>
                                        <span ng-click="openFieldDialog(field);" class="C10p">
                                            <span ng-if="field.Stored"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Save) %>" title="Stored"></i>&nbsp;</span>
                                            <span ng-if="field.Indexed"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Database) %>" title="Indexed"></i>&nbsp;</span>
                                            <span ng-if="field.Analyzed"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Font) %>" title="Analyzed"></i>&nbsp;</span>
                                        </span>
                                        <span class="C5p pull-right"><a href="javascript:void(0);" class="btn pull-right" ng-click="removeField($index)">
                                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                                    </div>

                                    <div ng-if="field.class == 'ExtensionFieldDefinition'">
                                        <span class="C20p" ng-click="openFieldDialog(field);" ><%=Translate.Translate("Schema extender")%>: </span>
                                        <span class="C20p" title="{{field.Type}}">{{getTypeName(field.Type)}}</span>
                                        <span class="C5p pull-right" ><a href="javascript:void(0);" class="btn pull-right" ng-click="removeField($index)">
                                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                                    </div>

                                    <div ng-if="field.class == 'CopyFieldDefinition'">
                                        <span ng-click="openFieldDialog(field);" class="C20p" >{{field.Name}}</span>
                                        <span ng-click="openFieldDialog(field);" class="C20p" title="{{field.SystemName}}">{{getTypeName(field.SystemName)}}</span>
                                        <span ng-click="openFieldDialog(field);" class="C20p">{{field.Sources}}</span>
                                        <span ng-click="openFieldDialog(field);" class="C10p">{{field.Type}}</span>
                                        <span ng-click="openFieldDialog(field);" class="C10p">
                                            <span ng-if="field.Stored"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Save) %>" title="Stored"></i>&nbsp;</span>
                                            <span ng-if="field.Indexed"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Database) %>" title="Indexed"></i>&nbsp;</span>
                                            <span ng-if="field.Analyzed"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Font) %>" title="Analyzed"></i>&nbsp;</span>
                                        </span>
                                        <span class="C5p pull-right"><a href="javascript:void(0);" class="btn pull-right" ng-click="removeField($index)">
                                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                                    </div>

                                    <div ng-if="field.class == 'GroupingFieldDefinition'">
                                        <span ng-click="openFieldDialog(field);" class="C20p" >{{field.Name}}</span>
                                        <span ng-click="openFieldDialog(field);" class="C20p" title="{{field.SystemName}}">{{getTypeName(field.SystemName)}}</span>                                        
                                        <span ng-click="openFieldDialog(field);" class="C20p" ng-if="field.Source.Name">{{field.Source.Name}}</span>                                       
                                        <span ng-click="openFieldDialog(field);" class="C20p" ng-if="!field.Source.Name">{{field.Source}}</span>                                       
                                        <span ng-click="openFieldDialog(field);" class="C10p">{{field.Type}}</span>
                                        <span ng-click="openFieldDialog(field);" class="C10p">
                                            <span ng-if="field.Stored"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Save) %>" title="Stored"></i>&nbsp;</span>
                                            <span ng-if="field.Indexed"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Database) %>" title="Indexed"></i>&nbsp;</span>
                                            <span ng-if="field.Analyzed"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Font) %>" title="Analyzed"></i>&nbsp;</span>
                                        </span>
                                        <span class="C5p pull-right" ><a href="javascript:void(0);" class="btn pull-right" ng-click="removeField($index)">
                                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                                    </div>

                                </li>
                            </ul>
                        </div>

                        <div class="text-center"><button type="button" class="btn" runat="server" ng-click="newFieldDialog(null);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add field")%></button></div>

                        <div class="m-b-20"><%=Translate.Translate("Schema extender fields")%></div>

                        <div id="items" ng-if="index.Schema.FieldsFromIndexDefinition.length &gt; 0">
                            <ul>
                                <li class="header">
                                    <span class="C20p"><%=Translate.Translate("Name")%></span>
                                    <span class="C20p"><%=Translate.Translate("System Name")%></span>
                                    <span class="C20p"><%=Translate.Translate("Source")%></span>
                                    <span class="C10p"><%=Translate.Translate("Type")%></span>
                                    <span class="C10p"><%=Translate.Translate("Settings")%></span>
                                </li>
                            </ul>
                            <ul class="items-list">
                                <li class="item-field" ng-repeat="field in index.Schema.Fields | filter:{Hidden:false}">
                                    <span class="C20p">{{field.Name}}</span>
                                    <span class="C20p">{{field.SystemName}}</span>
                                    <span class="C20p" ng-if="field.Source">{{field.Source}}</span>
                                    <span class="C20p" ng-if="field.Sources">{{field.Sources}}</span>
                                    <span class="C10p">{{field.Type}}</span>
                                    <span class="C10p">
                                        <span ng-if="field.Stored"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Save) %>" title="Stored"></i>&nbsp;</span>
                                        <span ng-if="field.Indexed"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Database) %>" title="Indexed"></i>&nbsp;</span>
                                        <span ng-if="field.Analyzed"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Font) %>" title="Analyzed"></i>&nbsp;</span>
                                    </span>
                                </li>
                            </ul>
                        </div>
                    </dwc:GroupBox>

                    <!-- FIELD TYPES -->
                    <dwc:GroupBox ID="GroupBox12" runat="server" Title="Field types" DoTranslation="true">
                        <div class="infobar" ng-if="!index.Schema.FieldTypes || index.Schema.FieldTypes.length &lt; 1">
                            <div class="alert-container"><%=Translate.Translate("No field types")%></div>
                        </div>

                        <div id="items" ng-if="index.Schema.FieldTypes.length &gt; 0">
                            <ul>
                                <li class="header">
                                    <span class="C20p"><%=Translate.Translate("Name")%></span>
                                    <span class="C40p"><%=Translate.Translate("Type")%></span>
                                </li>
                            </ul>
                            <ul>
                                <li class="item-field" ng-repeat="fieldType in index.Schema.FieldTypes">
                                    <span ng-click="openFieldTypeDialog(fieldType);" class="C20p">{{fieldType.Name}}</span>
                                    <span ng-click="openFieldTypeDialog(fieldType);" class="C40p">{{fieldType.Type}}</span>
                                    <span class="C5p pull-right" ><a href="javascript:void(0);" class="btn pull-right" ng-click="removeFieldType($index)">
                                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                                </li>
                            </ul>
                        </div>

                        <div class="text-center"><button type="button" class="btn" runat="server" ng-click="newFieldTypeDialog(null);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add field type")%></button></div>
                    </dwc:GroupBox>
                </div>
            </div>
        </div>

        <dw:Dialog ID="dlgInstance" Title="Instance" Size="Medium" ShowClose="true" ShowOkButton="true" ShowCancelButton="True" OkAction="document.getElementById('okInstanceDialog').click();" runat="server">
            <button class="btn" style="display: none;" id="okInstanceDialog" type="button" ng-click="saveInstanceDialog();">OK</button>

            <dwc:GroupBox ID="GroupBox2" runat="server" Title="Settings">
                <table border="0">
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Name" runat="server" />
                        </td>
                        <td>
                            <input name="dlgInstanceName" ng-readonly="draftInstance.originalName != 'new'" ng-model="draftInstance.Name" type="text" id="dlgInstanceName" class="std" />
                        </td>
                    </tr>
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Select provider" runat="server" />
                        </td>
                        <td>
                            <ul class="unstyled">
                                <li ng-model="draftInstance.Type" ng-repeat="instanceType in instanceTypes">
                                    <label>
                                        <input type="radio"
                                            ng-model="draftInstance.Type"
                                            ng-value="instanceType.FullName"
                                            id="{{instanceType.Name}}"
                                            name="{{instanceType.Name}}"
                                            ng-change="draftInstance.Settings ={}">
                                        {{instanceType.Name}}
                                    </label>
                                </li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <span ng-if="draftInstance.Type == 'Dynamicweb.Indexing.Lucene.LuceneIndexProvider, Dynamicweb.Indexing.Lucene'">
                <dwc:GroupBox ID="grpLucene" Title="Lucene settings" runat="server">
                    <table border="0">
                        <tr>
                            <td style="width: 170px">
                                <label>
                                    Folder
                                </label>
                            </td>
                            <td>
                                <input name="dlgInstanceName" ng-model="draftInstance.Settings.Folder" type="text" id="dlgInstanceName" class="std" />
                                <div class="view-index-root-folder">{{getLuceneIndexRootFolder()}}</div>
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
            </span>

            <span ng-if="draftInstance.Type == 'Dynamicweb.Indexing.Solr.SolrIndexProvider, Dynamicweb.Indexing.Solr'">
                <dwc:GroupBox runat="server" Title="Solr">
                    <table border="0">
                        <tr>
                            <td style="width: 170px">
                                <label>
                                    <%=Translate.Translate("Url")%>
                                </label>
                            </td>
                            <td>
                                <input name="dlgBuildName" ng-model="draftInstance.Settings.Url" type="text" id="dlgBuildName" class="std" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 170px">
                                <label>
                                    <%=Translate.Translate("Username")%>
                                </label>
                            </td>
                            <td>
                                <input name="dlgBuildName" ng-model="draftInstance.Settings.Username" type="text" id="dlgBuildName" class="std" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 170px">
                                <label>
                                    <%=Translate.Translate("Password")%>
                                </label>
                            </td>
                            <td>
                                <input name="dlgBuildName" ng-model="draftInstance.Settings.Password" type="text" id="dlgBuildName" class="std" />
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
            </span>
        </dw:Dialog>

        <dw:Dialog ID="dlgBuild" Title="Build" Size="Medium" ShowClose="true" ShowOkButton="true" ShowCancelButton="True" OkAction="document.getElementById('okBuildDialog').click();" runat="server">
            <button class="btn" style="display: none;" id="okBuildDialog" type="button" class="dialog-button-ok" ng-click="saveBuildDialog();">OK</button>

            <dwc:GroupBox ID="GroupBox9" runat="server">
                <table border="0">
                    <tr>
                        <td class="left-label">
                            <label>
                                <%=Translate.Translate("Name")%>
                            </label>
                        </td>
                        <td>
                            <input name="dlgBuildName" ng-model="draftBuild.Name" type="text" id="dlgBuildName" class="std" />
                        </td>
                    </tr>
                    <tr>
                        <td class="left-label">
                            <%=Translate.Translate("Builder")%>
                        </td>
                        <td>
                            <select class="std" name="ddlBuildType" ng-model="draftBuild.Type" ng-change="changeBuildType()" ng-options="buildType.FullName as buildType.Name for buildType in buildTypes" ng-disabled="getNumberOfBuilds() &gt; 0"></select>
                        </td>
                    </tr>
                    <tr>
                        <td class="left-label">
                            <%=Translate.Translate("Builder action")%>
                        </td>
                        <td>
                            <select class="std" name="ddlBuildAction" ng-model="draftBuild.Action" ng-options="buildAction for buildAction in buildActions[draftBuild.Type]"></select>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>


            <span ng-if="draftBuild.Type == 'Dynamicweb.Indexing.Builders.SqlIndexBuilder, Dynamicweb.Indexing'">
                <dwc:GroupBox runat="server" Title="Connection settings">
                    <table border="0">
                        <tr>
                            <td style="width: 170px">
                                <label>
                                    <%=Translate.Translate("Connection String")%>
                                </label>
                            </td>
                            <td>
                                <input ng-model="draftBuild.Settings.Connection" type="text" class="std" />
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Query">
                    <table border="0">
                        <tr>
                            <td>
                                <textarea name="dlgBuildName" ng-model="draftBuild.Settings.Query" type="text" class="std name" style="width: 100%; height: 80px;" onkeyup=""></textarea>
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Query to get count">
                    <table border="0">
                        <tr>
                            <td>
                                <textarea name="dlgBuildName" ng-model="draftBuild.Settings.CountQuery" type="text" class="std name" style="width: 100%; height: 80px;" onkeyup=""></textarea>
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
            </span>

            <div ng-show="draftBuild.Type != 'Dynamicweb.Indexing.Builders.SqlIndexBuilder, Dynamicweb.Indexing'">
                <dwc:GroupBox ID="GroupBox4" runat="server" Title="Settings">
                    <div class="list">
                        <div id="items">
                            <ul style="min-width: initial !important;">
                                <li class="header" style="min-width: initial !important;">
                                    
                                    <span class="C40p"><%=Translate.Translate("Name")%></span>
                                    
                                    <span class="C40p"><%=Translate.Translate("Value")%></span>
                                </li>
                            </ul>
                            <ul style="min-width: initial !important;">
                                <li class="item-field" style="min-width: initial !important;" ng-repeat="setting in draftBuild.settingsArr track by $index">
                                    <span class="C40p">
                                        <input type="text" class="std" ng-model="setting.name"/>
                                    </span>
                                    <span class="C40p">                                        
                                        <input type="text" class="std" style="color:{{setting.isDefault ? '#9e9e9e' : '#353535'}};" ng-model="setting.value" />
                                    </span>
                                    <span class="pull-right"><a href="javascript:void(0);" class="btn pull-right" ng-click="removeSettingFromBuild(draftBuild, $index)">
                                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                                </li>
                            </ul>
                        </div>
                        <div class="text-center"><button type="button" class="btn" ng-click="addSettingToBuild(draftBuild);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add")%></button></div>
                    </div>
                </dwc:GroupBox>
            </div>

            <div>
                <dwc:GroupBox ID="GroupBox15" runat="server" Title="Notifications">
                    <table border="0">
                        <tr>
                            <td class="left-label">
                                <%=Translate.Translate("Send notification")%>
                            </td>
                            <td>
                                <select class="std" ng-model="draftBuild.Notification.NotificationType">
                                    <option value="Never"><%=Translate.Translate("Never") %></option>
                                    <option value="EveryTime"><%=Translate.Translate("Every time") %></option>
                                    <option value="OnFailure"><%=Translate.Translate("On failure") %></option>
                                </select>
                            </td>
                        </tr>
                        <tr ng-if="draftBuild.Notification.NotificationType != 'Never'">
                            <td class="left-label">
                                <label>
                                    <%=Translate.Translate("Sender name")%>
                                </label>
                            </td>
                            <td>
                                <input name="dlgBuildNotificationSenderName" ng-model="draftBuild.Notification.SenderName" type="text" id="dlgBuildNotificationSenderName" class="std" />
                            </td>
                        </tr>
                        <tr ng-if="draftBuild.Notification.NotificationType != 'Never'">
                            <td class="left-label">
                                <label>
                                    <%=Translate.Translate("Sender email")%>
                                </label>
                            </td>
                            <td>
                                <input name="dlgBuildNotificationSenderEmail" ng-model="draftBuild.Notification.SenderEmail" type="text" id="dlgBuildNotificationSenderEmail" class="std" />
                            </td>
                        </tr>
                        <tr ng-if="draftBuild.Notification.NotificationType != 'Never'">
                            <td class="left-label">
                                <label>
                                    <%=Translate.Translate("Subject")%>
                                </label>
                            </td>
                            <td>
                                <input name="dlgBuildNotificationSubject" ng-model="draftBuild.Notification.Subject" type="text" id="dlgBuildNotificationSubject" class="std" />
                            </td>
                        </tr>
                        <tr ng-if="draftBuild.Notification.NotificationType != 'Never'">
                            <td class="left-label">
                                <%=Translate.Translate("Email template")%>
                            </td>
                            <td>
                                <select class="std" name="dlgBuildNotificationTemplate" ng-model="draftBuild.Notification.Template" ng-options="template for template in notificationTemplates track by template"></select>
                            </td>
                        </tr>
                        <tr ng-if="draftBuild.Notification.NotificationType != 'Never'">
                            <td class="left-label"></td>
                            <td align="left">
                                <input type="checkbox" ng-model="draftBuild.Notification.SendLog" onkeyup="" />
                                <%=Translate.Translate("Send log file")%>
                            </td>
                        </tr>
                        <tr ng-if="draftBuild.Notification.NotificationType != 'Never'">
                            <td colspan="2">
                                <div class="list">
                                    <div id="items">
                                        <ul style="min-width: initial !important;">
                                            <li class="header" style="min-width: initial !important;">
                                                
                                                <span class="C1"><%=Translate.Translate("Recipients")%></span>
                                            </li>
                                        </ul>
                                        <ul style="min-width: initial !important;">
                                            <li class="item-field" style="min-width: initial !important;" ng-repeat="recipient in draftBuild.Notification.Recipients track by $index">
                                                <span class="C1" style="width:300px;">
                                                    <input type="text" ng-model="draftBuild.Notification.Recipients[$index]" />
                                                </span>
                                                <span class="pull-right"><a href="javascript:void(0);" ng-click="removeRecipientFromBuild($index)">
                                                    <img src="/Admin/Images/Icons/Delete_vsmall.gif"></a></span>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="text-center"><button type="button" class="btn" ng-click="addRecipientToBuild(draftBuild);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add")%></button></div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
            </div>
        </dw:Dialog>

        <dw:Dialog ID="FieldDialog" Title="Field" Size="Medium" ShowClose="true" ShowOkButton="true" ShowCancelButton="True" OkAction="document.getElementById('okFieldDialog').click();" runat="server">
            <button class="btn" style="display: none;" id="okFieldDialog" type="button" class="dialog-button-ok" ng-click="saveFieldDialog();">OK</button>

            <dwc:GroupBox ID="GroupBox10" runat="server">
                <table border="0">
                    <tr>
                        <td class="left-label">
                            <dw:TranslateLabel Text="Field type" runat="server" />
                        </td>
                        <td>
                            <select class="std" ng-model="draftField.class">
                                <option value="FieldDefinition"><%=Translate.Translate("Field")%></option>
                                <option value="CopyFieldDefinition"><%=Translate.Translate("Summary field")%></option>
                                <option value="ExtensionFieldDefinition"><%=Translate.Translate("Schema extender")%></option>
                                <option value="GroupingFieldDefinition"><%=Translate.Translate("Grouping")%></option>
                            </select>
                        </td>
                    </tr>

                    <tr ng-if="draftField.class == 'FieldDefinition' || draftField.class == 'CopyFieldDefinition' || draftField.class == 'GroupingFieldDefinition'">
                        <td class="left-label">
                            <%=Translate.Translate("Name")%>
                        </td>
                        <td>
                            <input ng-model="draftField.Name" type="text" class="std" />
                        </td>
                    </tr>

                    <tr ng-if="draftField.class == 'FieldDefinition' || draftField.class == 'CopyFieldDefinition' || draftField.class == 'GroupingFieldDefinition'">
                        <td class="left-label">
                            <%=Translate.Translate("System name")%>
                        </td>
                        <td>
                            <input ng-model="draftField.SystemName" type="text" class="std" />
                        </td>
                    </tr>

                    <tr ng-if="draftField.class == 'FieldDefinition' || draftField.class == 'GroupingFieldDefinition'">
                        <td class="left-label">
                            <%=Translate.Translate("Source")%>
                        </td>
                        <td>
                            <div class="input-group">
                                <select class="std pull-left" name="ddlBuildAction" ng-model="draftField.Source" ng-options="fieldSource.Name group by fieldSource.Group for fieldSource in fieldSources track by fieldSource.Name" style="width: 245px"></select>
                                <div class="input-group-addon last pull-left" ng-click="addSource();" alt="Add source"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success) %>"></i></div>
                            </div>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox11" runat="server" Title="Settings">
                <table border="0">
                    <tr>
                        <td class="left-label">
                            <span ng-if="draftField.class != 'CopyFieldDefinition'">
                                <%=Translate.Translate("Type")%>
                            </span>
                        </td>
                        <td>
                            <select class="std" ng-model="draftField.Type" ng-options="type.name as type.name group by type.groupName for type in types" ng-if="hasUserDefinedFieldTypes && (draftField.class == 'FieldDefinition' || draftField.class == 'GroupingFieldDefinition')">
                            </select>

                            <select class="std" ng-model="draftField.Type" ng-options="type.name as type.name for type in types" ng-if="!hasUserDefinedFieldTypes && (draftField.class == 'FieldDefinition' || draftField.class == 'GroupingFieldDefinition')">
                            </select>

                            <select class="std" ng-model="draftField.Type" ng-if="draftField.class == 'ExtensionFieldDefinition'" ng-options="extensionType.FullName as extensionType.Name for extensionType in extensionTypes">
                            </select>
                        </td>
                    </tr>

                    <%--
                        <tr ng-if="draftField.class == 'FieldDefinition' || draftField.class == 'CopyFieldDefinition'">
                            <td class="left-label">
                                <%=Translate.Translate("Analyzer")%>
                            </td>
                            <td>
                                <input ng-model="draftField.Analyzer" type="text" class="std" />
                            </td>
                        </tr>
                    --%>

                    <tr ng-if="draftField.class == 'FieldDefinition' || draftField.class == 'CopyFieldDefinition' || draftField.class == 'GroupingFieldDefinition'">
                        <td class="left-label">
                            <%=Translate.Translate("Boost")%>
                        </td>
                        <td>
                            <input ng-model="draftField.Boost" type="number" step="0.1" class="std" placeholder="1.0" />
                            <small class="help-block info" id="infoBoost"><%=Translate.Translate("More important than other fields during search?")%></small>
                        </td>
                    </tr>

                    <tr ng-if="draftField.class == 'FieldDefinition' || draftField.class == 'CopyFieldDefinition' || draftField.class == 'GroupingFieldDefinition'">
                        <td class="left-label"></td>
                        <td align="left">
                            <input type="checkbox" id="checkStored" class="checkbox" ng-model="draftField.Stored" onkeyup="" />                            
                            <label for="checkStored"><%=Translate.Translate("Stored")%></label>
                            <small class="help-block info" id="infoCheckStored"><%=Translate.Translate("Should this field be shown in frontend?")%></small>
                        </td>
                    </tr>

                    <tr ng-if="draftField.class == 'FieldDefinition' || draftField.class == 'CopyFieldDefinition' || draftField.class == 'GroupingFieldDefinition'">
                        <td class="left-label"></td>
                        <td align="left">
                            <input type="checkbox" id="checkIndexed" class="checkbox" ng-model="draftField.Indexed" onkeyup="" />                            
                            <label for="checkIndexed"><%=Translate.Translate("Indexed")%></label>
                            <small class="help-block info" id="infoCheckIndexed"><%=Translate.Translate("Should this field be used in the query?")%></small>
                        </td>
                    </tr>

                    <tr ng-if="draftField.class == 'FieldDefinition' || draftField.class == 'CopyFieldDefinition' || draftField.class == 'GroupingFieldDefinition'">
                        <td class="left-label"></td>
                        <td align="left">
                            <input type="checkbox" id="checkAnalyzed" class="checkbox" ng-model="draftField.Analyzed" onkeyup="" />                            
                            <label for="checkAnalyzed"><%=Translate.Translate("Analyzed")%></label>
                            <small class="help-block info" id="infoCheckAnalyzed"><%=Translate.Translate("Use for freetext search?")%></small>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <div id="list" class="list" ng-if="draftField.class == 'CopyFieldDefinition'">
                <dwc:GroupBox ID="GroupBox3" runat="server" Title="Sources">
                    <div id="items">
                        <ul style="min-width: initial !important;">
                            <li class="header" style="min-width: initial !important;">
                                <span class="C1"><%=Translate.Translate("Field")%></span>
                            </li>
                        </ul>
                        <ul style="min-width: initial !important;">
                            <li class="item-field" style="min-width: initial !important;" ng-repeat="source in draftField.Sources track by $index">
                                <span class="C80p">
                                    <select ng-model="draftField.Sources[$index]" class="std" ng-options="field.SystemName as field.Name group by field.Group for field in index.Schema.Fields | orderBy:['Group','Name']">
                                    </select>
                                    <span ng-model="draftField.Sources[$index]"></span>
                                </span>
                                <span class="C5p pull-right"><a href="javascript:void(0);" class="btn pull-right" ng-click="removeCopyFieldSource(draftField, $index)">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                            </li>
                        </ul>
                    </div>

                    <div class="text-center"><button type="button" class="btn" ng-click="addFieldToCopyList(draftField);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add")%></button></div>
                </dwc:GroupBox>
            </div>

            <div class="list" ng-if="draftField.class == 'GroupingFieldDefinition'">
                <dwc:GroupBox ID="GroupBox5" runat="server" Title="Groups">
                    <div id="items">
                        <ul style="min-width: initial !important;">
                            <li class="header" style="min-width: initial !important;">
                                <span class="C30p"><%=Translate.Translate("Name")%></span>
                                <span class="C30p"><%=Translate.Translate("From")%></span>
                                <span class="C30p"><%=Translate.Translate("To")%></span>
                                <span></span>
                            </li>
                        </ul>
                        <ul style="position: relative; min-width: initial !important;">
                            <li class="item-field" style="min-width: initial !important;" ng-repeat="group in draftField.Groups track by $index">
                                <span class="C30p">
                                    <input type="text" class="std" ng-model="group.Name" />
                                </span>
                                <span class="C30p">
                                    <input type="text" class="std" ng-model="group.From" />
                                </span>
                                <span class="C30p">
                                    <input type="text" class="std" ng-model="group.To" />
                                </span>
                                <span class="pull-right"><a href="javascript:void(0);" class="btn" ng-click="removeGroupFromGrouping(draftField, $index)">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                            </li>
                        </ul>
                    </div>

                    <div class="text-center"><button type="button" class="btn" ng-click="addGroupToGrouping(draftField);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add")%></button></div>
                </dwc:GroupBox>
            </div>

            <div class="list" ng-if="draftField.class == 'ExtensionFieldDefinition'">
                <dwc:GroupBox ID="GroupBox6" runat="server" Title="Excluded fields">
                    <div id="items">
                        <ul style="min-width: initial !important;">
                            <li class="header" style="min-width: initial !important;">
                                <span class="C3"><%=Translate.Translate("Name")%></span>
                            </li>
                        </ul>
                        <ul style="min-width: initial !important;">
                            <li class="item-field" style="min-width: initial !important;" ng-repeat="excluded in draftField.ExcludedFields track by $index">
                                <span class="C80p">
                                    <select ng-model="draftField.ExcludedFields[$index]" class="std" ng-options="field.SystemName as field.Name for field in extensionFields[draftField.Type]">
                                    </select> 
                                </span>
                                <span class="pull-right"><a href="javascript:void(0);" class="btn pull-right" ng-click="removeExcludedField(draftField, $index)">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                            </li>
                        </ul>
                    </div>

                    <div class="text-center"><button type="button" class="btn" ng-click="addExcludedField(draftField);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add")%></button></div>
                </dwc:GroupBox>
            </div>
        </dw:Dialog>

        <dw:Dialog ID="FieldTypeDialog" Title="Field type" Size="Medium" ShowClose="true" ShowOkButton="true" ShowCancelButton="True" OkAction="document.getElementById('okFieldTypeDialog').click();" runat="server">
            <button class="btn" style="display: none;" id="okFieldTypeDialog" type="button" class="dialog-button-ok" ng-click="saveFieldTypeDialog();">OK</button>

            <dwc:GroupBox ID="GroupBox13" runat="server">
                <table border="0">
                    <tr>
                        <td class="left-label">
                            <%=Translate.Translate("Name")%>
                        </td>
                        <td>
                            <input ng-model="draftFieldType.Name" type="text" class="std" />
                        </td>
                    </tr>
                    <tr>
                        <td class="left-label">
                            <%=Translate.Translate("Type")%>
                        </td>
                        <td>
                            <select class="std" ng-model="draftFieldType.Type" ng-options="type.name as type.name for type in types">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="left-label">
                            <%=Translate.Translate("Boost")%>
                        </td>
                        <td>
                            <input ng-model="draftFieldType.Boost" type="text" class="std" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <dwc:GroupBox ID="GroupBox14" runat="server" Title="Analyzers">
                <div class="list">
                    <div id="items">
                        <ul style="min-width: initial !important;">
                            <li class="header">       
                                
                                <span class="C40p"><%=Translate.Translate("Provider")%></span>
                                
                                <span class="C40p"><%=Translate.Translate("Analyzer")%></span>
                            </li>
                        </ul>
                        <ul>
                            <li class="item-field" style="min-width: initial !important;" ng-repeat="analyzer in draftFieldType.Analyzers track by $index">
                                <span class="C40p">
                                    <select class="std" ng-model="analyzer.key" ng-options="instanceType.FullName as instanceType.Name for instanceType in instanceTypes">
                                    </select>
                                </span>
                                <span class="C40p">
                                    <select class="std" ng-model="analyzer.value" ng-options="analyzer.FullName as analyzer.Class for analyzer in analyzersDataSource(analyzer.key) | orderBy:'Class'">
                                    </select>
                                </span>
                                <span class="pull-right"><a href="javascript:void(0);" class="btn" ng-click="removeAnalyzerFromFieldType(draftFieldType, $index)">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Delete) %>"></i></a></span>
                            </li>
                        </ul>
                    </div>

                    <div class="text-center"><button type="button" class="btn" ng-click="addAnalyzerToFieldType(draftFieldType);"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, true, Dynamicweb.Core.UI.KnownColor.Success)%>"></i> <%=Translate.Translate("Add Analyzer")%></button></div>
                </div>
            </dwc:GroupBox>

        </dw:Dialog>

               <dw:Dialog ID="balancerDlg" Title="Balancer" Size="Medium" ShowClose="true" ShowOkButton="true" ShowCancelButton="True" OkAction="document.getElementById('okBalancerTypeDialog').click();" runat="server">
            <button class="btn" style="display: none;" id="okBalancerTypeDialog" type="button" class="dialog-button-ok" ng-click="saveBalancerDialog();">OK</button>

            <dwc:GroupBox ID="GroupBox17" runat="server">
                <table border="0">
                    <tr>
                        <td class="left-label">
                            <%=Translate.Translate("Balancer")%>
                        </td>
                      <td>
                            <select class="std" ng-model="draftBalancerType" ng-options="balancer as balancer.Type for balancer in balancerTypes track by balancer.Type">
                            </select>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </dw:Dialog>

        <rp:Infobar runat="server" Model="index" Name="{{index.Name}}" Type="Index" FileName="{{index.FileName}}"></rp:Infobar>

    </form>

    <dw:Overlay ID="ItemTypeEditOverlay" runat="server"></dw:Overlay>

    <%Translate.GetEditOnlineScript()%>

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

    <script type="text/javascript">
        Dynamicweb.Ajax.ControlManager.get_current().initialize();
    </script>
</body>
</html>
