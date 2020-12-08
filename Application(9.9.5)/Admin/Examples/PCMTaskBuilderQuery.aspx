<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="PCMTaskBuilderQuery.aspx.vb" Inherits="Dynamicweb.Admin.PCMTaskBuilderQuery" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head>
    <title>Product Edit</title>
    <dw:ControlResources runat="server">
    </dw:ControlResources>

    <style>
        body {
            overflow-x: hidden;
        }

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

        .card-section-seperator {
            padding-top: 20px;
            width: 100%;
            float: left;
            border-top: 1px solid #e0e0e0;
            margin-top: 8px;
        }

        .card-header-subtitle {
            color: #9E9E9E;
        }

        fieldset .gbTitle .gbSubtitle {
            font-size: 14px;
            color: #bdbdbd;
            margin-top: 15px;
            text-transform: none;
            font-weight: 300;
        }

        .header-actions .btn {
            margin-left: 5px;
            background-color: #e0e0e0;
        }

        .header-actions .seperator {
            height: 28px;
            margin-left: 7px;
            margin-right: 3px;
            border-left: 1px solid #e0e0e0;
        }


        .pcm-list-header-query {
            float: right;
            background-color: #eee;
            border: 1px solid #03A9F4; 
            transition: all ease-in 0.2s;
            margin-right: 10px;
        }

        .pcm-list-header-query-update {
            background-color: #03A9F4;
        }

        .pcm-list-header-query-update .pcm-list-header-query-icon, .pcm-list-header-query-update .pcm-bulk-edit-counter, .pcm-list-header-query-update .pcm-list-header-query-cart-btn {
            color: #fff;
        }

        .pcm-list-header-query-mark {
            color: #fff;
            background-color: #03A9F4;
            display: inline-block;
            float: left;
            width: 16px;
            height: 50px;
        }

        .pcm-list-header-query-mark-text {
            transform: rotate(270deg);
            margin-top: 26px;
            font-size: 12px;
        }

        .pcm-list-header-query-icon {
            display: inline-block;
            margin: 0 5px;
            vertical-align: top;
            font-size: 35px;
            color: #616161;
        }

        .pcm-list-header-query-cart {
            display: inline-block;
        }

        .pcm-query-counter {
            background-color: rgba(0,0,0,0.1);
            color: #03A9F4;
            padding: 0 5px;
            border-radius: 100px;
            font-size: 12px;
            font-weight: bold;
            text-align: right;
            margin: 5px 5px 0;
        }



        .pcm-task-builder-progressbar {
            padding: 15px;
            display: flex;
        }

        .pcm-task-builder-progressbar-step {
            display: inline-block;
            flex: 6;
            text-align: center;
        }

        .pcm-task-builder-progressbar-step::after {
            content: " ";
            width: 100%;
            display: flex;
            border-top: 2px solid #eeeeee;
            margin-top: -35px;
            margin-left: 50%;
            padding-bottom: 35px;
        }

        .pcm-task-builder-progressbar-step-last::after {
            border: 0;
        }

        .pcm-task-builder-progressbar-step-active .pcm-task-builder-progressbar-step-number {
            background-color: #4CAF50;
            color: #fff;
            width: 34px;
            height: 29px;
            padding-top: 6px;
            margin-top: 3px;
            margin-bottom: 2px;
        }

        .pcm-task-builder-progressbar-step-active .pcm-task-builder-progressbar-step-label {
            color: #4CAF50;
            font-weight: bold;
        }

        .pcm-task-builder-progressbar-step-active::before {
            content: " ";
            border: 1px solid #4CAF50;
            background-color: #fff;
            position: absolute;
            width: 40px;
            height: 40px;
            border-radius: 100px;
            transform: translateX(-50%);
        }               

        .pcm-task-builder-progressbar-step-number {
            background-color: #eeeeee;
            border-radius: 100px;
            width: 42px;
            height: 32px;
            color: #bdbdbd;
            text-align: center;
            padding-top: 9px;
            font-size: 16px;
            font-weight: bold;
            margin-left: 50%;
            transform: translateX(-50%);
        }

        .pcm-task-builder-progressbar-step-label {
            text-transform: uppercase;
            color: #9E9E9E;
            font-size: 12px;
        }

        .pcm-wizard-content {
            width: 100%;
            text-align: center;
        }

        .pcm-query {
            max-width: 600px;
            padding: 15px;
            display: inline-block;
            position: relative;
        }

        .pcm-tool-info {
            margin: 5px 0 15px;
            text-align: left;
            font-size: 20px;
        }

        .pcm-tool-info h2 {
            text-transform: uppercase;
            font-size: 12px;
            color: #9e9e9e; 
        }

        .pcm-query-filters, .pcm-work-goals {
            display: block;
            float: left;
            width: 100%;
            background-color: #e0e0e0;
        }

        .pcm-query-filter-group {
            border: 1px solid #9E9E9E;
            border-left: 8px solid #9E9E9E;
            box-sizing: border-box;
            height: 100%;
            display: inline-block;
            box-sizing: border-box;
            width: calc(100% - 10px);
            float: left;
            margin: 5px;
            background-color: #fafafa;
            transition: all ease-in 0.2s; 
        }

        .pcm-query-filter-group-focus {
            border: 1px solid #03A9F4;
            border-left: 8px solid #03A9F4;
        }

        .pcm-query-filter-item, .pcm-work-goal-item {
            display: inline-block;
            text-align: left;
            float: left;
            width: 100%;
        }

        .pcm-query-filter-check {
            height: 32px;
            display: inline-block;
            width: 15px;
            padding: 5px;
            float:left;
        }

        .pcm-query-filter-check label {
            margin-top: 4px;
        }

        .pcm-query-filter-next {
            height: 32px;
            display: inline-block;
            width: 50px;
            padding: 5px;
            float:left;
        }

        .pcm-query-filter-fieldselector, .pcm-query-filter-valueselector {
            height: 32px;
            display: inline-block;
            width: calc(50% - 80px);
            padding: 5px;
            float:left;
        }

        .pcm-query-filter-fieldselector .std, .pcm-query-filter-valueselector .std {
            width: 100% !important;
        }

        .conditiontype {
            height: 32px;
            display: inline-block;
            width: 20px;
            padding: 5px;
            float:left;
            cursor: pointer;
        }

        .condition-icon {
            border-radius: 200px;
            color: #fff;
            font-weight: bold;
            text-align: center;
            font-size: 15px;
            margin-top: 5px;
            width: 20px;
            display: inline-block;
        }

        .conditionselector {
            padding: 5px;
            padding-right: 15px;
            display: inline-block;
            background-color: #fafafa;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
            position: absolute;
            z-index: 1;
            margin-left: -30px;
            display: none;
        }

        .conditionselector-option {
            cursor: pointer;
        }

        .condition-icon.equal {
            background-color: #03A9F4;
        }

        .condition-icon.not {
            background-color: #F44336;
        }

        .condition-icon.contains {
            background-color: #4CAF50;
        }

        .condition-icon.less {
            background-color: #FFC107;
        }

        .condition-icon.lessequal {
            background-color: #FF9800;
        }

        .condition-icon.greater {
            background-color: #9C27B0;
        }

        .condition-icon.greaterequal {
            background-color: #673AB7;
        }

        .pcm-query-filter-remove {
            height: 32px;
            display: inline-block;
            width: 15px;
            padding: 5px;
            float:left;
        }

        .pcm-query-filter-remove i {
            margin-top: 8px;
            cursor: pointer;
        }

        .pcm-query-condition-seperator {
            color: #fff;
            border-radius: 100px;
            height: 20px;
            display: inline-block;
            float: left;
            padding: 0px 15px;
            margin-bottom: 5px;
            margin-top: 5px;
            margin-left: 50%;
            transform: translateX(-50%);
            cursor: pointer;
        }

        .condition-seperator-and {
           background-color: #E91E63;
        }

        .condition-seperator-or {
           background-color: #FFC107;
        }

        .pcm-query-actions, .pcm-work-goal-actions {
            display: block;
            float: left;
            text-align: left;
            background-color: #9E9E9E;
            padding: 5px;
            width: calc(100% - 10px);
        }

        .pcm-query-actions-btn-mark-and {
            background-color: #E91E63;
            color: #fff;
            padding: 0 4px;
            font-weight: bold;
            display: inline-block;
        }

        .pcm-query-actions-btn-mark-or {
            background-color: #FFC107;
            color: #fff;
            padding: 0 4px;
            font-weight: bold;
            display: inline-block;
        }

        .pcm-work-goal-builder {
            max-width: 600px;
            padding: 15px;
            display: inline-block;
            position: relative;
        }

        .pcm-work-goal-item {
            border: 1px solid #8BC34A; 
            box-sizing: border-box;
            margin: 5px;
            width: calc(100% - 10px);
            background-color: #fafafa;
        }

        .pcm-work-goal-item-mark {
            color: #fff;
            background-color: #8BC34A;
            display: inline-block;
            float: left;
            width: 20px;
            height: 60px;
        }

        .pcm-work-goal-item-mark-text {
            transform: rotate(270deg);
            margin-top: 29px;
        }

        .pcm-work-goal-item .pcm-query-filter-fieldselector, .pcm-work-goal-item .conditiontype, .pcm-work-goal-item .pcm-query-filter-valueselector, .pcm-work-goal-item .pcm-query-filter-remove {
            margin-top: 9px;
        }

        .pcm-selction-box-from-goal {
            color: #9E9E9E;
        }

        .pcm-selection-box .control-label {
            text-transform: uppercase;
            color: #9E9E9E;
            font-size: 12px;
            margin-bottom: 5px;
        }

        .pcm-selction-box-left, .pcm-selection-box-btn-group, .pcm-selction-box-right {
            display: inline-block;
        }

        .pcm-selction-box-left, .pcm-selction-box-right {
            width: calc(50% - 18px);
        }

        .pcm-selction-box-left .form-control, .pcm-selction-box-right .form-control {
            width: 100%;
            height: 220px;
        }

        .pcm-selection-box-btn-group {
            vertical-align: top;
            margin-top: 105px;
        }

        .pcm-selction-box-from-goal::before {
            font-family: "FontAwesome";
            content: "\f11e";
            margin-right: 5px;
        }

        .pcm-action-bar {
            border-top: 1px solid #bdbdbd;
            padding: 15px;
            display: block;
            height: 32px;
        }

        .pcm-success-btn {
            background-color: #4CAF50;
            color: #fff;
        }





        .pcm-query-preview-header {
            border-top: 1px solid #bdbdbd;
            background-color: #fafafa;
            padding: 15px;
            display: block;
            height: 20px;
        }

        .pcm-query-preview-header-title {
            font-size: 14px;
            color: #616161;
            text-transform: uppercase;
            font-weight: bold;
            float: left;
        }

        .pcm-query-preview-header-title i {
            margin-right: 15px;
        }

        .pcm-query-preview-header-info {
            float: right;
            color: #bdbdbd;
        }

        .pcm-query-preview-header-info i {
            margin-left: 15px;
        }


        .pcm-list-header {
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

        .pcm-list-header .btn {
            padding: 2px 6px;
            font-size: 12px;
            margin-right: 5px;
        }

        .pcm-list-header .form-group {
            width: 170px;
        }

        .pcm-list-header-info {
            float:right;
            color: #bdbdbd;
            margin-top: 3px;
            margin-right: 8px;
        }

        .pcm-list-header .control-label {
            display: none;
        }

        .pcm-list-header label {
            right: -2px;
        }

        .pcm-list {
            background-color: #fafafa;
            border: 1px solid #bdbdbd;
        }

        .pcm-list-item {
            width: 100%;
            height: 100%;
            display: flex;
            min-height: 1px;
            border-bottom: 1px solid #bdbdbd;
        }

        .pcm-list-item .form-group {
            border: 0;
            margin-bottom: 0px;
        }

        .pcm-list-item .form-control {
            border: 1px solid #bdbdbd;
	        padding: 4px 6px;
	        resize: none;
	        background-color: #fff;
	        font-size: 14px;
	        line-height: 22px;
            outline: none;
            box-sizing: border-box;
            width: calc(100% - 8px);
        }

        .pcm-list-item .form-control:disabled {
            background-color: #eee;
            border: 0;
        }

        .pcm-list-item .form-control:focus {
            box-shadow: 0 0 4px 0 rgba(0,0,0,.34);
            transition: all 200ms;
        }

        .pcm-list-state {
            width: 22px;
            min-height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #eee;
            box-sizing: border-box;
            text-align: center;
            transition: all ease-out 0.3s;                             
        }

        .state-warning {
            background-color: #FFC107;
            color: #fff;
        }

        .state-warning::after {
            font-family: "FontAwesome";
            content: "\f12a";
        }

        .state-success {
            background-color: #8BC34A;
            color: #fff;
        }

        .state-success::after {
            font-family: "FontAwesome";
            content: "\f00c";
        }

        .pcm-list-check {
            position: absolute;
        }

        .pcm-list-check .control-label {
            display: none;
        }

        .pcm-list-check label {
            right: -2px;
        }

        .pcm-list-left {
            display: inline-block;
        }

        .pcm-list-productnumber {
            background-color: #eeeeee;
            color: #9E9E9E;
            font-size: 12px;
            margin-left: 5px;
            width: calc(100% - 10px);
            top: 5px;
            position: relative;
        }

        .pcm-thumb {
            border: 1px solid #eee;
            vertical-align: top;
            margin: 5px;
            margin-top: 8px;
            width: 100px;
            height: 66px;
            cursor: pointer;
            background-color: #e0e0e0; 
            transition: all ease-in 0.2s; 
        }

        .pcm-thumb i {
            margin-left: 40px;
            margin-top: 25px;
            font-size: 22px;
            opacity: 1;
            transition: all ease-in 0.2s; 
        }

        .pcm-thumb:hover i {
            opacity: 0;
        }

        .pcm-thumb::before {
            font-family: "FontAwesome";
            content: "\f14b";
            position: absolute;
            opacity: 0;
            margin-left: 40px;
            margin-top: 25px;
            font-size: 22px;
            transition: all ease-in 0.2s;
        }

        .pcm-thumb:hover {
            opacity: .8;
        }

        .pcm-thumb:hover:before {
            opacity: 1;
        }

        .pcm-list-fields {
            display: inline-block;
            vertical-align: top;
            margin: 5px 0;
            width: calc(100% - 150px);
        }

        .pcm-list-fields-table {
            width: 100%;
        }

        .pcm-list-table-row {
            height: 36px;
        }

        .pcm-list-fields-table-header {
            text-transform: uppercase;
            color: #9E9E9E;
        }

        .pcm-list-fields-table-header td {
            font-size: 12px;
        }

        .pcm-list-fields-table-header-flag {
            width: 30px;
        }

        .pcm-list-fields-table-info {
            font-size: 18px;
        }

        .pcm-list-publish, .pcm-list-action-icon {
            font-size: 22px;
            padding-right: 4px;
        }

        .pcm-list-action-icon .fa-exchange {
            z-index: 1;
            position: absolute;
            color: #fff;
            font-size: 13px;
            margin-left: 3px;
            margin-top: 9px;
        }

        .pcm-list-header-highscore {
            float: right;
            background-color: #eee;
            border: 1px solid #8BC34A; 
            transition: all ease-in 0.2s;
        }

        .pcm-list-header-highscore-mark {
            color: #fff;
            background-color: #8BC34A;
            display: inline-block;
            float: left;
            width: 16px;
            height: 50px;
        }

        .pcm-list-header-highscore-mark-text {
            transform: rotate(270deg);
            margin-top: 29px;
            font-size: 12px;
        }

        .pcm-list-header-highscore-icon {
            display: inline-block;
            margin: 0 5px;
            vertical-align: top;
            font-size: 35px;
            color: #616161;
        }

        .pcm-list-header-highscore-scores {
            display: inline-block;
        }

        .pcm-list-header-highscore-update {
            background-color: #8BC34A;
        }

        .pcm-list-header-highscore-complete {
            margin: 0px 5px 0 5px;
            color: #8BC34A;
            font-weight: bold;
            font-size: 32px;
            line-height: 1;
            text-align: right;
            display: inline-block;
        }

        .pcm-list-header-highscore-uncomplete {
            margin: 0px 5px 0 5px;
            color: #9E9E9E; 
            font-weight: bold;
            text-align: right;
            line-height: 1;
        }

        .pcm-list-header-highscore-update .pcm-list-header-highscore-icon, .pcm-list-header-highscore-update .pcm-list-header-highscore-complete, .pcm-list-header-highscore-update .pcm-list-header-highscore-uncomplete {
            color: #fff;
        }

        .pcm-list-header-query-cart-btn {
            background-color: rgba(0,0,0,0.1);
            padding: 0px 4px;
            margin: 4px 5px;
        }

        .form-control-state-warning::before {
            font-family: "FontAwesome";
            content: "\f12a";
            padding-top: 9px;
            width: 10px;
            height: calc(100% - 9px);
            color: #fff;
            font-size: 12px;
            background-color: #FFC107;
            text-align: center;
            position: absolute; 
            transition: all ease-out 0.2s; 
        }

        .form-control-state-warning .form-control {
            padding-left: 14px;
            width: calc(100% - 8px);
            border: 1px solid #FFC107;
            background-color: #fff;
            transition: all ease-out 0.2s;
        }
    </style>
</head>
<body class="screen-container">
    <div class="row area-pink">
        <div class="section-12">
            <div class="card">
                <div class="card-header">
                    <div class="row">
                        <div class="section-6">
                            <h2>Task process wizard</h2>
                            <small class="card-header-subtitle">Query products and set task goals</small>
                        </div>
                        <div class="section-6 header-actions">
                            <div class="pcm-list-header-query">
                                <div class="pcm-list-header-query-mark">
                                    <div class="pcm-list-header-query-mark-text">QUERY</div>
                                </div>
                                <div class="pcm-list-header-query-icon">
                                    <i class="fa fa-filter"></i>
                                </div>
                                <div class="pcm-list-header-query-cart">
                                     <div id="pcm-query-counter" class="pcm-query-counter">599</div>
                                     <button id="previewBtn" class="btn pcm-list-header-query-cart-btn">Preview</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-body">
                    <div class="pcm-task-builder-progressbar">
                         <div class="pcm-task-builder-progressbar-step pcm-task-builder-progressbar-step-active">
                             <div class="pcm-task-builder-progressbar-step-number">
                                1
                             </div>
                             <div class="pcm-task-builder-progressbar-step-label">
                                Query
                             </div>
                         </div>

                         <div class="pcm-task-builder-progressbar-step">
                             <div class="pcm-task-builder-progressbar-step-number">
                                2
                             </div>
                             <div class="pcm-task-builder-progressbar-step-label">
                                Goals
                             </div>
                         </div>

                         <div class="pcm-task-builder-progressbar-step">
                             <div class="pcm-task-builder-progressbar-step-number">
                                3
                             </div>
                             <div class="pcm-task-builder-progressbar-step-label">
                                View
                             </div>
                         </div>

                         <div class="pcm-task-builder-progressbar-step">
                             <div class="pcm-task-builder-progressbar-step-number">
                                4
                             </div>
                             <div class="pcm-task-builder-progressbar-step-label">
                                Filters
                             </div>
                         </div>

                         <div class="pcm-task-builder-progressbar-step pcm-task-builder-progressbar-step-last">
                             <div class="pcm-task-builder-progressbar-step-number">
                                <i class="fa fa-check"></i>
                             </div>
                             <div class="pcm-task-builder-progressbar-step-label">
                                Created
                             </div>
                         </div>
                    </div>

                    <div class="pcm-wizard-content">
                        <div class="pcm-query">
                            <div class="pcm-tool-info">
                                <h2>Query</h2>
                                Which products do you want to work with?
                            </div>
                            <div class="pcm-query-filters">
                                <div class="pcm-query-filter-group js-pcm-query-filter-group pcm-query-filter-group-focus group-selected">
                                    <div class="pcm-query-filter-item">
                                        <div class="pcm-query-filter-check">
                                            <input type="checkbox" id="check0" class="checkbox" />
                                            <label for="check0"></label>
                                        </div>
                                        <div class="pcm-query-filter-next"></div>
                                        <div class="pcm-query-filter-fieldselector">
                                            <select class="std">
                                                <option selected>Brand</option>
                                                <option>Color</option>
                                                <option>Price</option>
                                            </select>
                                        </div>
                                        <div class="conditiontype js-conditiontype">
                                            <div class="condition-icon equal">=</div>
                                        </div>
                                        <div class="conditionselector js-conditionselector">
                                            <div class="conditionselector-option"><div class="condition-icon equal">=</div> Equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon not">≠</div> Not equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon contains">≈</div> Contains</div>
                                            <div class="conditionselector-option"><div class="condition-icon less"><</div> Less than</div>
                                            <div class="conditionselector-option"><div class="condition-icon lessequal"><=</div> Less than or equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon greater">></div> Greater than</div>
                                            <div class="conditionselector-option"><div class="condition-icon greaterequal">>=</div> Greater than or equal to</div>
                                        </div>
                                        <div class="pcm-query-filter-valueselector">
                                            <select class="std">
                                                <option selected>Cube</option>
                                                <option>Trek</option>
                                                <option>Specialized</option>
                                            </select>
                                        </div>
                                        <div class="pcm-query-filter-remove">
                                            <i class="fa fa-times color-danger"></i>
                                        </div>
                                    </div>

                                    <div class="pcm-query-filter-item">
                                        <div class="pcm-query-filter-check">
                                            <input type="checkbox" id="check22" class="checkbox" />
                                            <label for="check22"></label>
                                        </div>
                                        <div class="pcm-query-filter-next"><div class="pcm-query-condition-seperator condition-seperator-or">OR</div></div>
                                        <div class="pcm-query-filter-fieldselector">
                                            <select class="std">
                                                <option selected>Brand</option>
                                                <option>Color</option>
                                                <option>Price</option>
                                            </select>
                                        </div>
                                        <div class="conditiontype js-conditiontype">
                                            <div class="condition-icon equal">=</div>
                                        </div>
                                        <div class="conditionselector js-conditionselector">
                                            <div class="conditionselector-option"><div class="condition-icon equal">=</div> Equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon not">≠</div> Not equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon contains">≈</div> Contains</div>
                                            <div class="conditionselector-option"><div class="condition-icon less"><</div> Less than</div>
                                            <div class="conditionselector-option"><div class="condition-icon lessequal"><=</div> Less than or equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon greater">></div> Greater than</div>
                                            <div class="conditionselector-option"><div class="condition-icon greaterequal">>=</div> Greater than or equal to</div>
                                        </div>
                                        <div class="pcm-query-filter-valueselector">
                                            <select class="std">
                                                <option>Cube</option>
                                                <option selected>Trek</option>
                                                <option>Specialized</option>
                                            </select>
                                        </div>
                                        <div class="pcm-query-filter-remove">
                                            <i class="fa fa-times color-danger"></i>
                                        </div>
                                    </div>

                                    <div class="pcm-query-filter-item">
                                        <div class="pcm-query-filter-check">
                                            <input type="checkbox" id="check33" class="checkbox" />
                                            <label for="check33"></label>
                                        </div>
                                        <div class="pcm-query-filter-next"><div class="pcm-query-condition-seperator condition-seperator-or">OR</div></div>
                                        <div class="pcm-query-filter-fieldselector">
                                            <select class="std">
                                                <option selected>Brand</option>
                                                <option>Color</option>
                                                <option>Price</option>
                                            </select>
                                        </div>
                                        <div class="conditiontype js-conditiontype">
                                            <div class="condition-icon equal">=</div>
                                        </div>
                                        <div class="conditionselector js-conditionselector">
                                            <div class="conditionselector-option"><div class="condition-icon equal">=</div> Equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon not">≠</div> Not equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon contains">≈</div> Contains</div>
                                            <div class="conditionselector-option"><div class="condition-icon less"><</div> Less than</div>
                                            <div class="conditionselector-option"><div class="condition-icon lessequal"><=</div> Less than or equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon greater">></div> Greater than</div>
                                            <div class="conditionselector-option"><div class="condition-icon greaterequal">>=</div> Greater than or equal to</div>
                                        </div>
                                        <div class="pcm-query-filter-valueselector">
                                            <select class="std">
                                                <option>Cube</option>
                                                <option>Trek</option>
                                                <option selected>Specialized</option>
                                            </select>
                                        </div>
                                        <div class="pcm-query-filter-remove">
                                            <i class="fa fa-times color-danger"></i>
                                        </div>
                                    </div>
                                </div>

                                <div class="pcm-query-condition-seperator condition-seperator-and">AND</div>

                                <div class="pcm-query-filter-group js-pcm-query-filter-group">
                                     <div class="pcm-query-filter-item">
                                        <div class="pcm-query-filter-check">
                                            <input type="checkbox" id="check44" class="checkbox" />
                                            <label for="check44"></label>
                                        </div>
                                        <div class="pcm-query-filter-next"></div>
                                        <div class="pcm-query-filter-fieldselector">
                                            <select class="std">
                                                <option>Brand</option>
                                                <option>Color</option>
                                                <option selected>Price</option>
                                            </select>
                                        </div>
                                        <div class="conditiontype js-conditiontype">
                                            <div class="condition-icon greater">></div>
                                        </div>
                                        <div class="conditionselector js-conditionselector">
                                            <div class="conditionselector-option"><div class="condition-icon equal">=</div> Equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon not">≠</div> Not equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon contains">≈</div> Contains</div>
                                            <div class="conditionselector-option"><div class="condition-icon less"><</div> Less than</div>
                                            <div class="conditionselector-option"><div class="condition-icon lessequal"><=</div> Less than or equal to</div>
                                            <div class="conditionselector-option"><div class="condition-icon greater">></div> Greater than</div>
                                            <div class="conditionselector-option"><div class="condition-icon greaterequal">>=</div> Greater than or equal to</div>
                                        </div>
                                        <div class="pcm-query-filter-valueselector">
                                            <dwc:InputText runat="server" Value="20"></dwc:InputText>
                                        </div>
                                        <div class="pcm-query-filter-remove">
                                            <i class="fa fa-times color-danger"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="pcm-query-actions">
                                <button type="button" id="add-and-btn" class="btn btn-flat">Add <div class="pcm-query-actions-btn-mark-and">AND</div></button>
                                <button type="button" id="add-or-btn" class="btn btn-flat">Add <div class="pcm-query-actions-btn-mark-or">OR</div></button>
                                <button type="button" id="add-group-btn" class="btn btn-flat"><i class="fa fa-plus-square"></i> Add Group</button>
                                <%--<button type="button" id="group-btn" class="btn btn-flat" disabled><i class="fa fa-caret-square-o-right"></i> Group</button>
                                <button type="button" id="ungroup-btn" class="btn btn-flat"><i class="fa fa-caret-square-o-left"></i> Ungroup</button>--%>
                            </div>
                        </div>
                    </div>

                    <div class="pcm-action-bar">
                        <button class="btn btn-flat pcm-success-btn pull-right" onclick="changePage('/Admin/Examples/PCMTaskBuilderGoals.aspx')">Create query <i class="fa fa-angle-right"></i></button>                    
                    </div>

                    <div class="pcm-query-preview-block">
                        <div class="pcm-query-preview-header">
                            <div class="pcm-query-preview-header-title"><i class="fa fa-refresh"></i>Query preview</div>
                            <div class="pcm-query-preview-header-info">599 products <i class="fa fa-chevron-down"></i></div>
                        </div>
                        <div class="pcm-query-preview">
                            <div class="pcm-list-header">
                                <dwc:CheckBox ID="CheckAll" Name="CheckAll" Label="Check all" DoTranslation="False" runat="server" />
                                <button class="btn pull-right"><i class="fa fa-list"></i></button>
                                <button class="btn pull-right"><i class="fa fa-table"></i></button>
                            </div>

                            <div class="pcm-list">
                                <div class="pcm-list-item">
                                    <div class="pcm-list-check">
                                        <input type="checkbox" ID="CheckBox1" Name="CheckBox1" class="checkbox" />
                                        <label for="CheckBox1" class="js-checkbox-label"></label>
                                    </div>
                                    <div class="pcm-list-state state-warning" id="state1"></div>
                                    <div class="pcm-list-left">
                                        <div class="pcm-list-productnumber">&nbsp;#10121</div>
                                        <div class="pcm-thumb"><img class="img-responsive" src="/Admin/Public/GetImage.ashx?width=100&amp;height=66&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg"></div>
                                    </div>
                                    <div class="pcm-list-fields">
                                        <table class="pcm-list-fields-table">
                                            <thead>                               
                                                <tr class="pcm-list-fields-table-header">
                                                    <td class="pcm-list-fields-table-header-flag"></td>
                                                    <td>Name</td>
                                                    <td>Category</td>
                                                    <td>Stock</td>
                                                    <td>Weight</td>
                                                    <td>Campaign</td>
                                                    <td>Price</td>
                                                    <td></td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr class="pcm-list-table-row">
                                                    <td>
                                                        <i class="flag-icon flag-icon-gb"></i>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Id="title1" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="Category" Value="Bikes"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="15"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="22"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                                    </td>
                                                    <td class="pcm-list-fields-table-info">
                                                        <i class="fa fa-check-circle color-success"></i>
                                                    </td>
                                                </tr>
                                                <tr class="pcm-list-table-row">
                                                    <td>
                                                        <i class="flag-icon flag-icon-dk"></i>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Id="InputText1" Placeholder="Title" Value="Min flotte nye"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="Category" Value="Bikes"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="4.95"></dwc:InputText>
                                                    </td>
                                                    <td class="pcm-list-fields-table-info">
                                                        <i class="fa fa-check-circle color-success"></i>
                                                    </td>
                                                </tr>
                                                <tr class="pcm-list-table-row">
                                                    <td>
                                                        <i class="flag-icon flag-icon-de"></i>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Id="InputText2" Placeholder="Title" Value="Meine schöne neue"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="Category" Value="Bikes"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="5.00"></dwc:InputText>
                                                    </td>
                                                    <td class="pcm-list-fields-table-info">
                                                        <i class="fa fa-times-circle color-retracted"></i>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div class="pcm-list-item">
                                    <div class="pcm-list-check">
                                        <input type="checkbox" ID="CheckBox2" Name="CheckBox2" class="checkbox" />
                                        <label for="CheckBox2" class="js-checkbox-label"></label>
                                    </div>
                                    <div class="pcm-list-state state-success" id="state2"></div>
                                    <div class="pcm-list-left">
                                        <div class="pcm-list-productnumber">&nbsp;#10121</div>
                                        <div class="pcm-thumb"><img class="img-responsive" src="/Admin/Public/GetImage.ashx?width=100&amp;height=66&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10016.jpg"></div>
                                    </div>
                                    <div class="pcm-list-fields">
                                        <table class="pcm-list-fields-table">
                                            <thead>                               
                                                <tr class="pcm-list-fields-table-header">
                                                    <td class="pcm-list-fields-table-header-flag"></td>
                                                    <td>Name</td>
                                                    <td>Category</td>
                                                    <td>Stock</td>
                                                    <td>Weight</td>
                                                    <td>Campaign</td>
                                                    <td>Price</td>
                                                    <td></td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr class="pcm-list-table-row">
                                                    <td>
                                                        <i class="flag-icon flag-icon-gb"></i>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Id="InputText3" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="Category" Value="Bikes"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="15"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="22"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                                    </td>
                                                    <td class="pcm-list-fields-table-info">
                                                        <i class="fa fa-check-circle color-success"></i>
                                                    </td>
                                                </tr>
                                                <tr class="pcm-list-table-row">
                                                    <td>
                                                        <i class="flag-icon flag-icon-dk"></i>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Id="InputText4" Placeholder="Title" Value="Min flotte nye"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="Category" Value="Bikes"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="4.95"></dwc:InputText>
                                                    </td>
                                                    <td class="pcm-list-fields-table-info">
                                                        <i class="fa fa-check-circle color-success"></i>
                                                    </td>
                                                </tr>
                                                <tr class="pcm-list-table-row">
                                                    <td>
                                                        <i class="flag-icon flag-icon-de"></i>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Id="InputText5" Placeholder="Title" Value="Meine schöne neue"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="Category" Value="Bikes"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="5.00"></dwc:InputText>
                                                    </td>
                                                    <td class="pcm-list-fields-table-info">
                                                        <i class="fa fa-times-circle color-retracted"></i>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div class="pcm-list-item">
                                    <div class="pcm-list-check">
                                        <input type="checkbox" ID="CheckBox3" Name="CheckBox3" class="checkbox" />
                                        <label for="CheckBox3" class="js-checkbox-label"></label>
                                    </div>
                                    <div class="pcm-list-state state-success" id="state3"></div>
                                    <div class="pcm-list-left">
                                        <div class="pcm-list-productnumber">&nbsp;#10121</div>
                                        <div class="pcm-thumb"><img class="img-responsive" src="/Admin/Public/GetImage.ashx?width=100&amp;height=66&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10015.jpg"></div>
                                    </div>
                                    <div class="pcm-list-fields">
                                        <table class="pcm-list-fields-table">
                                            <thead>                               
                                                <tr class="pcm-list-fields-table-header">
                                                    <td class="pcm-list-fields-table-header-flag"></td>
                                                    <td>Name</td>
                                                    <td>Category</td>
                                                    <td>Stock</td>
                                                    <td>Weight</td>
                                                    <td>Campaign</td>
                                                    <td>Price</td>
                                                    <td></td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr class="pcm-list-table-row">
                                                    <td>
                                                        <i class="flag-icon flag-icon-gb"></i>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Id="InputText6" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="Category" Value="Bikes"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="15"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="22"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                                    </td>
                                                    <td class="pcm-list-fields-table-info">
                                                        <i class="fa fa-check-circle color-success"></i>
                                                    </td>
                                                </tr>
                                                <tr class="pcm-list-table-row">
                                                    <td>
                                                        <i class="flag-icon flag-icon-dk"></i>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Id="InputText7" Placeholder="Title" Value="Min flotte nye"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="Category" Value="Bikes"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="4.95"></dwc:InputText>
                                                    </td>
                                                    <td class="pcm-list-fields-table-info">
                                                        <i class="fa fa-check-circle color-success"></i>
                                                    </td>
                                                </tr>
                                                <tr class="pcm-list-table-row">
                                                    <td>
                                                        <i class="flag-icon flag-icon-de"></i>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Id="InputText8" Placeholder="Title" Value="Meine schöne neue"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="Category" Value="Bikes"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                                    </td>
                                                    <td>
                                                        <dwc:InputText runat="server" Placeholder="0" Value="5.00"></dwc:InputText>
                                                    </td>
                                                    <td class="pcm-list-fields-table-info">
                                                        <i class="fa fa-times-circle color-retracted"></i>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-footer">
                </div>
            </div>
        </div>
    </div>

    <script>
        function changePage(href) {
            document.location = href;
        }

        document.addEventListener("DOMContentLoaded", function (event) {
            init();

            document.getElementById("previewBtn").onclick = function () {
                window.scrollTo(0, 600);
            }
        });

        function init() {
            var groupselector = document.getElementsByClassName("js-pcm-query-filter-group");
            for (var i = 0; i < groupselector.length; i++) {
                groupselector[i].onclick = function () {
                    var elm = this;

                    clearGroupSelections();

                    elm.classList.add("pcm-query-filter-group-focus");
                    elm.classList.add("group-selected");
                };
            }
            var conditionselector = document.getElementsByClassName("js-conditiontype");
            for (var i = 0; i < conditionselector.length; i++) {
                conditionselector[i].onclick = function () {
                    var elm = this.parentNode.getElementsByClassName("js-conditionselector")[0];
                    elm.style.display = "inline-block";
                };
            }

            var optionselector = document.getElementsByClassName("conditionselector-option");
            for (var i = 0; i < optionselector.length; i++) {
                optionselector[i].onclick = function () {
                    var elm = this;
                    elm.parentNode.style.display = "none";
                    elm.parentNode.parentNode.getElementsByClassName("js-conditiontype")[0].getElementsByClassName("condition-icon")[0].className = this.getElementsByClassName("condition-icon")[0].className;
                    elm.parentNode.parentNode.getElementsByClassName("js-conditiontype")[0].getElementsByClassName("condition-icon")[0].innerHTML = this.getElementsByClassName("condition-icon")[0].innerHTML;
                };
            }
        }

        function clearGroupSelections() {
            var groupselector = document.getElementsByClassName("js-pcm-query-filter-group");
            for (var i = 0; i < groupselector.length; i++) {
                groupselector[i].classList.remove("pcm-query-filter-group-focus");
                groupselector[i].classList.remove("group-selected");
            }
        }

        var dummycounter = 1;

        document.getElementById("add-and-btn").onclick = function () {
            var selectedGroup = document.getElementsByClassName("group-selected")[0];
            createItem(document.getElementsByClassName("group-selected")[0], "AND");
        }

        document.getElementById("add-or-btn").onclick = function () {
            var selectedGroup = document.getElementsByClassName("group-selected")[0];
            createItem(document.getElementsByClassName("group-selected")[0], "OR");
        }

        document.getElementById("add-group-btn").onclick = function () {
            var seperator = document.createElement('div');
            seperator.classList.add("pcm-query-condition-seperator");
            seperator.classList.add("condition-seperator-and");
            seperator.innerHTML = "AND";

            document.getElementsByClassName("pcm-query-filters")[0].appendChild(seperator);

            var groupbox = document.createElement('div');
            groupbox.classList.add("pcm-query-filter-group");
            groupbox.classList.add("js-pcm-query-filter-group");

            createItem(groupbox, "");

            document.getElementsByClassName("pcm-query-filters")[0].appendChild(groupbox);

            init();
        }

        function createItem(target, nextConditionType) {
            var selectedGroup = target;

            var item = document.createElement('div');
            item.classList.add("pcm-query-filter-item");

            var check = document.createElement('div');
            check.classList.add("pcm-query-filter-check");

            var checkinput = document.createElement('input');
            checkinput.type = "checkbox";
            checkinput.id = "check" + dummycounter;
            checkinput.classList.add("checkbox");

            var checklabel = document.createElement('label');
            checklabel.htmlFor = "check" + dummycounter;

            dummycounter++

            check.appendChild(checkinput);
            check.appendChild(checklabel);

            var next = document.createElement('div');
            next.classList.add("pcm-query-filter-next");

            var seperator = document.createElement('div');
            seperator.classList.add("pcm-query-condition-seperator");
            if (nextConditionType == "AND") {
                seperator.classList.add("condition-seperator-and");
                seperator.innerHTML = "AND";
            }
            if (nextConditionType == "OR") {
                seperator.classList.add("condition-seperator-or");
                seperator.innerHTML = "OR";
            }

            next.appendChild(seperator);

            var field = document.createElement('div');
            field.classList.add("pcm-query-filter-fieldselector");

            var fieldselect = document.createElement('select');
            fieldselect.classList.add("std");

            field.appendChild(fieldselect);

            var condition = document.createElement('div');
            condition.classList.add("conditiontype");
            condition.classList.add("js-conditiontype");

            var conditionicon = document.createElement('div');
            conditionicon.classList.add("condition-icon");
            conditionicon.classList.add("equal");
            conditionicon.innerHTML = "=";

            condition.appendChild(conditionicon);
            
            var conditionselector = document.createElement('div');
            conditionselector.classList.add("conditionselector");
            conditionselector.classList.add("js-conditionselector");

            var conditionselectoroption = document.createElement('div');
            conditionselectoroption.classList.add("conditionselector-option");
            conditionselectoroption.innerHTML = " Equal";

            var conditionselectoricon = document.createElement('div');
            conditionselectoricon.classList.add("condition-icon");
            conditionselectoricon.classList.add("equal");
            conditionselectoricon.innerHTML = "=";

            conditionselectoroption.insertBefore(conditionselectoricon, conditionselectoroption.firstChild);
            conditionselector.appendChild(conditionselectoroption);

            conditionselectoroption = document.createElement('div');
            conditionselectoroption.classList.add("conditionselector-option");
            conditionselectoroption.innerHTML = " Now equal to";
            conditionselectoricon = document.createElement('div');
            conditionselectoricon.classList.add("condition-icon");
            conditionselectoricon.classList.add("not");
            conditionselectoricon.innerHTML = "≠";
            conditionselectoroption.insertBefore(conditionselectoricon, conditionselectoroption.firstChild);
            conditionselector.appendChild(conditionselectoroption);

            conditionselectoroption = document.createElement('div');
            conditionselectoroption.classList.add("conditionselector-option");
            conditionselectoroption.innerHTML = " Contains";
            conditionselectoricon = document.createElement('div');
            conditionselectoricon.classList.add("condition-icon");
            conditionselectoricon.classList.add("contains");
            conditionselectoricon.innerHTML = "≈";
            conditionselectoroption.insertBefore(conditionselectoricon, conditionselectoroption.firstChild);
            conditionselector.appendChild(conditionselectoroption);

            conditionselectoroption = document.createElement('div');
            conditionselectoroption.classList.add("conditionselector-option");
            conditionselectoroption.innerHTML = " Less than";
            conditionselectoricon = document.createElement('div');
            conditionselectoricon.classList.add("condition-icon");
            conditionselectoricon.classList.add("less");
            conditionselectoricon.innerHTML = "<";
            conditionselectoroption.insertBefore(conditionselectoricon, conditionselectoroption.firstChild);
            conditionselector.appendChild(conditionselectoroption);

            conditionselectoroption = document.createElement('div');
            conditionselectoroption.classList.add("conditionselector-option");
            conditionselectoroption.innerHTML = " Less than or equal to";
            conditionselectoricon = document.createElement('div');
            conditionselectoricon.classList.add("condition-icon");
            conditionselectoricon.classList.add("lessequal");
            conditionselectoricon.innerHTML = "<=";
            conditionselectoroption.insertBefore(conditionselectoricon, conditionselectoroption.firstChild);
            conditionselector.appendChild(conditionselectoroption);

            conditionselectoroption = document.createElement('div');
            conditionselectoroption.classList.add("conditionselector-option");
            conditionselectoroption.innerHTML = " Greater";
            conditionselectoricon = document.createElement('div');
            conditionselectoricon.classList.add("condition-icon");
            conditionselectoricon.classList.add("greater");
            conditionselectoricon.innerHTML = ">";
            conditionselectoroption.insertBefore(conditionselectoricon, conditionselectoroption.firstChild);
            conditionselector.appendChild(conditionselectoroption);

            conditionselectoroption = document.createElement('div');
            conditionselectoroption.classList.add("conditionselector-option");
            conditionselectoroption.innerHTML = " Greater than or equal to";
            conditionselectoricon = document.createElement('div');
            conditionselectoricon.classList.add("condition-icon");
            conditionselectoricon.classList.add("greaterequal");
            conditionselectoricon.innerHTML = ">=";
            conditionselectoroption.insertBefore(conditionselectoricon, conditionselectoroption.firstChild);
            conditionselector.appendChild(conditionselectoroption);

            var value = document.createElement('div');
            value.classList.add("pcm-query-filter-valueselector");

            var valueselect = document.createElement('select');
            valueselect.classList.add("std");

            value.appendChild(valueselect);

            var removebtn = document.createElement('div');
            removebtn.classList.add("pcm-query-filter-remove");

            var removeicon = document.createElement('i');
            removeicon.classList.add("fa");
            removeicon.classList.add("fa-remove");
            removeicon.classList.add("color-danger");

            removebtn.appendChild(removeicon);

            item.appendChild(check);
            item.appendChild(next);
            item.appendChild(field);
            item.appendChild(condition);
            item.appendChild(conditionselector);
            item.appendChild(value);
            item.appendChild(removebtn);

            selectedGroup.appendChild(item);

            init();
        }
    </script>
</body>
</html>
