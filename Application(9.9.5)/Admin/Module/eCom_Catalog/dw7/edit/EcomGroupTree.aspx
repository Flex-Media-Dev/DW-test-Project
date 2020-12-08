<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomGroupTree.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomGroupTree2" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title id="title" runat="server"></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server">
    </dw:ControlResources>
    <script type="text/javascript" language="JavaScript" src="../images/functions.js"></script>
    <style type="text/css">
        .card-header {
            display: none;
        }

        .nav .title {
            width: 99%;
            display: none;
        }

        .nav .subtitle {
            width: 99%;
        }

        .nav .tree {
            width: 99%;
        }

        body.margin {
            margin: 0px;
        }

        input, select, textarea {
            font-size: 11px;
            font-family: verdana,arial;
        }

        div.search-box {
            position: absolute;
            top: 2px;
            right: 2px;
        }

        #searchFieldTmp, #searchButton {
            padding: 4px 8px;
        }

        .box-end {
            height: 21px;
            background-color: #dfe9f5;
            border-top: 1px solid #c3c3c3;
        }

        div.tree {
            overflow-y: auto;
        }

        .groupSelectedNotActive {
            color: #C1C1C1;
        }
    </style>
    <script type="text/javascript">
        //<!--

        function getTree() {
            var tree;
            if (typeof (t) == 'undefined') {
                tree = window.parent.t;
            }
            else {
                tree = t;
            }
            return tree;
        }

        function hideAddGroupsButton() {
            //$('transferGroupSelect').style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=30)progid:DXImageTransform.Microsoft.BasicImage(grayscale=1)";
            //$('transferGroupSelect').removeAttribute("href");
            //$('transferGroupSelect').style.cursor = "";
        }

        function showLoad() {
            if ($('DW_Ecom_GroupTree').style.display == "") {	
                $('DW_Ecom_GroupTree').style.display = "none";
                new overlay('screenLoaderOverlay').show();
            }
        }

        var dontAdd = new Array()
        var loop = false; 
        var loopCnt = 0; 
        var tmpCnt = 0; 
        var boolCnt = 0; 
        var i;
        var grpCnt = 0;
        var grpArray = "";
        var arrValue = "";

        function AddProductToDiscount(itemId, itemName, itemImg) {
            grpArray = "["+ itemId +"]";
            setCaller();
            window.opener.ClearProdItems('<%=Request("id")%>_<%=Request("radio")%>');
            window.opener.addProductDivContent(itemId, itemName, itemImg, '<%=Request("id")%>_<%=Request("radio")%>');
            window.opener.invokeObjectByClick('<%=Request("id")%>', '<%=Request("radio")%>');
            window.close();
        }

        function submitGroups()
        {
            <%If Not String.IsNullOrEmpty(Request("AssortmentID")) Then%>
            showLoad();

            <%If Request("CMD") = "ShowProdList_ShowProdGroupList" OrElse Request("CMD") = "ShowProdList" Then%>
            submitSearchProduct('<%=Request("AssortmentID")%>');
            <%Else%>
            submitProduct('<%=Request("AssortmentID")%>');
			<%End If%>

            return;
            <%End If%>

            hideAddGroupsButton();
            showLoad();

			<%If Request("CMD") = "ShowProdList" Then%>
            document.getElementById('Form1').SubmitCheckBoxForm.click();
		    <%ElseIf Request("CMD") = "ShowProdGroupList" Then%>
            appendProductsToGroup(1);
            <%ElseIf Request("CMD") = "ShowProdList_ShowProdGroupList" Then%>
            appendSearchedProductsToGroup(1);
			<%ElseIf Request("CMD") = "ProductSelectors" Then%>
            returnProductsAndGroups(1);
			<%ElseIf Request("CMD") = "ProductsAndGroupsSelector" Then%>
            returnProductsAndGroups(2);
			<%ElseIf Request("CMD") = "ShowProdList_ProductSelectors" Then%>
            returnProductsToList(1);
			<%ElseIf Request("CMD") = "ShowProdList_ProductsAndGroupsSelector" Then%>
            returnProductsToList(2);
			<%ElseIf Request("CMD") = ProductsSelectorCommand Then%>
            returnSelectedProducts();
			<%ElseIf Request("CMD") = ProductsSelectorListCommand Then%>
            returnSelectedProductsFromList();
			<%Else%>
            reLoopGroups();
			<%End If%>
        }

        function submitShop(assortId)
        { 
            var cliEdit = '<%=Request("clientedit")%>';

            if(cliEdit == 'true')
            {
                window.opener.eCommerce.OnAssortmentShopSelected(window, null, null)
                window.close();
            }
            else
            {
                var t = getTree();
                var checkedNodes = t.getCheckedNodes();
                var arrStr = '';

                for(i = 0; i < checkedNodes.length; i++)
                {
                    var node = checkedNodes[i];
                    var item = decodeURIComponent(node.itemID).evalJSON();

                    var id = item.nodeId;

                    if(arrStr != '')
                        arrStr += ',';

                    arrStr += id;
                }

                window.opener.location.href = "EcomAssortment_Edit.aspx?CMD=ATTACH_SHOP&ID=" + assortId + "&shopArr=" + arrStr;
                window.close();
            }
        }

        function submitGroup(assortId)
        {
            var cliEdit = '<%=Request("clientedit")%>';

            if(cliEdit == 'true')
            {
                window.opener.eCommerce.OnAssortmentGroupSelected(window, null, null)
            }
            else
            {
                var t = getTree();
                var checkedNodes = t.getCheckedNodes();
                var arrStr = '';

                for(i = 0; i < checkedNodes.length; i++)
                {
                    var node = checkedNodes[i];
                    var item = decodeURIComponent(node.itemID).evalJSON();

                    var id = item.nodeId;

                    if(arrStr != '')
                        arrStr += ',';

                    arrStr += id;
                }

                window.opener.location.href = "EcomAssortment_Edit.aspx?CMD=ATTACH_GROUP&ID=" + assortId + "&groupArr=" + arrStr;
            }

            window.close();
        }       

        function submitProduct(assortId)
        { 
            var cliEdit = '<%=Request("clientedit")%>';
            if(cliEdit == 'true')
            {
                window.opener.eCommerce.OnAssortmentProdSelected(window, null, null)
                window.close();
            }
            else
            {
                var t = getTree();
                var checkedNodes = t.getCheckedNodes();
                var arrStr = '';

                for(i = 0; i < checkedNodes.length; i++)
                {
                    var node = checkedNodes[i];
                    var item = decodeURIComponent(node.itemID).evalJSON();
                    var id = item.nodeId;
                    var varId = item.variantId;

                    if(arrStr != '')
                        arrStr += ',';

                    arrStr += id + ':' + varId;
                }

                window.opener.location.href = "EcomAssortment_Edit.aspx?CMD=ATTACH_PRODUCT&ID=" + assortId + "&productArr=" + arrStr
                window.close();
            }
        }

        function submitSearchProduct(assortId)
        {
            var cliEdit = '<%=Request("clientedit")%>';
            var arrStr = '';
            var inputs = $$('#Form1 div#DW_Ecom_GroupTree input');

            inputs.each(function (input)
            {
                if(input.checked)
                {                    
                    if(arrStr != '')
                        arrStr += ',';

                    arrStr += input.value;
                }
            });
            arrStr = '[' + arrStr +']';

            if(cliEdit == 'true')
            {
                window.opener.eCommerce.OnAssortmentProdSelected(null, arrStr);
                window.close();
            }
            else
            {
                window.opener.location.href = "EcomAssortment_Edit.aspx?CMD=ATTACH_PRODUCT&ID=" + assortId + "&productArr=" + arrStr
                window.close();
            }
        }

        function submitSearchGroup(assortId, groupid, groupname)
        {
            var cliEdit = '<%=Request("clientedit")%>';

            if(cliEdit == 'true')
            {
                window.opener.eCommerce.OnAssortmentGroupSelected(null, groupid, groupname);
                window.close();
            }
            else
            {
                window.opener.location.href = "EcomAssortment_Edit.aspx?CMD=ATTACH_GROUP&ID=" + assortId + "&groupArr=" + groupid
                window.close();
            }
        }

        function appendSearchedProductsToGroup(idMode) {
            var productString = "";

            var inputs = $$("#Form1 div#DW_Ecom_GroupTree input");
            inputs.each(function (input) {
                if (input.checked) {
                    var value = input.value.evalJSON();
                    var id = value.id;
                    var variantID = value.variantID;

                    var addString = "";
                    var itemId = "";
                    if (idMode == 1) {
                        if (variantID == "") {
                            addString = "[" + id + "]";
                            itemId = id;
                        }
                        else {
                            addString = "[" + id + "#" + variantID + "]";
                            itemId = id + "#" + variantID
                        }
                    }
                    else {
                        addString = "[p:" + id + "," + variantID + "]";
                        itemId = "p_" + id + "," + variantID;
                    }
                    if (productString.indexOf(addString) < 0) {
                        if (idMode == 1 && productString != "") productString += ';';
                        productString += addString;
                    }
                }
            });

            if (productString != "") {
                AddProductsToGroup(productString, '<%=Request("MasterGroupID")%>');
        }

    }

    function appendProductsToGroup(idMode) {
        var productString = "";
        var t = getTree();
        var checkedNodes = t.getCheckedNodes();

        for (i = 0; i < checkedNodes.length; i++) {
            var node = checkedNodes[i];
            var item = decodeURIComponent(node.itemID).evalJSON();

            var id = item.nodeId;
            var variantID = item.variantId;
            var addString = "";
            var itemId = "";
            if (idMode==1) {
                if (variantID == ""){  
                    addString = "[" + id + "]";
                    itemId = id;
                }
                else {
                    addString = "[" + id + "#" + variantID + "]";
                    itemId = id + "#" + variantID
                }
            }
            else 
            {
                addString = "[p:" + id + "," + variantID + "]";
                itemId = "p_" + id + "," + variantID;
            }
            if (productString.indexOf(addString) < 0) {
                if (idMode == 1 && productString != "") productString += ';';
                productString += addString;
            }
        }

        if (productString != "")
        {
            AddProductsToGroup(productString, '<%=Request("MasterGroupID")%>');
            }

        }
		
        function returnProductsToList(idMode) {
            //Loop checks
            var productImage = '<%= Dynamicweb.Core.UI.Icons.KnownIconInfo.ClassNameFor(Dynamicweb.Core.UI.Icons.KnownIcon.Archive, True, Dynamicweb.Core.UI.KnownColor.Default) %>';
            var variantImage = '<%= Dynamicweb.Core.UI.Icons.KnownIconInfo.ClassNameFor(Dynamicweb.Core.UI.Icons.KnownIcon.Archive, True, Dynamicweb.Core.UI.KnownColor.Secondary) %>';
            var container = "<%=Request("caller2")%>";
		    
		    var caller = eval("<%=Request("caller")%>");
		    var returnString = caller.value;
		    var doAppend = "<%=Request("doAppend") %>".toLowerCase() == "true" ? true : false;
		    
        	var inputs = $$("#Form1 div#DW_Ecom_GroupTree input");
        	inputs.each(function (input) {
        	    if (input.checked){
        	        var value = input.value.evalJSON();
        	        var id = value.id;
        	        var variantID = value.variantID;
        	        var nodeTxt = "";

        	        if (input.nextElementSibling){
        	            nodeTxt = input.nextElementSibling.innerHTML;  
        	        }else {
        	            nodeTxt = "";  
        	        }
                   
        	        var addString = "";
        	        var itemId = "";
        	        if (idMode==1) {
        	            if (variantID == ""){  
        	                addString = "[" + id + "]";
        	                itemId = id;
        	            }
        	            else {
        	                addString = "[" + id + "#" + variantID + "]";
        	                itemId = id + "#" + variantID
        	            }
        	        }
        	        else 
        	        {
        	            addString = "[p:" + id + "," + variantID + "]";
        	            itemId = "p_" + id + "," + variantID;
        	        }
        	        if (returnString.indexOf(addString) < 0) {
        	            if (idMode==1 && returnString != "") returnString += ';';
        	            returnString += addString;                        
        	            var image = variantID == "" ? productImage : variantImage;
        	            if (caller.addProduct && typeof caller.addProduct === 'function') {
        	                caller.addProduct(itemId, nodeTxt, image, container);
        	            }
        	            else if (window.opener.addProductDivContent && typeof window.opener.addProductDivContent === 'function') {
        	                window.opener.addProductDivContent(itemId, nodeTxt, image, container);
        	            }
        	        }  
        	    }
        	});
          
		    // Set caller.value
        	caller.value = returnString;
        	if(caller.onchange) caller.onchange();
        	
		    // Close window
        	setTimeout("window.close()",500);
        }

        function returnSelectedProducts() {
            var products = [];
            var t = getTree();
            var checkedNodes = t.getCheckedNodes();
            for (i = 0; i < checkedNodes.length; i++) {
                var node = checkedNodes[i];
                var item = decodeURIComponent(node.itemID.replace(/\+/g, ' ')).evalJSON();
                var id = item.nodeId;
                var variantId = item.variantId;
                var name = item.name;
                var number = item.number;                
                products.push({
                    id: id,
                    variantId: variantId,
                    name:  name,
                    number: number
                });
            }
            productsSelectedHandler(products)
        }

        function returnSelectedProductsFromList() {
            const products = [];
            const rows = getListCheckedItems();
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const id = row.readAttribute("data-product-id");
                const variantId = row.readAttribute("data-variant-id");
                const name = row.children[2].innerText;
                const number = row.children[3].innerText;
                products.push({
                    id: id,
                    variantId: variantId,
                    name:  name,
                    number: number
                });
            }
            productsSelectedHandler(products)
        }

        function getListCheckedItems() {
            return List.getSelectedRows("ProductList");
        }
        

        function productSelected(product) {
            var target = (event || {}).target;
            if ((target || {}).type === 'checkbox') {
                return false;
            }
            productsSelectedHandler([product]);
        }

        function productsSelectedHandler(products) {
            var caller = eval("<%=Request("caller")%>");
            caller(products);
        }
		
        function returnProductsAndGroups(idMode) {
            var callerID = "<%=Request("caller")%>";
		    var container = "<%=Request("caller2")%>";
		    var productImage = 'fa fa-archive color-default';
		    var variantImage = 'fa fa-archive color-secondary';
		    var groupImage = 'fa fa-folder-o color-folder';
		    var queryImage = 'md md md-filter-list';
		    var searchImage = '/Admin/Images/Ribbon/Icons/Small/search.png';
		    var caller = eval("<%=Request("caller")%>");
            var returnString = caller.value;
            var doAppend = "<%=Request("doAppend") %>".toLowerCase() == "true" ? true : false;
        	var eventName = '';

        	var t = getTree();
        	var checkedNodes = t.getCheckedNodes();

        	for (i = 0; i < checkedNodes.length; i++) {
        	    var node = checkedNodes[i];
        	    var item = decodeURIComponent(node.itemID).evalJSON();
		        
        	    id = item.nodeId;
	                
        	    // node is a product
        	    if (item.type == "PRODLIST") {
        	        eventName = 'EcomGroupTree:ProductsComplete';
        	        var variantID = item.variantId;
        	        var addString = "";
        	        var itemId = "";
        	        var image = '';
        	        if (idMode==1) {
        	            if (variantID == ""){  
        	                addString = "[" + id + "]";
        	                itemId = id;
        	            }
        	            else {
        	                addString = "[" + id + "#" + variantID + "]";
        	                itemId = id + "#" + variantID
        	            }
        	        }
        	        else 
        	        {
        	            addString = "[p:" + id + "," + variantID + "]";
        	            itemId = "p_" + id + "," + variantID;
        	        }
        	        if (returnString.indexOf(addString) < 0) {

        	            if (idMode == 1 && returnString != "") {
        	                returnString += ';';
        	            }

        	            returnString += addString;

        	            if (variantID == "") {
        	                image = productImage;
        	            } else {
        	                image = variantImage;
        	            }
        	            var itemData = {
        	                Id: itemId,
        	                Type: "p",
        	                ItemId: id,
        	                Text: node.name    	                        
        	            };

        	            if (caller.addProduct && typeof caller.addProduct === 'function') {
        	                caller.addProduct(itemId, node.name, image, container, itemData);
        	            }
        	            else if (window.opener.addProductDivContent && typeof window.opener.addProductDivContent === 'function') {
        	                window.opener.addProductDivContent(itemId, node.name, image, container, itemData);
        	            }
        	        }
        	    }
    		        
        	        // node is a group
        	    else if (item.type == "GROUPLIST") {
        	        eventName = 'EcomGroupTree:GroupsComplete';
        	        var getShopName = function (node, res) {
        	            if (node._p.name == "Root"){
        	                return " (" + node.name + ")";
        	            }
        	            else {
        	                return getShopName(node._p)
        	            }
        	        };
        	        var addString = "[g:" + id + "]";
        	        if (returnString.indexOf(addString) < 0) {
        	            returnString += addString;
        	            var groupsNameParenthesis = <%=(Dynamicweb.Security.UserManagement.License.IsModuleAvailable("eCom_MultiShopAdvanced") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("eCom_MultiShopAdvanced") AndAlso (Dynamicweb.Ecommerce.Shops.Shop.GetShops().Count > 1)).ToString().ToLower()%>?getShopName(node):"";
    		                var itemId = "g_" + id;
    		                var itemData = {
    		                    Id: itemId,
    		                    Type: "g",
    		                    ItemId: id,
    		                    Text: node.name + groupsNameParenthesis
    		                };
    		                if (caller.addProduct && typeof caller.addProduct === 'function') {
    		                    caller.addProduct(itemId, node.name + groupsNameParenthesis, groupImage, container, itemData);
    		                }
    		                else if (window.opener.addProductDivContent && typeof window.opener.addProductDivContent === 'function') {
    		                    window.opener.addProductDivContent(itemId, node.name + groupsNameParenthesis, groupImage, container, itemData);
    		                }
                        }
                    }
                    else if (item.type == "SMARTSEARCH") {
                        eventName = 'EcomGroupTree:SmartSearchComplete';
                        var addString = "[ss:" + id + "]";
                        if (returnString.indexOf(addString) < 0) {
                            returnString += addString;
                            var itemId = "ss_" + id;

                            var itemData = {
                                Id: itemId,
                                Type: "ss",
                                ItemId: id,
                                Text: node.name
                            };
                            if (caller.addProduct && typeof caller.addProduct === 'function') {
                                caller.addProduct(itemId, node.name, groupImage, container, itemData);
                            }
                            else if (window.opener.addProductDivContent && typeof window.opener.addProductDivContent === 'function') {
                                window.opener.addProductDivContent(itemId, node.name, searchImage, container, itemData);
                            }
                        }
                    }
                    else if (item.type == "QUERY") {
                        eventName = 'EcomGroupTree:QueriesComplete';
                        var addString = "[q:" + id + "]";
                        if (returnString.indexOf(addString) < 0) {
                            returnString += addString;
                            var itemId = "q_" + id;

                            var itemData = {
                                Id: itemId,
                                Type: "q",
                                ItemId: id,
                                Text: node.name
                            };
                            if (caller.addProduct && typeof caller.addProduct === 'function') {
                                caller.addProduct(itemId, node.name, groupImage, container, itemData);
                            }
                            else if (window.opener.addProductDivContent && typeof window.opener.addProductDivContent === 'function') {
                                window.opener.addProductDivContent(itemId, node.name, queryImage, container, itemData);
                            }
                        }
                    }
            }
		    
		    // Set caller.value
            caller.value = returnString;
            if (caller.onchange) {
                caller.onchange();
            }

		    // Fire event
            if (eventName !== '') {
                opener.window.document.fire(eventName);
            }
        	
		    // Close window
            setTimeout("window.close()",500);
            		    
        }

        function SetGroupID(gID, gName) {
            var theCallerA = eval("<%=Request("caller")%>");
    theCallerA.value = gID;

    var theCallerB = eval("<%=Request("caller2")%>");
			theCallerB.value = gName;

			window.close();
        }
			
        function reLoopGroups() {

            var CMD = "<%=Request("CMD")%>";
		    var doAppend = "<%=Request("doAppend") %>".toLowerCase() == "true" ? true : false;
		    var addVariant = CMD == "ProdItemProd" || CMD == "ShowProd" || CMD == "ShowGroupProdRel";
				
		    grpArray = doAppend ? eval("<%=Request("caller")%>").value : "";

		        if (CMD == "ProductSelectors" && !doAppend)
		            window.opener.ClearProdItems('<%=Request("id")%>_<%=Request("radio")%>');

                var t = getTree();
                var checkedNodes = t.getCheckedNodes();

                for (i = 0; i < checkedNodes.length; i++) {
                    var node = checkedNodes[i];
                    var item = decodeURIComponent(node.itemID).evalJSON();

                    if(CMD == "ShowGroupToGroupRel" && item.type == "SHOPLIST") {
                        if (confirmDeleteGroupRelations()) {
                            CMD = "DeleteAllParentGroups";
                            break;
                        }
                    }

                    if (!!item.nodeId){
                        var tmpA = grpArray.toLowerCase();
                        var tmpB = addVariant ? ("[" + item.nodeId + "," + item.variantId + "]").toLowerCase() : item.nodeId.toLowerCase();

                        if (tmpA.indexOf(tmpB) == -1) {
                            if (grpArray != "") grpArray += ';';
                            if (addVariant) grpArray += "[" + item.nodeId + "," + item.variantId + "]";
                            else grpArray += "[" + item.nodeId + "]";
                        }	
                    }
                }

                setCaller();
                var callerWin = window.opener ? window.opener : parent;

                if (CMD == "ShowProd" || CMD == "ShowGroupProdRel")
                    callerWin.AddRelatedRows();
                else if (CMD == "ProdItemGrp")
                    callerWin.AddProdItemRows('GRP','ADD');
                else if (CMD == "ProdItemProd")
                    callerWin.AddProdItemRows('PROD','ADD');
                else if (CMD == "ShowGroupEditor")
                    callerWin.ProductMultiGroupsAppend("<%=Request("caller2")%>");
			    else if (CMD == "DeleteAllParentGroups")
			        callerWin.DeleteAllGroups();
			    else if (CMD == "ShowGroupSearchRel")
			        setTimeout(function(){callerWin.AddGroupRelatedSearches();}, 400);
			    else
			        setTimeout(function(){callerWin.AddGroupRows('<%=Request("id")%>');}, 400);

    setTimeout("window.close()",500);
}
		
