<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Report.aspx.vb" Inherits="Dynamicweb.Admin.Report11" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="false">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
    <title></title>
	<link rel="stylesheet" href="Setup.css" type="text/css" />

	<script type="text/javascript">
		function close() {
			var reloadLocation = parent.location.toString();
			if (reloadLocation.indexOf("omc") < 0) {
				reloadLocation += "&omc=true";
			}
			parent.location = reloadLocation;
		}
		function test(show) {
			document.getElementById("linkviews").className = "";

			if (document.getElementById("linkbounceRate") != null) {
			    document.getElementById("linkbounceRate").className = "";
			} else if (document.getElementById("linkpageViews") != null) {
			    document.getElementById("linkpageViews").className = "";
			} else if (document.getElementById("linktimeOnSite") != null) {
			    document.getElementById("linktimeOnSite").className = "";
			} else if (document.getElementById("linkvalueOrMarkupOrder") != null) {
			    document.getElementById("linkvalueOrMarkupOrder").className = "";
			} else if (document.getElementById("linkconversions") != null) {
			    document.getElementById("linkconversions").className = "";
			} else if (document.getElementById("linkconversionsTotal") != null) {
			    document.getElementById("linkconversionsTotal").className = "";
			}

			document.getElementById("link" + show).className = "active";

			document.getElementById("chart_div_views").style.display = "none";
			document.getElementById("chart_div_conversions").style.display = "none";
			document.getElementById("chart_div_conversionsTotal").style.display = "none";
			document.getElementById("chart_div_bounceRate").style.display = "none";
			document.getElementById("chart_div_pageViews").style.display = "none";
			document.getElementById("chart_div_timeOnSite").style.display = "none";
			document.getElementById("chart_div_valueOrMarkupOrder").style.display = "none";

			document.getElementById("chart_div_" + show).style.display = "";
		}
	</script>
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>

    <script type="text/javascript">
        var isExportToPDF = '<%=IsExportToPDF %>';
    	google.load("visualization", "1", { packages: ["corechart"] });
    	google.setOnLoadCallback(drawChartViews);
		google.setOnLoadCallback(drawChartConversions);
		google.setOnLoadCallback(drawChartConversionsTotal);
    	google.setOnLoadCallback(drawChartBounceRate);
		google.setOnLoadCallback(drawChartPageViews);
		google.setOnLoadCallback(drawChartTimeOnSite);
        google.setOnLoadCallback(drawChartValueOrMarkupOrder);
		
    	function drawChartViews() {
    		var data = new google.visualization.DataTable();
    		data.addColumn('string', 'Date');
    		data.addColumn('number', 'Original');
    		data.addColumn('number', 'Variation');
    		data.addRows([
		  <%=jsStringViews %>
        ]);

        var showTextEveryNumber = Math.round(data.getNumberOfRows() / 8);

    		//http//code.google.com/intl/da-DK/apis/chart/interactive/docs/gallery/linechart.html
    		var options = {
    			width: document.getElementById('chart_div_views').offsetWidth, 
				height: 180,
                fontSize: 11, 
                fontName: 'Arial',
				legend: { 
					position: 'none',
					textStyle: { color: '#233980', fontSize: 10, fontName: 'Arial' } 
				},
				hAxis: { 
					baselineColor: '#333',
                    viewWindow: 'maximized',
                    showTextEvery: ((showTextEveryNumber==0)?1:showTextEveryNumber),
					gridlines: { color: '#333', count: 5 }
				},
				chartArea:{
					left:40,
					top:5,
					width:"92%",
					height:"75%"
				},
				pointSize: 3,
				lineWidth:2,
				colors: ['#034FB7', '#006e12'] 
    		};

    		var chart = new google.visualization.LineChart(document.getElementById('chart_div_views'));
    		chart.draw(data, options);
    	}

		function drawChartConversions() {
    		var data = new google.visualization.DataTable();
    		data.addColumn('string', 'Date');
    		data.addColumn('number', 'Original');
    		data.addColumn('number', 'Variation');
    		data.addRows([
		  <%=jsStringConversions %>
        ]);

        showTextEveryNumber = Math.round(data.getNumberOfRows() / 8);

    		//http//code.google.com/intl/da-DK/apis/chart/interactive/docs/gallery/linechart.html
    		var options = {
    			width: document.getElementById('chart_div_views').offsetWidth, 
				height: 180,
                fontSize: 11, 
                fontName: 'Arial',
				legend: { 
					position: 'none',
					textStyle: { color: '#233980', fontSize: 10, fontName: 'Arial' } 
				},
				hAxis: { 
					baselineColor: '#333',
                    showTextEvery: ((showTextEveryNumber==0)?1:showTextEveryNumber),
                    viewWindow: 'maximized',
					gridlines: { color: '#333', count: 5 }
				},
				chartArea:{
					left:40,
					top:5,
					width:"92%",
					height:"75%"
				},
				pointSize: 3,
				lineWidth:2,
				colors: ['#034FB7', '#006e12'] 
    		};

    		var chart = new google.visualization.LineChart(document.getElementById('chart_div_conversions'));
    		chart.draw(data, options);
            var isConv = '<%=isConversions%>';
            if (navigator.userAgent.indexOf("Firefox")==-1 && isConv == 'False'){
                document.getElementById('chart_div_conversions').style.display = "none";
            }
    	}

		function drawChartConversionsTotal() {
    		var data = new google.visualization.DataTable();
    		data.addColumn('string', 'Date');
    		data.addColumn('number', 'Original');
    		data.addColumn('number', 'Variation');
    		data.addRows([
		  <%=jsStringConversionsTotal %>
        ]);

        showTextEveryNumber = Math.round(data.getNumberOfRows() / 8);
            
    		//http//code.google.com/intl/da-DK/apis/chart/interactive/docs/gallery/linechart.html
    		var options = {
    			width: document.getElementById('chart_div_views').offsetWidth, 
				height: 180,
                fontSize: 11, 
                fontName: 'Arial',
				legend: { 
					position: 'none',
					textStyle: { color: '#233980', fontSize: 10, fontName: 'Arial' } 
				},
				hAxis: { 
					baselineColor: '#333',
                    showTextEvery: ((showTextEveryNumber==0)?1:showTextEveryNumber),
					gridlines: { color: '#333', count: 5 }
				},
				chartArea:{
					left:40,
					top:5,
					width:"92%",
					height:"75%"
				},
				pointSize: 3,
				lineWidth:2,
				colors: ['#034FB7', '#006e12'] 
    		};

    		var chart = new google.visualization.LineChart(document.getElementById('chart_div_conversionsTotal'));
    		chart.draw(data, options);
            var isConvTotal = '<%=isConversions%>';
            if (navigator.userAgent.indexOf("Firefox")==-1 && isConvTotal == 'False') document.getElementById('chart_div_conversionsTotal').style.display = "none";
    	}

		function drawChartBounceRate() {
    		var data = new google.visualization.DataTable();
    		data.addColumn('string', 'Date');
    		data.addColumn('number', 'Original');
    		data.addColumn('number', 'Variation');
    		data.addRows([
		  <%=jsStringBounceRate %>
        ]);

        showTextEveryNumber = Math.round(data.getNumberOfRows() / 8);
            
    		//http//code.google.com/intl/da-DK/apis/chart/interactive/docs/gallery/linechart.html
    		var options = {
    			width: document.getElementById('chart_div_bounceRate').offsetWidth, 
				height: 180,
                fontSize: 11, 
                fontName: 'Arial',
				legend: { 
					position: 'none',
					textStyle: { color: '#233980', fontSize: 10, fontName: 'Arial' } 
				},
				hAxis: { 
					baselineColor: '#333',
                    showTextEvery: ((showTextEveryNumber==0)?1:showTextEveryNumber),
					gridlines: { color: '#333', count: 5 }
				},
				chartArea:{
					left:40,
					top:5,
					width:"92%",
					height:"75%"
				},
				pointSize: 3,
				lineWidth:2,
				colors: ['#034FB7', '#006e12'] 
    		};

    		var chart = new google.visualization.LineChart(document.getElementById('chart_div_bounceRate'));
    		chart.draw(data, options);
            var isBR = '<%=isBounceRate%>';
            if (navigator.userAgent.indexOf("Firefox")==-1  && isBR == 'False') document.getElementById('chart_div_bounceRate').style.display = "none";
    	}


		function drawChartPageViews() {
    		var data = new google.visualization.DataTable();
    		data.addColumn('string', 'Date');
    		data.addColumn('number', 'Original');
    		data.addColumn('number', 'Variation');
    		data.addRows([
		  <%=jsStringPageViews%>
        ]);

        showTextEveryNumber = Math.round(data.getNumberOfRows() / 8);
            
    		//http//code.google.com/intl/da-DK/apis/chart/interactive/docs/gallery/linechart.html
    		var options = {
    			width: document.getElementById('chart_div_pageViews').offsetWidth, 
				height: 180,
                fontSize: 11, 
                fontName: 'Arial',
				legend: { 
					position: 'none',
					textStyle: { color: '#233980', fontSize: 10, fontName: 'Arial' } 
				},
				hAxis: { 
					baselineColor: '#333',
                    showTextEvery: ((showTextEveryNumber==0)?1:showTextEveryNumber),
					gridlines: { color: '#333', count: 5 }
				},
				chartArea:{
					left:40,
					top:5,
					width:"92%",
					height:"75%"
				},
				pointSize: 3,
				lineWidth:2,
				colors: ['#034FB7', '#006e12'] 
    		};

    		var chart = new google.visualization.LineChart(document.getElementById('chart_div_pageViews'));
    		chart.draw(data, options);
            var isPageview ='<%=isPageview%>';
            if (navigator.userAgent.indexOf("Firefox")==-1 && isPageview == 'False') document.getElementById('chart_div_pageViews').style.display = "none";
    	}

		function drawChartTimeOnSite() {
    		var data = new google.visualization.DataTable();
    		data.addColumn('string', 'Date');
    		data.addColumn('number', 'Original');
    		data.addColumn('number', 'Variation');
    		data.addRows([
		  <%=jsStringTimeOnSite%>
        ]);

        showTextEveryNumber = Math.round(data.getNumberOfRows() / 8);
            
    		//http//code.google.com/intl/da-DK/apis/chart/interactive/docs/gallery/linechart.html
    		var options = {
    			width: document.getElementById('chart_div_timeOnSite').offsetWidth, 
				height: 180,
                fontSize: 11, 
                fontName: 'Arial',
				legend: { 
					position: 'none',
					textStyle: { color: '#233980', fontSize: 10, fontName: 'Arial' } 
				},
				hAxis: { 
					baselineColor: '#333',
                    showTextEvery: ((showTextEveryNumber==0)?1:showTextEveryNumber),
					gridlines: { color: '#333', count: 5 }
				},
				chartArea:{
					left:40,
					top:5,
					width:"92%",
					height:"75%"
				},
				pointSize: 3,
				lineWidth:2,
				colors: ['#034FB7', '#006e12'] 
    		};

    		var chart = new google.visualization.LineChart(document.getElementById('chart_div_timeOnSite'));
    		chart.draw(data, options);
            var isTimespent ='<%=isTimespent%>';
            if (navigator.userAgent.indexOf("Firefox")==-1 && isTimespent == "False") document.getElementById('chart_div_timeOnSite').style.display = "none";
    	}

		function drawChartValueOrMarkupOrder() {
    		var data = new google.visualization.DataTable();
    		data.addColumn('string', 'Date');
    		data.addColumn('number', 'Original');
    		data.addColumn('number', 'Variation');
    		data.addRows([
		  <%=jsHighestAverageValueOrMarkupOrder%>
        ]);

        showTextEveryNumber = Math.round(data.getNumberOfRows() / 8);
            
    		//http//code.google.com/intl/da-DK/apis/chart/interactive/docs/gallery/linechart.html
    		var options = {
    			width: document.getElementById('chart_div_valueOrMarkupOrder').offsetWidth, 
				height: 180,
                fontSize: 11, 
                fontName: 'Arial',
				legend: { 
					position: 'none',
					textStyle: { color: '#233980', fontSize: 10, fontName: 'Arial' } 
				},
				hAxis: { 
					baselineColor: '#333',
                    showTextEvery: ((showTextEveryNumber==0)?1:showTextEveryNumber),
					gridlines: { color: '#333', count: 5 }
				},
				chartArea:{
					left:40,
					top:5,
					width:"92%",
					height:"75%"
				},
				pointSize: 3,
				lineWidth:2,
				colors: ['#034FB7', '#006e12'] 
    		};

    		var chart = new google.visualization.LineChart(document.getElementById('chart_div_valueOrMarkupOrder'));
    		chart.draw(data, options);
            var isShow ='<%=isHighestAverageValueOrMarkupOrder%>';
            if (navigator.userAgent.indexOf("Firefox")==-1 && isShow == 'False') document.getElementById('chart_div_valueOrMarkupOrder').style.display = "none";
    	}

        function onDocumentLoad(){
            //Fix hAxis text wrap bug in Firefox
            if (navigator.userAgent.indexOf("Firefox")!=-1) {
                setTimeout(function (param) {
                if (isExportToPDF == "False") {
                     document.getElementById('chart_div_conversions').style.display = "none";
                     document.getElementById('chart_div_conversionsTotal').style.display = "none";
                     document.getElementById('chart_div_bounceRate').style.display = "none";
                     document.getElementById('chart_div_pageViews').style.display = "none";
                     document.getElementById('chart_div_timeOnSite').style.display = "none";
                     document.getElementById('chart_div_valueOrMarkupOrder').style.display = "none";
                     }
                }, 300);
            }
        }
    </script>
