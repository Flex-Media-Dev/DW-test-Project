<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="EcomGroup_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomGroupEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register  TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:content id="Header" contentplaceholderid="HeadHolder" runat="server">
    <style type="text/css">
        body {
            overflow: hidden;
        }
        .facets .selection-box {
            margin-left: 180px;
        }
        .specific-facets-selector-container {
            display: none;
        }
        .specific-facets-selector-container.show {
            display: initial;
        }
        
        .cat-field-row > .editor.type-1 .NewUIinput,
        .cat-field-row > .editor.type-10 .NewUIinput,
        .cat-field-row > .editor.type-11 .NewUIinput,
        .cat-field-row > .editor.type-12 .NewUIinput,
        .cat-field-row > .editor.type-13 .NewUIinput,
        .cat-field-row > .editor.type-6 input,
        .cat-field-row > .editor.type-7 input {
            float: left;
        }
        
        .cat-field-row.inherited-val .editor > .input-group-addon:hover {
            background-color: inherit;
        }
        .editor.type-4 .restore-inherited-val,
        .editor.type-5 .restore-inherited-val,
        .editor.type-8 .restore-inherited-val,
        .editor.type-9 .restore-inherited-val,
        .editor .custom-type-provider .restore-inherited-val,
        .editor.type-15 .restore-inherited-val {
            vertical-align: top;
            margin-top: 9px;
            margin-left: 5px;
        }
    </style>
	<script type="text/javascript" src="../images/functions.js"></script>
	<script type="text/javascript" src="../images/addrows.js"></script>
    <script type="text/javascript" src="../images/AjaxAddInParameters.js"></script>
    <script type="text/javascript" src="../images/layermenu.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/RteValueObserver.js"></script>
    <script type="text/javascript" src="../js/EcomGroup_Edit.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Validation.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/List/List.js"></script>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
    
	<script type="text/javascript"> //<!--
	    $(document).observe('dom:loaded', function () {
            const isPimGroup = <%=IIf(Converter.ToBoolean(Request("FromPIM")), "true", "false")%>;
	        ecomGroupEditInit({
	            isPimGroup: isPimGroup
	        });

	        if ($F("activeTab") == 'generalTab') { //check if default tab loaded.
	            window.focus(); // for ie8-ie9 
	            document.getElementById('<%=NameStr.ClientID %>').focus();
            }
	    });

        $(document).observe('keydown', function (e) {
            if (e.keyCode == 13) {
                var srcElement = e.srcElement ? e.srcElement : e.target;
                if (srcElement.type != 'textarea') {
                    e.preventDefault();
                }
            }
        });
        //--> </script>
	
	<script type="text/javascript" src="/Admin/Link.js"></script>
	<script type="text/javascript" src="/Admin/FormValidation.js"></script>
	
	<script type="text/javascript">
	    function help() {
	<%=Dynamicweb.SystemTools.Gui.help("", "ecom.group.edit", "en") %>
	    }

	    function loadTab(tabId) {
	        showTab(tabId);
	        FillDivLayer2("LOADING", "", tabId);
	        if (tabId == "relatedGroupsTab")
	            EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=Group.RelatedGroupList";
	        else if (tabId == "relatedProductsTab")
	            EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=Group.RelatedProductList";
	        else if (tabId == "discountsTab")
	            EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=Group.DiscountList";
	    }

	    function FillDivLayer2(typeStr, fillData, fillLayer) {
	        var fillStr = ""

	        if (typeStr == "LOADING") {
	            fillStr = '<asp:Literal id="LoadBlock" runat="server"></asp:Literal>';
	        }

	        if (typeStr == "DWNONE") {
	            fillStr = '<br />';
	        }

	        if (fillData != "") {
	            fillStr = fillData;
	        }

	        if (fillLayer == "GRPREL")
	            fillLayer = "relatedGroupsTab";
	        else if (fillLayer == "GRPPRODREL")
	            fillLayer = "relatedProductsTab";
	        else if (fillLayer == "GRPDISCOUNT")
	            fillLayer = "discountsTab";

	        $(fillLayer).innerHTML = fillStr;
	    }

	    function AddRelatedGroups() {
	        AddRelated('relatedGroupsChecked');
	    }

	    function AddRelatedProducts(RelgrpID) {
	        document.getElementById('Form1').addRelatedGrpID.value = RelgrpID;
	        AddRelated('relatedProductsChecked', RelgrpID);
	    }

	    function AddRelated(fieldName, RelgrpID) {
	        var shopType = '&shopsToShow=' + '<%=ShopType%>';
	        if (globalGroupId.length > 0) {
	            if (typeof (fieldName) == "undefined")
	                fieldName = 'relatedGroupsChecked';

	            if (fieldName == "relatedGroupsChecked") {
	                showTab("relatedGroupsTab");

	                if (enableClick) {
	                    var caller = "parent.document.getElementById('Form1')." + fieldName;
	                    dialog.setTitle('GroupEditMiscDialog', '<%=Translate.Translate("Add group relation")%>');
	                    dialog.show('GroupEditMiscDialog', "/Admin/module/ecom_catalog/dw7/edit/EcomGroupTree.aspx?CMD=ShowGroupGroupRel&MasterGroupID=" + globalGroupId + "&MasterShopID=" + globalShopId + "&caller=" + caller + shopType);
                    }
                }
                else {
                    var caller = "parent.document.getElementById('Form1')." + fieldName;
                    dialog.setTitle('GroupEditMiscDialog', '<%=Translate.Translate("Add product relation")%>');
	                dialog.show('GroupEditMiscDialog', "EcomGroupTree.aspx?CMD=ShowGroupProdRel&caller=" + caller + "&RelgrpID=" + RelgrpID + "&GroupID=" + globalGroupId + shopType);
            }
        }
        else {
            alert("<%=Dynamicweb.SystemTools.Translate.JsTranslate("Save group first...")%>");
	        }
        }

        function AddRelatedRows() {
            closeMiscDialog();
            FillDivLayer2("LOADING", "", "GRPPRODREL");
            setTimeout('AddRelatedRowsPutter()', "10");
        }

        function AddRelatedRowsPutter() {
            var prodArray = document.getElementById('Form1').relatedProductsChecked.value;
            AddDWRowFromArry('GROUPPRODRELATED', globalGroupId, prodArray, '../Edit/', document.getElementById('Form1').addRelatedGrpID.value);
        }

        function sortReleatedProducts(grpId) {
            var elem = document.getElementById("RELGRPHOLDER_" + grpId);
            var sort = document.getElementById("RELGRPSORTER_" + grpId);

            if (elem.style.display == '') {
                elem.style.display = 'none';
                sort.style.display = '';

                EcomUpdator.document.location.href = "EcomUpdator.aspx?CMD=Group.ReleatedProduct.Sort&GroupID=" + grpId;
            } else {
                elem.style.display = '';
                sort.style.display = 'none';
            }
        }

        function fillReleatedProducts(grpId, fillStr) {
            var sort = document.getElementById("SORTEDLIST_" + grpId)
            sort.innerHTML = fillStr;
        }


        function checkSortInput(grpId) {
            var elem = document.getElementById("ElemSort" + grpId)
            setTimeout("" + submitSort(grpId), 200);
        }

        function submitSort(grpId) {
            var values = ""
            var elem = document.getElementById("ElemSort" + grpId)
            for (i = 0; i < elem.length; i++) {
                //elem.options[i].selected = true;


                if (values == "") {
                    values = elem.options[i].value;
                } else {
                    values += ";" + elem.options[i].value;
                }
            }
            EcomUpdator.document.location.href = "EcomUpdator.aspx?CMDSort=SAVE&CMD=Group.ReleatedProduct.Sort&GroupID=" + grpId + "&ElemSort" + grpId + "=" + values;
        }
        function MoveSortUp(grpId) {
            try {
                var elem = document.getElementById("ElemSort" + grpId)
                ID = elem.selectedIndex;

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
                var elem = document.getElementById("ElemSort" + grpId)
                ID = elem.selectedIndex;

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
            var imgUp = document.images["up" + grpId]
            var imgDown = document.images["down" + grpId]
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

        var categoryDidChange = false;
        var originalCategory;
        function ProductCategoryChange(obj) {
            //
            if (!categoryDidChange)
                originalCategory = obj.selectedIndex;

            var msg = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Changing the category will affect all products in the group. Data will be lost if the changes are saved. Click 'Ok' to confirm.")%>';
            if (confirm(msg)) {
                $("CurentProductCategory").value = obj.selectedIndex;
                categoryDidChange = originalCategory == obj.selectedIndex;
                updateProductCategory(obj.selectedOptions[0].value);
            } else {
                obj.selectedIndex = $("CurentProductCategory").value;
            }
        }

        function updateProductCategory(newCategory) {
            console.log("updateProductCategory", newCategory);
        }

        function ConfirmSave() {
            var msg = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Category has changed. Data will be lost for all products in the group. Click 'Ok' to confirm.")%>';
            if (categoryDidChange && !confirm(msg)) {
                return false;
            }
            return true;
        }

        function AddToRelatedProductGroups() {
            dialog.setTitle('GroupEditMiscDialog', '<%=Translate.Translate("Add related product relation group")%>');
	        dialog.show('GroupEditMiscDialog', "EcomRelGrp_Edit.aspx?isPopUp=TRUE");
	        return false;
	    }

	    function UpdateRelatedProductGroups(groupName, groupID) { // this function called from EcomRelGrp_Edit.aspx popup
	        var ctnr = $('RelatedProductsContextMenu').getElementsByClassName("container containerFixed")[0];
	        var newGrp = document.createElement("a");
	        newGrp.href = "#";
	        newGrp.onclick = function () { loadTab('relatedProductsTab'); AddRelatedProducts(groupID); };
	        var innerspan = document.createElement("span");
	        innerspan.className = "item";
	        var innerImg = document.createElement("i");
	        innerImg.class = "icon fa fa-check";
	        innerspan.appendChild(innerImg);
	        innerspan.innerHTML += groupName;
	        newGrp.appendChild(innerspan);
	        var outerSpan = document.createElement("span");
	        outerSpan.appendChild(newGrp);
	        ctnr.insertBefore(outerSpan, ctnr.firstChild);
	    }

	    function IncludeInDiscounts(fieldName) {
	        if (fieldName == "includeInDiscountsChecked") {
	            showTab('discountsTab');
	        }

	        <%If Request("ID") <> "" Then%>
	        var caller = "parent.document.getElementById('Form1')." + fieldName;
	        dialog.setTitle('GroupEditMiscDialog', '<%=Translate.Translate("Manage included discounts")%>');
	        dialog.show('GroupEditMiscDialog', "../lists/EcomOrderDiscount_List.aspx?CMD=GroupIncludeInDiscounts&GroupID=<%=Request("ID")%>&caller=" + caller);
	        <%Else%>
	        alert("<%=Dynamicweb.SystemTools.Translate.JsTranslate("You need to save the group...")%>")
	        <%End If%>
	    }

	    function ExcludeFromDiscounts(fieldName) {
	        if (fieldName == "excludeFromDiscountsChecked") {
	            showTab('discountsTab');
	        }

	        <%If Request("ID") <> "" Then%>
	        var caller = "parent.document.getElementById('Form1')." + fieldName;
	        dialog.setTitle('GroupEditMiscDialog', '<%=Translate.Translate("Manage excluded discounts")%>');
	        dialog.show('GroupEditMiscDialog', "../lists/EcomOrderDiscount_List.aspx?CMD=GroupExcludeFromDiscounts&GroupID=<%=Request("ID")%>&caller=" + caller);
	        <%Else%>
	        alert("<%=Dynamicweb.SystemTools.Translate.JsTranslate("You need to save the group...")%>")
	        <%End If%>
	    }

	    function IncludeDiscounts(discountArr) {
	        closeMiscDialog();
	        FillDivLayer2("LOADING", "", "discountsTab");
	        EcomUpdator.document.location.href = "../edit/EcomUpdator.aspx?CMD=Group.IncludeInDiscounts&DiscountArr=" + discountArr;
	    }

	    function ExcludeDiscounts(discountArr) {
	        closeMiscDialog();
	        FillDivLayer2("LOADING", "", "discountsTab");
	        EcomUpdator.document.location.href = "../edit/EcomUpdator.aspx?CMD=Group.ExcludeFromDiscounts&DiscountArr=" + discountArr;
	    }

	    function closeMiscDialog() {
	        dialog.hide("GroupEditMiscDialog");
	        dialog.set_contentUrl("GroupEditMiscDialog", "");
	    }
        
        function openAuditDialog() {
            <%=GetAuditDialogAction()%>
        }

        function openProfileDynamicsDialog(groupId, languageId) {
            <%=marketConfig.ClientInstanceName%>.openSettings('ProfileDynamics', { data: { ItemType: 'ProductGroup', ItemID: groupId + '.' + languageId } });
        }

        function selectedFacetsChanged(selectionBoxId, storageLeftId, storageRightId) {
            let unselectedFacets = SelectionBox.getElementsLeftAsArray(selectionBoxId);
            document.getElementById(storageLeftId).value = unselectedFacets;
            let selectedFacets = SelectionBox.getElementsRightAsArray(selectionBoxId);
            document.getElementById(storageRightId).value = selectedFacets;
            document.getElementById(storageLeftId + "RightIsChanged").value = "true"
        }

        function facetsGroupModeSelectorChanged(radioButton, selectionBoxId, storageLeftId, storageRightId) {
            var selectedValue = radioButton.value;
            var frmGroupEl = radioButton.closest(".radio-group");
            var specificFacets = frmGroupEl.nextElementSibling;
            if (selectedValue == "specific") {
                specificFacets.className = "specific-facets-selector-container show";
            } else {
                specificFacets.className = "specific-facets-selector-container";
            }

            if (selectedValue == "none") {
                SelectionBox.selectionRemoveAll(selectionBoxId);
            } else if (selectedValue == "all") {
                SelectionBox.selectionAddAll(selectionBoxId);
            }
            selectedFacetsChanged(selectionBoxId, storageLeftId, storageRightId);
        }

        function serializeGroupCompletionRules() {
            $("CompletionRuleIDs").value = SelectionBox.getElementsRightAsArray("CompletionRulesSelector");
        }

        function serializeGroupLanguages() {
            $("CompletionLangsIDs").value = SelectionBox.getElementsRightAsArray("CompletionLangs");
        }
    </script>
</asp:content>

<asp:content id="Content" contentplaceholderid="ContentHolder" runat="server">
<div style="min-width:1000px;overflow:hidden;">
    <dw:RibbonBar runat="server" ID="myribbon">
        <dw:RibbonBarTab Name="Group" runat="server">
            <dw:RibbonBarGroup Name="Tools" runat="server">
                <dw:RibbonBarButton Text="Save" ID="RBSave" Icon="Save" Size="Small" runat="server" ShowWait="true" OnClientClick="if(!saveGroupData()) return false;" OnClick="RBSave_Click" EnableServerClick="true" />
                <dw:RibbonBarButton Text="Save and close" ID="RBSaveAndClose" Icon="Save" Size="Small" ShowWait="true" runat="server" OnClientClick="if(!saveGroupData()) return false;" OnClick="RBSaveAndClose_Click" EnableServerClick="true" />
                <dw:RibbonBarButton Text="Close" ID="RBClose" Icon="TimesCircle" Size="Small" runat="server" OnClick="RBClose_Click" EnableServerClick="true" />
                <dw:RibbonBarButton Text="Delete" ID="RBDelete" Icon="Delete" Size="Small" runat="server" EnableServerClick="true" PerformValidation="false" OnClick="RBDelete_Click" OnClientClick="if (!deleteGroup()) return false;" />
             </dw:RibbonBarGroup>
             <dw:RibbonBarGroup Name="Information" runat="server">
                <dw:RibbonBarRadioButton ID="basicBtn" runat="server" Text="Details" Icon="InfoCircle" Group="groupTabs" Size="Small" OnClientClick="showTab('generalTab');" />
                <dw:RibbonBarRadioButton ID="locationBtn" Text="Location" Size="Small" runat="server" Icon="MapMaker" OnClientClick="showTab('locationTab');" ContextMenuId="LocationMenu" SplitButton="true" Group="groupTabs" />                 
                <dw:RibbonBarButton ID="cmdAuditing" runat="server" Size="Small" Icon="Eye" Text="Auditing" Visible="true" OnClientClick="openAuditDialog();" ></dw:RibbonBarButton>
                <dw:RibbonBarRadioButton ID="orderLineFieldsBtn" Text="Orderline fields" Size="Small" runat="server" Icon="Assignment" ContextMenuId="OrderLineContextMenu" SplitButton="true" OnClientClick="showTab('orderlineTab');" Group="groupTabs" />
                <dw:RibbonBarRadioButton ID="discountsBtn" Text="Discounts" Size="Small" runat="server" Icon="LocalPlay" SplitButton="true" ContextMenuId="DiscountContextMenu" OnClientClick="loadTab('discountsTab');" Group="groupTabs" />
             </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="Navigation" Name="Navigation" runat="server">
                <dw:RibbonBarCheckbox ID="NavigationShowInMenu" Text="Show in menu" Icon="Menu" Size="Small" runat="server" />
                <dw:RibbonBarCheckbox ID="NavigationShowInSiteMap" Icon="Sitemap" Text="Show in sitemap" runat="server" />
                <dw:RibbonBarCheckbox ID="NavigationClickable" Text="Clickable" Icon="BullsEye" runat="server" />
            </dw:RibbonBarGroup>
             <dw:RibbonBarGroup Name="New products" runat="server" DoNotSetActive="true">
                <dw:RibbonBarRadioButton ID="RibbonRelatedGroupsButton" Checked="False" Text="Default related groups" Size="Small" runat="server" Icon="Folder" IconColor="Default" ContextMenuId="RelatedGroupsContextMenu" SplitButton="true" OnClientClick="loadTab('relatedGroupsTab')" Group="groupTabs" />
                <dw:RibbonBarRadioButton ID="RibbonBarRelatedProductsButton" Checked="False" Text="Default related products" Size="Small" runat="server" Icon="Sitemap" ContextMenuId="RelatedProductsContextMenu" SplitButton="true" OnClientClick="loadTab('relatedProductsTab')" Group="groupTabs" />
             </dw:RibbonBarGroup>
             <dw:RibbonBarGroup ID="RibbonGroupLanguage" Name="Language" runat="server">
                <ecom:LanguageSelector ID="langSelector" OnClientSelect="selectLang" TrackFormChanges="true" runat="server" />
             </dw:RibbonBarGroup>
             <dw:RibbonBarGroup ID="RibbonGroupDelocalize" Name="Delocalize" runat="server">
                <dw:RibbonBarButton ID="RibbonDelocalizeButton" Text="Delocalize" Icon="NotInterested" Size="Large"
                runat="server" EnableServerClick="true" OnClick="DelocalizeGroup_Click" OnClientClick="if(!delocalize()){return false;}" >
             </dw:RibbonBarButton>
             </dw:RibbonBarGroup>
             <dw:RibbonBarGroup Name="Help" runat="server">
                <dw:RibbonBarButton ID="ButtonHelp" Icon="Help" Size="Large" Text="Help" runat="server" OnClientClick="help();" />
             </dw:RibbonBarGroup>
         </dw:RibbonBarTab>
        <dw:RibbonBarTab ID="TabMarketing" Active="false" Name="Marketing" Visible="true" runat="server">
            <dw:RibbonBarGroup ID="GroupMarketingRestrictions" Name="Personalization" runat="server">
                <dw:RibbonBarButton ID="marketingProfileDynamicsBtn" Text="Add profile points" Size="Small" Icon="PersonAdd" runat="server" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="groupMarketingHelp" Name="Help" runat="server">
                <dw:RibbonBarButton ID="cmdMarketingHelp" Text="Help" Icon="Help" Size="Large" OnClientClick="help('marketing');" runat="server">
                </dw:RibbonBarButton>
            </dw:RibbonBarGroup>
        </dw:RibbonBarTab>
    </dw:RibbonBar>
	</div>
	<dw:ContextMenu ID="OrderLineContextMenu" runat="server" MaxHeight="650" Translate="false" />
	<dw:ContextMenu ID="LocationMenu" runat="server">
	    <dw:ContextMenuButton runat="server" ID="AttachSubgroupsBtn" OnClientClick="AddGroups('addGroupsChecked');" Text="Attach as subgroup" Icon="AttachFile"/>
	</dw:ContextMenu>
    <dw:ContextMenu ID="RelatedGroupsContextMenu" runat="server" MaxHeight="650">
        <dw:ContextMenuButton runat="server" OnClientClick="AddRelated('relatedGroupsChecked');" Icon="Check" IconColor="Default" Text="Add groups" />
    </dw:ContextMenu>

    <dw:ContextMenu ID="RelatedProductsContextMenu" runat="server" MaxHeight="650"/>

    <dw:ContextMenu ID="DiscountContextMenu" runat="server" MaxHeight="650">
        <dw:ContextMenuButton ID="ContextMenuButton3" runat="server" OnClientClick="IncludeInDiscounts('includeInDiscountsChecked');" Icon="Check" IconColor="Default" Text="Manage including discounts" />
        <dw:ContextMenuButton ID="ContextMenuButton1" runat="server" OnClientClick="ExcludeFromDiscounts('excludeFromDiscountsChecked');" Icon="Check" IconColor="Default" Text="Manage excluding discounts" />
    </dw:ContextMenu>

    <ecom:Breadcrumb ID="breadcrumb" runat="server" CssClass="breadcrumb" />

    <div id="validationSummaryInfo" style="display:none;">
        <dw:Infobar ID="validationInfobar" runat="server" Message="Please fill out all required fields."/>
    </div>
	
    <dw:Infobar ID="NoGrpExistsForLanguageInfoBar" runat="server" Message="Gruppe findes ikke i det valgte sprog." Visible="false" />	
	<dw:StretchedContainer ID="ProductEditScroll" Stretch="Fill" Scroll="Auto" Anchor="document" runat="server">

	<asp:textbox Visible="False" Enabled="True" id="LanguageIDStr" runat="server"></asp:textbox>			

	<input type="hidden" name="addGroupsChecked"/>
    <input type="hidden" name="relatedGroupsChecked"/>
    <input type="hidden" name="relatedProductsChecked"/>
    <input type="hidden" id="addRelatedGrpID" name="addRelatedGrpID"/> 
    <input type="hidden" id="FromPIM" name="FromPIM" value="" runat="server" />
	
	<table border="0" cellpadding="0" cellspacing="0" class="tabTable100" id="DW_Ecom_tableTab" style="clear:left;">
	<tr><td valign="top">
	<table border="0" cellpadding="0" cellspacing="0" width="95%" style="width:95%;">
	<tr><td>

	<div class="groupTab" id="generalTab">			
		<dwc:GroupBox ID="settingsGroupBox" runat="server" Title="Settings">
		    <table class="formsTable">
			    <tr>
				    <td><dw:TranslateLabel id="tLabelName" runat="server" Text="Navn"></dw:TranslateLabel></td>
				    <td style="white-space:nowrap;">
		                <asp:textbox id="NameStr" runat="server" MaxLength="255" cssClass="ecomStd"/>
		                <span id="errNameStr" style="color: Red;"></span>
		            </td>
			    </tr>
			    <tr>
				    <td><dw:TranslateLabel id="tLabelNumber" runat="server" Text="Nummer"/></td>
				    <td>
		                <asp:textbox id="NumberStr" runat="server" MaxLength="255" cssClass="ecomStd"/>
		            </td>
			    </tr>
                <tr>
                    <td><dw:TranslateLabel ID="tLabelId" runat="server" Text="Id"></dw:TranslateLabel> </td>
                    <td>
                        <asp:TextBox ID="IdStr" runat="server" CssClass="ecomStd" Enabled="False"></asp:TextBox>
                        <input type="button" runat="server" id="BtnEditGroupId" class="newUIbutton" onclick="dialog.show('EditGroupIdDialog');" value="Edit group id"/>
                    </td>
                </tr>
                <tr style="display:none;" id="product-workflow-editor">
                    <td><dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Workflow"></dw:TranslateLabel></td>
                    <td>                        
                        <asp:DropDownList id="ProductWorkflow" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                        &nbsp;
                        <asp:ImageButton runat="server" ID="ApplyWorkflow" OnClick="OnApplyWorkflow" style="position: inherit; top: 3px"/>
                    </td>
                </tr>

			    <tr style="display:none;">
				    <td><dw:TranslateLabel id="tLabelPageIDRel" runat="server" Text="PageIDRel"/></td>
				    <td><asp:textbox id="Name_PageIDRelStr" runat="server" cssClass="ecomStd"/>
				    <asp:textbox id="ID_PageIDRelStr" style="display:none;" runat="server"/>&nbsp;
				    <img src="/Admin/images/Icons/Page_int.gif" onclick="javascript:internalEcom(0, '', 'PageIDRelStr', '');" align="absMiddle" class="H" alt="<%=Translate.JsTranslate("Internt link")%>"/>&nbsp;
				    <img src="/Admin/images/Icons/Page_Decline.gif" onclick="javascript:RemoveInternalEcom('PageIDRelStr');" align="absMiddle" class="H" alt="<%=Translate.JSTranslate("Slet link")%>"/></td>
			    </tr>			  
                <tr>
				    <td><dw:TranslateLabel id="tLabelProductCategory" runat="server" Text="Product category"></dw:TranslateLabel></td>
				    <td><asp:DropDownList id="ProductCategory" onchange="ProductCategoryChange(this);" CssClass="NewUIinput" runat="server"></asp:DropDownList></td>
			    </tr>
                <tr>
				    <td></td>
				    <td>
                        <dwc:CheckBox ID="InheritCategoryFieldsFromParent" Indent="false" Label="Inherit fields from parent" ClientIDMode="Static"  runat="server" />
                    </td>
			    </tr>
                <tr>
                    <td><dw:TranslateLabel id="TranslateLabel9" runat="server" Text="Beskrivelse"/></td>
                    <td><div style="width: 60%;"><dw:Editor id="Description" runat="server" ForceNew="true" InitFunction="true" WindowsOnLoad="false" GetClientHeight="false" width="60%"></dw:Editor></div></td>
                </tr>
    		</table>
            <input type="hidden" id="CurentProductCategory" value="<%=ProductCategory.SelectedIndex%>"/>
		</dwc:GroupBox>
		<dwc:GroupBox ID="MediaGroupbox" runat="server" Title="Media">
	    	<table class="formsTable">
			    <tr>
				    <td><dw:TranslateLabel id="tLabelSmallImg" runat="server" Text="Lille"></dw:TranslateLabel></td>
				    <td><dw:FileArchive runat="server" id="SmallImgStr" ShowPreview="True" MaxLength=255 cssClass="ecomStd"></dw:FileArchive></td>
			    </tr>
			    <tr>
				    <td><dw:TranslateLabel id="tLabelLargeImg" runat="server" Text="Stor"></dw:TranslateLabel></td>
				    <td><dw:FileArchive runat="server" id="LargeImgStr" ShowPreview="True" MaxLength="255" cssClass="ecomStd"></dw:FileArchive></td>
			    </tr>
			    <tr>
				    <td><dw:TranslateLabel id="tLabelIcon" runat="server" Text="Ikon"></dw:TranslateLabel></td>
				    <td><dw:FileArchive runat="server" id="IconStr" ShowPreview="True" MaxLength="255" cssClass="ecomStd"></dw:FileArchive></td>
			    </tr>					
		    </table>
		</dwc:GroupBox>
        <dwc:GroupBox ID="MetaInfoGroupBox" runat="server" Title="Meta information">
			<table class="formsTable">
				<tr>
					<td><dw:TranslateLabel id="TranslateLabel2" runat="server" Text="Title"></dw:TranslateLabel></td>
					<td><asp:textbox id="MetaTitle" CssClass="NewUIinput product-meta-title" runat="server"></asp:textbox></td>
				</tr>
				<tr>
					<td><dw:TranslateLabel id="TranslateLabel3" runat="server" Text="Keywords"></dw:TranslateLabel></td>
					<td><asp:textbox id="MetaKeywords" CssClass="NewUIinput product-meta-keywords" runat="server"></asp:textbox></td>
				</tr>
				<tr>
					<td><dw:TranslateLabel id="TranslateLabel4" runat="server" Text="Description"></dw:TranslateLabel></td>
					<td><asp:textbox id="MetaDescr" TextMode="MultiLine" Columns="30" Rows="4" CssClass="NewUIinput product-meta-description" runat="server"></asp:textbox></td>
				</tr>
                <tr>
					<td><dw:TranslateLabel id="TranslateLabel7" runat="server" Text="Canonical page"></dw:TranslateLabel></td>
					<td><asp:textbox id="MetaCanonical" MaxLength="255" CssClass="NewUIinput" runat="server"></asp:textbox></td>
				</tr>
				<tr>
					<td><dw:TranslateLabel id="TranslateLabel5" runat="server" Text="URL"></dw:TranslateLabel></td>
					<td>
						<asp:textbox id="MetaUrl" CssClass="NewUIinput product-meta-url" runat="server" />
					</td>
				</tr>
                <tr>
					<td></td>
					<td>
                        <dwc:CheckBox ID="MetaUrlIgnoreParent" Indent="false" Label="Ignore parent groups in URL" ClientIDMode="Static"  runat="server" />
					</td>
				</tr>
				<tr>
					<td><dw:TranslateLabel id="TranslateLabel6" runat="server" Text="Primary page"></dw:TranslateLabel></td>
					<td>
                        <dw:LinkManager ID="MetaPrimaryPage" DisableParagraphSelector="true" DisableFileArchive="true" runat="server" />
					</td>
				</tr>
			</table>
		</dwc:GroupBox>
		<dwc:GroupBox ID="DefaultValuesGroupbox" runat="server" Title="Default values for new products">
	    	<table class="formsTable">
			    <tr>
				    <td><dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Manufacturer"></dw:TranslateLabel></td>
				    <td>
                        <asp:DropDownList id="ManufacturerID" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                        &nbsp;
                        <asp:ImageButton runat="server" ID="ApplyManufacturer" OnClick="OnApplyManufacturer" style="position: inherit; top: 3px"/>
                    </td>
			    </tr>
			    <tr>
				    <td><dw:TranslateLabel runat="server" Text="Moms gruppe"></dw:TranslateLabel></td>
				    <td>
                        <asp:DropDownList id="VatGrpID" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                        &nbsp;
                        <asp:ImageButton runat="server" ID="ApplyVatGroup" OnClick="OnApplyVatGroup" style="position: inherit; top: 3px"/>
                    </td>
			    </tr>
			    <tr>
				    <td><dw:TranslateLabel id="tLabelStockGroupID" runat="server" Text="Lagerstatus"></dw:TranslateLabel></td>
                    <td>
                        <asp:DropDownList id="StockGroupID" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                        &nbsp;
                        <asp:ImageButton runat="server" ID="ApplyStockGroup" OnClick="OnApplyStockGroup" style="position: inherit; top: 3px"/>
                    </td>
			    </tr>					
		    </table>
		</dwc:GroupBox>
		<dwc:GroupBox ID="DiscountsContainer" runat="server" Title="Discounts">
            <asp:CheckBoxList runat="server" ID="Discounts" RepeatColumns="3" />
		</dwc:GroupBox>

        <div id="ProductCustomFields">
        <dwc:GroupBox ID="GroupBox1" runat="server" Title="Varegruppefelter">
		    <asp:Literal id="GroupFieldList" runat="server"></asp:Literal>
        </dwc:GroupBox>
            <a></a>
        </div>

		<div id="ProductCategoriesBlock" class="groupbox">
            <asp:Literal id="GroupCategoriesFieldList" runat="server"></asp:Literal>
		</div>

        <dwc:GroupBox ID="Facets" runat="server" Title="Facets" ClassName="facets">
            <asp:Repeater id="RepositoryRepeater" runat="server" EnableViewState="false" OnItemDataBound="RepositoryRepeater_ItemDataBound">
                <ItemTemplate>
                    <dwc:GroupBox id="RepositoryInfo" runat="server" DoTranslation="false" Expandable="True" >
                        <asp:HiddenField id="RepositoryName" runat="server" />
                        <asp:Repeater id="FacetGroupRepeater" runat="server" EnableViewState="false" OnItemDataBound="FacetGroupRepeater_OnItemDataBound">
                            <ItemTemplate>
                                <dwc:RadioGroup ID="FacetsGroupModeSelector" Name="FacetsGroupModeSelector" Indent="True" runat="server" Label="" SelectedValue="all" >
                                    <dwc:RadioButton ID="VariantsMode" Label="All" runat="server" FieldValue="all"></dwc:RadioButton>
                                    <dwc:RadioButton ID="FamilyMode" Label="None" runat="server" FieldValue="none"></dwc:RadioButton>
                                    <dwc:RadioButton ID="RadioButton1" Label="Specific" runat="server" FieldValue="specific"></dwc:RadioButton>
                                </dwc:RadioGroup>
                                <asp:Panel runat="server" id="SpecificFacetsSelectorContainer" class="specific-facets-selector-container">
                                    <dw:SelectionBox ID="SpecificFacetsSelector" runat="server" Width="250" LeftHeader="Unselected facets" RightHeader="Selected facets" ShowSortRight="True" /> 
                                </asp:Panel>
                                <br />
                                <asp:HiddenField id="FacetGroupName" runat="server" />
                                <asp:HiddenField id="FacetsStorageLeft" runat="server" />
                                <asp:HiddenField id="FacetsStorageRight" runat="server" />
                                <asp:HiddenField id="FacetsStorageLeftRightIsChanged" runat="server" />
                            </ItemTemplate>
                        </asp:Repeater>
                    </dwc:GroupBox>
                </ItemTemplate>
            </asp:Repeater>
        </dwc:GroupBox>
        <dwc:GroupBox runat="server" Title="Completion rules" ID="CompletionRulesGroupBox">
            <dw:SelectionBox ID="CompletionRulesSelector" runat="server" Width="250" Label="Completion rules" ClientIDMode="Static" />
            <input type="hidden" name="CompletionRuleIDs" id="CompletionRuleIDs" value="" runat="server" clientidmode="Static" />
            <dw:SelectionBox ID="CompletionLangs" runat="server" Width="250" Label="Languages" ClientIDMode="Static" />
            <input type="hidden" name="CompletionLangsIDs" id="CompletionLangsIDs" value="" runat="server" clientidmode="Static" />
        </dwc:GroupBox>
        <dwc:GroupBox runat="server" Title="Auto product relation rules" ID="ProductRelationRulesGroupBox">
            <dwc:SelectPicker runat="server" ID="ProductRelationRuleField1" Label="Field"></dwc:SelectPicker>
            <dwc:InputText runat="server" ID="ProductRelationRuleValue1" Label="Value"></dwc:InputText>
            <dwc:SelectPicker runat="server" ID="ProductRelationRuleField2" Label="Field"></dwc:SelectPicker>
            <dwc:InputText runat="server" ID="ProductRelationRuleValue2" Label="Value"></dwc:InputText>
        </dwc:GroupBox>
	</div>
	
	</td></tr>
	</table>
	
	<div class="groupTab groupbox" id="locationTab" style="display:none;">
		<div id="GrpRelData">
		    <asp:Literal id="GroupList" runat="server"/>
		</div>
	</div>
	
	<div class="groupTab groupbox" id="relatedGroupsTab" style="display:none;">
	</div>

	<div class="groupTab groupbox" id="relatedProductsTab" style="display:none;">
	</div>

	<div class="groupTab groupbox" id="orderlineTab" style="display:none;">
	    <input type="hidden" id="OrderLineFieldCount" name="OrderLineFieldCount" value="0" />
	    <fieldset><legend class="gbTitle"><%=Translate.Translate("Orderline fields")%>&nbsp;</legend>
	        <label for="OrderLineFieldsInheritCheckbox">
	            <dw:TranslateLabel runat="server" Text="Inherit orderlinefields from parent groups" />
	        </label>
	        <asp:CheckBox runat="server" ID="OrderLineFieldsInheritCheckbox" />
	        <br />
	        <asp:Literal id="OrderLineFieldsLiteral" runat="server"></asp:Literal>
	                    
	        <div <%=IIf(OrderLineFieldsInheritCheckbox.Checked, "", "style=""display: none;""") %>>
	            <asp:Literal id="OrderLineFieldsInheritedLiteral" runat="server"></asp:Literal>
	        </div>
	    </fieldset>
    </div>

    <div class="groupTab groupbox" id="discountsTab" style="display:none;">
    </div>

	</td>
	</tr>
	</table>				
	</dw:StretchedContainer>
	
    <!-- Edit Group Id Dialog -->
    <dw:Dialog runat="server" ID="EditGroupIdDialog" Title="Edit group id" ShowCancelButton="true" ShowOkButton="true" OkText="Apply" OkAction="saveAndCloseEditGroupIdDlg();">        
		<table cellpadding="1" cellspacing="1">
            <tr>
			    <td><dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="New group id" /></td>
			    <td><input type="text" id="txtEditedGroupId" maxlength="255" class="NewUIinput" /></td>
		    </tr>            
		</table>
    </dw:Dialog>
	
    <!-- Add related group or product dialog -->
    <dw:Dialog runat="server" ID="GroupEditMiscDialog" HidePadding="True">
        <iframe id="GroupEditMiscDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <omc:MarketingConfiguration ID="marketConfig" runat="server" />

	<script type="text/javascript">
	    addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
	    activateValidation('Form1');
    </script>
    
    <script type="text/javascript">

        function ResizeFckEditor() {
            var pText = $('Description___Frame');
            var h = getClientHeight(0, 'Description');
            if (pText)
                pText.setStyle({ height: (h) + 'px' });
        }

        function getClientHeight(Height, Name) {
            if (Name == 'Description') {
                var h = document.documentElement.clientHeight;
                h -= $("myribbon").getHeight();
                h -= $("breadcrumb").getHeight();
                h -= $("LocationMenu").getHeight();
                if (h < 0) h = 0;
                if (h >= 20) h -= 20;
                return h;
            }
            else {
                return Height;
            }
        }

        window.onload = function () {
            if (window.editor) {
                window.editor.init();
            }
            InitGroupField();
        }

        window.onresize = function () {
            ResizeFckEditor();
        }

        function saveAndCloseEditGroupIdDlg() {
            var groupId = document.getElementById("txtEditedGroupId").value;

            if (groupId == '') {
                alert('<%=Translate.JsTranslate("The group id cannot be empty.")%>');
                document.getElementById("txtEditedGroupId").focus();
            } else {
                new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/Edit/EcomGroup_Edit.aspx?CMD=CheckGroupId&EditedGroupID=" + groupId, {
                    method: 'get',
                    onSuccess: function (transport) {
                        if (transport.responseText != "true") {
                            alert('<%=Translate.JsTranslate("The group id is already in use and cannot be used again.")%>');
	                }
	                else {
	                    if (confirm('<%=Translate.JsTranslate("The group id will be updated and it cannot be undone")%>')) {
	                        dialog.hide('EditGroupIdDialog');
	                        document.getElementById('Form1').action = "EcomGroup_Edit.aspx?CMD=UpdateGroupId&EditedGroupID=" + groupId + "&ID=" + globalGroupId +
                                "&shopID=" + globalShopId + "&parentID=" + globalParentId;
	                        document.getElementById('Form1').submit();
	                    }
	                }
	            },
	            onFailure: function () {
	                alert('<%=Translate.JsTranslate("Error checking existing group id.")%>');
	            }
	        });
        }
    }
	</script>
	
	<iframe name="EcomUpdator" id="EcomUpdator" width="501" height="501" align="right" marginwidth="0" marginheight="0" border="0" frameborder="0" src="EcomUpdator.aspx"></iframe>
	
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</asp:content>