function AddSingleGroupToProduct(groupId, productId) {
    hideAddGroupsButton();
    showLoad();
		
    grpArray = groupId;
    setCaller();
    var callerWin = window.opener ? window.opener : parent;
    callerWin.AddGroupRows(productId);
		    
    setTimeout("window.close()",500);
}
		
        function setCaller() {
            if (grpArray != "") {
                var theCaller = eval("<%=Request("caller")%>");
		        theCaller.value = grpArray;
		    }	
        }
		
        function getCallerValue() {
            var theCaller = eval("<%=Request("caller")%>");
		    return theCaller.value;
		}
		
		function confirmDeleteGroupRelations() {
		    return confirm("<%=Dynamicweb.SystemTools.Translate.JsTranslate("Selecting the shop will remove the group from all other groups. Do you wish to continue?")%>");
		}

		function ProductCaller(prodID, variantID, prodName) { 
            if (prodID != "") {
                var caller = eval("<%=Request("caller")%>");
                if (caller && caller.updateProductEditor && typeof caller.updateProductEditor === 'function') {
                    var container = "<%=Request("caller2")%>";
                    caller.updateProductEditor(container, prodID, variantID, prodName);
                }
                else {
                    var Namestr = replaceSubstring("<%=Request("caller")%>", "DW_REPLACE_", "Name_");
                    var NameCaller = eval(Namestr);
                    if (NameCaller) NameCaller.value = prodName;

                    var VariantIDstr = replaceSubstring("<%=Request("caller")%>", "DW_REPLACE_", "VariantID_");
                    var VariantCaller = eval(VariantIDstr);
                    if (VariantCaller) VariantCaller.value = variantID;

                    var IDstr = replaceSubstring("<%=Request("caller")%>", "DW_REPLACE_", "ID_");
                    var invokeOnChangeOnID = "<%=Request("invokeOnChangeOnID") %>";
                    var IDCaller = eval(IDstr);
                    IDCaller.value = prodID;
                    if (invokeOnChangeOnID) {
                        try {
                            IDCaller.onchange();
                        } catch (e) { }
                    }
                }
			}
			
            window.close();
        }
		
        function ProductListCaller(pageUrl) {
            alert(pageUrl);
            if (pageUrl != "") {
            }	
        }		

        function SetGroupID(gID, gName) {
            var theCallerA = eval("<%=Request("caller")%>");
		    theCallerA.value = gID;

		    var theCallerB = eval("<%=Request("caller2")%>");
			theCallerB.value = gName;

			var invokeOnChangeOnID = "<%=Request("invokeOnChangeOnID") %>";

		    if (invokeOnChangeOnID) {
		        try {
		            theCallerA.onchange();
		        } catch (e) { }
		    }

		    window.close();
        }
		
        function AddProductToGroup(pID, pGrpID) {
            showLoad();
            <%=AddProductToGroupScript()%>
        }

        function AddProductsToGroup(prodArr, pGrpID) {
            showLoad();
            <%=AddProductsToGroupScript()%>
		}
		
        function AddGroupToGroup(grpID, grpIDTo) {
            showLoad();     
            <%=GetAddToGroupScript()%>
		}

		//-->
    </script>
