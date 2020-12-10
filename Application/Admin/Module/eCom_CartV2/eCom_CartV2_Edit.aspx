<%@ Page Language="vb" AutoEventWireup="false" MaintainScrollPositionOnPostback="true" CodeBehind="eCom_CartV2_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eCom_CartV2_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<input type="hidden" name="eCom_CartV2_settings" id="eCom_CartV2_settings" value="SelectedValidations,ValidationGroups,UseNewsletterSubscription,NewsletterSubscribers,EmptyCartRadio,EmptyCartRedirectPage,EmptyCartTemplate,OnReEnterRadio,CountryForShippingRadio,CountryForPaymentRadio,ShopSelector,CartSelector,CustomerAcceptedErrorMessage,DoValidateCustomerAccepted,RemoveNoneExistingProductsRadio,SetUserDetailsRadio,ImagePatternProductCatalog,SelectAllPayments,PaymetTypes,SelectAllDeliveries,DeliveryTypes,DoCreateUserInCheckout,CreateNewUserGroupsHidden,DoUpdateUsersByEmail,ErrorEmtyUsername,ErrorUsernameTaken,ErrorEmtyPassword,ErrorPasswordsNotMatch,ErrorPasswordLength,ErrorIllegalPasswordCharacters,DoValidateStockStatus,StockStatusErrorMessage,CheckoutToQuote" />
<input type="hidden" runat="server" id="StepsJSON" value="[]" />
<input type="hidden" runat="server" id="MailsJSON" value="[]" />
<input type="hidden" runat="server" id="ValidationJSON" value="[]" />
<input type="hidden" runat="server" id="NewsletterCategoriesJSON" value="[]" />

<script type="text/javascript" src="/Admin/Module/eCom_CartV2/javascript/tablednd.js"></script>
<script type="text/javascript" src="/Admin/Module/eCom_CartV2/javascript/Step.js"></script>
<script type="text/javascript" src="/Admin/Module/eCom_CartV2/javascript/Mail.js"></script>
<script type="text/javascript" src="/Admin/Module/eCom_CartV2/javascript/Validation.js"></script>

<dw:ModuleHeader runat="server" ModuleSystemName="eCom_CartV2" />

<!-- Shop -->
<dw:GroupBox runat="server" Title="Settings" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Shop" />
            </td>
            <td>
                <select id="ShopSelector" name="ShopSelector" runat="server" size="1" class="std"></select>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Context cart" />
            </td>
            <td>
                <select id="CartSelector" name="CartSelector" runat="server" size="1" class="std"></select>
            </td>
        </tr>
        <tr runat="server" id="StepQuoteRow">
            <td></td>
            <td>
                <label for="CheckoutToQuote">
                    <dw:CheckBox runat="server" id="CheckoutToQuote" name="CheckoutToQuote"></dw:CheckBox>
                    <dw:TranslateLabel runat="server" Text="Checkout to quote" />
                </label>
            </td>
        </tr>
    </table>

</dw:GroupBox>

<!-- Steps -->
<dw:GroupBox runat="server" Title="Steps" DoTranslation="true">

    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Steps" />
            </td>
            <td>
                <!-- table to show steps in -->
                <table id="StepsTable">
                </table>

                <!-- Add button -->
                <div class="btn btn-flat">
                    <a onclick="addNewStep();" title="<%=Dynamicweb.SystemTools.Translate.JsTranslate("Add new step") %>">
                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Core.UI.KnownColor.Success) %>"></i>
                        <dw:TranslateLabel runat="server" Text="Add step" />
                    </a>
                </div>
            </td>
        </tr>
    </table>


</dw:GroupBox>

<!-- Emails -->
<dw:GroupBox runat="server" Title="Notification e-mails" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Notification e-mails" />
            </td>
            <td>
                <!-- table to show emails in -->
                <table id="MailsTable">
                </table>

                <div style="height: 5px;">&nbsp;</div>

                <!-- Add button -->
                <div class="btn btn-flat">
                    <a onclick="addNewMail();" title="<%=Dynamicweb.SystemTools.Translate.JsTranslate("Add new notification e-mail") %>">
                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Core.UI.KnownColor.Success) %>"></i>
                        <dw:TranslateLabel runat="server" Text="Add notification" />
                    </a>
                </div>

            </td>
        </tr>
    </table>

