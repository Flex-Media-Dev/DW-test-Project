<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FramedStatisticView.aspx.vb" Inherits="Dynamicweb.Admin.FramedStatisticView" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
    <script src="/Admin/Images/Ribbon/Ribbon.js" type="text/javascript"></script>
    <script src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" type="text/javascript"></script>
    <link rel="stylesheet" href="/Admin/Resources/vendors/bootgrid/jquery.bootgrid.min.css" />
    <link rel="stylesheet" href="/Admin/Resources/css/fonts.min.css" />
    <link rel="stylesheet" href="/Admin/Resources/css/app.min.css" />
    <link rel="stylesheet" href="/Admin/Resources/vendors/funnel-graph/css/main.min.css" />
    <link rel="stylesheet" href="/Admin/Resources/vendors/funnel-graph/css/theme.min.css" />

    <script>
        class StatisticsViewPage {
            constructor(opts) {
                this.options = opts;
                if (this.options.showDataList) {
                    this.showDataList();
                }
            }

            showDataList() {
                let elem = document.getElementById("DataLayer");
                elem.style.display = "block";
                document.getElementById('Form1').showDataLines.value = "1";
            }

            toggleDataList() {
                var elem = document.getElementById("DataLayer");
                if (elem.style.display == "none") {
                    elem.style.display = "block";
                    document.getElementById('Form1').showDataLines.value = "1";
                    this.goToAnchor("DataAnchor")
                } else {
                    elem.style.display = "none";
                    document.getElementById('Form1').showDataLines.value = "";
                }
            }

            exportStat() {
                var url = "FramedStatisticView.aspx?AddIn=<%=StatAddInType%>&XLSExport=1";
                EcomStatExport.document.location.href = url;
            }

            printStat() {
                window.open("FramedStatisticView.aspx?AddIn=<%=StatAddInType%>&PrintMode=1&ecom7master=hidden");
            }

            changeLineView() {
                this.changeView(this.options.graphType.Line || 0);
            }

            changePieView() {
                this.changeView(this.options.graphType.Pie);
            }

            changeBarView() {
                this.changeView(this.options.graphType.Bar);
            }

            changeView(graphType) {
                document.getElementById('graphType').value = graphType;
                dwGlobal.Dom.triggerEvent(document.getElementById('cmdSave'), 'click');
            }

            goToAnchor(AnchorName) {
                location.href = "#" + AnchorName;
            }
        }
    </script>
    <%=cAddInControl1.Jscripts%>

    <style type="text/css">
        h1.report-title {
            padding-left: 16px;
            padding-top: 5px;
            font-weight: bold;
            font-size: 16px;
        }

        h1 small.report-subtitle {
            font-weight: normal;
            display:block;
            padding-top: 8px;
        }

        .dw8-container, .dw8-container .card {
            margin-bottom: 0px;
        }
    </style>
</head>

<body class="area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dw:RibbonBar ID="chartRibbon" HelpKeyword="ecom.statistics.view" runat="server">
                <dw:RibbonBarTab ID="tabChart" Name="Chart" runat="server">
                    <dw:RibbonBarGroup ID="groupData" Name="Data" runat="server">
                        <dw:RibbonBarButton ID="cmdChartType" Text="Chart type" Size="Large" Icon="AreaChart" ContextMenuId="cmChartType" SplitButton="false" runat="server" />
                        <dw:RibbonBarCheckbox ID="chkShowList" Checked="false" Text="Show list" OnClientClick="currentPage.toggleDataList();" Size="Small" Icon="Table" runat="server" />
                        <dw:RibbonBarButton ID="cmdSave" Text="Apply parameters" EnableServerClick="true" OnClick="cmdSave_Click" Icon="Check" IconColor="Default" Size="Small" runat="server" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="groupExport" Name="Export" runat="server">
                        <dw:RibbonBarButton ID="cmdExportXLS" Text="Export to Excel" Size="Small" Icon="FileExelO" OnClientClick="currentPage.exportStat();" runat="server" />
                        <dw:RibbonBarButton ID="cmdPrint" Text="Printable version" Size="Small" Icon="Print" OnClientClick="currentPage.printStat();" runat="server" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>
            <dwc:CardBody runat="server">
                <form id="Form1" runat="server">
                    <input type="hidden" id="graphType" name="graphType" />
                    <input type="hidden" name="showDataLines" />

                    <h1 class="report-title">
                        <asp:Literal ID="litTitle" runat="server" />
                        <small class="report-subtitle">
                            <asp:Literal ID="litSubTitle" runat="server" />
                        </small>
                    </h1>
                    
                    <de:AddInSelector ID="cAddInControl1" runat="server" AddInGroupName="Statistik" AddInTypeName="Dynamicweb.Ecommerce.Statistics.StatisticsProvider"></de:AddInSelector>

                    <fieldset class="widget" style='width: 100%; margin: 5px;'>
                        <legend class="gbTitle"><%=Translate.Translate("Graph")%></legend>
                        <div class="col-lg-12">
                            <asp:Literal ID="Graph" runat="server"></asp:Literal>
                        </div>
                    </fieldset>

                    <asp:Literal ID="StatInfoData" runat="server"></asp:Literal>

                    <div id="DataLayer" style="display: none;">
                        <p />
                        <a id="DataAnchor"></a>
                        <fieldset style='width: 100%; margin: 5px;'>
                            <legend class="gbTitle"><%=Translate.Translate("Data")%>&nbsp;</legend>
                            <asp:Literal ID="StatList" runat="server"></asp:Literal>
                        </fieldset>
                    </div>

                    <iframe frameborder="1" name="EcomStatExport" id="EcomStatExport" style="display:none;" width="1" height="1" tabindex="-1" align="right" marginwidth="0" marginheight="0" border="0" src="FramedStatisticView.aspx?XLSExport=0"></iframe>

                    <input type="submit" id="SaveParameters" name="SaveParameters" style="display: none" />

                    <%=cAddInControl1.LoadParameters%>


                    <dw:ContextMenu ID="cmChartType" runat="server">
                        <dw:ContextMenuButton ID="cmdLineChart" Text="Line chart" Icon="LineChart" OnClientClick="currentPage.changeLineView();" runat="server" />
                        <dw:ContextMenuButton ID="cmdPieChart" Text="Pie chart" Icon="PieChart" OnClientClick="currentPage.changePieView();" runat="server" />
                        <dw:ContextMenuButton ID="cmdColumnChart" Text="Column chart" Icon="BarChart" Checked="true" OnClientClick="currentPage.changeBarView();" runat="server" />
                    </dw:ContextMenu>
                </form>
            </dwc:CardBody>
        </dwc:Card>
    </div>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript() %>
</html>
