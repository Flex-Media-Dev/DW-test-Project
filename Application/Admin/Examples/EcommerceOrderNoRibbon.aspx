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
    <link href="/Admin/Module/eCom_Catalog/dw7/css/orderEdit.css" rel="stylesheet" type="text/css">

    <style>
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

        .order-number {
            margin-top: 0px;
        }

        .order-date {
            color: #9E9E9E;
        }

        .edit-button {
            float: right;
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

        .form-group .product-title {
            font-size: 20px;
            line-height: 30px;
            width: 100%;
        }

        .form-group .product-number {
            width: 100%;
        }

        .section-seperator {
            padding-top: 20px;
            width: 100%;
            float: left;
            border-top: 1px solid #e0e0e0;
            margin-top: 8px;
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

        .order-details-box {
            background-color: #f5f5f5;
            padding: 15px 10px;
            margin-bottom: 20px;
        }

            .order-details-box fieldset .gbTitle {
                margin-bottom: 0px;
            }

        .order_item4, .order_item5 {
            width: 103px;
        }

        .header-actions .btn {
            margin-left: 5px;
        }

        .header-actions .seperator {
            height: 28px;
            margin-left: 7px;
            margin-right: 3px;
            border-left: 1px solid #e0e0e0;
        }
    </style>
</head>
<body class="screen-container">
    <div class="row area-pink">
        <div class="section-8">
            <div class="card">
                <div class="card-header">
                    <div class="row">
                        <div class="section-6">
                            <h2>#DEMOORDER261</h2>
                            <small class="order-date">01/09/15 11:36:06</small>
                        </div>
                        <div class="section-6 header-actions">
                            <button class="btn pull-right"><i class="fa fa-arrow-right"></i></button>
                            <button class="btn pull-right" disabled=""><i class="fa fa-arrow-left"></i></button>
                            <div class="seperator pull-right"></div>
                            <button class="btn pull-right" title="Edit"><i class="fa fa-pencil"></i></button>
                            <button class="btn pull-right" title="Print"><i class="fa fa-print"></i></button>
                            <button class="btn pull-right" title="RMA"><i class="md md-assignment-late"></i></button>
                            <button class="btn pull-right" title="Delivery documents"><i class="fa fa-truck"></i></button>
                            <button class="btn pull-right" title="Capture"><i class="fa fa-credit-card"></i></button>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <dwc:GroupBox runat="server" ID="primaryProductSettings">
                        <div class="row">
                            <div class="section-12">
                                <div class="order_items" id="OrderItemsShow">
                                    <div class="list">
                                        <table class="main" cellspacing="0">
                                            <tbody>
                                                <tr style="display: none">
                                                    <td class="title">List (1)</td>
                                                </tr>
                                                <tr>
                                                    <td class="container">
                                                        <div id="ListTableContainer" oncontextmenu="return List.showContextMenu(event, '', 'OrderLines');">
                                                            <table id="ListTable" border="0" cellspacing="0">
                                                                <thead style="display: ">
                                                                    <tr class="header">
                                                                        <td class="columnCell" style="white-space: nowrap; min-width: 120px;">
                                                                            <table class="columnTable">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td>Number</td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td class="columnCell" style="white-space: nowrap; min-width: 341px;">
                                                                            <table class="columnTable">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td>Name</td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td class="columnCell" style="white-space: nowrap; min-width: 50px;" align="center">
                                                                            <table class="columnTable">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td align="center">Quantity</td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                            <table class="columnTable">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td align="right">Unit price</td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                            <table class="columnTable">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td align="right">Total price</td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </thead>
                                                                <tbody id="OrderLines_body" controlid="ctl00$ContentHolder$UCOrderEdit$OrderLines">
                                                                    <tr id="row1" itemid="OL5712" oncontextmenu="return ContextMenu.show(event, 'OrderLineContext', '1','OL5712','MousePointer');" class="listRow withHover">
                                                                        <td style="width: 120px">10173</td>
                                                                        <td style="width: 341px">Shimano Ultegra 6600/Mavic Wheelset</td>
                                                                        <td style="width: 50px" align="center">
                                                                            <div>
                                                                                <input class="std" id="OlQuantityOL5712" maxlength="9" style="width: 50px; border-style: none; text-align: center;" name="OlQuantityOL5712" readonly="readonly" value="1" type="text">
                                                                            </div>
                                                                        </td>
                                                                        <td style="width: 90px" align="right">
                                                                            <div><span id="OlNiceUnitPriceOL5712">350.00</span><input class="std" id="OlUnitPriceOL5712" maxlength="18" style="width: 80px; border-style: none; text-align: right; display: none;" name="OlUnitPriceOL5712" readonly="readonly" value="350" type="text"></div>
                                                                        </td>
                                                                        <td style="width: 90px" align="right">€ 350.00</td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <input id="SortingMenu:OrderLines_onShow" value="" type="hidden">
                                    <input id="SortingMenu:OrderLines_onHide" value="" type="hidden">
                                    <div id="SortingMenu:OrderLines" class="contextmenu dropdown-menu no-animation" oncontextmenu="return false;">
                                        <span class="edge"></span>
                                        <span class="container" style="">
                                            <span id="SortingMenuSortAscending"><a id="hrefSortingMenuSortAscending" style="" ongetstate="" onclick="List.sortInternal('ctl00$ContentHolder$UCOrderEdit$OrderLines', List.SortDirection.Ascending);" onmouseover="ContextMenu.expand(this)" href="#"><span class="item"><i id="cmImg_SortingMenuSortAscending" class="fa fa-sort-amount-asc"></i>Sort ascending</span><img style="display: none"></a>
                                            </span>
                                            <span id="SortingMenuSortDescending"><a id="hrefSortingMenuSortDescending" style="" ongetstate="" onclick="List.sortInternal('ctl00$ContentHolder$UCOrderEdit$OrderLines', List.SortDirection.Descending);" onmouseover="ContextMenu.expand(this)" href="#"><span class="item"><i id="cmImg_SortingMenuSortDescending" class="fa fa-sort-amount-desc"></i>Sort descending</span><img style="display: none"></a>
                                            </span>
                                        </span><span class="edge"></span>
                                    </div>

                                    <div class="editControls" style="display: none; width: 100%;" align="right">
                                        <img src="/admin/images/ecom/eCom_Discounts_add_small.gif" id="addDiscountButton" onclick="dialog.show('addDiscountDialog');" alt="Add discount">
                                        <img src="/admin/images/ecom/eCom_Product_add_small.gif" onclick="dialog.show('EditProductDialog');">&nbsp;
                           
                                    </div>

                                    <input id="OrderLineContext_onShow" value="" type="hidden">
                                    <input id="OrderLineContext_onHide" value="" type="hidden">
                                    <div id="OrderLineContext" class="contextmenu dropdown-menu no-animation" oncontextmenu="return false;">
                                        <span class="edge"></span>
                                        <span class="container" style="">

                                            <span id="editProductButton"><a id="hrefeditProductButton" style="" ongetstate="" onclick="showProduct();" onmouseover="ContextMenu.expand(this)" href="#"><span class="item"><i id="cmImg_editProductButton" class="fa fa-plus-square"></i>Go to product</span><img style="display: none"></a>
                                            </span>

                                            <span id="pageButton"><a id="hrefpageButton" style="" ongetstate="" onclick="showPage();" onmouseover="ContextMenu.expand(this)" href="#"><span class="item"><i id="cmImg_pageButton" class="md  md-open-in-new"></i>Show page</span><img style="display: none"></a>
                                            </span>

                                        </span><span class="edge"></span>
                                    </div>


                                    <div class="order_item_foot">
                                        <div class="order_item1"></div>
                                        <div class="order_item2">Total purchase price excluding VAT and taxes</div>
                                        <div class="order_item5 ">
                                            <span id="ctl00_ContentHolder_UCOrderEdit_totalBeforePriceWithoutVATAndTax">€ 290.00</span>
                                        </div>
                                    </div>
                                    <div class="order_item_foot">
                                        <div class="order_item1"></div>
                                        <div class="order_item2">Total purchase price excluding taxes</div>
                                        <div class="order_item5 ">
                                            <span id="ctl00_ContentHolder_UCOrderEdit_totalBeforePriceWithoutTax">€ 360.00</span>
                                        </div>
                                    </div>
                                    <div class="order_item_foot">
                                        <div class="order_item1"></div>
                                        <div class="order_item2">Total purchase price excluding VAT</div>
                                        <div class="order_item5 ">
                                            <span id="ctl00_ContentHolder_UCOrderEdit_totalBeforePriceWithoutVAT">€ 280.00</span>
                                        </div>
                                    </div>
                                    <div class="order_item_foot">
                                        <div class="order_item1"></div>
                                        <div class="order_item2">
                                            Payment
                                                                    
                                                                    :&nbsp;<span class="disableText" style="font-size: 9px;">(Invoice)</span>
                                        </div>
                                        <div class="order_item5">
                                            <span id="ctl00_ContentHolder_UCOrderEdit_totalPaymentFeePrice">€ 0.00</span>
                                        </div>
                                    </div>
                                    <div class="order_item_foot">
                                        <div class="order_item1"></div>
                                        <div class="order_item2">
                                            Shipping
                                                                    
                                                                    :&nbsp;<span class="disableText" style="font-size: 9px;">(Danish Post Office)</span>
                                        </div>
                                        <div class="order_item5">
                                            <span id="ctl00_ContentHolder_UCOrderEdit_totalShippingFeePrice">€ 10.00</span>
                                        </div>
                                    </div>
                                    <div class="order_item_foot">
                                        <div class="order_item1"></div>
                                        <div class="order_item2">Sub-total excluding VAT</div>
                                        <div class="order_item5">
                                            <span id="ctl00_ContentHolder_UCOrderEdit_totalPriceWithoutVAT">€ 290.00</span>
                                        </div>
                                    </div>
                                    <div class="order_item_foot">
                                        <div class="order_item1"></div>
                                        <div class="order_item2">VAT</div>
                                        <div class="order_item5">
                                            <span id="ctl00_ContentHolder_UCOrderEdit_totalPriceVAT">€ 70.00</span>
                                        </div>
                                    </div>
                                    <div class="order_item_foot">
                                        <div class="order_item1"></div>
                                        <div class="order_item2"><strong>Total price including VAT</strong></div>
                                        <div class="order_item5">
                                            <strong><span id="ctl00_ContentHolder_UCOrderEdit_totalPriceFormatted">€ 360.00</span></strong>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Comments" IsCollapsed="false" DoTranslation="false">
                        <span>I would like the bike to be colored green...</span>
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Additional information" IsCollapsed="true" DoTranslation="false">
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Order data" IsCollapsed="true" DoTranslation="false">
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="History" IsCollapsed="true" DoTranslation="false">
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Transaction" IsCollapsed="true" DoTranslation="false">
                    </dwc:GroupBox>

                    <dwc:GroupBox runat="server" Title="Miscellaneous" IsCollapsed="false" DoTranslation="false">
                        <table style="width: 100%;" border="0" cellpadding="2" cellspacing="0" width="100%">
                            <tbody>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="2" cellspacing="2" width="100%">
                                            <tbody>
                                                <tr>
                                                    <td width="170">Price calc. date
                                            </td>
                                                    <td>01/09/15 11:36:06
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td width="170">Completed
                                            </td>
                                                    <td>01/09/15 11:36:06
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td width="170">Recurring
                                            </td>
                                                    <td>Every 1 Weeks (Ended)
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td width="170">Standard sales tax
                                            </td>
                                                    <td>
                                                        <span id="ctl00_ContentHolder_UCOrderEdit_OrderVAT">25%</span>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td width="170">Bought in shop
                                            </td>
                                                    <td>
                                                        <span id="ctl00_ContentHolder_UCOrderEdit_OrderShop">Bikez</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="170">IP
                                            </td>
                                                    <td>
                                                        <span id="ctl00_ContentHolder_UCOrderEdit_OrderIp">81.95.255.42</span>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td width="170">Step
                                            </td>
                                                    <td>
                                                        <span id="ctl00_ContentHolder_UCOrderEdit_OrderStep">Not registered</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="170">Exported
                                            </td>
                                                    <td>
                                                        <span id="ctl00_ContentHolder_UCOrderEdit_OrderIsExported">False</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="170">Order context name
                                            </td>
                                                    <td>
                                                        <span id="ctl00_ContentHolder_UCOrderEdit_OrderContextName">none</span>
                                                    </td>
                                                </tr>

                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
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
                    <dwc:GroupBox runat="server" Title="Shipping details" IsCollapsed="false" DoTranslation="false">
                        <div class="row">
                            <div class="order-detail-label section-6">Name</div>
                            <div class="order-detail-value section-6">Nicolai Høeg</div>
                        </div>
                        <div class="row">
                            <div class="order-detail-label section-6">Att.</div>
                            <div class="order-detail-value section-6">Dynamicweb Software</div>
                        </div>
                        <div class="row">
                            <div class="order-detail-label section-6">Address</div>
                            <div class="order-detail-value section-6">Bjørnholms Allé 30</div>
                        </div>
                        <div class="row">
                            <div class="order-detail-label section-6">Postal code & City</div>
                            <div class="order-detail-value section-6">DK-8260 Viby J</div>
                        </div>
                        <div class="row">
                            <div class="order-detail-label section-6">Country</div>
                            <div class="order-detail-value section-6"><span class="flag-icon flag-icon-dk"></span>&nbsp;Denmark</div>
                        </div>
                        <div class="row">
                            <div class="order-detail-label section-6">Phone</div>
                            <div class="order-detail-value section-6">+45 88 88 88 88</div>
                        </div>
                        <div class="row">
                            <div class="order-detail-label section-6">Created by</div>
                            <div class="order-detail-value section-6"><i class="fa fa-user"></i>&nbsp;jea</div>
                        </div>
                    </dwc:GroupBox>
                    <dwc:GroupBox runat="server" Title="Billing details" IsCollapsed="false" DoTranslation="false">
                        <div class="row">
                            <div class="order-detail-label section-6">Name</div>
                            <div class="order-detail-value section-6">Nicolai Høeg</div>
                        </div>
                        <div class="row">
                            <div class="order-detail-label section-6">Address</div>
                            <div class="order-detail-value section-6">Bjørnholms Allé 30</div>
                        </div>
                        <div class="row">
                            <div class="order-detail-label section-6">Postal code & City</div>
                            <div class="order-detail-value section-6">DK-8260 Viby J</div>
                        </div>
                        <div class="row">
                            <div class="order-detail-label section-6">Country</div>
                            <div class="order-detail-value section-6"><span class="flag-icon flag-icon-dk"></span>&nbsp;Denmark</div>
                        </div>
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
