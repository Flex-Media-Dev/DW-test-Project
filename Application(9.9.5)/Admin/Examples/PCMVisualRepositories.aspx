<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="PCMVisualRepositories.aspx.vb" Inherits="Dynamicweb.Admin.PCMVisualRepositories" %>

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

        .form-group-info {
            display: inline-block !important;
            color: #9e9e9e;
            text-align: center;
            width: 30px;
            height: 25px;
            padding-top: 5px;
            border: 1px solid #bdbdbd;
            background-color: #eeeeee;
            float: right;
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

        .card-body-header {
            text-transform: uppercase;
            border-bottom: 1px solid #bdbdbd;
            width: 100%;
            text-align: center;
            margin: 0;
            margin-top: 10px;
            padding-bottom: 10px;
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




        .pcm-query {
            width: calc(100% - 30px);
            display: block;
            min-height: 1px;
            padding: 15px;
        }

        .pcm-tool-info {
            margin: 5px 0 15px;
            text-align: left;
        }

        .pcm-tool-info h3 {
            color: #616161;
            font-size: 14px;
            text-transform: uppercase;
            font-weight: bold;
        }

        .pcm-query-filters, .pcm-work-goals {
            display: block;
            float: left;
            width: 100%;
            background-color: #e0e0e0;
        }

        .pcm-query-filter-top-level-selector {
            float: left;
            height: 18px;
            background-color: #9E9E9E;
            color: #fff;
            text-align: center;
            padding: 2px;
            margin: 5px;
            width: calc(100% - 15px);
            cursor: pointer;
            transition: all ease-in 0.2s; 
        }

        .pcm-query-filter-top-level-selector-focus {
            background-color: #03A9F4;
;
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

        .pcm-bulk-edit-conditiontype {
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

        .conditiontype {
            height: 32px;
            display: inline-block;
            width: 20px;
            padding: 5px;
            float:left;
            cursor: pointer;
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
            padding: 15px;
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

        .pcm-work-goal-item .pcm-query-filter-fieldselector, .pcm-work-goal-item .pcm-bulk-edit-conditiontype, .pcm-work-goal-item .pcm-query-filter-valueselector, .pcm-work-goal-item .pcm-query-filter-remove {
            margin-top: 9px;
        }

        .pcm-view-builder, .pcm-filter-builder {
            padding: 15px;
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
    </style>
</head>
<body class="screen-container">
    <div class="row area-pink">
        <div class="section-12">
            <div class="card">
                <div class="card-header">
                    <div class="row">
                        <div class="section-6">
                            <h2>Task process overview</h2>
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
                    <div class="row">
                       <h2 class="card-body-header">My work goals for integrated products</h2>
                    </div>

                    <div class="row">
                        <div class="section-6">
                            <div class="pcm-query">
                                <div class="pcm-tool-info">
                                    <h3>Query</h3>
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

                        <div class="section-6">
                            <div class="pcm-work-goal-builder">
                                <div class="pcm-tool-info">
                                    <h3>Goals</h3>
                                    What do you want to accomplish?
                                </div>
                                <div class="pcm-work-goals">
                                    <div class="pcm-work-goal-item">
                                        <div class="pcm-work-goal-item-mark">
                                            <div class="pcm-work-goal-item-mark-text">GOAL</div>
                                        </div>
                                        <div class="pcm-query-filter-fieldselector">
                                            <select class="std">
                                                <option selected>Image</option>
                                                <option>Title</option>
                                                <option>Price</option>
                                            </select>
                                        </div>
                                        <div class="pcm-bulk-edit-conditiontype js-conditiontype">
                                            <div class="condition-icon not">≠</div>
                                        </div>
                                        <div class="pcm-query-filter-valueselector">
                                            <select class="std">
                                                <option selected>Not set</option>
                                                <option>This</option>
                                                <option>That</option>
                                            </select>
                                        </div>
                                        <div class="pcm-query-filter-remove">
                                            <i class="fa fa-times color-danger"></i>
                                        </div>
                                    </div>

                                    <div class="pcm-work-goal-item">
                                        <div class="pcm-work-goal-item-mark">
                                            <div class="pcm-work-goal-item-mark-text">GOAL</div>
                                        </div>
                                        <div class="pcm-query-filter-fieldselector">
                                            <select class="std">
                                                <option>Image</option>
                                                <option selected>Title</option>
                                                <option>Price</option>
                                            </select>
                                        </div>
                                        <div class="pcm-bulk-edit-conditiontype js-conditiontype">
                                            <div class="condition-icon not">≠</div>
                                        </div>
                                        <div class="pcm-query-filter-valueselector">
                                            <select class="std">
                                                <option selected>Not set</option>
                                                <option>This</option>
                                                <option>That</option>
                                            </select>
                                        </div>
                                        <div class="pcm-query-filter-remove">
                                            <i class="fa fa-times color-danger"></i>
                                        </div>
                                    </div>

                                    <div class="pcm-work-goal-item">
                                        <div class="pcm-work-goal-item-mark">
                                            <div class="pcm-work-goal-item-mark-text">GOAL</div>
                                        </div>
                                        <div class="pcm-query-filter-fieldselector">
                                            <select class="std">
                                                <option>Image</option>
                                                <option>Title</option>
                                                <option selected>Price</option>
                                            </select>
                                        </div>
                                        <div class="pcm-bulk-edit-conditiontype js-conditiontype">
                                            <div class="condition-icon greater">></div>
                                        </div>
                                        <div class="pcm-query-filter-valueselector">
                                            <select class="std">
                                                <option selected>10</option>
                                                <option>This</option>
                                                <option>That</option>
                                            </select>
                                        </div>
                                        <div class="pcm-query-filter-remove">
                                            <i class="fa fa-times color-danger"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="pcm-work-goal-actions">
                                    <button type="button" id="add-goal" class="btn btn-flat"><i class="fa fa-plus color-success"></i> Add goal</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="section-6">
                            <div class="pcm-view-builder">
                                <div class="pcm-tool-info">
                                    <h3>View</h3>
                                    Which fields do you want to work with?                                
                                </div>
                                <div class="form-group">
                                    <div class="pcm-selection-box">
                                        <div class="pcm-selction-box-right">
                                            <div class="control-label">Excluded fields</div>
                                            <select size="4" multiple="multiple" class="form-control" ondblclick="javascript:SelectionBox.selectionAddSingle('ItemFieldsListSelector');">
                                                <option>Color</option>
                                                <option>Weight</option>
                                                <option>Volume</option>
                                                <option>Points</option>
                                            </select>
                                        </div>

                                        <div class="pcm-selection-box-btn-group">
                                            <div class="selection-box-btn">
                                                <a href="javascript:void(0)" class="btn btn-default" onclick="javascript:SelectionBox.selectionAddSingle('ItemFieldsListSelector');"><i class="fa fa-angle-right" alt="Move single"></i></a>
                                            </div>
                                            <div class="selection-box-btn">
                                                <a href="javascript:void(0)" class="btn btn-default" onclick="javascript:SelectionBox.selectionRemoveSingle('ItemFieldsListSelector');"><i class="fa fa-angle-left" alt="Move single"></i></a>
                                            </div>
                                        </div>

                                        <div class="pcm-selction-box-right">
                                            <div class="control-label">Included fields</div>
                                            <select size="4" multiple="multiple" class="form-control" ondblclick="javascript:SelectionBox.selectionRemoveSingle('ItemFieldsListSelector');">
                                                <option>Category</option>
                                                <option>Stock</option>
                                                <option>Weight</option>
                                                <option>Campaign</option>
                                                <option disabled class="pcm-selction-box-from-goal">Image</option>
                                                <option disabled class="pcm-selction-box-from-goal">Name</option>
                                                <option disabled class="pcm-selction-box-from-goal">Price</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="section-6">
                            <div class="pcm-filter-builder">
                                <div class="pcm-tool-info">
                                    <h3>Filter</h3>
                                    Do you need to use additional filters?
                                </div>
                                <div class="form-group">
                                    <div class="pcm-selection-box">
                                        <div class="pcm-selction-box-right">
                                            <div class="control-label">Excluded filters</div>
                                            <select size="4" multiple="multiple" class="form-control" ondblclick="javascript:SelectionBox.selectionAddSingle('ItemFieldsListSelector');">
                                                <option>Color</option>
                                                <option>Weight</option>
                                                <option>Stock</option>
                                                <option>Volume</option>
                                                <option>Points</option>
                                                <option>Has variants</option>
                                                <option>No image</option>
                                                <option>Creation date</option>
                                            </select>
                                        </div>

                                        <div class="pcm-selection-box-btn-group">
                                            <div class="selection-box-btn">
                                                <a href="javascript:void(0)" class="btn btn-default" onclick="javascript:SelectionBox.selectionAddSingle('ItemFieldsListSelector');"><i class="fa fa-angle-right" alt="Move single"></i></a>
                                            </div>
                                            <div class="selection-box-btn">
                                                <a href="javascript:void(0)" class="btn btn-default" onclick="javascript:SelectionBox.selectionRemoveSingle('ItemFieldsListSelector');"><i class="fa fa-angle-left" alt="Move single"></i></a>
                                            </div>
                                        </div>

                                        <div class="pcm-selction-box-right">
                                            <div class="control-label">Included filters</div>
                                            <select size="4" multiple="multiple" class="form-control" ondblclick="javascript:SelectionBox.selectionRemoveSingle('ItemFieldsListSelector');">
                                                <option>Price</option>
                                                <option>Brand</option>
                                                <option>Category</option>
                                                <option>Size</option>
                                            </select>
                                        </div>
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

    <dwc:ActionBar runat="server" Visible="true">
        <dw:ToolbarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Image="NoImage" OnClientClick="Save();" ID="cmdSave" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
        <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
        <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
    </dwc:ActionBar>

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
