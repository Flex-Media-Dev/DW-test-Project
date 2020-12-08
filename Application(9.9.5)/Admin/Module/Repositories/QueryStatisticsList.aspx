<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="QueryStatisticsList.aspx.vb" Inherits="Dynamicweb.Admin.QueryStatisticsList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Statistics</title>
    <dw:ControlResources IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
</head>
<body class="area-black screen-container">
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Query statistics" />
            <dwc:CardBody runat="server">
                <!-- !!!NOTE!!! Don't add, remove or change columns without updating the RowComparer to match -->
                <dw:List runat="server" ID="listQueries" ShowPaging="false" NoItemsMessage="No indexes in the solution" ShowTitle="false" ShowCollapseButton="false" HandleSortingManually="true">
                    <Columns>
                        <dw:ListColumn Id="colQuery" runat="server" EnableSorting="true" Name="Query" />
                        <dw:ListColumn Id="colRepository" runat="server" EnableSorting="true" Name="Repository" />
                        <dw:ListColumn Id="colLastQueryTime" runat="server" EnableSorting="true" Name="Last query time" />
                        <dw:ListColumn Id="colNumberOfQueries" runat="server" EnableSorting="true" Name="Number of queries" />
                        <dw:ListColumn Id="colNumberOfEmptyQueries" runat="server" EnableSorting="true" Name="Number of empty queries" />
                        <dw:ListColumn Id="colPercentageOfEmptyQueries" runat="server" EnableSorting="true" Name="Percentage of empty queries" />
                    </Columns>
                </dw:List>
            </dwc:CardBody>
        </dwc:Card>
    </form>

    <script>
        function loadQueryStatistics(queryKey) {
            location.href = `/Admin/Module/Repositories/QueryParameterStatistics.aspx?Query=${encodeURIComponent(queryKey)}`;
        }
    </script>
</body>
</html>
