<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UCOrderEdit.ascx.vb" Inherits="Dynamicweb.Admin.eComBackend.UCOrderEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register Assembly="Dynamicweb" Namespace="Dynamicweb.Extensibility" TagPrefix="de" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<dw:ControlResources runat="server" IncludeUIStylesheet="true" MergeOutput="True">
    <Items>
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/orderEdit.js" />
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/orderEdit.css" />
        <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
    </Items>
</dw:ControlResources>

<!-- CUSTOM CSS FOR THE ORDER PAGE -->
<style>
    .row {
        display: flex;
        margin-left: -8px;
        margin-right: -8px;
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
        margin: 0px;
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

    .column-product-number {
        font-weight: bold;
        color: #9E9E9E;
        width: 120px;
        word-break: break-all;
        white-space: normal;
        line-height: normal;
        padding: 5px 0;
    }

    fieldset fieldset {
        border: 0;
    }

    .list .container tbody[id="OrderLogList_body"] > tr.listRow > td, .list table.main_stretcher tr.listRow > td {
        white-space: normal;
        line-height: 1.42857143;
        vertical-align: top;
        padding-bottom: 5px;
    }

    .list .container #OrderLines_body > tr.listRow input.std[readonly=readonly] {
        padding: initial;
    }
</style>

<input type="hidden" id="Cancel" name="Cancel" />
<input type="hidden" id="showEdit" name="showEdit" />
<input type="hidden" id="deleteOrderlineId" name="deleteOrderlineId" />
<input type="hidden" id="deletePartItemId" name="deletePartItemId" />
<input type="hidden" id="CurrencySymbol" runat="server" />
<input type="hidden" id="saveOrder" name="saveOrder" />
<input type="hidden" id="OrderType" name="OrderType" value="<%=OrderType%>" />
<input type="hidden" id="IsQuote" name="IsQuote" value="<%=IsQuote%>" />
<input type="hidden" id="IsLedgerEntries" name="IsLedgerEntries" value="<%=IsLedgerEntries%>" />
<input type="hidden" id="IsRecurringOrderTemplate" name="IsRecurringOrderTemplate" value="<%=IsRecurringOrderTemplate%>" />
<input type="hidden" id="IsCarts" name="IsCarts" value="<%=IsCarts%>" />
<div style="min-width: 1000px; overflow: hidden;">
    <span id="ProductWasDeletedAlert" style="display: none;"><%=Translate.JsTranslate("Product was deleted.")%></span>

    <div onclick="CloseAllMenu();" id="CloseRightMenu" style="left: 0px; width: 0px; position: absolute; top: 0px; height: 0px;">
    </div>
    <dw:RibbonBar ID="RibbonBar" runat="server">
        <dw:RibbonBarTab ID="RibbonBarTab1" Name="Order" runat="server">
            <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                <dw:RibbonBarButton ID="btnSaveOrder" Text="Save" Icon="Save" Size="Small" runat="server" ShowWait="true"
                    EnableServerClick="true" OnClientClick="$('saveOrder').value='true'" OnClick="Ribbon_Save">
                </dw:RibbonBarButton>
                <dw:RibbonBarButton ID="btnSaveAndCloseOrder" Text="Save and close" Icon="Save"
                    Size="Small" runat="server" ShowWait="true" EnableServerClick="true" OnClientClick="$('saveOrder').value='true'" OnClick="Ribbon_SaveAndClose">
                </dw:RibbonBarButton>
                <dw:RibbonBarButton ID="btnResetSortOrder" Text="Close" Icon="Close" Size="Small"
                    runat="server" EnableServerClick="true" OnClick="Ribbon_Close">
                </dw:RibbonBarButton>
                <dw:RibbonBarButton ID="ButtonCreateShippingDocuments" Icon="Truck" Size="Small"
                    Text="Create shipping documents" OnClientClick="createShippingDocuments();" runat="server">
                </dw:RibbonBarButton>
                <dw:RibbonBarButton runat="server" ID="ShowHistory" Icon="History" Size="Small"
                    Text="Show History" OnClientClick="showHistory();" />
                <dw:RibbonBarButton ID="btnTrackAndTrace" Text="Track & Trace" Icon="Truck"
                    Size="Small" runat="server" OnClientClick="openTNTDialog('TrackAndTraceDialog', 'ctl00_ContentHolder_UCOrderEdit');" />
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup ID="RibbonBarGroup6" Name="Show" runat="server">
                <dw:RibbonBarRadioButton ID="DetailsButton" Group="viewMode" Checked="true" Text="Details" Icon="InfoCircle"
                    Size="small" runat="server" OnClientClick="changeViewToDetails();">
                </dw:RibbonBarRadioButton>
                <dw:RibbonBarRadioButton runat="server" ID="LogButton" Group="viewMode" Text="Log" Icon="EventNote" Size="Small" OnClientClick="changeView(3);" />
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup ID="RibbonBarGroupNavigation" Name="Navigate orders" runat="server">
                <dw:RibbonBarButton ID="PreviousButton" Text="Previous" Icon="ArrowLeft" Size="Large"
                    runat="server">
                </dw:RibbonBarButton>
                <dw:RibbonBarButton ID="NextButton" Text="Next" Icon="ArrowRight" Size="Large"
                    runat="server">
                </dw:RibbonBarButton>
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup ID="RibbonBarStateGroup" Name="State" runat="server">
                <dw:RibbonBarPanel ID="RibbonStatePanel" runat="server">
                    <dw:GroupDropDownList ID="OrderStateList" CssClass="NewUIinput" Style="width: auto; margin-top: 3px;" runat="server" />
                </dw:RibbonBarPanel>
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup ID="RibbonBarGroupCapture" Name="Capture" runat="server">
                <dw:RibbonBarButton ID="CaptureButton" Text="Capture" Icon="CreditCard"
                    Size="Large" runat="server" OnClientClick="openCaptureDialog();">
                </dw:RibbonBarButton>
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup ID="RibbonBarGroupRefund" Name="Refund" runat="server" Visible="false">
                <dw:RibbonBarButton ID="RefundButton" Text="Refund" Icon="AssignmentReturn"
                    Size="Large" runat="server" OnClientClick="openRefundDialog();">
                </dw:RibbonBarButton>
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup ID="RibbonBarGroupCancel" Name="Cancel" runat="server">
                <dw:RibbonBarButton ID="CancelButton" Text="Cancel" Icon="Ban" EnableServerClick="true"
                    Size="Large" runat="server" OnClientClick="if(!confirm(_cancelQuestion)) {return false;}" OnClick="Ribbon_Cancel">
                </dw:RibbonBarButton>
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup ID="RibbonBarGroupDelete" Name="Delete" runat="server">
                <dw:RibbonBarButton ID="DeleteButton" Text="Delete" Icon="Delete" EnableServerClick="true"
                    Size="Large" runat="server" OnClientClick="if(!confirm(_deleteQuestion)) {return false;}" OnClick="Ribbon_Delete">
                </dw:RibbonBarButton>
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup ID="RibbonBarGroup4" Name="Print" runat="server">
                <dw:RibbonBarButton ID="ButtonPrint" Icon="Print" Size="Large" Text="Print" OnClientClick="printOrder();"
                    runat="server" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="RibbonbarGroup5" runat="server" Name="Help">
                <dw:RibbonBarButton ID="btnHelp" runat="server" Text="Help" Icon="Help" Size="Large"
                    OnClientClick="help();" />
            </dw:RibbonBarGroup>
        </dw:RibbonBarTab>
        <dw:RibbonBarTab ID="RibbonBarTab2" Name="RMA" runat="server">
            <dw:RibbonBarGroup ID="RibbonBarGroup9" Name="RMA" runat="server">
                <dw:RibbonBarButton ID="btnRegisterNewRMA" runat="server" Text="Register new RMA" Icon="PlusSquare" OnClientClick="registerNewRMA();" />
                <dw:RibbonBarButton ID="btnExistingRMAs" runat="server" Text="View existing RMAs" Icon="Search" OnClientClick="dialog.show('ExistingRMAsDialog');" />
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
</div>
<dw:Infobar ID="errorBar" runat="server" Visible="false" TranslateMessage="False">
</dw:Infobar>
<dw:Infobar ID="GiftCardTransactionFailedInfo" runat="server" Visible="false" TranslateMessage="True" Type="Error" Message="Giftcard transaction failed"></dw:Infobar>
<dw:Dialog
    ID="ExistingRMAsDialog"
    runat="server"
    Title="Existing RMAs"
    ShowCancelButton="false"
    ShowClose="true"
    ShowOkButton="true"
    OkAction="dialog.hide('ExistingRMAsDialog');"
    HidePadding="false"
    Size="Medium">

    <dw:List runat="server" ID="ExistingRMAsList" ShowTitle="false" ShowPaging="false"></dw:List>
