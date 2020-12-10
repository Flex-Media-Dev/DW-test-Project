<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Indexes.aspx.vb" Inherits="Dynamicweb.Admin.Indexes" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

    <!-- Default ScriptLib-->
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script src="/Admin/Content/jsLib/Angular/angular.min.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js" type="text/javascript"></script>
    </dwc:ScriptLib>

    <script type="text/javascript">
        var app = angular.module('app', []);

        function refreshPress() {
            document.getElementById("refreshButton").click();
        }

        function rebuildPress() {
            document.getElementById("rebuildButton").click();
        }

        var rebuildCompleteMsg = '<%=Translate.Translate("Rebuild complete")%>';        
    </script>

    <%--ToDo: ensure that moved from indexes.css style needed--%>
    <style type="text/css">        
        .table .container {
            padding: 0 !important; 
        }
    </style>

</head>
<body>
    <body class="area-blue">
        <div class="dw8-container">            
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" ID="lbSetup" Title="Database Indexes Health"></dwc:CardHeader>

                <dw:Toolbar runat="server" ShowStart="true" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="cmdRefresh" Icon="Refresh" OnClientClick="refreshPress();" Text="Refresh" Divide="After" runat="server" />
                    <dw:ToolbarButton ID="cmdRebuild" Icon="Recycle" Text="Rebuid Indexes" runat="server" OnClientClick="rebuildPress();" />
                </dw:Toolbar>

                <div class="card">
                    <form id="MainForm" runat="server" ng-app="app" ng-cloak ng-controller="IndexesController">
                        <input type="hidden"  ng-init="init('<%=Convert.ToBase64String(Encoding.Default.GetBytes(Dynamicweb.Content.Management.Installation.Checksum()))%>')" />
                        <input id="refreshButton" type="button" style="display: none;" ng-click="refresh();" />
                        <input id="rebuildButton" type="button" style="display: none;" ng-click="rebuild();" />

                        <dw:Overlay ID="loadOverlay" runat="server"></dw:Overlay>

                        <div ng-if="permissionError && permissionError.length > 0">
                            <dw:Infobar ID="Infobar1" runat="server" Type="Information" Visible="true" TranslateMessage="False">
                                <asp:Literal runat="server" Text="{{permissionError}}" />
                            </dw:Infobar>
                        </div>

                        <div ng-if="!permissionError">
                            <div ng-if="error && error.length > 0">
                                <dw:Infobar ID="infError" runat="server" Type="Error" Visible="true" TranslateMessage="False">
                                    <asp:Literal runat="server" Text="{{error}}" />
                                </dw:Infobar>
                            </div>
                            <table class="table">
                                <tbody>
                                    <tr style="display: none">
                                        <td class="title">(2)</td>
                                    </tr>
                                    <tr>
                                        <td class="container">
                                            <div id="ListTableContainer list database" >
                                                <table id="ListTable" class="table">
                                                    <thead style="display: ">
                                                        <tr class="header">                                                            
                                                            <td class="columnCell" style="white-space: nowrap;">
                                                                <table cellspacing="0" cellpadding="0" border="0" style="width: 100%; height: 18px;">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>
                                                                                <span class="pipe"></span>
                                                                                <span class="C1 table-name">
                                                                                    <%=Translate.Translate("Table Name")%>
                                                                                </span>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                            <td class="columnCell" style="white-space: nowrap;">
                                                                <table cellspacing="0" cellpadding="0" border="0" style="width: 100%; height: 18px;">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>
                                                                                <span class="pipe"></span>
                                                                                <span class="C2 index-name">
                                                                                    <%=Translate.Translate("Index Name")%>
                                                                                </span>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                            <td class="columnCell" style="white-space: nowrap;">
                                                                <table cellspacing="0" cellpadding="0" border="0" style="width: 100%; height: 18px;">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>
                                                                                <span class="pipe"></span>
                                                                                <span class="C3">
                                                                                    <%=Translate.Translate("Fragmentation")%>
                                                                                </span>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                            <td class="columnCell" style="white-space: nowrap;">
                                                                <table cellspacing="0" cellpadding="0" border="0" style="width: 100%; height: 18px;">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>
                                                                                <span class="pipe"></span>
                                                                                <span class="C3"></span>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="configurationsList_body" controlid="configurationsList" class="item-field" ng-class="{'hightlight': index.inProgress }" style="position: relative;" ng-repeat="index in database.indexes">
                                                        <tr style="cursor: pointer;" class="listRow">                                                            
                                                            <td style="width: auto">
                                                                <span class="C1 table-name">{{index.tableName}}</span>
                                                            </td>
                                                            <td style="width: auto">
                                                                <span class="C2 index-name">{{index.indexName}}</span>
                                                            </td>
                                                            <td style="width: auto">
                                                                <span class="C3">{{index.frag}}</span>
                                                            </td>
                                                            <td>
                                                                <span class="C3 result">{{index.message}}<span ng-if="index.error && index.error.length > 0" title="{{index.error}}"><%=Translate.Translate("Error")%></span></span>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr style="display: none">
                                        <td>
                                            <div class="subheader">
                                                &nbsp;
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>


                            <dw:Overlay ID="PleaseWait" runat="server" />
                    </form>

                    <%Translate.GetEditOnlineScript()%>

                    <script type="text/javascript" src="/Admin/Content/Management/Database/IndexesRepository.js"></script>
                    <script type="text/javascript" src="/Admin/Content/Management/Database/IndexesController.js"></script>                    
                </div>
            </dwc:Card>
        </div>
    </body>
</html>
