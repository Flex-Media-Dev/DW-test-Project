<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Page.aspx.vb" Inherits="Dynamicweb.Admin.page" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>


<!DOCTYPE html>

<html>
<head runat="server">
	<dw:ControlResources ID="ControlResources1" runat="server">
	</dw:ControlResources>
    <title></title>
    <script type="text/javascript" src="/Admin/Images/Chart/JSClass/FusionCharts.js"></script>
    <script type="text/javascript">
    	function changeChartType(chart) {
    		location = "Page.aspx?Chart=" + chart + "&Report=<%=Dynamicweb.Context.Current.Request("Report")%>&PageID=<%=Dynamicweb.Context.Current.Request("PageID")%>";
    	}
    </script>
</head>
<body>
	<dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false">
		<dw:ToolbarButton ID="ToolbarButton1" OnClientClick="changeChartType('Line');" runat="server" Divide="None" Icon="LineChart" Text="Line">
		</dw:ToolbarButton>
		<dw:ToolbarButton ID="ToolbarButton3" OnClientClick="changeChartType('Pie3D');" runat="server" Divide="None" Icon="PieChart" Text="Pie">
		</dw:ToolbarButton>
		<dw:ToolbarButton ID="ToolbarButton2" OnClientClick="changeChartType('Column3D');" runat="server" Divide="None" Icon="BarChart" Text="3D Column">
		</dw:ToolbarButton>
		<dw:ToolbarButton ID="ToolbarButton4" OnClientClick="changeChartType('Column2D');" runat="server" Divide="None" Icon="BarChart" Text="2D Column">
		</dw:ToolbarButton>
	</dw:Toolbar>
    
    <dw:PageBreadcrumb ID="breadcrumbControl" runat="server" />

   <div id="chartdiv" align="center"></div>
   <script type="text/javascript">
   <%=getHtml()%>
   
	chart.render("chartdiv");
	
	function showXML(){
		if(document.getElementById('xml').style.display == ''){
			document.getElementById('xml').style.display = 'none';
		}
		else{
			document.getElementById('xml').style.display = '';
			document.frames.xml.location = 'PageXml.aspx?Chart=<%=Dynamicweb.Context.Current.Request("Chart")%>PageID=<%=Dynamicweb.Context.Current.Request("PageID")%>&Report=<%=Dynamicweb.Context.Current.Request("Report")%>&src=iframe'
		}
	}
	</script>
	<iframe src="" width="500" height="400" id="xml" name="xml" style="display:none;"></iframe>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
    %>
</html>
