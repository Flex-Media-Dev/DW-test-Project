<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ContentRestrictionEdit.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Profiles.ContentRestrictionEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" TagName="ContentRestrictionEditor" Src="~/Admin/Module/OMC/Controls/ContentRestrictionEditor.ascx" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />

    <title>
        <dw:TranslateLabel ID="lbTitle" Text="Content restriction edit" runat="server" />
    </title>
    <dw:ControlResources ID="ctrlResources" runat="server" />

    <style type="text/css">
        html, body {
            margin: 0px;
            padding: 0px;
            border-right: none !important;
            height: auto;
        }
    </style>

    <script type="text/javascript">
        var w = null;
        var editorObj = null;
        var editor = '<%=EditorClientInstanceName%>';

        var frame = window.frameElement;
        var container = $(frame).up('div.omc-marketing-configuration');
        parent.dialog.set_okButtonOnclick(container, function () {
            if (!editorObj) {
                try {
                    editorObj = eval(editor);
                } catch (ex) { }
            }
            if (editorObj) {
                editorObj.validate(function (isValid) {
                    if (isValid) {
                        editorObj.save();
                    } else {
                        alert(editorObj.get_lastError());
                    }
                });
            }
        });
    </script>
</head>

<body>
    <form id="MainForm" runat="server">
        <omc:ContentRestrictionEditor ID="restrictionEditor" runat="server" />
    </form>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
