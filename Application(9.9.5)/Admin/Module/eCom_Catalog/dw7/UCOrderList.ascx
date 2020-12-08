<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UCOrderList.ascx.vb" Inherits="Dynamicweb.Admin.UCOrderList" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Security.Permissions" %>

<script>
    // Fires when a row is selected or deselected
    function rowSelected() {
        // Use enable or disable
        var enable = getSelectedOrders().length > 0
        var toggle = enable ? Ribbon.enableButton : Ribbon.disableButton;

        <% If CurrentPermission.HasPermission(PermissionLevel.Delete) Then %>
        // Delete button
        if (checkDeleteSelectedOrders()) {
            Ribbon.enableButton('ButtonDelete');
        } else {
            Ribbon.disableButton('ButtonDelete');
        }
        <% End If %>

        // Capture button
        toggle('ButtonCapture');

        toggle('ButtonCreateShippingDocuments');

        if ($('ButtonSetOrderState') != null)
            toggle('ButtonSetOrderState'); // The button next to the order state drop down, that shows if more than 6 order states exist

        // Order state buttons - with ids: OrderStateButton0, OrderStateButton1, ..., OrderStateButtonN
        for (var i = 0; ; i++) {
            var buttonID = 'OrderStateButton' + i;
            if (!$(buttonID))
                return;
            toggle(buttonID);
        }
    }

    function ordersListMenuShown(deleteButtonId) {
        var ordersCanBeDeleted = checkDeleteSelectedOrders();
      
        var contextMenuElement = document.getElementById(deleteButtonId);
        var contextMenuButton = contextMenuElement.querySelector('a');

        if (ordersCanBeDeleted) {
            contextMenuButton.classList.remove('button-disabled');
        } else {
            contextMenuButton.classList.add('button-disabled');
        }
    }

    function ordersListMenuHide() {
        ContextMenu.callingItemID = null;
    }

    function deleteSelectedOrders(contextMenuButton) {
        if (!contextMenuButton.classList.contains('button-disabled')) {
            deleteOrder();
        }
    }

    function showSelectedShopOrder() {
        showOrder('<%=SelectedShopID%>');
    }
</script>

 <input id="orderIds" name="orderIds" type="hidden" value="" />
 <input id="ShopID" name="ShopID" type="hidden" value="<%=Dynamicweb.Context.Current.Request("ShopID") %>" />
 <input id="isQuotes" name="isQuotes" type="hidden" value="<%=IsQuotes%>"/>
 <input id="isRecurringOrders" name="isRecurringOrders" type="hidden" value="<%=IsRecurringOrder%>"/>
 <input id="IsLedgerEntries" name="IsLedgerEntries" type="hidden" value="<%=IsLedgerEntries%>"/>
 <input id="IsCarts" name="IsCarts" type="hidden" value="<%=IsCarts%>" />
