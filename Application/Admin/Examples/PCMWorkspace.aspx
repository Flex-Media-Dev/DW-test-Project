<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="PCMWorkspace.aspx.vb" Inherits="Dynamicweb.Admin.PCMWorkspace" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head>
    <title>Ecommerce workspace</title>
    <link rel="stylesheet" href="/Admin/Resources/css/fonts.min.css">
    <link rel="stylesheet" href="/Admin/Resources/css/app.min.css">

    <style>
        .row {
            position: relative;
            display: flex;
            flex-flow: row wrap;
            justify-content: space-around;
        }

        .section-2 {
            flex: 2;
        }

        .section-3 {
            flex: 3;
        }

        .section-4 {
            flex: 4;
        }

        .section-6 {
            flex: 6;
        }

        .section-8 {
            flex: 8;
        }

        .section-9 {
            flex: 9;
        }

        .section-10 {
            flex: 10;
        }

        .section-12 {
            flex: 12;
        }

        @media screen and (max-width: 768px) {
            .row {
                flex-direction: column;
            }
        }

        .chart-info {
            padding-top: 5px;
            border-top: 1px solid #e0e0e0;
            color: #9E9E9E;
        }

        .col-md-4 .card {
            height: 270px;
        }

        .col-md-3 .card {
            height: 184px;
        }

        .col-md-4 .ct-chart {
            margin-top: 22px;
        }

        .col-md-3 .chart-body {
            padding-top: 10px;
        }

        .col-md-4 .stats-widget, .col-md-4 .stats-widget-mark {
            height: 270px;
            overflow: hidden;
        }

        .col-md-4 .stats-widget-mark-text {
            margin-top: 29px;
        }

        .col-md-4 .stats-widget-icon {
            font-size: 160px;
        }

        .col-md-4 .stats-widget-complete {
            font-size: 110px;
        }

        .col-md-4 .stats-widget-uncomplete {
            font-size: 30px;
        }

        .col-md-4 .stats-widget-continue-btn {
            margin: 15px;
        }

        .col-md-4 .stats-widget-info {
            margin-top: 26px;
        }

        .col-md-3 .stats-widget, .col-md-3 .stats-widget-mark {
            height: 184px;
        }

        .col-md-3 .stats-widget-mark-text {
            margin-top: 92px;
        }

        .col-md-3 .stats-widget-icon {
            font-size: 70px;
        }

        .col-md-3 .stats-widget-complete {
            font-size: 80px;
        }

        .col-md-3 .stats-widget-uncomplete {
            font-size: 22px;
            height: 22px;
        }

        .col-md-3 .stats-widget-continue-btn {
            padding: 2px 8px;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        .col-md-3 .stats-widget-info {
            margin-top: 0;
            margin-bottom: 0;
        }

        .col-md-3 .ct-chart {
            height: 136px;
        }

        .stats-widget-mark {
            color: #fff;
            display: inline-block;
            float: left;
            width: 20px;
        }

        .stats-widget {
            border: 1px solid #bdbdbd; 
        }

        .stats-widget .stats-widget-mark {
            background-color: #bdbdbd;
        }

        .stats-widget-mark-text {
            transform: rotate(270deg);
        }

        .stats-widget-icon {
            display: inline-block;
            float: left;
            margin: 8px 15px 6px 10px;
            vertical-align: top;
            color: #9E9E9E;
        }

        .stats-widget-icon i {
            display: block;
        }

        .stats-widget-scores {
            display: inline-block;
            float: right;
        }

        .stats-widget-complete {
            margin: 0px 15px 0 15px;
            font-weight: bold;
            line-height: 1;
            text-align: right;
            display: inline-block;
        }

        .stats-widget.goals .stats-widget-complete {
            color: #8BC34A;
        }

        .stats-widget.query .stats-widget-complete {
            color: #03A9F4;
        }

        .stats-widget-uncomplete {
            margin: 0px 15px 0 15px;
            color: #9E9E9E; 
            font-weight: bold;
            font-size: 30px;
            text-align: right;
            line-height: 1;
        }

        .stats-widget-continue-btn {
            display: block;
            float: right;
            margin: 15px;
        }

        .stats-widget-continue-btn i {
            font-size: 10px;
            margin-right: 10px;
            vertical-align: top;
            margin-top: 6px;
        }

        .stats-widget-info {
            margin: 15px;
            display: inline-block;
            font-size: 16px;
            color: #9E9E9E;
            border-top: 1px solid #e0e0e0;
            width: calc(100% - 50px);
            padding-top: 5px;
        }

        .stats-widget-info-label {
            float: left;
        }

        .stats-widget-info-edit {
            float: right;
        }

        .ct-series-a .ct-bar {
            stroke: #E91E63;
        }

        .chart-info .chart-count {
            color: #E91E63;
        }

        .pcm-work-progress-chart .ct-series-a .ct-line, .pcm-work-progress-chart .ct-series-a .ct-point {
            stroke: #8BC34A;
            stroke-width: 2px;
        }

        .pcm-work-progress-chart .chart-count {
            color: #8BC34A;
        }
    </style>
</head>
<body class="sw-toggled-off boxed-fields">
    <section id="content">
         <div class="container">
            <div class="col-md-4">
			    <div class="widget card">
				    <div class="card-body no-padding">
                        <div class="stats-widget goals">
                            <div class="stats-widget-mark">
                                <div class="stats-widget-mark-text">GOALS</div>
                            </div>
                            <div class="stats-widget-icon"><i class="fa fa-flag-checkered"></i></div>
                            <div class="stats-widget-scores">
                                <div class="stats-widget-complete">33</div>
                                <div class="stats-widget-uncomplete">204</div>
                                <button class="btn btn-flat stats-widget-continue-btn"><i class="fa fa-play"></i>Continue</button>
                            </div>
                            <div class="stats-widget-info">
                                <span class="stats-widget-info-label"><i class="fa fa-filter"></i> My work goals for integrated products</span>
                                <span class="stats-widget-info-edit"><i class="fa fa-gear"></i></span>									
						    </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
				<div class="widget card">
					<div class="card-header">
						<h2>Latest orders</h2>
					</div>
					<div class="card-body no-padding">
						<div class="listview" data-datasource="/admin/api/navigators/DataFeed/LatestOrders"></div>
                    </div>
				</div>
			</div>
            <div class="col-md-4">
			    <div class="widget card">
                    <div class="card-header">
						<h2>Latest task queries</h2>
					</div>
				    <div class="card-body no-padding">
					    <div class="listview">
                            <div>
                                <a class="lv-item">
                                    <div class="media">
                                        <div class="pull-left">
                                            <i class="fa fa-filter listview-icon"></i>
                                        </div>
                                        <div class="media-body">
                                            <div class="lv-title">Get all products</div>
                                            <small class="lv-small">mo, 03 okt 2016 15:56</small>
                                        </div>
                                    </div>
                                </a>
                                <a class="lv-item">
                                    <div class="media">
                                        <div class="pull-left">
                                            <i class="fa fa-filter listview-icon"></i>
                                        </div>
                                        <div class="media-body">
                                            <div class="lv-title">Translate to Danish</div>
                                            <small class="lv-small">thu, 04 okt 2016 13:23</small>
                                        </div>
                                    </div>
                                </a>
                                <a class="lv-item">
                                    <div class="media">
                                        <div class="pull-left">
                                            <i class="fa fa-filter listview-icon"></i>
                                        </div>
                                        <div class="media-body">
                                            <div class="lv-title">Fix missing images</div>
                                            <small class="lv-small">mo, 03 okt 2016 17:01</small>
                                        </div>
                                    </div>
                                </a>
                                <a class="lv-item">
                                    <div class="media">
                                        <div class="pull-left">
                                            <i class="fa fa-filter listview-icon"></i>
                                        </div>
                                        <div class="media-body">
                                            <div class="lv-title">My work goals for integrated products</div>
                                            <small class="lv-small">mo, 03 okt 2016 19:44</small>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </div>
				    </div>
			    </div>
		    </div>

            <div class="col-md-3">
			    <div class="widget card">
				    <div class="card-body no-padding">
                        <div class="stats-widget goals">
                            <div class="stats-widget-mark">
                                <div class="stats-widget-mark-text">GOALS</div>
                            </div>
                            <div class="stats-widget-icon"><i class="fa fa-flag-checkered"></i></div>
                            <div class="stats-widget-scores">
                                <div class="stats-widget-complete">235</div>
                                <div class="stats-widget-uncomplete">10987</div>
                                <button class="btn btn-flat stats-widget-continue-btn"><i class="fa fa-play"></i>Continue</button>
                            </div>
                            <div class="stats-widget-info">
                                <span class="stats-widget-info-label"><i class="fa fa-filter"></i> Fix missing images</span>
                                <span class="stats-widget-info-edit"><i class="fa fa-gear"></i></span>									
						    </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
			    <div class="widget card">
				    <div class="card-body no-padding">
                        <div class="stats-widget query">
                            <div class="stats-widget-mark">
                                <div class="stats-widget-mark-text">QUERY</div>
                            </div>
                            <div class="stats-widget-icon"><i class="fa fa-filter"></i></div>
                            <div class="stats-widget-scores">
                                <div class="stats-widget-complete">599</div>
                                <div class="stats-widget-uncomplete"></div>
                                <button class="btn btn-flat stats-widget-continue-btn"><i class="fa fa-play"></i>Continue</button>
                            </div>
                            <div class="stats-widget-info">
                                <span class="stats-widget-info-label"><i class="fa fa-filter"></i> My product query</span>
                                <span class="stats-widget-info-edit"><i class="fa fa-gear"></i></span>									
						    </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
			    <div class="widget card">
				    <div class="card-body no-padding">
					    <div class="chart chart-body pcm-work-progress-chart" data-type="Line">
						    <div class="ct-chart ct-major-tenth" data-data="{&quot;labels&quot;:[&quot;Fri&quot;,&quot;Sat&quot;,&quot;Sun&quot;,&quot;Mon&quot;,&quot;Tue&quot;,&quot;Wed&quot;,&quot;Thu&quot;],&quot;series&quot;:[140,200,134,97,208,202,187]}"></div>
						    <div class="chart-info">
                                <span class="chart-label">PCM Work progress</span>
                                <span class="chart-count">576</span>									
						    </div>
					    </div>
				    </div>
			    </div>
		    </div>

            <div class="col-md-3">
			    <div class="widget card">
				    <div class="card-body no-padding">
					    <div class="chart chart-body" data-type="Bar">
						    <div class="ct-chart ct-major-tenth" data-data="{&quot;labels&quot;:[&quot;Fri&quot;,&quot;Sat&quot;,&quot;Sun&quot;,&quot;Mon&quot;,&quot;Tue&quot;,&quot;Wed&quot;,&quot;Thu&quot;],&quot;series&quot;:[3,1,4,2,0,1,3]}"></div>
						    <div class="chart-info">
                                <span class="chart-label">Latest orders</span>
                                <span class="chart-count">22</span>									
						    </div>
					    </div>
				    </div>
			    </div>
		    </div>
        </div>
    </section>

    <script src="/Admin/Resources/js/jquery-2.1.1.min.js"></script>
    <script src="/Admin/Resources/vendors/waves/waves.min.js"></script>
    <script src="/Admin/Resources/vendors/maxlength/bootstrap-maxlength.min.js"></script>
    <script src="/Admin/Resources/js/layout/chartist.min.js"></script>
    <script src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script src="/Admin/Resources/js/layout/Actions.js"></script>
    <script src="/Admin/Resources/js/layout/input-functions.js"></script>
    <script src="/Admin/Resources/js/layout/screen-functions.js"></script>
    <script src="/Admin/Resources/js/layout/selector.js"></script>
    <script src="/Admin/Resources/js/layout/listview.js"></script>
    <script src="/Admin/Resources/js/layout/teaser.js"></script>
    <script src="/Admin/Resources/js/layout/initgrid.js"></script>
</body>
</html>