</dw:Dialog>

<dw:Dialog ID="ShowHistoryDialog" runat="server" Title="Versioner" HidePadding="true" Width="600">
    <iframe id="ShowHistoryDialogFrame" frameborder="0"></iframe>
</dw:Dialog>

<dw:Dialog ID="ShowCompareDialog" runat="server" Title="Compare" HidePadding="true" Width="800">
    <iframe id="ShowCompareDialogFrame" frameborder="0"></iframe>
</dw:Dialog>

<dw:Dialog ID="CaptureDialog" runat="server" Title="Capture order" HidePadding="true" ShowOkButton="false" ShowCancelButton="true" CancelText="Close" ShowClose="true">
    <iframe id="CaptureDialogFrame" frameborder="0"></iframe>
</dw:Dialog>

<dw:Dialog ID="RefundDialog" runat="server" Title="Refund order" HidePadding="true" ShowOkButton="false" ShowCancelButton="true" CancelText="Close" ShowClose="true">
    <iframe id="RefundDialogFrame" frameborder="0"></iframe>
</dw:Dialog>

<dw:Dialog ID="TrackAndTraceDialog" runat="server" Title="Delivery" ShowOkButton="true"
    ShowClose="true" OkAction="updateTNTDialog('TrackAndTraceDialog','ctl00_ContentHolder_UCOrderEdit');" Width="450"
    ShowCancelButton="true" CancelAction="cancelOrderDialog('TrackAndTraceDialog');">
    <dwc:GroupBox ID="GroupBox1" runat="server" DoTranslation="true">
        <dwc:SelectPicker Label="Track & Trace" ID="otntSelectBox" runat="server" Info="" />
    </dwc:GroupBox>
    <dwc:GroupBox ID="ParametersGroupBox" runat="server" DoTranslation="true" Title="Parameters">
        <div id="otntLoadingDiv">
            <img src="/Admin/Module/eCom_Catalog/images/ajaxloading_trans.gif" alt="" /><br />
            <br />
        </div>
        <div id="otntParametersDiv"></div>
        <script type="text/template" id="ParameterTplBlock">
            <dwc:InputText runat="server" ID="ParameterId" Name="<ParameterName>" DoTranslate="false" Label="<ParameterLabel>" Value="<ParameterValue>" Info="<ParameterDescription>" />
        </script>
    </dwc:GroupBox>
