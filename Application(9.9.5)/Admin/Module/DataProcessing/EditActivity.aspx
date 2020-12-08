<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditActivity.aspx.vb" Inherits="Dynamicweb.Admin.EditActivity" %>

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

    <style type="text/css">
        #ConsentsListContent {
            margin-bottom: 60px;
            overflow-x: auto;            
        }
    </style>
    <script type="text/javascript">        
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

        editSave = function (close) {
            if (!isValid()) {
                return false;
            }
            initiatePostBack("EditActivity", close ? "close" : "")
        }

        initiatePostBack = function (action, target) {
            var frm = document.getElementById("EditActivityForm");
            document.getElementById("PostBackAction").value = (action + ':' + target);
            frm.submit();
        }

        cancel = function () {
            Action.Execute({
                Name: "OpenScreen",
                Url: "<%= GetBackUrl() %>"
            });
        }

        deleteActivity = function () {
            if (confirm('<%=Translate.JsTranslate("Are you sure you want to delete this activity?")%>')) {
                initiatePostBack('RemoveActivity', "");
            }
        }

        editConsent = function (id) {
            var url = "EditConsent.aspx?";
            if (id != null) {
                url += "id=" + id + "&";
            }                        
            var backUrl = escape("<%= EditUrl() %>");
            url += "backUrl=" + backUrl;
            document.location = url;
        }
    </script>
</head>
<body class="screen-container">
    <form id="EditActivityForm" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbHeader" Title="Edit activity"></dwc:CardHeader>
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSave')) {{ editSave(false); }}" Text="Save" />
                <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSaveAndClose')) {{ editSave(true); }}" Text="Save and close" />
                <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Text="Cancel" Icon="Cancel" ShowWait="true" OnClientClick="cancel();" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="None" Icon="Delete" OnClientClick="deleteActivity()" Text="Delete" Visible="False" />
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dw:GroupBox runat="server" Title="Activity information" ID="GroupBox1">
                    <div class="form-group" runat="server" id="rowId" visible="false">
                        <label class="control-label"><%=Translate.Translate("Id")%></label>
                        <div>
                            <asp:Literal ID="lblId" runat="server" />
                        </div>
                    </div>
                    <dwc:InputText ID="txtName" runat="server" Label="Name" ValidationMessage="" />
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Description")%></label>
                        <div class="form-group-input">
                            <dw:Editor ID="txtDescription" name="txtDescription" CssClass="std" runat="server" />
                        </div>
                    </div>
                </dw:GroupBox>
                <dw:GroupBox runat="server" Title="Audit" ID="AuditGroupBox" Visible="false">
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Created")%></label>
                        <div>
                            <asp:Literal ID="lblCreated" runat="server" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Updated")%></label>
                        <div>
                            <asp:Literal ID="lblUpdated" runat="server" />
                        </div>
                    </div>
                </dw:GroupBox>
                <div id="ConsentsListContent">
                    <dw:GroupBox runat="server" Title="Consents" ID="ConsentsGroupBox" Visible="false">
                        <dw:List ID="ConsentsList" Personalize="true" PageSize="10" runat="server" Title="Consents" NoItemsMessage="No consents">
                        </dw:List>
                    </dw:GroupBox>
                </div>
                <asp:HiddenField ID="PostBackAction" runat="server" />
                <asp:HiddenField ID="hdBackUrl" runat="server" />
            </dwc:CardBody>
        </dwc:Card>
    </form>
    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
    </dw:Overlay>
</body>
</html>