</head>
<body>
    <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
    <div class="search-box">
        <asp:Literal ID="BoxSearch" runat="server"></asp:Literal>
    </div>
    <form id="Form1" runat="server">
        <input type="hidden" runat="server" id="FromPIM" name="FromPIM">
        <input type="hidden" runat="server" id="DisabledProducts" name="DisabledProducts">
        <%If CMD = ProductsSelectorCommand OrElse CMD = ProductsSelectorListCommand Then %>
            <input type="hidden" name="searchField" value="<%=Request("searchField") %>"/>
        <% End If %>        
        <dw:Overlay ID="screenLoaderOverlay" runat="server"></dw:Overlay>
        <div id="DW_Ecom_GroupTree">
            <dw:Tree ID="Tree1" runat="server" ShowSubTitle="False" ShowRoot="false" OpenAll="false"
                UseSelection="true" AutoID="true" UseCookies="false" LoadOnDemand="true" UseLines="true">
                <dw:TreeNode ID="Root" NodeID="0" runat="server" Name="Root" ParentID="-1" />
            </dw:Tree>
            <dw:Infobar ID="ManyResults" runat="server" Message="The search causes too many results, show only first 1000 products!" Visible="false" />
            <dw:List ID="ProductList" runat="server" ShowTitle="false" AllowMultiSelect="true" ShowPaging="true" NoItemsMessage="Ingen produkter fundet..."  Visible="false">
                <Columns>
                    <dw:ListColumn ID="Image" Name="Image" EnableSorting="false" /> 
                    <dw:ListColumn ID="Name" Name="Name" EnableSorting="true" />
                    <dw:ListColumn ID="Number" Name="Number" EnableSorting="true" />
                </Columns>
            </dw:List>
            <asp:Literal ID="productSearchList" runat="server"></asp:Literal>
            <asp:Button ID="SubmitCheckBoxForm" Style="display: none;" runat="server"></asp:Button>
        </div>
    </form>
</body>
</html>
