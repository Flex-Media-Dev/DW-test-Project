<%@ Page CodeBehind="WorkflowProcedure_List.aspx.vb" Language="vb" AutoEventWireup="false" Inherits="Dynamicweb.Admin.WorkflowProcedure_List" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %><%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
	
<!DOCTYPE html>

<html>
<head>
	<title></title>
        
    <dwc:ScriptLib runat="server">
        <link rel="/Admin/Resources/css/dw8stylefix.css" type="text/css" />
    </dwc:ScriptLib>
    <script type="text/javascript">
	<!--
        var WorkFlowID =<%= WorkflowID%>;

	    function help()
        {
            return <%=Gui.Help("workflow", "modules.workflow.general.list")%>;
	    }

        function DeleteWorkflowProcedure(WorkflowProcedureID, WorkflowProcedureName) {
		    if (confirm('<%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("deltager"))%>\n(' + WorkflowProcedureName +')')==true) {
			    location.href = "WorkflowProcedure_List.aspx?cmd=delete&workflow=<%=WorkflowID%>&procedureid=" + WorkflowProcedureID;
		    }
        }

        function sortdown(procedureID) {
            location = 'WorkflowProcedure_List.aspx?cmd=sort&MoveDirection=down&workflow=<%=WorkflowID%>&procedureid=' + procedureID;
        }

        function sortup(procedureID) {
            location = 'WorkflowProcedure_List.aspx?cmd=sort&MoveDirection=up&workflow=<%=WorkflowID%>&procedureid=' + procedureID;
        }

        function toggleRequired(procedureID) {
            location = 'WorkflowProcedure_List.aspx?cmd=ToggleRequired&workflow=<%=WorkflowID%>&procedureid=' + procedureID;
        }

        function toggleNotify(procedureID) {
            location = 'WorkflowProcedure_List.aspx?cmd=ToggleNotify&workflow=<%=WorkflowID%>&procedureid=' + procedureID;
        }
	//-->
	</script>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbHeader" Title="Procedure"></dwc:CardHeader>

            <dw:Toolbar ID="SurveyToolbar" runat="server" ShowStart="true" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="tbStart" runat="server" OnClientClick="window.location.href = 'Workflow_List.aspx';" Icon="Home" Text="Start" Divide="After">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="tNewParticipant" runat="server" OnClientClick="window.location.href = 'WorkflowProcedure_Edit.aspx?workflow='+WorkFlowID;" Icon="Cog" Text="New participant">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="tEditSurvey" runat="server" OnClientClick="window.location.href = 'Workflow_Edit.aspx?workflowid='+WorkFlowID;" Icon="Pencil" Text="Edit workflow">
                </dw:ToolbarButton>
            </dw:Toolbar>
            <dw:List runat="server" ID="ParticipantsList" RenderWithDiv="true" ShowTitle="false">
                <Columns>
                    <dw:ListColumn runat="server" ID="UserNameCol" Name="Name" />
                    <dw:ListColumn runat="server" ID="RoleCol" Name="Role" />
                    <dw:ListColumn runat="server" ID="SortingCol" Name="Sorting" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn runat="server" ID="RequiredCol" Name="Required" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn runat="server" ID="NotifyCol" Name="Notify" HeaderAlign="Center" ItemAlign="Center" />
                    <dw:ListColumn runat="server" ID="DeleteCol" Name="Delete" HeaderAlign="Center" ItemAlign="Center" />
                </Columns>
            </dw:List>
        </dwc:Card>
    </div>
	</body>
<%Translate.GetEditOnlineScript()%>
</html>