<asp:Panel runat="server" ID="ContentPanel">
    <!-- Ribbon bar start -->
    <div style="min-width:832px;overflow:hidden;">
    <dw:RibbonBar ID="OrderListRibbon" runat="server">
        <dw:RibbonBarTab ID="TabOrders" Name="Orders" runat="server">
            <dw:RibbonBarGroup Name="Tools" runat="server">
                <dw:RibbonBarButton ID="ButtonDelete" Icon="Delete" Size="Small" Text="Delete" OnClientClick="deleteOrder();" runat="server" Disabled="true"/>
                <dw:RibbonBarButton ID="ButtonCapture" Icon="CreditCard" Size="Small" Text="Capture orders" OnClientClick="captureOrders();" runat="server" Disabled="true"/>
                <dw:RibbonBarButton ID="ButtonCreateShippingDocuments" Icon="Truck" Size="Small" Text="Create shipping documents" OnClientClick="createShippingDocuments();" runat="server" Disabled="true"/>
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup ID="OrderStateButtonView" Name="Set order state" runat="server">
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup ID="OrderStateListView" Name="Set order state" runat="server">
                <dw:RibbonBarPanel ID="RibbonBarPanel1" runat="server">
                    <dw:GroupDropDownList ID="OrderStateList" CssClass="NewUIinput" style="width: auto; margin-top: 3px;" runat="server" />
                </dw:RibbonBarPanel>
                <dw:RibbonBarButton ID="ButtonSetOrderState" Icon="Check" Size="Small" Text="Set" OnClientClick="setOrderState($(orderStateListClientID).value);" runat="server" Disabled="true"/>
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup runat="server" Name="Filters">
                <dw:RibbonBarButton runat="server" ID="ButtonReset" Text="Reset" Size="Large" Icon="Refresh" OnClientClick="ResetFilters();" />
                <dw:RibbonBarButton runat="server" ID="ButtonApplyFilters" Text="Apply" Size="Large" Icon="Check" OnClientClick="javascript:List._submitForm('List');" />
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup Name="Print" runat="server">
                <dw:RibbonBarButton ID="ButtonPrint" Icon="Print" Size="Large" Text="Print" OnClientClick="printOrders();" runat="server" />
            </dw:RibbonBarGroup>

            <dw:RibbonBarGroup Name="Help" runat="server">
                <dw:RibbonBarButton ID="ButtonHelp" Icon="Help" Size="Large" Text="Help" OnClientClick="helpOL();" runat="server" />
            </dw:RibbonBarGroup>
        </dw:RibbonBarTab>

    </dw:RibbonBar>
    </div>
    <!-- Ribbon bar end -->

    <!-- List start -->
    <div id="ListContent" class="content" style="overflow: auto;">
    <dw:List runat="server"
             ID="List"
             AllowMultiSelect="true"
             Title="Orders" UseCountForPaging="true"
             HandleSortingManually="true"
             HandlePagingManually="true"
             OnClientSelect="rowSelected();"
             ShowCollapseButton="true"
             Personalize="true"
             OnClientCollapse="SaveCollapseState(true);enableResetButton();"
             OnClientUnCollapse="SaveCollapseState(false);">

        <Filters>
            <dw:ListDropDownListFilter runat="server" ID="DatePresetFilter" Width="220" Label="Preset interval" OnClientChange="enableResetButton(); setDatePreset();" >
                <Items>
                    <dw:ListFilterOption Text="Select interval" Value="" selected="true"/>
                    <dw:ListFilterOption Text="All dates" Value="All_Time" />
                    <dw:ListFilterOption Text="Today" Value="Today" />
                    <dw:ListFilterOption Text="Latest week" Value="Last_Week" />
                    <dw:ListFilterOption Text="Latest month" Value="Last_Month" />
                    <dw:ListFilterOption Text="Latest 6 months" Value="Last_6_Months" />
                    <dw:ListFilterOption Text="Latest year" Value="Last_Year" />
                </Items>
            </dw:ListDropDownListFilter>
            <dw:ListDropDownListFilter runat="server" ID="OrderStateFilter" Label="Order state" Width="220" OnClientChange="enableResetButton();"/>

            <dw:ListDropDownListFilter runat="server" ID="CaptureStateFilter" Label="Capture state" Width="220" Divide="After" OnClientChange="enableResetButton();">
                <Items>
                    <dw:ListFilterOption Text="All" Value="All" DoTranslate="true" Selected="true" />
                    <dw:ListFilterOption Text="Captured" Value="Captured" DoTranslate="true" />
                    <dw:ListFilterOption Text="Not captured" Value="NotCaptured" DoTranslate="true" />
                    <dw:ListFilterOption Text="Not supported" Value="NotSupported" DoTranslate="true" />
                </Items>
            </dw:ListDropDownListFilter>

            <dw:ListDropDownListFilter runat="server" ID="CompletedFilter" Label="Order progress" Width="220" OnClientChange="enableResetButton();"/>

            <dw:ListDateFilter runat="server" id="FromDateFilter" Label="Start date" IncludeTime="false" OnClientChange="enableResetButton(); resetDatePreset();" /> 

            <dw:ListDropDownListFilter runat="server" ID="UntransferredFilter" Label="Untransferred" Width="220" Divide="After" OnClientChange="enableResetButton();">
                <Items>
                    <dw:ListFilterOption Text="All" Value="0" DoTranslate="true" Selected="true" />
                    <dw:ListFilterOption Text="Yes" Value="1" DoTranslate="true" />                    
                </Items>
            </dw:ListDropDownListFilter>            

            <dw:ListDropDownListFilter runat="server" ID="PageSizeFilter" Label="Orders per page" Width="220" OnClientChange="enableResetButton();" >
                <Items>
                    <dw:ListFilterOption Text="10" Value="10" DoTranslate="false"/>
                    <dw:ListFilterOption Text="25" Value="25" DoTranslate="false" Selected="true" />
                    <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                    <dw:ListFilterOption Text="75" Value="75" DoTranslate="false" />
                    <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                    <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                </Items>
            </dw:ListDropDownListFilter>

            <dw:ListDateFilter runat="server" id="ToDateFilter" Label="End date" IncludeTime="false" OnClientChange="enableResetButton(); resetDatePreset();" />                       
            <dw:ListTextFilter runat="server" id="SearchInOrderIdFilter" Label="Search Order Id" Width="220" ShowSubmitButton="false" Divide="Before" OnClientChange="enableResetButton();" />
            <dw:ListTextFilter runat="server" id="SearchInCustomerFieldsFilter" Label="Search customer fields" Width="220" ShowSubmitButton="false" OnClientChange="enableResetButton();" />
            <dw:ListTextFilter runat="server" id="SearchInAllFieldsFilter" Label="Search all fields" Width="220" ShowSubmitButton="false" Divide="After" OnClientChange="enableResetButton();" />            
        </Filters>
    </dw:List>
    </div>
    <!-- List end -->
    
       <!-- context menu for carts/quotes in the orderlist start -->
    <dw:ContextMenu runat="server" ID="OrderListNonOrderContext" OnHide="ordersListMenuHide();" OnShow="ordersListMenuShown('ContextDeleteOrders');">
        <dw:ContextMenuButton ID="ContextShowOrder" Icon="Pencil" Text="Show" OnClientClick="showSelectedShopOrder();" runat="server" />
        <dw:ContextMenuButton ID="ContextDeleteOrders" Icon="Delete" Text="Delete" OnClientClick="deleteSelectedOrders(this);" runat="server" />
        <dw:ContextMenuButton ID="ContextPrint" Icon="Print" Text="Print" Divide="Before" OnClientClick="printOrders();" runat="server" />
        <dw:ContextMenuButton ID="ContextBulkCapture" Icon="CreditCard" Text="Capture" Divide="Before" OnClientClick="captureOrders();" runat="server" />
    </dw:ContextMenu>
    <!-- context menu end-->
     <!-- context menu for completed orders in the orderlist start -->
    <dw:ContextMenu runat="server" ID="OrderListOrderContext" OnHide="ordersListMenuHide();" OnShow="ordersListMenuShown('ContextDeleteOrders2');">
        <dw:ContextMenuButton ID="ContextShowOrder2" Icon="Pencil" Text="Show order" OnClientClick="showSelectedShopOrder();" runat="server" />
        <dw:ContextMenuButton ID="ContextDeleteOrders2" Icon="Delete" Text="Delete" OnClientClick="deleteSelectedOrders(this);" runat="server" />
        <dw:ContextMenuButton ID="ContextSetOrderState2" Icon="Check" IconColor="Default" Text="Set order state" Divide="Before" runat="server">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextCreateRMA2" Icon="Delete" Text="Create new RMA" OnClientClick="createRma(createRmaConfirmationText);" runat="server" />
        <dw:ContextMenuButton ID="ContextPrint2" Icon="Print" Text="Print order" Divide="Before" OnClientClick="printOrders();" runat="server" />
        <dw:ContextMenuButton ID="ContextBulkCapture2" Icon="CreditCard" Text="Capture orders" Divide="Before" OnClientClick="captureOrders();" runat="server" />
    </dw:ContextMenu>
    <!-- Order context menu end -->
    <!-- context menu for carts/Orders in the QuoteList start -->
    <dw:ContextMenu runat="server" ID="QuoteListNonQuoteContext" OnHide="ordersListMenuHide();" OnShow="ordersListMenuShown('ContextDeleteOrders3');">
        <dw:ContextMenuButton ID="ContextShowOrder3" Icon="Pencil" Text="Show quote" OnClientClick="showSelectedShopOrder();" runat="server" />
        <dw:ContextMenuButton ID="ContextDeleteOrders3" Icon="Delete" Text="Delete" OnClientClick="deleteSelectedOrders(this);" runat="server" />
        <dw:ContextMenuButton ID="ContextPrint3" Icon="Print" Text="Print order" Divide="Before" OnClientClick="printOrders();" runat="server" />
    </dw:ContextMenu>
    <!-- context menu end-->
     <!-- context menu for Quotes in the QuoteList start -->
    <dw:ContextMenu runat="server" ID="QuoteListQuoteContext" OnHide="ordersListMenuHide();" OnShow="ordersListMenuShown('ContextDeleteOrders4');">
        <dw:ContextMenuButton ID="ContextShowOrder4" Icon="Pencil" Text="Show quote" OnClientClick="showSelectedShopOrder();" runat="server" />
        <dw:ContextMenuButton ID="ContextDeleteOrders4" Icon="Delete" Text="Delete" OnClientClick="deleteSelectedOrders(this);" runat="server" />
        <dw:ContextMenuButton ID="ContextSetOrderState4" Icon="Check" IconColor="Default" Text="Set quote state" Divide="Before" runat="server">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextPrint4" Icon="Print" Text="Print quote" Divide="Before" OnClientClick="printOrders();" runat="server" />
    </dw:ContextMenu>
    <!-- Order context menu end -->
     <!-- context menu for Quotes in the QuoteList start -->
    <dw:ContextMenu runat="server" ID="RecurringOrderListContext" OnHide="ordersListMenuHide();" OnShow="ordersListMenuShown('ContextMenuButton2');">
        <dw:ContextMenuButton ID="ContextMenuButton1" Icon="Pencil" Text="Show order" OnClientClick="showSelectedShopOrder();" runat="server" />
        <dw:ContextMenuButton ID="ContextMenuButton2" Icon="Delete" Text="Delete" OnClientClick="deleteSelectedOrders(this);" runat="server" />
        <dw:ContextMenuButton ID="ContextMenuButton4" Icon="Print" Text="Print order" Divide="Before" OnClientClick="printOrders();" runat="server" />
    </dw:ContextMenu>
    <!-- Order context menu end -->

