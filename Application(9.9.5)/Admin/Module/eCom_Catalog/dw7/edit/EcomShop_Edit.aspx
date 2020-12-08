<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomShop_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomShopEdit" EnableEventValidation="False" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.Security" %>
<%@ Import Namespace="Dynamicweb.Security.UserManagement" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>Shops</title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/shopEdit.js" />
            <dw:GenericResource Url="/Admin/FormValidation.js" />
            <dw:GenericResource Url="../images/AjaxAddInParameters.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var _saveId = '<%= SaveButton.ClientID %>'
        var _deleteId = '<%= DeleteButton.ClientID %>'

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('<%=NameStr.ClientID %>').focus();

            addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name needs to be specified")%>');
            activateValidation('Form1');
        });

        function newShop() {
            location.href = 'EcomShop_Edit.aspx?FromPIM=<%=Request("FromPIM")%>&ShopType<%=Request("ShopType")%>';
        }

        function save(doClose) {
            doClose = !!doClose;

            if (document.getElementById('NameStr').value.trim() == '') {
                dwGlobal.showControlErrors('NameStr', '<%= Translate.JsTranslate("Name cannot be empty") %>');
                return;
            }
            
            if (document.getElementById(_deleteId)) {
                document.getElementById(_deleteId).disabled = 'true';
            }

            if (document.getElementById('SaveAndCloseShopButton')) {
                document.getElementById('SaveAndCloseShopButton').disabled = 'true';
            }

            if (document.getElementById('SaveShopButton')) {
                document.getElementById('SaveShopButton').disabled = 'true';
            }

            if (document.getElementById('DeleteShopButton')) {
                document.getElementById('DeleteShopButton').disabled = 'true';
            }

            if (document.getElementById('NewShopButton')) {
                document.getElementById('NewShopButton').disabled = 'true';
            }

            if (document.getElementById('btnResetSortOrder')) {
                document.getElementById('btnResetSortOrder').disabled = 'true';
            }            
            
            $('doClose').value = doClose;
            $(_saveId).click();
        }

        function deleteShop() {
            var alertmsg = getAjaxPage("EcomUpdator.aspx?CMD=ShopCheckForGroups&shopID=<%=ShopId%>");
            if (confirm(alertmsg)) {
                $(_deleteId).click();
            }
        }

        function serializeStockLocations() {
            $("StockLocationId").value = SelectionBox.getElementsRightAsArray("StockLocationSelector");

            var rightValues = $('StockLocationSelector_lstRight');
            var selectPicker = $('DdlStockLocation');
            var oldVal = null;

            if (selectPicker.selectedIndex != -1)
                oldVal = selectPicker[selectPicker.selectedIndex].value;

            for (i = selectPicker.options.length - 1; i >= 0; i--)
                selectPicker.remove(i);

            if (rightValues.options.length == 0 || (rightValues.options.length == 1 && rightValues.options[0].value == 'StockLocationSelector_lstRight_no_data'))
                selectPicker.disabled = true;
            else {
                var selIndex = 0;
                selectPicker.disabled = false;
                selectPicker.options[0] = new Option('<%= Translate.Translate("Nothing selected")%>', '0')

                for (i = 0; i < rightValues.length; i++) {
                    if (rightValues.options[i].value != 'StockLocationSelector_lstRight_no_data') {
                        selectPicker.options[i + 1] = new Option(rightValues.options[i].text, rightValues.options[i].value);

                        if (selectPicker.options[i + 1].value == oldVal)
                            selIndex = i + 1;
                    }
                }

                selectPicker.selectedIndex = selIndex;
            }
        }

        function serializeOrderLineFields() {
            $("OrderLineFieldsId").value = SelectionBox.getElementsRightAsArray("OrderLineFieldsSelector");
        }

        function serializeShopLanguages(controlId, defaultSelectorId) {

            $(controlId + "IDs").value = SelectionBox.getElementsRightAsArray(controlId);

            var sel = $(defaultSelectorId);

            if (sel) {
                var rArr = $(controlId+'_lstRight');
                var oldVal = null;
                if (sel.selectedIndex != -1)
                    oldVal = sel[sel.selectedIndex].value;

                for (i = sel.options.length - 1; i >= 0; i--)
                    sel.remove(i);

                if (rArr.options.length == 0 || (rArr.options.length == 1 && rArr.options[0].value == (controlId+'_lstRight_no_data')))
                    sel.disabled = true;
                else {
                    var selIndex = 0;
                    sel.disabled = false;

                    for (i = 0; i < rArr.length; i++) {

                        if (rArr.options[i].value != (controlId+'_lstRight_no_data')) {
                            sel.options[i] = new Option(rArr.options[i].text, rArr.options[i].value);

                            if (sel.options[i].value == oldVal)
                                selIndex = i;
                        }
                    }

                    sel.selectedIndex = selIndex;
                }
            }
        }

        function serializeShopCompletionRules() {
            $("CompletionRuleIDs").value = SelectionBox.getElementsRightAsArray("CompletionRulesSelector");
        }

        function openPermissionsDialog() {
            <%= GetPermissionsShowAction() %>
        }
        
        function openAuditDialog() {
            <%=GetAuditDialogAction()%>
        }

    </script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="Form1" method="post" runat="server">
            <dw:Overlay ID="__ribbonOverlay" runat="server"></dw:Overlay>
            <input type="hidden" id="doClose" name="doClose" value="" />
            <input type="hidden" id="FromPIM" name="FromPIM" value="" runat="server" />
            <input type="hidden" id="ShopType" name="ShopType" value="<%=Request("ShopType")%>"/>
            <input type="hidden" id="ConvertOldImages" name="ConvertOldImages" value="false" />
            <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <dwc:InputText runat="server" ID="NameStr" Label="Navn" MaxLength="255" ValidationMessage="" />
                <dwc:InputText runat="server" ID="IdStr" Label="ID" Disabled="true" />
                <dw:FileManager runat="server" ID="ImageSelector" Folder="/Images" FullPath="true" Label="Icon" />
                <dwc:CheckBox runat="server" ID="IsDefault" Label="Standard" />
                <dwc:CheckBox runat="server" ID="IsDefaultTmp" Label="Standard" Enabled="false" />
                <dwc:InputText runat="server" ID="CreatedStr" Label="Oprettet" Disabled="true" />
                <dwc:SelectPicker runat="server" ID="OrderflowSelect" Label="Orderflow"></dwc:SelectPicker>
                <%If License.IsModuleAvailable("eCom_MultiShopAdvanced") Then%>
                <dwc:SelectPicker runat="server" ID="StockStateList" Label="Default stock state"></dwc:SelectPicker>
                <%End If%>
                <dwc:SelectPicker runat="server" ID="OrderContextList" Label="Default context cart"></dwc:SelectPicker>
                <dw:FileManager Folder="Templates/eCom7/Order" ID="PrintTemplate" Label="Default print template" runat="server" />
                <div class="form-group" runat="server" id="PreviewPageDiv"> 
                    <label class="control-label">
                        <dw:TranslateLabel runat="server" Text="Preview page"></dw:TranslateLabel>
                    </label>
                    <dw:LinkManager runat="server" Name="PrimaryPage" ID="PrimaryPage" DisableParagraphSelector="true" DisableFileArchive="true"  />
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Available as">                
                <dwc:RadioGroup runat="server" ID="ShopUsageType" Name="ShopUsageType" SelectedValue="Shop">
                    <dwc:RadioButton runat="server" FieldValue="Shop" Label="Shop" />
                    <dwc:RadioButton runat="server" FieldValue="Warehouse" Label="Warehouse" />
                    <dwc:RadioButton runat="server" FieldValue="Channel" Label="Channel" />
                </dwc:RadioGroup>
            </dwc:GroupBox>
            <%If License.IsModuleAvailable("eCom_MultiShopAdvanced") Then%>
            <dwc:GroupBox runat="server" Title="Languages" ID="languagesGroupBox">
                <dw:SelectionBox ID="sboxLangs" runat="server" Width="250" Label="Languages" ClientIDMode="Static" />
                <input type="hidden" name="sboxLangsIDs" id="sboxLangsIDs" value="" runat="server" clientidmode="Static" />
                <dwc:SelectPicker runat="server" ID="DdlDefLangId" Label="Default language" ClientIDMode="Static"></dwc:SelectPicker>
            </dwc:GroupBox>
            <%End If%>            
            <dwc:GroupBox runat="server" Title="Completion rules" ID="CompletionRulesGroupBox">
                <dw:SelectionBox ID="CompletionRulesSelector" runat="server" Width="250" Label="Completion rules" ClientIDMode="Static" />
                <input type="hidden" name="CompletionRuleIDs" id="CompletionRuleIDs" value="" runat="server" clientidmode="Static" />
                <dw:SelectionBox ID="CompletionLangs" runat="server" Width="250" Label="Languages" ClientIDMode="Static" />
                <input type="hidden" name="CompletionLangsIDs" id="CompletionLangsIDs" value="" runat="server" clientidmode="Static" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Stock locations" ID="stockLocationsGroupBox">
                <dw:SelectionBox ID="StockLocationSelector" Width="250" Label="Stock locations" runat="server" />
                <input type="hidden" name="StockLocationID" id="StockLocationId" value="" runat="server" clientidmode="Static" />
                <dwc:SelectPicker runat="server" ID="DdlStockLocation" Label="Default stock location" ClientIDMode="Static"></dwc:SelectPicker>
            </dwc:GroupBox>            
            <dwc:GroupBox ID="AlternativeImagesGroupBox" runat="server" Title="Alternative images">
                <div id="PatternsWarningContainer" runat="server" >
                    <dw:Infobar runat="server" Type="Warning" Message="Using search in subfolders option can cause bad performance"></dw:Infobar>
                    <br/>
                </div>
                <dwc:CheckBox ID="UseAlternativeImages" runat="server" Label="Brug alternative billeder" OnClick="backend.toggleUseAltImage(this);" />                
                <div id="AlternativeImageSection" runat="server">
                    <dw:FolderManager ID="ImageFolder" runat="server" Label="Billed mappe"></dw:FolderManager>
                    <dwc:CheckBox ID="ImageSearchInSubfolders" runat="server" Label="Search in subfolders" OnClick="backend.toggleSearchInSubfolders(this);" />  
                    
                    <div class="form-group">
                        <strong><%=Translate.Translate("File name pattern")%></strong>
                    </div>

                    <div id="ImagePatternsContainer" runat="server"> 
                        <dwc:InputText runat="server" ID="ImagePatternS" Label="Lille" Value="" />
                        <dwc:InputText runat="server" ID="ImagePatternM" Label="Medium" Value="" />
                        <dwc:InputText runat="server" ID="ImagePatternL" Label="Stor" Value="" />
                        <div class="form-group">
                            <label class="control-label">&nbsp;</label>
                            <div class="form-group-input">
                                <dwc:Button Title="Convert from deprecated image features" id="ConvertImages" runat="server"  />
                            </div>
                        </div>
                    </div>
                    <dwc:InputText runat="server" ID="MainProductPattern" Label="Main product" Value="/{ProductNumber}{VariantOptionLevel1}.jpg" visible="false" />
                    <dwc:InputText runat="server" ID="VariantProductPattern" Label="Variant product" Value="/{ProductNumber}{VariantOptionLevel1}.jpg" visible="false" />
                    <div class="form-group">
                    <label class="control-label">&nbsp;</label>
    	            <div class="form-group-input">
                        <small>{ProductID}, {ProductNumber}, {ProductEAN}, {ProductName}, {GroupID}, {VariantID}, {VariantOptionIdLevel1}, {VariantOptionLevel1}, {*CustomFieldSystemName*}</small>
	                </div>
                </div>                
                    
                    <dw:EditableGrid ID="UserDefinedPatterns" runat="server" AllowAddingRows="true" AllowDeletingRows="true" AddNewRowMessage="Click here to add new row">
                        <Columns>                            
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <dwc:InputText runat="server" ID="PatternName" />
                                    <asp:HiddenField runat="server" ID="WidthHidden" />
                                    <asp:HiddenField runat="server" ID="HeightHidden" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-Width="60%" >
                                <ItemTemplate>
                                    <dwc:InputText runat="server" ID="Pattern" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <dwc:Radiobutton runat="server" ID="IsDefaultPattern" FieldName="IsDefaultPattern" ClientIDMode="Static" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <dwc:InputText runat="server" ID="Width" Min="0" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <dwc:InputText runat="server" ID="Height" Min="0" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="center">
                                <ItemTemplate>
                                    <i ID="RemovePattern" runat="server" class='fa fa-remove color-danger pointer'></i>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </dw:EditableGrid>
                </div>
            </dwc:GroupBox>
            <input type="hidden" id="OrderLineFieldCount" name="OrderLineFieldCount" value="0" />            
            <dwc:GroupBox ID="OrderLineFields" runat="server" Title="Order line fields">
                <dw:SelectionBox ID="OrderLineFieldsSelector" ShowSortRight="false" runat="server" Width="250" Label="Order line fields" ClientIDMode="Static" />
                <input type="hidden" name="OrderLineFieldsId" id="OrderLineFieldsId" value="" runat="server" clientidmode="Static" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Indexing">
                <dwc:CheckBox runat="server" ID="BuildProductIndexAfterProductUpdate" Label="Auto build index when products update" />
                <div class="form-group">
                    <label class="control-label"><%= Translate.Translate("Index") %></label>
    	            <div class="form-group-input">
                        <dw:GroupDropDownList runat="server" ID="ProductIndex" CssClass="selectpicker" Label=""></dw:GroupDropDownList>
	                </div>
                </div>                
            </dwc:GroupBox>
            <asp:Button ID="SaveButton" Style="display: none" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" runat="server"></asp:Button>
        </form>
        <% If Not String.IsNullOrEmpty(Request("ecom7mode")) AndAlso String.Compare(Request("ecom7mode"), "management", True) = 0 Then%>
        <asp:Literal ID="RemoveDelete" runat="server"></asp:Literal>
        <% End If%>
    </div>
</body>
</html>
