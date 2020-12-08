<%@ Page CodeBehind="WorkflowProcedure_Edit.aspx.vb" Language="vb" AutoEventWireup="false" Inherits="Dynamicweb.Admin.WorkflowProcedure_Edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html>
<head>
    <title></title>

    <dwc:ScriptLib runat="server"></dwc:ScriptLib>
    <script type="text/javascript">
	<!--
    function help() {
        return <%= Gui.Help("workflow", "modules.workflow.general.list.item.edit")%>;
        }

        function WorkflowShowUserType_OnClick() {
            if (document.getElementById('WorkFlowUser').WorkflowShowUserType[1].checked) {
                document.all("WorkflowUserSelect_User").style.display = "none";
                document.all("WorkflowUserSelect_Group").style.display = "";
                document.getElementById("UserTypeLabel").innerText = '<%= Translate.Translate("Group") %>';
            }
            else {
                document.all("WorkflowUserSelect_User").style.display = "";
                document.all("WorkflowUserSelect_Group").style.display = "none";
                document.getElementById("UserTypeLabel").innerText = '<%= Translate.Translate("Bruger") %>';
            }
        }

        function WorkFlowUser_Save(close) {
            var groupSelected = document.getElementById('WorkFlowUser').WorkflowShowUserType[1].checked;
            var list = $("AccessWorkflowUserUserID_User");
            if (groupSelected) {
                list = $("AccessWorkflowUserUserID_Group");
            }
            if (list != null && list.selectedIndex == 0) {
                if (groupSelected) {
                    $('InfoBar_GroupWarningBar').removeClassName('hidden');                    
                }
                else {
                    $('InfoBar_UserWarningBar').removeClassName('hidden');
                }
                return false;
            }
            $('cmdClose').value = close ? "true" : "false";
            $('cmd').value = "save";
            $('WorkFlowUser').submit();
        }

        function Redirect() {
            <%="location = 'WorkflowProcedure_List.aspx?workflow=" & WorkflowID & "'" %>
        }

        document.observe('dom:loaded', function () {
            $('InfoBar_UserWarningBar').className = 'hidden';
            $('InfoBar_GroupWarningBar').className = 'hidden';
            var userType = <%=If(AccessWorkflowUserUserID_User = True, "0", "1")%>;
            document.getElementById('WorkFlowUser').WorkflowShowUserType[userType].checked = true;
            WorkflowShowUserType_OnClick();
        });
	//-->
    </script>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbHeader" Title="Rediger deltager"></dwc:CardHeader>
            <dw:Toolbar ID="SurveyToolbar" runat="server" ShowStart="true" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="tbSave" runat="server" OnClientClick="WorkFlowUser_Save();" Icon="Save" Text="Save" Divide="After"></dw:ToolbarButton>
                <dw:ToolbarButton ID="tbSaveAndClose" runat="server" OnClientClick="WorkFlowUser_Save(true);" Icon="Save" Text="Save and close"></dw:ToolbarButton>
                <dw:ToolbarButton ID="tbCancel" runat="server" OnClientClick="Redirect();" Icon="TimesCircle" Text="Cancel"></dw:ToolbarButton>
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <form method="post" name="WorkFlowUser" id="WorkFlowUser">
                    <input type="hidden" name="AccessWorkflowUserWorkflowID" value="<%=WorkflowID%>">
                    <input type="hidden" name="procedureId" id="procedureId" value="<%=WorkflowProcedureID%>" />
                    <input type="hidden" name="cmdClose" id="cmdClose">
                    <input type="hidden" name="cmd" id="cmd" />
                    <dwc:GroupBox runat="server" ID="WorkflowUserSettingsGroup" Title="Indstillinger">
                        <dwc:RadioGroup runat="server" ID="WorkflowShowUserType" Label="Type">
                            <dwc:RadioButton FieldValue="user" Label="Bruger" runat="server" OnClick="WorkflowShowUserType_OnClick();" />
                            <dwc:RadioButton FieldValue="group" Label="Gruppe" runat="server" OnClick="WorkflowShowUserType_OnClick();" />
                        </dwc:RadioGroup>
                        <div class="form-group">
                            <label class="control-label" for="AccessWorkflowUserUserID_User" id="UserTypeLabel"></label>
                            <div id="WorkflowUserSelect_User" style="display: block">
                                <select class="selectpicker" id="AccessWorkflowUserUserID_User" name="AccessWorkflowUserUserID_User">
                                    <%=GetUserList()%>
                                </select>
                                <div style="margin-left:180px">
                                    <dw:Infobar ID="UserWarningBar" runat="server" Type="Warning" Message="Select user from the list" TranslateMessage="true" />
                                </div>
                            </div>
                            <div id="WorkflowUserSelect_Group" style="display: none">
                                <select class="selectpicker" id="AccessWorkflowUserUserID_Group" name="AccessWorkflowUserUserID_Group">
                                    <%=GetGroupList()%>
                                </select>
                                <div style="margin-left:180px">
                                    <dw:Infobar ID="GroupWarningBar" runat="server" Type="Warning" Message="Select group from the list" TranslateMessage="true" />
                                </div>
                            </div>
                        </div>
                    </dwc:GroupBox>
                    <dwc:GroupBox runat="server" ID="WorkflowRoleGroup" Title="Godkendelse">
                        <div class="form-group">
                            <dwc:SelectPicker runat="server" ID="AccessWorkflowUserRole" Label="Rolle">
                            </dwc:SelectPicker>
                        </div>
                        <div class="form-group">
                            <dwc:CheckBox ID="AccessWorkflowUserRequired" Label="Krævet" Value="1" runat="server" />
                        </div>
                        <div class="form-group">
                            <dwc:CheckBox ID="AccessWorkflowUserNotify" Label="Notificer" Value="1" runat="server" />
                        </div>
                    </dwc:GroupBox>
                </form>
            </dwc:CardBody>
        </dwc:Card>
    </div>
</body>
</html>
<% Translate.GetEditOnlineScript()%>