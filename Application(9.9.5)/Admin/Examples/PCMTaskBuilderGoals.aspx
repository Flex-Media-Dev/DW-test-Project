<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="PCMTaskBuilderGoals.aspx.vb" Inherits="Dynamicweb.Admin.PCMTaskBuilderGoals" %>

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


        .form-control {
            border: 1px solid #bdbdbd;
	        padding: 4px 6px;
	        resize: none;
	        background-color: #fff;
	        font-size: 14px;
	        line-height: 22px;
            outline: none;
            box-sizing: border-box;
            width: 100%;
        }

        .form-control:focus {
            box-shadow: 0 0 4px 0 rgba(0,0,0,.34);
            transition: all 200ms;
        }

        .seperator {
            width: 100%;
            height: 20px;
            display: block;
            float: left;
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

        .pcm-query-builder {
            width: 100%;
            display: block;
            min-height: 1px;
            text-align: left;
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

        .pcm-query-builder-filters, .pcm-work-goals {
            display: block;
            float: left;
            width: 100%;
            background-color: #e0e0e0;
        }

        .pcm-query-builder-filter-top-level-selector {
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

        .pcm-query-builder-filter-top-level-selector-focus {
            background-color: #03A9F4;
;
        }

        .pcm-query-builder-filter-group {
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

        .pcm-query-builder-filter-group-focus {
            border: 1px solid #03A9F4;
            border-left: 8px solid #03A9F4;
        }

        .pcm-query-builder-filter-item, .pcm-work-goal-item {
            display: inline-block;
            float: left;
            width: 100%;
        }

        .pcm-query-builder-filter-check {
            height: 32px;
            display: inline-block;
            width: 15px;
            padding: 5px;
            float:left;
        }

        .pcm-query-builder-filter-check label {
            margin-top: 4px;
        }

        .pcm-query-builder-filter-fieldselector, .pcm-query-builder-filter-valueselector {
            height: 32px;
            display: inline-block;
            width: calc(50% - 50px);
            padding: 5px;
            float:left;
        }

        .pcm-query-builder-filter-fieldselector .std, .pcm-query-builder-filter-valueselector .std {
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
            margin-top: -52px;
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

        .condition-icon.greater {
            background-color: #9C27B0;
        }

        .pcm-query-builder-filter-remove {
            height: 32px;
            display: inline-block;
            width: 15px;
            padding: 5px;
            float:left;
        }

        .pcm-query-builder-filter-remove i {
            margin-top: 8px;
            cursor: pointer;
        }

        .pcm-query-builder-condition-seperator {
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

        .pcm-query-builder-actions, .pcm-work-goal-actions {
            display: block;
            float: left;
            text-align: left;
            background-color: #9E9E9E;
            padding: 5px;
            width: calc(100% - 10px);
        }

        .pcm-query-builder-actions-btn-mark-and {
            background-color: #E91E63;
            color: #fff;
            padding: 0 4px;
            font-weight: bold;
            display: inline-block;
        }

        .pcm-query-builder-actions-btn-mark-or {
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

        .pcm-work-goal-item .pcm-query-builder-filter-fieldselector, .pcm-work-goal-item .pcm-bulk-edit-conditiontype, .pcm-work-goal-item .pcm-query-builder-filter-valueselector, .pcm-work-goal-item .pcm-query-builder-filter-remove {
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
                            <button class="btn pull-right" title="Help"><i class="fa fa-question-circle"></i></button>
                        </div>
                    </div>
                </div>

                <div class="card-body">
                    <div class="pcm-task-builder-progressbar">
                         <div class="pcm-task-builder-progressbar-step">
                             <div class="pcm-task-builder-progressbar-step-number">
                                1
                             </div>
                             <div class="pcm-task-builder-progressbar-step-label">
                                Query
                             </div>
                         </div>

                         <div class="pcm-task-builder-progressbar-step pcm-task-builder-progressbar-step-active">
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
                        <div class="pcm-work-goal-builder">
                            <dwc:InputText runat="server" Placeholder="Task process title" Value="My work goals for integrated products"></dwc:InputText>
                            <div class="seperator"></div>
                            <div class="pcm-tool-info">
                                <h2>Goals</h2>
                                What do you want to accomplish?
                            </div>
                            <div class="pcm-work-goals">
                                <div class="pcm-work-goal-item">
                                    <div class="pcm-work-goal-item-mark">
                                        <div class="pcm-work-goal-item-mark-text">GOAL</div>
                                    </div>
                                    <div class="pcm-query-builder-filter-fieldselector">
                                        <select class="std">
                                            <option selected>Image</option>
                                            <option>Title</option>
                                            <option>Price</option>
                                        </select>
                                    </div>
                                    <div class="pcm-bulk-edit-conditiontype js-conditiontype">
                                        <div class="condition-icon equal">=</div>
                                    </div>
                                    <div class="pcm-query-builder-filter-valueselector">
                                        <select class="std">
                                            <option selected>Not set</option>
                                            <option>This</option>
                                            <option>That</option>
                                        </select>
                                    </div>
                                    <div class="pcm-query-builder-filter-remove">
                                        <i class="fa fa-times color-danger"></i>
                                    </div>
                                </div>

                                <div class="pcm-work-goal-item">
                                    <div class="pcm-work-goal-item-mark">
                                        <div class="pcm-work-goal-item-mark-text">GOAL</div>
                                    </div>
                                    <div class="pcm-query-builder-filter-fieldselector">
                                        <select class="std">
                                            <option>Image</option>
                                            <option selected>Title</option>
                                            <option>Price</option>
                                        </select>
                                    </div>
                                    <div class="pcm-bulk-edit-conditiontype js-conditiontype">
                                        <div class="condition-icon equal">=</div>
                                    </div>
                                    <div class="pcm-query-builder-filter-valueselector">
                                        <select class="std">
                                            <option selected>Not set</option>
                                            <option>This</option>
                                            <option>That</option>
                                        </select>
                                    </div>
                                    <div class="pcm-query-builder-filter-remove">
                                        <i class="fa fa-times color-danger"></i>
                                    </div>
                                </div>

                                <div class="pcm-work-goal-item">
                                    <div class="pcm-work-goal-item-mark">
                                        <div class="pcm-work-goal-item-mark-text">GOAL</div>
                                    </div>
                                    <div class="pcm-query-builder-filter-fieldselector">
                                        <select class="std">
                                            <option>Image</option>
                                            <option>Title</option>
                                            <option selected>Price</option>
                                        </select>
                                    </div>
                                    <div class="pcm-bulk-edit-conditiontype js-conditiontype">
                                        <div class="condition-icon greater">></div>
                                    </div>
                                    <div class="pcm-query-builder-filter-valueselector">
                                        <select class="std">
                                            <option selected>10</option>
                                            <option>This</option>
                                            <option>That</option>
                                        </select>
                                    </div>
                                    <div class="pcm-query-builder-filter-remove">
                                        <i class="fa fa-times color-danger"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="pcm-work-goal-actions">
                                <button type="button" id="add-goal" class="btn btn-flat"><i class="fa fa-plus color-success"></i> Add goal</button>
                                <button type="button" id="add-goal" class="btn btn-flat"><i class="fa fa-plus color-success"></i> Add predeffined goal</button>
                            </div>
                        </div>
                    </div>

                    <div class="pcm-action-bar">
                        <button class="btn btn-flat pull-left" onclick="changePage('/Admin/Examples/PCMTaskBuilderQuery.aspx')"><i class="fa fa-angle-left"></i> Back</button>
                        <button class="btn btn-flat pcm-success-btn pull-right" onclick="changePage('/Admin/Examples/PCMTaskBuilderView.aspx')">Create goals <i class="fa fa-angle-right"></i></button>
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
            var groupselector = document.getElementsByClassName("js-pcm-query-builder-filter-group");
            for (var i = 0; i < groupselector.length; i++) {
                groupselector[i].onclick = function () {
                    var elm = this;

                    clearGroupSelections();
                    
                    elm.classList.add("pcm-query-builder-filter-group-focus");
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
        });

        document.getElementsByClassName("js-conditionselector")[0].onclick = function () {
            this.style.display = "none";
        }

        document.getElementById("level-selector").onclick = function () {
            clearGroupSelections();
            this.classList.add("pcm-query-builder-filter-top-level-selector-focus");
            this.classList.add("group-selected");
        }

        function clearGroupSelections() {
            var groupselector = document.getElementsByClassName("js-pcm-query-builder-filter-group");
            for (var i = 0; i < groupselector.length; i++) {
                groupselector[i].classList.remove("pcm-query-builder-filter-group-focus");
                groupselector[i].classList.remove("group-selected");
            }

            document.getElementById("level-selector").classList.remove("pcm-query-builder-filter-top-level-selector-focus");
            document.getElementById("level-selector").classList.remove("group-selected");
        }

        var dummycounter = 1;

        document.getElementById("add-and-btn").onclick = function () {
            var selectedGroup = document.getElementsByClassName("group-selected")[0];

            var seperator = document.createElement('div');
            seperator.classList.add("pcm-query-builder-condition-seperator");
            seperator.classList.add("condition-seperator-and");
            seperator.innerHTML = "AND";

            if (selectedGroup.classList.contains('pcm-query-builder-filter-top-level-selector')) {
                selectedGroup.parentNode.appendChild(seperator);
            } else {
                selectedGroup.appendChild(seperator);
            }

            createItem();
        }

        document.getElementById("add-or-btn").onclick = function () {
            var selectedGroup = document.getElementsByClassName("group-selected")[0];

            var seperator = document.createElement('div');
            seperator.classList.add("pcm-query-builder-condition-seperator");
            seperator.classList.add("condition-seperator-or");
            seperator.innerHTML = "OR";

            if (selectedGroup.classList.contains('pcm-query-builder-filter-top-level-selector')) {
                selectedGroup.parentNode.appendChild(seperator);
            } else {
                selectedGroup.appendChild(seperator);
            }

            createItem();
        }

        function createItem() {
            var selectedGroup = document.getElementsByClassName("group-selected")[0];

            var item = document.createElement('div');
            item.classList.add("pcm-query-builder-filter-item");

            var check = document.createElement('div');
            check.classList.add("pcm-query-builder-filter-check");

            var checkinput = document.createElement('input');
            checkinput.type = "checkbox";
            checkinput.id = "check" + dummycounter;
            checkinput.classList.add("checkbox");

            var checklabel = document.createElement('label');
            checklabel.htmlFor = "check" + dummycounter;

            dummycounter++

            check.appendChild(checkinput);
            check.appendChild(checklabel);

            var field = document.createElement('div');
            field.classList.add("pcm-query-builder-filter-fieldselector");

            var fieldselect = document.createElement('select');
            fieldselect.classList.add("std");

            field.appendChild(fieldselect);

            var condition = document.createElement('div');
            condition.classList.add("pcm-bulk-edit-conditiontype");

            var conditionicon = document.createElement('div');
            conditionicon.classList.add("condition-icon");
            conditionicon.classList.add("equal");
            conditionicon.innerHTML = "=";

            condition.appendChild(conditionicon);

            var value = document.createElement('div');
            value.classList.add("pcm-query-builder-filter-valueselector");

            var valueselect = document.createElement('select');
            valueselect.classList.add("std");

            value.appendChild(valueselect);

            var removebtn = document.createElement('div');
            removebtn.classList.add("pcm-query-builder-filter-remove");

            var removeicon = document.createElement('i');
            removeicon.classList.add("fa");
            removeicon.classList.add("fa-remove");
            removeicon.classList.add("color-danger");

            removebtn.appendChild(removeicon);

            item.appendChild(check);
            item.appendChild(field);
            item.appendChild(condition);
            item.appendChild(value);
            item.appendChild(removebtn);

            if (selectedGroup.classList.contains('pcm-query-builder-filter-top-level-selector')) {
                selectedGroup.parentNode.appendChild(item);
            } else {
                selectedGroup.appendChild(item);
            }
        }
    </script>
</body>
</html>
