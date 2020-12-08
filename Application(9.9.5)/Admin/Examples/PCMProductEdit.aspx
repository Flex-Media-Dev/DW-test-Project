<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="PCMProductEdit.aspx.vb" Inherits="Dynamicweb.Admin.PCMProductEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls.OMC" TagPrefix="omc" %>

<!DOCTYPE html>
<html>
<head>
    <title>Product Edit</title>
    <dw:ControlResources runat="server">
    </dw:ControlResources>

    <style>
        #primaryProductSettings fieldset {
            margin: 0;
        }

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

        .product-id {
            margin-top: -8px;
            color: #bdbdbd;
            font-size: 12px;
        }

        .active-switch .ts-label {
            right: 28px;
            position: absolute;
            text-transform: uppercase;
            color: #bdbdbd;
        }

        .active-switch .ts-helper {
            right: 5px;
        }

        .form-group .product-title {
            font-size: 20px;
            line-height: 30px;
            width: 100%;
        }

        .form-group .product-number {
            width: 100%;
        }

        .image-manager {
            border: 1px solid #e0e0e0;
            padding: 5px;
        }

        .image-manager-add-btn {
            display: inline-block;
            padding-top: 34px;
            vertical-align: top;
            font-size: 22px;
        }

        .thumbnail {
            position: relative;
            display: inline-block;
        }

        .thumbnail img {
            border: 1px solid #e0e0e0;
            background-color: #eee;
            padding: 4px;
            cursor: pointer;
        }

        .thumbnail .btn-remove {
            position: absolute;
            right: -4px;
            bottom: 5px;
            color: #F44336;
            font-size: 18px;
        }

        .thumbnail i {
            margin-left: 40px;
            margin-top: 25px;
            font-size: 22px;
            opacity: 1;
            transition: all ease-in 0.2s; 
        }

        .thumbnail:hover i {
            opacity: 0;
        }

        .thumbnail::before {
            font-family: "FontAwesome";
            content: "\f14b";
            position: absolute;
            opacity: 0;
            margin-left: 54px;
            margin-top: 38px;
            font-size: 22px;
            transition: all ease-in 0.2s;
        }

        .thumbnail:hover {
            opacity: .8;
        }

        .thumbnail:hover:before {
            opacity: 1;
        }

        .form-group .campaign-selector {
            width: 120px;
        }

        .activation-label {
            display: block;
        }

        .DateSelectorLabel {
            color: #9E9E9E;
        }

        .flag-icon {
            position: relative;
            top: -6px;
            margin-right: 10px;
        }

        .header-icon {
            position: relative;
            top: -15px;
            font-size: 22px;
            margin-right: 10px;
        }

        .header-icon .fa-exchange {
            z-index: 1;
            position: absolute;
            color: #fff;
            font-size: 13px;
            margin-left: 3px;
            margin-top: 9px;
        }

        fieldset .gbTitle .gbSubtitle {
            font-size: 14px;
            color: #bdbdbd;
            margin-top: 15px;
            text-transform: none;
            font-weight: 300;
        }

        .pcm-active-switch {
            float: right;
            margin-top: -8px;
            position: relative;
            font-size: 12px;
        }

        .pcm-active-switch .toggle-switch .ts-helper {
            height: 14px;
            width: 34px;
        }

        .pcm-active-switch .toggle-switch .ts-helper:before {
            height: 22px;
            width: 22px;
        }

        .tag-builder-container {
            width: 100%;
            min-height: 233px;
            border: 1px solid #bdbdbd;
            padding: 5px;
            box-sizing: border-box;
        }

        .tag-builder-actions {
            padding: 5px;
            border: 1px solid #bdbdbd;
            border-top: 0;
        }

        .tag-builder-actions .form-control {
            display: inline-block;
            width: calc(100% - 55px);
        }

        .tag {
            padding: 2px 4px;
            border-radius: 4px;
            background-color: #E91E63;
            color: #fff;
            display: inline-block;
            margin-bottom: 4px;
        }

        .tag-remove {
            cursor: pointer;
        }
    </style>
