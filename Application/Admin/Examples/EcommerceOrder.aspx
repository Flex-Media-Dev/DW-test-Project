<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="EcommerceOrder.aspx.vb" Inherits="Dynamicweb.Admin.EcommerceOrder" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>
<html>
<head>
    <title>Order page</title>
    <dw:ControlResources runat="server">
    </dw:ControlResources>
    <link href="/Admin/Module/eCom_Catalog/dw7/css/orderEdit.css" rel="stylesheet" type="text/css">

    <!-- CUSTOM CSS FOR THE ORDER PAGE -->
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
            flex: 6;
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
            float: right;
            margin: 6px 20px 6px 6px;
            color: #bdbdbd;
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

        .form-group .campaign-selector {
            width: 120px;
        }

        .activation-label {
            display: block;
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
    </style>
</head>
<body class="screen-container">
    <div class="card area-pink">
        <form runat="server">
            <dw:RibbonBar ID="RibbonBar" runat="server">
                <dw:RibbonBarTab ID="RibbonBarTab1" Name="Order" runat="server">
                    <dw:RibbonBarGroup ID="RibbonBarGroup2" Name="Show" runat="server">
                        <dw:RibbonBarRadioButton ID="RibbonBarButton1" Text="Details" Icon="InfoCircle" Size="Large" runat="server">
                        </dw:RibbonBarRadioButton>
                    </dw:RibbonBarGroup>

                    <%--<dw:RibbonBarGroup ID="RibbonBarGroup6" Name="View" runat="server">
                        <dw:RibbonBarRadioButton runat="server" ID="LogButton" Group="viewMode" Text="Log" Icon="EventNote" Size="Small" />
                        <dw:RibbonBarRadioButton runat="server" ID="EditOrderButton" Group="viewMode" Text="Edit" Icon="Pencil" Size="Small" />           
                    </dw:RibbonBarGroup>--%>

                    <%--<dw:RibbonBarGroup ID="RibbonBarStateGroup" Name="State" runat="server">
                        <dw:RibbonBarPanel ID="RibbonStatePanel" runat="server">
                            <dw:GroupDropDownList ID="OrderStateList" CssClass="std" Style="width: auto; margin-top: 3px;" runat="server" />
                        </dw:RibbonBarPanel>
                    </dw:RibbonBarGroup>--%>

                    <dw:RibbonBarGroup ID="RibbonBarGroupSettings" Name="Information" runat="server">
                        <dw:RibbonBarButton ID="RibbonBarButton7" Text="Track & Trace" Icon="Truck"
                            Size="Small" runat="server" />
                        <dw:RibbonBarButton runat="server" ID="ShowHistory" Text="Show History" Icon="History" Size="Small" />
                    </dw:RibbonBarGroup>

                    <dw:RibbonBarGroup ID="RibbonBarGroupCapture" Name="Capture" runat="server">
                        <dw:RibbonBarButton ID="RibbonBarButton2" Text="Capture" Icon="CreditCard"
                            Size="Large" runat="server">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                        <dw:RibbonBarButton ID="ButtonCreateShippingDocuments" Icon="Truck" Size="Large"
                            Text="Shipping documents" runat="server">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup9" Name="RMA" runat="server">
                        <dw:RibbonBarButton ID="btnRegisterNewRMA" runat="server" Text="Register new RMA" Icon="PlusSquare" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup4" Name="Print" runat="server">
                        <dw:RibbonBarButton ID="ButtonPrint" Icon="Print" Size="Large" Text="Print"
                            runat="server" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroupNavigation" Name="Navigate orders" runat="server">
                        <dw:RibbonBarButton ID="PreviousButton" Text="Previous" Icon="ArrowLeft" Size="Large"
                            runat="server">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="NextButton" Text="Next" Icon="ArrowRight" Size="Large"
                            runat="server">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup5" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="btnHelp" runat="server" Text="Help" Icon="Help" Size="Large" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
                <dw:RibbonBarTab ID="RibbonBarTab3" Name="Recurring" runat="server" Visible="false">
                    <dw:RibbonBarGroup ID="RibbonBarGroup10" Name="Recurring" runat="server">
                        <dw:RibbonBarButton runat="server" ID="PreviousDeliveries" Text="Previous deliveries" Icon="ClockO" Size="Large" />
                        <dw:RibbonBarButton runat="server" ID="FutureDeliveries" Text="Future deliveries" Icon="Timer" Size="Large" />
                        <dw:RibbonBarButton runat="server" ID="CancelRecurringOrder" Text="Cancel recurring" Icon="NotInterested" Size="Large" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroupRecurringOrderLog" Name="Log" runat="server">
                        <dw:RibbonBarButton runat="server" ID="RecurringOrderLog" Text="Log" Icon="InfoCircle" Size="Large" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <div class="card-body">
                <dwc:GroupBox runat="server" ID="primaryProductSettings">
                    <div class="row">
                        <div class="section-8">
                            <h2 class="order-number">#DEMOORDER261</h2>
                        </div>
                        <div class="section-4">
                            <button class="btn edit-button"><i class="fa fa-pencil"></i></button>
                            <span class="order-date">01/09/15 11:36:06</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="section-8">
                            <div class="order_items" id="OrderItemsShow">
                                <div class="editControls" style="display: none; width: 100%;" align="right">
                                    <a href="javascript:void(0);" id="addDiscountButton" onclick="dialog.show('addDiscountDialog');" title="Tilføj rabat">
                                        <i class="fa fa-dollar (alias)"></i></a>
                                    <a href="javascript:void(0);" onclick="dialog.show('EditProductDialog');"><i class="fa fa-archive"></i></a>&nbsp;
                   
                                </div>

                                <div class="list">
                                    <table class="main" cellspacing="0">
                                        <tbody>
                                            <tr style="display: none">
                                                <td class="title">Liste (2)</td>
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
                                                                                    <td>Nummer</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 340px;">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>Navn</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 70px;" align="center">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="center">Antal</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right">Enhedspris</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right">Totalpris</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 15px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right"></td>
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
                                                            <tbody id="OrderLines_body" controlid="ctl00$ContentHolder$UCOrderEdit$OrderLines">
                                                                <tr id="row1" itemid="OL5463" oncontextmenu="return ContextMenu.show(event, 'OrderLineContext', '1','OL5463','MousePointer');" class="listRow withHover">
                                                                    <td style="width: 120px">10137</td>
                                                                    <td style="width: 340px">Nirve Paul Frank Aku Single Speed</td>
                                                                    <td style="width: 70px" align="center">
                                                                        <div>
                                                                            <input class="std" id="OlQuantityOL5463" maxlength="9" style="width: 50px; border-style: none; text-align: center;" name="OlQuantityOL5463" readonly="readonly" value="1" type="text"></div>
                                                                    </td>
                                                                    <td style="width: 90px" align="right">
                                                                        <div><span id="OlNiceUnitPriceOL5463">475,00</span><input class="std" id="OlUnitPriceOL5463" maxlength="18" style="width: 80px; border-style: none; text-align: right; display: none;" name="OlUnitPriceOL5463" readonly="readonly" value="475" type="text"></div>
                                                                    </td>
                                                                    <td style="width: 90px" align="right">€ 475,00</td>
                                                                    <td style="width: 15px" align="right">
                                                                        <div class="editControls" style="display: none;"><a href="javascript:void(0);" title="Remove Product" onclick="deleteOrderline(&quot;0&quot; )"><i class="fa fa-remove color-danger"></i></a></div>
                                                                    </td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr id="row2" itemid="OL5489" oncontextmenu="return ContextMenu.show(event, 'OrderLineContext', '2','OL5489','MousePointer');" class="listRow withHover">
                                                                    <td>&nbsp;</td>
                                                                    <td>10% on everything</td>
                                                                    <td align="center">
                                                                        <div>1</div>
                                                                    </td>
                                                                    <td align="right">
                                                                        <div>-47,50</div>
                                                                    </td>
                                                                    <td align="right">€ -47,50</td>
                                                                    <td align="right">
                                                                        <div class="editControls" style="display: none;"><a href="javascript:void(0);" title="Remove Product" onclick="deleteOrderline(&quot;1&quot; )"><i class="fa fa-remove color-danger"></i></a></div>
                                                                    </td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="display: ">
                                                <td></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <div context_id="ColumnSelector:OrderLines" style="display: none; left: 524px; top: 330px;" id="ColumnSelector:OrderLines" class="contextmenu dropdown-menu no-animation" oncontextmenu="return false;">
                                    <span class="edge"></span>
                                    <span class="container" style="">
                                        <span id="ColumnSelector_More"><a id="hrefColumnSelector_More" style="" ongetstate="" onclick="List.columnsDialog('OrderLines');" onmouseover="ContextMenu.expand(this)" href="#"><span class="item">
                                            <img id="cmImg_ColumnSelector_More" src="/Admin/Images/nothing.gif" class="icon" style="">Mere...</span><img style="display: none"></a>
                                        </span>
                                        <div class="divider" style="" data-for="ColumnSelector_More"></div>
                                        <span id="ColumnSelector_colnum"><a id="hrefColumnSelector_colnum" style="" ongetstate="" onclick="List.changeColumn('ctl00$ContentHolder$UCOrderEdit$OrderLines', 'colnum');" onmouseover="ContextMenu.expand(this)" href="#"><span class="item">
                                            <img id="cmImg_ColumnSelector_colnum" src="/Admin/Images/Ribbon/UI/Contextmenu/BtnSelected.gif" class="checked" _src="/Admin/Images/nothing.gif">Nummer</span><img style="display: none"></a>
                                        </span>
                                        <span id="ColumnSelector_colname"><a id="hrefColumnSelector_colname" style="" ongetstate="" onclick="List.changeColumn('ctl00$ContentHolder$UCOrderEdit$OrderLines', 'colname');" onmouseover="ContextMenu.expand(this)" href="#"><span class="item">
                                            <img id="cmImg_ColumnSelector_colname" src="/Admin/Images/Ribbon/UI/Contextmenu/BtnSelected.gif" class="checked" _src="/Admin/Images/nothing.gif">Navn</span><img style="display: none"></a>
                                        </span>
                                        <span id="ColumnSelector_colqty"><a id="hrefColumnSelector_colqty" style="" ongetstate="" onclick="List.changeColumn('ctl00$ContentHolder$UCOrderEdit$OrderLines', 'colqty');" onmouseover="ContextMenu.expand(this)" href="#"><span class="item">
                                            <img id="cmImg_ColumnSelector_colqty" src="/Admin/Images/Ribbon/UI/Contextmenu/BtnSelected.gif" class="checked" _src="/Admin/Images/nothing.gif">Antal</span><img style="display: none"></a>
                                        </span>
                                        <span id="ColumnSelector_colunit"><a id="hrefColumnSelector_colunit" style="" ongetstate="" onclick="List.changeColumn('ctl00$ContentHolder$UCOrderEdit$OrderLines', 'colunit');" onmouseover="ContextMenu.expand(this)" href="#"><span class="item">
                                            <img id="cmImg_ColumnSelector_colunit" src="/Admin/Images/Ribbon/UI/Contextmenu/BtnSelected.gif" class="checked" _src="/Admin/Images/nothing.gif">Enhedspris</span><img style="display: none"></a>
                                        </span>
                                        <span id="ColumnSelector_colamount"><a id="hrefColumnSelector_colamount" style="" ongetstate="" onclick="List.changeColumn('ctl00$ContentHolder$UCOrderEdit$OrderLines', 'colamount');" onmouseover="ContextMenu.expand(this)" href="#"><span class="item">
                                            <img id="cmImg_ColumnSelector_colamount" src="/Admin/Images/Ribbon/UI/Contextmenu/BtnSelected.gif" class="checked" _src="/Admin/Images/nothing.gif">Totalpris</span><img style="display: none"></a>
                                        </span>
                                        <span id="ColumnSelector_colremove"><a id="hrefColumnSelector_colremove" style="" ongetstate="" onclick="List.changeColumn('ctl00$ContentHolder$UCOrderEdit$OrderLines', 'colremove');" onmouseover="ContextMenu.expand(this)" href="#"><span class="item">
                                            <img id="cmImg_ColumnSelector_colremove" src="/Admin/Images/Ribbon/UI/Contextmenu/BtnSelected.gif" class="checked" _src="/Admin/Images/nothing.gif"></span><img style="display: none"></a>
                                        </span>
                                    </span><span class="edge"></span>
                                </div>
                                <div class="sidebox dialog-md" id="columnSelectorDialog_OrderLines" onmousedown="dialog.floatTop('columnSelectorDialog_OrderLines');">
                                    <div class="boxhead" id="H_columnSelectorDialog_OrderLines" onmousedown="dialog.floatTop('columnSelectorDialog_OrderLines');">
                                        <table cellpadding="0" cellspacing="0">
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <h2><span id="T_columnSelectorDialog_OrderLines">Vælg detaljer</span></h2>
                                                    </td>
                                                    <td class="close">
                                                        <i class="fa fa-times-circle color-danger" onclick="dialog.hide('columnSelectorDialog_OrderLines');" alt=""></i>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="bodywrapper">
                                        <div class="boxbody " id="B_columnSelectorDialog_OrderLines">
                                            <div class="list.dialog.content">
                                                <input name="dialog_OrderLines_data" id="dialog_OrderLines_data" type="hidden"><div class="list-dialog-top">
                                                    Angiv de detaljer som du vil vise i listen

                                                </div>
                                                <div class="list-dialog-title">
                                                    Detaljer

                                                </div>
                                                <div id="dialog_OrderLines_container" class="list-dialog-columns">
                                                    <div id="dialog_OrderLines_row_colnum" onclick="List.dialogSelectColumn('OrderLines', 'colnum');">
                                                        <input id="dialog_OrderLines_item_colnum" checked="checked" name="dialog_OrderLines_item_colnum" customdata="colnum" class="checkbox" type="checkbox"><label for="dialog_OrderLines_item_colnum"></label><span id="dialog_OrderLines_name_colnum">Nummer</span></div>
                                                    <div id="dialog_OrderLines_row_colname" onclick="List.dialogSelectColumn('OrderLines', 'colname');">
                                                        <input id="dialog_OrderLines_item_colname" checked="checked" name="dialog_OrderLines_item_colname" customdata="colname" class="checkbox" type="checkbox"><label for="dialog_OrderLines_item_colname"></label><span id="dialog_OrderLines_name_colname">Navn</span></div>
                                                    <div id="dialog_OrderLines_row_colqty" onclick="List.dialogSelectColumn('OrderLines', 'colqty');">
                                                        <input id="dialog_OrderLines_item_colqty" checked="checked" name="dialog_OrderLines_item_colqty" customdata="colqty" class="checkbox" type="checkbox"><label for="dialog_OrderLines_item_colqty"></label><span id="dialog_OrderLines_name_colqty">Antal</span></div>
                                                    <div id="dialog_OrderLines_row_colunit" onclick="List.dialogSelectColumn('OrderLines', 'colunit');">
                                                        <input id="dialog_OrderLines_item_colunit" checked="checked" name="dialog_OrderLines_item_colunit" customdata="colunit" class="checkbox" type="checkbox"><label for="dialog_OrderLines_item_colunit"></label><span id="dialog_OrderLines_name_colunit">Enhedspris</span></div>
                                                    <div id="dialog_OrderLines_row_colamount" onclick="List.dialogSelectColumn('OrderLines', 'colamount');">
                                                        <input id="dialog_OrderLines_item_colamount" checked="checked" name="dialog_OrderLines_item_colamount" customdata="colamount" class="checkbox" type="checkbox"><label for="dialog_OrderLines_item_colamount"></label><span id="dialog_OrderLines_name_colamount">Totalpris</span></div>
                                                    <div id="dialog_OrderLines_row_colremove" onclick="List.dialogSelectColumn('OrderLines', 'colremove');">
                                                        <input id="dialog_OrderLines_item_colremove" checked="checked" name="dialog_OrderLines_item_colremove" customdata="colremove" class="checkbox" type="checkbox"><label for="dialog_OrderLines_item_colremove"></label><span id="dialog_OrderLines_name_colremove"></span></div>
                                                </div>
                                                <div class="list-dialog-buttons">
                                                    <button class="btn btn-primary" type="button" onclick="List.dialogUpClick();;return false;">Flyt op</button>
                                                    <button class="btn btn-primary" type="button" onclick="List.dialogDownClick();;return false;">Flyt ned</button>
                                                    <button class="btn btn-primary" type="button" onclick="List.dialogShowClick();;return false;">Vis</button>
                                                    <button class="btn btn-primary" type="button" onclick="List.dialogHideClick();;return false;">Skjul</button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="cmd-pane" style="text-align: right;">
                                            <button type="button" class="dialog-button-ok btn btn-clean" onclick="List.dialogUpdateColumns('ctl00$ContentHolder$UCOrderEdit$OrderLines', 'OrderLines');return false;">OK</button>
                                            <button type="button" class="dialog-button-cancel btn btn-clean" onclick="List.cancelColumnSelectorDialog('OrderLines');return false;">Annuller</button>
                                        </div>
                                    </div>
                                </div>

                                <div class="list">
                                    <table class="main" cellspacing="0">
                                        <tbody>
                                            <tr style="display: none">
                                                <td class="title">Liste (1)</td>
                                            </tr>
                                            <tr>
                                                <td class="container">
                                                    <div id="ListTableContainer" oncontextmenu="return List.showContextMenu(event, '', 'OrderSumSubTotal');">
                                                        <table id="ListTable" border="0" cellspacing="0">
                                                            <thead style="display: none">
                                                                <tr class="header">
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 120px;">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>Nummer</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 340px;">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>Navn</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 70px;" align="center">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="center">Antal</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right">Enhedspris</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right">Totalpris</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 15px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right"></td>
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
                                                            <tbody id="OrderSumSubTotal_body" controlid="ctl00$ContentHolder$UCOrderEdit$OrderSumSubTotal">
                                                                <tr class="listRow">
                                                                    <td style="width: 120px">&nbsp;</td>
                                                                    <td style="width: 340px">Mellemsum</td>
                                                                    <td style="width: 70px" align="center">&nbsp;</td>
                                                                    <td style="width: 90px" align="right">&nbsp;</td>
                                                                    <td style="width: 90px" align="right">€ 427,50</td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="display: none">
                                                <td></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="list">
                                    <table class="main" cellspacing="0">
                                        <tbody>
                                            <tr style="display: none">
                                                <td class="title">Liste (2)</td>
                                            </tr>
                                            <tr>
                                                <td class="container">
                                                    <div id="ListTableContainer" oncontextmenu="return List.showContextMenu(event, '', 'OrderSumExtra');">
                                                        <table id="ListTable" border="0" cellspacing="0">
                                                            <thead style="display: none">
                                                                <tr class="header">
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 120px;">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>Nummer</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 340px;">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>Navn</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 70px;" align="center">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="center">Antal</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right">Enhedspris</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right">Totalpris</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 15px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right"></td>
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
                                                            <tbody id="OrderSumExtra_body" controlid="ctl00$ContentHolder$UCOrderEdit$OrderSumExtra">
                                                                <tr class="listRow">
                                                                    <td style="width: 120px">&nbsp;</td>
                                                                    <td style="width: 340px"><i class="fa fa-money"></i>&nbsp;Betaling:&nbsp;<span class="disableText">Invoice</span></td>
                                                                    <td style="width: 70px" align="center">&nbsp;</td>
                                                                    <td style="width: 90px" align="right">&nbsp;</td>
                                                                    <td style="width: 90px" align="right">€ 0,00</td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr class="listRow">
                                                                    <td>&nbsp;</td>
                                                                    <td><i class="fa fa-truck"></i>&nbsp;Forsendelse:&nbsp;<span class="disableText">Danish Post Office</span></td>
                                                                    <td align="center">&nbsp;</td>
                                                                    <td align="right">&nbsp;</td>
                                                                    <td align="right">€ 10,00</td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="display: none">
                                                <td></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="list">
                                    <table class="main" cellspacing="0">
                                        <tbody>
                                            <tr style="display: none">
                                                <td class="title">Liste (1)</td>
                                            </tr>
                                            <tr>
                                                <td class="container">
                                                    <div id="ListTableContainer" oncontextmenu="return List.showContextMenu(event, '', 'OrderSumTotal');">
                                                        <table id="ListTable" border="0" cellspacing="0">
                                                            <thead style="display: none">
                                                                <tr class="header">
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 120px;">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>Nummer</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 340px;">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>Navn</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 70px;" align="center">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="center">Antal</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right">Enhedspris</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right">Totalpris</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 15px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right"></td>
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
                                                            <tbody id="OrderSumTotal_body" controlid="ctl00$ContentHolder$UCOrderEdit$OrderSumTotal">
                                                                <tr class="listRow">
                                                                    <td style="width: 120px">&nbsp;</td>
                                                                    <td style="width: 340px">Total</td>
                                                                    <td style="width: 70px" align="center">&nbsp;</td>
                                                                    <td style="width: 90px" align="right"><span class="disableText">Moms € 85,50</span></td>
                                                                    <td style="width: 90px" align="right">€ 437,50</td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="display: none">
                                                <td></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="list">
                                    <table class="main" cellspacing="0">
                                        <tbody>
                                            <tr style="display: none">
                                                <td class="title">Liste (3)</td>
                                            </tr>
                                            <tr>
                                                <td class="container">
                                                    <div id="ListTableContainer" oncontextmenu="return List.showContextMenu(event, '', 'OrderSumVatTax');">
                                                        <table id="ListTable" border="0" cellspacing="0">
                                                            <thead style="display: none">
                                                                <tr class="header">
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 120px;">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>Nummer</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 340px;">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>Navn</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 70px;" align="center">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="center">Antal</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right">Enhedspris</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 90px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right">Totalpris</td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td class="columnCell" style="white-space: nowrap; min-width: 15px;" align="right">
                                                                        <table class="columnTable">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="right"></td>
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
                                                            <tbody id="OrderSumVatTax_body" controlid="ctl00$ContentHolder$UCOrderEdit$OrderSumVatTax">
                                                                <tr class="listRow">
                                                                    <td style="width: 120px">&nbsp;</td>
                                                                    <td style="width: 340px">Samlet købspris eksklusiv skatter og afgifter</td>
                                                                    <td style="width: 70px" align="center">&nbsp;</td>
                                                                    <td style="width: 90px" align="right">&nbsp;</td>
                                                                    <td style="width: 90px" align="right">€ 437,50</td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr class="listRow">
                                                                    <td>&nbsp;</td>
                                                                    <td>Samlet købspris eksklusiv moms og afgifter</td>
                                                                    <td align="center">&nbsp;</td>
                                                                    <td align="right">&nbsp;</td>
                                                                    <td align="right">€ 352,00</td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr class="listRow">
                                                                    <td>&nbsp;</td>
                                                                    <td>Samlet købspris eksklusiv moms</td>
                                                                    <td align="center">&nbsp;</td>
                                                                    <td align="right">&nbsp;</td>
                                                                    <td align="right">€ 342,00</td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="display: none">
                                                <td></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="section-4">
                            <div class="order-details-box">
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
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Comments" IsCollapsed="false" DoTranslation="false">
                    <span>I would like the bike to be colored green...</span>
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Additional information" IsCollapsed="true" DoTranslation="false">
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Order data" IsCollapsed="true" DoTranslation="false">
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
        </form>
    </div>
    <div class="card-footer">
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
