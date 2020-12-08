<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomPriceEdit.aspx.vb" Inherits="Dynamicweb.Admin.EcomPriceEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Images/Controls/EditableList/EditableListEditors.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />            
        </Items>
    </dw:ControlResources>
    <script>
        function createPriceEditPage(opts) {
            let dialogId = "ProductPricesDialog";
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },

                save: function (close) {
                    let cmd = document.getElementById('cmdSubmit');
                    cmd.value = !!close ? "SaveAndClose" : "Save";
                    __doPostBack();
                },

                delete: function () {
                    Action.Execute(this.options.actions.delete, { ProductId: this.options.productId, ids:  this.options.priceId });
                },

                cancel: function () {
                    Action.Execute(this.options.actions.cancel);
                }
            };
            obj.init(opts);
            return obj;
        }
    </script>
</head>

<body>
    <form id="MainForm" runat="server" defaultfocus="Amount">
        <dwc:Card runat="server">
            <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(true);" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Icon="Remove" Text="Delete price" OnClientClick="currentPage.delete()" Disabled="true" />
                <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dwc:GroupBox ID="gbSettings" Title="General" runat="server">
                    <dwc:InputText ID="PriceIdentifier" runat="server" Label="Id" Disabled="true" />
                    <dwc:RadioGroup runat="server" ID="IsWithVAT">
                        <dwc:RadioButton FieldValue="WithoutVat" Label="Price without VAT" runat="server" />
                        <dwc:RadioButton FieldValue="WithVat" Label="Price with VAT" runat="server" />
                    </dwc:RadioGroup>
                    <div class="dw-ctrl number-ctrl form-group">
		                <label class="control-label"><dw:TranslateLabel runat="server" Text="Price" /></label>	
                        <div class="form-group-input">
                            <div style="display:inline;float:left;padding-right: 6px;">
                                <input runat="server" id="Amount" name="Amount" class="form-control std" type="number" step="0.1" min="0" value="0" data-number-type="integer">
                            </div>
			            </div>
		            </div>
                    <dwc:SelectPicker ID="CurrencyCode" runat="server" Label="Currency" />
                    <dwc:SelectPicker ID="Variant" runat="server" Label="Variant" />
                    <div class="form-group">
                        <label class="control-label">
                            <dw:TranslateLabel runat="server" Text="User" />
                        </label>
                        <dw:EditableListColumnUserEditor ID="UserID_CustomSelector" runat="server" />
                    </div>
                    <div class="form-group">
                        <label class="control-label">
                            <dw:TranslateLabel runat="server" Text="User group" />
                        </label>
                        <dw:EditableListColumnUserEditor ID="UserGroupID_CustomSelector" Select="Group" runat="server" />
                    </div>
                    <dwc:InputText ID="CustomerNumber" runat="server" Label="Customer Number" />
                    <dw:DateSelector runat="server" ID="ValidFrom" IncludeTime="false" AllowEmpty="true" Label="Valid From" all />
                    <dw:DateSelector runat="server" ID="ValidTo" IncludeTime="false" AllowEmpty="true" Label="Valid To" />
                    <dwc:SelectPicker ID="Publication" runat="server" Label="Campaign" />
                    <dwc:SelectPicker ID="Unit" runat="server" Label="Unit" />
                    <dwc:SelectPicker ID="StockLocation" runat="server" Label="Stock location" />
                    <dwc:SelectPicker ID="Language" runat="server" Label="Language" />
                    <dwc:SelectPicker ID="CountryCode" runat="server" Label="Country" />
                    <dwc:SelectPicker ID="Shop" runat="server" Label="Shop " />
                    <dwc:InputNumber ID="Quantity" runat="server" Label="Quantity" Min="0" />
                    <dwc:CheckBox ID="IsInformative" runat="server" Label="Is informative" />
                </dwc:GroupBox>
            </dwc:CardBody>
        </dwc:Card>
        <input type="hidden" id="cmdSubmit" name="cmdSubmit" value="" />
    </form>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>

