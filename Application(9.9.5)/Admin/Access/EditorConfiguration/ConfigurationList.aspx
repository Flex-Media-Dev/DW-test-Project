<%@ Page Language="vb" AutoEventWireup="false" Codebehind="ConfigurationList.aspx.vb" Inherits="Dynamicweb.Admin.EditorConfigurationList" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="System.Data" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<SCRIPT language="JavaScript">
	function init(){
		parent.document.getElementById("ListUsers").innerHTML = document.body.innerHTML;
		<%If Request.QueryString.Item("Tab") = "4" Then%>
		if (parent.document.getElementById("Tab3_head")) {
			parent.document.getElementById("Tab3_head").click();
		}
		<%End If%>
	}
	
</SCRIPT>
<HTML>
	<HEAD>
		<META HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=UTF-8">
		
	</HEAD>
	<body onLoad="init();">
		<form name="side" method="Post" name="EditorConfiguration">
		<%=Dynamicweb.SystemTools.Gui.MakeHeaders(Translate.Translate("Editor konfigurationer"), Translate.Translate("Editor konfigurationer"), "All", false, "")%>
		<table border="0" cellpadding="0" cellspacing="0" width="600" class="tabTable">
			<tr>
				<td valign="top">
						<div ID="Tab1">
							<table border="0" cellpadding="0" width="598" height="100%">
								<tr>
									<td valign="top"><br>
										<table border="0" cellpadding="0" width="598">
											<tr>
												<td width="100%"><strong>&nbsp;<%=Translate.Translate("Konfiguration")%></strong></td>
												
											</tr>
											<tr valign="top">
												<td colspan="2" bgcolor="#C4C4C4" valign="top"><img src="/Admin/images/nothing.gif" width="1" height="1" alt="" border="0"></td>
											</tr>
											<%=ListEditorConfigurations()%>
										</table>
									</td>
								</tr>
								<tr>
									<td align="right" valign="bottom">
										<table cellspacing="5">
											<tr>
												<td><%=Dynamicweb.SystemTools.Gui.Button(Translate.Translate("Ny konfiguration"), "EditConfiguration();return false;", 0)%></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</div>
				</td>
			</tr>
		</table>
	</form>
	</body>
</HTML>
<%
Translate.GetEditOnlineScript()
%>
<SCRIPT LANGUAGE="JavaScript">
parent.document.getElementById("StatusFrame").setAttribute("src", "Access_blank_with_color.html");
</SCRIPT>
