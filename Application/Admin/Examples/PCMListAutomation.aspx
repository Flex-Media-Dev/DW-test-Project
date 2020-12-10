<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="PCMListAutomation.aspx.vb" Inherits="Dynamicweb.Admin.PCMListAutomation" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head>
    <title>PCM Product list languages</title>
    <dw:ControlResources runat="server">
    </dw:ControlResources>

    <style>
        .row {
            position: relative;
            display: flex;
            flex-flow: row wrap;
            justify-content: space-around;
        }

        .row-spacing {       
            left: -8px;
            width: calc(100% + 16px);
        }

        .section-spacing {
            margin: 0 8px;
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

        .select-languages {
            width: 145px;
            height: 29px !important;
        }

        .pcm-bulk-edit-focus {
            background-color: #E91E63 !important;
            color: #fff;
        }

        .pcm-bulk-edit-counter {
            background-color: #bdbdbd;
            padding: 0 5px;
            border-radius: 100px;
            font-size: 10px;
            margin: 0;
            position: relative;
            top: -1px;
        }




        .pcm-list-header {
            width: 100%;
            height: 26px;
            background-color: #f7f7f7;
            display: inline-block;
            vertical-align: bottom;
            padding-top: 2px;
            border: 1px solid #bdbdbd;
            border-bottom: 0;
            box-sizing: border-box;
        }

        .pcm-list-action-header-flag {
            margin: 5px;
            font-size: 22px;
        }

        .pcm-list-action-header-warning {
            display: inline-block;
            float: right;
            font-size: 22px;
            margin-top: 2px;
            margin-right: 5px;
            color: #FF9800;
        }

        .pcm-list-header .form-group {
            width: 170px;
        }

        .pcm-list-header .control-label {
            display: none;
        }

        .pcm-list-header label {
            right: -2px;
        }

        .pcm-list-header-info {
            float:right;
            color: #bdbdbd;
            margin-top: 3px;
            margin-right: 8px;
        }

        .pcm-bulklist {
            background-color: #bdbdbd;
            border: 1px solid #bdbdbd;
            box-sizing: border-box;
        }

        .pcm-list-action-header {
            height: 34px;
            background-color: #e0e0e0;
            border: 1px solid #bdbdbd;
            box-sizing: border-box;
        }

        .pcm-list-action-header-title {
            display: inline-block;
            font-size: 16px;
            vertical-align: top;
            margin-top: 5px;
            font-weight: bold;
        }

        .pcm-bulklist-item {
            width: 100%;
            display: block;
            min-height: 1px;
        }

        .pcm-bulk-edit-fieldselector, .pcm-bulk-edit-valueselector {
            height: 32px;
            background-color: #fafafa;
            display: inline-block;
            width: calc(50% - 25px);
            padding: 5px;
            float:left;
        }

        .pcm-bulk-edit-valueselector {
            width: calc(50% - 50px);
        }

        .pcm-bulk-edit-fieldselector .std, .pcm-bulk-edit-valueselector .std {
            width: 100% !important;
        }

        .pcm-bulk-edit-conditionselector {
            height: 32px;
            background-color: #fafafa;
            display: inline-block;
            width: 20px;
            padding: 5px;
            float:left;
            
        }

        .equal-icon {
            border-radius: 200px;
            background-color: #03A9F4;
            color: #fff;
            font-weight: bold;
            text-align: center;
            font-size: 15px;
            margin-top: 5px;
        }

        .pcm-bulk-edit-remove {
            height: 32px;
            background-color: #fafafa;
            display: inline-block;
            width: 15px;
            padding: 5px;
            float:left;
        }

        .pcm-bulk-edit-remove i {
            margin-top: 8px;
            cursor: pointer;
        }

        .pcm-bulklist-footer .btn {
            margin: 5px;
            width: calc(100% - 10px);
        }

        .pcm-bulk-overview-header {
            font-size: 14px;
            color: #616161;
            text-transform: uppercase;
            font-weight: bold;
            margin: 5px;
            margin-top: 10px;
        }

        .pcm-bulk-overview-list {
            padding: 5px;
            background-color: #e0e0e0;
            border: 1px solid #bdbdbd;
            max-height: 120px;
            margin: 5px;
            overflow: auto;
        }

        .pcm-bulk-overview-item-title {
            display: inline-block;
            margin-right: 5px;
        }

        .pcm-bulk-overview-item-id {
            display: inline-block;
            color: #bdbdbd;
        }

        .pcm-bulk-edit-apply {
            margin: 5px;
        }

        .pcm-bulk-edit-apply .btn {
            width: 100%;
            background-color: #4CAF50;
            color: #fff;
        }
    </style>
</head>
<body class="screen-container">
    <div class="row area-pink">
       
    </div>

    <dw:Dialog ID="BulkEditDialog" Size="Medium" HidePadding="True" runat="server" Title="Bulk edit" TranslateTitle="False">
        <div class="pcm-bulklist">
            <div class="pcm-bulklist-item">
                <div class="pcm-bulk-edit-fieldselector">
                    <select class="std">
                    <option selected>Price</option>
                    <option>Points</option>
                    <option>Stock</option>
                    </select>
                </div>
                <div class="pcm-bulk-edit-conditionselector">
                    <div class="equal-icon">=</div>
                </div>
                <div class="pcm-bulk-edit-valueselector">
                    <input type="text" class="std" value="2"/>
                </div>
                <div class="pcm-bulk-edit-remove">
                    <i class="fa fa-times color-danger"></i>
                </div>
            </div>

            <div class="pcm-bulklist-item">
                <div class="pcm-bulk-edit-fieldselector">
                    <select class="std">
                    <option>Price</option>
                    <option selected>Points</option>
                    <option>Stock</option>
                    </select>
                </div>
                <div class="pcm-bulk-edit-conditionselector">
                    <div class="equal-icon">=</div>
                </div>
                <div class="pcm-bulk-edit-valueselector">
                    <input type="text" class="std" value="23"/>
                </div>
                <div class="pcm-bulk-edit-remove">
                    <i class="fa fa-times color-danger"></i>
                </div>
            </div>

            <div class="pcm-bulklist-footer">
                <button class="btn btn-flat">Add new field</button>
            </div>
        </div>

        <div class="pcm-bulk-overview">
            <div class="row row-spacing">
                    <div class="section-6 section-spacing">
                    <div class="pcm-bulk-overview-header">
                        Confirm selected items in English
                    </div>
                    <div class="pcm-bulk-overview-list">
                        <div class="pcm-bulk-overview-item">
                            <input type="checkbox" id="check1" class="checkbox" checked />
                            <label for="check1"></label>
                            <div class="pcm-bulk-overview-item-title">Mongroose bike</div>
                            <div class="pcm-bulk-overview-item-id">PROD121</div>
                        </div>
                        <div class="pcm-bulk-overview-item">
                            <input type="checkbox" id="check2" class="checkbox" checked />
                            <label for="check2"></label>
                            <div class="pcm-bulk-overview-item-title">Fine glowes</div>
                            <div class="pcm-bulk-overview-item-id">PROD151</div>
                        </div>
                        <div class="pcm-bulk-overview-item">
                            <input type="checkbox" id="check3" class="checkbox" checked />
                            <label for="check3"></label>
                            <div class="pcm-bulk-overview-item-title">Red helmet</div>
                            <div class="pcm-bulk-overview-item-id">PROD122</div>
                        </div>
                    </div>
                    </div>

                    <div class="section-6 section-spacing">
                    <div class="pcm-bulk-overview-header">
                        Confirm selected items in Dansk
                    </div>
                    <div class="pcm-bulk-overview-list">
                        <div class="pcm-bulk-overview-item">
                            <input type="checkbox" id="check4" class="checkbox" checked />
                            <label for="check4"></label>
                            <div class="pcm-bulk-overview-item-title">Mongroose bike</div>
                            <div class="pcm-bulk-overview-item-id">PROD121</div>
                        </div>
                        <div class="pcm-bulk-overview-item">
                            <input type="checkbox" id="check5" class="checkbox" />
                            <label for="check5"></label>
                            <div class="pcm-bulk-overview-item-title">Fine glowes</div>
                            <div class="pcm-bulk-overview-item-id">PROD151</div>
                        </div>
                        <div class="pcm-bulk-overview-item">
                            <input type="checkbox" id="check6" class="checkbox" />
                            <label for="check6"></label>
                            <div class="pcm-bulk-overview-item-title">Red helmet</div>
                            <div class="pcm-bulk-overview-item-id">PROD122</div>
                        </div>
                    </div>
                    </div>
            </div>
        </div>

        <div class="pcm-bulk-edit-apply">
            <button type="button" class="btn btn-flat">Apply changes to selected items</button>
        </div> 
    </dw:Dialog>

    <script>
        document.addEventListener("DOMContentLoaded", function (event) {
            dialog.show('BulkEditDialog')
        });
    </script>
</body>
</html>
