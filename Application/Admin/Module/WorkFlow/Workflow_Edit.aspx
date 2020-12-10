<%@ Page CodeBehind="Workflow_Edit.aspx.vb" Language="vb" AutoEventWireup="false" Inherits="Dynamicweb.Admin.Workflow_Edit" codePage="65001"%>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
	
<!DOCTYPE html>

<html>
<head>
	<title></title>
        
    <dwc:ScriptLib runat="server"></dwc:ScriptLib>
    <script type="text/javascript">
		<!--
		var WorkFlowID = '<%= WorkflowID%>';
		function Redirect() {
		    if (WorkFlowID == '0') location = 'Workflow_List.aspx';
		    else location = 'WorkflowProcedure_List.aspx?workflow=' + WorkFlowID;
		}

		function SaveForm(close) {
		    $('cmdClose').value = close ? "true" : "false";
			if (document.getElementById('AccessWorkflow').AccessWorkflowTitle.value != "") {
				document.getElementById('AccessWorkflow').submit();
			}
			else {
				alert('<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>');
				document.getElementById('AccessWorkflow').AccessWorkflowTitle.focus();
			}
		}

        function help()
        {
          return <%= Gui.Help("workflow", "modules.workflow.general.list")%>;
    	}
		//-->
	</script>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbHeader" Title="Rediger procedure"></dwc:CardHeader>

            <dw:Toolbar ID="SurveyToolbar" runat="server" ShowStart="true" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="tbSave" runat="server" OnClientClick="SaveForm();" Icon="Save" Text="Save" Divide="After"></dw:ToolbarButton>
                <dw:ToolbarButton ID="tbSaveAndClose" runat="server" OnClientClick="SaveForm(true);" Icon="Save" Text="Save and close"></dw:ToolbarButton>
                <dw:ToolbarButton ID="tbCancel" runat="server" OnClientClick="Redirect();" Icon="TimesCircle" Text="Cancel"></dw:ToolbarButton>
            </dw:Toolbar>
            <dwc:CardBody runat="server">
		        <form method="post" action="Workflow_Save.aspx<%=If(AccessWorkflowID <> 0, "?workflowid=" & AccessWorkflowID, "")%>" name="AccessWorkflow" id="AccessWorkflow">
                    <dwc:GroupBox runat="server" ID="WorkflowSettingsGroup" Title="Indstillinger">
                        <input type="hidden" name="cmdClose" id="cmdClose">
                        <div class="form-group">
                            <label class="control-label" for="AccessWorkflowTitle"><%=Translate.Translate("Navn")%></label>
                            <div class="form-group-input">
                                <input type="text" class="form-control" maxlength="80" name="AccessWorkflowTitle" value="<%=AccessWorkflowTitle%>" id="AccessWorkflowTitle" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label" for="AccessWorkflowRequiredTemplate"><%=Translate.Translate("Template - %%", "%%", Translate.Translate("Obligatorisk trin"))%></label>
                            <%=Gui.FileManager(AccessWorkflowRequiredTemplate, "Templates/Workflow", "AccessWorkflowRequiredTemplate")%>
                        </div>
                        <div class="form-group">
                            <label class="control-label" for="AccessWorkflowTitle"><%=Translate.Translate("Template - %%", "%%", Translate.Translate("Notificering"))%></label>
                            <%=Gui.FileManager(AccessWorkflowNotifyTemplate, "Templates/Workflow", "AccessWorkflowNotifyTemplate")%>
                        </div>
                    </dwc:GroupBox>
		        </form>
            </dwc:CardBody>
        </dwc:Card>
    </div>
</body>
<% Translate.GetEditOnlineScript()%>
</HTML>