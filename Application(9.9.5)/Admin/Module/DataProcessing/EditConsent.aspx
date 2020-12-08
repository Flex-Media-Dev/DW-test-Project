<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditConsent.aspx.vb" Inherits="Dynamicweb.Admin.EditConsent" %>

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
        initiatePostBack = function (action, target) {
            var frm = document.getElementById("EditConsentForm");
            document.getElementById("PostBackAction").value = (action + ':' + target);
            frm.submit();
        }

        cancel = function () {
            Action.Execute({
                Name: "OpenScreen",
                Url: "<%= GetBackUrl() %>"
            });
        }

        deleteConsent = function () {
            if (confirm('<%=Translate.JsTranslate("Are you sure you want to delete this Consent?")%>')) {
                initiatePostBack('RemoveConsent', "");
            }
        }
    </script>
</head>
<body class="screen-container">
    <form id="EditConsentForm" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbHeader" Title="Consent"></dwc:CardHeader>
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                 <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" icon="Cancel" Text="Cancel" ShowWait="true" OnClientClick="cancel();" />
                <dw:ToolbarButton ID="ConsentDelete" runat="server" Divide="None" Icon="Delete" OnClientClick="deleteConsent()" Text="Delete" />
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dw:GroupBox runat="server" Title="Consent information" ID="GroupBox1">
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Activity Id")%></label>
                        <div>
                            <asp:Literal ID="lblConsentActivityId" runat="server" />
                        </div>
                    </div>    
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Subject Id")%></label>
                        <div>
                            <asp:Literal ID="lblConsentSubjectId" runat="server" />
                        </div>
                    </div>    
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Subject Type")%></label>
                        <div>
                            <asp:Literal ID="lblConsentSubjectType" runat="server" />
                        </div>
                    </div>    
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Status")%></label>
                        <div>
                            <asp:Literal ID="lblConsentStatus" runat="server" />
                        </div>
                    </div>                        
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Checksum")%></label>
                        <div>
                            <asp:Literal ID="llbConsentChecksum" runat="server" />
                        </div>
                    </div>    
                </dw:GroupBox>
                <dw:GroupBox runat="server" Title="Consent request information" ID="GroupBox2">
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Url")%></label>
                        <div>
                            <asp:Literal ID="lblConsentRequestUrl" runat="server" />
                        </div>
                    </div>    
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("User Host Address")%></label>
                        <div>
                            <asp:Literal ID="lblConsentRequestUserHostAddress" runat="server" />
                        </div>
                    </div>    
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("UserAgent")%></label>
                        <div>
                            <asp:Literal ID="lblConsentRequestUserAgent" runat="server" />
                        </div>
                    </div>    
                </dw:GroupBox>
                <dw:GroupBox runat="server" Title="Audit" ID="AuditGroupBox">
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
                <asp:HiddenField ID="PostBackAction" runat="server" />
                <asp:HiddenField ID="hdBackUrl" runat="server" />
            </dwc:CardBody>
        </dwc:Card>
    </form>
  <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
    </dw:Overlay>
</body>
</html>
