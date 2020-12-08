<%@ Page CodeBehind="Workflow_List.aspx.vb" Language="vb" AutoEventWireup="false" Inherits="Dynamicweb.Admin.Workflow_List" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %><%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
		
<!DOCTYPE html>

<html>
<head>
	<title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript">

        function help(){
            <%= Gui.Help("workflow", "modules.workflow.general.list")%>;
        }

        function Workflow() {
			location.href = "Workflow_List.aspx";
		}

		function EditWorkFlow(WorkflowID) {
			location.href = "WorkflowProcedure_List.aspx?workflow=" + WorkflowID;
		}

		function DeleteWorkFlow(WorkflowID, WorkflowTitle) {
		    event.stopPropagation ? event.stopPropagation() : (event.cancelBubble = true);

			if (confirm('<%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("procedure"))%>\n(' + WorkflowTitle + ')')==true) {
				location.href = "Workflow_Del.aspx?workflow=" + WorkflowID;
			}
		}

	</script>
</head>
<body class="screen-container">
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbHeader" Title="Procedurer"></dwc:CardHeader>
            <dw:Toolbar ID="SurveyToolbar" runat="server" ShowStart="true" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="tbNewWorkflow" runat="server" OnClientClick="window.location.href = 'Workflow_Edit.aspx';" Icon="PlusSquare" Text="New workflow">
                </dw:ToolbarButton>
            </dw:Toolbar>
            <dw:List ID="lstWorkflows" HandleSortingManually="false" ShowPaging="true" ShowTitle="false" runat="server" PageSize="25" NoItemsMessage="No workflows found">
                <Columns>   
                    <dw:ListColumn ID="colProcedure" EnableSorting="true" Name="Procedure" runat="server" />
                    <dw:ListColumn ID="colSteps" ItemAlign="Center" EnableSorting="true" Name="Trin" Width="45" runat="server" />
                    <dw:ListColumn ID="colCreated" EnableSorting="true" Name="Oprettet" Width="200" runat="server" />
                    <dw:ListColumn ID="colInUse" ItemAlign="Center" HeaderAlign="Right" Name="I brug" Width="45" runat="server" />
                    <dw:ListColumn ID="colDelete" ItemAlign="Center" HeaderAlign="Right" Name="Slet" Width="45" runat="server" />
                </Columns>
            </dw:List>
        </dwc:card>
    </form>
</body>
<% Translate.GetEditOnlineScript()%>
</html>