<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="eCom_economic_edit.aspx.vb" Inherits="Dynamicweb.Admin.eCom_economic_edit" %>

<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="/Admin/Validation.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Ajax.js"></script>       
    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function () {
            if ($("economic_settings_box").visible()) {
                $("selectList_orderlayouts").name = "/Globalsettings/Ecom/EconomicIntegration/Ordering/DebitorOrderLayout";
                $("selectList_paymentconditions").name = "/Globalsettings/Ecom/EconomicIntegration/Ordering/Paymentcondition";
                $("selectList_debitorgroup").name = "/Globalsettings/Ecom/EconomicIntegration/Ordering/DebitorGroup";
            }
            $("MainForm").submit();
        }

        function checkConnection() {
            $("economic_settings_box").show();

            Toolbar.setButtonIsDisabled('cmdSave', true);
            Toolbar.setButtonIsDisabled('cmdSaveAndClose', true);
            Toolbar.setButtonIsDisabled('cmdCancel', true);
            Toolbar.setButtonIsDisabled('cmdHelp', true);

            $('selectList_orderlayouts').addClassName('disabledSelect');
            $('selectList_paymentconditions').addClassName('disabledSelect');
            $('selectList_debitorgroup').addClassName('disabledSelect');

            authenticate();
        }

        function authenticate() {
            var msg = '<%=Dynamicweb.Ecommerce.Common.Gui.AlertMessageBox(Translate.Translate("Please wait..."), "100%")%>';
            var ok = '<%=Dynamicweb.Ecommerce.Common.Gui.AlertMessageBox(Translate.Translate("Connection successful"), "100%")%>';
            var err = '<%=Dynamicweb.Ecommerce.Common.Gui.AlertMessageBox(Translate.Translate("Could not connect"), "100%")%>';

            $("e_credential_msg").update(msg);

            new Ajax.Request('ecom_economic_edit.aspx?ajax=authentication', {
                method: 'get',
                onComplete: function (transport) {
                    if (200 == transport.status) {
                        Toolbar.setButtonIsDisabled('cmdSave', false);
                        Toolbar.setButtonIsDisabled('cmdSaveAndClose', false);
                        Toolbar.setButtonIsDisabled('cmdCancel', false);
                        Toolbar.setButtonIsDisabled('cmdHelp', false);
                    }
                },
                onSuccess: function (transport) {
                    if (transport.responseText == "1") {

                        loadData("orderlayouts");
                        loadData("paymentconditions");
                        loadData("debitorgroup");

                        loadData("productgroups");

                        $("e_credential_msg").update(ok);
                    } else {
                        $("e_credential_msg").update(err);
                        $("economic_settings_box").hide();
                    }
                },
                onFailure: function () {
                    $("e_credential_msg").update(err);
                    $("economic_settings_box").hide();
                }
            });

        }

        //get json
        function loadData(method, param) {
            if (method == "orderlayouts" || method == "paymentconditions" || method == "debitorgroup") {

                $('wait_' + method).visible();
                Dynamicweb.Ajax.getObject('ecom_economic_edit.aspx?ajax=' + method, {
                    onComplete: function (json) {

                        for (var field in json) {
                            if (typeof (json[field]) != "function") {
                                var selectList = $('selectList_' + method);
                                AddSelectOption(selectList, json[field].Text, json[field].Value, json[field].Selected);
                            }
                        }

                        //Remove wait and enable controls
                        $('wait_' + method).hide();

                        if (method == "orderlayouts") { $('selectList_orderlayouts').removeClassName('disabledSelect'); }
                        if (method == "paymentconditions") { $('selectList_paymentconditions').removeClassName('disabledSelect'); }
                        if (method == "debitorgroup") { $('selectList_debitorgroup').removeClassName('disabledSelect'); }

                    }
                });
            } else if (method == "productgroups") {
                $('wait_e_product_groups').show();
                var request = 'ecom_economic_edit.aspx?ajax=productgroups';
                if (param)
                    request += '&pageNumber=' + param;
                new Ajax.Request(request, {
                    method: 'get',
                    onComplete: function (transport) {
                        if (200 == transport.status) {
                            $('wait_e_product_groups').hide();
                        }
                    },
                    onSuccess: function (transport) {
                        if (transport.responseText != "") {
                            $("e_product_groups").update(transport.responseText);
                        }
                    }
                });
            }
        }

        function AddSelectOption(selectObj, text, value, isSelected) {
            if (selectObj != null && selectObj.options != null) {
                selectObj.options[selectObj.options.length] =
                    new Option(text, value, false, isSelected);
            }
        }

        //Used for dw:List paging
        if (typeof __doPostBack == 'undefined') {
            __doPostBack = function (eventTarget, eventArgument) {
                if (eventArgument && eventArgument.indexOf("PageIndexChanged:") == 0)
                    loadData("productgroups", eventArgument.replace("PageIndexChanged:", ""));
            };
        }

        if (typeof (Dynamicweb) == 'undefined') {
            var Dynamicweb = new Object();
        }

        if (typeof (Dynamicweb.Economic) == 'undefined') {
            Dynamicweb.Economic = new Object();
        }

        Dynamicweb.Economic.Authorize = {
            beginAuthorize: function () {
                window.open("/Admin/Public/Module/Economic/EconomicAuthorization.aspx");
            },
            onSuccess: function () {
                checkConnection();
            },
            onError: function (err) {
                $("e_credential_msg").update(err);
                $("economic_settings_box").hide();
            },
            resetApp: function () {
                var ol = new overlay("wait")
                ol.show();
                document.location = "/admin/module/ecom_economic/ecom_economic_edit.aspx?reset=true";
            }
        }
    </script>
    <style type="text/css">
        .disabledSelect {
            background-color: transparent;
            color: #C3C3C3;
            opacity: 0.4;
        }
    </style>