</head>
<body class="screen-container area-pink">
    <div class="row row-spacing">
        <div class="section-6 section-spacing">
            <div class="card">
                <div class="card-header">
                    <div class="flag-icon flag-icon-dk pull-left"></div>
                    <div class="product-id pull-left">PROD107</div>
                    <div class="pcm-active-switch pull-right">
                        <div class="toggle-switch active-switch" data-ts-color="green">
                            <label for="ts3" class="ts-label">Active</label>
                            <input id="ts3" hidden="hidden" type="checkbox" checked>
                            <label for="ts3" class="ts-helper"></label>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <dwc:GroupBox runat="server" ID="imageSettings">
                        <div class="row">
                            <div class="section-12">
                                <div class="image-manager">
                                    <div class="thumbnail img-responsive">
                                        <img id="FM_ProductImage_image" class="img-responsive" src="/Admin/Public/GetImage.ashx?width=120&amp;height=90&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg">
                                        <i id="FM_ProductImage_addicon" class="hidden thumbnail-add-file"></i>
                                    </div>
                                    <div class="btn btn-clean image-manager-add-btn">
                                        <i class="fa fa-plus-circle color-success"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </dwc:GroupBox>
                    <dwc:GroupBox runat="server" ID="primaryProductSettings">
                        <div class="row row-spacing">
                            <div class="section-6 section-spacing">
                                <dwc:InputText runat="server" Label="Title" Value="Mongoose Mountain Bike"></dwc:InputText>
                                <dwc:InputText runat="server" Label="Price" Value="70"></dwc:InputText>
                                <dwc:InputText runat="server" Label="Stock" Value="3"></dwc:InputText>
                                <dwc:InputText runat="server" Label="Points" Value="10"></dwc:InputText>
                                <dwc:InputText runat="server" Label="Product number" Value="10096"></dwc:InputText>
                            </div>
                            <div class="section-6 section-spacing">
                                <div class="form-group">
                                    <label class="control-label">Categories</label>	
                                    <div class="tag-builder-container">
		                                <div class="tag">Assesories <i class="fa fa-remove tag-remove"></i></div> 
                                        <div class="tag">Hats <i class="fa fa-remove tag-remove"></i></div>
                                        <div class="tag">Textile <i class="fa fa-remove tag-remove"></i></div>
                                        <div class="tag">Outdoor <i class="fa fa-remove tag-remove"></i></div>
                                        <div class="tag">Sale <i class="fa fa-remove tag-remove"></i></div>       
	                                </div>
                                    <div class="tag-builder-actions">
                                        <input type="text" class="form-control"/>
                                        <button type="button" class="btn btn-flat">Add</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Description" DoTranslation="false" runat="server">
                        <div class="form-group full-width">
                            <textarea class="std" rows="8"></textarea>
                        </div>
                    </dwc:GroupBox>
                </div>

                <div class="card-footer">
                </div>
            </div>
        </div>

        <div class="section-6 section-spacing">
            <div class="card">
                <div class="card-header">
                    <div class="flag-icon flag-icon-gb pull-left"></div>
                    <div class="header-icon pull-left" data-tooltip="Integrated 17:45 10-10-2016"><i class="fa fa-exchange"></i><i class="fa fa-circle color-retracted"></i></div>
                    <div class="product-id pull-left">PROD107</div>
                    <div class="pcm-active-switch pull-right">
                        <div class="toggle-switch active-switch" data-ts-color="green">
                            <label for="ts4" class="ts-label">Active</label>
                            <input id="ts4" hidden="hidden" type="checkbox" checked>
                            <label for="ts4" class="ts-helper"></label>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <dwc:GroupBox runat="server" ID="GroupBox1">
                        <div class="row">
                            <div class="section-12">
                                <div class="image-manager">
                                    <div class="thumbnail img-responsive">
                                        <img id="FM_ProductImage_image" class="img-responsive" src="/Admin/Public/GetImage.ashx?width=120&amp;height=90&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg">
                                        <i id="FM_ProductImage_addicon" class="hidden thumbnail-add-file"></i>
                                    </div>
                                    <div class="btn btn-clean image-manager-add-btn">
                                        <i class="fa fa-plus-circle color-success"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </dwc:GroupBox>
                    <dwc:GroupBox runat="server" ID="GroupBox2">
                        <div class="row row-spacing">
                            <div class="section-6 section-spacing">
                                <dwc:InputText runat="server" Label="Title" Value="Mongoose Mountain Bike"></dwc:InputText>
                                <dwc:InputText runat="server" Label="Price" Value="70"></dwc:InputText>
                                <dwc:InputText runat="server" Label="Stock" Value="3"></dwc:InputText>
                                <dwc:InputText runat="server" Label="Points" Value="10"></dwc:InputText>
                                <dwc:InputText runat="server" Label="Product number" Value="10096"></dwc:InputText>
                            </div>
                            <div class="section-6 section-spacing">
                                <div class="form-group">
                                    <label class="control-label">Categories</label>	
                                    <div class="tag-builder-container">
		                                <div class="tag">Assesories <i class="fa fa-remove tag-remove"></i></div> 
                                        <div class="tag">Hats <i class="fa fa-remove tag-remove"></i></div>
                                        <div class="tag">Textile <i class="fa fa-remove tag-remove"></i></div>
                                        <div class="tag">Outdoor <i class="fa fa-remove tag-remove"></i></div>
                                        <div class="tag">Sale <i class="fa fa-remove tag-remove"></i></div>       
	                                </div>
                                    <div class="tag-builder-actions">
                                        <input type="text" class="form-control"/>
                                        <button type="button" class="btn btn-flat">Add</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Description" DoTranslation="false" runat="server">
                        <div class="form-group full-width">
                            <textarea class="std" rows="8"></textarea>
                        </div>
                    </dwc:GroupBox>
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
</body>
</html>
