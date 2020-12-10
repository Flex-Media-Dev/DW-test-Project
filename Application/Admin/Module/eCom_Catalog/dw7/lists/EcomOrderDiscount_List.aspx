<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomOrderDiscount_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrderDiscount_List" %>
<%@ Register assembly="Dynamicweb.Controls" namespace="Dynamicweb.Controls" tagprefix="dw" %>
<%@ Register Src="~/Admin/Module/eCom_Catalog/dw7/lists/UCOrderDiscount_List.ascx" TagPrefix="odl" TagName="UCOrderDiscount_List" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
    <script src="/Admin/Resources/js/layout/Actions.js"></script>
    <script type="text/javascript">
        function deleteDiscount() {
            var discountIDs = getCheckedRows();
            var act = <%=GetDiscountDeleteAction()%>;
            act.OnSubmitted.Parameters.DiscountID = discountIDs.join();
            Action.Execute(act);
        }

        function editDiscount(id) {
            if (id) {
                document.location.href = '/Admin/Module/eCom_Catalog/dw7/edit/EcomOrderDiscount_Edit.aspx?Type=<%=Dynamicweb.Core.Converter.ToString(Request("Type"))%>&OrderDiscountId=' + id + '&ShopId=<%=Request("ShopId")%>';
            } else {
                document.location.href = '/Admin/Module/eCom_Catalog/dw7/edit/EcomOrderDiscount_Edit.aspx?Type=<%=Dynamicweb.Core.Converter.ToString(Request("Type"))%>&ShopId=<%=Request("ShopId")%>';
            }            
        }

        function copyDiscount(id) {
            document.location.href = '/Admin/Module/eCom_Catalog/dw7/edit/EcomOrderDiscount_Edit.aspx?Type=<%=Dynamicweb.Core.Converter.ToString(Request("Type"))%>&OrderDiscountId=' + id + '&CopyMode=true&ShopId=<%=Request("ShopId")%>';
        }

        function selectDiscount(id)
        {
            var row = List.getRowByID('DiscountList', id.toString());
            List.setRowSelected('DiscountList', row, !List.rowIsSelected(row), null);
        }

        function isIEBrowser() {
            var ua = window.navigator.userAgent;
            var msie = ua.indexOf("MSIE ");
            if (msie < 0) {
                msie = ua.indexOf("rv:11.0");
            }
            if (msie > 0) {
                return true;
            } else {
                return false;
            }
        }

        function discountSelected() {
            var delBtn = $('linkDiscountDelete');
            if (List && List.getSelectedRows('DiscountList').length > 0) {
                delBtn.removeAttribute("disabled");
                delBtn.onclick = deleteDiscount
            } else {
                delBtn.setAttribute("disabled", "disabled");
            }
        }

        function getCheckedRows() {
            var IDs = [];
            var discountID = ContextMenu.callingID;
            var checkedRows = List.getSelectedRows('DiscountList');

            if (checkedRows && checkedRows.length > 0) {
                for (var i = 0; i < checkedRows.length; i++) {
                    IDs[i] = checkedRows[i].id.replace("row", "");
                }
            } else if (discountID) {
                IDs[0] = discountID;
            }
            return IDs;
        }

        function closeDiscounts() {
            parent.closeMiscDialog();
        }

        function IncludeInDiscounts() {
            var discountArr = getCheckedRows().join(",");
            parent.IncludeDiscounts(discountArr);
        }

        function ExcludeFromDiscounts() {
            var discountArr = getCheckedRows().join(",");
            parent.ExcludeDiscounts(discountArr);
        }
    </script>
</head>
<body class="screen-container">
    <form id="form1" runat="server" enableviewstate="false">
    <input type="hidden" name="selctedRowID" id="selctedRowID" />
    <div style="height: 98%;">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <odl:UCOrderDiscount_List runat="server"
             ID="DiscountList"
             AllowMultiSelect="true"
             UseCountForPaging="true"
             HandleSortingManually="true"
             HandlePagingManually="true"
             Personalize="true"
             StretchContent="false" 
             ShowTitle="false"
             PageSize="200"
             PageNumber="1"
             RowUsePointerCursor="true"
             RowContextMenuID="OrderDiscountContext"
             OnClientSelect="discountSelected();"            
             OnClientRowClickCallback="editDiscount">
        </odl:UCOrderDiscount_List>
        <asp:Literal id="BoxEnd" runat="server"></asp:Literal> 
    </div>
        <div class="card-footer" id="BottomInformationBg" runat="server"></div>
    <dw:ContextMenu ID="OrderDiscountContext" runat="server">
        <dw:ContextMenuButton ID="cmdCopyDiscount" runat="server" Divide="None" Icon="PlusSquare" Text="Copy discount" OnClientClick="copyDiscount(ContextMenu.callingID);" />
        <dw:ContextMenuButton ID="cmdEditDiscount" runat="server" Divide="None" Icon="Pencil" Text="Edit discount" OnClientClick="editDiscount(ContextMenu.callingID);" />
        <dw:ContextMenuButton ID="cmdDeleteDiscount" runat="server" Divide="None" Icon="Delete" Text="Delete discount" OnClientClick="deleteDiscount(ContextMenu.callingID);" />
    </dw:ContextMenu>
        
    </form>
</body>
</html>