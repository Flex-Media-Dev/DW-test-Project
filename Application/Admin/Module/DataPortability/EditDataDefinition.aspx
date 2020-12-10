<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditDataDefinition.aspx.vb" Inherits="Dynamicweb.Admin.EditDataDefinition" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
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
        isValid = function () {
            var result = true;
            dwGlobal.hideAllControlsErrors(null, "");
            var el = document.getElementById("txtName");
            if (!el.value) {
                dwGlobal.showControlErrors("txtName", '<%=Translate.JsTranslate("required")%>');
                result = false;
            } else {
                if (!el.value.match(/[a-z0-9]/i)) {
                    dwGlobal.showControlErrors("txtName", '<%=Translate.JsTranslate("Letters or numbers required")%>');
                    result = false;
                }
            }
            return result;
        }

        editSave = function (close) {
            if (!isValid()) {
                return false;
            }
            initiatePostBack("Edit", close ? "close" : "")
        }

        initiatePostBack = function (action, target) {
            var frm = document.getElementById("EditDataDefinitionForm");
            document.getElementById("PostBackAction").value = (action + ':' + target);
            frm.submit();
        }

        cancel = function () {
            parent.submitReload("DataDefinition", '<%=CurrentDataDefinitionId%>');            
        }

        deleteDataDefinition = function () {
            if (confirm('<%=Translate.JsTranslate("Are you sure you want to delete this data definition?")%>')) {
                initiatePostBack('Remove', "");
            }
        }   

        if ('<%=Converter.ToBoolean(Dynamicweb.Context.Current.Request("refresh")) %>' == 'True') {
            parent.submitReload("DataDefinition", '<%=Dynamicweb.Context.Current.Request("id")%>', '<%=Dynamicweb.Context.Current.Request("edit")%>');
        }
    </script>
</head>
<body class="screen-container">
    <form id="EditDataDefinitionForm" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbHeader" Title="Edit data definition"></dwc:CardHeader>
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSave')) {{ editSave(false); }}" Text="Save" />
                <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSaveAndClose')) {{ editSave(true); }}" Text="Save and close" />
                <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Text="Cancel" Icon="Cancel" ShowWait="true" OnClientClick="cancel();" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="None" Icon="Delete" OnClientClick="deleteDataDefinition()" Text="Delete" Visible="False" />
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dw:GroupBox runat="server" Title="Data definition information" ID="GroupBox1">
                    <div class="form-group" runat="server" id="rowId" visible="false">
                        <label class="control-label"><%=Translate.Translate("Id")%></label>
                        <div>
                            <asp:Literal ID="lblId" runat="server" />
                        </div>
                    </div>
                    <dwc:InputText ID="txtName" runat="server" Label="Name" ValidationMessage="" MaxLength="255" />                    
                </dw:GroupBox>
               
                <asp:HiddenField ID="PostBackAction" runat="server" />                
            </dwc:CardBody>
        </dwc:Card>
    </form>
    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
    </dw:Overlay>
</body>
</html>
