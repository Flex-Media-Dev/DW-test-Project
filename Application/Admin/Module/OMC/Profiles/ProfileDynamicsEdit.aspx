<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ProfileDynamicsEdit.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Profiles.ProfileDynamicsEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" TagName="ProfileDynamicsEditor" Src="~/Admin/Module/OMC/Controls/ProfileDynamicsEditor.ascx" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />

    <title>
        <dw:TranslateLabel ID="lbTitle" Text="Profile dynamics edit" runat="server" />
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
        <omc:ProfileDynamicsEditor ID="dynamicsEditor" runat="server" />
    </form>

    <script type="text/javascript">
        var editor = '<%=EditorClientInstanceName%>';
    </script>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