</dw:GroupBox>

<!-- Validations -->
<dw:GroupBox runat="server" Title="Field validation" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td></td>
            <td>
                <dw:CheckBox runat="server" id="DoValidateCustomerAccepted" title="Validate that customer has accepted" Label="Customer acceptance"></dw:CheckBox>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Error message" />
            </td>
            <td>
                <input type="text" runat="server" id="CustomerAcceptedErrorMessage" class="std" size="60" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox runat="server" id="DoValidateStockStatus" Label="A check for stock status"></dw:CheckBox>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Error message" />
            </td>
            <td>
                <input type="text" runat="server" id="StockStatusErrorMessage" class="std" size="60" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Custom validation groups" />
            </td>
            <td>
                <style>
                    #ValidationContainer .std {
                        width: 100%;
                    }

                    #ValidationContainer table {
                        width: 60%;
                    }
                </style>
                <div id="ValidationContainer">
                </div>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <select runat="server" id="ValidationGroupSelector" class="std" style="vertical-align: middle;"></select>

                <button
                    onclick="var selector = document.getElementById('ValidationGroupSelector'); addNewValidationGroup(selector.value); selector.selectedIndex = 0; return false"
                    title="<%=Dynamicweb.SystemTools.Translate.JsTranslate("Add new validation group") %>"
                    class="btn btn-flat">
                    <dw:TranslateLabel runat="server" Text="Add" />
                </button>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<!-- Newsletter settings -->
<dw:GroupBox runat="server" Title="Newsletter" DoTranslation="true" ID="NewsletterGroupBox">
    <table class="formsTable">
        <tr>
            <td></td>
            <td>
                <dw:CheckBox runat="server" id="UseNewsletterSubscription" value="True" Label="Use email subscription"></dw:CheckBox>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<!-- Empty cart settings -->
<dw:GroupBox runat="server" Title="Empty cart" DoTranslation="true">

    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="When cart is empty" />
            </td>
            <td id="EmptyCartRadioGroup">
                <!-- Radios -->
                <div class="radio">
                    <input type="radio" runat="server" id="EmptyCartRadioRedirect" name="EmptyCartRadio" onclick="SwitchEmptyCartPanel(this);" />
                    <label for="EmptyCartRadioRedirect">
                        <dw:TranslateLabel runat="server" Text="Redirect to internal page" />
                    </label>
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="EmptyCartRadioTemplate" name="EmptyCartRadio" onclick="SwitchEmptyCartPanel(this);" />
                    <label for="EmptyCartRadioTemplate">
                        <dw:TranslateLabel runat="server" text="Show template" />
                    </label>
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="EmptyCartRadioNothing" name="EmptyCartRadio" onclick="SwitchEmptyCartPanel(this);" />
                    <label for="EmptyCartRadioNothing">
                        <dw:TranslateLabel runat="server" Text="Take no special action" />
                    </label>
                </div>
            </td>
        </tr>
        <tr runat="server" id="EmptyCartPanelRedirect">
            <td>
                <dw:TranslateLabel runat="server" Text="Redirect to internal page" />
            </td>
            <td>
                <dw:LinkManager runat="server" id="EmptyCartRedirectPage" DisableFileArchive="true"></dw:LinkManager>
            </td>
        </tr>
        <!-- Settings for template -->
        <tr runat="server" id="EmptyCartPanelTemplate">
            <td>
                <dw:TranslateLabel runat="server" Text="Show template" />
            </td>
            <td>
                <dw:FileManager runat="server" id="EmptyCartTemplate" Folder="Templates/eCom7/CartV2/Step" FullPath="false" />
            </td>
        </tr>
    </table>

    <script type="text/javascript">
        function SwitchEmptyCartPanel(radio) {
            document.getElementById("EmptyCartPanelRedirect").style.display = radio.id == 'EmptyCartRadioRedirect' ? '' : 'none'
            document.getElementById("EmptyCartPanelTemplate").style.display = radio.id == 'EmptyCartRadioTemplate' ? '' : 'none'
        }
        var checkedEl = document.querySelector("input[name=EmptyCartRadio]:checked");
        SwitchEmptyCartPanel(checkedEl);
    </script>

