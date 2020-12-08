<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewReport.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Reports.ViewReport" EnableViewState="false" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Tracking.Reporting" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title><%=Translate.Translate("View report") %></title>
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
    <script src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    <script src="/Admin/Resources/vendors/funnel-graph/js/funnel-graph.min.js"></script>
    <link rel="stylesheet" href="/Admin/Resources/vendors/bootgrid/jquery.bootgrid.min.css">
    <link rel="stylesheet" href="/Admin/Resources/css/fonts.min.css">
    <link rel="stylesheet" href="/Admin/Resources/css/app.min.css">
    <link rel="stylesheet" href="/Admin/Resources/vendors/funnel-graph/css/main.min.css">
    <link rel="stylesheet" href="/Admin/Resources/vendors/funnel-graph/css/theme.min.css">
    <link rel="stylesheet" href="funnel-graph.css">

    <script type="text/javascript">
        function editReport() {
            document.location = "EditReport.aspx?Folder=<%= Folder %>&Report=<%= ReportName %>";
        }

        function showFilters() {
            dialog.show('dlgFilters');
        }

        function applyFilters() {
            btnApplyFilters.click();
            dialog.hide('dlgFilters');
            showSpinner();
        }

        function postChange() {
            showSpinner();
            var form = document.getElementById('form1');
            form.submit()
        }

        function showSpinner() {
            //var spinner = document.getElementById('spinner');
            new overlay('spinner').show();
        }
    </script>

    <style>
        .groupbox {
            padding-top: 0;
            padding-bottom: 0;
            margin-bottom: 0;
            border: 0;
        }

        .chart.chart-body {
            padding-right: 0;
            padding-left: 0;
        }

        .ct-controls {
            text-align: right;
            margin-right: 32px;
        }

        .ct-tools {
            margin-top: 10px;
        }

        .ct-label.ct-horizontal {
            min-width: 135px;
        }

        .ct-head {
            margin-bottom: 12px;
        }

        .ct-head__title {
            font-size: 18px;
            font-weight: 300;
            margin: 0;
        }

        .ct-info {
            color: #929292;
            font-size: 11px;
        }

        .btn-radio {
            display: none;
        }

        .selectedDateRange {
            font-weight: bold;
            background-color: #e2e2e2;
        }

        .date-range {
            cursor: pointer;
            text-decoration: underline;
            font-size: 16px;
        }

        .modal .modal-body {
            overflow: visible;
        }

        .card>.card-body>.row .grid-container {
            margin: 0px;
        }
        div.ct-head {
            margin-bottom: 0px;
            float: left;
        }
        div.chart.chart-body{
            padding-top: 2px;
            padding-bottom: 25px;
            height: 600px;
        }
        ul.ct-legend-bottom{
            bottom: -25px !important;
        }
    </style>
</head>
<body class="screen-container">
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dw:Infobar ID="WrongReportData" runat="server" Type="Error" Message="The report contains wrong data" TranslateMessage="True" Visible="false" />
            <dwc:CardBody runat="server">
                <dwc:GroupBox runat="server">
                    <div class="ct-head">
                        <h2 class="ct-head__title">
                            <asp:Literal ID="litTitle" runat="server" /></h2>
                        <%--<div class="ct-info">
                            <asp:Literal ID="litSubTitle" runat="server" />
                        </div>--%>
                    </div>

                    <div class="ct-controls">
                        <div class="date-range" onclick="showFilters();">
                            <asp:Literal ID="litDateRange" runat="server" />
                        </div>

                        <div class="ct-tools">
                            <button type="button" class="btn btn-flat waves-effect" id="cmdEdit" onclick="editReport();"><%=KnownIconInfo.GetIconHtml(KnownIcon.Gear)%></button>
                            <input type="radio" class="btn-radio" id="dateSelectorDate" value="<%= DateGrouping.Date.ToString() %>" name="dateGrouping" onchange="postChange();"><label runat="server" id="dateLabel" class="btn btn-flat waves-effect radio-btn-lbl" for="dateSelectorDate"><%= DateGrouping.Date.ToString() %></label>
                            <input type="radio" class="btn-radio" id="dateSelectorWeek" value="<%= DateGrouping.Week.ToString() %>" name="dateGrouping" onchange="postChange();"><label runat="server" id="weekLabel" class="btn btn-flat waves-effect radio-btn-lbl" for="dateSelectorWeek"><%= DateGrouping.Week.ToString() %></label>
                            <input type="radio" class="btn-radio" id="dateSelectorMonth" value="<%= DateGrouping.Month.ToString() %>" name="dateGrouping" onchange="postChange();"><label runat="server" id="monthLabel" class="btn btn-flat waves-effect radio-btn-lbl" for="dateSelectorMonth"><%= DateGrouping.Month.ToString() %></label>
                        </div>
                    </div>

                    <div class="widget analytic-widget">
                        <asp:Literal ID="litWidgetChart" runat="server" />
                    </div>
                </dwc:GroupBox>

                <div class="widgets-edit-bar">
                    <dwc:Button ID="cmdMakeWidget" runat="server" Icon="Dashboard" Title="Add to dashboard" OnClick="btnMakeWidget.click();" />
                </div>
            </dwc:CardBody>
        </dwc:Card>

        <div style="display: none">
            <asp:Button runat="server" ID="btnMakeWidget" Text="MakeWidget" OnClick="CmdMakeWidget_Click" />
            <asp:Button runat="server" ID="btnApplyFilters" Text="Apply filters" />
        </div>
        <dw:Dialog ID="dlgFilters" Title="Date range" Size="Medium" OkAction="applyFilters();" ShowOkButton="true" ShowCancelButton="true" runat="server">
            <dw:GroupBox runat="server">
                <div class="form-group">
                    <div class="control-label">
                        <dw:TranslateLabel Text="From" runat="server" />
                    </div>
                    <dw:DateSelector runat="server" id="fromDate" IncludeTime="false" AllowNeverExpire="false"></dw:DateSelector>
                </div>
                <div class="form-group">
                    <div class="control-label">
                        <dw:TranslateLabel Text="To" runat="server" />
                    </div>
                    <dw:DateSelector runat="server" id="toDate" IncludeTime="false"></dw:DateSelector>
                </div>
            </dw:GroupBox>
        </dw:Dialog>
        <%--        <%=ReportProviderAddIn.Jscripts%>
        <%=ReportProviderAddIn.LoadParameters%>--%>
    </form>
    <dw:Overlay runat="server" id="spinner"></dw:Overlay>
</body>
</html>