</asp:Panel>

<!-- Print Panel start -->

<asp:Panel ID="PrintPreview" runat="server" style="display: none;">
    <dw:RibbonBar ID="PrintRibbon" runat="server">
        <dw:RibbonBarTab ID="PrintRibbonPrintTab" Name="Print" runat="server">
            <dw:RibbonBarGroup ID="PrintRibbonPrintGroup" Name="Tools" runat="server">
                <dw:RibbonBarButton ID="PrintRibbonCloseButton" Icon="TimesCircle" Text="Close" Size="Large" OnClientClick="closePrintPreview();" runat="server" />
                <dw:RibbonBarButton ID="PrintRibbonRefreshButton" Icon="Refresh" Text="Refresh" Size="Large" OnClientClick="reloadPrintPreview();" runat="server" />
                <dw:RibbonBarButton ID="PrintRibbonPrintButton" Icon="Print" Text="Print" Size="Large" OnClientClick="processPrinting();" runat="server" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="PrintRibbonTemplateGroup" Name="Template" runat="server">
                <dw:RibbonBarPanel ID="PrintRibbonTemplatePanel" runat="server">
                    <div style="width: 290px;">
                        <dw:FileManager Folder="Templates/eCom7/Order" ID="PrintTemplate" File="PrintOrder.html" OnChange="reloadPrintPreview(this.value);" runat="server" />
                    </div>
                </dw:RibbonBarPanel>
            </dw:RibbonBarGroup>
        </dw:RibbonBarTab>
    </dw:RibbonBar>

    <!-- Content -->
    <div id="PrintContent"></div>

    <!-- Loading gif -->
    <div id="PrintLoading">
        <img src="/Admin/Module/eCom_Catalog/images/ajaxloading.gif" alt=""/><br /><br />
        <dw:TranslateLabel runat="server" Text="Preparing orders for printing" />
    </div>

    <!-- Error div -->
    <div id="PrintError">
        <img src="/Admin/Images/Ribbon/Icons/error.png" alt="" />
        <dw:TranslateLabel runat="server" Text="An error occured, please try again." />
    </div>
</asp:Panel>
<!-- Print Panel end -->

<!-- Action start -->
    <input type="hidden" runat="server" id="ActionHidden"  name="Action" value="" />
    <input type="hidden" runat="server" id="OrderIDsHidden" name="OrderIDs" value="" />
    <input type="hidden" id="SelectedOrderStateID" name="SelectedOrderStateID" value="" />
    <input type="hidden" id="OrderListPageNumber" name="OrderListPageNumber" value="<%=List.PageNumber %>" />
<!-- Action end -->


    <dw:Dialog ID="CaptureDialog" runat="server" Title="Capture order" HidePadding="true" ShowOkButton="false" ShowCancelButton="true" CancelText="Close" ShowClose="true" >
        <iframe id="CaptureDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
	<dw:Dialog ID="SetupWizardDialog" runat="server" Size="Medium" ShowOkButton="false" ShowCancelButton="false" HidePadding="true" Title="Setup guide">
            <iframe id="SetupWizardDialogFrame" frameborder="0"></iframe>
	</dw:Dialog>