</dw:GroupBox>

<!-- UserManagement -->
<asp:panel runat="server" id="UserManagementSettingsPanel">
    <dw:GroupBox runat="server" Title="UserManagement" DoTranslation="true">
        <table class="formsTable">
            <tr>
                <td>
                    <dw:TranslateLabel runat="server" Text="Apply user details to order" />
                </td>
                <td>
                    <div class="radio">
                    <input type="radio" runat="server" id="SetUserDetailsRadioTrue" name="SetUserDetailsRadio" />
                    <label for="SetUserDetailsRadioTrue"><dw:TranslateLabel runat="server" Text="Enable" /></label>
                    </div>
                    
                    <div class="radio">
                    <input type="radio" runat="server" id="SetUserDetailsRadioFalse" name="SetUserDetailsRadio" />
                    <label for="SetUserDetailsRadioFalse"><dw:TranslateLabel runat="server" Text="Disable" /></label>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                </td>
                <td>
                    <dw:Checkbox runat="server" id="DoCreateUserInCheckout" onclick="Toggle_UserGroups();" Label="Create user in checkout"></dw:CheckBox>
                </td>
            </tr>
            <tr id="CreateNewUserGroupsRow">
                <td><dw:TranslateLabel runat="server" Text="Groups for new users" /></td>
                <td><dw:UserSelector runat="server" ID="CreateNewUserGroups" NoneSelectedText="No group selected" Show="Groups" HeightInRows="3"/></td>
            </tr>
            <tr id="CreateNewUserEmailRow">
                <td></td>
                <td><dw:CheckBox runat="server" id="DoUpdateUsersByEmail" name="DoUpdateUsersByEmail" Label="Update existing users based on email match"></dw:CheckBox></td>
            </tr>
            </table>
            <table class="formsTable" id="ErrorMessagesDiv">
            <tr>
                <td><strong><dw:TranslateLabel runat="server" Text="Error messages" /></strong></td>
                <td></td>
            </tr>
            <tr>
                    <td>
                        <dw:TranslateLabel runat="server" Text="Empty username" />
                        </td>
                        <td>
                        <input type="text" class="std" runat="server" name="ErrorEmtyUsername" id="ErrorEmtyUsername" value="" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                        <dw:TranslateLabel runat="server" Text="Username is taken" />
                        </td>
                        <td>
                        <input type="text" class="std" runat="server" name="ErrorUsernameTaken" id="ErrorUsernameTaken" value="" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                        <dw:TranslateLabel runat="server" Text="Empty password" />
                        </td>
                        <td>
                        <input type="text" class="std" runat="server" name="ErrorEmtyPassword" id="ErrorEmtyPassword" value="" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                        <dw:TranslateLabel runat="server" Text="Passwords do not match" />
                        </td>
                        <td>
                        <input type="text" class="std" runat="server" name="ErrorPasswordsNotMatch" id="ErrorPasswordsNotMatch" value="" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                        <dw:TranslateLabel runat="server" Text="Password length = 32" />
                        </td>
                        <td>
                        <input type="text" class="std" runat="server" name="ErrorPasswordLength" id="ErrorPasswordLength" value="" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                        <dw:TranslateLabel runat="server" Text="Illegal password characters" />
                        </td>
                        <td>
                        <input type="text" class="std" runat="server" name="ErrorIllegalPasswordCharacters" id="ErrorIllegalPasswordCharacters" value="" />
                        </td>
                    </tr>         
        </table>
    </dw:GroupBox>
</asp:panel>

