<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ContentBuilder.aspx.vb" Inherits="Dynamicweb.Admin.ContentBuilder" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>

    <dw:ControlResources ID="ControlResources1" IncludePrototype="false" IncludeScriptaculous="false" runat="server" IncludejQuery="false" IncludeRequireJS="false" CombineOutput="false">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Link.js" />
        </Items>
    </dw:ControlResources>

    <link rel="stylesheet" href="/Admin/Resources/css/content.min.css" />
    <link rel="stylesheet" href="ContentBuilder.css?v=3" />
    <script type="text/javascript" src="ContentBuilder.js?v=4"></script>
</head>
<body class="boxed-fields sw-toggled">
    <div class="action-menu">
    <a href="javascript:void(0);" onclick="ContentBuilder.rotatePreviewFrame()" class="back-to-content-btn rotate-preview-btn" title="<%=Translate.Translate("Portrait/landscape mode") %>">
        <img src='/Admin/Public/PreviewRotation.svg' style='height: 30px; width: 30px;'>
    </a>
    <% If Request("popout") Is Nothing %>
        <% If Dynamicweb.Security.UserManagement.User.GetCurrentBackendUser().IsAngel Then %>
        <a href="javascript:void(0);" onclick="ContentBuilder.popEditorOut()" class="back-to-content-btn" ><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.ExternalLink, True)%>"></i> <dw:TranslateLabel runat="server" Text="Pop out" /></a>
        <% End If %>
        <a href="javascript:void(0);" onclick="ContentBuilder.closeVisualEditor()" class="back-to-content-btn" ><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Clear, True)%>"></i> <dw:TranslateLabel runat="server" Text="Close Visual Editor" /></a>
    <% End If %>
    </div>

    <aside id="sidebar" class="sw-toggled">
        <div class="sidebar-header-actions">
           <dw:TranslateLabel Text="Visual Editor" runat="server" />
        </div>
        <button type="button" class="sidebar-toggle-btn"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.CaretLeft, True)%>"></i></button>
        <div id="fixed-sidebar">
            <div class="toolbar">
                <div class="toolbar-menu">
                    <div class="toolbar-tab toolbar-tab-rows" onclick="ContentBuilder.showRowSelector()"><dw:TranslateLabel runat="server" Text="Rows" /></div>
                    <div class="toolbar-tab toolbar-tab-columns" onclick="ContentBuilder.showColumnSelector()"><dw:TranslateLabel runat="server" Text="Columns" /></div>
                </div>
                <div class="toolbar-filter"> 
                    <div class="toolbar-filter-wrapper">
                        <input type="text" id="filter" name="filter" placeholder="<%=Translate.Translate("Search") %>" />
                        <i class="fa fa-search pull-right"></i>
                    </div>
                </div>
                <div class="toolbar-container">
                    <div class="toolbar-new-row">
                    </div>
                    <div class="toolbar-new-column">
                    </div>
                </div>
                <div class="toolbar-preview-menu">
                    <button class="toolbar-preview-menu__btn" onclick="ContentBuilder.showPreview('Desktop', 0, 0)">
                        <span class="icon"><i class="fa fa-desktop"></i></span>
                        <%=Translate.Translate("Desktop")%>
                        <span class="pull-right"><%=Translate.Translate("Default preview")%></span>
                    </button>
                    <button class="toolbar-preview-menu__btn" onclick="ContentBuilder.showPreview('Tablet', 980, 1024)">
                        <span class="icon"><i class="fa fa-tablet"></i></span>
                        <%=Translate.Translate("Tablet")%>
                        <span class="pull-right">980 🗴 1024</span>
                    </button>
                    <button class="toolbar-preview-menu__btn" onclick="ContentBuilder.showPreview('Tablet', 768, 1024)">
                        <span class="icon"><i class="fa fa-tablet"></i></span>
                        <%=Translate.Translate("Tablet")%>
                        <span class="pull-right">768 🗴 1024</span>
                    </button>
                    <button class="toolbar-preview-menu__btn" onclick="ContentBuilder.showPreview('Mobile', 360, 640)">
                        <span class="icon"><i class="fa fa-mobile"></i></span> 
                        <%=Translate.Translate("Mobile")%>
                        <span class="pull-right">360 🗴 640</span>
                    </button>
                </div>
                <div class="toolbar-footer-actions">
                    <a onclick="ContentBuilder.showPage()" class="toolbar-footer-actions__btn" title="<%=Translate.Translate("Show page")%>"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Pageview, True)%>" style="font-size: 26px"></i></a>
                    <button class="toolbar-footer-actions__btn" onclick="ContentBuilder.showPreviewMenu()" title="<%=Translate.Translate("Responsive preview")%>"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Desktop, True)%>"></i></button>
                    <button class="toolbar-footer-actions__btn" onclick="ContentBuilder.navigate()" title="<%=Translate.Translate("Select another page")%>"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Sitemap, True)%>"></i></button>
                </div>
            </div>
        </div>
    </aside>

    <section class="b-container">
        <div id="content-container" class="frame-container">
            <iframe class="view-port"></iframe>
        </div>
    </section>

    <dw:Dialog runat="server" ID="dlgEditParagraph" HidePadding="true" Title="Edit column" Size="Large" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" CancelAction="dialog.hide('dlgEditParagraph')" OkAction="ContentBuilder.saveColumn()">
        <dw:Toolbar ID="Toolbar" runat="server">
            <dw:ToolbarButton ID="rbtnItem" runat="server" Divide="None" Image="NoImage" Text="Item" OnClientClick="ContentBuilder.switchColumnEditMode(2)" />                
            <dw:ToolbarButton ID="rbtnModule" runat="server" Divide="None" Image="NoImage" Text="App" OnClientClick="ContentBuilder.switchColumnEditMode(1)" />
        </dw:Toolbar>
        <iframe id="dlgEditParagraphFrame" style="width: 100%;"></iframe>
    </dw:Dialog>

    <dw:Dialog runat="server" ID="dlgEditGridRow" HidePadding="true" Title="Edit row" Size="Large" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" CancelAction="dialog.hide('dlgEditGridRow')" OkAction="ContentBuilder.saveRow()">
        <iframe id="dlgEditGridRowFrame" style="width: 100%;"></iframe>
    </dw:Dialog>

    <dw:Dialog runat="server" ID="dlgSaveAsTemplate" Size="Medium" Title="Save row as template" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" CancelAction="dialog.hide('dlgSaveAsTemplate')" OkAction="ContentBuilder.saveAsTemplate()">
        <iframe id="dlgSaveAsTemplateFrame" style="width: 100%;"></iframe>
    </dw:Dialog>

    <dw:Dialog runat="server" ID="dlgSaveColumnAsTemplate" Size="Medium" Title="Save column as template" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" CancelAction="dialog.hide('dlgSaveColumnAsTemplate')" OkAction="ContentBuilder.saveColumnAsTemplate()">
        <iframe id="dlgSaveColumnAsTemplateFrame" style="width: 100%;"></iframe>
    </dw:Dialog>

    <dw:Dialog runat="server" ID="dlgLinkParagraph" Title="Link paragraph" Size="Small" ShowOkButton="false" ShowCancelButton="true" ShowClose="false" CancelText="Close" CancelAction="dialog.hide('dlgLinkParagraph')">
        <div class="link-paragraph-container"></div>
    </dw:Dialog>

    <dw:Overlay ID="wait" runat="server" Message="Loading page - please wait..." ShowWaitAnimation="True"></dw:Overlay>
    <dw:Overlay ID="spinner" runat="server" Message="Please wait..." ShowWaitAnimation="True"></dw:Overlay>

    <script src="/Admin/Resources/js/jquery-2.1.1.min.js"></script>
    <script src="/Admin/Resources/vendors/waves/waves.min.js"></script>
    <script src="/Admin/Resources/js/layout/content-functions.js"></script>

    <script>
        var translations = {
            "Drag this": "<%=Translate.Translate("Drag this") %>",
            "Edit row": "<%=Translate.Translate("Edit row") %>",
            "Edit column": "<%=Translate.Translate("Edit column") %>",
            "Save row as template": "<%=Translate.Translate("Save row as template") %>",
            "Save column as template": "<%=Translate.Translate("Save column as template") %>",
            "Delete row": "<%=Translate.Translate("Delete row") %>",
            "Delete column": "<%=Translate.Translate("Delete column") %>",
            "Drag column here": "<%=Translate.Translate("Drag column here") %>",
            "Link paragraph": "<%=Translate.Translate("Link paragraph") %>",
            "Unlink paragraph": "<%=Translate.Translate("Unlink paragraph") %>",
            "No paragraps available": "<%=Translate.Translate("No paragraps available") %>",
            "Required": "<%=Translate.Translate("Required") %>",
            "Publication period": "<%=Translate.Translate("Publication period") %>",
            "Hidden for desktops": "<%=Translate.Translate("Hidden for desktops") %>",
            "Hidden for phones": "<%=Translate.Translate("Hidden for phones") %>",
            "Hidden for tablets": "<%=Translate.Translate("Hidden for tablets") %>"
        };
        ContentBuilder.initializeEditor(<%=pageId%>, <%=If(isAdmin, "true", "false")%>, translations);
    </script>
</body>
</html>