<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditEndpointAuthentication.aspx.vb" Inherits="Dynamicweb.Admin.EditEndpointAuthentication" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeRequireJS="false" IncludeScriptaculous="false" IncludePrototype="false">
    </dw:ControlResources>
    <script src="/Admin/Resources/js/layout/dwglobal.js" type="text/javascript"></script>
    <script src="/Admin/Resources/js/layout/Actions.js" type="text/javascript"></script>
    <script type="text/javascript">
        editSave = function (close) {
            if (!isValid()) {
                return false;
            }
            initiatePostBack("EditEndpointAuthentication", close ? "close" : "")
        }

        isValid = function () {
            var result = true;
            dwGlobal.hideAllControlsErrors(null, "");
            var el = document.getElementById("txtName");
            if (!el.value) {
                dwGlobal.showControlErrors("txtName", '<%=Translate.JsTranslate("required")%>');
                result = false;
            }
            return result;
        }

        initiatePostBack = function (action, target) {
            var frm = document.getElementById("EditEndpointAuthenticationForm");
            document.getElementById("PostBackAction").value = (action + ':' + target);
            frm.submit();
        }

        cancel = function () {
            Action.Execute({
                Name: "OpenScreen",
                Url: "<%= GetBackUrl() %>"
            });
        }

        deleteAuthentication = function () {
            if (confirm('<%=Translate.JsTranslate("Are you sure you want to delete this authentication?")%>')) {
                initiatePostBack('RemoveEndpointAuthentication', "");
            }
        }

        typeChange = function (obj) {
            var selectBox = obj;
            var selected = selectBox.options[selectBox.selectedIndex].value;
            hideParameters();
            if (selected === 'Basic') {
                $('BasicParameters').show();
            } else if (selected === 'Ntlm') {
                $('NtlmParameters').show();
            } else if (selected === 'WebServiceAccessKey') {
                $('WebServiceAccessKey').show();
            }
        }

        function hideParameters() {
            $('BasicParameters').hide();
            $('WebServiceAccessKey').hide();
            $('NtlmParameters').hide();
        }

        function onload() {
            //hideParameters();
            typeChange($('ddlType'));
        }
    </script>
</head>
<body class="screen-container" onload="onload();">
    <form id="EditEndpointAuthenticationForm" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbHeader" Title="Edit authentication"></dwc:CardHeader>
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSave')) {{ editSave(false); }}" Text="Save" />
                <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSaveAndClose')) {{ editSave(true); }}" Text="Save and close" />
                <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Text="Cancel" Icon="Cancel" ShowWait="true" OnClientClick="cancel();" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="None" Icon="Delete" OnClientClick="deleteAuthentication()" Text="Delete" Visible="False" />
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dw:GroupBox runat="server" Title="Authentication information" ID="GroupBox1">
                    <div class="form-group" runat="server" id="rowId" visible="false">
                        <label class="control-label"><%=Translate.Translate("Id")%></label>
                        <div>
                            <asp:Literal ID="lblId" runat="server" />
                        </div>
                    </div>
                    <dwc:InputText ID="txtName" runat="server" Label="Name" ValidationMessage="" MaxLength="255" />
                    <div class="form-group">
                        <label class="control-label">
                            <dw:TranslateLabel runat="server" Text="Type" />
                        </label>
                        <div class="btn-group bootstrap-select">
                            <select id="ddlType" name="ddlType" runat="server" class="std" onchange="typeChange(this)">
                            </select>
                        </div>
                    </div>
                    <div id="BasicParameters" runat="server">
                        <dwc:InputText ID="UserName" runat="server" Label="User Name" />
                        <dwc:InputText Password="true" ID="Password" runat="server" Label="Password" />                        
                    </div>
                    <div id="WebServiceAccessKey" runat="server">
                        <dwc:InputText ID="WsUserName" runat="server" Label="User Name" />
                        <dwc:InputText ID="WsAccessKey" runat="server" Label="Web Service Access Key" />
                    </div>
                    <div id="NtlmParameters" runat="server">
                        <dwc:InputText ID="NtlmUserName" runat="server" Label="User Name" />
                        <dwc:InputText Password="true" ID="NtlmPassword" runat="server" Label="Password" />
                        <dwc:InputText ID="NtlmDomain" runat="server" Label="Domain" />
                    </div>
                </dw:GroupBox>
                <asp:HiddenField ID="PostBackAction" runat="server" />
                <asp:HiddenField ID="hdBackUrl" runat="server" />
            </dwc:CardBody>
        </dwc:Card>
    </form>
    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
    </dw:Overlay>
</body>
</html>