<!-- Payment & delivery -->
<dw:GroupBox ID="grpPaymentAndDelivery" runat="server" Title="Payment & delivery" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Show" /> (<dw:TranslateLabel runat="server" Text="Betaling" />)
            </td>
            <td>
                <div class="radio">
                    <input type="radio" runat="server" id="PaymentRadioAll" name="PaymentSelectionType" onclick="Toggle_Payments();" />
                    <label for="PaymentRadioAll">
                        <dw:TranslateLabel runat="server" Text="All" />
                    </label>
                </div>
                <div class="radio">
                    <input type="radio" runat="server" id="PaymentRadioSelected" name="PaymentSelectionType" onclick="Toggle_Payments();" />
                    <label for="PaymentRadioSelected">
                        <dw:TranslateLabel runat="server" Text="Selected" />
                    </label>
                </div>
            </td>
        </tr>
        <tr id="PaymentsSelectorRow">
            <td></td>
            <td>
                <!-- Payment types -->
                <dw:SelectionBox ID="PaymentsSelector" runat="server" CssClass="std" />
                <input type="hidden" name="SelectAllPayments" id="SelectAllPayments" value="" runat="server" />
                <input type="hidden" name="PaymetTypes" id="PaymetTypes" value="" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Show" /> (<dw:TranslateLabel runat="server" Text="Shipping" />)
            </td>
            <td>
                <div class="radio">
                    <input type="radio" runat="server" id="DeliveryRadioAll" name="DeliverySelectionType" onclick="Toggle_Deliveries();" />
                    <label for="DeliveryRadioAll">
                        <dw:TranslateLabel runat="server" Text="All" />
                    </label>
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="DeliveryRadioSelected" name="DeliverySelectionType" onclick="Toggle_Deliveries();" />
                    <label for="DeliveryRadioSelected">
                        <dw:TranslateLabel runat="server" Text="Selected" />
                    </label>
                </div>
            </td>
        </tr>
        <tr id="DeliveriesSelectorRow">
            <td></td>
            <td>
                <!--  Delivery types -->
                <dw:SelectionBox ID="DeliveriesSelector" runat="server" CssClass="std" />
                <input type="hidden" name="SelectAllDeliveries" id="SelectAllDeliveries" value="" runat="server" />
                <input type="hidden" name="DeliveryTypes" id="DeliveryTypes" value="" runat="server" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<!-- Other settings -->
<dw:GroupBox runat="server" Title="Settings" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="When re-entering cart" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" runat="server" id="OnReEnterRadioFirstStep" name="OnReEnterRadio" />
                    <label for="OnReEnterRadioFirstStep">
                        <dw:TranslateLabel runat="server" Text="Show first step" />
                    </label>
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="OnReEnterRadioLastStepVisited" name="OnReEnterRadio" />
                    <label for="OnReEnterRadioLastStepVisited">
                        <dw:TranslateLabel runat="server" Text="Show last visited step" />
                    </label>
                </div>
            </td>
        </tr>

        <!-- Shipping method selection -->
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Country for shipping method" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" runat="server" id="CountryForShippingRadioCustomer" name="CountryForShippingRadio" />
                    <label for="CountryForShippingRadioCustomer">
                        <dw:TranslateLabel runat="server" Text="Always use billing country" />
                    </label>
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="CountryForShippingRadioDelivery" name="CountryForShippingRadio" />
                    <label for="CountryForShippingRadioDelivery">
                        <dw:TranslateLabel runat="server" Text="Always use shipping country" />
                    </label>
                </div>


                <div class="radio">
                    <input type="radio" runat="server" id="CountryForShippingRadioBoth" name="CountryForShippingRadio" />
                    <label for="CountryForShippingRadioBoth">
                        <dw:TranslateLabel runat="server" Text="Use delivery country if shipping address is set" />
                    </label>
                </div>
            </td>
        </tr>

        <!-- Payment method selection -->
        <tr>
            <td style="vertical-align: top;">
                <dw:TranslateLabel runat="server" Text="Country for payment method" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" runat="server" id="CountryForPaymentRadioCustomer" name="CountryForPaymentRadio" />
                    <label for="CountryForPaymentRadioCustomer">
                        <dw:TranslateLabel runat="server" Text="Always use billing country" />
                    </label>
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="CountryForPaymentRadioDelivery" name="CountryForPaymentRadio" />
                    <label for="CountryForPaymentRadioDelivery">
                        <dw:TranslateLabel runat="server" Text="Always use shipping country" />
                    </label>
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="CountryForPaymentRadioBoth" name="CountryForPaymentRadio" />
                    <label for="CountryForPaymentRadioBoth">
                        <dw:TranslateLabel runat="server" Text="Use shipping country if shipping address is set" />
                    </label>
                </div>

            </td>
        </tr>

        <!-- Unavailable products -->
        <tr>
            <td style="vertical-align: top;">
                <dw:TranslateLabel runat="server" Text="Unavailable products" />
            </td>
            <td>
                <div class="radio">
                    <input type="radio" runat="server" id="RemoveNoneExistingProductsRadioTrue" name="RemoveNoneExistingProductsRadio" />
                    <label for="RemoveNoneExistingProductsRadioTrue">
                        <dw:TranslateLabel runat="server" Text="Remove" />
                    </label>
                </div>

                <div class="radio">
                    <input type="radio" runat="server" id="RemoveNoneExistingProductsRadioFalse" name="RemoveNoneExistingProductsRadio" />
                    <label for="RemoveNoneExistingProductsRadioFalse">
                        <dw:TranslateLabel runat="server" Text="Ignore" />
                    </label>
                </div>
            </td>
        </tr>

        <!-- Image pattern settings -->
        <tr id="imagepatternSettings" runat="server">
            <td>
                <dw:TranslateLabel runat="server" Text="Use image pattern settings from product catalog" />
            </td>
            <td>
                <dw:LinkManager runat="server" id="ImagePatternProductCatalog" EnablePageSelector="False" DisableFileArchive="True"></dw:LinkManager>
            </td>
        </tr>

    </table>
