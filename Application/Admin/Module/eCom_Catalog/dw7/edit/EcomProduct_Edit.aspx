<%@ Page Language="vb" AutoEventWireup="false" EnableEventValidation="false"
    ValidateRequest="false" CodeBehind="EcomProduct_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.ProductEdit" %>

<%@ Import Namespace="Dynamicweb.Ecommerce.Products" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Security" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<asp:content id="Header" contentplaceholderid="HeadHolder" runat="server">

    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <script type="text/javascript" src="../js/hotkeys.js"></script>
    <script type="text/javascript" src="../js/queryString.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/RteValueObserver.js"></script>
    <script type="text/javascript" src="../js/ProductImageBlocks.js"></script>
    <script type="text/javascript" src="../js/productEdit.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Validation.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/List/List.js"></script>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
    <script type="text/javascript" src="/Admin/Filemanager/Browser/FileList.js"></script>
    <link rel="Stylesheet" type="text/css" href="../css/ProductImageBlocks.css" />
    <link rel="Stylesheet" type="text/css" href="../css/productEdit.css" />


    <%If Dynamicweb.Context.Current.Request("VariantID") <> "" Then%>
    <style type="text/css">
        body {
            top: 0px;
            margin-top: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
            margin-left: 0px;
        }
    </style>
    <% End If%>

    <style type="text/css">
        .cropText {
            display: block;
            width: 400px;
            text-overflow: ellipsis;
            white-space: nowrap;
            overflow: hidden;
        }

        .dw-rte-readonly {
            border: 1px solid #ABADB3 !important;
            border-collapse: separate;
            border-radius: 2px;
            background-color: #EBEBE4;
            color: #545454;
        }

        .short-descr .dw-rte-readonly {
            width: 100% !important;
            height: auto !important;
            min-height: 100px;
        }

        .long-descr .dw-rte-readonly {
            width: 100% !important;
            height: auto !important;            
            min-height: 200px;
        }
    </style>

    <!-- CUSTOM CSS FOR THE PRODUCT EDIT PAGE -->
    <style>
        #primaryProductSettings fieldset {
            margin: 0;
        }
        
        .row {
            display: -webkit-box;
            display: -ms-flexbox;
            display: flex;
            -ms-flex-wrap: wrap;
            flex-wrap: wrap;
            margin-right: -15px;
            margin-left: -15px;
            box-sizing: border-box;
        }

        @media (min-width: 1450px) {
            .card-section-4 {
                -webkit-box-flex: 0;
                -ms-flex: 0 0 33.333333%;
                flex: 0 0 33.333333%;
                max-width: 33.333333%;
            }

            .card-section-6 {
                -webkit-box-flex: 0;
                -ms-flex: 0 0 50%;
                flex: 0 0 50%;
                max-width: 50%;
            }

            .card-section-8 {
                -webkit-box-flex: 0;
                -ms-flex: 0 0 66.666666%;
                flex: 0 0 66.666666%;
                max-width: 66.666666%;
            }

            .card-section-12 {
                -webkit-box-flex: 0;
                -ms-flex: 0 0 100%;
                flex: 0 0 100%;
                max-width: 100%;
            }
        }

        [class*='card-section-'] {
            position: relative;
            width: 100%;
            min-height: 1px;
            padding-right: 15px;
            padding-left: 15px;
            box-sizing: border-box;
        }

        .card-section-4.xs {
            -webkit-box-flex: 0;
            -ms-flex: 0 0 33.333333%;
            flex: 0 0 33.333333%;
            max-width: 33.333333%;
        }

        .card-section-8.xs {
            -webkit-box-flex: 0;
            -ms-flex: 0 0 66.666666%;
            flex: 0 0 66.666666%;
            max-width: 66.666666%;
        }

        @media (max-width: 1450px) {
            [class*='card-section-']:not(.xs) {
                -webkit-box-flex: 0;
                -ms-flex: 0 0 99%;
                flex: 0 0 99%;
                max-width: 99%;
            }
        }

        .form-group {
            min-height: 30px;
            width: 100%;
            margin-bottom: 10px;
        }

            .form-group .pull-right.std {
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
            border-left: 0px;
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
            width: 100%;
        }

        .toggle-switch.active-switch {
            margin-top: 6px;
            margin-bottom: 26px;
        }

        div.product-id {
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

        .validator-container,
        .number-validator-container,
        .link-validator-container,
        .image-validator-container,
        .RTE-validator-container {
            position: relative;
        }

        .validation-error {
            position: absolute;
            right: 6px;
            color: #F44336;
            font-size: 20px;
            top: 6px;
        }
        
        .RTE-validator-container .validation-error{
            top: 28px;
        }

        .formsTable td > .form-group.number-validator-container {
            width: 111px;
        }

        .formsTable td > .form-group.number-validator-container input {
            width: 79px;
        }

        .number-validator-container .validation-error{
            right:36px;
        }

        .link-validator-container .validation-error{
            right:calc(40% + 6px);
        }

        .image-validator-container .validation-error{
            left: 276px;
            top: 5px;
        }

        #ProductFieldsContainer  .validator-container .validation-error{
            left: 514px;
            top: 10px;
        }
        
        #ButtonHelpSmall {
            display:none;
        }

        @media (max-width: 1440px) {
            #tabarea1 .ribbon-tabarea-cell:nth-of-type(6) {
                display:none;
            }

            #ButtonHelpSmall {
                display:block;
            }
        }

        #tabitem4 {            
            display:none;
        }

        @media (max-width: 1365px) {
            #tabarea1 .ribbon-tabarea-cell:nth-of-type(5),
            #tabarea1 .ribbon-tabarea-cell:nth-of-type(4) {
                display:none;
            }

            #tabitem4 {
                display:block;
            }
        }
    </style>

    <asp:Literal ID="CurrencyOptions" runat="server"></asp:Literal>

    <script type="text/javascript">
        strHelpTopic = 'ecom.productman.product.edit';

        var useUnit = true;
        var priceStandard = false;
        var priceExtended = false;
        priceStandard = true;
		<%If Dynamicweb.Security.Authorization.UserHasAccess("eCom_PricingExtended", "") Then%>
        priceExtended = true;
        <%End If%>
    </script>

    <script type="text/javascript" language="JavaScript" src="../images/functions.js"></script>
    <script type="text/javascript" language="JavaScript" src="../images/addrows.js"></script>
    <script type="text/javascript" language="JavaScript" src="../images/layermenu.js"></script>
    <script type="text/javascript" language="JavaScript" src="../Wizard/wizardstart.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/images/DateSelector.js"></script>
    <script src="/Admin/FileManager/FileManager_browse2.js" type="text/javascript"></script>
    <script src="/Admin/Link.js" type="text/javascript"></script>
    <script type="text/javascript">        function html() { return true; }</script>
    <script type="text/javascript">

        var aspForm;

        $(document).observe('dom:loaded', function() {
            aspForm = document.forms[0];
            document.onmousemove = getMouseXY;

            if(_tabNum && _tabNum == '1'){ //check if default tab loaded.
                window.focus(); // for ie8-ie9
                document.getElementById('<%=Name.ClientID %>').focus();
            }

            var deferredStretchedContainerRecalc = dwGlobal.debounce(function() {
                Dynamicweb.Controls.StretchedContainer.stretchAll();
                Dynamicweb.Controls.StretchedContainer.Cache.updatePreviousDocumentSize();
            }, 200);

            Ribbon.add_stateChanged(function (sender, args) {
                deferredStretchedContainerRecalc();
            });
        });

        $(document).observe('keydown', function (e) {
            if (e.keyCode == 13) {
                var srcElement = e.srcElement ? e.srcElement : e.target;
                if (srcElement.type != 'textarea') {
                    e.preventDefault();
                }
            }
        });

        function SaveProduct() {
            (function() {
                try {
                    if (typeof CKEDITOR != 'undefined') {
                        var editorName;
                        for (editorName in CKEDITOR.instances) {
                            CKEDITOR.instances[editorName].updateElement();
                        }
                    }
                } catch (ex) {}
            }());

            if (window.Page_ClientValidate) {
                validationResult = Page_ClientValidate("");
                if(!validationResult){
                    return false;
                }
            }

			
            if(!ProductEdit.validate())
            {
                return false;
            }
			
            var pname = "<%=Name.ClientID %>";

            if($(pname).value.trim().length == 0){
                Ribbon.radioButton('RibbonBasicButton', 'ctl00$ContentHolder$RibbonBasicButton', 'productTabs');
                ribbonTab('GENERAL', 1);
                return;
            }

            FillDivLayer("LOADING", "", "SAVE");

			<%If VariantProduct Then%>
            window.name = "VariantWin";
            aspForm.target = "VariantWin";
			<%End If%>

            submitPricePrioritySort();
            submitCurrentTab();

            if ('<%=Dynamicweb.Context.Current.Request("updateSimpleVariant") %>' && parent.updateSimpleVariant) {
                parent.updateSimpleVariant();
            }

            return true;
        }

        function submitPricePrioritySort() {
            try {
                for (i = 0; i < aspForm.MatrixSelected.length; i++) {
                    aspForm.MatrixSelected.options[i].selected = true;
                }
            } catch(e) {
                //Nothing
            }
        }

        function DeleteProduct() {
            var Message;
            if (isDefaultLang)
                Message = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Slet?")%>';
            else
                Message = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("This will delete the product across all languages. Use delocalize to remove product from selected language.") %>';

            if (confirm (Message)) {
                FillDivLayer("LOADING", "", "SAVE");

				<%If VariantProduct Then%>
                window.name = "VariantWin";
                document.getElementById('Form1').target = "VariantWin";
				<%End If%>
                return true;
            }
            else
                return false;
        }
        function Delocalize() {
            var Message = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Delocalize?")%>';
            if (confirm (Message)) {
                FillDivLayer("LOADING", "", "SAVE");

				<%If VariantProduct Then%>
                window.name = "VariantWin";
                document.getElementById('Form1').target = "VariantWin";
				<%End If%>
                return true;
            }
            else
                return false;
        }

        function gotoPage(url) {
            document.location.href = url;
        }

        function browseDetailArchive(type, cnt) {
            var elem = document.getElementById("DETAIL_Value[" + type + "]" + cnt);
            browseFullPath("DETAIL_Value[" + type + "]" + cnt + "","",elem.value);
        }


        function AddToGroups(fieldName) {
            if (fieldName == "addGroupsChecked") {
                ActivateTabClick('Tab5');
                closeAllRollerMenu();
                TabLoader('5');
            }

			<%If ProdIdEncoded <> "" Then%>
            if (prodGroupAdd) {
                var caller = "parent.document.getElementById('Form1')."+ fieldName;
                
                dialog.setTitle('ProductEditMiscDialog', '<%=Translate.Translate("Add group relation")%>');
		        dialog.show('ProductEditMiscDialog', "EcomGroupTree.aspx?CMD=ShowGroupRel&MasterProdID=<%=ProdIdEncoded%>&caller="+ caller);
		    }
			<%Else%>
            alert("<%=Dynamicweb.SystemTools.Translate.JsTranslate("You need to save the product...")%>")
            <%End If%>			
        }

        function AddNewManufacturer() {
            dialog.show('NewManufacturerDialog', '/Admin/module/eCom_Catalog/dw7/Edit/EcomManu_Edit.aspx?isPopUp=true');
        }

        function UpdateManufacturerSelectBox(newList, selectOption) {
            selectOption = selectOption || "";
            var container = $('ManufacturerId');
            if (!container || !newList || newList.length < 1) {
                return;
            }
                        
            for (var i = container.options.length - 1; i > 0; i--) { // Do not remove first option
                container.options[i].remove();
            }
            
            for (var i = 0; i < newList.length; i++) {
                var option = document.createElement("option");
                option.value = newList[i].Key;
                option.textContent = newList[i].Value;
                option.selected = (option.value == selectOption);
                container.appendChild(option);
            }            
        }

        function closeMiscDialog(){
            dialog.hide("ProductEditMiscDialog");
            dialog.set_contentUrl("ProductEditMiscDialog", "");
        }

        function CheckPrimaryDWRow(chk, rowID) {
            var iconEl = chk.select(".state-icon")[0];
            var onCss = iconEl.getAttribute("data-state-on");
            var offCss = iconEl.getAttribute("data-state-off");
            if (!iconEl.hasClassName(onCss)) {
                var inputs = $$("table .state-icon");
                inputs.each(function (item) {
                    item.removeClassName(onCss);
                    item.addClassName(offCss);
                });
                $('GRPREL_PRIMARY_ID').value = rowID;
            }
            else {
                $('GRPREL_PRIMARY_ID').value = "";
            }
            iconEl.toggleClassName(onCss);
            iconEl.toggleClassName(offCss);
        }

        function CheckDeleteDWRow(rowID, rowCount, layerName, ProductId, prefix, arg1, arg2, message) {
            var totalGroups = parseInt(document.getElementById("DWRowNextLine"+ prefix).value);
            if (parseInt(totalGroups) <= 2) {
                alert("<%=Dynamicweb.SystemTools.Translate.JsTranslate("Kan ikke slette sidste gruppe!")%>")
        } else {
            DeleteDWRow(rowID,rowCount,layerName,ProductId,prefix,arg1,arg2, message);
        }
    }

    function AddDetailLine(method, type) {
        ActivateTabClick('Tab3');
        closeAllRollerMenu();

        if (prodDetailAdd) {
            enableClick = true;
            if (method == "ADD") {
                RemoveNoneline("DWRowNoDetailLine"+ type);
                closeRollerMenu('DetailLayer');

                if (type == "0") {
                    AddDWRowLine("DETAILURL", "_E_"+ type);
                } else {
                    AddDWRowLine("DETAILTXT", "_E_"+ type);
                }
            }
            if (method == "SHOW") {
                doGenerelRollerMenu('DetailLayer');
            }

        }
    }

        function SetDefaultDetail(selected) {
        document.getElementById("ProductImageDefaultChanged").value = "true";
        document.getElementById("ProductImageDefault").value = "";
        if (selected.checked){
            var checkboxes = document.getElementsByName("DETAIL_Default");
            for(var i=0;i<checkboxes.length;i++){
                var checkbox = checkboxes[i];
                if (!checkbox.disabled) {
                    checkboxes[i].checked = false;
                }
            }
            selected.checked = true;
            var selectedImage = document.getElementById("DETAIL_Value[0]"+selected.value);
            var imageExtensions = [".gif", ".jpg", ".jpeg", ".psd", ".bmp", ".png", ".tiff", ".tif", ".eps", ".ai", ".pdf", ".webp"];
            if(selectedImage && selectedImage.value && imageExtensions.some(function(extension, idx, items){ return selectedImage.value.endsWith(extension); })){
                document.getElementById("ProductImageDefault").value = selectedImage.value;
            }
        }
        UpdateProductImage();
    }


    function DelPropertyLine(method, propID, rowID, prefix, typeId) {
        CallerForDeleteDWRow(propID, rowID, method, propID, prefix, typeId, '');
    }

    function CallerForDeleteDWRow(DWRowid, rowID, typeStr, methodID, prefix, arg1, arg2) {
        showMessage = false;
        var Message = "<%=Translate.JSTranslate("Slet?")%>";
        if (confirm (Message)) {
            DeleteDWRow(DWRowid, rowID, typeStr, methodID, prefix, arg1, arg2);
        }
        showMessage = true;
    }

    function SelectAllVariants() {
        for (var i = 0; i < document.getElementById('Form1').VARCOMBO_singleVarOptLine.length;i++) {
            document.getElementById('Form1').VARCOMBO_singleVarOptLine[i].checked = true;
        }
    }
    function UnSelectAllVariants() {
        for (var i = 0; i < document.getElementById('Form1').VARCOMBO_singleVarOptLine.length;i++) {
            document.getElementById('Form1').VARCOMBO_singleVarOptLine[i].checked = false;
        }
    }

    function changeImgType(mMode, picID, mType) {
        try {
            if (mType == "VAROPT") {
                var srcStr = document.getElementById(picID).getAttribute("src");
                var fileName = GetFileNameFromUrl(srcStr);

                if (fileName == "empty.gif") {
                    srcStr = "../images/check.gif";
                } else {
                    srcStr = "../images/empty.gif";
                }
            }

            if (mType == "VAREXISTS") {
                if (mMode == "TRUE") {
                    srcStr = "../images/editvariantasprod_small.gif";
                } else {
                    srcStr = "../images/editvariantasprod_small_dim.gif";
                }
            }

            if (mType == "VAREXISTS") {
                if (window.dialogArguments) {
                    dialogArguments.document.getElementById(picID).setAttribute("src",srcStr);
                } else {
                    window.parent.document.getElementById(picID).setAttribute("src",srcStr);
                }

				<%If Request("DelVariant") = "1" Then%>
                if (mMode == "FALSE") {
            
                    if (parent) {
                        parent.dialog.hide('ProductEditMiscDialog');
                        parent.dialog.hide('VariantsDialog');
                        var frame = parent.document.getElementById("VariantDialogFrame") ||
                            parent.document.getElementById("ProductEditMiscDialogFrame");
                        if (frame) {
                            frame.writeAttribute('src', "");
                        }
                    } else {
                        window.close();
                    }
            
                }
				<%End If%>
            } else {
                document.getElementById(picID).setAttribute("src",srcStr);
            }

        } catch(e) {
            //Nothing
        }

		<%If Request("closeVariantWindow") = "true" Then%>
        if (parent) {
            parent.dialog.hide('VariantDialog');
            parent.closeVariantDialog();
            var frame = parent.document.getElementById("VariantDialogFrame") ||
                parent.document.getElementById("ProductEditMiscDialogFrame");
            if (frame) {
                frame.writeAttribute('src', "");
            }
        } else {
            window.close();
        }
		<%End If%>
    }
        
        function closeVariantDialog() {
            dialog.hide('ProductEditMiscDialog');
            var frame = document.getElementById('VariantsDialogFrame');
            if (frame) {
                var iFrameDoc = (frame.contentWindow || frame.contentDocument);
                new iFrameDoc.overlay('ProductEditOverlay').show();
                iFrameDoc.location.reload();
            }
        }

        function changeImgFileName(picID) {
            var srcStr = document.getElementById(picID).getAttribute("src");
            var fileName = GetFileNameFromUrl(srcStr);
            return fileName;
        }

        function FillDivLayer(typeStr, fillData, fillLayer) {
            var fillStr = "",
                doc = Dynamicweb.Ajax.Document.get_current(),
    	        collectionHelper = Dynamicweb.Utilities.CollectionHelper,
                typeHelper = Dynamicweb.Utilities.TypeHelper;

            if (typeStr == "LOADING") {
                fillStr = '<asp:Literal id="LoadBlock" runat="server"></asp:Literal>';
            }


            if (typeStr == "DWNONE") {
                fillStr = '<br />';
            }

            if (fillData != "") {
                fillStr = fillData;
            }
            if (fillLayer == "PRODGRPREL") {
                doc.getElementById('ProductGrpRelData').innerHTML = fillStr;
            }
            if (fillLayer == "VARGRP") {
                doc.getElementById('VariantGroupRelData').innerHTML = fillStr;
            }
            if (fillLayer == "VAROPT") {
                doc.getElementById('VariantOptionRelData').innerHTML = fillStr;
            }
            if (fillLayer == "PRODITEM") {
                doc.getElementById('ProductItemBlock').innerHTML = fillStr;
            }
            if (fillLayer == "PRODDESC") {
                doc.getElementById('ProductDescBlock').innerHTML = fillStr;
    	
            }
            if (fillLayer == "PRODDESCEDITOR") {
                doc.getElementById('ProductCustomFieldsEditor').innerHTML = fillStr;

                try {
                    var sDescr = eval(document.getElementsByName('ShortDescription'));
                    sDescr.focus();
                } catch(e) {
                    //Nothing
                }
            }

                if (fillLayer == "SAVE") {
                    doc.getElementById('PageHolderStart').innerHTML = fillStr;

                    for (var i = 0; i < 12; i++) {
                        try {
                            doc.getElementById('PageContent'+ i).style.display = 'none';
                        } catch(e) {
                            //Nothing
                        }
                    }

                    doc.getElementById('PageHolderStart').innerHTML = fillStr;
                }

                if(_onloaded != null)
                {
                    _onloaded();
                    _onloaded = null;
                }
            }

            function updateVariantCombinationsText(count){
                var span = document.getElementById("varinatCombinationsCount");
                if(span){
                    span.innerHTML = count;
                }
        }

        function AddGroupRows(id) {
            closeMiscDialog();
            FillDivLayer('LOADING', '', 'PRODGRPREL');

            var grpArray = document.getElementById('Form1').addGroupsChecked.value;
            var prodId = '';

            if (typeof b == 'undefined') {
                prodId = '<%=ProdIdEncoded%>';
                  } else {
                      prodId = id;
                  }
                  setTimeout("AddDWRowFromArry('PRODGROUPS','" + prodId + "', '" + grpArray + "', '../Edit/', '<%=Request("GroupID")%>', '');", 500);
        }

        function removeFromField(grpID) {
            var tmpList = ""
            var listGrp = document.getElementById('Form1').oldGroupsChecked.value;

            tmpList = replaceSubstring(listGrp, "[" + grpID + "];", "")
            tmpList = replaceSubstring(tmpList, "[" + grpID + "]", "")

            document.getElementById('Form1').oldGroupsChecked.value = tmpList;
        }

        function ReloadPage(pageID, tabId) {
            if (pageID != "") {
                document.location.href = "EcomProduct_Edit.aspx?Tab="+ tabId +"&ID="+ pageID;
            }
        }

        function changeDelBut(objID, counter, calc) {
            document.getElementById('CALCDELBUT'+ objID).src = "../images/editprice_small.gif";

            //EnableCurrencyPriceEdit(counter,calc);

            document.getElementById('CALCHREF'+ objID).removeAttribute("href");
            document.getElementById('CALCHREF'+ objID).href = "javascript:changeDelBut('"+ objID +"','"+ counter +"','"+ calc +"')";
        }


        function changeCheckedVariantCount(elem,amount) {
            var oldValue = parseInt(document.getElementById('prodVariantCheckedCnt').value);
            var newValue = 0;

            if (elem.checked == false) {
                newValue = oldValue - parseInt(amount);
            } else {
                newValue = oldValue + parseInt(amount);
            }

            document.getElementById('prodVariantCheckedCnt').value = newValue;
        }

        function uncheckCheckBox(cbElem){
            if(cbElem.checked)
                cbElem.checked = false;
        }

        function addVariantOption(group, param) {
            addVariantOption.dialogID = 'AddVariantOption';

            if(!addVariantOption.dialog) {
                addVariantOption.dialog = $(addVariantOption.dialogID);
            }

            if (!addVariantOption.input) {
                addVariantOption.input = addVariantOption.dialog.select('input')[0];
            }

            addVariantOption.input.value = param.item.text;
            addVariantOption.param = param;
            addVariantOption.group = group;

            if (confirm('<%=Translate.Translate("Variant option does not exist. Do you want to create it?")%>')) {
                dialog.show(addVariantOption.dialogID);
                addVariantOption.input.focus();
            } else {
                param.cancel();
            }
        }
    
        function addVariantOptionComplete() {
            var over = new overlay('ProductEditOverlay');
            if (addVariantOption.param) {

                if (!addVariantOption.input.value) {
                    alert('<%= Translate.Translate("Name can not be empty.")%>')
                    return;
                }

                new Ajax.Request('/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx', {
                    method: 'GET',
                    parameters: {
                        'CMD' : 'CreateVariantOption',
                        'ID' : '<%=ProdIdEncoded%>',
                        'LangID' :'<%=Ecommerce.Common.Context.LanguageID %>',
                        'VariantGroupID' : addVariantOption.group,
                        'VariantOptionName' : addVariantOption.input.value
                    },
                    onCreate: function () {
                        over.show();
                    },
                    onSuccess: function (transport) {
                        if (transport.responseText) {
                            addVariantOption.param.complete({
                                text: addVariantOption.input.value,
                                value: transport.responseText
                            });
                        } else {
                            alert('<%=Translate.Translate("Creation is FAILED.")%>');
                            addVariantOption.param.cancel();
                        }
                    },
                    onFailure: function () {
                        alert('<%=Translate.Translate("Unexpected internal error.")%>');
                        addVariantOption.param.cancel();
                    },
                    onComplete: function () {
                        setTimeout(function() {
                            dialog.hide(addVariantOption.dialogID);
                            over.hide();
                        }, 100);
                    }
                });
            }
        }

        function addVariantOptionCancel() {
            if (addVariantOption.param) {
                dialog.hide(addVariantOption.dialogID);
                addVariantOption.param.cancel();
            }
        }

        function sortVariant(a, b, key) {
            var column,
                option,
                vA = a, 
                vB = b, 
                helper = Dynamicweb.Utilities.CollectionHelper,
                func = function (v1, v2) {
                    if (v1 > v2) {
                        return 1;
                    }
                        
                    if (v1 < v2) {
                        return -1;
                    }
                    
                    return 0;
                };

            // memorize columns
            if (!sortVariant.cache) {
                sortVariant.cache = new Dynamicweb.Utilities.Dictionary();
                helper.forEach(variantCombinations_EditableList.get_columns(), function(c) {
                    var options;
                
                    if (c.editorMetadata) {
                        options = new Dynamicweb.Utilities.Dictionary();

                        helper.forEach(c.editorMetadata.options || [], function (o){
                            options.add(o.value, o);
                        });

                        sortVariant.cache.add(c.name, options);
                    }
                });
            }

            column = sortVariant.cache.get(key);

            if (column) {
                option = column.get(a);
            
                if (option) {
                    vA = option.text;
                }

                option = column.get(b);
     
                if (option) {
                    vB = option.text;
                }
            }

            return func(vA, vB);
        }

        function updateSimpleVariant() {
        }

        function gotoVariant(prodId, groupID, variantId, found, callback) {
            var screenWidth = screen.width;
            var screenHeight = screen.height;
            var minusWidth = (screenWidth / 4);
            var minusHeight = (screenHeight / 4);

            var width = screenWidth - minusWidth;
            var height = screenHeight - minusHeight;

            var left = (screenWidth - width)/2;
            var top = (screenHeight - height)/2;

            var variantPage = "EcomProduct_Edit.aspx?ID="+ prodId +"&GroupID="+ groupID +"&VariantID="+ variantId + "&Found=" + found + "&ecom7master=hidden&updateSimpleVariant=true";

            dialog.setTitle('ProductEditMiscDialog', '<%=Translate.Translate("Variant edit")%>');
            dialog.show('ProductEditMiscDialog', variantPage);
       }

       function EnableCurrencyMatrixPrice(LineNumb, Currency) {
           var hideField =	document.getElementById('PRICEMATRIXLINES_Hide'+ LineNumb +'_'+ Currency);
           var amountField = document.getElementById('PRICEMATRIXLINES_Amount'+ LineNumb +'_'+ Currency);

           if (hideField.value == "1") {
               amountField.focus();
               if (navigator.appName.indexOf("Microsoft") != -1) {
                   amountField.style.filter = "";
               }else {
                   amountField.style.opacity = "1";
               }

               if (document.selection) {
                   var amountValue = amountField.value;
                   amountField.focus();
                   amountField.value = "";
                   sel = document.selection.createRange();
                   sel.text = amountValue;
               }
               amountField.select();

               hideField.value = "0";
           } else {
               //amountField.onfocus = "";
               //amountField.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=30)progid:DXImageTransform.Microsoft.BasicImage(grayscale=1)";

               //hideField.value = "1";
           }

       }

       function DisableCurrencyMatrixPrice(LineNumb, Currency, checkCtrl, e) {
           //var evtobj = window.event ? window.event : window.Event
           if (e.ctrlKey == true || checkCtrl == false) {
               var hideField =	document.getElementById('PRICEMATRIXLINES_Hide'+ LineNumb +'_'+ Currency);
               var amountField = document.getElementById('PRICEMATRIXLINES_Amount'+ LineNumb +'_'+ Currency);
               var oldAmountField = document.getElementById('PRICEMATRIXLINES_OldAmount'+ LineNumb +'_'+ Currency);

               amountField.value = oldAmountField.value;
               if (navigator.appName.indexOf("Microsoft") != -1) {
                   amountField.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=30)progid:DXImageTransform.Microsoft.BasicImage(grayscale=1)";
               }else {
                   amountField.style.opacity = "0.3";
               }
               hideField.value = "1";
           } else {
               return false;
           }
       }

       function checkLength(LineNumb, Currency, e) {
           var amountField = document.getElementById('PRICEMATRIXLINES_Amount'+ LineNumb +'_'+ Currency);

           if (amountField.length <= 0 || amountField.value == 0) {
               amountField.value = 0;
               DisableCurrencyMatrixPrice(LineNumb, Currency, false, e);
           }
       }


       function changeRowColor(objRow, method){
           if (method == "over") {
               objRow.style.backgroundColor='#f3f1e7';
           } else {
               objRow.style.backgroundColor='';
           }
       }

       function changeRowColorClass(objRow, method){
           if (method == "over") {
               objRow.className = 'OutlookItemOver';
           } else {
               objRow.className = 'OutlookItem';
           }
       }

       function help(){
		<%=Dynamicweb.SystemTools.Gui.Help("", "ecom.productlist.edit", "en") %>
        }

    </script>

    <script type="text/javascript">        

        function fillReleatedProducts(grpId, fillStr) {
            var sort = document.getElementById("SORTEDLIST_" + grpId)
            sort.innerHTML = fillStr;
        }

        function MoveSortUp(grpId){
            try {
                var elem = document.getElementById("ElemSort"+ grpId)
                ID = elem.selectedIndex;

                if (ID != 0) {
                    val1 = elem[ID - 1].value;
                    val2 = elem[ID - 1].text;
                    elem.options[ID - 1] = new Option(elem[ID].text, elem[ID].value);
                    elem.options[ID] = new Option(val2, val1);
                    elem.options[ID - 1].selected = true;
                    ToggleImage(ID - 1,grpId);
                }
            } catch(e) {
                alert(e);
                //Nothing
            }
        }

        function MoveSortDown(grpId){
            try {
                var elem = document.getElementById("ElemSort"+ grpId)
                ID = elem.selectedIndex;

                if (ID != elem.length - 1) {
                    val1 = elem[ID + 1].value;
                    val2 = elem[ID + 1].text;
                    elem.options[ID + 1] = new Option(elem[ID].text, elem[ID].value);
                    elem.options[ID] = new Option(val2, val1);
                    elem.options[ID + 1].selected = true;
                    ToggleImage(ID + 1,grpId);
                }
            } catch(e) {
                alert(e);
                //Nothing
            }
        }

        function ToggleImage(ID, grpId){
            var imgUp = document.getElementById("up"+ grpId)
            var imgDown = document.getElementById("down"+ grpId)
            var elem = document.getElementById("ElemSort"+ grpId)

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

    <script>
        var IE = document.all?true:false;
        if (!IE) document.captureEvents(Event.MOUSEMOVE);

        var tempX = 0;
        var tempY = 0;
        var tmpPriceLine = null;
        function getMouseXY(e) {
            if (IE) {
                tempX = event.clientX + document.body.scrollLeft;
                tempY = event.clientY + document.body.scrollTop;
            } else {
                tempX = e.pageX;
                tempY = e.pageY;
            }
            tempX = tempX - 10;

            // catch possible negative values in NS4
            if (tempX < 0){tempX = 0}
            if (tempY < 0){tempY = 0}
            return true
        }

        //PERIOD
        function SetPeriodInfo(perID) {
            perName = document.getElementById('PeriodProperty'+ perID).value;
            SetPricePeriod(perID,perName);
        }

        function SetPricePeriod(perID, perName) {
            if (tmpPriceLine != null) {
                document.getElementById('PRICE_PeriodID'+ tmpPriceLine).value = perID;
                document.getElementById('PRICE_Period'+ tmpPriceLine).value = perName;
            }
        }

        //VARIANT
        function SetVariantInfo(varID) {
            varName = document.getElementById('VariantProperty'+ varID).value;
            SetPriceVariant(varID,varName);
        }


        function SetPriceVariant(varID, varName) {
            if (tmpPriceLine != null) {
                document.getElementById('PRICE_VariantID'+ tmpPriceLine).value = varID;
                document.getElementById('PRICE_Variant'+ tmpPriceLine).value = varName;
            }
        }

        //UNIT
        function SetPriceUnit(unitID, unitName) {
            if (tmpPriceLine != null) {
                document.getElementById('PRICE_UnitID'+ tmpPriceLine).value = unitID;
                document.getElementById('PRICE_Unit'+ tmpPriceLine).value = unitName;
            }
        }

        function changeAType(mMode, anchorID) {
            try {
                if (mMode == "TRUE") {
                    hrefStr = "javascript:gotoVariant('<%=ProdIdEncoded%>','<%=groupId%>','<%=variantId%>','True')";
                } else {
                    hrefStr = "javascript:gotoVariant('<%=ProdIdEncoded%>','<%=groupId%>','<%=variantId%>','False')";
                }
                if (window.dialogArguments) {
                    dialogArguments.document.getElementById(anchorID).setAttribute("href",hrefStr);
                } else {
                    window.parent.document.getElementById(anchorID).setAttribute("href",hrefStr);
                }
            } catch(e) {
                //Nothing
            }
        }


        function addOption(theSel, theText, theValue) {
            var newOpt = new Option(theText, theValue);
            var selLength = theSel.length;
            theSel.options[selLength] = newOpt;
        }

        function deleteOption(theSel, theIndex) {
            var selLength = theSel.length;
            if(selLength>0) {
                theSel.options[theIndex] = null;
            }
        }

        function moveOption(theSelFrom, theSelTo) {
            if (HideMatrix()) {
                var selLength = theSelFrom.length;
                var selectedText = new Array();
                var selectedValues = new Array();
                var selectedCount = 0;
                var i;

                // Find the selected Options in reverse order
                // and delete them from the 'from' Select.
                for(i=selLength-1; i>=0; i--) {
                    if(theSelFrom.options[i].selected) {
                        selectedText[selectedCount] = theSelFrom.options[i].text;
                        selectedValues[selectedCount] = theSelFrom.options[i].value;
                        deleteOption(theSelFrom, i);
                        getMultiplePriceIndex(null);
                        selectedCount++;
                    }
                }

                // Add the selected text/values in reverse order.
                // This will add the Options to the 'to' Select
                // in the same order as they were in the 'from' Select.
                for(i=selectedCount-1; i>=0; i--) {
                    addOption(theSelTo, selectedText[i], selectedValues[i]);
                }
            }
        }

        function MoveUp(){
            if (HideMatrix()) {
                try {
                    ID = document.getElementById('Form1').MatrixSelected.selectedIndex;
                    if (ID != 0) {
                        val1 = document.getElementById('Form1').MatrixSelected[ID - 1].value;
                        val2 = document.getElementById('Form1').MatrixSelected[ID - 1].text;
                        document.getElementById('Form1').MatrixSelected.options[ID - 1] = new Option(document.getElementById('Form1').MatrixSelected[ID].text, document.getElementById('Form1').MatrixSelected[ID].value);
                        document.getElementById('Form1').MatrixSelected.options[ID] = new Option(val2, val1);
                        document.getElementById('Form1').MatrixSelected.options[ID - 1].selected = true;
                    }
                } catch(e) {
                    //Nothing
                }
            }
        }

        function MoveDown(){
            if (HideMatrix()) {
                try {
                    ID = document.getElementById('Form1').MatrixSelected.selectedIndex;
                    if (ID != document.getElementById('Form1').MatrixSelected.length - 1) {
                        val1 = document.getElementById('Form1').MatrixSelected[ID + 1].value;
                        val2 = document.getElementById('Form1').MatrixSelected[ID + 1].text;
                        document.getElementById('Form1').MatrixSelected.options[ID + 1] = new Option(document.getElementById('Form1').MatrixSelected[ID].text, document.getElementById('Form1').MatrixSelected[ID].value);
                        document.getElementById('Form1').MatrixSelected.options[ID] = new Option(val2, val1);
                        document.getElementById('Form1').MatrixSelected.options[ID + 1].selected = true;
                    }
                } catch(e) {
                    //Nothing
                }
            }
        }

        function HideMatrix() {
            var hide = document.getElementById("HideTheMatrix").value;
            if (hide == "0") {
                if (confirm("<%=Translate.JSTranslate("Alle priser bliver slettet!")%>\n<%=Translate.JsTranslate("Continue?")%>")) {
                    document.getElementById("HideTheMatrix").value = "1";
                    document.getElementById("MatrixSchema").style.display = "none";
                    return true;
                } else {
                    document.getElementById("HideTheMatrix").value = "0";
                    document.getElementById("MatrixSchema").style.display = "";
                    return false;
                }
            } else {
                return true;
            }

        }

        function getMultiplePriceIndex(elem) {
            try {
                ID = elem.selectedIndex;
                val1 = document.getElementById('Form1').MatrixSelected[ID].value;
                val2 = document.getElementById('Form1').MatrixSelected[ID].text;

                if (val1 == 'MULTIPLEPRICES') {
                    document.getElementById('PriceMatrix_MULTIPLEPRICES').style.display = '';
                } else {
                    document.getElementById('PriceMatrix_MULTIPLEPRICES').style.display = 'none';
                }
            } catch(e) {
                try {
                    document.getElementById('PriceMatrix_MULTIPLEPRICES').style.display = 'none';
                } catch(e) {
                    //Nothing
                }
            }
        }

        function AddProductItem(typeMode) {
            <%If ProdIdEncoded <> "" Then%>
            if (prodProdItemAdd) {
                var caller = "parent.document.getElementById('Form1').addProdItemGrpChecked";
                if (typeMode == "ProdItemProd") {
                    caller = "parent.document.getElementById('Form1').addProdItemProdChecked";
                }
                dialog.setTitle('ProductEditMiscDialog', '<%=Translate.Translate("Add product item")%>');
                 dialog.show('ProductEditMiscDialog', "EcomGroupTree.aspx?CMD=" + typeMode + "&AppendType=" + typeMode +"&MasterProdID=<%=ProdIdEncoded%>&caller=" + caller);
            }
            <%Else%>
            alert("<%=Dynamicweb.SystemTools.Translate.JsTranslate("You need to save the product...")%>")
            <%End If%>
        }

        function AddProdItemRows(typeMode, method) {
            if (typeMode == "PROD") {
                checkedArray = document.getElementById('Form1').addProdItemProdChecked.value;
            } else {
                checkedArray = document.getElementById('Form1').addProdItemGrpChecked.value;
            }
            openParts(checkedArray, typeMode);
        }

        function openParts(checkArr, methodType) {
            var url = "/Admin/Module/eCom_Catalog/dw7/PIM/EcomPartsList.aspx?ProductId=<%=ProdIdEncoded%>";
            if (checkArr && methodType) {
                url += "&CMD=AddRelation";
                url += "&checkArr=" + checkArr;
                url += "&methodType=" + methodType;
            }
            else if (window.event.target.id != 'RibbonPartsListsButton')
            {
                return;
            }
            closeMiscDialog();
            dialog.show('PartsDialog', url);
        }

        function saveParts() {
            var partsDialogFrame = document.getElementById('PartsDialogFrame');
            var iFrameDoc = (partsDialogFrame.contentWindow || partsDialogFrame.contentDocument);

            var overlay = new iFrameDoc.overlay('ProductEditOverlay');
            if (overlay && overlay.overlay) { overlay.show(); }
            iFrameDoc.saveParts();
        }

        function openVariants() {
            dialog.show('VariantsDialog', "/Admin/Module/eCom_Catalog/dw7/edit/EcomProductVariants.aspx?ID=<%=ProdIdEncoded%>");
        }

        function saveVariants() {
            var metadataDialogFrame = document.getElementById('VariantsDialogFrame');
            var iFrameDoc = (metadataDialogFrame.contentWindow || metadataDialogFrame.contentDocument);

            var overlay = new iFrameDoc.overlay('ProductEditOverlay');
            if (overlay && overlay.overlay) { overlay.show(); }
            iFrameDoc.saveVariants();
        }

        /*******************************
		* LOADER FOR TAB CLICKS
		*******************************/

        function TabLoader(tabName) {

            if (tabName == "DESCRIPTION")
            {
                loadDescriptionTab();
                return;
            }

            toggleRibbonButtons(true);

            if (tabName == "GENERAL" || tabName == "1") {
                strHelpTopic = 'ecom.productman.product.edit.general';
            }

            if (tabName == "GROUP" || tabName == "5") {
                strHelpTopic = 'ecom.productman.product.edit.groups';
                if ($('ProductGrpRelData').innerHTML == "") {
                    FillDivLayer("LOADING", "", "PRODGRPREL");
                    EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=Product.GroupList";
                }
            }
        }

        function setScrollHeight()
        {
            var nav = parent.document.getElementById('DW_Ecom_Nav');
            var tab = document.getElementById('tabPlace');

            if(!document.all && (nav && tab))
                tab.style.height = nav.scrollHeight - 100;
        }

        function fileArchiveOnKeyUp(fileArchive) {
            // http:// is needed as a prefix for MindWorking Mediadatabase!
            //			if(!isProductImageSource(fileArchive)) return;
            //			if(fileArchive.value.indexOf('://') != -1){
            //				alert('<%=Translate.JsTranslate("Http and ftp adresses are not allowed in this field.") %>');
            //				fileArchive.value = Mid(fileArchive.value, fileArchive.value.indexOf('://') + 3, fileArchive.value.length);
            //			}
        }

        function fileArchiveOnChange(fileArchive){
            fileArchiveOnKeyUp(fileArchive);
        }

        function isProductImageSource(fileArchive){
            var name = fileArchive.name;
            if(name == 'ProductImageSmall_path' || name == 'ProductImageMedium_path' || name == 'ProductImageLarge_path'){
                return true;
            }else{
                return false;
            }
        }

        function Mid(str, start, len){
            if (start < 0 || len < 0) return "";
            var iEnd, iLen = String(str).length;
            if (start + len > iLen){
                iEnd = iLen;
            }else{
                iEnd = start + len;
            }

            return String(str).substring(start, iEnd);
        }

        function LoadMindworkingProductSheetEditor() {
            dialog.setTitle('ProductEditMiscDialog', '<%=Translate.Translate("Mind working Product Sheet Editor")%>');
            dialog.show('ProductEditMiscDialog', "/Admin/Module/MwProductSheet/MwProductSheet_ProductSetup.aspx?id=<%=ProdIdEncoded%>");
        }

        var commentsUrl = '';
        function comments(){
            commentsUrl = '/Admin/Content/Comments/List.aspx?Type=ecomProduct&ItemID=<%=ProdIdEncoded%>&LangID=<%=Ecommerce.Common.Context.LanguageID %>';
            dialog.show('CommentsDialog', commentsUrl);
        }
    </script>

    <%If Request("ImgChange") <> "" Then%>

    <script type="text/javascript">
        changeAType("<%=Request("ImgChange")%>", "EditVarA_<%=variantId%>")
        changeImgType("<%=Request("ImgChange")%>", "EditVarImg_<%=ProdIdEncoded%>_<%=variantId%>", "VAREXISTS")
    </script>

    <% End If%>


    <script type="text/javascript">      
var _MetaTitleCounterMaxId = '<%=MetaTitleCounterMax.ClientID%>';
var _MetaKeywordsCounterMaxId = '<%=MetaKeywordsCounterMax.ClientID%>';
        var _MetaDescrCounterMaxId = '<%=MetaDescrCounterMax.ClientID%>';

        var ElemCounter;

        function ShowCounters(field, counter, counterMax) {

            HideCounter();

            if (field == null || field == 'undefined') return;

            var elemCounter = document.getElementById(counter);
            if (elemCounter == null || elemCounter == 'undefined') return;

            var elemCounterMax = document.getElementById(counterMax);
            if (elemCounterMax == null || elemCounterMax == 'undefined') return;

            ShowCounter(elemCounter, elemCounterMax.value, field.value.length);
            ElemCounter = elemCounter;

        }

        function HideCounter() {
            if (ElemCounter) {
                setTextContent(ElemCounter, '');
            }
        }


        function CheckAndHideCounter(field, counter, counterMax) {

            if (CheckCounter(field, counter, counterMax) == true) {

                HideCounter();
            }
        }

        function CheckCounter(field, counter, counterMax) {

            if (field == null || field == 'undefined') return false;

            var elemCounter = document.getElementById(counter);
            if (elemCounter == null || elemCounter == 'undefined') return false;

            var elemCounterMax = document.getElementById(counterMax);
            if (elemCounterMax == null || elemCounterMax == 'undefined') return false;

            ShowCounter(elemCounter, elemCounterMax.value, field.value.length);
            return true;
        }

        function ShowCounter(elemCounter, maxSize, currentSize) {

            if (currentSize < maxSize) {
                setTextContent(elemCounter, (maxSize - currentSize) + ' ' + '<%=Translate.JsTranslate("remaining before recommended maximum")%>');
            }
            else {
                setTextContent(elemCounter, '<%=Translate.JsTranslate("recommended maximum exceeded")%>');
            }

            var sizeInPercentage = 100;

            if (maxSize > 0) {
                sizeInPercentage = currentSize * 100 / maxSize;
            }

            if (sizeInPercentage < 80) {
                elemCounter.style.color = '#7F7F7F';
            }
            else if (sizeInPercentage < 90) {
                elemCounter.style.color = '#000000';
            }
            else {
                elemCounter.style.color = '#FF0000';
            }
        }

        function setTextContent(element, text) {
            while (element.firstChild !== null) {
                element.removeChild(element.firstChild); // remove all existing content
            }
            element.appendChild(document.createTextNode(text));
        }

        function changeBackground(tr, isMouseOver){
            if(tr){
                if(isMouseOver){
                    tr.observe('mouseover', function(event) {
                        this.setStyle({backgroundColor: '#EBF7FD'});
                    });
                }else{
                    tr.observe('mouseout', function(event) {
                        this.setStyle({backgroundColor: '#fff'});
                    });
                }
            }
        }   

        function showOptimize(){
            dialog.show('OptimizeDialog', "/Admin/Module/eCom_Catalog/dw7/Optimize/Default.aspx?ProductID=<%=ProdIdEncoded%>&ProductVariantID=<%=Request("VariantID")%>&t=<%=DateTime.Now.Ticks%>");
        }

        function UpdateProductImage(size) {   
            const deprecateOldImages = <%=IsOldImagesDeprecated.ToString().ToLower()%>;
            var largeImage = document.getElementById("ProductImageLarge_path");
            var mediumImage = document.getElementById("ProductImageMedium_path");
            var defaultImage = document.getElementById("ProductImageDefault");
            var imgPath;
            var patternImage = $("PatternedImage");
            var img = $("FM_ProductImage_image");
            var imgContainer;
            if (deprecateOldImages) {
                size = null;
            }            
            switch (size) {
                default:
                    if (defaultImage.value) {
                        imgPath = defaultImage.value;
                        break;                    
                    }
                    if (deprecateOldImages) {
                        break;
                    }
                case 3:
                    if (defaultImage.value) {
                        return;
                    }
                    //changed large image - check if has a value, if not try get from medium or small;
                    if (imgPath = largeImage.value) {
                        break;
                    }
                case 2:
                    //changed medium image, if large image exists exit function, otherwise try get from medium or small;
                    if (defaultImage.value || largeImage.value) {
                        return;
                    }
                    if(imgPath = mediumImage.value) {
                        break;
                    }
                case 1:
                    //large or medium exists - do nothing otherwise change to small;
                    if (defaultImage.value || largeImage.value || mediumImage.value) {
                        return;
                    } else {
                        imgPath =  document.getElementById("ProductImageSmall_path").value;
                        break;
                    }
            }
            if(!imgPath && patternImage && patternImage.value){
                imgPath = patternImage.value;
            }

            //if image path is null show no image selected message;
            if (!imgPath) {
                imgContainer = $$("div #ProductImageContainer")[0];
                imgContainer.innerText = "<%=Translate.Translate("No image selected")%>";
                if(img){
                    imgContainer.removeChild(img);
                }
                return;
            }

            imgPath = "/Admin/Public/GetImage.ashx?width=500&height=320&crop=5&donotupscale=1&Compression=75&image=" + imgPath;
            if (img) {
                img.setAttribute("src", imgPath);
            } else {
                imgContainer = $$("div #ProductImageContainer")[0];
                img = document.createElement("img");
                img.setAttribute("src", imgPath);
                img.setAttribute("id", "FM_ProductImage_image");
                img.setAttribute("class", "img-responsive");
                imgContainer.innerText = "";
                imgContainer.appendChild(img);
            }
        }

        function ShowStockDialog() {            
            let url = "/Admin/Module/eCom_Catalog/dw7/PIM/EcomStockList.aspx?ProductId={productId}&groupId={groupId}&queryId={queryId}"
            let windowHref = window.location.href;
            let productId = getParameterByName("ID", windowHref);
            let groupId = getParameterByName("GroupID", windowHref);
            url = Action.Transform(url, {
                productId: productId,
                groupId: groupId,
                queryId: ""
            });
            dialog.show("ProductStocksDialog", url);
        }

        function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, '\\$&');
            var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, ' '));
        }

        function closeRelatedProducts() {
            dialog.hide('RelatedProductsDialog');
            dialog.set_contentUrl("RelatedProductsDialog", "");
        }

        function addProduct(fieldName) {
            if (fieldName != "") {
                var caller = "opener";
                var caller2 = encodeURIComponent(fieldName);
                window.open("/Admin/Module/eCom_Catalog/dw7/Edit/EcomGroupTree.aspx?CMD=ShowProd&AddCaller=1&caller=" + caller + "&caller2=" + caller2, "", "displayWindow,width=460,height=400,scrollbars=no");
            }
        }

        function updateProductEditor(fieldName, prodID, variantID, prodName) {
            let el = document.getElementById(fieldName);
            if (el) {
                el.value = prodID + "#" + variantID;

                el = document.getElementById(fieldName + "_editor");
                el.value = prodName;
            }
        };

        function removeProduct(fieldName) {
            let el = document.getElementById(fieldName);
            if (el) {
                el.value = "";

                el = document.getElementById(fieldName + "_editor");
                el.value = "";
            }
        }
    </script>
