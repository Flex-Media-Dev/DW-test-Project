<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomPartsList.aspx.vb" Inherits="Dynamicweb.Admin.EcomPartsList" %>

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
    <script>
        var prodProdItemAdd = true;
        function createPriceListPage(opts) {
            let dialogId = "PartsDialog";
            let api = {
                init: function (opts) {
                    this.options = opts;
                },
                
                delete: function (itemId) {
                    Action.Execute(this.options.actions.delete, { ProductId: this.options.productId, itemId: itemId });
                },

                saveSorting: function (sortedItems) {
                    Action.Execute(this.options.actions.saveSorting, { ProductId: this.options.productId, sortedItems: sortedItems });
                },

                add: function (checkArr, methodType) {
                    Action.Execute(this.options.actions.add, { ProductId: this.options.productId, checkArr: checkArr, methodType: methodType});
                }
            };
            api.init(opts);
            return api;

        }

        function addPartsList(event) {
            ContextMenu.show(event, 'PartsListContext', '', '', 'BottomRight');
        }

        function saveParts() {
            document.forms[0].submit();
        }
        

        function AddProductItem(typeMode) {
            <%If ProductId <> "" Then%>
            if (prodProdItemAdd) {
                var caller = "parent.document.getElementById('MainForm').addProdItemGrpChecked";
                if (typeMode == "ProdItemProd") {
                    caller = "parent.document.getElementById('MainForm').addProdItemProdChecked";
                }
                dialog.setTitle('ProductEditMiscDialog', '<%=Translate.Translate("Add product item")%>');
                dialog.show('ProductEditMiscDialog', "/Admin/Module/eCom_Catalog/dw7/edit/EcomGroupTree.aspx?CMD=" + typeMode + "&AppendType=" + typeMode + "&MasterProdID=<%=ProductId%>&caller=" + caller + "&FromPim=<%=Request("FromPim")%>");
            }
            <%Else%>
            alert("<%=Dynamicweb.SystemTools.Translate.JsTranslate("You need to save the product...")%>")
            <%End If%>
        }

        function AddProdItemRows(typeMode, method) {
            var checkedArray = ""
            if (typeMode == "PROD") {
                checkedArray = document.getElementById('MainForm').addProdItemProdChecked.value;
            } else {
                checkedArray = document.getElementById('MainForm').addProdItemGrpChecked.value;
            }

            currentPage.add(checkedArray, typeMode);
        }

        function CallerForDeleteDWRow(DWRowid, rowID, typeStr, methodID, prefix, arg1, arg2) {
            currentPage.delete(methodID);
        }

        function sortProductItems() {
            var elem = document.getElementById("PRODITEMHOLDER");
            var sort = document.getElementById("PRODITEMSORTER")

            if (elem.style.display == '') {
                elem.style.display = 'none';
                sort.style.display = '';
            } else {
                elem.style.display = '';
                sort.style.display = 'none';
            }
        }

        function fillProductItems(fillStr) {
            var sort = document.getElementById("SORTEDLIST")
            sort.innerHTML = fillStr;
        }

        function submitSortProductItems() {
            var values = ""
            var elem = document.getElementById("ElemSort")
            for (i = 0; i < elem.length; i++) {
                if (values == "") {
                    values = elem.options[i].value;
                } else {
                    values += ";" + elem.options[i].value;
                }
            }
            currentPage.saveSorting(values);
        }

        function showProductsInBOMGroup(rowID, itemID) {
            var caretIcon = document.querySelector('#BOM_' + itemID + ' .caret');
            if (document.getElementById('PI_BOMProdListRow' + rowID).style.display == '') {
                document.getElementById('PI_BOMProdListRow' + rowID).style.display = 'none';
                if (document.getElementById('PI_BOMProdListNoProductRow' + rowID)) {
                    document.getElementById('PI_BOMProdListNoProductRow' + rowID).style.display = 'none';
                }
                caretIcon.classList.remove('fa-caret-down');
                caretIcon.classList.add('fa-caret-right');
            } else {
                document.getElementById('PI_BOMProdListRow' + rowID).style.display = '';
                if (document.getElementById('PI_BOMProdListNoProductRow' + rowID)) {
                    document.getElementById('PI_BOMProdListNoProductRow' + rowID).style.display = '';
                }
                caretIcon.classList.remove('fa-caret-right');
                caretIcon.classList.add('fa-caret-down');
            }
        }

        function fillProductsInBOMGroup(rowID, fillValue) {
            try {
                var div = eval('PI_BOMProdList' + rowID);
                div.innerHTML = fillValue;
            } catch (e) {
                //Nothing
            }
        }

        function setDefaultProductForBOMGroup(rowID, productID) {
            document.getElementById('PRODITEM_DefaultProductID' + rowID).value = productID;
        }

        function MoveSortUp(grpId) {
            try {
                var elem = document.getElementById("ElemSort" + grpId);
                if (!elem) return;
                var ID = elem.selectedIndex;

                if (ID != 0) {
                    val1 = elem[ID - 1].value;
                    val2 = elem[ID - 1].text;
                    elem.options[ID - 1] = new Option(elem[ID].text, elem[ID].value);
                    elem.options[ID] = new Option(val2, val1);
                    elem.options[ID - 1].selected = true;
                    ToggleImage(ID - 1, grpId);
                }
            } catch (e) {
                alert(e);
                //Nothing
            }
        }

        function MoveSortDown(grpId) {
            try {
                var elem = document.getElementById("ElemSort" + grpId);
                if (!elem) return;
                var ID = elem.selectedIndex;

                if (ID != elem.length - 1) {
                    val1 = elem[ID + 1].value;
                    val2 = elem[ID + 1].text;
                    elem.options[ID + 1] = new Option(elem[ID].text, elem[ID].value);
                    elem.options[ID] = new Option(val2, val1);
                    elem.options[ID + 1].selected = true;
                    ToggleImage(ID + 1, grpId);
                }
            } catch (e) {
                alert(e);
                //Nothing
            }
        }

        function ToggleImage(ID, grpId) {
            var imgUp = document.getElementById("up" + grpId)
            var imgDown = document.getElementById("down" + grpId)
            var elem = document.getElementById("ElemSort" + grpId)

            if (ID > -1) {
                if (ID == 0) {
                    imgUp.src = "/Admin/images/Collapse_inactive.gif";
                    imgUp.alt = "";
                } else {
                    imgUp.src = "/Admin/images/Collapse.gif";
                    imgUp.alt = "<%=Translate.JsTranslate("Flyt op")%>";
                }

                if (ID == elem.length - 1) {
                    imgDown.src = "/Admin/images/Expand_inactive.gif";
                    imgDown.alt = "";
                } else {
                    imgDown.src = "/Admin/images/Expand_active.gif";
                    imgDown.alt = "<%=Translate.JsTranslate("Flyt ned")%>";
                }
            } else {
                imgUp.src = "/Admin/images/Collapse_inactive.gif";
                imgUp.alt = "";
                imgDown.src = "/Admin/images/Expand_inactive.gif";
                imgDown.alt = "";
            }
        }
    </script>
</head>

<body>
    <form id="MainForm" runat="server">
        <input type="hidden" id="addProdItemProdChecked" name="addProdItemProdChecked">
        <input type="hidden" id="addProdItemGrpChecked" name="addProdItemGrpChecked">
        <asp:Literal ID="ProductPartsList" runat="server"></asp:Literal>
        <dw:ContextMenu ID="PartsListContext" runat="server" MaxHeight="650">
        </dw:ContextMenu>
        <dw:Dialog runat="server" ID="ProductEditMiscDialog" Size="Large" HidePadding="True">
            <iframe id="ProductEditMiscDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>
        <dw:Overlay ID="ProductEditOverlay" runat="server"></dw:Overlay>
    </form>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
