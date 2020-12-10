<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PageSort.aspx.vb" Inherits="Dynamicweb.Admin.PageSort" %>

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
    <div class="dw8-container">
        <%--<dwc:BlockHeader runat="server" ID="Header">
        </dwc:BlockHeader>--%>
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Card title" ID="cardTitle"></dwc:CardHeader>
            <dw:PageBreadcrumb ID="breadcrumbControl" runat="server" />
                <form id="form1" runat="server">
                    <div id="content">
                        <div class="list">
                            <asp:Repeater ID="PagesRepeater" runat="server" EnableViewState="false">
                                <HeaderTemplate>
                                    <ul class="list-group">
                                        <li class="list-group-item">
                                            <span class="C2 sort-col" data-col-name="name">
                                                <a href="#"><%=Translate.Translate("Sidenavn")%></a>
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
                                </HeaderTemplate>

                                <ItemTemplate>
                                    <li id="Page_<%# Eval("ID") %>" class="list-group-item Show<%#Eval("Active")%>">
                                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.File, True)%>" style="display: none;"></i>
                                        <span class="C2"><%#Eval("MenuText")%></span>
                                        <div style="display: none;"><%#Eval("Audit.CreatedAt").Ticks%></div>
                                        <div style="display: none;"><%#Eval("Audit.LastModifiedAt").Ticks%></div>
                                        <div style="display: none;"></div>
                                        <span class="C3" id="Span1"><%#Eval("Sort")%>
                                        </span>
                                        <span class="C4">
                                            <%#Eval("Audit.CreatedAt", "{0:ddd, dd MMM yyyy HH':'mm':'ss}")%>
                                        </span>
                                        <span class="C4">
                                            <%#Eval("Audit.LastModifiedAt", "{0:ddd, dd MMM yyyy HH':'mm':'ss}")%>
                                        </span>
                                    </li>
                                </ItemTemplate>

                                <FooterTemplate>
                                    </ul>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </form>

            <div class="card-footer">
                <table>
                    <tr>
                        <td><span>
                            <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Sider" />
                            :</span></td>
                        <td align="right"><span id="PageCount" runat="server">7</span></td>
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
