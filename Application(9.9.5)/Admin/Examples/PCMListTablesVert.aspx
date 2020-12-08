<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="PCMListTablesVert.aspx.vb" Inherits="Dynamicweb.Admin.PCMListTablesVert" %>

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
            float: right;
            color: #bdbdbd;
            margin-top: 3px;
            margin-right: 8px;
        }

        .pcm-list-header .control-label {
            display: none;
        }

        .pcm-list-header label {
            right: -10px;
        }

        .pcm-list {
            max-height: calc(100vh - 185px);
            overflow: auto;
            position: relative;
        }

        .pcm-list-item {
            margin-top: 20px;
            box-shadow: 0 2px 2px rgba(0,0,0,.15);
            width: calc(100% - 28px);
            height: 100%;
            min-height: 1px;
            background-color: #fafafa;
            border-bottom: 1px solid #bdbdbd;
            border-left: 8px solid #9E9E9E;
            left: 10px;
            position: relative;
        }

            .pcm-list-item.variant {
                margin: 0;
                background-color: #e0e0e0;
            }

        .pcm-list-item-header {
            border-bottom: 1px solid #bdbdbd;
            width: calc(100% - 8px);
            display: inline-block;
            padding: 5px;
        }

        .pcm-list-item-header-title {
            font-size: 16px;
            text-transform: uppercase;
            font-weight: bold;
            padding-left: 5px;
        }

        .pcm-list-item.variant .pcm-list-item-header-title {
            color: #9E9E9E;
        }

        .pcm-list-item-header-info {
            color: #9E9E9E;
            padding-right: 5px;
        }

        .pcm-list-item-body {
            display: flex;
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
            box-sizing: border-box;
            text-align: center;
            transition: all ease-out 0.3s;
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

        .pcm-thumb {
            border: 1px solid #eee;
            vertical-align: top;
            margin: 5px;
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
            padding: 5px 0;
            width: calc(100% - 140px);
        }

        .pcm-list-fields-table {
            width: 100%;
        }

        .pcm-list-table-row {
            height: 36px;
        }

        .pcm-list-table-row-label {
            text-transform: uppercase;
            color: #9E9E9E;
            font-size: 12px;
        }

        .pcm-list-fields-table-header .flag-icon {
            font-size: 18px;
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

        .pcm-list-header-bulkedit {
            float: right;
            background-color: #eee;
            border: 1px solid #E91E63;
            transition: all ease-in 0.2s;
        }

        .pcm-list-header-bulkedit-update {
            background-color: #E91E63;
        }

            .pcm-list-header-bulkedit-update .pcm-list-header-bulkedit-icon, .pcm-list-header-bulkedit-update .pcm-bulk-edit-counter, .pcm-list-header-bulkedit-update .pcm-list-header-bulkedit-cart-btn {
                color: #fff;
            }

        .pcm-list-header-bulkedit-mark {
            color: #fff;
            background-color: #E91E63;
            display: inline-block;
            float: left;
            width: 16px;
            height: 50px;
        }

        .pcm-list-header-bulkedit-mark-text {
            transform: rotate(270deg);
            margin-top: 21px;
            font-size: 12px;
        }

        .pcm-list-header-bulkedit-icon {
            display: inline-block;
            margin: 0 5px;
            vertical-align: top;
            font-size: 35px;
            color: #616161;
        }

            .pcm-list-header-bulkedit-icon .fa-check {
                position: absolute;
                top: 24px;
                margin-left: 22px;
                font-size: 18px;
            }

        .pcm-list-header-bulkedit-cart {
            display: inline-block;
        }

        .pcm-bulk-edit-counter {
            background-color: rgba(0,0,0,0.1);
            color: #E91E63;
            padding: 0 5px;
            border-radius: 100px;
            font-size: 12px;
            font-weight: bold;
            text-align: right;
            margin: 5px 5px 0;
        }

        .pcm-list-header-bulkedit-cart-btn {
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

    <style>
        /* Add this attribute to the element that needs a tooltip */
        [data-tooltip] {
            position: relative;
            z-index: 2;
            cursor: pointer;
        }

            /* Hide the tooltip content by default */
            [data-tooltip]:before,
            [data-tooltip]:after {
                visibility: hidden;
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=0)";
                filter: progid: DXImageTransform.Microsoft.Alpha(Opacity=0);
                opacity: 0;
                pointer-events: none;
            }

            /* Position tooltip above the element */
            [data-tooltip]:before {
                position: absolute;
                bottom: 100%;
                left: 50%;
                transform: translate(-50%, 0);
                margin-bottom: 5px;
                padding: 3px;
                width: 160px;
                border-radius: 2px;
                background-color: #333;
                color: #fff;
                content: attr(data-tooltip);
                text-align: center;
                font-size: 12px;
            }

            /* Triangle hack to make tooltip look like a speech bubble */
            [data-tooltip]:after {
                position: absolute;
                bottom: 100%;
                left: 50%;
                top: -5px;
                margin-left: -5px;
                width: 0;
                border-top: 5px solid #333;
                border-right: 5px solid transparent;
                border-left: 5px solid transparent;
                content: " ";
            }

            /* Show tooltip content on hover */
            [data-tooltip]:hover:before,
            [data-tooltip]:hover:after {
                visibility: visible;
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=100)";
                filter: progid: DXImageTransform.Microsoft.Alpha(Opacity=100);
                opacity: 1;
            }
    </style>
</head>
<body class="screen-container">
    <div class="row area-black">
        <div class="section-12">
            <div class="card">
                <div class="card-header">
                    <div class="row">
                        <div class="section-6">
                            <h2>PCM Productlist</h2>
                            <small class="card-header-subtitle">Bikez</small>
                        </div>
                        <div class="section-6 header-actions">
                            <div id="pcm-bulk-edit" class="pcm-list-header-bulkedit">
                                <div class="pcm-list-header-bulkedit-mark">
                                    <div class="pcm-list-header-bulkedit-mark-text">EDIT</div>
                                </div>
                                <div class="pcm-list-header-bulkedit-icon">
                                    <i class="fa fa-copy"></i>
                                    <i class="fa fa-check"></i>
                                </div>
                                <div class="pcm-list-header-bulkedit-cart">
                                    <div id="pcm-bulk-edit-counter" class="pcm-bulk-edit-counter">0</div>
                                    <button id="pcm-list-header-bulkedit-cart-btn" class="btn pcm-list-header-bulkedit-cart-btn">Edit selected</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-body">
                    <div class="pcm-list-header">
                        <dwc:CheckBox ID="CheckAll" Name="CheckAll" Label="Check all" DoTranslation="False" runat="server" />
                        <button class="btn pull-right"><i class="fa fa-list"></i></button>
                        <button class="btn pull-right"><i class="fa fa-table"></i></button>
                        <small class="pcm-list-header-info">Showing 105 of 12234 products</small>
                    </div>
                </div>
            </div>

            <div class="pcm-list">
                <div class="pcm-list-item">
                    <div class="pcm-list-item-header">
                        <div class="pcm-list-item-header-title pull-left">My new shiny</div>
                        <div class="pcm-list-item-header-info pull-right">#10121</div>
                    </div>
                    <div class="pcm-list-item-body">
                        <div class="pcm-list-check">
                            <input type="checkbox" id="CheckBox6" name="CheckBox6" class="checkbox" />
                            <label for="CheckBox6" class="js-checkbox-label"></label>
                        </div>
                        <div class="pcm-list-state" id="state1"></div>
                        <div class="pcm-list-left">
                            <div class="pcm-thumb">
                                <img class="img-responsive" src="/Admin/Public/GetImage.ashx?width=100&amp;height=66&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg">
                            </div>
                        </div>
                        <div class="pcm-list-fields">
                            <table class="pcm-list-fields-table">
                                <thead>
                                    <tr class="pcm-list-fields-table-header">
                                        <td></td>
                                        <td>
                                            <i class="flag-icon flag-icon-gb"></i>
                                        </td>
                                        <td>
                                            <i class="flag-icon flag-icon-dk"></i>
                                        </td>
                                        <td>
                                            <i class="flag-icon flag-icon-de"></i>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Name
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText1" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="title1" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText9" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Category
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText10" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText11" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText12" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Stock
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Weight
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Campaign
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Price
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="pcm-list-item variant">
                    <div class="pcm-list-item-header">
                        <div class="pcm-list-item-header-title pull-left">Variant: Blue, Aluminium</div>
                        <div class="pcm-list-item-header-info pull-right">#VO10121</div>
                    </div>
                    <div class="pcm-list-item-body">
                        <div class="pcm-list-check">
                            <input type="checkbox" id="CheckBox6" name="CheckBox6" class="checkbox" />
                            <label for="CheckBox6" class="js-checkbox-label"></label>
                        </div>
                        <div class="pcm-list-state" id="state1"></div>
                        <div class="pcm-list-left">
                            <div class="pcm-thumb">
                                <img class="img-responsive" src="/Admin/Public/GetImage.ashx?width=100&amp;height=66&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg">
                            </div>
                        </div>
                        <div class="pcm-list-fields">
                            <table class="pcm-list-fields-table">
                                <thead>
                                    <tr class="pcm-list-fields-table-header">
                                        <td></td>
                                        <td>
                                            <i class="flag-icon flag-icon-gb"></i>
                                        </td>
                                        <td>
                                            <i class="flag-icon flag-icon-dk"></i>
                                        </td>
                                        <td>
                                            <i class="flag-icon flag-icon-de"></i>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Name
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText18" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText19" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText20" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Category
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText21" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText22" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText23" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Stock
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Weight
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Campaign
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Price
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="pcm-list-item variant">
                    <div class="pcm-list-item-header">
                        <div class="pcm-list-item-header-title pull-left">Variant: Red, Aluminium</div>
                        <div class="pcm-list-item-header-info pull-right">#10121</div>
                    </div>
                    <div class="pcm-list-item-body">
                        <div class="pcm-list-check">
                            <input type="checkbox" id="CheckBox6" name="CheckBox6" class="checkbox" />
                            <label for="CheckBox6" class="js-checkbox-label"></label>
                        </div>
                        <div class="pcm-list-state" id="state1"></div>
                        <div class="pcm-list-left">
                            <div class="pcm-thumb">
                                <img class="img-responsive" src="/Admin/Public/GetImage.ashx?width=100&amp;height=66&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg">
                            </div>
                        </div>
                        <div class="pcm-list-fields">
                            <table class="pcm-list-fields-table">
                                <thead>
                                    <tr class="pcm-list-fields-table-header">
                                        <td></td>
                                        <td>
                                            <i class="flag-icon flag-icon-gb"></i>
                                        </td>
                                        <td>
                                            <i class="flag-icon flag-icon-dk"></i>
                                        </td>
                                        <td>
                                            <i class="flag-icon flag-icon-de"></i>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Name
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText24" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText25" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText26" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Category
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText27" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText28" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText29" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Stock
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Weight
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Campaign
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Price
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="pcm-list-item">
                    <div class="pcm-list-item-header">
                        <div class="pcm-list-item-header-title pull-left">My new shiny</div>
                        <div class="pcm-list-item-header-info pull-right">#10121</div>
                    </div>
                    <div class="pcm-list-item-body">
                        <div class="pcm-list-check">
                            <input type="checkbox" id="CheckBox7" name="CheckBox7" class="checkbox" />
                            <label for="CheckBox7" class="js-checkbox-label"></label>
                        </div>
                        <div class="pcm-list-state" id="state1"></div>
                        <div class="pcm-list-left">
                            <div class="pcm-thumb">
                                <img class="img-responsive" src="/Admin/Public/GetImage.ashx?width=100&amp;height=66&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg">
                            </div>
                        </div>
                        <div class="pcm-list-fields">
                            <table class="pcm-list-fields-table">
                                <thead>
                                    <tr class="pcm-list-fields-table-header">
                                        <td></td>
                                        <td>
                                            <i class="flag-icon flag-icon-gb"></i>
                                        </td>
                                        <td>
                                            <i class="flag-icon flag-icon-dk"></i>
                                        </td>
                                        <td>
                                            <i class="flag-icon flag-icon-de"></i>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Name
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText2" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText3" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText4" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Category
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText5" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText6" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText7" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Stock
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Weight
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Campaign
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Price
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="pcm-list-item">
                    <div class="pcm-list-item-header">
                        <div class="pcm-list-item-header-title pull-left">My new shiny</div>
                        <div class="pcm-list-item-header-info pull-right">#10121</div>
                    </div>
                    <div class="pcm-list-item-body">
                        <div class="pcm-list-check">
                            <input type="checkbox" id="CheckBox7" name="CheckBox7" class="checkbox" />
                            <label for="CheckBox7" class="js-checkbox-label"></label>
                        </div>
                        <div class="pcm-list-state" id="state1"></div>
                        <div class="pcm-list-left">
                            <div class="pcm-thumb">
                                <img class="img-responsive" src="/Admin/Public/GetImage.ashx?width=100&amp;height=66&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg">
                            </div>
                        </div>
                        <div class="pcm-list-fields">
                            <table class="pcm-list-fields-table">
                                <thead>
                                    <tr class="pcm-list-fields-table-header">
                                        <td></td>
                                        <td>
                                            <i class="flag-icon flag-icon-gb"></i>
                                        </td>
                                        <td>
                                            <i class="flag-icon flag-icon-dk"></i>
                                        </td>
                                        <td>
                                            <i class="flag-icon flag-icon-de"></i>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Name
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText8" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText13" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText14" Placeholder="Title" Value="My new shiny"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Category
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText15" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText16" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" ID="InputText17" Placeholder="Title" Value="Bikes"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Stock
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="15" Disabled="True"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Weight
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="22" Disabled="True"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Campaign
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="No campaign" Value="Easter"></dwc:InputText>
                                        </td>
                                    </tr>
                                    <tr class="pcm-list-table-row">
                                        <td class="pcm-list-table-row-label">Price
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
                                        </td>
                                        <td>
                                            <dwc:InputText runat="server" Placeholder="0" Value="10.99"></dwc:InputText>
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

    <dwc:ActionBar runat="server" Visible="true">
        <dw:ToolbarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Image="NoImage" OnClientClick="Save();" ID="cmdSave" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
        <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
        <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
    </dwc:ActionBar>

    <script>
        document.addEventListener("DOMContentLoaded", function (event) {
            var checkboxes = document.getElementsByClassName("js-checkbox-label");
            var selectedCount = 0;

            for (var i = 0; i < checkboxes.length; i++) {
                checkboxes[i].onclick = function (e) {
                    var checkstate = e.currentTarget.parentNode.getElementsByClassName("checkbox")[0].checked;

                    /* The reason this is opposite, is that there is a mysterious delay on the checkbox */
                    if (checkstate == false) {
                        selectedCount++;
                    } else {
                        selectedCount--;
                    }

                    document.getElementById("pcm-bulk-edit-counter").innerHTML = selectedCount;

                    document.getElementById('pcm-bulk-edit').classList.add("pcm-list-header-bulkedit-update");
                    setTimeout(function () {
                        document.getElementById('pcm-bulk-edit').classList.remove("pcm-list-header-bulkedit-update");
                    },
                    1400);

                    if (selectedCount > 0) {
                        document.getElementById("pcm-list-header-bulkedit-cart-btn").disabled = false;
                        document.getElementById("pcm-list-header-bulkedit-cart-btn").style.backgroundColor = "#E91E63";
                        document.getElementById("pcm-list-header-bulkedit-cart-btn").style.color = "#FFF";
                    } else {
                        document.getElementById("pcm-list-header-bulkedit-cart-btn").disabled = true;
                        document.getElementById("pcm-list-header-bulkedit-cart-btn").style.backgroundColor = "rgba(0, 0, 0, 0.1)";
                        document.getElementById("pcm-list-header-bulkedit-cart-btn").style.color = "#333";
                    }
                };
            }
        });
    </script>
</body>
</html>