</dw:GroupBox>

<!-- Edit step dialog -->
<dw:Dialog runat="server" ID="EditStepDialog" Title="Edit step" TranslateTitle="true" ShowCancelButton="true" ShowOkButton="true" OkAction="saveStepEdit();">
    <input type="hidden" id="StepIndex" />
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Name" />
            </td>
            <td>
                <input type="text" id="StepName" class="NewUIinput" />
            </td>
        </tr>
        <tr id="StepEditTemplateRow">
            <td>
                <dw:TranslateLabel runat="server" Text="Template" />
            </td>
            <td style="white-space: nowrap;">
                <dw:FileManager runat="server" id="StepTemplate" Folder="Templates/eCom7/CartV2/Step" FullPath="true" />
            </td>
        </tr>
    </table>
</dw:Dialog>

<!-- Edit mail dialog -->
<dw:Dialog runat="server" ID="EditMailDialog" Title="Edit e-mail" TranslateTitle="true" ShowCancelButton="true" ShowOkButton="true" OkAction="saveMailEdit();">
    <input type="hidden" id="MailIndex" />
    <table class="formsTable">
        <tr>
            <td></td>
            <td>
                <input type="checkbox" id="MailIsCustomer" class="checkbox" onchange="onCustomerOrDeliveryChecked();" />
                <label for="MailIsCustomer">
                    <dw:TranslateLabel runat="server" Text="Send to billing email" />
                </label>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <input type="checkbox" id="MailIsDelivery" class="checkbox" onchange="onCustomerOrDeliveryChecked();" />
                <label for="MailIsDelivery">
                    <dw:TranslateLabel runat="server" Text="Send to shipping email" />
                </label>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <input type="checkbox" id="MailIsCustomField" class="checkbox" onchange="onCustomerOrDeliveryChecked();" />
                <label for="MailIsCustomField">
                    <dw:TranslateLabel runat="server" Text="Send to order field email" />
                </label>
            </td>
        </tr>
        <tr id="MailCustomFieldsRow">
            <td>
                <dw:TranslateLabel runat="server" Text="Order field for email" />
            </td>
            <td>
                <dw:GroupDropDownList runat="server" id="MailCustomFields" class="std"></dw:GroupDropDownList>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Recipient e-mail" />
            </td>
            <td>
                <input type="text" id="MailRecipient" class="NewUIinput" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Subject" />
            </td>
            <td>
                <input type="text" id="MailSubject" class="NewUIinput" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Template" />
            </td>
            <td style="white-space: nowrap;">
                <dw:FileManager runat="server" id="MailTemplate" Folder="Templates/eCom7/CartV2/Mail" FullPath="true" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Sender name" />
            </td>
            <td>
                <input type="text" id="MailSenderName" class="NewUIinput" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Sender e-mail" />
            </td>
            <td>
                <input type="text" id="MailSenderEmail" class="NewUIinput" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Encoding" />
            </td>
            <td>
                <select runat="server" id="MailEncoding" class="NewUIinput" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Attachment" />
            </td>
            <td>
                <dw:FileManager runat="server" id="MailAttachment" FullPath="false" AllowBrowse="true" />
            </td>
        </tr>
    </table>
