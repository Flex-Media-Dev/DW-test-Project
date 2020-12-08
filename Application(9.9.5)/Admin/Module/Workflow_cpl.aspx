<%@ Page Language="vb" AutoEventWireup="false" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<html>
<head>
    <title><%=Translate.JsTranslate("Kontrol Panel - %%","%%",Translate.JsTranslate("Godkendelse",9))%></title>
</head>
<body>
    <script>
        function OK_OnClick() {
            document.getElementById('frmGlobalSettings').submit();
        }

        function findCheckboxNames(form) {
            var _names = "";
            for (var i = 0; i < form.length ; i++) {
                if (form[i].name != undefined) {
                    if (form[i].type == "checkbox") {
                        _names = _names + form[i].name + "@"
                    }
                }
            }
            form.CheckboxNames.value = _names;
        }
    </script>
    <%=Dynamicweb.SystemTools.Gui.MakeHeaders(Translate.Translate("Kontrol Panel - %%","%%",Translate.Translate("Godkendelse",9)),Translate.Translate("Konfiguration"), "all")%>

    <table border="0" cellpadding="0" cellspacing="0" class="tabTable">
        <form method="post" action="ControlPanel_Save.aspx" name="frmGlobalSettings" id="frmGlobalSettings">
            <input type="hidden" name="CheckboxNames">
        <tr>
            <td valign="top">
                <table border="0" cellpadding="5" cellspacing="0" width="95%">
                    <tr>
                        <td></td>
                        <td height="50" width="38">
                            <%=Dynamicweb.Core.UI.Icons.KnownIconInfo.GetIconHtml(Dynamicweb.Core.UI.Icons.KnownIcon.Gear) %></td>
                    </tr>
                </table>
                <%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Godkendelse"))%>
                <table border="0" cellpadding="2" cellspacing="0">

                    <tr>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="170"><%=Translate.Translate("Standard type")%></td>
                        <td>
                            <%  Dim ApprovalType as integer = Converter.ToInt32(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/VersionControl/ApprovalType"))
                            %>
                            <select class="std" name="/Globalsettings/Modules/VersionControl/ApprovalType" id="/Globalsettings/Modules/VersionControl/ApprovalType">
                                <option value="0" <%=If(ApprovalType = 0, "SELECTED", "")%>><%=Translate.JsTranslate("ingen")%></option>
                                <option value="-1" <%=If(ApprovalType = -1, "SELECTED", "")%>><%=Translate.JsTranslate("Strakspublicer")%></option>
                                <option value="-3" <%=If(ApprovalType = -3, "SELECTED", "")%>><%=Translate.JsTranslate("Strakspublicer (m/ versionering)")%></option>
                                <option value="-2" <%=If(ApprovalType = -2, "SELECTED", "")%>><%=Translate.JsTranslate("Godkendelse")%></option>
                                <%  
                                        Dim strSqlWorkFlow As String = "SELECT * FROM AccessWorkflow"
                                        Dim cnWorkFlow As IDbConnection = Dynamicweb.Data.Database.CreateConnection()
                                        Dim cmdSelectWorkFlow As System.Data.IDbCommand = cnWorkFlow.CreateCommand

                                        cmdSelectWorkFlow.CommandText = strSqlWorkFlow

                                        Dim drWorkFlowReader As IDataReader = cmdSelectWorkFlow.ExecuteReader
                                        Dim intOpAccessWorkflowID As Integer = drWorkFlowReader.GetOrdinal("AccessWorkflowID")
                                        Dim intOpAccessWorkflowTitle As Integer = drWorkFlowReader.GetOrdinal("AccessWorkflowTitle")
                                        Dim strSel as String = ""
                                        Do While drWorkFlowReader.Read

                                            If ApprovalType = CType(drWorkFlowReader(intOpAccessWorkflowID), Integer) Then
                                                strSel = " Selected"
                                            End If
                                            response.write("<option value=""" & drWorkFlowReader(intOpAccessWorkflowID).ToString & """" & strSel & ">" & drWorkFlowReader(intOpAccessWorkflowTitle).ToString & "</option>")
                                            strSel = ""
                                        Loop
                                        drWorkFlowReader.Close()
                                        drWorkFlowReader.Dispose()
                                        cmdSelectWorkFlow.Dispose()
                                        cnWorkFlow.Close()
                                        cnWorkFlow.Dispose()
                                    
                                %>
                        </td>
                    </tr>
                    <tr>
                        <td height="5" colspan="2"></td>
                    </tr>

                    <%  Dim ListSize as integer = Converter.ToInt32(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/VersionControl/ListSize"))
                        If ListSize = 0 Then
                            ListSize = 6
                        End If
                    %>
                <td width="170"><%=Translate.Translate("Antal viste versioner")%></td>
            <td colspan="2"><%=Dynamicweb.SystemTools.Gui.SpacListExt(ListSize,"/Globalsettings/Modules/VersionControl/ListSize",1,20,1,"")%></td>
        </tr>

        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
    </table>
    <%=Dynamicweb.SystemTools.Gui.GroupBoxEnd%>
    <tr>
        <td align="right" valign="bottom">
            <table>
                <tr>
                    <td>
                        <%=Dynamicweb.SystemTools.Gui.Button(Translate.Translate("OK"), "findCheckboxNames(this.form);OK_OnClick();", "90")%>
                    </td>
                    <td>
                        <%=Dynamicweb.SystemTools.Gui.Button(Translate.Translate("Annuller"), "location='ControlPanel.aspx';", "90")%>
                    </td>
                    <%=Dynamicweb.SystemTools.Gui.HelpButton("", "administration.controlpanel.workflow")%>
                    <td width="2"></td>
                </tr>
            </table>
        </td>
    </tr>
    </TD>
		<tr>
            </form>
</TABLE>
            <%
                Translate.GetEditOnlineScript()
            %>
</body>
</html>
