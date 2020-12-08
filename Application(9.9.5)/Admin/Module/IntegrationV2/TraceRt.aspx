<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TraceRt.aspx.vb" Inherits="Dynamicweb.Admin.TraceRt" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
    </dw:ControlResources>
    <title>Trace route information for <%=host %></title>
</head>
<body>
    <dwc:Card runat="server">
        <form id="form1" runat="server">
            <dwc:CardHeader runat="server" ID="lbTitle" Title="Test connection"></dwc:CardHeader>
            <dwc:CardBody runat="server">

                <dw:List ID="traceInfoList" runat="server" Title="" ShowTitle="false" StretchContent="true" PageSize="25">
                    <Filters></Filters>
                    <Columns>
                        <dw:ListColumn ID="colHop" runat="server" Name="#" EnableSorting="false" Width="10" />
                        <dw:ListColumn ID="colTime" runat="server" Name="Elapsed time" EnableSorting="false" />
                        <dw:ListColumn ID="colIP" runat="server" Name="IP address" EnableSorting="false" />
                        <dw:ListColumn ID="colHost" runat="server" Name="Host name" EnableSorting="false" />
                    </Columns>
                </dw:List>

            </dwc:CardBody>
        </form>
    </dwc:Card>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