</dw:Dialog>

<!-- Div containing the step values -->
<div id="HiddensSteps"></div>
<!-- Div containing the mail values -->
<div id="HiddensMails"></div>

<div id="RuleBox" style="display: none;">
    <dw:GroupBox runat="server" Title="Rules" DoTranslation="true">
        <span style="color: Gray;"></span>
    </dw:GroupBox>
</div>

<!-- Translated names -->
<div id="Translate_Unnamed" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Unnamed" />
</div>
<div id="Translate_Edit" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Edit" />
</div>
<div id="Translate_Delete" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Delete" />
</div>
<div id="Translate_Customer" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Customer" />
</div>
<div id="Translate_Delivery" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Delivery" />
</div>
<div id="Translate_RecipientCustomField" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Field:" />
</div>
<div id="Translate_No_recipient" style="display: none;">
    <dw:TranslateLabel runat="server" Text="No recipient" />
</div>
<div id="Translate_Please_select_a_validation_group" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Please select a validation group" />
</div>
<div id="Translate_The_selected_validation_group_is_already_added" style="display: none;">
    <dw:TranslateLabel runat="server" Text="The selected validation group is already added" />
</div>
<div id="Translate_Field" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Field" />
</div>
<div id="Translate_ErrorMessage" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Error message" />
</div>
<div id="Translate_Remove" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Remove" />
</div>
<div id="Translate_Check_all_fields" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Select all fields" />
</div>

