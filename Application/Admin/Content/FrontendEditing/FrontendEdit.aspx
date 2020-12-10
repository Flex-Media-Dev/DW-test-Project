<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="FrontendEdit.aspx.vb" Inherits="Dynamicweb.Admin.FrontendEdit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head runat="server">
	<title></title>

	<dw:ControlResources runat="server" IncludePrototype="true" IncludeScriptaculous="true">
	</dw:ControlResources>
	<link href="FrontendEdit.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="FrontendEdit.js"></script>

	<script type="text/javascript">
		function help() {
		    eval($('jsHelp').innerHTML);	
		}
	</script>

</head>
<body onload="init(<%=Dynamicweb.Core.Converter.ToInt32(Dynamicweb.Context.Current.Request("PageID"))%>);" style="overflow:hidden;">
<dw:Ribbonbar runat="server" ID="myribbon" HelpKeyword="page.paragraph.frontendEditNEW">
		<dw:RibbonbarTab Active="true" Name="Rediger" runat="server">
			<dw:RibbonbarGroup runat="server" Name="Funktioner">
				<dw:RibbonbarButton runat="server" Text="Gem" Image="Save" OnClientClick="Save();" ID="Save">
				</dw:RibbonbarButton>
			</dw:RibbonbarGroup>
			<dw:RibbonbarGroup runat="server" Name="Edit">
				<dw:RibbonbarPanel runat="server">
				<div id="xToolbar" style="height:auto;width:570px;min-width:570px;"></div>
				</dw:RibbonbarPanel>
			</dw:RibbonbarGroup>
		</dw:RibbonbarTab>
		
	</dw:Ribbonbar>
	
	<iframe src="/Default.aspx?ID=<%=Dynamicweb.Context.Current.Request("PageID") %>&FrontendEdit=True" id="EditorFrame" width="100%" height="450" style="border: 0px;" frameborder="0"></iframe>
	
	<span id="mSaveChanges" style="display: none">
	    <dw:TranslateLabel ID="lbSaveChanges" Text="Save changes before reloading?" runat="server" />
	</span>
	
	<span id="jsHelp" style="display: none">
	    <%=Dynamicweb.SystemTools.Gui.Help("", "page.paragraph.frontendEditNEW")%>
	</span>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
