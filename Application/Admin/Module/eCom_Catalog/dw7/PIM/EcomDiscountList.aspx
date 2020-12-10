<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomDiscountList.aspx.vb" Inherits="Dynamicweb.Admin.EcomDiscountList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    <style type="text/css">
        #DiscountList_body .listRow > td[onclick] {
            cursor: pointer;
        }
    </style>
    <script>
        function createDiscountListPage(opts) {
            let dialogId = "ProductDiscountsDialog";
            let changeCurrentState = function (rowEl, cellEl, state, fn) {
                let discountId = rowEl.getAttribute("itemid");
                let isChecked = rowEl.getAttribute(state) == "true";
                let newLabel = opts.labels.checked;
                if (isChecked) {
                    newLabel = opts.labels.unchecked;
                }
                isChecked = !isChecked;
                cellEl.innerHTML = newLabel;
                rowEl.setAttribute(state, isChecked);
                fn(discountId, isChecked);
            };

            let updateStorage = function (storageEl, discountId, newVal) {
                let arr = storageEl.value.split(",");
                discountId = discountId + "-"
                var filtered = arr.filter(item => item && item.indexOf(discountId) !== 0)
                filtered.push(discountId + newVal);
                let val = filtered.join();
                storageEl.value = val;
            };

            let api = {
                init: function (opts) {
                    this.options = opts;
                },
                cancel: function () {
                    let dlg = window.parent.dialog;
                    if (dlg) {
                        dlg.hide(dialogId);
                    }
                },
                save: function (close) {
                    let cmd = document.getElementById('cmdSubmit');
                    cmd.value = !!close ? "SaveAndClose" : "Save";
                    MainForm.submit();
                    this.cancel();
                },

                changeIncluded: function (evt) {
                    let cellEl = evt.currentTarget;
                    let rowEl = cellEl.parentElement;
                    let storageEl = document.getElementById("IncludedChanges");
                    changeCurrentState(rowEl, cellEl, "Included", function (discountId, newVal) {
                        updateStorage(storageEl, discountId, newVal);
                    });
                },

                changeExcluded: function (evt) {
                    let cellEl = evt.currentTarget;
                    let rowEl = cellEl.parentElement;
                    let storageEl = document.getElementById("ExcludedChanges");
                    changeCurrentState(rowEl, cellEl, "Excluded", function (discountId, newVal) {
                        updateStorage(storageEl, discountId, newVal);
                    });
                }
            };
            api.init(opts);
            return api;
        }
    </script>
</head>

<body>
    <form id="MainForm" runat="server">
        <dwc:Card runat="server">
            <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                <dw:ToolbarButton ID="cmdCancel" runat="server" Icon="Cancel" Text="Cancel" OnClientClick="currentPage.cancel()" />
                <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(true);" />
            </dw:Toolbar>
            <dw:List runat="server" ID="DiscountList" AllowMultiSelect="false" HandleSortingManually="false" Personalize="true" ShowPaging="true" ShowTitle="false" PageSize="25" NoItemsMessage="No discounts found">
                <Filters>
                    <dw:ListAutomatedSearchFilter runat="server" />
                </Filters>
            </dw:List>
        </dwc:Card>
        <input type="hidden" id="IncludedChanges" runat="server" name="IncludedChanges" value="" />
        <input type="hidden" id="ExcludedChanges" runat="server" name="ExcludedChanges" value="" />
        <input type="hidden" id="cmdSubmit" name="cmdSubmit" value="" />
    </form>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>

