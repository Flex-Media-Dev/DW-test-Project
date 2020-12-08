<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="EcommerceProductEdit.aspx.vb" Inherits="Dynamicweb.Admin.EcommerceProductEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
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

    <!-- CUSTOM CSS FOR THE PRODUCT EDIT PAGE -->
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

        .card-section-4 {
            margin: 0 8px;
            flex: 4;
        }

        .card-section-6 {
            margin: 0 8px;
            flex: 2;
        }

        .card-section-8 {
            margin: 0 8px;
            flex: 8;
        }

        .card-section-12 {
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
    </style>
</head>
<body class="screen-container">
    <div class="card area-pink">
        <dw:RibbonBar ID="RibbonBar" runat="server">
            <dw:RibbonBarTab ID="RibbonGeneralTab" Name="Product" runat="server" Visible="true">
                <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Information" runat="server">
                    <dw:RibbonBarRadioButton ID="RibbonBarButton1" Text="Details" Icon="InfoCircle" Size="Large" runat="server">
                    </dw:RibbonBarRadioButton>
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonBarGroupOptions" Name="Options" runat="server">
                    <dw:RibbonBarRadioButton ID="RibbonStockButton" Checked="False" Text="Stock" Size="Small"
                        runat="server" Icon="TrendingUp"
                        Group="productTabs">
                    </dw:RibbonBarRadioButton>

                    <dw:RibbonBarRadioButton ID="RibbonVariantsButton" Checked="False" Text="Variants" Size="Small"
                        runat="server" Icon="HDRWeak"
                        ContextMenuId="VariantsContext" SplitButton="true"
                        Group="productTabs">
                    </dw:RibbonBarRadioButton>

                    <dw:RibbonBarRadioButton ID="RibbonPartsListsButton" Checked="False" Text="Parts Lists" Size="Small"
                        runat="server" Icon="List"
                        ContextMenuId="PartsListContext" SplitButton="true"
                        Group="productTabs">
                    </dw:RibbonBarRadioButton>

                    <dw:RibbonBarRadioButton ID="RibbonPricesButton" Checked="False" Text="Prices" Size="Small"
                        runat="server" Icon="Money"
                        Group="productTabs">
                    </dw:RibbonBarRadioButton>

                    <dw:RibbonBarRadioButton ID="RibbonDiscountsButton" Checked="False" Text="Discounts" Size="Small"
                        runat="server" ContextMenuId="DiscountContext" SplitButton="true" Icon="Tags"
                        Group="productTabs">
                    </dw:RibbonBarRadioButton>

                    <dw:RibbonBarRadioButton ID="RibbonVATGroupsButton" Checked="False" Text="VAT groups" Size="Small"
                        runat="server" Icon="Bank"
                        Group="productTabs">
                    </dw:RibbonBarRadioButton>

                    <dw:RibbonBarRadioButton ID="RibbonRelatedGroupsButton" Checked="False" Text="Related groups"
                        Size="Small"
                        runat="server" Icon="Folder" IconColor="Default"
                        Group="productTabs" />

                    <dw:RibbonBarRadioButton ID="RibbonRelatedProdButton" Checked="False" Text="Related products" Size="Small"
                        runat="server" Icon="GroupWork"
                        ContextMenuId="RelatedContext" SplitButton="true"
                        OnClientClick="ribbonTab('RELATED', 8);" Group="productTabs" />

                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonGroupLanguage" Name="Language" runat="server">
                    <ecom:LanguageSelector ID="langSelector" OnClientSelect="selectLang" TrackFormChanges="true" runat="server" />
                    <%--<dw:RibbonBarButton ID="RibbonDelocalizeButton" Text="Delocalize" Icon="NotInterested" Size="Large"
                        runat="server" EnableServerClick="true">
                    </dw:RibbonBarButton>--%>
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonBarGroup2" Name="Social" runat="server">
                    <dw:RibbonBarButton ID="Comments" Text="Comments" Icon="ModeComment" Size="Large" runat="server" />
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonBarGroup20" Name="Help" runat="server">
                    <dw:RibbonBarButton ID="ButtonHelp" Icon="Help" Size="Large" Text="Help" runat="server" OnClientClick="help();" />
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>

            <dw:RibbonBarTab ID="rbtOptions" Active="false" Name="Options" Visible="true" runat="server">
                <dw:RibbonBarGroup ID="RibbonbarGroup7" runat="server" Name="Publication">
                    <dw:RibbonBarPanel ID="RibbonbarPanel1" ExcludeMarginImage="true" runat="server">
                        <table style="height: 45px; margin: 0px 0px 0px 0px;">
                            <tr valign="top" style="height: 44px;">
                                <td>
                                    <label class="activation-label"><%=Translate.Translate("Activation date")%></label>
                                    <dw:DateSelector runat="server" EnableViewState="false" ID="PageActiveFrom" />
                                </td>
                            </tr>
                            <tr valign="top" style="height: 44px;">
                                <td>
                                    <label class="activation-label"><%=Translate.Translate("Deactivation date")%></label>
                                    <dw:DateSelector runat="server" EnableViewState="false" ID="PageActiveTo" />
                                </td>
                            </tr>
                        </table>
                    </dw:RibbonBarPanel>
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonbarGroupCampaigns" runat="server" Name="Campaigns">
                    <dw:RibbonBarPanel ID="RibbonbarPanel2" ExcludeMarginImage="true" runat="server">
                        <div class="form-group">
                            <label class="from-label">Campaign</label>
                            <select _watching="1" name="ctl00$ContentHolder$PeriodID" id="ctl00_ContentHolder_PeriodID" class="std campaign-selector">
                                <option selected="selected" value="">None</option>
                                <option value="PERIOD2">ssdf</option>
                                <option value="PERIOD3">Easter</option>
                            </select>
                        </div>
                    </dw:RibbonBarPanel>
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonbarGroup3" Name="Tools" runat="server">
                    <dw:RibbonBarButton ID="cmdPeriodOptimize" Text="Optimize" Icon="Tachometer" Size="Large" runat="server" />
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonBarGroup4" Name="Help" runat="server">
                    <dw:RibbonBarButton ID="RibbonBarButton2" Icon="Help" Size="Large" Text="Help" runat="server" OnClientClick="help();" />
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>

            <dw:RibbonBarTab ID="tabMarketing" Active="false" Name="Marketing" Visible="true" runat="server">
                <dw:RibbonBarGroup ID="groupMarketingRestrictions" Name="Personalization" runat="server">
                    <dw:RibbonBarButton ID="cmdMarketingPersonalize" Text="Personalize" Size="Small" Icon="AccountBox" runat="server" />
                    <dw:RibbonBarButton ID="cmdMarketingProfileDynamics" Text="Add profile points" Size="Small" Icon="PersonAdd" runat="server" />
                </dw:RibbonBarGroup>       
                <dw:RibbonBarGroup ID="groupMarketingHelp" Name="Help" runat="server">
                    <dw:RibbonBarButton ID="cmdMarketingHelp" Text="Help" Icon="Help" Size="Large" OnClientClick="help();" runat="server">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
        </dw:RibbonBar>

        <div class="card-body">
            <dwc:GroupBox runat="server" ID="primaryProductSettings">
                <div class="row">
                    <div class="card-section-8">
                        <div class="product-id">PROD107</div>
                    </div>
                    <div class="card-section-4">
                        <div class="toggle-switch active-switch" data-ts-color="green">
                            <label for="ts3" class="ts-label">Active</label>
                            <input id="ts3" hidden="hidden" type="checkbox" checked>
                            <label for="ts3" class="ts-helper"></label>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="card-section-8">
                        <div class="row">
                            <div class="card-section-12">
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
                            <div class="card-section-6">
                                <div class="form-group">
                                    <label class="form-label">Price</label>
                                    <span class="form-group-info">$</span>
                                    <input class="std" style="width: 80px" value="9,95" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Stock level</label>
                                    <span class="form-group-info">#</span>
                                    <input class="std" style="width: 80px" value="5" />
                                </div>
                            </div>
                            <div class="card-section-6">
                                <div class="form-group">
                                    <label class="form-label">Loyalty points</label>
                                    <span class="form-group-info">$</span>
                                    <input class="std" style="width: 80px" value="0.00" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Manufacturer</label>
                                    <select _watching="1" name="ctl00$ContentHolder$ManufacturerID" id="ctl00_ContentHolder_ManufacturerID" class="std">
                                        <option selected="selected" value="">None</option>
                                        <option value="MANU1">Cube</option>
                                        <option value="MANU2">Trek</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="card-section-seperator"></div>
                            <div class="card-section-12">
                                <div class="form-group full-width">
                                    <dw:Editor runat="server" ID="LongDescription" name="LongDescription" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-section-4">
                        <div class="thumbnail img-responsive">
                            <img id="FM_ProductImage_image" class="img-responsive" src="/Admin/Public/GetImage.ashx?width=500&amp;height=320&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg">
                            <i id="FM_ProductImage_addicon" class="hidden thumbnail-add-file"></i>
                            <button class="btn btn-clean btn-remove"><i class="fa fa-times-circle"></i></button>
                        </div>
                        <div class="image-manager">
                            <button class="btn btn-clean"><i class="fa fa-caret-left"></i></button>
                            <div class="image-manager-thumb">
                                <img src="/Admin/Public/GetImage.ashx?width=46&amp;height=32&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10096.jpg">
                            </div>
                            <div class="image-manager-thumb">
                                <img src="/Admin/Public/GetImage.ashx?width=46&amp;height=32&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10001.jpg">
                            </div>
                            <div class="image-manager-thumb">
                                <img src="/Admin/Public/GetImage.ashx?width=46&amp;height=32&amp;crop=0&amp;Compression=75&amp;image=/Files/Images/Ecom/Products/10016.jpg">
                            </div>
                            <button class="btn btn-clean add-btn"><i class="fa fa-plus-circle"></i></button>
                            <button class="btn btn-clean" disabled="true"><i class="fa fa-caret-right"></i></button>
                        </div>
                        <%--<dw:FileManager ID="ProductImage" Name="ProductImage" Folder="Images" File="Ecom/Products/10096.jpg" runat="server" Extensions="jpg,gif,png,swf" CssClass="std" />--%>
                    </div>
                </div>
            </dwc:GroupBox>

            <dwc:GroupBox Title="Product fields" runat="server">
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

            <dwc:GroupBox Title="Product category fields" IsCollapsed="True" DoTranslation="false" runat="server">
            </dwc:GroupBox>

            <dwc:GroupBox Title="Short description" IsCollapsed="True" DoTranslation="false" runat="server">
                <div class="row">
                    <div class="card-section-12">
                        <div class="form-group full-width">
                            <label class="form-label">Teaser</label>
                            <dw:Editor runat="server" ID="ShortDescription" name="ShortDescription" />
                        </div>
                    </div>
                </div>
            </dwc:GroupBox>

            <dwc:GroupBox Title="Stock" IsCollapsed="True" DoTranslation="false" runat="server">
                <table border="0" cellpadding="2" cellspacing="2" width="100%">
                    <tbody>
                        <tr>
                            <td width="170">Stock status
                            </td>
                            <td>
                                <select _watching="1" name="ctl00$ContentHolder$StockGroupID" id="ctl00_ContentHolder_StockGroupID" class="std" style="width: 110px">
                                    <option value="">None</option>
                                    <option selected="selected" value="STOCKGRP1">Standard</option>
                                    <option value="STOCKGRP3">test</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td width="170">
                                <dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Default units"></dw:TranslateLabel>
                            </td>
                            <td width="200">
                                <select _watching="1" class="std" name="DefaultUnitID" size="1">
                                    <option value="">None</option>
                                    <option value="VO10">Piece</option>
                                    <option value="VO11">Set of 2</option>
                                    <option value="VO7">Trailer</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td width="170">Weight
                            </td>
                            <td>
                                <input type="text" id="Weight" width="40" class="std" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td width="170">Volume
                            </td>
                            <td>
                                <input type="text" id="Volume" width="40" class="NewUIinput" runat="server" />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox Title="Documents and files" IsCollapsed="True" DoTranslation="false" runat="server">

                <!-- IN DW8 THIS WERE LOCATED IN RIBBON -> MEDIA -> IMAGES/LINKS -->

            </dwc:GroupBox>

            <dwc:GroupBox Title="Advanced configurations" DoTranslation="false" IsCollapsed="True" runat="server">
                <table border="0" cellpadding="2" cellspacing="0" width='100%' style='width: 100%'>
                    <tr>
                        <td>
                            <table border="0" cellpadding="2" cellspacing="2" width="100%">
                                <tr>
                                    <td width="170">
                                        <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Shop"></dw:TranslateLabel>
                                    </td>
                                    <td width="200">
                                        <select _watching="1" name="ctl00$ContentHolder$DefaultShopID" id="ctl00_ContentHolder_DefaultShopID" class="std">
                                            <option value="">None</option>
                                            <option selected="selected" value="SHOP1">Bikez</option>
                                            <option value="SHOP4">Fashion</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="170">
                                        <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Product type"></dw:TranslateLabel>
                                    </td>
                                    <td width="200">
                                        <select _watching="1" name="ctl00$ContentHolder$Type" id="ctl00_ContentHolder_Type" class="std" onchange="productTypeChanged(this);">
                                            <option selected="selected" value="0">Stock item</option>
                                            <option value="1">Service</option>
                                            <option value="2">Parts list</option>
                                            <option value="3">Gift card</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="170">
                                        <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Default VAT group"></dw:TranslateLabel>
                                    </td>
                                    <td width="200">
                                        <select _watching="1" name="ctl00$ContentHolder$VatGrpID" id="ctl00_ContentHolder_VatGrpID" class="std">
                                            <option selected="selected" value="">None</option>
                                            <option value="VATGRP1">Standard</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="170">
                                        <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Cost"></dw:TranslateLabel>
                                    </td>
                                    <td width="200">
                                        <input _watching="1" name="ctl00$ContentHolder$Cost" value="0.00" id="ctl00_ContentHolder_Cost" class="std" style="width: 80px; text-align: right" type="text">&nbsp;<span id="ctl00_ContentHolder_CurrencyLabelCost">€ </span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox Title="Meta data" DoTranslation="false" IsCollapsed="True" runat="server">
                <table border="0" cellpadding="2" cellspacing="0" width='100%' style='width: 100%'>
                    <tr>
                        <td>
                            <table border="0" cellpadding="2" cellspacing="2" width="100%">
                                <tr>
                                    <td width="170">
                                        <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Title"></dw:TranslateLabel>
                                    </td>
                                    <td width="200">
                                        <input type="text" id="MetaTitle" class="NewUIinput product-meta-title" runat="server"></input>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="170" class="LabelTop">
                                        <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Description"></dw:TranslateLabel>
                                    </td>
                                    <td>
                                        <textarea id="MetaDescr" textmode="MultiLine" columns="30" rows="4" class="NewUIinput product-meta-description" runat="server"
                                            onfocus="ShowCounters(this,'MetaDescrCounter',_MetaDescrCounterMaxId);"
                                            onkeyup="CheckCounter(this,'MetaDescrCounter',_MetaDescrCounterMaxId);"
                                            onblur="CheckAndHideCounter(this,'MetaDescrCounter',_MetaDescrCounterMaxId);"></textarea>
                                    </td>
                                    <td align="left" valign="top">
                                        <strong id="MetaDescrCounter" class="char-counter"></strong>
                                        <input type="hidden" id="MetaDescrCounterMax" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="170" class="LabelTop">
                                        <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Keywords"></dw:TranslateLabel>
                                    </td>
                                    <td>
                                        <textarea id="MetaKeywords" textmode="MultiLine" columns="30" rows="4" class="NewUIinput product-meta-keywords" runat="server"
                                            onfocus="ShowCounters(this,'MetaKeywordsCounter',_MetaKeywordsCounterMaxId);"
                                            onkeyup="CheckCounter(this,'MetaKeywordsCounter',_MetaKeywordsCounterMaxId);"
                                            onblur="CheckAndHideCounter(this,'MetaKeywordsCounter',_MetaKeywordsCounterMaxId);"></textarea>
                                    </td>
                                    <td align="left" valign="top">
                                        <strong id="MetaKeywordsCounter" class="char-counter"></strong>
                                        <input type="hidden" id="MetaKeywordsCounterMax" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Canonical page"></dw:TranslateLabel>
                                    </td>
                                    <td>
                                        <input type="text" id="MetaCanonical" maxlength="255" class="NewUIinput" runat="server"></input>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td width="170">
                                        <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="URL"></dw:TranslateLabel>
                                    </td>
                                    <td>
                                        <input type="text" id="MetaUrl" class="NewUIinput product-meta-url" runat="server"></input></td>
                                    <td></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </div>

        <div class="card-footer">
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