</asp:content>
<asp:content id="Content" contentplaceholderid="ContentHolder" runat="server">
    <div class="card">
        <dw:RibbonBar ID="RibbonBar" runat="server">
            <dw:RibbonBarTab ID="RibbonGeneralTab" Name="Product" runat="server" Visible="true">

                <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">

                    <dw:RibbonBarButton ID="btnSaveProduct" Disabled="True" Text="Save" Icon="Save" Size="Small" runat="server" ShowWait="true" EnableServerClick="true" OnClick="SaveProduct_Click" OnClientClick="if(!SaveProduct()) {return false;}" />
                    <dw:RibbonBarButton ID="btnSaveAndCloseProduct" Disabled="True" Text="Save and close" Icon="Save" Size="Small" runat="server" ShowWait="true" EnableServerClick="true" OnClientClick="if(!SaveProduct()) {return false;}" OnClick="SaveAndCloseProduct_Click" />
                    <dw:RibbonBarButton ID="BtnCancel" Text="Close" Icon="TimesCircle" IconColor="Default" Size="Small" runat="server" OnClick="btnCancel_Click" EnableServerClick="true" PerformValidation="False" />
                    <dw:RibbonBarButton ID="BtnDeleteProduct" Text="Delete" Icon="Delete" Size="Small"
                        runat="server" EnableServerClick="true" PerformValidation="false" OnClick="DeleteProduct_Click" OnClientClick="if(!DeleteProduct()){return false;}">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="cmdComments" Text="Comments" Icon="ModeComment" ModuleSystemName="eCom_PowerPack" Size="Small" runat="server" OnClientClick="comments();" />
                    <dw:RibbonBarButton ID="CmdOptimize" Text="Optimize" Icon="Tachometer" ModuleSystemName="SeoExpress" Size="Small" runat="server" />

                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonBarGroup18" Name="Information" runat="server">

                    <dw:RibbonBarRadioButton ID="RibbonBasicButton" runat="server" Text="Details" Checked="false" Icon="InfoCircle" Group="productTabs"
                        Size="Large" OnClientClick="ribbonTab('GENERAL', 1);">
                    </dw:RibbonBarRadioButton>

                    <dw:RibbonBarRadioButton ID="RibbonDefaultInfoButton" Checked="true" Visible="false" Text="def1" Size="Small"
                        runat="server">
                    </dw:RibbonBarRadioButton>

                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroupOptions" Name="Options" runat="server">

                    <dw:RibbonBarRadioButton ID="RibbonRelatedGroupsButton" Checked="False" Text="Related groups"
                        Size="Small"
                        runat="server" Icon="Folder" IconColor="Default"
                        ContextMenuId="GroupsContext" SplitButton="true"
                        OnClientClick="ribbonTab('GROUP', 5);" Group="productTabs" />

                    <dw:RibbonBarRadioButton ID="RibbonRelatedProdButton" Checked="False" Text="Related products" Size="Small" runat="server" Icon="GroupWork"/>

                    <dw:RibbonBarButton ID="ShowProductsFamilyToolButton" Text="Combine products as family" Size="Small"
                        runat="server" Icon="Bank" IconColor="Modules" Visible="false" />

                    <dw:RibbonBarButton runat="server" Text="This button is just for empty space" Size="Small" Visible="false" />

                    <dw:RibbonBarRadioButton ID="RibbonVariantsButton" Text="Variants" Size="Small"
                        runat="server" Icon="HDRWeak" OnClientClick="openVariants();">
                    </dw:RibbonBarRadioButton>

                    <dw:RibbonBarRadioButton ID="RibbonPartsListsButton" Text="Parts Lists" Size="Small"                        
                        ContextMenuId="PartsListContext" SplitButton="true"
                        runat="server" Icon="List" OnClientClick="openParts();">
                    </dw:RibbonBarRadioButton>

                    <dw:RibbonBarRadioButton ID="RibbonPricesButton" Text="Prices" Size="Small" runat="server" Icon="Money" />

                    <dw:RibbonBarRadioButton ID="RibbonStockButton" Text="Stock" Size="Small" runat="server" Icon="TrendingUp" OnClientClick="ShowStockDialog();" />

                    <dw:RibbonBarRadioButton ID="RibbonDiscountsButton" Checked="False" Text="Discounts" Size="Small" runat="server"  Icon="Tags" />

                    <dw:RibbonBarRadioButton ID="RibbonVatGroupsButton" Text="VAT groups" Size="Small" runat="server" Icon="Bank" />

                    <dw:RibbonBarButton ID="RibbonMwButton" Text="Product Sheet" Size="Small"
                        runat="server" Icon="Database" OnClientClick="LoadMindworkingProductSheetEditor();" ModuleSystemName="MwMediaDatabase">
                    </dw:RibbonBarButton>

                    <dw:RibbonBarButton ID="ButtonHelpSmall" Icon="Help" Size="Small" Text="Help" runat="server" OnClientClick="help();" />

                    <dw:RibbonBarRadioButton ID="RibbonDefaultOptButton" Checked="true" Visible="false" Text="Variants" Size="Small"
                        runat="server">
                    </dw:RibbonBarRadioButton>
                    
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonGroupLanguage" Name="Language" runat="server">
                    <ecom:LanguageSelector ID="LangSelector" OnClientSelect="selectLang" TrackFormChanges="true" runat="server" />
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="DelocalizeRibbonBarGroup" Name="Delocalize" runat="server">
                    <dw:RibbonBarButton ID="RibbonDelocalizeButton" Text="Delocalize" Icon="NotInterested" Size="Large"
                        runat="server" EnableServerClick="true" OnClick="DelocalizeProduct_Click" OnClientClick="if(!Delocalize()){return false;}">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonBarGroup20" Name="Help" runat="server">
                    <dw:RibbonBarButton ID="ButtonHelp" Icon="Help" Size="Large" Text="Help" runat="server" OnClientClick="help();" />
                </dw:RibbonBarGroup>
                
            </dw:RibbonBarTab>

            <dw:RibbonBarTab ID="rbtOptions" Active="false" Name="Options" Visible="true" runat="server">
                <dw:RibbonBarGroup ID="RibbonbarGroup2" Name="Tools" runat="server">
                    <dw:RibbonBarButton ID="btnPeriodSaveProduct" Disabled="True" Text="Save" Title="Save" Icon="Save" Size="Small" runat="server" ShowWait="true" EnableServerClick="true" OnClick="SaveProduct_Click" OnClientClick="if(!SaveProduct()) {return false;}" />
                    <dw:RibbonBarButton ID="btnPeriodSaveAndCloseProduct" Disabled="True" Text="Save and close" Icon="Save" Size="Small" runat="server" ShowWait="true" EnableServerClick="true" OnClientClick="if(!SaveProduct()) {return false;}" OnClick="SaveAndCloseProduct_Click" />
                    <dw:RibbonBarButton ID="btnPeriodCancel" Text="Close" Icon="TimesCircle" Size="Small" runat="server" OnClientClick="cancel();" />
                    <dw:RibbonBarButton ID="BtnPeriodDelete" Text="Delete" Icon="Delete" Size="Small" runat="server" EnableServerClick="true" PerformValidation="false" OnClick="DeleteProduct_Click" OnClientClick="if(!DeleteProduct()){return false;}" />
                    <dw:RibbonBarButton ID="cmdPeriodComments" Text="Comments" Icon="ModeComment" ModuleSystemName="eCom_PowerPack" Size="Small" runat="server" OnClientClick="comments();" />
                    <dw:RibbonBarButton ID="cmdPeriodOptimize" Text="Optimize" Icon="Tachometer" ModuleSystemName="SeoExpress" Size="Small" runat="server" />
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="rbgPublication" Name="Publication period" runat="server">
                    <dw:RibbonBarPanel ID="rbpActivation" ExcludeMarginImage="true" runat="server">
                        <table class="publication-date-picker-table">
                            <tr>
                                <td>
                                    <dw:TranslateLabel runat="server" Text="From" />
                                </td>
                                <td>
                                    <dw:DateSelector runat="server" EnableViewState="false" ID="ProductActiveFrom" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dw:TranslateLabel runat="server" Text="To" />
                                </td>
                                <td>
                                    <dw:DateSelector runat="server" EnableViewState="false" ID="ProductActiveTo" />
                                </td>
                            </tr>
                        </table>
                    </dw:RibbonBarPanel>
                </dw:RibbonBarGroup>
                
                <dw:RibbonBarGroup ID="RibbonbarGroupCampaigns" runat="server" Name="Publication periods">
                    <dw:RibbonBarPanel ID="RibbonbarPanel2" ExcludeMarginImage="true" runat="server">
                        <div class="form-group">
                            <label class="from-label"><%= GetCommonFieldTitle(FieldElementsSection.ActivateProduct, ProductDataBaseField.ProductPeriodId)%></label>
                            <asp:DropDownList ID="PeriodId" CssClass="std campaign-selector" runat="server"></asp:DropDownList>
                            <%=GetValidateSpanBlock(ProductDataBaseField.ProductPeriodID, "PeriodID")%>
                        </div>
                    </dw:RibbonBarPanel>
                </dw:RibbonBarGroup>

            </dw:RibbonBarTab>
            <dw:RibbonBarTab ID="TabMarketing" Active="false" Name="Marketing" Visible="true" runat="server">
                <dw:RibbonBarGroup ID="groupMarketingSave" Name="Tools" runat="server">
                    <dw:RibbonBarButton ID="btnMarketingSaveProduct" Disabled="True" Text="Save" Title="Save" Icon="Save" Size="Small" runat="server" ShowWait="true" EnableServerClick="true" OnClick="SaveProduct_Click" OnClientClick="if(!SaveProduct()) {return false;}" />
                    <dw:RibbonBarButton ID="btnMarketingSaveAndCloseProduct" Disabled="True" Text="Save and close" Icon="Save" Size="Small" runat="server" ShowWait="true" EnableServerClick="true" OnClientClick="if(!SaveProduct()) {return false;}" OnClick="SaveAndCloseProduct_Click" />
                    <dw:RibbonBarButton ID="btnMarketingCancel" Text="Close" Icon="TimesCircle" Size="Small" runat="server" OnClientClick="cancel();" />
                    <dw:RibbonBarButton ID="BtnMarketingDelete" Text="Delete" Icon="Delete" Size="Small" runat="server" EnableServerClick="true" PerformValidation="false" OnClick="DeleteProduct_Click" OnClientClick="if(!DeleteProduct()){return false;}" />
                    <dw:RibbonBarButton ID="cmdMarketingComments" Text="Comments" Icon="ModeComment" ModuleSystemName="eCom_PowerPack" Size="Small" runat="server" OnClientClick="comments();" />
                    <dw:RibbonBarButton ID="CmdMarketingOptimize" Text="Optimize" Icon="Tachometer" ModuleSystemName="SeoExpress" Size="Small" runat="server" />
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="GroupMarketingRestrictions" Name="Personalization" runat="server">
                    <dw:RibbonBarButton ID="CmdMarketingPersonalize" Text="Personalize" Size="Small" Icon="AccountBox" runat="server" />
                    <dw:RibbonBarButton ID="CmdMarketingProfileDynamics" Text="Add profile points" Size="Small" Icon="PersonAdd" runat="server" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="groupMarketingHelp" Name="Help" runat="server">
                    <dw:RibbonBarButton ID="cmdMarketingHelp" Text="Help" Icon="Help" Size="Large" OnClientClick="help();" runat="server">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>

            <dw:RibbonBarTab ID="LanguageManagement" Active="false" Name="Languages" Visible="true" runat="server">
                <dw:RibbonBarGroup ID="RibbonBarGroup3" Name="Language" runat="server">
                    <ecom:LanguageSelector ID="LanguageSelectorSmall" OnClientSelect="selectLang" TrackFormChanges="true" runat="server" />
                    <dw:RibbonBarButton ID="RibbonDelocalizeButtonSmall" Text="Delocalize" Icon="NotInterested" Size="Large"
                        runat="server" EnableServerClick="true" OnClick="DelocalizeProduct_Click" OnClientClick="if(!Delocalize()){return false;}">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>

        </dw:RibbonBar>

        <div class="card-body">
            <dw:Infobar runat="server" ID="PublishPeriodInfoBar" />
            <ecom:Breadcrumb ID="breadcrumb" runat="server" CssClass="breadcrumb" />

            <dw:Infobar runat="server" ID="NewProductWarning" Visible="false" Type="Warning" Message="Some fields are not available until the product is saved." />
            <div id="validationSummaryInfo" class="pe-hidden">
                <dw:Infobar ID="prodValidatorInfo" runat="server" Message="Please fill out all required fields."></dw:Infobar>
            </div>

            <dw:ContextMenu ID="MediaContext" runat="server">
                <dw:ContextMenuButton ID="MediaAddDetailImage" runat="server" OnClientClick="checkTab('DETAIL', 3, function(){AddDetailLine('ADD','0');});" Icon="Check" IconColor="Default" Text="Billeder/links" />
                <dw:ContextMenuButton ID="MediaAddDetailText" runat="server" OnClientClick="checkTab('DETAIL', 3, function(){AddDetailLine('ADD','1');});" Icon="Check" IconColor="Default" Text="Tekst" />
            </dw:ContextMenu>

            <dw:ContextMenu ID="GroupsContext" runat="server" MaxHeight="650">
                <dw:ContextMenuButton ID="ContextMenuButton1" runat="server" OnClientClick="checkTab('GROUP', 5, function(){ AddToGroups('addGroupsChecked');});" Icon="Check" IconColor="Default" Text="Add groups" />
            </dw:ContextMenu>

            <dw:ContextMenu ID="FieldsContext" runat="server" MaxHeight="650">
            </dw:ContextMenu>            

            <dw:ContextMenu ID="PartsListContext" runat="server" MaxHeight="650">
            </dw:ContextMenu>
            
            <input type="hidden" id="addProdItemGrpChecked" name="addProdItemGrpChecked">
            <input type="hidden" id="addProdItemProdChecked" name="addProdItemProdChecked">
            <input type="hidden" id="addGroupsChecked" name="addGroupsChecked">
            <input type="hidden" id="addRelatedGrpID" name="addRelatedGrpID">
            <input type="hidden" id="Tab" name="Tab">
            <input type="hidden" id="TabName" name="TabName">
            <input type="hidden" id="refreshGroups">
            <input type="hidden" id="ProductImageDefaultChanged" name="ProductImageDefaultChanged" value="false">
            <asp:Literal ID="NoProductExistsForLanguageBlock" runat="server"></asp:Literal>
            <dw:StretchedContainer ID="ProductEditScroll" Stretch="Fill" Scroll="Auto" Anchor="document" runat="server">

                <table border="0" cellpadding="0" cellspacing="0" class="tabTable100" id="DW_Ecom_tableTab">
                    <tr>
                        <td valign="top">
                            <div id="PageHolderStart" style="display: none;"></div>

                            <div id="Tab1" class="Tab1Div" style="display: none">
                                <dwc:GroupBox ID="primaryProductSettings" runat="server">
                                    <div class="row">
                                        <div class="card-section-8">
                                             <div class="row">
                                                <div class="card-section-8 xs validator-container">
                                                    <div class="product-id" runat="server" id="ProductIdContainer">
                                                        <label id="IdStr" runat="server" disabled="true"></label>
                                                    </div>
                                                    <asp:TextBox ID="NewProductId" runat="server" MaxLength="30" CssClass="std product-id" visible="false"></asp:TextBox>
                                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Warning)%> validation-error hide-error" id='asterisk_NewProductId'></i>
                                                </div>
                                                <div class="card-section-4 xs <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductActive)%>">
                                                    <div class="toggle-switch active-switch" data-ts-color="green">
                                                        <label for="Active" class="ts-label"><%= GetCommonFieldTitle(FieldElementsSection.Settings, ProductDataBaseField.ProductActive)%></label>
                                                        <input id="Active" hidden="hidden" runat="server" type="checkbox" clientidmode="Static" checked />
                                                        <label for="Active" class="ts-helper"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductName, ProductDataBaseField.ProductNumber) %>" >
                                                <div class="card-section-12">
                                                    <div class="form-group validator-container <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductName)%>" >
                                                        <asp:TextBox ID="Name" runat="server" MaxLength="255" CssClass="std product-title"></asp:TextBox>
                                                        <%=GetValidateSpanBlock(ProductDataBaseField.ProductName, "Name")%>
                                                    </div>
                                                    <div class="form-group validator-container <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductNumber)%>" >
                                                        <asp:TextBox ID="Number" runat="server" MaxLength="255" CssClass="std product-number"></asp:TextBox>
                                                        <%=GetValidateSpanBlock(ProductDataBaseField.ProductNumber, "Number")%>
                                                    </div>
                                                    <div class="form-group validator-container <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductEAN)%>" >
                                                        <asp:TextBox ID="EAN" runat="server" MaxLength="255" CssClass="std product-number"></asp:TextBox>
                                                        <%=GetValidateSpanBlock(ProductDataBaseField.ProductEAN, ProductField.ProductEAN.Name)%>
                                                    </div>
                                                </div>
                                                <div class="card-section-seperator"></div>
                                            </div>
                                            <div class="row">
                                                <div class="card-section-6 <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductPrice, ProductDataBaseField.ProductStock) %> ">
                                                    <div class="form-group number-validator-container <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductPrice)%>">
                                                        <label class="form-label"><%= GetCommonFieldTitle(FieldElementsSection.Settings, ProductDataBaseField.ProductPrice)%></label>
                                                        <span class="form-group-info">
                                                            <asp:Label ID="CurrencyLabel" runat="server"></asp:Label>
                                                        </span>
                                                        <asp:TextBox ID="Price" Width="100" CssClass="pull-right std" runat="server"></asp:TextBox>
                                                        <%=GetValidateSpanBlock(ProductDataBaseField.ProductPrice, "Price")%>
                                                    </div>
                                                    <div class="form-group number-validator-container <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductStock)%>">
                                                        <label class="form-label">
                                                            <asp:Label runat="server" ID="TLabelStock">
                                                            <%= GetCommonFieldTitle(FieldElementsSection.Settings, ProductDataBaseField.ProductStock)%>
                                                            </asp:Label>
                                                        </label>
                                                        <span class="form-group-info" ID="StockIcon" runat="server">#</span>
                                                        <asp:TextBox ID="Stock" Width="100" CssClass="pull-right std" runat="server"></asp:TextBox>
                                                        <%=GetValidateSpanBlock(ProductDataBaseField.ProductStock, "Stock")%>
                                                        <span style="color: gray;">
                                                            <dw:TranslateLabel ID="LblStockSum" runat="server" Text="Sum of variant stocks" Visible="False"></dw:TranslateLabel>
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="card-section-6 <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductDefaultPoints, ProductDataBaseField.ProductManufacturerId) %> ">
                                                    <%If Dynamicweb.Security.UserManagement.License.IsModuleAvailable("LoyaltyPoints") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("LoyaltyPoints") Then%>
                                                    <div class="form-group number-validator-container <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductDefaultPoints)%>" >
                                                        <label class="form-label"><%= GetCommonFieldTitle(FieldElementsSection.Settings, ProductDataBaseField.ProductDefaultPoints)%></label>
                                                        <span class="form-group-info">pts.</span>
                                                        <input ID="DefaultPoints" runat="server" class="pull-right std" type="number" min="0" style="width:100px;" />
                                                        <%=GetValidateSpanBlock(ProductDataBaseField.ProductDefaultPoints, "DefaultPoints")%>
                                                    </div>
                                                    <%End If%>
                                                    <div class="form-group validator-container box-control <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductManufacturerId)%> ">
                                                        <label class="form-label"><%= GetCommonFieldTitle(FieldElementsSection.Settings, ProductDataBaseField.ProductManufacturerID)%></label>
                                                        <div class="box-control-actions pull-right">
                                                            <Button type="button" id="AddManufacturer" runat="server"></Button>
                                                        </div>
                                                        <asp:DropDownList ID="ManufacturerId" CssClass="pull-right std" runat="server" ClientIDMode="Static"></asp:DropDownList>
                                                        <%=GetValidateSpanBlock(ProductDataBaseField.ProductManufacturerID, "ManufacturerID")%>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row <%= GetCommonFieldCssClass(FieldElementsSection.ShortDescription) %>">
                                                <div class="card-section-12">
                                                    <div class="form-group RTE-validator-container full-width short-descr">
                                                        <label class="form-label"><%= GetCommonFieldTitle(FieldElementsSection.ShortDescription, ProductDataBaseField.ProductShortDescription)%></label>
                                                        <dw:Editor runat="server" ID="ShortDescription" name="ShortDescription" />
                                                        <%=GetValidateSpanBlock(ProductDataBaseField.ProductShortDescription, "ShortDescription")%>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row <%= GetCommonFieldCssClass(FieldElementsSection.Settings, ProductDataBaseField.ProductLongDescription) %>" >
                                                <div class="card-section-seperator"></div>
                                                <div class="card-section-12">
                                                    <div class="form-group full-width RTE-validator-container long-descr">
                                                        <label class="form-label"><%= GetCommonFieldTitle(FieldElementsSection.Settings, ProductDataBaseField.ProductLongDescription)%></label>
                                                        <dw:Editor runat="server" ID="LongDescription" name="LongDescription" />
                                                        <%=GetValidateSpanBlock(ProductDataBaseField.ProductLongDescription, "LongDescription")%>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card-section-4">
                                            <div class="form-group">
                                                <div id="ProductImageContainer" class="thumbnail img-responsive">
                                                    <i id="FM_ProductImage_addicon" class="hidden thumbnail-add-file"></i>
                                                </div>
                                                <asp:HiddenField runat="server" id="PatternedImage" ClientIDMode="Static" />
                                                <asp:HiddenField runat="server" id="ProductImageDefault" ClientIDMode="Static" />                                                
                                            </div>
                                        </div>
                                    </div>
                                </dwc:GroupBox>

                                <dwc:GroupBox Title="Product images" IsCollapsed="True" DoTranslation="false" runat="server" ID="ProductImagesGroupBox">
                                    <table class="formsTable">
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Media, ProductDataBaseField.ProductImageSmall)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Media, ProductDataBaseField.ProductImageSmall)%>
                                            </td>
                                            <td>
                                                <div class="image-validator-container">
                                                    <dw:FileManager ID="ProductImageSmall" Name="ProductImageSmall" runat="server" Extensions="jpg,gif,png,swf,pdf,webp" CssClass="NewUIinput" OnChange="UpdateProductImage(1);" FullPath="true" />
                                                    <%=GetValidateSpanBlock(ProductDataBaseField.ProductImageSmall, "ProductImageSmall")%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Media, ProductDataBaseField.ProductImageMedium)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Media, ProductDataBaseField.ProductImageMedium)%>
                                            </td>
                                            <td>
                                                <div class="image-validator-container">
                                                <dw:FileManager ID="ProductImageMedium" Name="ProductImageMedium" runat="server" Extensions="jpg,gif,png,swf,pdf,webp" CssClass="NewUIinput" OnChange="UpdateProductImage(2);"  FullPath="true" />
                                                <%=GetValidateSpanBlock(ProductDataBaseField.ProductImageMedium, "ProductImageMedium")%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Media, ProductDataBaseField.ProductImageLarge)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Media, ProductDataBaseField.ProductImageLarge)%>
                                            </td>
                                            <td>
                                                <div class="image-validator-container">
                                                <dw:FileManager ID="ProductImageLarge" Name="ProductImageLarge" runat="server" Extensions="jpg,gif,png,swf,pdf,webp" CssClass="NewUIinput" OnChange="UpdateProductImage(3);" FullPath="true" />
                                                <%=GetValidateSpanBlock(ProductDataBaseField.ProductImageLarge, "ProductImageLarge")%>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </dwc:GroupBox>
                                <dwc:GroupBox Title="Product fields" IsCollapsed="True" ID="ProductFieldsContainer" runat="server">
                                    <asp:Literal ID="ProductFieldList" runat="server"></asp:Literal>
                                    <div id="ProductCustomFieldsEditor">
                                        <asp:Literal ID="ProductFieldsList" runat="server"></asp:Literal>
                                    </div>
                                </dwc:GroupBox>
                                <dwc:GroupBox Title="Product category fields" IsCollapsed="True" ID="ProductCategoriesContainer" runat="server">
                                    <asp:Literal ID="ProductCategoriesFieldList" runat="server"></asp:Literal>
                                </dwc:GroupBox>
                                
                                <dwc:GroupBox Title="Stock" IsCollapsed="True" DoTranslation="false" runat="server" ID="StockGroupBox">
                                    <table class="formsTable">
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Stock, ProductDataBaseField.ProductStockGroupId)%>">
                                            <td>
                                                <label runat="server" id="TLabelStockGroupId">
                                                    <%= GetCommonFieldTitle(FieldElementsSection.Stock, ProductDataBaseField.ProductStockGroupId)%>
                                                </label>
                                            </td>
                                            <td class="validator-container">
                                                <asp:DropDownList ID="StockGroupId" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                                                <%=GetValidateSpanBlock(ProductDataBaseField.ProductStockGroupID, "StockGroupID")%>
                                            </td>
                                        </tr>
                                        <asp:Literal ID="ProductUnitBlock" runat="server"></asp:Literal>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Stock, ProductDataBaseField.ProductWeight)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Stock, ProductDataBaseField.ProductWeight)%>
                                            </td>
                                            <td>
                                                <div class="form-group number-validator-container">
                                                    <asp:TextBox ID="Weight" CssClass="NewUIinput pull-left" runat="server" />
                                                    <span class="form-group-info pull-left"><%=Ecommerce.Common.Gui.GetWeightUnit%></span>
                                                
                                                    <%=GetValidateSpanBlock(ProductDataBaseField.ProductWeight, "Weight")%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Stock, ProductDataBaseField.ProductVolume)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Stock, ProductDataBaseField.ProductVolume)%>
                                            </td>
                                            <td>
                                                <div class="form-group number-validator-container">
                                                    <asp:TextBox ID="Volume" CssClass="NewUIinput pull-left" runat="server" />
                                                    <span class="form-group-info pull-left"><%=Ecommerce.Common.Gui.GetVolumeUnit%></span>
                                                    <%=GetValidateSpanBlock(ProductDataBaseField.ProductVolume, "Volume")%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Stock, ProductDataBaseField.ProductWidth)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Stock, ProductDataBaseField.ProductWidth)%>
                                            </td>
                                            <td>
                                                <div class="form-group number-validator-container">
                                                    <asp:TextBox ID="Width" CssClass="NewUIinput pull-left" runat="server" />
                                                    <span class="form-group-info pull-left"><%=Ecommerce.Common.Gui.GetDimensionsUnit%></span>
                                                    <%=GetValidateSpanBlock(ProductDataBaseField.ProductWidth, ProductField.ProductWidth.Name)%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Stock, ProductDataBaseField.ProductHeight)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Stock, ProductDataBaseField.ProductHeight)%>
                                            </td>
                                            <td>
                                                <div class="form-group number-validator-container">
                                                    <asp:TextBox ID="Height" CssClass="NewUIinput pull-left" runat="server" />
                                                    <span class="form-group-info pull-left"><%=Ecommerce.Common.Gui.GetDimensionsUnit%></span>
                                                    <%=GetValidateSpanBlock(ProductDataBaseField.ProductHeight, ProductField.ProductHeight.Name)%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Stock, ProductDataBaseField.ProductDepth)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Stock, ProductDataBaseField.ProductDepth)%>
                                            </td>
                                            <td>
                                                <div class="form-group number-validator-container">
                                                    <asp:TextBox ID="Depth" CssClass="NewUIinput pull-left" runat="server" />
                                                    <span class="form-group-info pull-left"><%=Ecommerce.Common.Gui.GetDimensionsUnit%></span>
                                                    <%=GetValidateSpanBlock(ProductDataBaseField.ProductDepth, ProductField.ProductDepth.Name)%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Stock, ProductDataBaseField.ProductNeverOutOfStock)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Stock, ProductDataBaseField.ProductNeverOutOfStock)%>
                                            </td>
                                            <td>
                                                <div class="form-group number-validator-container">                                                    
                                                    <dw:CheckBox ID="NeverOutOfStock" runat="server" />                                                    
                                                    <asp:HiddenField ID="NeverOutOfStockOldValue" runat="server" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Stock, ProductDataBaseField.ProductExpectedDelivery) %>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Stock, ProductDataBaseField.ProductExpectedDelivery)%>
                                            </td>
                                            <td>
                                                <dw:DateSelector ID="ExpectedDelivery" AllowNeverExpire="true" EnableViewState="false" runat="server"></dw:DateSelector>
                                            </td>
                                        </tr>
                                    </table>
                                </dwc:GroupBox>
                                <dwc:GroupBox Title="Documents and files" IsCollapsed="True" runat="server" ID="DocumentsGroupBox" ClientIDMode="Static">
                                    <table class="formsTable" id="MediaTable" runat="server">
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Documents, ProductDataBaseField.ProductLink1)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Documents, ProductDataBaseField.ProductLink1)%>
                                            </td>
                                            <td>
                                                <div class="link-validator-container">
                                                    <dw:LinkManager ID="ProductLink1" Name="ProductLink1" DisableParagraphSelector="true" DisableFileArchive="true" runat="server" CssClass="NewUIinput" />
                                                    <%=GetValidateSpanBlock(ProductDataBaseField.ProductLink1, "ProductLink1")%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.Documents, ProductDataBaseField.ProductLink2)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.Documents, ProductDataBaseField.ProductLink2)%>
                                            </td>
                                            <td>
                                                <div class="link-validator-container">
                                                    <dw:LinkManager ID="ProductLink2" Name="ProductLink2" DisableParagraphSelector="true" DisableFileArchive="true" runat="server" CssClass="NewUIinput" />
                                                    <%=GetValidateSpanBlock(ProductDataBaseField.ProductLink2, "ProductLink2")%>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </dwc:GroupBox>
                                <dwc:GroupBox Title="Advanced configurations" IsCollapsed="True" runat="server">
                                    <table class="formsTable">
                                        <tr>
                                            <td>
                                                <dw:TranslateLabel ID="TLabelDefaultShopId" runat="server" Text="Shop"></dw:TranslateLabel>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="DefaultShopId" CssClass="NewUIinput" runat="server"></asp:DropDownList></td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.AdvancedConfigurations, ProductDataBaseField.ProductVatGrpId)%>">
                                            <td>
                                                <asp:Label runat="server" ID="TLabelVatGrpId">
                                                    <%= GetCommonFieldTitle(FieldElementsSection.AdvancedConfigurations, ProductDataBaseField.ProductVatGrpId)%>
                                                </asp:Label>
                                            </td>
                                            <td class="validator-container">
                                                <asp:DropDownList ID="VatGrpId" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                                                <%=GetValidateSpanBlock(ProductDataBaseField.ProductVatGrpId, "VatGrpID")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dw:TranslateLabel ID="TLabelType" runat="server" Text="Produkttype"></dw:TranslateLabel>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="Type" CssClass="NewUIinput" runat="server"></asp:DropDownList></td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.AdvancedConfigurations, ProductDataBaseField.ProductCost)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.AdvancedConfigurations, ProductDataBaseField.ProductCost)%>
                                            </td>
                                            <td>
                                                <div class="form-group number-validator-container">
                                                    <asp:TextBox ID="Cost" CssClass="NewUIinput pull-left" runat="server">
                                                    </asp:TextBox>
                                                    <span class="form-group-info pull-left"><asp:Label ID="CurrencyLabelCost" runat="server"></asp:Label></span>
                                                    <%=GetValidateSpanBlock(ProductDataBaseField.ProductCost, "Cost")%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.AdvancedConfigurations, ProductDataBaseField.ProductPurchaseMinimumQuantity)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.AdvancedConfigurations, ProductDataBaseField.ProductPurchaseMinimumQuantity)%>
                                            </td>
                                            <td>
                                                <div class="form-group number-validator-container">
                                                    <asp:TextBox ID="PurchaseMinimumQuantity" CssClass="NewUIinput pull-left" runat="server" />
                                                    <%=GetValidateSpanBlock(ProductDataBaseField.ProductPurchaseMinimumQuantity, ProductField.ProductPurchaseMinimumQuantity.Name)%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="<%= GetCommonFieldCssClass(FieldElementsSection.AdvancedConfigurations, ProductDataBaseField.ProductPurchaseQuantityStep)%>">
                                            <td>
                                                <%= GetCommonFieldTitle(FieldElementsSection.AdvancedConfigurations, ProductDataBaseField.ProductPurchaseQuantityStep)%>
                                            </td>
                                            <td>
                                                <div class="form-group number-validator-container">
                                                    <asp:TextBox ID="PurchaseQuantityStep" CssClass="NewUIinput pull-left" runat="server" />
                                                    <%=GetValidateSpanBlock(ProductDataBaseField.ProductPurchaseQuantityStep, ProductField.ProductPurchaseQuantityStep.Name)%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dw:TranslateLabel ID="TLabelTypeNotDefault" runat="server" Text="Produkttype"></dw:TranslateLabel>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="TypeNotDefault" CssClass="NewUIinput" runat="server"></asp:DropDownList><asp:TextBox ID="TypeHiddenValue" runat="server" Style="display: none;"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dw:TranslateLabel ID="TLabelPriceType" runat="server" Text="Prisudregning"></dw:TranslateLabel>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="PriceType" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </dwc:GroupBox>
                                <dwc:GroupBox ID="BackCatalogFieldsContainer" Title="Back catalog" IsCollapsed="True" runat="server">
                                    <table class="formsTable">
                                        <tr>
                                            <td></td>
                                            <td>
                                                <label>
                                                    <asp:CheckBox ID="ExcludeFromIndex" runat="server" />
                                                    <dw:TranslateLabel ID="ExcludeFromIndexLabel" runat="server" Text="Exclude from index"></dw:TranslateLabel>
                                                </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td>
                                                <label>
                                                    <asp:CheckBox ID="ExcludeFromCustomizedUrls" runat="server" />
                                                    <dw:TranslateLabel ID="ExcludeFromCustomizedUrlsLabel" runat="server" Text="Exclude from customized urls"></dw:TranslateLabel>
                                                </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td>
                                                <label>
                                                    <asp:CheckBox ID="ExcludeFromAllProducts" runat="server" />
                                                    <dw:TranslateLabel ID="ExcludeFromAllProductsLabel" runat="server" Text="Exclude from &quot;All products&quot;"></dw:TranslateLabel>
                                                </label>
                                            </td>
                                        </tr>
                                    </table>
                                </dwc:GroupBox>

                                <dwc:GroupBox Title="Discontinuation" IsCollapsed="True" runat="server" ID="DiscontinuationGroupBox">                                        
                                    <div class="form-group <%= GetCommonFieldCssClass(FieldElementsSection.Discontinuation, ProductDataBaseField.ProductDiscontinued)%>">
                                        <label class="control-label">&nbsp;</label>
                                        <div class="form-group-input">
                                            <label>
                                                <asp:CheckBox ID="Discontinued" runat="server" />
                                                <%= GetCommonFieldTitle(FieldElementsSection.Discontinuation, ProductDataBaseField.ProductDiscontinued)%>
                                            </label>
                                        </div>                                            
                                    </div>

                                    <div class="form-group <%= GetCommonFieldCssClass(FieldElementsSection.Discontinuation, ProductDataBaseField.ProductReplacementProduct)%>">
                                        <label class="control-label"><%= GetCommonFieldTitle(FieldElementsSection.Discontinuation, ProductDataBaseField.ProductReplacementProduct)%></label>
                                        <div class="form-group-input">
                                            <input type="hidden" id="ReplacementProduct" runat="server" ClientIDMode="Static" />
                                            <input type="text" id="ReplacementProduct_editor" runat="server" class="std" ClientIDMode="Static" readonly="readonly" />
                                        </div>
                                        <% If IsStandartFieldEnabled(ProductDataBaseField.ProductReplacementProduct)%>
                                        <span class="input-group-addon" onclick="javascript:addProduct('ReplacementProduct');" title="<%= Translate.Translate("Add")%>">
                                            <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Plus, True, Core.UI.KnownColor.Success) %>"></i>
                                        </span>
                                        <span class="input-group-addon last" onclick="javascript:removeProduct('ReplacementProduct');" title="<%= Translate.Translate("Delete")%>">
                                            <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Remove, True, Core.UI.KnownColor.Danger) %>"></i>
                                        </span>
                                        <%End if %>
                                    </div>

                                    <div class="form-group <%= GetCommonFieldCssClass(FieldElementsSection.Discontinuation, ProductDataBaseField.ProductDiscontinuedAction)%>">
                                        <label class="control-label"><%= GetCommonFieldTitle(FieldElementsSection.Discontinuation, ProductDataBaseField.ProductDiscontinuedAction)%></label>
                                        <div class="form-group-input">
                                            <asp:DropDownList ID="DiscontinuedAction" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                </dwc:GroupBox>

                                <dwc:GroupBox Title="Meta information" IsCollapsed="True" runat="server" ID="MetaInformationGroupBox">                                        
                                    <div class="form-group <%= GetCommonFieldCssClass(FieldElementsSection.MetaInformation, ProductDataBaseField.ProductMetaTitle)%>">
                                        <label class="control-label"><%= GetCommonFieldTitle(FieldElementsSection.MetaInformation, ProductDataBaseField.ProductMetaTitle)%></label>
                                        <div class="form-group-input validator-container">
                                            <asp:TextBox ID="MetaTitle" CssClass="NewUIinput product-meta-title" runat="server"
                                                onfocus="ShowCounters(this,'MetaTitleCounter',_MetaTitleCounterMaxId);"
                                                onkeyup="CheckCounter(this,'MetaTitleCounter',_MetaTitleCounterMaxId);"
                                                onblur="CheckAndHideCounter(this,'MetaTitleCounter',_MetaTitleCounterMaxId);"></asp:TextBox>
                                            <%=GetValidateSpanBlock(ProductDataBaseField.ProductMetaTitle, "MetaTitle")%>
                                            <small class="help-block info" id="MetaTitleCounter"></small>
                                            <input type="hidden" id="MetaTitleCounterMax" runat="server" />
                                        </div>                                            
                                    </div>

                                    <div class="form-group <%= GetCommonFieldCssClass(FieldElementsSection.MetaInformation, ProductDataBaseField.ProductMetaDescription)%>">
                                        <label class="control-label"><%= GetCommonFieldTitle(FieldElementsSection.MetaInformation, ProductDataBaseField.ProductMetaDescription)%></label>
                                        <div class="form-group-input validator-container">
                                            <asp:TextBox ID="MetaDescr" TextMode="MultiLine" Columns="30" Rows="4" CssClass="NewUIinput product-meta-description" runat="server"
                                                onfocus="ShowCounters(this,'MetaDescrCounter',_MetaDescrCounterMaxId);"
                                                onkeyup="CheckCounter(this,'MetaDescrCounter',_MetaDescrCounterMaxId);"
                                                onblur="CheckAndHideCounter(this,'MetaDescrCounter',_MetaDescrCounterMaxId);"></asp:TextBox>
                                            <%=GetValidateSpanBlock(ProductDataBaseField.ProductMetaDescription, "MetaDescr")%>
                                            <small class="help-block info" id="MetaDescrCounter"></small>
                                            <input type="hidden" id="MetaDescrCounterMax" runat="server" />
                                        </div>
                                    </div>

                                    <div class="form-group <%= GetCommonFieldCssClass(FieldElementsSection.MetaInformation, ProductDataBaseField.ProductMetaKeywords)%>">
                                        <label class="control-label"><%= GetCommonFieldTitle(FieldElementsSection.MetaInformation, ProductDataBaseField.ProductMetaKeywords)%></label>
                                        <div class="form-group-input validator-container">
                                            <asp:TextBox ID="MetaKeywords" TextMode="MultiLine" Columns="30" Rows="4" CssClass="NewUIinput product-meta-keywords" runat="server"
                                                onfocus="ShowCounters(this,'MetaKeywordsCounter',_MetaKeywordsCounterMaxId);"
                                                onkeyup="CheckCounter(this,'MetaKeywordsCounter',_MetaKeywordsCounterMaxId);"
                                                onblur="CheckAndHideCounter(this,'MetaKeywordsCounter',_MetaKeywordsCounterMaxId);"></asp:TextBox>
                                            <%=GetValidateSpanBlock(ProductDataBaseField.ProductMetaKeywords, "MetaKeywords")%>
                                            <small class="help-block info" id="MetaKeywordsCounter"></small>
                                            <input type="hidden" id="MetaKeywordsCounterMax" runat="server" />
                                        </div>
                                    </div>

                                    <div class="form-group <%= GetCommonFieldCssClass(FieldElementsSection.MetaInformation, ProductDataBaseField.ProductMetaCanonical)%>">
                                        <label class="control-label"><%= GetCommonFieldTitle(FieldElementsSection.MetaInformation, ProductDataBaseField.ProductMetaCanonical)%></label>
                                        <div class="form-group-input validator-container">
                                            <asp:TextBox ID="MetaCanonical" MaxLength="255" CssClass="NewUIinput" runat="server"></asp:TextBox>
                                            <%=GetValidateSpanBlock(ProductDataBaseField.ProductMetaCanonical, "MetaCanonical")%>
                                        </div>
                                    </div>

                                    <div class="form-group <%= GetCommonFieldCssClass(FieldElementsSection.MetaInformation, ProductDataBaseField.ProductMetaUrl)%>">
                                        <label class="control-label"><%= GetCommonFieldTitle(FieldElementsSection.MetaInformation, ProductDataBaseField.ProductMetaUrl)%></label>
                                        <div class="form-group-input validator-container">
                                            <asp:TextBox ID="MetaUrl" CssClass="NewUIinput product-meta-url" runat="server"></asp:TextBox>
                                            <%=GetValidateSpanBlock(ProductDataBaseField.ProductMetaUrl, "MetaUrl")%>
                                        </div>
                                    </div>
                                </dwc:GroupBox>
                            </div>
                            <div id="Tab2" class="Tab2Div" style="display: none">
                                <div id="PageContent2">
                                </div>
                            </div>
                            <div id="Tab3" class="Tab3Div" style="display: none">
                                <div id="PageContent3">
                                </div>
                            </div>
                            <div id="Tab5" class="Tab5Div" style="display: none">
                                <div id="PageContent5">
                                    <div id="ProductGrpRelData" class="p-t-15"></div>
                                </div>
                            </div>
                            <div id="Tab7" class="Tab7Div" style="display: none">
                                <div id="PageContent7">
                                    <div id="ProductVariantData" class="p-t-15"></div>
                                </div>
                            </div>
                            <div id="Tab11" class="Tab11Div" style="display: none">
                                <div id="PageContent11">
                                    <div id="ProductItemBlock"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </dw:StretchedContainer>
        </div>
    </div>
    <iframe name="EcomUpdator" id="EcomUpdator" width="0" height="0" tabindex="-1" align="right" marginwidth="0" marginheight="0" frameborder="0" src="EcomUpdator.aspx" border="0"></iframe> 
       
    <dw:Dialog ID="ImageManagementDialog" Size="Large" runat="server" Title="Manage assets" HidePadding="True" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
        <iframe id="ImageManagementDialogFrame"></iframe>
    </dw:Dialog>
            
    <dw:Dialog runat="server" ID="VideoDetailPreview" Title="Video detail preview" HidePadding="True" Size="Large" >
        <div id="VideoDetailPreviewContainer"></div>
    </dw:Dialog>   

    <dw:Dialog runat="server" ID="ProductPricesDialog" Size="Large" Title="Prices" HidePadding="True">
        <iframe id="ProductPricesDialogFrame"></iframe>
    </dw:Dialog>

    <dw:Dialog runat="server" ID="ProductVatGroupsDialog" Size="Large" Title="VAT groups" HidePadding="True">
        <iframe id="ProductVatGroupsDialogFrame"></iframe>
    </dw:Dialog>

    <dw:Dialog runat="server" ID="ProductDiscountsDialog" Size="Large" Title="Discounts" HidePadding="True">
        <iframe id="ProductDiscountsDialogFrame"></iframe>
    </dw:Dialog>

    <dw:Dialog runat="server" ID="RelatedProductsDialog" Size="Large" HidePadding="True" Title="Related products" OkText="Close" ShowOkButton="true" OkAction="closeRelatedProducts();">
        <iframe id="RelatedProductsDialogFrame"></iframe>
    </dw:Dialog>

    <dw:Dialog runat="server" ID="VariantsDialog" Size="Large" HidePadding="True" Title="Variants" OkText="Save" ShowOkButton="true" ShowCancelButton="true" OkAction="saveVariants();">
        <iframe id="VariantsDialogFrame"></iframe>
    </dw:Dialog>

    <dw:Dialog runat="server" ID="PartsDialog" Size="Large" HidePadding="True" Title="Parts list" OkText="Save" ShowOkButton="true" ShowCancelButton="true" OkAction="saveParts();">
        <iframe id="PartsDialogFrame"></iframe>
    </dw:Dialog>    

    <dw:Dialog ID="OptimizeDialog" runat="server" Title="Optimize" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
        <iframe id="OptimizeDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <omc:MarketingConfiguration ID="marketConfig" runat="server" />
    
    <!-- Add related group or product dialog -->
    <dw:Dialog runat="server" ID="ProductEditMiscDialog" Size="Large" HidePadding="True">
        <iframe id="ProductEditMiscDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="CommentsDialog" runat="server" Title="Comments" HidePadding="true">
        <iframe id="CommentsDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="NewManufacturerDialog" runat="server" Title="Edit manufacturer" HidePadding="true" Size="Large">
        <iframe id="NewManufacturerDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="CreateMessageDialog" runat="server" Title="Publish product to social media" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
        <iframe id="CreateMessageDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>
    
    <dw:Dialog runat="server" ID="ProductStocksDialog" Size="Large" Title="Stocks" HidePadding="True">
        <iframe id="ProductStocksDialogFrame"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="AddVariantOption" runat="server" Title="Add new variant option" Width="250" ShowCancelButton="true" ShowClose="false"
        ShowOkButton="true" OkAction="addVariantOptionComplete();" CancelAction="addVariantOptionCancel();">
        <label>
            <dw:TranslateLabel Text="Option name" runat="server" />
        </label>
        <input />
    </dw:Dialog>

    <dw:Overlay ID="ProductEditOverlay" runat="server"></dw:Overlay>


    <%Translate.GetEditOnlineScript()%>

    <script type="text/javascript">
            <%If Ecommerce.Common.Context.LanguageID <> Dynamicweb.Ecommerce.Common.Application.DefaultLanguage.LanguageID Then%>
        isDefaultLang = false;
            <%End If%>

        document.observe("dom:loaded", function() {	            
            <%If OMCRedirect Then%>
            Ribbon.tab(2, 'RibbonBar');
            ProductEdit.openContentRestrictionDialog('<%=ProdIdEncoded %>', '', '<%=langId %>');
            <%End If%>

            ProductEdit.terminology['unsavedChanges'] = '<%=Translate.Translate("Data you have entered may not be saved.")%>';
            ProductEdit.terminology['PreviewPdfDialogTitle'] = '<%=Translate.Translate("Preview")%>';
            ProductEdit.Marketing = <%=marketConfig.ClientInstanceName%>;
            ProductEdit.initialization();
            UpdateProductImage();
        });
    </script>
</asp:content>
