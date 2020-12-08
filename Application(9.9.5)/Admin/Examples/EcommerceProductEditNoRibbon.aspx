<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="EcommerceProductEditNoRibbon.aspx.vb" Inherits="Dynamicweb.Admin.EcommerceProductEditNoRibbon" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls.OMC" TagPrefix="omc" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head>
    <title>Product Edit</title>
    <dw:ControlResources runat="server">
    </dw:ControlResources>
    <link href="/Admin/FileManager/Browser/EntryContent.css" rel="stylesheet" type="text/css">

    <style>
        #primaryProductSettings fieldset {
            margin: 0;
        }

        .row {
            position: relative;
            width: calc(100% + 8px);
            left: -8px;
            display: flex;
            flex-flow: row wrap;
            justify-content: space-around;
        }

        .section-4 {
            margin: 0 8px;
            flex: 4;
        }

        .section-6 {
            margin: 0 8px;
            flex: 2;
        }

        .section-8 {
            margin: 0 8px;
            flex: 8;
        }

        .section-12 {
            margin: 0 8px;
            flex: 12;
        }

        @media screen and (max-width: 768px) {
            .row {
                flex-direction: column;
            }
        }

        .form-group {
            min-height: 30px;
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

        .product-id {
            margin-bottom: 6px;
            margin-top: 4px;
            color: #bdbdbd;
            font-size: 12px;
        }

        .active-switch .ts-label {
            right: 40px;
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

        .thumbnail {
            position: relative;
        }

            .thumbnail img {
                border: 1px solid #e0e0e0;
                background-color: #eee;
                padding: 4px;
            }

            .thumbnail .btn-remove {
                position: absolute;
                right: -4px;
                bottom: 5px;
                color: #F44336;
                font-size: 18px;
            }

        .image-manager {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 10px;
        }

            .image-manager .btn {
                line-height: inherit;
                margin: 0 4px;
            }

            .image-manager i {
                font-size: 22px;
                color: #616161;
            }

            .image-manager .image-manager-thumb {
                width: 46px;
                height: 32px;
                background-color: #eee;
                margin: 0 4px;
                padding: 4px;
                transition: all 0.2s;
                cursor: pointer;
            }

                .image-manager .image-manager-thumb:hover {
                    box-shadow: 0 2px 4px 0 rgba(0,0,0,.2);
                }

        .card-section-seperator {
            padding-top: 20px;
            width: 100%;
            float: left;
            border-top: 1px solid #e0e0e0;
            margin-top: 8px;
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

        #smallflag {
            position: relative;
            top: -6px;
        }

        .secondary-panel {
            background-color: #f5f5f5;
        }

            .secondary-panel .card-header {
                background-color: #bdbdbd;
            }

        fieldset .gbTitle .gbSubtitle {
            font-size: 14px;
            color: #bdbdbd;
            margin-top: 15px;
            text-transform: none;
            font-weight: 300;
        }
    </style>
</head>
<body class="screen-container">
    <div class="row area-pink">
        <div class="section-8">
            <div class="card">
                <div class="card-header">
                    <span class="flag-icon flag-icon-dk pull-right" id="smallflag"></span>
                </div>
                <div class="card-body">
                    <dwc:GroupBox runat="server" ID="primaryProductSettings">
                        <div class="row">
                            <div class="section-8">
                                <div class="product-id">PROD107</div>
                            </div>
                            <div class="section-4">
                                <div class="toggle-switch active-switch" data-ts-color="green">
                                    <label for="ts3" class="ts-label">Active</label>
                                    <input id="ts3" hidden="hidden" type="checkbox" checked>
                                    <label for="ts3" class="ts-helper"></label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="section-8">
                                <div class="row">
                                    <div class="section-12">
                                        <div class="form-group">
                                            <input type="text" class="std product-title" placeholder="Title" value="Mongoose Mountain Bike" />
                                        </div>
                                        <div class="form-group">
                                            <input type="text" class="std product-number" placeholder="Product number" value="10096" />
                                        </div>
                                    </div>
                                    <div class="card-section-seperator"></div>
                                </div>
                                <div class="row">
                                    <div class="section-6">
                                        <div class="form-group">
                                            <label class="form-label">Stock level</label>
                                            <span class="form-group-info">#</span>
                                            <input class="std" style="width: 70px" value="5" />
                                        </div>
                                    </div>
                                    <div class="section-6">
                                        <div class="form-group">
                                            <label class="form-label">Price</label>
                                            <span class="form-group-info">$</span>
                                            <input class="std" style="width: 70px" value="9,95" />
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Loyalty points</label>
                                            <span class="form-group-info">$</span>
                                            <input class="std" style="width: 70px" value="0.00" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="section-4">
                                <div class="thumbnail img-responsive">
                                    <img id="FM_ProductImage_image" class="img-responsive" src="/Admin/Public/GetImage.ashx?width=500&amp;height=320&amp;crop=1&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg">
                                    <i id="FM_ProductImage_addicon" class="hidden thumbnail-add-file"></i>
                                    <button class="btn btn-clean btn-remove"><i class="fa fa-times-circle"></i></button>
                                </div>
                                <div class="image-manager">
                                    <button class="btn btn-clean"><i class="fa fa-caret-left"></i></button>
                                    <div class="image-manager-thumb">
                                        <img src="/Admin/Public/GetImage.ashx?width=46&amp;height=32&amp;crop=1&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg">
                                    </div>
                                    <div class="image-manager-thumb">
                                        <img src="/Admin/Public/GetImage.ashx?width=46&amp;height=32&amp;crop=1&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10001.jpg">
                                    </div>
                                    <div class="image-manager-thumb">
                                        <img src="/Admin/Public/GetImage.ashx?width=46&amp;height=32&amp;crop=1&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10016.jpg">
                                    </div>
                                    <button class="btn btn-clean add-btn"><i class="fa fa-plus-circle"></i></button>
                                    <button class="btn btn-clean" disabled="true"><i class="fa fa-caret-right"></i></button>
                                </div>
                                <%--<dw:FileManager ID="ProductImage" Name="ProductImage" Folder="Images" File="Ecom/Products/10096.jpg" runat="server" Extensions="jpg,gif,png,swf" CssClass="std" />--%>
                            </div>
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Descriptions" DoTranslation="false" runat="server">
                        <div class="row">
                            <div class="section-6">
                                <div class="form-group full-width">
                                    <label class="form-label">Full description</label>
                                    <textarea class="std" rows="8"></textarea>
                                </div>
                            </div>
                            <div class="section-6">
                                <div class="form-group full-width">
                                    <label class="form-label">Teaser</label>
                                    <textarea class="std" rows="8"></textarea>
                                </div>
                            </div>
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Custom product fields" Subtitle="Does the product need any additional fields or category fields?" DoTranslation="false" runat="server">
                        <table border="0" cellpadding="2" cellspacing="2" width="100%">
                            <tbody>
                                <tr class="">
                                    <td class="LabelTop" width="170">New product</td>
                                    <td>
                                        <input _watching="1" checked="checked" value="1" class="checkbox" id="PRODFIELD_newproduct" name="PRODFIELD_newproduct" type="checkbox"><label for="PRODFIELD_newproduct"></label></td>
                                </tr>
                                <tr class="">
                                    <td class="LabelTop" width="170">Quantity</td>
                                    <td>
                                        <input _watching="1" class="NewUIinput" name="PRODFIELD_quantity" id="PRODFIELD_quantity" value="5" maxlength="11" style="width: 100px;" type="text"></td>
                                </tr>
                                <tr class="">
                                    <td class="LabelTop" width="170">Product Crop Origin</td>
                                    <td>
                                        <input _watching="1" class="NewUIinput" name="PRODFIELD_croporigin" id="PRODFIELD_croporigin" value="0" maxlength="11" style="width: 100px;" type="text"></td>
                                </tr>
                                <tr class="">
                                    <td class="LabelTop" width="170">Rims</td>
                                    <td>
                                        <input _watching="1" value="1" class="checkbox" id="PRODFIELD_rims" name="PRODFIELD_rims" type="checkbox"><label for="PRODFIELD_rims"></label></td>
                                </tr>
                                <tr class="">
                                    <td class="LabelTop" width="170">Discount</td>
                                    <td>
                                        <input _watching="1" value="1" class="checkbox" id="PRODFIELD_discount" name="PRODFIELD_discount" type="checkbox"><label for="PRODFIELD_discount"></label></td>
                                </tr>
                                <tr class="">
                                    <td class="LabelTop" width="170">Relation Group</td>
                                    <td>
                                        <input _watching="1" class="NewUIinput" name="PRODFIELD_relationgroup" id="PRODFIELD_relationgroup" value="227" maxlength="11" style="width: 100px;" type="text"></td>
                                </tr>
                                <tr class="">
                                    <td class="LabelTop" width="170">ItemCode</td>
                                    <td>
                                        <input _watching="1" class="NewUIinput" style="width: 500px;" name="PRODFIELD_ItemCode" id="PRODFIELD_ItemCode" value="" maxlength="255" type="text"></td>
                                </tr>
                                <tr class="">
                                    <td class="LabelTop" width="170">TaxCode</td>
                                    <td>
                                        <select _watching="1" class="NewUIinput" name="PRODFIELD_TaxCode">
                                            <option value="" selected="selected">Make a choice</option>
                                            <option value="dfg">sd</option>
                                            <option value="dfgd">sdd</option>
                                        </select></td>
                                </tr>
                                <tr class="">
                                    <td class="LabelTop" width="170">HideForGroup</td>
                                    <td>
                                        <input _watching="1" class="NewUIinput" style="width: 500px;" name="PRODFIELD_HideForGroup" id="PRODFIELD_HideForGroup" value="" maxlength="255" type="text"></td>
                                </tr>
                            </tbody>
                        </table>
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Files and documents" Subtitle="Do you want to attach any documents or files to the product?" IsCollapsed="True" DoTranslation="false" runat="server">
                        <div id="ListTableContainer" oncontextmenu="return List.showContextMenu(event, '', 'Files');">
                            <table id="ListTable" border="0" cellspacing="0">
                                <thead style="display: ">
                                    <tr class="header">
                                        <td class="columnCell" style="white-space: nowrap; min-width: 16px;">
                                            <table class="columnTable">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <input name="chk_all_Files" id="chk_all_Files" onclick="List.setAllSelected('Files', this.checked); rowSelected($('writeAccess').value);" type="checkbox"></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td class="columnCell" style="white-space: nowrap; min-width: 20px;">
                                            <table class="columnTable">
                                                <tbody>
                                                    <tr>
                                                        <td></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td class="columnCell" style="white-space: nowrap; width: 50%;">
                                            <table class="columnTable">
                                                <tbody>
                                                    <tr>
                                                        <td>Filnavn</td>
                                                        <td align="right"><a href="javascript:void(0);" class="columnMenu" onclick="return ContextMenu.show(event, 'SortingMenu:Files', '1','','BottomRightRelative');"><i class="fa fa-long-arrow-up"></i></a></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td class="columnCell" style="white-space: nowrap; min-width: 130px;">
                                            <table class="columnTable">
                                                <tbody>
                                                    <tr>
                                                        <td>Ændret</td>
                                                        <td align="right"><a href="javascript:void(0);" class="columnMenu" onclick="return ContextMenu.show(event, 'SortingMenu:Files', '2','','BottomRightRelative');"><i class="fa fa-caret-down"></i></a></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td class="columnCell" style="white-space: nowrap; min-width: 120px;">
                                            <table class="columnTable">
                                                <tbody>
                                                    <tr>
                                                        <td>Dimensioner</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td class="columnCell" style="white-space: nowrap; min-width: 120px;">
                                            <table class="columnTable">
                                                <tbody>
                                                    <tr>
                                                        <td>Farver</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td class="columnCell" style="white-space: nowrap; min-width: 100px;">
                                            <table class="columnTable">
                                                <tbody>
                                                    <tr>
                                                        <td>Størrelse</td>
                                                        <td align="right"><a href="javascript:void(0);" class="columnMenu" onclick="return ContextMenu.show(event, 'SortingMenu:Files', '5','','BottomRightRelative');"><i class="fa fa-caret-down"></i></a></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td class="columnCell" style="white-space: nowrap;">
                                            <table class="columnTable">
                                                <tbody>
                                                    <tr>
                                                        <td></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody id="Files_body" controlid="Files">
                                    <tr id="row1" itemid="/Files/Integration/jobs/export ecom xlsx.xml" oncontextmenu="return ContextMenu.show(event, 'FilesContext', '1','/Files/Integration/jobs/export ecom xlsx.xml','MousePointer');" ondblclick="__page.preview('/Files/Integration/jobs/export ecom xlsx.xml');" class="listRow">
                                        <td class="checkBoxCell" align="center">
                                            <input id="chk_1_Files" name="chk_1_Files" onclick="List.setRowSelected('Files', List.getContainingRow(this), this.checked, event); rowSelected($('writeAccess').value);" value="True" type="checkbox"></td>
                                        <td style="width: 20px">
                                            <div class="fm_column fm_column_smallicon"><i class="fa fa-file-code-o" alt="export ecom xlsx.xml"></i></div>
                                        </td>
                                        <td style="width: auto">
                                            <div class="fm_column fm_column_name" title="export ecom xlsx.xml">export ecom xlsx.xml</div>
                                        </td>
                                        <td style="width: 130px">
                                            <div class="fm_column fm_column_modified">ti, 15 sep 2015 12:52</div>
                                        </td>
                                        <td style="width: 120px">
                                            <div class="fm_column fm_column_dimensions"></div>
                                        </td>
                                        <td style="width: 120px">
                                            <div class="fm_column fm_column_colors"></div>
                                        </td>
                                        <td style="width: 100px">
                                            <div class="fm_column fm_column_size">221 KB</div>
                                        </td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr id="row2" itemid="/Files/Integration/jobs/Export products.xml" oncontextmenu="return ContextMenu.show(event, 'FilesContext', '2','/Files/Integration/jobs/Export products.xml','MousePointer');" ondblclick="__page.preview('/Files/Integration/jobs/Export products.xml');" class="listRow">
                                        <td class="checkBoxCell" align="center">
                                            <input id="chk_2_Files" name="chk_2_Files" onclick="List.setRowSelected('Files', List.getContainingRow(this), this.checked, event); rowSelected($('writeAccess').value);" value="True" type="checkbox"></td>
                                        <td>
                                            <div class="fm_column fm_column_smallicon"><i class="fa fa-file-code-o" alt="Export products.xml"></i></div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_name" title="Export products.xml">Export products.xml</div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_modified">ti, 15 sep 2015 12:52</div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_dimensions"></div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_colors"></div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_size">2.253 KB</div>
                                        </td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr id="row3" itemid="/Files/Integration/jobs/export users.xml" oncontextmenu="return ContextMenu.show(event, 'FilesContext', '3','/Files/Integration/jobs/export users.xml','MousePointer');" ondblclick="__page.preview('/Files/Integration/jobs/export users.xml');" class="listRow">
                                        <td class="checkBoxCell" align="center">
                                            <input id="chk_3_Files" name="chk_3_Files" onclick="List.setRowSelected('Files', List.getContainingRow(this), this.checked, event); rowSelected($('writeAccess').value);" value="True" type="checkbox"></td>
                                        <td>
                                            <div class="fm_column fm_column_smallicon"><i class="fa fa-file-code-o" alt="export users.xml"></i></div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_name" title="export users.xml">export users.xml</div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_modified">ti, 15 sep 2015 12:52</div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_dimensions"></div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_colors"></div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_size">266 KB</div>
                                        </td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr id="row4" itemid="/Files/Integration/jobs/tets.xml" oncontextmenu="return ContextMenu.show(event, 'FilesContext', '4','/Files/Integration/jobs/tets.xml','MousePointer');" ondblclick="__page.preview('/Files/Integration/jobs/tets.xml');" class="listRow">
                                        <td class="checkBoxCell" align="center">
                                            <input id="chk_4_Files" name="chk_4_Files" onclick="List.setRowSelected('Files', List.getContainingRow(this), this.checked, event); rowSelected($('writeAccess').value);" value="True" type="checkbox"></td>
                                        <td>
                                            <div class="fm_column fm_column_smallicon"><i class="fa fa-file-code-o" alt="tets.xml"></i></div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_name" title="tets.xml">tets.xml</div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_modified">ti, 15 sep 2015 12:52</div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_dimensions"></div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_colors"></div>
                                        </td>
                                        <td>
                                            <div class="fm_column fm_column_size">139 KB</div>
                                        </td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Variants" Subtitle="Does this product come in multiple variations like material, size or color?" DoTranslation="false" IsCollapsed="True" runat="server">
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Parts lists" DoTranslation="false" Subtitle="Add the parts that in combination creates the product" IsCollapsed="True" runat="server">
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Prices and discounts" Subtitle="Do you want to create special prices or discounts for the product?" DoTranslation="false" IsCollapsed="True" runat="server">
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="VAT Groups" Subtitle="Create advanced VAT configurations specific for this product here" DoTranslation="false" IsCollapsed="True" runat="server">
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Stock location" Subtitle="Manage the stok location for this product" DoTranslation="false" IsCollapsed="True" runat="server">
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Product relations" Subtitle="Does the product relate to other products?" DoTranslation="false" IsCollapsed="True" runat="server">
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Other" DoTranslation="false" IsCollapsed="True" runat="server">
                        <div class="row">
                            <div class="section-6">
                                <div class="form-group">
                                    <label class="form-label">Canonical</label>
                                    <input _watching="1" name="ctl00$ContentHolder$MetaCanonical" maxlength="255" id="ctl00_ContentHolder_MetaCanonical" class="std" type="text">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Cost</label>
                                    <input _watching="1" name="ctl00$ContentHolder$Cost" value="0.00" id="ctl00_ContentHolder_Cost" class="std" style="width: 80px; text-align: right" type="text">&nbsp;<span id="ctl00_ContentHolder_CurrencyLabelCost">€ </span>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Default units</label>
                                    <select _watching="1" class="std" name="DefaultUnitID" size="1">
                                        <option value="">None</option>
                                        <option value="VO10">Piece</option>
                                        <option value="VO11">Set of 2</option>
                                        <option value="VO7">Trailer</option>
                                    </select>
                                </div>
                            </div>
                            <div class="section-6">
                            </div>
                        </div>
                    </dwc:GroupBox>
                </div>

                <div class="card-footer">
                </div>
            </div>
        </div>

        <div class="section-4">
            <div class="card secondary-panel">
                <div class="card-header"></div>
                <div class="card-body">
                    <dwc:GroupBox Title="Organization" DoTranslation="false" runat="server">
                        <div class="form-group">
                            <label class="form-label">Shop</label>
                            <select _watching="1" name="ctl00$ContentHolder$DefaultShopID" id="ctl00_ContentHolder_DefaultShopID" class="std">
                                <option value="">None</option>
                                <option selected="selected" value="SHOP1">Bikez</option>
                                <option value="SHOP4">Fashion</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Manufacturer</label>
                            <select _watching="1" name="ctl00$ContentHolder$ManufacturerID" id="ctl00_ContentHolder_ManufacturerID" class="std">
                                <option selected="selected" value="">None</option>
                                <option value="MANU1">Cube</option>
                                <option value="MANU2">Trek</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Product type</label>
                            <select _watching="1" name="ctl00$ContentHolder$Type" id="ctl00_ContentHolder_Type" class="std" onchange="productTypeChanged(this);">
                                <option selected="selected" value="0">Stock item</option>
                                <option value="1">Service</option>
                                <option value="2">Parts list</option>
                                <option value="3">Gift card</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Default VAT group</label>
                            <select _watching="1" name="ctl00$ContentHolder$VatGrpID" id="ctl00_ContentHolder_VatGrpID" class="std">
                                <option selected="selected" value="">None</option>
                                <option value="VATGRP1">Standard</option>
                            </select>
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Campaigns and publishing" DoTranslation="false" runat="server">
                        <table style="height: 45px; margin: 0px 0px 0px 0px;">
                            <tr valign="top" style="height: 44px;">
                                <td>
                                    <label class="activation-label">Activation date</label>
                                    <dw:DateSelector runat="server" EnableViewState="false" ID="PageActiveFrom" />
                                </td>
                            </tr>
                            <tr valign="top" style="height: 44px;">
                                <td>
                                    <label class="activation-label">Deactivation datE</label>
                                    <dw:DateSelector runat="server" EnableViewState="false" ID="PageActiveTo" />
                                </td>
                            </tr>
                        </table>
                        <div class="form-group">
                            <label class="from-label">Campaign</label>
                            <select _watching="1" name="ctl00$ContentHolder$PeriodID" id="ctl00_ContentHolder_PeriodID" class="std campaign-selector">
                                <option selected="selected" value="">None</option>
                                <option value="PERIOD2">ssdf</option>
                                <option value="PERIOD3">Easter</option>
                            </select>
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Stock and delivery" DoTranslation="false" runat="server">
                        <div class="form-group">
                            <label class="form-label">Stock status</label>
                            <select _watching="1" name="ctl00$ContentHolder$StockGroupID" id="ctl00_ContentHolder_StockGroupID" class="std" style="width: 110px">
                                <option value="">None</option>
                                <option selected="selected" value="STOCKGRP1">Standard</option>
                                <option value="STOCKGRP3">test</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Weight</label>
                            <span class="form-group-info">kg</span>
                            <input class="std" style="width: 80px" value="5" />
                        </div>
                        <div class="form-group">
                            <label class="form-label">Volume</label>
                            <span class="form-group-info">m³</span>
                            <input class="std" style="width: 80px" value="20" />
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Personalization" DoTranslation="false" IsCollapsed="true" runat="server">
                        <div class="form-group">
                            <button type="button" class="btn btn-default"><i class="md md-account-box"></i>Personalization</button>
                        </div>
                        <div class="form-group">
                            <button type="button" class="btn btn-default"><i class="md md-person-add"></i>Add profilepoints</button>
                        </div>
                        <div class="form-group">
                            <button type="button" class="btn btn-default"><i class="fa fa-users"></i>Social publishing</button>
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Comments" DoTranslation="false" IsCollapsed="true" runat="server">
                    </dwc:GroupBox>
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
