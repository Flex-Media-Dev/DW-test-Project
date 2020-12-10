<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="PCMTaskBuilderFilters.aspx.vb" Inherits="Dynamicweb.Admin.PCMTaskBuilderFilters" %>

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

        .pcm-query-builder-filters {
            display: block;
            float: left;
            width: 100%;
            background-color: #e0e0e0;
        }

        .pcm-selection-builder {
            max-width: 600px;
            min-width: 450px;
            padding: 15px;
            display: inline-block;
            position: relative;
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
            width: calc(50% - 36px);
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

                         <div class="pcm-task-builder-progressbar-step pcm-task-builder-progressbar-step-active">
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
                        <div class="pcm-selection-builder">
                            <div class="pcm-tool-info">
                                <h2>Filters</h2>
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
                                            <a href="javascript:void(0)" class="btn btn-default"><i class="fa fa-angle-right" alt="Move single"></i></a>
                                        </div>
                                        <div class="selection-box-btn">
                                            <a href="javascript:void(0)" class="btn btn-default"><i class="fa fa-angle-left" alt="Move single"></i></a>
                                        </div>
                                    </div>

                                    <div class="pcm-selction-box-right">
                                        <div class="control-label">Included filters</div>
                                        <select size="4" multiple="multiple" class="form-control">
                                            <option>Price</option>
                                            <option>Brand</option>
                                            <option>Category</option>
                                            <option>Size</option>
                                        </select>
                                    </div>

                                    <div class="pcm-selection-box-btn-group">
                                        <div class="selection-box-btn">
                                            <a href="javascript:void(0)" class="btn btn-default"><i class="fa fa-angle-up" alt="Move up"></i></a>
                                        </div>
                                        <div class="selection-box-btn">
                                            <a href="javascript:void(0)" class="btn btn-default"><i class="fa fa-angle-down" alt="Move down"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="pcm-action-bar">
                        <button class="btn btn-flat pull-left" onclick="changePage('/Admin/Examples/PCMTaskBuilderView.aspx')">Back <i class="fa fa-angle-left"></i></button>
                        <button class="btn btn-flat pcm-success-btn pull-right" onclick="changePage('/Admin/Examples/PCMVisualRepositories.aspx')">Create filters <i class="fa fa-angle-right"></i></button>
                        <button class="btn btn-flat m-r-15 pull-right" onclick="changePage('/Admin/Examples/PCMVisualRepositories.aspx')">No, thanks! <i class="fa fa-angle-double-right"></i></button>
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
