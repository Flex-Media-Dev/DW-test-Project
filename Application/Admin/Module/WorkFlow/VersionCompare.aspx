<%@ Page Language="vb" AutoEventWireup="false" Codebehind="VersionCompare.aspx.vb" Inherits="Dynamicweb.Admin.VersionCompare"%>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="System.Data" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
  <head>
    <title>VersionCompare</title>
    
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
    <meta name=vs_defaultClientScript content="JavaScript">
    <meta name=vs_targetSchema content="http://schemas.microsoft.com/intellisense/ie5">
  </head>

<%=Dynamicweb.SystemTools.Gui.MakeHeaders(Translate.Translate("Versionssammenligning"), Translate.Translate("Original") & ", " & Translate.Translate("Version"), "all")%>

<table border="0" cellpadding="0" cellspacing="0" class="TabTable">
	<tr>
		<td valign="top"><br>
			<DIV id="Tab1" style="Display:;">
				<BR>
				<table border="0" cellpadding="0" width="100%">
					<tr>
						<td colspan=2>
							<%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Felter"))%>
							<table cellpadding=2 cellspacing=0 width="100%" ID="Table1">
								<tr valign="top">
									<td><%=Translate.Translate("Vælg felt")%></td>
									<td>
										<%= GetFieldPicker() %>
									</td>
								</tr>
								<% If ObjectOrigID > 0 And ObjectShowTextField <> "" Then %>
								<tr valign="top">
									<td><%=Translate.Translate("Vælg Parent")%></td>
									<td>
										<%= sbParentSelector.tostring %>
									</td>
								</tr>
								<% End If %>
							</table>
							<%=Dynamicweb.SystemTools.Gui.GroupBoxEnd%>
						</td>
					</tr>
					<tr>
						<td colspan=2>
							<%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Original"))%>
							<table cellpadding=2 cellspacing=0 width="100%">
								<%=sbFields.ToString%>
							</table>
							<%=Dynamicweb.SystemTools.Gui.GroupBoxEnd%>
						</td>
					</tr>
				</TABLE>
			</DIV>
			<DIV id="Tab2" style="Display:None;">
				<BR>
				<table border="0" cellpadding="0" width="100%">
					<tr>
						<td colspan=2>
							<table cellpadding=2 cellspacing=0 width="100%" >
								<tr height="130px">
									<td colspan=2>
									
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan=2>
							<%=Dynamicweb.SystemTools.Gui.GroupBoxStart(Translate.Translate("Version"))%>
							<table cellpadding=2 cellspacing=0 width="100%">
								<%=sbVFields.ToString%>
							</table>
							<%=Dynamicweb.SystemTools.Gui.GroupBoxEnd%>
						</td>
					</tr>
				</TABLE>
			</DIV>
		</td>
	</tr>

  </body>
</html>


