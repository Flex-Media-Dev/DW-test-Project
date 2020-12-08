<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="FrontendEditing.aspx.vb" Inherits="Dynamicweb.Admin.FrontendEditing" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb.Frontend" %>
<!DOCTYPE html>
<html>
<% If Request("close") = "true" AndAlso FrontendEditing.FrontendEditingState = FrontendEditing.FrontendEditingStates.Disabled Then%>
<head>
    <script>
        try { close(); } catch(ex) {}
        <% If (pageID > 0) Then%>
        location.href = "/Default.aspx?ID=<%=pageID%>";
        <%End If%>
    </script>
</head>
<body></body>
<% Else%>
<head runat="server">
    <title>Frontend Editing</title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludePrototype="false" IncludeUIStylesheet="true" CombineOutput="false" IncludeScriptaculous="false" IncludejQuery="true">
    </dw:ControlResources>
    <link href="/Admin/Resources/css/fonts.min.css" rel="stylesheet">
    <link href="/Admin/Resources/css/main.min.css" rel="stylesheet">
    <link href="FrontendEditing.css" rel="stylesheet" />
    <script>
        var dwFrontendEditing = {};

		<%
        Dim messages As New Generic.Dictionary(Of String, String)()
        For Each message As String In New String() {
                "Inline editing enabled",
                "Inline editing disabled",
                "Frontend editing ready",
                "Saving content …",
                "Save failed",
                "Content saved",
                "Save changes?",
                "You have unsaved changes",
                "Save changes",
                "Return to editor",
                "Discard changes"
            }
            messages(message) = Translate.JsTranslate(message)
        Next
		%>

        dwFrontendEditing.messages = <%= Converter.SerializeCompact(messages) %>;
    </script>
    <script type="text/javascript" src="FrontendEditing.js"></script>
</head>
<body>
    <div id="topbar">
        <div class="Toolbar">
            <ul>
                <li>
                    <a id="btn-close" class="btn btn-link toolbar-button" href="#">
                        <span class="toolbar-button-container">
                            <i class="<%= Dynamicweb.Core.UI.Icons.KnownIconInfo.ClassNameFor(Dynamicweb.Core.UI.Icons.KnownIcon.Remove) %>"></i>
                            <%= Translate.Translate("Close Frontend editing") %>
                        </span>
                    </a>
                </li>
                <li>
                    <span class="ribbon-section-form-checkbox">
                        <input class="checkbox" type="checkbox" <%= IIf(FrontendEditing.FrontendEditingState = FrontendEditing.FrontendEditingStates.Edit, " checked", "")%> id="toggle-editing" />
                        <label for="toggle-editing"><%= Translate.Translate("Enable inline editing") %></label>
                    </span>
                </li>
                <li class="help">
                    <a id="btn-help" class="btn btn-link toolbar-button" title="Help" href="#">
                        <span class="toolbar-button-container">
                            <i class="<%= Dynamicweb.Core.UI.Icons.KnownIconInfo.ClassNameFor(Dynamicweb.Core.UI.Icons.KnownIcon.Help) %>"></i>
                            <%= Translate.Translate("Help") %>
                        </span>
                    </a>
                </li>
            </ul>
            <div id="status" class="fade">
                <div class="content"></div>
            </div>
        </div>
        <div class="version-info"><%= Translate.Translate("Frontend Editing Draft")%></div>
    </div>

    <div id="content" style="display: none">
        <% If pageID > 0 Then
                Dim editingState As String = "disable"
                Select Case FrontendEditing.FrontendEditingState
                    Case FrontendEditing.FrontendEditingStates.Browse
                        editingState = "browse"
                    Case FrontendEditing.FrontendEditingStates.Edit
                        editingState = "edit"
                End Select

                Dim queryString = HttpUtility.ParseQueryString("")
                queryString("ID") = pageID
                queryString("FrontendEditingState") = editingState
        %>
        <iframe src="/Default.aspx?<%= queryString.ToString()%>" id="contentFrame" style="border: none" frameborder="0"></iframe>
        <% Else%>
		Invalid page ID: <%= pageID%>
        <% End If%>
    </div>

    <span id="mSaveChanges" style="display: none">
        <dw:TranslateLabel ID="lbSaveChanges" Text="Save changes before reloading?" runat="server" />
    </span>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>

    <%--@*main dialog*@--%>
    <div class="dialog-iframe-container" data-dialog-level="1">
        <iframe src="" class="dialog iframe-closed"></iframe>
        <div class="modal-backdrop overlay-container">
            <div class="overlay-panel"><i class="fa fa-refresh fa-3 fa-spin"></i></div>
        </div>
    </div>
    <%--@*sub dialog of main*@--%>
    <div class="dialog-iframe-container" data-dialog-level="2">
        <iframe src="" class="dialog iframe-closed"></iframe>
        <div class="modal-backdrop overlay-container">
            <div class="overlay-panel"><i class="fa fa-refresh fa-3 fa-spin"></i></div>
        </div>
    </div>
    <%--@*sub sub dialog of main*@--%>
    <div class="dialog-iframe-container" data-dialog-level="3">
        <iframe id="main-dialog" src="" class="dialog iframe-closed"></iframe>
        <div class="modal-backdrop overlay-container">
            <div class="overlay-panel"><i class="fa fa-refresh fa-3 fa-spin"></i></div>
        </div>
    </div>
</body>
<%End If%>
</html>
