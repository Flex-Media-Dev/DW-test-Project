<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GiftCardsList.aspx.vb" Inherits="Dynamicweb.Admin.GiftCards.GiftCardsList" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head>
    <dw:ControlResources ID="ControlResources1" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ecomLists.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/Main.css" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">

        Event.observe(document, 'dom:loaded', function () {
            var isClearDate = false;
            $('CreationDateFilter').getElementsByClassName('ClearDateImage')[0].onclick = function () {
                if ($('CreationDateFilter:DateSelector_notSet').value != 'True') {
                    isClearDate = true;
                    DWClearDate('CreationDateFilter:DateSelector');
                    applyFilter();
                    isClearDate = false;
                }
            };

            var el = document.getElementById("CreationDateFilter:DateSelector_label");
            if (el != null) {
                el.onchange = function () {
                    if (!isClearDate) {
                        applyFilter();
                    }
                };
            }
        });

        function help() {
            <%=Dynamicweb.SystemTools.Gui.Help("", "administration.managementcenter.eCommerce.orders.giftcards")%>;
        }

        function showTransactionsList(giftCardID, giftCardCurrencyCode) {
            var url = '/Admin/Module/eCom_Catalog/dw7/GiftCards/GiftCardTransactionsList.aspx?GiftCardID=' + giftCardID + '&GiftCardCurrencyCode=' + giftCardCurrencyCode;
            dialog.show("GiftCardTransactionsDialog", url);
        }

        function applyFilter() {
            form1.submit();
        }

        function toggleButtons() {
            var rows = List.getSelectedRows('GiftCardsLst');
            Toolbar.setButtonIsDisabled("ExpireToolbarButton", rows.length < 1);
        }

        function expireCards() {
            var rows = List.getSelectedRows('GiftCardsLst');
            var ids = rows.map(function (row) { return row.getAttribute("itemid"); }).join();
            var message = "<%=Translate.Translate("Are you sure you want to cancel %% gift cards?")%>".replace("%%", rows.length);

            var dlgAction = {
                Url: "/Admin/CommonDialogs/Confirm?Caption=<%=Translate.Translate("Cancel gift cards")%>&Message=" + message + "&Buttons=3",
                Name: "OpenDialog",
                OnSubmitted: {
                    Name: "ScriptFunction",
                    Function: function (act, model) {
                        $("GiftCardsToExpire").value = ids;
                        form1.submit();
                    }
                }
            };

            Action.Execute(dlgAction);
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card-header">
            <h2 class="subtitle"><%=Translate.Translate("Gift cards") %></h2>
        </div>

        <dw:Toolbar ID="ListBar1" runat="server" ShowEnd="false">
            <dw:ToolbarButton ID="HelpToolbarButton" runat="server" Divide="None" Icon="Help" Text="Help"
                OnClientClick="help();">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="ExpireToolbarButton" runat="server" Divide="Before" Disabled="true" Icon="NoSim" Text="Cancel gift card"
                OnClientClick="expireCards();">
            </dw:ToolbarButton>
        </dw:Toolbar>
        <input type="hidden" id="GiftCardsToExpire" name="GiftCardsToExpire" />
        <dw:List ID="GiftCardsLst" ShowFooter="true" runat="server" TranslateTitle="True" StretchContent="True" PageSize="25" ShowPaging="true" AllowMultiSelect="true" Title="GiftCards" OnClientSelect="toggleButtons();">
            <Columns>
                <dw:ListColumn ID="colName" runat="server" Name="Name" EnableSorting="true" />
                <dw:ListColumn ID="colCode" runat="server" Name="Code" EnableSorting="true" />
                <dw:ListColumn ID="colCurrency" runat="server" Name="Currency" EnableSorting="true" />
                <dw:ListColumn ID="colCreationDate" runat="server" Name="Creation Date" EnableSorting="true" />
                <dw:ListColumn ID="colExpiryDate" runat="server" Name="Expiry Date" EnableSorting="true" />
                <dw:ListColumn ID="colInitialAmount" runat="server" Name="InitialAmount" EnableSorting="true" />
                <dw:ListColumn ID="colBalance" runat="server" Name="RemainingBalance" EnableSorting="true" />
            </Columns>
            <Filters>
                <dw:ListDateFilter runat="server" ID="CreationDateFilter" Label="Creation date" />
                <dw:ListTextFilter runat="server" ID="CodeFilter" Label="Search code" ShowSubmitButton="true" />
                <dw:ListDropDownListFilter runat="server" ID="ExpiryStateFilter" Label="ExpiryState" Width="200" OnClientChange="applyFilter();"></dw:ListDropDownListFilter>
            </Filters>
        </dw:List>

        <dw:Dialog ID="GiftCardTransactionsDialog" runat="server" Title="GiftCard Transactions" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
            <iframe id="GiftCardTransactionsDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>

        <%Translate.GetEditOnlineScript()%>
    </form>
</body>
</html>


