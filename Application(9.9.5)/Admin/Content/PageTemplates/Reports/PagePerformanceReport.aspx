<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PagePerformanceReport.aspx.vb" Inherits="Dynamicweb.Admin.PagePerformanceReport" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Webpage analysis</title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
    <link rel="stylesheet" href="/Admin/Content/PageTemplates/Reports/PagePerformanceReport.css" type="text/css" />
    <script type="text/javascript">
        function help() {
            <%=Dynamicweb.SystemTools.Gui.Help("page.optimizeexpress")%>
            }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Panel ID="pHasAccess" runat="server">
            <dw:Toolbar ID="TopTools" ShowStart="false" ShowEnd="false" runat="server">
                <dw:ToolbarButton ID="cmdHelp" Image="Help" Text="Help" OnClientClick="help();" runat="server" />
            </dw:Toolbar>
            
            <dw:PageBreadcrumb ID="breadcrumbControl" runat="server" />
            
            <dw:List ID="lstWebPageAnalyzeReport" ShowPaging="false" NoItemsMessage="No data to show" ShowTitle="false" runat="server" pagesize="25" OnRowExpand="OnRowExpand" Personalize="true">
                <Columns>
                    <dw:ListColumn ID="colName" Name="Parameter Name" Width="250" runat="server" />
                    <dw:ListColumn ID="colValue" Name="Value" Width="75" runat="server" />
                    <dw:ListColumn ID="colStatus" Name="Status" Width="75" runat="server" />
                </Columns>
            </dw:List>
	    </asp:Panel>
    </form>
</body>
<span id="jsHelp" style="display: none"><%=Dynamicweb.SystemTools.Gui.Help("page.optimizeexpress")%></span>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
