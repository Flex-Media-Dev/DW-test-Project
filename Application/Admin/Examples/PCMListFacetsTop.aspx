<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="PCMListFacetsTop.aspx.vb" Inherits="Dynamicweb.Admin.PCMListFacetsTop" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head>
    <title>PCM List Facets</title>
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

        .pcm-list {
            background-color: #fafafa;
            border: 1px solid #bdbdbd;
        }

        .pcm-list-item {
            width: 100%;
            display: block;
            min-height: 1px;
        }

        .pcm-list-item:hover .pcm-list-edit-btn {
            background-color: #E91E63;
            color: #fff;
        }

        .pcm-list-item .form-group {
            border: 0;
            margin-bottom: 0px;
        }

        .pcm-list-item .form-control {
            border: 0;
            padding: 2px 4px;
            background-color: #fafafa;
            width: 100%;
        }

        .pcm-list-item .form-control:focus {
            background-color: #fff;
        }

        .pcm-list-edit-btn {
            width: 22px;
            height: 100%;
            display: inline-block;
            background-color: #eee;
            box-sizing: border-box;
            border-radius: 0;
            padding: 0;
        }

        .pcm-list-left {
            height: 80px;
            background-color: #fafafa;
        }

        .pcm-list-right {
            padding: 5px;
            background-color: #fafafa;
        }

        .pcm-list-right .pcm-list-block {
            float: right;
        }

        .pcm-list-block {
            display: block;
            width: 100%;
        }

            .pcm-list-block div {
                display: inline;
            }

        .pcm-list-right .pcm-list-block div {
            float: right;
        }

        .pcm-list-title {
            font-size: 18px;
            margin-bottom: 4px;
            height: 30px;
        }

        .pcm-list-description {
            padding: 2px 4px;
            cursor: pointer;
            min-width: 60px;
            background-color: #e0e0e0;
            display: inline;
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

        .pcm-thumb {
            display: inline-block;
            border: 1px solid #eee;
            vertical-align: top;
            margin: 5px;
            width: 100px;
            height: 70px;
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

        .pcm-list-info {
            display: inline-block;
            vertical-align: top;
            margin: 5px;
            width: calc(100% - 160px);
        }

        .pcm-list-productnumber {
            color: #9E9E9E;
            margin-right: 10px;
            margin-top: 7px;
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

        .pcm-list-price {
            font-size: 27px;
            font-weight: bold;
        }

        .pcm-list-price input {
            width: 100px !important;
            text-align: right;
        }

        .pcm-list-footer, .pcm-list-description-edit {
            width: 100%;
            background-color: #e0e0e0;
            float: left;
        }

        .pcm-list-description-edit {
            background-color: #bdbdbd; 
            height: 160px;
            transition: height 250ms ease-out, opacity 250ms ease-out;
        }

        .pcm-list-description-edit-mode {
            background-color: #03A9F4;
            position: relative;
            display: inline;
            color: #fff;
        }

        .pcm-list-description-edit-mode:after {
	        top: 100%;
	        left: 50%;
	        border: solid transparent;
	        content: " ";
	        height: 0;
	        width: 0;
	        position: absolute;
	        pointer-events: none;
	        border-color: rgba(136, 183, 213, 0);
	        border-top-color: #03A9F4;
	        border-width: 10px;
	        margin-left: -10px;
        }

        .pcm-list-description-edit.collapsed {
            height: 0;
        }

        .pcm-list-description-edit-field {
            margin: 5px;
        }

        .pcm-list-description-edit-field .form-control {
            width: calc(100% - 10px);
            height: 145px;
        }

        .pcm-list-footer .pcm-list-block {
            padding: 5px;
        }

        .pcm-list-footer .form-group {
            flex: 2;
            padding: 5px;
        }

        .pcm-list-footer .control-label, .pcm-list-footer .form-group-input {
            display: inline;
            color: #757575;
        }

        .pcm-list-footer .control-label {
            text-transform: uppercase;
            font-weight: bold;
        }

        .pcm-list-footer .form-control {
            background-color: #e0e0e0;
            min-width: 60px;
            max-width: 100px;
        }

        .card-header {
            padding-bottom: 0;
        }

        .pcm-filters-collapse-btn {
            width: 15px;
            height: 100%;
            display: inline-block;
            float: right;
            background-color: #bdbdbd;
            cursor: pointer;
        }

        .pcm-filters-collapse-btn:before {
            font-family: "FontAwesome";
            content: "\f0d9";
            vertical-align: middle;
            text-align: center;
            color: #e0e0e0;
            margin-left: 4px;
        }

        .pcm-header-filters {
            left: -15px;
            width: calc(100% + 30px);
            background-color: #eee;
        }

        .pcm-filter, .pcm-filters-footer {
            padding: 15px;
        }

        .pcm-filter {
            margin-bottom: 15px;
            clear: both;
        }

        .pcm-filter-header {
            margin-bottom: 10px;
            height: 20px;
        }

        .pcm-filter-title {
            font-size: 14px;
            color: #616161;
            text-transform: uppercase;
            font-weight: bold;
            margin-bottom: 5px;
            float: left;
        }

        .pcm-filter-switch {
            float: right;
            margin-top: 2px;
            right: -14px;
            position: relative;
        }

        .pcm-filter-switch .toggle-switch .ts-helper {
            height: 14px;
            width: 34px;
        }

        .pcm-filter-switch .toggle-switch .ts-helper:before {
            height: 22px;
            width: 22px;
        }

        .pcm-filter .control-label {
            margin-right: 0;
        }

        .pcm-filters-footer {
            margin-top: 15px;
            clear: both;
        }

        .pcm-filters-footer .btn {
            width: 100%;
        }

        .range-slider {
            width: 100%;
            margin-top: 10px;
        }

        .range-slider-count {
            font-weight: bold;
        }

        .checkbox-list {
            padding: 5px;
            float: left;
            border: 1px solid #bdbdbd;
            height: 90px;
            overflow: auto;
            margin-bottom: 10px;
            background-color: #fafafa;
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
          left: -50px;
          margin-bottom: 5px;
          margin-left: -80px;
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
          left: 42%;
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
    <div class="row area-pink">
        <div class="section-12">
            <div class="card">
                <div class="card-header">
                    <div class="row">
                        <div class="section-6">
                            <h2>PCM Productlist</h2>
                            <small class="card-header-subtitle">Bikez</small>
                        </div>
                        <div class="section-6 header-actions">
                            <button class="btn pull-right" title="Help"><i class="fa fa-question-circle"></i></button>
                            <select class="std select-languages pull-right">
                                <option>Select languages</option>
                                <option>Danish</option>
                                <option>English</option>
                            </select>
                            <div class="seperator pull-right"></div>
                            <button class="btn pull-right" id="pcm-bulk-edit" disabled title="Bulk edit">Bulk edit &nbsp;&nbsp;<span class="pcm-bulk-edit-counter" id="pcm-list-selection-counter">0</span></button>
                            <button class="btn pull-right" title="Delete"><i class="fa fa-remove color-danger"></i></button>
                            <button class="btn pull-right" title="Print"><i class="fa fa-plus-square color-success"></i></button>
                        </div>
                    </div>
                    <div class="row pcm-header-filters">
                        <div class="section-2">
                                <div class="pcm-filter">
                                    <div class="pcm-filter-header">
                                        <div class="pcm-filter-title">Price range</div>
                                        <div class="pcm-filter-switch">
                                            <div class="toggle-switch active-switch" data-ts-color="green">
                                                <input id="ts3" hidden="hidden" type="checkbox">
                                                <label for="ts3" class="ts-helper"></label>
                                            </div>
                                        </div>
                                    </div>
                                    <input type="range" class="range-slider" id="priceRangeSlider" min="0" max="9999" step="1" value="9999" oninput="outputUpdate(value)">
                                    <output class="range-slider-count" for="priceRangeSlider" id="priceRangeCount">9999</output>
                                </div>
                            </div>
                            <div class="section-2">
                                <div class="pcm-filter">
                                    <div class="pcm-filter-header">
                                        <div class="pcm-filter-title">Categories</div>
                                        <div class="pcm-filter-switch">
                                            <div class="toggle-switch active-switch" data-ts-color="green">
                                                <input id="ts4" hidden="hidden" type="checkbox" checked>
                                                <label for="ts4" class="ts-helper"></label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="checkbox-list">
                                        <dwc:CheckBox ID="ListCheckBox1" Name="ListCheckBox1" Label="Bikes" DoTranslate="False" checked="true" runat="server" />
                                        <dwc:CheckBox ID="ListCheckBox2" Name="ListCheckBox2" Label="Assesories" DoTranslate="False" checked="true" runat="server" />
                                        <dwc:CheckBox ID="ListCheckBox3" Name="ListCheckBox3" Label="Eyewear" DoTranslate="False" runat="server" />
                                        <dwc:CheckBox ID="ListCheckBox4" Name="ListCheckBox4" Label="Components" DoTranslate="False" runat="server" />
                                        <dwc:CheckBox ID="ListCheckBox5" Name="ListCheckBox5" Label="Campaign" DoTranslate="False" runat="server" />
                                        <dwc:CheckBox ID="ListCheckBox6" Name="ListCheckBox6" Label="Clothing" DoTranslate="False" checked="true" runat="server" />
                                        <dwc:CheckBox ID="ListCheckBox7" Name="ListCheckBox7" Label="Offers" DoTranslate="False" runat="server" />
                                        <dwc:CheckBox ID="ListCheckBox8" Name="ListCheckBox8" Label="Giftcards" DoTranslate="False" runat="server" />
                                        <dwc:CheckBox ID="ListCheckBox9" Name="ListCheckBox9" Label="Helmets" DoTranslate="False" runat="server" />
                                        <dwc:CheckBox ID="ListCheckBox10" Name="ListCheckBox10" Label="Lights" DoTranslate="False" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="section-2">
                                <div class="pcm-filter">
                                    <div class="pcm-filter-header">
                                        <div class="pcm-filter-title">Integration</div>
                                    </div>
                                    <dwc:CheckBox ID="FilterCheck1" Label="Recently added" DoTranslation="False" runat="server" />
                                </div>
                            </div>
                            <div class="section-2">
                                <div class="pcm-filter">
                                    <div class="pcm-filter-header">
                                        <div class="pcm-filter-title">Images</div>
                                    </div>
                                    <dwc:CheckBox ID="FilterCheck2" Label="Has no image" DoTranslation="False" runat="server" />
                                </div>
                           </div>
                    </div>
                </div>

                <div class="card-body">
                    <div class="pcm-list-header">
                        <dwc:CheckBox ID="CheckAll" Name="CheckAll" Label="Check all" DoTranslation="False" runat="server" />
                        <small class="pcm-list-header-info">Showing 105 of 12234 products</small>
                    </div>

                    <div class="pcm-list">
                        <div class="row">
                            <div class="section-12">

                                <div class="pcm-list-item">
                                    <div class="row">
                                        <div class="pcm-list-left section-9">
                                            <div class="pcm-list-check">
                                                <dwc:CheckBox ID="CheckBox1" Name="CheckBox1" runat="server" />
                                            </div>
                                            <button class="btn pcm-list-edit-btn"><i class="fa fa-pencil"></i></button>
                                            <div class="pcm-thumb"><img class="img-responsive" src="/Admin/Public/GetImage.ashx?width=100&amp;height=70&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg"></div>
                                            <div class="pcm-list-info">
                                                <div class="pcm-list-title">
                                                    <dwc:InputText runat="server" Placeholder="Title" Value="My new shiny product is all I need for the vacation in December"></dwc:InputText>
                                                </div>
                                                <div class="pcm-list-description js-pcm-list-description" data-id="description1">
                                                    I really like this fine product...
                                                </div>
                                            </div>
                                        </div>
                                        <div class="pcm-list-right section-3">
                                            <div class="pcm-list-block">
                                                <div class="pcm-list-publish"><i class="fa fa-check-circle color-success"></i></div>
                                                <div class="pcm-list-productnumber">#10121</div>
                                            </div>
                                            <div class="pcm-list-block">
                                                <div class="pcm-list-price">
                                                    <dwc:InputText runat="server" Placeholder="0.00" Value="9.98"></dwc:InputText>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="pcm-list-description-edit collapsed" id="description1">
                                            <div class="pcm-list-description-edit-field" style="visibility: hidden">
                                                <dwc:InputTextArea runat="server" Placeholder="Description" Value="I really like this fine product very much"></dwc:InputTextArea>
                                            </div>
                                        </div>
                                        <div class="pcm-list-footer">
                                            <div class="row">
                                                <dwc:InputText runat="server" Placeholder="0" Value="Assesories" Label="Category"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="122" Label="Stock"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="2kg" Label="Weight"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="4L" Label="Volume"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="None" Label="Campaign"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="98" Label="Points"></dwc:InputText>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="pcm-list-item">
                                    <div class="row">
                                        <div class="pcm-list-left section-9">
                                            <div class="pcm-list-check">
                                                <dwc:CheckBox ID="CheckBox2" Name="CheckBox2" runat="server" />
                                            </div>
                                            <button class="btn pcm-list-edit-btn"><i class="fa fa-pencil"></i></button>
                                            <div class="pcm-thumb"><img class="img-responsive" src="/Admin/Public/GetImage.ashx?width=100&amp;height=70&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10097.jpg"></div>
                                            <div class="pcm-list-info">
                                                <div class="pcm-list-title">
                                                    <dwc:InputText runat="server" Placeholder="Title" Value="Yet another fine product"></dwc:InputText>
                                                </div>
                                                <div class="pcm-list-description js-pcm-list-description" data-id="description2">
                                                    This is the text about the product...
                                                </div>
                                            </div>
                                        </div>
                                        <div class="pcm-list-right section-3">
                                            <div class="pcm-list-block">
                                                <div class="pcm-list-publish"><i class="fa fa-check-circle color-success"></i></div>
                                                <div class="pcm-list-productnumber">#10122</div>
                                            </div>
                                            <div class="pcm-list-block">
                                                <div class="pcm-list-price">
                                                    <dwc:InputText runat="server" Placeholder="0.00" Value="110.99"></dwc:InputText>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="pcm-list-description-edit collapsed" id="description2">
                                            <div class="pcm-list-description-edit-field" style="visibility: hidden">
                                                <dwc:InputTextArea runat="server" Placeholder="Description" Value="I really like this fine product very much"></dwc:InputTextArea>
                                            </div>
                                        </div>
                                        <div class="pcm-list-footer">
                                            <div class="row">
                                                <dwc:InputText runat="server" Placeholder="0" Value="Assesories" Label="Category"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="998" Label="Stock"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="22kg" Label="Weight"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="3L" Label="Volume"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="Easter" Label="Campaign"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="599" Label="Points"></dwc:InputText>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="pcm-list-item">
                                    <div class="row">
                                        <div class="pcm-list-left section-9">
                                            <div class="pcm-list-check">
                                                <dwc:CheckBox ID="CheckBox3" Name="CheckBox3" runat="server" />
                                            </div>
                                            <button class="btn pcm-list-edit-btn"><i class="fa fa-pencil"></i></button>
                                            <div class="pcm-thumb"><i class="fa fa-exclamation-circle"></i></div>
                                            <div class="pcm-list-info">
                                                <div class="pcm-list-title">
                                                    <dwc:InputText runat="server" Placeholder="Title" Value="You need this as much as I do..."></dwc:InputText>
                                                </div>
                                                <div class="pcm-list-description js-pcm-list-description" data-id="description3">
                                                    Read about it now...
                                                </div>
                                            </div>
                                        </div>
                                        <div class="pcm-list-right section-3">
                                            <div class="pcm-list-block">
                                                <div class="pcm-list-publish"><i class="fa fa-times-circle color-retracted"></i></div>
                                                <div class="pcm-list-action-icon" data-tooltip="Integrated 17:45 10-10-2016"><i class="fa fa-exchange"></i><i class="fa fa-circle color-retracted"></i></div>
                                                <div class="pcm-list-productnumber">#10121</div>
                                            </div>
                                            <div class="pcm-list-block">
                                                <div class="pcm-list-price">
                                                    <dwc:InputText runat="server" Placeholder="0.00" Value="15.00"></dwc:InputText>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="pcm-list-description-edit collapsed" id="description3">
                                            <div class="pcm-list-description-edit-field" style="visibility: hidden">
                                                <dwc:InputTextArea runat="server" Placeholder="Description" Value="I really like this fine product very much"></dwc:InputTextArea>
                                            </div>
                                        </div>
                                        <div class="pcm-list-footer">
                                            <div class="row">
                                                <dwc:InputText runat="server" Placeholder="0" Value="Assesories" Label="Category"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="3" Label="Stock"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="10kg" Label="Weight"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="2L" Label="Volume"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="Easter" Label="Campaign"></dwc:InputText>
                                                <dwc:InputText runat="server" Placeholder="0" Value="1022" Label="Points"></dwc:InputText>
                                            </div>
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
        document.addEventListener("DOMContentLoaded", function (event) {
            var buttons = document.getElementsByClassName("js-pcm-list-description");
            for (var i = 0; i < buttons.length; i++) {
                buttons[i].onclick = function () {
                    var elm = this;
                    var collapsedContent = document.getElementById(elm.dataset.id);
                    collapsedContent.classList.toggle('collapsed');

                    if (collapsedContent.classList.contains('collapsed')) {
                        elm.classList.remove("pcm-list-description-edit-mode");
                        collapsedContent.getElementsByClassName("form-control")[0].blur();
                        collapsedContent.getElementsByClassName("pcm-list-description-edit-field")[0].style.visibility = "hidden";
                    } else {
                        elm.classList.add("pcm-list-description-edit-mode");
                        collapsedContent.getElementsByClassName("pcm-list-description-edit-field")[0].style.visibility = "visible";
                        collapsedContent.getElementsByClassName("form-control")[0].focus();
                    }
                };
            }

            var checkboxes = document.getElementsByClassName("pcm-list-check");
            var selectedCount = 0;

            for (var i = 0; i < checkboxes.length; i++) {
                checkboxes[i].onclick = function () {

                    selectedCount++;
                    document.getElementById("pcm-list-selection-counter").innerHTML = selectedCount;

                    document.getElementById('pcm-bulk-edit').classList.add("pcm-bulk-edit-focus");
                    setTimeout(function () {
                        document.getElementById('pcm-bulk-edit').classList.remove("pcm-bulk-edit-focus");
                    },
                    1400);

                    if (selectedCount > 0) {
                        document.getElementById("pcm-bulk-edit").disabled = false;
                        document.getElementById("pcm-list-selection-counter").style.backgroundColor = "#E91E63";
                        document.getElementById("pcm-list-selection-counter").style.color = "#FFF";
                    } else {
                        document.getElementById("pcm-bulk-edit").disabled = true;
                        document.getElementById("pcm-list-selection-counter").style.backgroundColor = "#BDBDBD";
                        document.getElementById("pcm-list-selection-counter").style.color = "#333";
                    }
                };
            }
        });

        function outputUpdate(count) {
            document.querySelector('#priceRangeCount').value = count;
        }
    </script>
</body>
</html>
