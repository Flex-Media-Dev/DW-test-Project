<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PermissionTests.aspx.vb" Inherits="Dynamicweb.Admin.PermissionTests" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <dwc:ScriptLib runat="server">
        <script type="text/javascript" src="/Admin/Content/JsLib/dw/Ajax.js"></script>
    </dwc:ScriptLib>
    <title></title>

    <script>
        function RequestInformation(getUrl, getJs, execute) {
            if (!getUrl && !getJs) {
                return;
            }

            var hasErrors = false;

            if ($('PermissionKey').value.length < 1) {
                dwGlobal.showControlErrors('PermissionKey', '<%= EmptyKeyMessage %>');
                hasErrors = true;
            } else {
                dwGlobal.hideControlErrors('PermissionKey');
            }

            if ($('PermissionName').value.length < 1) {
                dwGlobal.showControlErrors('PermissionName', '<%= EmptyNameMessage %>');
                hasErrors = true;
            } else {
                dwGlobal.hideControlErrors('PermissionName');
            }

            var selectedLevels = [];
            var checkBoxes = document.getElementsByName('PermissionLevels');
            for (var i = 0; i < checkBoxes.length; i++) {
                if (checkBoxes[i].checked) {
                    selectedLevels.push(checkBoxes[i].value);
                }
            }

            if (hasErrors) {
                return false;
            }

            var cmd = '';
            if (getUrl) {
                cmd += '<%= GetUrlActionName %>';
            }
            if (getJs) {
                cmd += ',<%= GetJavaScriptActionName %>';
            }

            Dynamicweb.Ajax.doPostBack({
                parameters: {
                    IsAjax: true,
                    CMD: cmd,
                    SelectedLevels: selectedLevels.join(',')
                },
                onComplete: function (transport) {
                    if (transport.responseText.length < 1) {
                        if (transport.statusText.length > 0 && transport.statusText !== 'success') {
                            alert(transport.statusText);
                        } else {
                            alert('Something went wrong!');
                        }
                    } else {
                        var lastGottenUrl = '';
                        var lastGottenJs = '';
                        var resultObject = JSON.parse(transport.responseText);

                        if ("JavaScript" in resultObject && resultObject.JavaScript.length > 0) {
                            lastGottenJs = resultObject.JavaScript;
                            $('JavaScriptCode').value = lastGottenJs;
                        }
                        if ("Url" in resultObject && resultObject.Url.length > 0) {
                            lastGottenUrl = resultObject.Url;
                            $('QueryString').value = lastGottenUrl;
                        }
                        if (execute && lastGottenJs.length > 0) { // open dialog
                            return (new Function(lastGottenJs))()
                        }
                    }
                }
            });
        }

        function help() {
            <%= Gui.HelpPopup("", "administration.managementcenter.designer.permissiontests") %>
        }
    </script>
</head>
<body class="area-black screen-container">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Permission tests"></dwc:CardHeader>
        <dw:Toolbar runat="server">
            <dw:ToolbarButton runat="server" Icon="Help" ID="HelpButton" OnClientClick="help();" Text="Help"></dw:ToolbarButton>
        </dw:Toolbar>
        <dwc:CardBody runat="server">
            <dw:Infobar runat="server" Type="Warning" Message="Be aware all the changes you save in the dialog will affect existing settings in the solution"></dw:Infobar>
            <form id="form1" runat="server">
                <dwc:GroupBox runat="server" Title="General">
                    <dwc:InputText runat="server" ID="PermissionTitle" Label="Title" />
                    <dwc:InputText runat="server" ID="PermissionKey" Label="Key" ValidationMessage="" />
                    <dwc:InputText runat="server" ID="PermissionName" Label="Name" ValidationMessage="" />
                    <dwc:InputText runat="server" ID="PermissionSubName" Label="Subname" />
                    <dwc:RadioGroup runat="server" ID="ShowMode" Label="Show mode" SelectedValue="">
                        <dwc:RadioButton runat="server" Label="General" FieldValue="" DoTranslation="true" />
                        <dwc:RadioButton runat="server" Label="Visibility" FieldValue="visibility" DoTranslation="true" />
                    </dwc:RadioGroup>
                    <dwc:CheckBoxGroup runat="server" ID="PermissionLevels" Name="PermissionLevels" Label="Permission levels" ValidationMessage=""></dwc:CheckBoxGroup>
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" Title="Results">
                    <dwc:InputText runat="server" ID="QueryString" Label="Query string" />
                    <dwc:InputText runat="server" ID="JavaScriptCode" Label="JavaScript" DoTranslate="false" />
                    <dwc:Button runat="server" ID="GetUrlButton" Title="Generate URL" OnClick="RequestInformation(true, true, false);" />
                    <dwc:Button runat="server" ID="OpenDialogButton" Title="Open dialog" OnClick="RequestInformation(false, true, true);" />
                </dwc:GroupBox>
            </form>
        </dwc:CardBody>
    </dwc:Card>
</body>
</html>