</head>
<body onload="onDocumentLoad();">
	<div runat="server" id="closeJs" visible="false">
		<script type="text/javascript">
		    close();
		</script>
	</div>
    <form id="deleteForm" runat="server" action="Delete.aspx" method="post">
	    <input type="hidden" runat="server" id="id" name="id" />
        <div id="step1Delete" class="step">
            <div class="step__content step__content--without-footer no-horizontal-scroll">
                <dwc:GroupBox runat="server" Title="Split test report">
                    <div id="pageInfo" runat="server" visible="false" >
                        <div class="form-group">
                            <div class="control-label"><%= Translate.Translate("Page ID")%></div>
                            <dw:TranslateLabel ID="labelPageID" runat="server"></dw:TranslateLabel>
                        </div>
                        <div class="form-group">
                            <div class="control-label"><%= Translate.Translate("Page name: ")%></div>
                            <dw:TranslateLabel ID="labelPageName" runat="server"></dw:TranslateLabel>
                        </div>
                        <div class="form-group">
                            <div class="control-label"><%= Translate.Translate("Split test name")%></div>
                            <dw:TranslateLabel ID="labelSplitTestName" runat="server"></dw:TranslateLabel>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="control-label"><%= Translate.Translate("Split test type")%></div>
                        <dw:TranslateLabel ID="labelType" runat="server"></dw:TranslateLabel><br />
                    </div>
                    <div class="form-group">
                        <div class="control-label"><%= Translate.Translate("Conversion goal")%></div>
                        <span ID="labelGoal" runat="server" ></span>
                    </div>
                    <div class="m-b-15">
                        <i runat="server" Id="imgReport" class="fa fa-line-chart"></i>
				        <span runat="server" id="linksReport"  class="links report">
					        <a href="javascript:test('views');" class="active" id="linkviews"><%= Translate.Translate("Views")%></a>
					        <a href="javascript:test('conversions');" class="" id="linkconversions"  runat="server" visible="false"><%= Translate.Translate("Conversions")%></a>
					        <a href="javascript:test('conversionsTotal');" class="" id="linkconversionsTotal"  runat="server" visible="false"><%= Translate.Translate("Total conversion")%></a>
					        <a href="javascript:test('bounceRate');" class="" id="linkbounceRate" runat="server" visible="false" ><%= Translate.Translate("Bounce rate")%></a>
					        <a href="javascript:test('pageViews');" class="" id="linkpageViews" runat="server" visible="false" ><%= Translate.Translate("Page views pr. view")%></a>
					        <a href="javascript:test('timeOnSite');" class="" id="linktimeOnSite" runat="server" visible="false" ><%= Translate.Translate("Time on site pr. view")%></a>
                            <a href="javascript:test('valueOrMarkupOrder');" class="" id="linkvalueOrMarkupOrder" runat="server" visible="false" ></a>
				        </span>
                    </div>
                    <h2 runat="server" id="pdfTextViews" visible="false">Views</h2>
			        <div id="chart_div_views" runat="server"></div>
                    <h2 runat="server" id="pdfTextConv" visible="false">Conversions</h2>
			        <div id="chart_div_conversions" runat="server"></div>
                    <h2 runat="server" id="pdfTextConvTotal" visible="false">Total conversion</h2>
			        <div id="chart_div_conversionsTotal" runat="server"></div>
                    <h2 runat="server" id="pdfTextBR" visible="false">Bounce rate</h2>
			        <div id="chart_div_bounceRate" runat="server"></div>
                    <h2 runat="server" id="pdfTextPageViews" visible="false">Page views pr. view</h2>
			        <div id="chart_div_pageViews"  runat="server"></div>
                    <h2 runat="server" id="pdfTextTimespent" visible="false">Time on site pr. view</h2>
			        <div id="chart_div_timeOnSite" runat="server"></div>
                    <h2 runat="server" id="pdfTextValueOrMarkupOrder" visible="false"></h2>
			        <div id="chart_div_valueOrMarkupOrder"  runat="server"></div>
                    <BR/>
			        <div class="report">
				        <table runat="server" id="reportTable" border="0" cellpadding="0" cellspacing="0">
					        <thead>
						        <tr>
							        <th class="name" style="width:100px;"><%= Translate.Translate("Variants")%></th>
							        <th><%= Translate.Translate("Views")%></th>
							        <th id="headerConversions" style="display:none;" runat="server"><%= Translate.Translate("Conversions")%></th>
							        <th id="headerBounceRate" style="display:none;" runat="server"><%= Translate.Translate("Bounce rate (%)")%></th>
							        <th id="headerPageviews" style="display:none;" runat="server"><%= Translate.Translate("Page views pr. view")%></th>
							        <th id="headerTimespent" style="display:none;" runat="server"><%= Translate.Translate("Time on site pr. view")%></th>
                                    <th id="headerValueOrMarkupOrder" style="display:none;" runat="server"></th>
							        <th id="headerCR" style="display:none;" runat="server"><%= Translate.Translate("CR (%)")%></th>
							        <th><%= Translate.Translate("CR improvement")%></th>                            
                                    <th id="headerAverageOrderValue" style="display:none;" runat="server"><%= Translate.Translate("Average Order Value")%></th>
                                    <th id="headerTotalOrderValue" style="display:none;" runat="server"><%= Translate.Translate("Total Order Value")%></th>                            
							        <th id="headerProbability" style="display:none;" runat="server"><%= Translate.Translate("Significance")%></th>
						        </tr>
					        </thead>
					        <tbody>
						        <tr>
							        <td class="name" style="width:100px;">
							            <div style="line-height:20px;">
								            <span style="background-color:#034FB7;width:10px;height:10px;display:block;margin:5px;float:left;"></span><%= Translate.Translate("Original")%> 
							            </div>
							        </td>
							        <td><%=variation1ViewCountTotal%></td>
							        <td id="originalConversions" style="display:none;" runat="server"><%=variation1ConversionCountTotal%></td>
							        <td id="originalBR" style="display:none;" runat="server"></td>
							        <td id="originalPageviews" style="display:none;" runat="server"></td>
							        <td id="originalTimespent" style="display:none;" runat="server"></td>
                                    <td id="valueOrMarkupOrder" style="display:none;" runat="server"></td>
							        <td id="originalCR" style="display:none;" runat="server"></td>
							        <td>-</td>
                                    <td id="originalAverageOrder" style="display:none;" runat="server"></td>
                                    <td id="originalTotalOrder" style="display:none;" runat="server"></td>
							        <td id="originalProbability" style="display:none;" runat="server"><%=ShowSignificance(False)%></td>
						        </tr>
						        <tr>
							        <td class="name" style="width:100px;">
							            <div style="line-height:20px;">
								            <span style="background-color:#006e12;width:10px;height:10px;display:block;margin:5px;float:left;"></span><%= Translate.Translate("Variants")%> 
							            </div>
							        </td>
							        <td><%=variation2ViewCountTotal%></td>
							        <td id="variantConversions" style="display:none;" runat="server"><%=variation2ConversionCountTotal%></td>
							        <td id="variantBR" style="display:none;" runat="server"></td>
							        <td id="variantPageviews" style="display:none;" runat="server"></td>
							        <td id="variantTimespent" style="display:none;" runat="server"></td>
                                    <td id="variantValueOrMarkupOrder" style="display:none;" runat="server"></td>
							        <td id="variantCR" style="display:none;" runat="server"></td>
							        <td id="variantImprovement" style="color:#006e12;" runat="server"></td>
                                    <td id="variantAverageOrder" style="display:none;" runat="server">-</td>
                                    <td id="variantTotalOrder" style="display:none;" runat="server">-</td>
							        <td id="variantProbability" style="display:none;" runat="server"><%=ShowSignificance(True)%></td>
						        </tr>
					        </tbody>
				        </table>
			        </div>
                </dwc:GroupBox>
            </div>
        </div>
    </form>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
