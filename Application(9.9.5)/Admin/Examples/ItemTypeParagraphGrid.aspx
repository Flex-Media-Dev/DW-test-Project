<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="ItemTypeParagraphGrid.aspx.vb" Inherits="Dynamicweb.Admin.ItemTypeParagraphGrid" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>
<html>
<head>
    <title>Product Edit</title>
    <dw:ControlResources runat="server">
    </dw:ControlResources>

    <style>
        .row {
            position: relative;
            display: flex;
            flex-flow: row;
            justify-content: flex-start;
        }

        .row-spacing {
            left: -8px;
            width: calc(100% + 16px);
        }

        .section-spacing {
            margin: 0 8px;
        }

        .section-4 {
            flex: 4;
        }

        .section-6 {
            flex: 2;
        }

        .section-8 {
            flex: 8;
        }

        .section-12 {
            flex: 12;
        }

        .col-4 {
            width: 33%;
        }

        .col-6 {
            width: 50%;
        }

        @media screen and (max-width: 768px) {
            .row {
                flex-direction: column;
            }
        }

        .form-group {
            width: 100%;
            margin-bottom: 10px;
        }

            .form-group .std {
                width: 60%;
                float: right;
            }

            .form-group.full-width .std {
                width: 100%;
            }

        .form-label {
            display: inline-block;
            padding-top: 4px;
        }

        input:active,
        input:focus {
            outline: 0;
            box-shadow: none;
        }

        .form-control {
            padding: 6px 8px;
            border: 1px solid #bdbdbd;
            width: 100%;
            box-sizing: border-box;
        }

            .form-control:focus {
                box-shadow: 0 0 4px 0 rgba(0,0,0,0.34);
                transition: all 200ms;
            }

        .card-header-condensed {
            padding: 5px;
        }

        .card-header-title {
            padding: 11px;
        }

        .header-actions {
            float: right;
        }

        .header-actions-btn {
            font-size: 18px;
            color: #757575;
        }

        .header-publish-btn {
            font-size: 32px;
            background-color: transparent;
            margin: 0 11px 0 20px;
            padding: 0;
        }

        .paragraph-list-header {
            width: 100%;
            height: 28px;
            background-color: #f7f7f7;
            display: inline-block;
            vertical-align: bottom;
            padding-top: 2px;
            border: 1px solid #bdbdbd;
            border-bottom: 0;
            box-sizing: border-box;
        }

            .paragraph-list-header .btn {
                padding: 2px 6px;
                font-size: 12px;
                margin-right: 5px;
            }

            .paragraph-list-header .form-group {
                width: 170px;
            }

        .paragraph-list-header-info {
            float: right;
            color: #bdbdbd;
            margin-top: 3px;
            margin-right: 8px;
        }

        .paragraph-list-header .control-label {
            display: none;
        }

        .paragraph-list-header label {
            right: -10px;
        }

        .grid-container {
            position: relative;
        }

        .paragraph-grid {
            z-index: 10;
            position: relative;
            inset 0px 0px 8px 0px rgba(0,0,0,0.62)
        }

        .paragraph-grid-page {
            max-width: 800px;
            width: 100%;
            margin: 0 auto;
            min-height: 800px;
        }

        .paragraph-grid-background {
            position: absolute;
            background-color: #9E9E9E;
            width: 100%;
            top: 0;
        }

        .paragraph-grid-page--background {
            border-right: 1px dashed #757575;
            border-left: 1px dashed #757575;
            background-color: #e0e0e0;
        }

        .paragraph-grid-background-row {
            border-bottom: 1px dashed #757575;
        }

        .paragraph-grid-background-col {
            height: 200px;
            border-left: 1px dashed #757575;
        }

        .widget-item {
            height: 186px;
            padding: 10px;
            background-color: #fff;
            margin: 8px;
            box-sizing: border-box;
            cursor: move;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .widget-item:hover {
            border: 4px solid #333;
            box-shadow: 0 8px 17px 0 rgba(0, 0, 0, 0.2);
        }

        .widget-item__header {
            display: inline-block;
            width: 100%;
        }

        .widget-item__header i {
            font-size: 22px;
        }

        .widget-item__body {
            background-color: #bdbdbd;
            height: 85px;
        }

        .widget-item__name {
            line-height: 85px;
            text-align: center;
            text-transform: uppercase;
        }

        .widget-item__footer {
            display: inline-block;
            width: 100%;
            position: absolute;
            bottom: 15px;
        }

        .widget-item__title {
            font-weight: bold;
        }

        .widget-item__info {
            font-size: 12px;
        }

        .side-panel {
            width: 280px;
            height: 100%;
            display: inline-block;
            float: left;
            background: #fff;
            box-shadow: 0 0 10px rgba(51,51,51,.38);
        }

        .side-panel-header {
            background-color: #f5f5f5;
            padding: 16px 10px 16px 16px;
        }

            .side-panel-header h2 {
                font-size: 18px;
                margin: 5px 0;
                font-weight: 500;
            }

        .side-panel-group-header {
            padding: 0px 16px 10px;
            margin: 10px 0;
            border-bottom: 1px solid #bdbdbd;
        }

        .side-panel-body {
            overflow: auto;
            height: calc(100% - 66px);
        }

        .side-panel-group-header h3 {
            font-size: 14px;
            text-transform: uppercase;
            color: #616161;
            line-height: 1;
            padding: 0;
            margin: 0;
        }

        .side-panel-open {
            display: inline-block;
            width: calc(100% - 280px);
            vertical-align: top;
            float: left;
            height: 100%;
        }

        .itemtype-widget-item {
            margin: 16px;
            display: inline-block;
            border: 1px solid #bdbdbd;
            cursor: move;
            transition: box-shadow 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

            .itemtype-widget-item:hover {
                box-shadow: 0 8px 17px 0 rgba(0, 0, 0, 0.2);
            }
    </style>
</head>
<body class="area-blue">
    <div class="screen-container side-panel-open">
        <div class="row row-spacing">
            <div class="section-12 section-spacing">
                <div class="card">
                    <div class="card-header card-header-condensed">
                        <div class="card-header-title pull-left">
                            <h2>Home</h2>
                        </div>

                        <div class="header-actions">
                            <button class="btn btn-clean header-actions-btn"><i class="fa fa-pencil-square"></i></button>
                            <button class="btn btn-clean header-actions-btn"><i class="md md-pageview"></i></button>
                            <button class="btn btn-clean header-actions-btn"><i class="fa fa-question-circle"></i></button>
                            <button class="btn btn-clean header-publish-btn"><i class="fa fa-check-circle color-success"></i></button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="paragraph-list-header">
                            <button class="btn pull-right"><i class="fa fa-list"></i></button>
                            <button class="btn pull-right"><i class="fa fa-table"></i></button>
                        </div>

                        <div class="grid-container">
                            <div class="paragraph-grid">
                               <div class="paragraph-grid-page"> 
                                   <div class="row">
                                        <div class="col-4 widget-item">
                                            <div class="widget-item__header">
                                                <div class="pull-left">
                                                    <i class="fa fa-pencil-square"></i>
                                                </div>
                                                <div class="pull-right">
                                                    <i class="fa fa-check-circle color-success"></i>
                                                </div>
                                            </div>
                                            <div class="widget-item__body">
                                                <div class="widget-item__name">Paragraph</div>
                                            </div>
                                            <div class="widget-item__footer">
                                                <div class="widget-item__title">My paragraph one</div>
                                                <div class="widget-item__info">System administrator</div>
                                                <div class="widget-item__info">Thu, 06 Aug 2015 11:33</div>
                                            </div>
                                        </div>
                                        <div class="col-4 widget-item">
                                            <div class="widget-item__header">
                                                <div class="pull-left">
                                                    <i class="fa fa-pencil-square"></i>
                                                </div>
                                                <div class="pull-right">
                                                    <i class="fa fa-check-circle color-success"></i>
                                                </div>
                                            </div>
                                            <div class="widget-item__body">
                                                <div class="widget-item__name">Paragraph</div>
                                            </div>
                                            <div class="widget-item__footer">
                                                <div class="widget-item__title">My paragraph two</div>
                                                <div class="widget-item__info">System administrator</div>
                                                <div class="widget-item__info">Thu, 06 Aug 2015 11:33</div>
                                            </div>
                                        </div>
                                        <div class="col-4 widget-item">
                                            <div class="widget-item__header">
                                                <div class="pull-left">
                                                    <i class="fa fa-pencil-square"></i>
                                                </div>
                                                <div class="pull-right">
                                                    <i class="fa fa-times-circle color-danger"></i>
                                                </div>
                                            </div>
                                            <div class="widget-item__body">
                                                <div class="widget-item__name">Paragraph</div>
                                            </div>
                                            <div class="widget-item__footer">
                                                <div class="widget-item__title">My paragraph three</div>
                                                <div class="widget-item__info">System administrator</div>
                                                <div class="widget-item__info">Thu, 06 Aug 2015 11:33</div>
                                            </div>
                                        </div>
                                   </div> 
                                   <div class="row">
                                        <div class="col-6 widget-item">
                                            <div class="widget-item__header">
                                                <div class="pull-left">
                                                    <i class="fa fa-pencil-square"></i>
                                                </div>
                                                <div class="pull-right">
                                                    <i class="fa fa-check-circle color-success"></i>
                                                </div>
                                            </div>
                                            <div class="widget-item__body">
                                                <div class="widget-item__name">Banner</div>
                                            </div>
                                            <div class="widget-item__footer">
                                                <div class="widget-item__title">New items</div>
                                                <div class="widget-item__info">System administrator</div>
                                                <div class="widget-item__info">Thu, 06 Aug 2015 11:33</div>
                                            </div>
                                        </div>
                                        <div class="col-6 widget-item">
                                            <div class="widget-item__header">
                                                <div class="pull-left">
                                                    <i class="fa fa-pencil-square"></i>
                                                </div>
                                                <div class="pull-right">
                                                    <i class="fa fa-check-circle color-success"></i>
                                                </div>
                                            </div>
                                            <div class="widget-item__body">
                                                <div class="widget-item__name">-| Customized |-</div>
                                            </div>
                                            <div class="widget-item__footer">
                                                <div class="widget-item__title">Latest work</div>
                                                <div class="widget-item__info">System administrator</div>
                                                <div class="widget-item__info">Thu, 06 Aug 2015 11:33</div>
                                            </div>
                                        </div>
                                   </div>
                               </div>
                            </div>

                            <div class="paragraph-grid-background">
                                <div class="paragraph-grid-page paragraph-grid-page--background">
                                    <div class="row paragraph-grid-background-row">
                                        <div class="section-12">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                    </div> 

                                    <div class="row paragraph-grid-background-row">
                                        <div class="section-12">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                    </div>

                                    <div class="row paragraph-grid-background-row">
                                        <div class="section-12">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                    </div>

                                    <div class="row paragraph-grid-background-row">
                                        <div class="section-12">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                        <div class="section-12 paragraph-grid-background-col">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card-footer">
                        <div class="text-center">
                            <button class="btn"><i class="fa fa-plus-square"></i> Add row</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="side-panel">
        <div class="side-panel-header">
            <h2>Content widgets</h2>
        </div>
        <div class="side-panel-body">
            <div class="side-panel-group">
                <div class="side-panel-group-header">
                    <h3>Basic paragraphs</h3>
                </div>
                <div class="side-panel-group-body">
                    <div class="itemtype-widget-item" draggable="true" ondragover="allowDrop(event)">
                        <img src="/Admin/Examples/Images/widgets/dw_iwidget_paragraph.png" />
                    </div>
                    <div class="itemtype-widget-item" draggable="true" ondragover="allowDrop(event)">
                        <img src="/Admin/Examples/Images/widgets/dw_iwidget_image_left.png" />
                    </div>
                    <div class="itemtype-widget-item" draggable="true" ondragover="allowDrop(event)">
                        <img src="/Admin/Examples/Images/widgets/dw_iwidget_image_right.png" />
                    </div>
                </div>
            </div>
            <div class="side-panel-group">
                <div class="side-panel-group-header">
                    <h3>Predefined collections</h3>
                </div>
                <div class="side-panel-group-body">
                    <div class="itemtype-widget-item" draggable="true" ondragover="allowDrop(event)">
                        <img src="/Admin/Examples/Images/widgets/dw_iwidget_services.png" />
                    </div>
                    <div class="itemtype-widget-item" draggable="true" ondragover="allowDrop(event)">
                        <img src="/Admin/Examples/Images/widgets/dw_iwidget_testimonial.png" />
                    </div>
                </div>
            </div>
            <div class="side-panel-group">
                <div class="side-panel-group-header">
                    <h3>Advertisements</h3>
                </div>
                <div class="side-panel-group-body">
                    <div class="itemtype-widget-item" draggable="true" ondragover="allowDrop(event)">
                        <img src="/Admin/Examples/Images/widgets/dw_iwidget_banner.png" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

<script>
    function allowDrop(e) {
        e.preventDefault();
    }

    function drag(e) {
        e.dataTransfer.setData("text", e.target.id);
    }

    function drop(e) {
        e.preventDefault();
        var data = e.dataTransfer.getData("text");
        e.target.appendChild(document.getElementById(data));
    }
</script>