</dw:Dialog>

<dw:Dialog ID="TNTUrlSchemeDialog" runat="server" Title="URL Scheme"
    ShowClose="true" Width="400" ShowOkButton="true">
    <div id="otntURLDiv"></div>
</dw:Dialog>

<dw:Dialog ID="addDiscountDialog" runat="server" Title="Add discount" ShowCancelButton="true" ShowOkButton="true" OkAction="dialog.hide('addDiscountDialog');AddProductOrDiscount();">
    <dwc:GroupBox runat="server" Title="Discount">
        <dwc:InputText Label="Discount description" ID="DiscountDescriptionTextField" runat="server" />
        <dwc:InputNumber Label="Discount amount" ID="DiscountAmountTextField" runat="server" />
    </dwc:GroupBox>
</dw:Dialog>

<dw:Dialog ID="EditProductDialog" runat="server" Title="Add product / discount" ShowCancelButton="true" ShowOkButton="true"
    CancelAction="dialog.hide('EditProductDialog');" OkAction="AddProductOrDiscount();">

    <dw:GroupBox ID="GroupBox4" runat="server" DoTranslation="true" Title="Product">
        <input type="hidden" id="ProductID" name="ProductId" />
        <input type="hidden" id="ID_ProductID" name="ID_ProductID" />
        <input type="hidden" id="VariantID_ProductID" name="VariantId_ProductID" />
        <dwc:InputText Label="Product" ID="Name_ProductID" runat="server" Icon="Plus" IconColor="Success" IconAction="window.open('/Admin/Module/eCom_Catalog/dw7/Edit/EcomGroupTree.aspx?CMD=ShowProd&AddCaller=1&caller=opener.document.forms.Form1.DW_REPLACE_ProductID&invokeOnChangeOnID=true', '', 'displayWindow,width=460,height=400,scrollbars=no');" IconTitle="Add product" />
    </dw:GroupBox>

    <dw:GroupBox ID="GroupBox2" runat="server" DoTranslation="true" Title="Discount">
        <table>
            <tr>
                <td width="170">
                    <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Orderline text" />
                </td>
                <td>
                    <input type="text" id="productDiscountDescriptionTextField" name="productDiscountDescriptionTextField" class="NewUIinput" />
                </td>
            </tr>
            <tr>
                <td width="170">
                    <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Amount" />
                </td>
                <td>
                    <input type="text" id="productDiscountAmountTextField" name="productDiscountAmountTextField" class="NewUIinput" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>

    <input type="hidden" id="DiscountParentOrderlineId" name="DiscountParentOrderlineId" />
    <input type="hidden" id="DiscountOrderLineId" name="DiscountOrderLineId" />

</dw:Dialog>

<dw:Dialog ID="VisitorDetailsDialog" runat="server" Size="Large" Title="Visitor details" HidePadding="true" ShowOkButton="false" ShowCancelButton="true" ShowClose="true">
    <iframe id="VisitorDetailsDialogFrame" frameborder="0"></iframe>
</dw:Dialog>

<dw:Dialog ID="GiftCardTransactionsDialog" runat="server" Title="GiftCard Transactions" HidePadding="true" ShowOkButton="false" ShowCancelButton="true" ShowClose="true">
    <iframe id="GiftCardTransactionsDialogFrame" frameborder="0"></iframe>
</dw:Dialog>

<dw:Dialog ID="FutureDeliveriesDialog" runat="server" Title="Recurring Orders" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true">
    <iframe id="FutureDeliveriesDialogFrame" frameborder="0"></iframe>
</dw:Dialog>

<dw:Dialog ID="RecurringLogDialog" runat="server" Title="Recurring Orders" HidePadding="true" ShowOkButton="false" ShowCancelButton="true" ShowClose="true">
    <iframe id="RecurringLogDialogFrame" frameborder="0"></iframe>
</dw:Dialog>

<dw:Dialog ID="PreviousDeliveriesDialog" runat="server" Title="Previous deliveries" HidePadding="true" ShowOkButton="false" ShowCancelButton="true" ShowClose="true">
    <iframe id="PreviousDeliveriesDialogFrame" frameborder="0"></iframe>
</dw:Dialog>

<input type="hidden" id="AddingProductOrDiscount" name="AddingProductOrDiscount" value="false" />

<asp:Panel runat="server" ID="TransactionWarnings" />

