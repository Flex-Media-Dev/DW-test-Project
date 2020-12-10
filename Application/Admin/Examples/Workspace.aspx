<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="Workspace.aspx.vb" Inherits="Dynamicweb.Admin.Workspace" %>

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
        /*.row {
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

        .col-md-4 .widget.no-card-header .ct-chart {
            margin-top: 22px;
        }

        .col-md-3 .chart-body {
            padding-top: 10px;
        }

        .col-md-3 .ct-chart {
            height: 136px;
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

        .widgets-edit-bar {
            border-top: 1px solid #bdbdbd;
            padding: 20px;
            text-align: center;
        }*/

        
    </style>
</head>
<body class="sw-toggled-off boxed-fields">
    <section id="content">
         <div class="container">
            
             <div class="col-md-4">
				<div class="widget card">
					<div class="card-header">
						<h2>Last edited paragraphs</h2>
					</div>
					<div class="card-body no-padding">
						<div class="listview hover" data-datasource="">
                            <div>
                                <div class="lv-item with-right-icon" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">05 June 2017 - System administration</small>
                                        <div class="lv-title">Products</div>
                                    </div>
                                    <div class="right">
                                        <i class="fa fa-archive"></i>
                                    </div>
                                </div>
                                <div class="lv-item with-right-icon" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">01 June 2017 - System administration</small>
                                        <div class="lv-title">Outdoor experience</div>
                                    </div>
                                    <div class="right">
                                        <i class="fa fa-file-text-o"></i>
                                    </div>
                                </div>
                                <div class="lv-item with-right-icon" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">30 May 2017 - System administration</small>
                                        <div class="lv-title">Indoor experience</div>
                                    </div>
                                    <div class="right">
                                        <i class="fa fa-file-text-o"></i>
                                    </div>
                                </div>
                                <div class="lv-item with-right-icon" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">21 May 2017 - System administration</small>
                                        <div class="lv-title">Cart</div>
                                    </div>
                                    <div class="right">
                                        <i class="fa fa-shopping-cart"></i>
                                    </div>
                                </div>
                                <div class="lv-item with-right-icon" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">16 May 2017 - System administration</small>
                                        <div class="lv-title">Abandon cart email</div>
                                    </div>
                                    <div class="right">
                                        <i class="md md-assignment"></i>
                                    </div>
                                </div>
                                <div class="lv-item with-right-icon" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">14 May 2017 - System administration</small>
                                        <div class="lv-title">Experience for two Experience for two Experience for two Experience for two Experience for two</div>
                                    </div>
                                    <div class="right">
                                        <i class="fa fa-file-text-o"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock"></i>Permissions
                                    </a>
                                </li>
                            </ul>
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
						<div class="listview hover" data-datasource="">
                            <div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body color-red">
                                        <small class="lv-small">14 May 2017, 12:05</small>
                                        <div class="lv-title">Adam Mikkelsen</div>
                                    </div>
                                    <div class="right">
                                        799 DKK
                                    </div>
                                </div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body color-red">
                                        <small class="lv-small">14 May 2017, 12:05</small>
                                        <div class="lv-title">Maria Olsen</div>
                                    </div>
                                    <div class="right">
                                        299 DKK
                                    </div>
                                </div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body color-orange">
                                        <small class="lv-small">14 May 2017, 12:05</small>
                                        <div class="lv-title">ow@mail.com</div>
                                    </div>
                                    <div class="right">
                                        399 DKK
                                    </div>
                                </div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body color-green">
                                        <small class="lv-small">14 May 2017, 12:05</small>
                                        <div class="lv-title">Maria Olsen</div>
                                    </div>
                                    <div class="right">
                                        899 DKK
                                    </div>
                                </div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body color-green">
                                        <small class="lv-small">14 May 2017, 12:05</small>
                                        <div class="lv-title">jan@olsen.dk</div>
                                    </div>
                                    <div class="right">
                                        1200 DKK
                                    </div>
                                </div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body color-green">
                                        <small class="lv-small">14 May 2017, 12:05</small>
                                        <div class="lv-title">Maria Olsen</div>
                                    </div>
                                    <div class="right">
                                        2399 DKK
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock "></i>Permissions
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
				</div>
			</div>

            <div class="col-md-4">
				<div class="widget card">
					<div class="card-header">
						<h2>Last edited paragraphs</h2>
					</div>
					<div class="card-body no-padding">
						<div class="listview hover" data-datasource="">
                            <div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">05 June 2017, 10:17</small>
                                        <div class="lv-title">Products</div>
                                    </div>
                                    <div class="right">
                                        London, UK
                                    </div>
                                </div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">01 June 2017, 11:23</small>
                                        <div class="lv-title">Front page</div>
                                    </div>
                                    <div class="right">
                                        Aarhus, DK
                                    </div>
                                </div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">30 May 2017, 15:25</small>
                                        <div class="lv-title">Front page</div>
                                    </div>
                                    <div class="right">
                                        Aarhus, DK
                                    </div>
                                </div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">21 May 2017, 01:15</small>
                                        <div class="lv-title">Cart</div>
                                    </div>
                                    <div class="right">
                                        Washington, US
                                    </div>
                                </div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">16 May 2017, 18:12</small>
                                        <div class="lv-title">Products</div>
                                    </div>
                                    <div class="right">
                                        Vladivostok, RU
                                    </div>
                                </div>
                                <div class="lv-item with-right-text" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">14 May 2017, 14 May 2017, 19:30 v 14 May 2017, 19:3014 May 2017, 19:3014 May 2017, 19:30 19:30</small>
                                        <div class="lv-title">Support Support Support v Support Support Support</div>
                                    </div>
                                    <div class="right">
                                        Washington, US Washington, US Washington, US Washington, US Washington, US
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock"></i>Permissions
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
			    </div>
            </div>

            <div class="col-md-4">
				<div class="widget card">
					<div class="card-header">
						<h2>Last edited paragraphs</h2>
					</div>
					<div class="card-body no-padding">
						<div class="listview hover" data-datasource="">
                            <div>
                                <div class="lv-item" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">05 June 2017, 10:17 05 June 2017, 10:17 05 June 2017, 10:17 v 05 June 2017, 10:17 05 June 2017, 10:17 05 June 2017, 10:17</small>
                                        <div class="lv-title">Products Products Products Products Products Products Products Products Products</div>
                                    </div>
                                </div>
                                <div class="lv-item" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">01 June 2017, 11:23</small>
                                        <div class="lv-title">Front page</div>
                                    </div>
                                </div>
                                <div class="lv-item" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">30 May 2017, 15:25</small>
                                        <div class="lv-title">Front page</div>
                                    </div>
                                </div>
                                <div class="lv-item" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">21 May 2017, 01:15</small>
                                        <div class="lv-title">Cart</div>
                                    </div>
                                </div>
                                <div class="lv-item" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">16 May 2017, 18:12</small>
                                        <div class="lv-title">Products</div>
                                    </div>
                                </div>
                                <div class="lv-item" onclick="#">
                                    <div class="body">
                                        <small class="lv-small">14 May 2017, 19:30</small>
                                        <div class="lv-title">Support</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock"></i>Permissions
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
			    </div>
            </div>
            
            <div class="col-md-2">
			    <div class="widget card">
                    <div class="card-body no-padding">
                        <div class="widget__counter">
					        <h2 class="counter-title">Products in total</h2>
					        <div class="counter-number widget__counter--md">256</div>
                            <div class="counter-subtitle">Products</div>
                        </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock "></i>Permissions
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
			    </div>
                <div class="widget card">
                    <div class="card-body no-padding">
                        <div class="widget__counter">
					        <h2 class="counter-title">Pages in total</h2>
					        <div class="counter-number widget__counter--sm">97546</div>
                            <div class="counter-subtitle">Pages</div>
                        </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock "></i>Permissions
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
			    </div>
            </div>

            <div class="col-md-4">
	            <div class="widget card" data-actions-visible="False" data-actions="null">
		            <div class="card-header">
			            <h2>Latest news</h2>
		            </div>
		            <div class="card-body no-padding">
			            <div data-datasource="http://dynamicweb.com/dashboard-news" class="teaser"><div><div class="teaser-text"><h3 class="teaser-title">Welcome to Dynamicweb 9</h3><div class="teaser-description">Learn all about the platform and interface.</div><button type="button" class="teaser-button btn btn-flat bgm-orange">Download the release presentation</button></div></div></div>
		            </div>
	            </div>
            </div>

            <div class="col-md-4">
				<div class="widget card">
					<div class="card-header">
						<h2>Last edited paragraphs</h2>
					</div>
					<div class="card-body no-padding">
						<div class="listview hover" data-datasource="">
                            <div>
                                <div class="lv-item with-left-icon" onclick="#">
                                    <div class="left">
                                        <i class="fa fa-archive"></i>
                                    </div>
                                    <div class="body">
                                        <small class="lv-small">05 June 2017 - System administration</small>
                                        <div class="lv-title">Products</div>
                                    </div>
                                </div>
                                <div class="lv-item with-left-icon" onclick="#">
                                    <div class="left">
                                        <i class="fa fa-file-text-o"></i>
                                    </div>
                                    <div class="body">
                                        <small class="lv-small">01 June 2017 - System administration</small>
                                        <div class="lv-title">Outdoor experience</div>
                                    </div>
                                </div>
                                <div class="lv-item with-left-icon" onclick="#">
                                    <div class="left">
                                        <i class="fa fa-file-text-o"></i>
                                    </div>
                                    <div class="body">
                                        <small class="lv-small">30 May 2017 - System administration</small>
                                        <div class="lv-title">Indoor experience</div>
                                    </div>
                                </div>
                                <div class="lv-item with-left-icon" onclick="#">
                                    <div class="left">
                                        <i class="fa fa-shopping-cart"></i>
                                    </div>
                                    <div class="body">
                                        <small class="lv-small">21 May 2017 - System administration</small>
                                        <div class="lv-title">Cart</div>
                                    </div>
                                </div>
                                <div class="lv-item with-left-icon" onclick="#">
                                    <div class="left">
                                        <i class="md md-assignment"></i>
                                    </div>
                                    <div class="body">
                                        <small class="lv-small">16 May 2017 - System administration</small>
                                        <div class="lv-title">Abandon cart email</div>
                                    </div>
                                </div>
                                <div class="lv-item with-left-icon" onclick="#">
                                    <div class="left">
                                        <i class="fa fa-file-text-o"></i>
                                    </div>
                                    <div class="body">
                                        <small class="lv-small">14 May 2017 - System administration</small>
                                        <div class="lv-title">Experience for two Experience for two Experience for two Experience for two Experience for two</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock"></i>Permissions
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
			    </div>
            </div> 
            
            <div class="col-md-2">
			    <div class="widget card">
                    <div class="card-body no-padding">
                        <div class="widget__counter">
					        <h2 class="counter-title">Orders in total</h2>
					        <div class="counter-number widget__counter--xs">2456545</div>
                            <div class="counter-subtitle">Orders</div>
                        </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock "></i>Permissions
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
			    </div>
                <div class="widget card">
                    <div class="card-body no-padding">
                        <div class="widget__counter">
					        <h2 class="counter-title">Products in total</h2>
					        <div class="counter-number widget__counter--xxs">9434357546</div>
                            <div class="counter-subtitle">Products</div>
                        </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock "></i>Permissions
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
			    </div>
            </div>

            <div class="col-md-6">
			    <div class="widget card">
				    <div class="card-header">
						<h2>Orders by day</h2>
					</div>
				    <div class="card-body no-padding">
					    <div class="chart chart-body" data-type="Bar">
						    <div class="ct-chart ct-major-tenth" data-data="{&quot;labels&quot;:[&quot;Fri&quot;,&quot;Sat&quot;,&quot;Sun&quot;,&quot;Mon&quot;,&quot;Tue&quot;,&quot;Wed&quot;,&quot;Thu&quot;],&quot;series&quot;:[3,1,4,2,0,1,3]}"></div>
					    </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock "></i>Permissions
                                    </a>
                                </li>
                            </ul>
                        </div>
				    </div>
			    </div>
		    </div>

            <div class="col-md-6">
			    <div class="widget card">
				    <div class="card-header">
						<h2>Frequently bought items</h2>
					</div>
				    <div class="card-body no-padding">
					    <div class="chart chart-body" data-type="Bar">
						    <div class="ct-chart ct-major-tenth" data-data="{&quot;labels&quot;:[&quot;Mongoose Supergoose Elite BMX Bike&quot;,&quot;Mongoose Supergoose Cruiser BMX&quot;,&quot;GT Mach One Pro BMX Bike&quot;,&quot;GTw Avalanche 3.0 Disc Ladies&quot;,&quot;Performance Century Tight&quot;,&quot;Shimano Ultegra FC-6500 53T&quot;,&quot;Pearl Izumi Women’s Whisper Jacket&quot;],&quot;series&quot;:[10,9,8,6,5,3,2]}"></div>
					    </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock "></i>Permissions
                                    </a>
                                </li>
                            </ul>
                        </div>
				    </div>
			    </div>
		    </div>

            <div class="col-md-6">
			    <div class="widget card">
				    <div class="card-header">
						<h2>Latest created users</h2>
					</div>
				    <div class="card-body no-padding">
					    <div class="chart chart-body" data-type="Bar">
						    <div class="ct-chart ct-major-tenth" data-data="{&quot;labels&quot;:[&quot;Mongoose Supergoose Elite BMX Bike&quot;,&quot;Mongoose Supergoose Cruiser BMX&quot;,&quot;GT Mach One Pro BMX Bike&quot;,&quot;GTw Avalanche 3.0 Disc Ladies&quot;,&quot;Performance Century Tight&quot;,&quot;Shimano Ultegra FC-6500 53T&quot;,&quot;Pearl Izumi Women’s Whisper Jacket&quot;],&quot;series&quot;:[10,9,8,6,5,3,2]}"></div>
					    </div>
                        <div class="dropdown">
                            <button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false">
                                <i class="md md-more-vert"></i>
                            </button>
                            <ul class="dropdown-menu dm-icon pull-left" role="menu">
                                <li role="presentation" style="margin-left: 0px; opacity: 1;">
                                    <a href="#" role="menuitem" tabindex="-1" class="context-btn">
                                        <i class="fa fa-lock "></i>Permissions
                                    </a>
                                </li>
                            </ul>
                        </div>
				    </div>
			    </div>
		    </div>

            

            <div class="col-md-12">
                <div class="widgets-edit-bar">
                    <button class="btn"><i class="fa fa-pencil"></i> Edit workspace</button>
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