</asp:Content>



<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="lbSetup" Title="E-conomic integration"></dwc:CardHeader>
        <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
            <dw:ToolbarButton ID="AuthorizeBtn" runat="server" Text="Authorize" Icon="LockOpen" OnClientClick="Dynamicweb.Economic.Authorize.beginAuthorize();" />                                    
        </dw:Toolbar>        
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="CustomApp" Visible="false" runat="server">                
                <dw:Infobar runat="server" Message="You are using custom e-conomic application. Click the button below to use the Dynamicweb e-conomic app." Type="Warning"></dw:Infobar>
                <dwc:Button ID="ResetBtn" runat="server" Title="Use Dynamicweb e-conomic application" OnClick="Dynamicweb.Economic.Authorize.resetApp();" />                        
            </dwc:GroupBox>            
            <dwc:GroupBox ID="GroupBox1" runat="server" Title="Credentials">                
                <dwc:InputText runat="server" ID="AppPublicToken" Disabled="true" Label="App Public Token" />
                <dwc:InputText runat="server" ID="AppSecretToken" Disabled="true" Label="App Secret Token" />
                <dwc:InputText runat="server" ID="AgreementGrantToken" Disabled="true" Label="Agreement Grant Token" />
                <div id="e_credential_msg" style="color:red; padding:2px 5px 2px 5px; height:50px;"></div>
            </dwc:GroupBox>
            <div id="economic_settings_box" style="display:none;">                
                <dwc:GroupBox ID="GroupBox2" runat="server" Title="Order settings">
                    <dwc:CheckBox runat="server" ID="chkExportOrderOnComplete" Header="Export order to e-conomic on complete" Name="/Globalsettings/Ecom/EconomicIntegration/Ordering/ExportOrderOnComplete" />                    
                    
                    <table border="0" cellpadding="2" cellspacing="0" width="100%" style="table-layout: fixed">                    
                        <tr>
                            <td width="170">
                                <dw:TranslateLabel ID="TranslateLabel11" runat="server" Text="Order number prefix" />
                            </td>
                            <td>
                                <input type="text" class="std" value="<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/EconomicIntegration/Ordering/OrderNumberPrefix")%>" name="/Globalsettings/Ecom/EconomicIntegration/Ordering/OrderNumberPrefix" id="/Globalsettings/Ecom/EconomicIntegration/Ordering/OrderNumberPrefix" />
                            </td>
                        </tr>

                        <tr>
                            <td width="170">
                                <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Fee product number" />
                            </td>
                            <td>
                                <input type="text" class="std" value="<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/EconomicIntegration/Ordering/FeeProductNumber")%>" name="/Globalsettings/Ecom/EconomicIntegration/Ordering/FeeProductNumber" id="/Globalsettings/Ecom/EconomicIntegration/Ordering/FeeProductNumber" />
                            </td>
                        </tr>
                        <tr>
                            <td width="170">
                                <dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Discount product number" />
                            </td>
                            <td>
                                <input type="text" class="std" value="<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/EconomicIntegration/Ordering/DiscountProductNumber")%>" name="/Globalsettings/Ecom/EconomicIntegration/Ordering/DiscountProductNumber" id="/Globalsettings/Ecom/EconomicIntegration/Ordering/DiscountProductNumber" />
                            </td>
                        </tr>

                        <tr>
                            <td width="170">
                                <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Invoice Layout" />
                            </td>
                            <td>
                                <select name="selectList_orderlayouts" id="selectList_orderlayouts" class="std"><option value=""><%=Translate.Translate("None")%></option></select>
                                <img src="/Admin/Images/Ribbon/UI/Overlay/wait.gif" id="wait_orderlayouts" style="height:14px; width:14px;" />
                            </td>
                        </tr>

                        <tr>
                            <td width="170">
                                <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Payment Condition" />
                            </td>
                            <td>
                                <select name="selectList_paymentconditions" id="selectList_paymentconditions" class="std"><option value=""><%= Translate.Translate("None")%></option></select>
                                <img src="/Admin/Images/Ribbon/UI/Overlay/wait.gif" id="wait_paymentconditions" style="height:14px; width:14px;" />
                            </td>
                        </tr>

                        <tr>
                            <td width="170">
                                <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Debitor Group" />
                            </td>
                            <td>
                                <select name="selectList_debitorgroup" id="selectList_debitorgroup" class="std"><option value=""><%= Translate.Translate("None")%></option></select>
                                <img src="/Admin/Images/Ribbon/UI/Overlay/wait.gif" id="wait_debitorgroup" style="height:14px; width:14px;" />
                            </td>
                        </tr>

				    </table>
                    <dwc:CheckBox runat="server" ID="chkNotifyEanException" Header="Notify on EAN validation error" Name="/Globalsettings/Ecom/EconomicIntegration/Ordering/NotifyOnEanValidationError" />                    
                    <dwc:CheckBox runat="server" ID="chkCancelOrder" Header="Cancel orders with EAN validation error" Name="/Globalsettings/Ecom/EconomicIntegration/Ordering/CancelOrdersWithEanValidationError" />                    
                </dwc:GroupBox>                
                <dwc:GroupBox ID="GroupBox" runat="server" Title="Product Groups">
                    <table border="0" cellpadding="2" cellspacing="0" width="100%" style="table-layout: fixed">
                        <tr>
                            <td width="170" colspan="2">
                                <div id="wait_e_product_groups">
                                    <!--img src="/Admin/Images/Ribbon/UI/Overlay/wait.gif" id="Img1" style="height:14px; width:14px;" /-->
                                    <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Loading groups, please wait..." />
                                </div>
                                <div id="e_product_groups" style="min-height:100px;"></div>                                        
                            </td>
                        </tr>
				    </table>
                </dwc:GroupBox>				                    
                <dwc:GroupBox ID="GroupBox3" runat="server" Title="Notification settings">
                    <dwc:InputText runat="server" ID="txtSenderDisplayName" Label="Sender name" Name="/Globalsettings/Ecom/EconomicIntegration/Notification/SenderName" />
                    <dwc:InputText runat="server" ID="txtSenderEmail" Label="Sender e-mail" Name="/Globalsettings/Ecom/EconomicIntegration/Notification/SenderEmail" />
                    <dwc:InputText runat="server" ID="txtRecipients" Label="Recipients list" Info="Separate e-mails by semicolon or comma" Name="/Globalsettings/Ecom/EconomicIntegration/Notification/Recipients" />
                    <div class="form-group">
                        <label class="control-label">
                            <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Notification e-mail template" />
                        </label>
                        <dw:FileManager ID="templateSelector" runat="server" FixFieldName="true" ShowPreview="false" Folder="Templates/Economic/Notifications" Name="/Globalsettings/Ecom/EconomicIntegration/Notification/Template" />
                    </div>                    
                </dwc:GroupBox>
            </div>
            <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True"></dw:Overlay>
        </dwc:CardBody>
    </dwc:Card>    

   	<%
        Translate.GetEditOnlineScript()
	%>
    <asp:Literal ID="LoaderJavaScript" runat="server" />
</asp:Content>