<script type="text/javascript">
    var hiddenSettingNames = new Object;
    hiddenSettingNames.Steps = new Array();
    hiddenSettingNames.Mails = new Array();

    function addHidden(settingName, name, value, excludeInSettings, excludeInHiddens) {
        // Add to hiddens
        if (!excludeInHiddens) {
            var hiddenDiv = document.getElementById('Hiddens' + settingName);
            var hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.value = value;
            hidden.name = name;
            hiddenDiv.appendChild(hidden);
        }

        // Add to settings
        if (!excludeInSettings) {
            var settings = document.getElementById('eCom_CartV2_settings');
            settings.value = settings.value + (settings.value.toString().length > 0 ? ',' : '') + name;
            hiddenSettingNames[settingName].push(name);
        }
    }

    function clearHidden(settingName) {
        // Clear the hidden inputs
        if (document.getElementById('Hiddens' + settingName))
            document.getElementById('Hiddens' + settingName).innerHTML = '';

        // Remove previously inserted settings
        var settings = $('eCom_CartV2_settings');
        var settingsValues = settings.value.split(',');
        var newSettings = '';
        for (var j = 0; j < settingsValues.length; j++) {
            var found = false;
            for (var i = 0; i < hiddenSettingNames[settingName].length; i++) {
                if (hiddenSettingNames[settingName][i] == settingsValues[j]) {
                    found = true;
                    break;
                }
            }
            if (!found)
                newSettings += (newSettings.length > 0 ? ',' : '') + settingsValues[j];
        }
        settings.value = newSettings;
        hiddenSettingNames[settingName].length = 0;
    }

    function createIcon(iconString, onclick, titleName) {
        var icon = document.createElement('i');
        icon.className = iconString;
        icon.alt = '';
        icon.onclick = new Function(onclick);
        icon.title = document.getElementById('Translate_' + titleName).innerHTML;
        return icon;
    }

    function addNewNewsletterCategory() {
        window.open('/Admin/module/NewsLetterV3/CategorySelector.aspx?paragraph=true&SelectionRequired=False', 'catSelector', 'toolbar=0,menubar=0,resizable=0,scrollbars=0,height=400,width=300,directories=0,location=0');
    }

    function CartNewsletterSubcription() {
        var divId = "NewsletterCategories";
        var url = "/Admin/Module/eCom_Cart/GetNewsletterCategories.aspx?ajax=getCats&Time=" + (new Date()).getMilliseconds();

        $(divId).update('<img src=\'/Admin/Module/eCom_Catalog/images/ajaxloading.gif\' style=\'text-align:center;margin:5px;padding:5px;\' /> <span class=\'disableText\'><%=Dynamicweb.SystemTools.Translate.JsTranslate("Requesting content...")%></span>');

        new Ajax.Updater(divId, url, {
            asynchronous: true,
            evalScripts: false,
            method: 'get'

        });
    }


    // init
    steps = eval(document.getElementById('StepsJSON').value);
    mails = eval(document.getElementById('MailsJSON').value);
    updateSteps();
    updateMails();
    var validationGroupsToInsert = eval(document.getElementById('ValidationJSON').value);
    for (var i = 0; i < validationGroupsToInsert.length; i++)
        addValidationGroup(validationGroupsToInsert[i]);


    function SetFileOption(dropDownName, optionName) {
        var pathName = '/Files/' + optionName;

        var dropDown = document.getElementById('FM_' + dropDownName);
        dropDown.options.length++;
        var option = dropDown.options[dropDown.options.length - 1];
        option.value = optionName;
        option.text = optionName;
        option.setAttribute('fullPath', pathName);
        dropDown.selectedIndex = dropDown.options.length - 1;

        document.getElementById(dropDownName + '_path').value = pathName;
    }

    // Set stylesheet
    if ('<%=styleSheet %>' != '')
        SetFileOption('ParagraphModuleCSS', '<%=styleSheet %>');

    // Set javascript
    if ('<%=javascript %>' != '')
        SetFileOption('ParagraphModuleJS', '<%=javascript %>');

    Event.observe(window, "load", function () {
        Toggle_UserGroups();
        Toggle_Payments();
        Toggle_Deliveries();
        SelectionBox.setNoDataLeft("PaymentsSelector");
        SelectionBox.setNoDataRight("PaymentsSelector");
        SelectionBox.setNoDataLeft("DeliveriesSelector");
        SelectionBox.setNoDataRight("DeliveriesSelector");

        window["paragraphEvents"].setValidator(function () {
            if ($('DoCreateUserInCheckout').checked) {
                if ($('CreateNewUserGroupshidden').value.length == 0) {
                    alert('<%= Dynamicweb.SystemTools.Translate.JsTranslate("Created user should be assigned to any user group!") %>');
                    return false;
                }
            }
            return true;
        });
    });

    function serializePayments() {
        var fields = SelectionBox.getElementsRightAsArray("PaymentsSelector");
        //var fieldsJSON = JSON.stringify(fields);
        $("PaymetTypes").value = fields.join(); //  fieldsJSON;
    }

    function Toggle_Payments() {
        if ($('PaymentRadioAll').checked) {
            $('SelectAllPayments').value = true;
            $('PaymentsSelectorRow').hide();
        } else {
            $('SelectAllPayments').value = false;
            $('PaymentsSelectorRow').show();
        }
    }

    function serializeDeliveries() {
        var fields = SelectionBox.getElementsRightAsArray("DeliveriesSelector");
        $("DeliveryTypes").value = fields.join();
    }

    function Toggle_Deliveries() {
        if ($('DeliveryRadioAll').checked) {
            $('SelectAllDeliveries').value = true;
            $('DeliveriesSelectorRow').hide();
        } else {
            $('SelectAllDeliveries').value = false;
            $('DeliveriesSelectorRow').show();
        }
    }

    function Toggle_UserGroups() {
        if ($('DoCreateUserInCheckout').checked) {
            $('CreateNewUserGroupsRow').show();
            $('CreateNewUserEmailRow').show();
            $('ErrorMessagesDiv').show();
        } else {
            $('CreateNewUserGroupsRow').hide();
            $('CreateNewUserEmailRow').hide();
            $('ErrorMessagesDiv').hide();
        }
    }

</script>
