<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="QueryParameterDetails.aspx.vb" Inherits="Dynamicweb.Admin.QueryParameterDetails" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Parameter</title>
    <dw:ControlResources IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
</head>
<body class="area-black screen-container">
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" DoTranslate="false" ID="header" />
            <dw:Toolbar ID="Toolbar" runat="server" ShowStart="true" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="tbNew" runat="server" OnClientClick="goBackToList();" Icon="ArrowBack" Text="Back" Divide="After"></dw:ToolbarButton>
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dw:List runat="server" ID="listQueries" ShowPaging="false" ShowTitle="false" ShowCollapseButton="false" HandleSortingManually="false">
                    <Columns>
                        <dw:ListColumn Id="colParameterValue" runat="server" EnableSorting="true" Name="Value" />
                        <dw:ListColumn Id="colNumberOfQueries" runat="server" EnableSorting="true" Name="Number of queries" />
                        <dw:ListColumn Id="colLastQueryTime" runat="server" EnableSorting="true" Name="Last query time" />
                        <dw:ListColumn Id="colNumberOfEmptyQueries" runat="server" EnableSorting="true" Name="Number of empty queries" />
                    </Columns>
                </dw:List>
            </dwc:CardBody>
        </dwc:Card>
    </form>

    <script>
        function goBackToList() {
            location.href = "/Admin/Module/Repositories/QueryParameterStatistics.aspx?Query=<%=Query %>";
        }
    </script>
</body>
</html>
