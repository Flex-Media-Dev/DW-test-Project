<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WidgetsList.aspx.vb" Inherits="Dynamicweb.Admin.WidgetsList" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title>Page sorting</title>
    <dwc:ScriptLib runat="server" ID="ScriptLib1" />

    <script type="text/javascript" src="/Admin/Content/JsLib/scriptaculous-js-1.9/src/scriptaculous.js?load=effects,dragdrop,slider,controls"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/require.js"></script>
    <script type="text/javascript" src="PageSort.js"></script>
    <link rel="Stylesheet" href="PageSort.css" />

    <script>
        var sortPage = null;
        (function ($) {
            sortPage = getSortPage($, {
                parentPageId: <%=parentPageID %>,
                areaId: <%=areaID %>,
                selectedPageId: "<%=selectedPageID %>",
                selectedPageParentsID: "<%=selectedPageParentsID %>",
            });
            $(function () {
                sortPage.init();
            });
        })(jQuery);
        
    </script>
</head>

<body class="area-blue">
    <div class="screen-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Home dashboard" ID="cardTitle"></dwc:CardHeader>
            <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowStart="false">
                <dw:ToolbarButton ID="ToolbarButton1" runat="server" Icon="PlusSquare" Text="Add widget">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="ToolbarButton2" runat="server" Icon="Times" Text="Delete selected">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="cmdHelp" Icon="Help" Divide="Before" Text="Help" OnClientClick="help();" runat="server" />
            </dw:Toolbar>

            <dw:PageBreadcrumb ID="breadcrumbControl" runat="server" />
            <dwc:CardBody runat="server">
                <form id="form1" runat="server">
                    <div id="content">
                        <div class="list">
                            <ul class="list-group">
                                <li class="list-group-item">
                                    <span class="C0"><dw:Checkbox runat="server" /></span>
                                    <span class="C1">&nbsp;</span>
                                    <span class="C2 sort-col" data-col-name="name">
                                        <a href="#"><%=Translate.Translate("Widget name")%></a>
                                        <i class="sort-selector up <%=KnownIconInfo.ClassNameFor(KnownIcon.SortUp, True)%>"></i>
                                        <i class="sort-selector down <%=KnownIconInfo.ClassNameFor(KnownIcon.SortDown, True)%>"></i>
                                    </span>
                                    <span class="C3 sort-col">
                                        <%=Translate.Translate("Sortering")%>
                                    </span>
                                    <span class="C4 sort-col" data-col-name="created">
                                        <a href="#"><%=Translate.Translate("Oprettet")%></a>
                                        <i class="sort-selector up <%=KnownIconInfo.ClassNameFor(KnownIcon.SortUp, True)%>"></i>
                                        <i class="sort-selector down <%=KnownIconInfo.ClassNameFor(KnownIcon.SortDown, True)%>"></i>
                                    </span>
                                    <span class="C4 sort-col" data-col-name="updated">
                                        <a href="#"><%=Translate.Translate("Redigeret")%></a>
                                        <i class="sort-selector up <%=KnownIconInfo.ClassNameFor(KnownIcon.SortUp, True)%>"></i>
                                        <i class="sort-selector down <%=KnownIconInfo.ClassNameFor(KnownIcon.SortDown, True)%>"></i>
                                    </span>
                                </li>
                            </ul>

                            <ul id="items">
                                <li class="list-group-item Show<%#Eval("Active")%>">
                                    <span class="C0"><dw:Checkbox runat="server" /></span>
                                    <span class="C1"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.ThList, True)%>"></i></span>
                                    <span class="C2">Latest news</span>
                                    <div style="display: none;"><%#Eval("Audit.CreatedAt").Ticks%></div>
                                    <div style="display: none;"><%#Eval("Audit.LastModifiedAt").Ticks%></div>
                                    <div style="display: none;"></div>
                                    <span class="C3" id="Span1">1</span>
                                    <span class="C4">ti, 16 sep 2014 05:21:13</span>
                                    <span class="C4">ti, 16 sep 2014 05:21:14</span>
                                </li>
                                <li class="list-group-item Show<%#Eval("Active")%>">
                                    <span class="C0"><dw:Checkbox runat="server" /></span>
                                    <span class="C1"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.ThList, True)%>"></i></span>
                                    <span class="C2">Shortcuts</span>
                                    <div style="display: none;"><%#Eval("Audit.CreatedAt").Ticks%></div>
                                    <div style="display: none;"><%#Eval("Audit.LastModifiedAt").Ticks%></div>
                                    <div style="display: none;"></div>
                                    <span class="C3" id="Span1">2</span>
                                    <span class="C4">ti, 16 sep 2014 05:21:13</span>
                                    <span class="C4">ti, 16 sep 2014 05:21:14</span>
                                </li>
                                <li class="list-group-item Show<%#Eval("Active")%>">
                                    <span class="C0"><dw:Checkbox runat="server" /></span>
                                    <span class="C1"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.ThList, True)%>"></i></span>
                                    <span class="C2">Latest available updates</span>
                                    <div style="display: none;"><%#Eval("Audit.CreatedAt").Ticks%></div>
                                    <div style="display: none;"><%#Eval("Audit.LastModifiedAt").Ticks%></div>
                                    <div style="display: none;"></div>
                                    <span class="C3" id="Span1">3</span>
                                    <span class="C4">ti, 16 sep 2014 05:21:13</span>
                                    <span class="C4">ti, 16 sep 2014 05:21:14</span>
                                </li>
                                <li class="list-group-item Show<%#Eval("Active")%>">
                                    <span class="C0"><dw:Checkbox runat="server" /></span>
                                    <span class="C1"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.BarChart, True)%>"></i></span>
                                    <span class="C2">Latest visitors</span>
                                    <div style="display: none;"><%#Eval("Audit.CreatedAt").Ticks%></div>
                                    <div style="display: none;"><%#Eval("Audit.LastModifiedAt").Ticks%></div>
                                    <div style="display: none;"></div>
                                    <span class="C3" id="Span1">4</span>
                                    <span class="C4">ti, 16 sep 2014 05:21:13</span>
                                    <span class="C4">ti, 16 sep 2014 05:21:14</span>
                                </li>
                                <li class="list-group-item Show<%#Eval("Active")%>">
                                    <span class="C0"><dw:Checkbox runat="server" /></span>
                                    <span class="C1"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.BarChart, True)%>"></i></span>
                                    <span class="C2">Latest orders</span>
                                    <div style="display: none;"><%#Eval("Audit.CreatedAt").Ticks%></div>
                                    <div style="display: none;"><%#Eval("Audit.LastModifiedAt").Ticks%></div>
                                    <div style="display: none;"></div>
                                    <span class="C3" id="Span1">5</span>
                                    <span class="C4">ti, 16 sep 2014 05:21:13</span>
                                    <span class="C4">ti, 16 sep 2014 05:21:14</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </form>
            </dwc:CardBody>

            <div class="card-footer">
                <table>
                    <tr>
                        <td><span>
                            <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Widgets" />
                            :</span></td>
                        <td align="right"><span id="WidgetsCount" runat="server">10</span></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                    </tr>
                </table>
            </div>
        </dwc:Card>
        <dw:Overlay ID="actionOverlay" Message="wait" runat="server"></dw:Overlay>

        <dwc:ActionBar runat="server">
            <dw:ToolbarButton runat="server" Text="Gem" Image="NoImage" OnClientClick="sortPage.save();" ID="Save" ShowWait="False" />
            <dw:ToolbarButton runat="server" Text="Save and close" Image="NoImage" OnClientClick="sortPage.saveAndClose();" ID="SaveAndClose" ShowWait="true" />
            <dw:ToolbarButton runat="server" Text="Annuller" Image="NoImage" OnClientClick="sortPage.cancel();" ID="Cancel" ShowWait="true" />
        </dwc:ActionBar>
    </div>
</body>
</html>
