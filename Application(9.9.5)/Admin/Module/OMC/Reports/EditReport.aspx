<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditReport.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Reports.EditReport" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title>Edit report</title>

    <script src="/Admin/Resources/js/jquery-2.1.1.min.js"></script>
    <script src="/Admin/Resources/vendors/waves/waves.min.js"></script>
    <script src="/Admin/Resources/js/layout/bootstrap.min.js"></script>
    <script src="/Admin/Resources/vendors/maxlength/bootstrap-maxlength.min.js"></script>
    <script src="/Admin/Resources/vendors/bootstrap-select/bootstrap-select.min.js"></script>
    <script src="/Admin/Resources/vendors/bootgrid/jquery.bootgrid.min.js"></script>
    <script src="/Admin/Resources/js/layout/chartist.min.js"></script>
    <script src="/Admin/Resources/js/layout/chartist-legend.js"></script>
    <script src="/Admin/Resources/js/layout/chartist-plugin-tooltip.js"></script>
    <script src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script src="/Admin/Resources/js/layout/Actions.js"></script>
    <script src="/Admin/Resources/js/layout/input-functions.js"></script>
    <script src="/Admin/Resources/js/layout/screen-functions.js"></script>
    <script src="/Admin/Resources/js/layout/selector.js"></script>
    <script src="/Admin/Resources/js/layout/listview.js"></script>
    <script src="/Admin/Resources/js/layout/teaser.js"></script>
    <script src="/Admin/Resources/js/layout/initgrid.js"></script>
    <script src="/Admin/Resources/vendors/funnel-graph/js/funnel-graph.min.js"></script>
    <link rel="stylesheet" href="/Admin/Resources/vendors/bootgrid/jquery.bootgrid.min.css">
    <link rel="stylesheet" href="/Admin/Resources/css/fonts.min.css">
    <link rel="stylesheet" href="/Admin/Resources/css/app.min.css">
    <link rel="stylesheet" href="/Admin/Resources/vendors/funnel-graph/css/main.min.css">
    <link rel="stylesheet" href="/Admin/Resources/vendors/funnel-graph/css/theme.min.css">
    <link rel="stylesheet" href="funnel-graph.css">

    <script type="text/javascript">

        function deleteReport()
        {
            <%= DeleteAction %>
        }

        function viewReport() {
            dialog.show('dlgViewReport');

            var chartControl = document.querySelector('#dlgViewReport .ct-chart');
            var chart = $(chartControl).data('chart');
            if (chart instanceof FunnelGraph) {
                chart.toggleDirection();
                chart.toggleDirection();
            }
            else {
                chart.update();
            }
        }

    </script>

    <style>
        .chart.chart-body {
            padding-right: 0;
            padding-left: 0;
            padding-top: 35px;
        }
        .chart .ct-major-tenth::before {
            padding-bottom: 0;
        }
        .ct-label.ct-horizontal {
            min-width: 135px;
        }
    </style>
</head>
<body class="screen-container">
    <form id="form1" runat="server">
        <input type="hidden" id="AddInType" name="AddInType" runat="server" />
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Edit report" ID="cardTitle"></dwc:CardHeader>
            <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowStart="false">
                <dw:ToolbarButton ID="cmdSave" runat="server" Icon="Save" Text="Save" OnClientClick="btnSave.click()">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="cmdDelete" runat="server" Icon="Delete" Text="Delete" OnClientClick="deleteReport()" Divide="Before">
                </dw:ToolbarButton>
                 <dw:ToolbarButton ID="cmdViewReport" runat="server" Icon="AreaChart" Text="View report" OnClientClick="viewReport()" Divide="Before">
                </dw:ToolbarButton>
            </dw:Toolbar>
            <dw:Infobar ID="WrongReportData" runat="server" Type="Error" Message="The report contains wrong data" TranslateMessage="True" Visible="false" />   
            <dwc:CardBody runat="server">
                <dwc:GroupBox runat="server">
                    <dwc:InputText ID="ReportName" runat="server" Label="Widget title" ValidationMessage=""></dwc:InputText>
                </dwc:GroupBox>
                <dw:GroupBox runat="server">
                    <de:AddInSelector id="ReportProviderAddIn" AddInShowNoFoundMessage="true" runat="server" AddInGroupName="Report type" AddInTypeName="Dynamicweb.Tracking.Reporting.ReportProvider" AddInShowNothingSelected="false" ExecInGlobalScope="true"></de:AddInSelector>
                </dw:GroupBox>               
            </dwc:CardBody>
        </dwc:Card>
        <div style="display: none">
            <asp:Button runat="server" ID="btnSave" Text="Save" OnClick="CmdSave_Click" />
        </div>
        <dw:Dialog runat="server" ID="dlgViewReport" Title="View report" Size="Large" HidePadding="false" ShowOkButton="true" ShowCancelButton="false" ShowClose="false">
            <dwc:GroupBox runat="server">
                <div class="widget analytic-widget">
                    <asp:Literal ID="litWidgetChart" runat="server" />
                </div>
            </dwc:GroupBox>
        </dw:Dialog>
    </form>
    <%=ReportProviderAddIn.Jscripts%>
    <%=ReportProviderAddIn.LoadParameters%>
</body>
</html>