<dw:StretchedContainer ID="ProductEditScroll" Stretch="Fill" Scroll="VerticalOnly"
    Anchor="document" runat="server">
    <div class="card-body">

        <div id="OrderEditTab1" class="tabDiv">
            <dwc:GroupBox runat="server" ID="primaryProductSettings">
                <div class="row">
                    <div class="section-8">
                        <h2 class="order-number">#<asp:Label ID="OrderID" runat="server"></asp:Label></h2>
                        <asp:Label ID="OrderRecurringReference" runat="server" />
                        <span class="order-date">
                            <asp:Label ID="OrderCreated" runat="server"></asp:Label>
                        </span>
                    </div>
                    <div class="section-4">
                        <button class="btn edit-button" runat="server" clientidmode="Static" id="EditOrderButton" type="button" onclick="changeViewToEdit();"><i class="fa fa-pencil"></i></button>
                        <input type="hidden" id="radio_EditOrderButton" value="EditOrderButton" />
                    </div>
                </div>
                <div class="row">
                    <div class="section-8">
                        <div class="order_items" id="OrderItemsShow">
                            <div class="editControls" style="display: none; width: 100%;" align="right">
                                <a href="javascript:void(0);" id="addDiscountButton" onclick="dialog.show('addDiscountDialog');" title="<%=Translate.JsTranslate("Add discount")%>">
                                    <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Dollar) %>"></i></a>
                                <a href="javascript:void(0);" onclick="dialog.show('EditProductDialog');"><i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Archive) %>"></i></a>&nbsp;
                            </div>

                            <dw:List runat="server" OnRowExpand="OnRowExpand" ID="OrderLines" ShowTitle="false" ShowPaging="true" ShowFooter="False" Personalize="true">
                                <Columns>
                                    <dw:ListColumn ID="colnum" runat="server" Name="Number" Width="140" />
                                    <dw:ListColumn ID="colname" runat="server" Name="Name" Width="320" />
                                    <dw:ListColumn ID="colqty" runat="server" Name="Quantity" HeaderAlign="Right" ItemAlign="Right" Width="80" />
                                    <dw:ListColumn ID="coluntis" runat="server" Name="Units" HeaderAlign="Left" ItemAlign="Left" Width="60" />
                                    <dw:ListColumn ID="colStockLocation" runat="server" Name="Stock Location" Width="160" />
                                    <dw:ListColumn ID="colunit" runat="server" Name="Unit price" HeaderAlign="Right" ItemAlign="Right" Width="140" />
                                    <dw:ListColumn ID="colamount" runat="server" Name="Total price" HeaderAlign="Right" ItemAlign="Right" Width="120" />
                                    <dw:ListColumn runat="server" ID="colremove" ClientIDMode="AutoID" HeaderAlign="Right" ItemAlign="Right" Width="15" />
                                </Columns>
                            </dw:List>

                            <dw:ContextMenu ID="OrderLineContext" runat="server">
                                <dw:ContextMenuButton ID="editProductButton" runat="server" Icon="PlusSquare"
                                    Text="Go to product" OnClientClick="showProduct();" />
                                <dw:ContextMenuButton ID="pageButton" runat="server" Icon="OpenInNew"
                                    Text="Vis side" OnClientClick="showPage();" />
                            </dw:ContextMenu>
                        </div>
                    </div>
                    <div class="section-4" id="orderInfoShow">
                        <div class="order-details-box">
                            <dwc:GroupBox runat="server" Title="Shipping details" IsCollapsed="false" DoTranslation="false">
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvFirm" <%= HideEmpty(DelvFirm)%>><%=Translate.Translate("Navn")%></div>
                                    <div class="order-detail-value section-6 DelvFirm" <%= HideEmpty(DelvFirm)%>>
                                        <asp:Label ID="DelvFirm" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvAtt" <%= HideEmpty(DelvAtt)%>><%=Translate.Translate("Att.")%></div>
                                    <div class="order-detail-value section-6 DelvAtt" <%= HideEmpty(DelvAtt)%>>
                                        <asp:Label ID="DelvAtt" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvTitle" <%= HideEmpty(DelvTitle)%>><%=Translate.Translate("Title")%></div>
                                    <div class="order-detail-value section-6 DelvTitle" <%= HideEmpty(DelvTitle)%>>
                                        <asp:Label ID="DelvTitle" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvFirstName" <%= HideEmpty(DelvFirstName)%>><%=Translate.Translate("First name")%></div>
                                    <div class="order-detail-value section-6 DelvFirstName" <%= HideEmpty(DelvFirstName)%>>
                                        <asp:Label ID="DelvFirstName" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvMiddleName" <%= HideEmpty(DelvMiddleName)%>><%=Translate.Translate("Middle name")%></div>
                                    <div class="order-detail-value section-6 DelvMiddleName" <%= HideEmpty(DelvMiddleName)%>>
                                        <asp:Label ID="DelvMiddleName" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvSurnameName" <%= HideEmpty(DelvSurnameName)%>><%=Translate.Translate("Surname")%></div>
                                    <div class="order-detail-value section-6 DelvSurnameName" <%= HideEmpty(DelvSurnameName)%>>
                                        <asp:Label ID="DelvSurnameName" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvAdr1" <%= HideEmpty(DelvAdr1)%>><%=Translate.Translate("Adresse")%></div>
                                    <div class="order-detail-value section-6 DelvAdr1" <%= HideEmpty(DelvAdr1)%>>
                                        <asp:Label ID="DelvAdr1" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvAdr2" <%= HideEmpty(DelvAdr2)%>><%=Translate.Translate("Sec. adresse")%></div>
                                    <div class="order-detail-value section-6 DelvAdr2" <%= HideEmpty(DelvAdr2)%>>
                                        <asp:Label ID="DelvAdr2" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvHouseNumber" <%= HideEmpty(DelvHouseNumber)%>><%=Translate.Translate("House number")%></div>
                                    <div class="order-detail-value section-6 DelvHouseNumber" <%= HideEmpty(DelvHouseNumber)%>>
                                        <asp:Label ID="DelvHouseNumber" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvZip" <%= HideEmpty(DelvZip, DelvCity)%>><%=Translate.Translate("Post nr.")%> & <%=Translate.Translate("By")%></div>
                                    <div class="order-detail-value section-6 DelvZip" <%= HideEmpty(DelvZip, DelvCity)%>>
                                        <asp:Label ID="DelvZip" runat="server"></asp:Label>&nbsp;<asp:Label ID="DelvCity" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvCountry" <%= HideEmpty(DelvCountry)%>><%=Translate.Translate("Land")%></div>
                                    <div class="order-detail-value section-6 DelvCountry" <%= HideEmpty(DelvCountry)%>>
                                        <asp:Label ID="DelvCountry" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvRegion" <%= HideEmpty(DelvRegion)%>><%= Translate.Translate("Region")%></div>
                                    <div class="order-detail-value section-6 DelvRegion" <%= HideEmpty(DelvRegion)%>>
                                        <asp:Label ID="DelvRegion" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvPhone" <%= HideEmpty(DelvPhone)%>><%=Translate.Translate("Telefon")%></div>
                                    <div class="order-detail-value section-6 DelvPhone" <%= HideEmpty(DelvPhone)%>>
                                        <asp:Label ID="DelvPhone" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvFax" <%= HideEmpty(DelvFax)%>><%=Translate.Translate("Fax")%></div>
                                    <div class="order-detail-value section-6 DelvFax" <%= HideEmpty(DelvFax)%>>
                                        <asp:Label ID="DelvFax" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvCell" <%= HideEmpty(DelvCell)%>><%=Translate.Translate("Mobil")%></div>
                                    <div class="order-detail-value section-6 DelvCell" <%= HideEmpty(DelvCell)%>>
                                        <asp:Label ID="DelvCell" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 DelvEmail" <%= HideEmpty(DelvEmail)%>><%=Translate.Translate("Email")%></div>
                                    <div class="order-detail-value section-6 DelvEmail" <%= HideEmpty(DelvEmail)%>>
                                        <asp:Label ID="DelvEmail" runat="server"></asp:Label>
                                    </div>
                                </div>
                            </dwc:GroupBox>
                            <dwc:GroupBox runat="server" Title="Billing details" IsCollapsed="false" DoTranslation="false">
                                <div class="row">
                                    <div class="order-detail-label section-6 CustNum" <%= HideEmpty(CustNum) %>><%=Translate.Translate("Kunde nr.")%></div>
                                    <div class="order-detail-value section-6 CustNum" <%= HideEmpty(CustNum) %>>
                                        <asp:Label ID="CustNum" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustFirm" <%= HideEmpty(CustFirm) %>><%=Translate.Translate("Navn")%></div>
                                    <div class="order-detail-value section-6 CustFirm" <%= HideEmpty(CustFirm)%>>
                                        <asp:Label ID="CustFirm" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustAtt" <%= HideEmpty(CustAtt)%>><%=Translate.Translate("Att.")%></div>
                                    <div class="order-detail-value section-6 CustAtt" <%= HideEmpty(CustAtt)%>>
                                        <asp:Label ID="CustAtt" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustTitle" <%= HideEmpty(CustTitle)%>><%=Translate.Translate("Title")%></div>
                                    <div class="order-detail-value section-6 CustTitle" <%= HideEmpty(CustTitle)%>>
                                        <asp:Label ID="CustTitle" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustFirstName" <%= HideEmpty(CustFirstName)%>><%=Translate.Translate("First name")%></div>
                                    <div class="order-detail-value section-6 CustFirstName" <%= HideEmpty(CustFirstName)%>>
                                        <asp:Label ID="CustFirstName" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustMiddleName" <%= HideEmpty(CustMiddleName)%>><%=Translate.Translate("Middle name")%></div>
                                    <div class="order-detail-value section-6 CustMiddleName" <%= HideEmpty(CustMiddleName)%>>
                                        <asp:Label ID="CustMiddleName" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustSurnameName" <%= HideEmpty(CustSurnameName)%>><%=Translate.Translate("Surname")%></div>
                                    <div class="order-detail-value section-6 CustSurnameName" <%= HideEmpty(CustSurnameName)%>>
                                        <asp:Label ID="CustSurnameName" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">

                                    <div class="order-detail-label section-6 CustAdr1" <%= HideEmpty(CustAdr1)%>><%=Translate.Translate("Adresse")%></div>
                                    <div class="order-detail-value section-6 CustAdr1" <%= HideEmpty(CustAdr1)%>>
                                        <asp:Label ID="CustAdr1" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustAdr2" <%= HideEmpty(CustAdr2)%>><%=Translate.Translate("Sec. adresse")%></div>
                                    <div class="order-detail-value section-6 CustAdr2" <%= HideEmpty(CustAdr2)%>>
                                        <asp:Label ID="CustAdr2" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustHouseNumber" <%= HideEmpty(CustHouseNumber)%>><%=Translate.Translate("House number")%></div>
                                    <div class="order-detail-value section-6 CustHouseNumber" <%= HideEmpty(CustHouseNumber)%>>
                                        <asp:Label ID="CustHouseNumber" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustZip" <%= HideEmpty(CustZip, CustCity)%>><%=Translate.Translate("Post nr.")%> & <%=Translate.Translate("By")%></div>
                                    <div class="order-detail-value section-6 CustZip" <%= HideEmpty(CustZip, CustCity)%>>
                                        <asp:Label ID="CustZip" runat="server"></asp:Label>&nbsp;<asp:Label ID="CustCity" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustCountry" <%= HideEmpty(CustCountry)%>><%=Translate.Translate("Land")%></div>
                                    <div class="order-detail-value section-6 CustCountry" <%= HideEmpty(CustCountry)%>>
                                        <asp:Label ID="CustCountry" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustRegion" <%= HideEmpty(CustRegion)%>><%= Translate.Translate("Region")%></div>
                                    <div class="order-detail-value section-6 CustRegion" <%= HideEmpty(CustRegion)%>>
                                        <asp:Label ID="CustRegion" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustPhone" <%= HideEmpty(CustPhone)%>><%=Translate.Translate("Telefon")%></div>
                                    <div class="order-detail-value section-6 CustPhone" <%= HideEmpty(CustPhone)%>>
                                        <asp:Label ID="CustPhone" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustFax" <%= HideEmpty(CustFax)%>><%=Translate.Translate("Fax")%></div>
                                    <div class="order-detail-value section-6 CustFax" <%= HideEmpty(CustFax)%>>
                                        <asp:Label ID="CustFax" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustCell" <%= HideEmpty(CustCell)%>><%=Translate.Translate("Mobil")%></div>
                                    <div class="order-detail-value section-6 CustCell" <%= HideEmpty(CustCell)%>>
                                        <asp:Label ID="CustCell" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CusteMail" <%= HideEmpty(CustEmail)%>><%=Translate.Translate("Email")%></div>
                                    <div class="order-detail-value section-6 CusteMail" <%= HideEmpty(CustEmail)%>>
                                        <asp:Label ID="CustEmail" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustRefId" <%= HideEmpty(CustRefID)%>><%=Translate.Translate("Reference nr.")%></div>
                                    <div class="order-detail-value section-6 CustRefId" <%= HideEmpty(CustRefID)%>>
                                        <asp:Label ID="CustRefID" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustEan" <%= HideEmpty(CustEAN)%>><%=Translate.Translate("EAN nr.")%></div>
                                    <div class="order-detail-value section-6 CustEan" <%= HideEmpty(CustEAN)%>>
                                        <asp:Label ID="CustEAN" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="order-detail-label section-6 CustVatReg" <%= HideEmpty(CustVatReg)%>><%=Translate.Translate("CVR nr.")%></div>
                                    <div class="order-detail-value section-6 CustVatReg" <%= HideEmpty(CustVatReg)%>>
                                        <asp:Label ID="CustVatReg" runat="server"></asp:Label>
                                    </div>
                                </div>
                            </dwc:GroupBox>
                        </div>
                    </div>
                </div>
            </dwc:GroupBox>

            <div class="bill_wr" id="orderInfoEdit" style="display: none">
                <dwc:GroupBox runat="server" Title="Shipping details" IsCollapsed="false" DoTranslation="false">
                    <table border="0" cellpadding="2" cellspacing="2" width="100%">
                        <colgroup>
                            <col width="170" />
                            <col />
                        </colgroup>
                        <tr>
                            <td>
                                <%=Translate.Translate("Navn")%>
                            </td>
                            <td>
                                <input type="text" id="DelvFirmEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Navn")%></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Title")%></td>
                            <td>
                                <input type="text" id="DelvPrefixEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Att.")%></td>
                            <td>
                                <input type="text" id="DelvNameEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Title")%></td>
                            <td>
                                <input type="text" id="DelvTitleEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("First name")%></td>
                            <td>
                                <input type="text" id="DelvFirstNameEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Middle name")%></td>
                            <td>
                                <input type="text" id="DelvMiddleNameEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Surname")%></td>
                            <td>
                                <input type="text" id="DelvSurnameEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Initials")%></td>
                            <td>
                                <input type="text" id="DelvInitialsEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("House number")%></td>
                            <td>
                                <input type="text" id="DelvHouseNumberEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Adresse")%></td>
                            <td>
                                <input type="text" id="DelvAdr1Edit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Sec. adresse")%></td>
                            <td>
                                <input type="text" id="DelvAdr2Edit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Post nr.")%> & <%=Translate.Translate("By")%></td>
                            <td>
                                <input type="text" id="DelvZipEdit" class="halfWidth NewUIinput" runat="server" maxlength="50" />&nbsp;<input type="text" class="halfWidth NewUIinput" id="DelvCityEdit" runat="server" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Land")%></td>
                            <td>
                                <input type="text" id="DelvCountryEdit" runat="server" class="NewUIinput editInput" maxlength="50" />
                            </td>
                        </tr>
                        <tr>
                            <td><%= Translate.Translate("Region")%></td>
                            <td>
                                <input type="text" id="DelvRegionEdit" runat="server" class="NewUIinput editInput" maxlength="50" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Telefon")%></td>
                            <td>
                                <input type="text" id="DelvPhoneEdit" runat="server" class="NewUIinput editInput" maxlength="50" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Fax")%></td>
                            <td>
                                <input type="text" id="DelvFaxEdit" runat="server" class="NewUIinput editInput" maxlength="50" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Mobil")%></td>
                            <td>
                                <input type="text" id="DelvCellEdit" runat="server" class="NewUIinput editInput" maxlength="50" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Email")%></td>
                            <td>
                                <input type="text" id="DelvEmailEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" Title="Billing details" IsCollapsed="false" DoTranslation="false">
                    <table border="0" cellpadding="2" cellspacing="2" width="100%">
                        <colgroup>
                            <col width="170" />
                            <col />
                        </colgroup>
                        <tr>
                            <td><%=Translate.Translate("Kunde nr.")%></td>
                            <td>
                                <input type="text" id="CustNumEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Navn")%></td>
                            <td>
                                <input type="text" id="CustFirmEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Title")%></td>
                            <td>
                                <input type="text" id="CustPrefixEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Name")%></td>
                            <td>
                                <input type="text" id="CustNameEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Title")%></td>
                            <td>
                                <input type="text" id="CustTitleEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("First name")%></td>
                            <td>
                                <input type="text" id="CustFirstNameEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Middle name")%></td>
                            <td>
                                <input type="text" id="CustMiddleNameEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Surname")%></td>
                            <td>
                                <input type="text" id="CustSurnameEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Initials")%></td>
                            <td>
                                <input type="text" id="CustInitialsEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("House number")%></td>
                            <td>
                                <input type="text" id="CustHouseNumberEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Adresse")%></td>
                            <td>
                                <input type="text" id="CustAdr1Edit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Sec. adresse")%></td>
                            <td>
                                <input type="text" id="CustAdr2Edit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Post nr.")%> & <%=Translate.Translate("By")%></td>
                            <td>
                                <input type="text" id="CustZipEdit" runat="server" class="halfWidth NewUIinput" maxlength="50" />&nbsp;<input type="text" id="CustCityEdit" runat="server" class="halfWidth NewUIinput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Land")%></td>
                            <td>
                                <input type="text" id="CustCountryEdit" runat="server" class="NewUIinput editInput" maxlength="50" />
                            </td>
                        </tr>
                        <tr>
                            <td><%= Translate.Translate("Region")%></td>
                            <td>
                                <input type="text" id="CustRegionEdit" runat="server" class="NewUIinput editInput" maxlength="50" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Telefon")%></td>
                            <td>
                                <input type="text" id="CustPhoneEdit" runat="server" class="NewUIinput editInput" maxlength="50" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Fax")%></td>
                            <td>
                                <input type="text" id="CustFaxEdit" runat="server" class="NewUIinput editInput" maxlength="50" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Mobil")%></td>
                            <td>
                                <input type="text" id="CustCellEdit" runat="server" class="NewUIinput editInput" maxlength="50" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Email")%></td>
                            <td>
                                <input type="text" id="CustEmailEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Reference nr.")%></td>
                            <td>
                                <input type="text" id="CustRefIDEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("EAN nr.")%></td>
                            <td>
                                <input type="text" id="CustEANEdit" runat="server" class="NewUIinput editInput" maxlength="255" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("CVR nr.")%></td>
                            <td>
                                <input type="text" id="CustVatRegEdit" runat="server" class="NewUIinput editInput" maxlength="50" />
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
            </div>

            <dwc:GroupBox runat="server" Title="Comments" IsCollapsed="false" DoTranslation="false">
                <table border="0" cellpadding="2" cellspacing="2" width="100%">
                    <tr>
                        <td width="170" valign="top">
                            <%=Translate.Translate("Ordre kommentar")%>
                        </td>
                        <td>
                            <asp:TextBox ID="OrderComment" runat="server" CssClass="NewUIinput" TextMode="MultiLine"
                                Columns="120" Rows="6" Style="width: 450px;"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="170" valign="top">
                            <%=Translate.Translate("Kunde kommentar")%>
                        </td>
                        <td>
                            <asp:TextBox ID="OrderCustomerComment" CssClass="NewUIinput" runat="server" TextMode="MultiLine"
                                Columns="120" Rows="6" Style="width: 450px;"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox ID="AdditionalGroupBox" runat="server" Title="Additional information" IsCollapsed="true" DoTranslation="false">
                <div id="OrderFieldsContainer" runat="server">
                    <asp:Literal ID="OrderFieldList" runat="server"></asp:Literal>
                </div>
            </dwc:GroupBox>

            <dwc:GroupBox ID="DataGroupBox" runat="server" Title="Order data" IsCollapsed="true" DoTranslation="false">
                <table border="0" cellpadding="2" cellspacing="2" width="100%">
                    <tr>
                        <td width="170">
                            <%=Translate.Translate("Standard moms")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderVAT" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td width="170">
                            <%=Translate.Translate("Køb i shop")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderShop" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td width="170">
                            <%=Translate.Translate("IP")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderIp" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr id="OrderReferrerTD" runat="server">
                        <td width="170">
                            <%=Translate.Translate("Reference")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderReferrer" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td width="170">
                            <%=Translate.Translate("Step")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderStep" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td width="170">
                            <%=Translate.Translate("Eksporteret")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderIsExported" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td width="170">
                            <%=Translate.Translate("Order context name")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderContextName" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td width="170">
                            <%=Translate.Translate("Voucher")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderVoucherCode" runat="server"></asp:Label>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Valuta" IsCollapsed="true">
                <table border="0" cellpadding="2" cellspacing="2" width="100%">
                    <tr>
                        <td width="170">
                            <%=Translate.Translate("Navn")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderCurrName" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td width="170">
                            <%=Translate.Translate("Faktor")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderCurrFactor" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td width="170">
                            <%=Translate.Translate("Kode")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderCurrCode" runat="server"></asp:Label>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox ID="TransactionGroupBox" runat="server" Title="Transaction" IsCollapsed="true" DoTranslation="false">
                <asp:Literal ID="GatewayStatusOutput" runat="server"></asp:Literal>
                <table border="0" cellpadding="2" cellspacing="2" width="100%">
                    <colgroup>
                        <col width="170" />
                        <col />
                    </colgroup>
                    <tr>
                        <td>
                            <%=Translate.Translate("Transaktions nummer")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderTransNumber" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <%=Translate.Translate("Transaktions værdi")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderTransValue" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <%=Translate.Translate("Transaktions type")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderTransType" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <%=Translate.Translate("Transaktions status")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderTransStatus" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <%=Translate.Translate("Transaktions beløb")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderTransAmount" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td onclick="GetGatewayResult();">
                            <%=Translate.Translate("Transaktions gateway")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderTransGateWay" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <%=Translate.Translate("Transaction card type")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderTransCardType" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <%=Translate.Translate("Transaction card number")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderTransCardNumber" runat="server"></asp:Label>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Miscellaneous" IsCollapsed="false" DoTranslation="false">
                <table border="0" cellpadding="2" cellspacing="2" width="100%">
                    <colgroup>
                        <col width="170" />
                        <col />
                    </colgroup>
                    <tr <%= HideEmpty(OrderIntegrationOrderID)%>>
                        <td>
                            <%=Translate.Translate("Integration Order ID")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderIntegrationOrderID" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr id="PriceCalcDateDiv" runat="server">
                        <td>
                            <%=Translate.Translate("Price calculation date")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderPriceCalculationDate" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr <%=HideEmpty(ShippingDate)%>>
                        <td>
                            <%=Translate.Translate("Shipping date")%>
                        </td>
                        <td>
                            <asp:Label ID="ShippingDate" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr <%=HideEmpty(OrderCompleted)%>>
                        <td>
                            <%=Translate.Translate("Completed")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderCompleted" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr <%=HideEmpty(OrderCreatedUserID)%>>
                        <td>
                            <%=Translate.Translate("Created by user")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderCreatedUserID" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr <%=HideEmpty(OrderSecondaryUserID)%>>
                        <td>
                            <%=ImpersonationType%>
                        </td>
                        <td>
                            <asp:Label ID="OrderSecondaryUserID" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr <%=HideEmpty(ReplacementRmaId)%>>
                        <td>
                            <%=Translate.Translate("Replacement for RMA")%>
                        </td>
                        <td>
                            <asp:Label ID="ReplacementRmaId" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr <%=HideEmpty(OrderRecurring)%>>
                        <td>
                            <%=Translate.Translate("Recurring")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderRecurring" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr <%=HideEmpty(OrderReference)%>>
                        <td>
                            <%=Translate.Translate("Reference")%>
                        </td>
                        <td>
                            <asp:Label ID="OrderReference" runat="server"></asp:Label>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </div>
        <div id="OrderEditTab3" style="display: none">
            <dw:List runat="server" ID="OrderLogList"
                NoItemsMessage="There are no entries. Only cart v2 uses this log system"
                PageSize="100"
                Title="Order log">

                <Columns>
                    <dw:ListColumn ID="OrderLogTimeColumn" runat="server" Name="Time" EnableSorting="true" TranslateName="true" Width="180" DateFormat="ddd',' dd MMM yyyy HH':'mm':'ss" />
                    <dw:ListColumn ID="OrderLogMessageColumn" runat="server" Name="Message" EnableSorting="true" TranslateName="true" />
                </Columns>
            </dw:List>
        </div>

    </div>
</dw:StretchedContainer>

<iframe name="EcomUpdator" id="EcomUpdator" style="width: 0;" height="1" tabindex="-1" align="right"
    marginwidth="0" marginheight="0" frameborder="0" src="/Admin/Module/eCom_Catalog/dw7/edit/EcomUpdator.aspx" border="0"></iframe>
<asp:Literal ID="OrderLineMenuBlock" runat="server"></asp:Literal>
<asp:Literal ID="GatewayResultBlock" runat="server"></asp:Literal>
<input type="hidden" id="BackUrl" runat="server" />
<input type="hidden" id="BackUserID" runat="server" />
<input type="hidden" id="OrderShopID" runat="server" clientidmode="Static" />
<input type="hidden" id="SelectedShopID" runat="server" clientidmode="Static" />
<input type="hidden" name="OrderListPageNumber" value="<%=OrderListPageNumber %>" />
<input type="hidden" id="otntParameters" runat="server" clientidmode="AutoID" />

<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
