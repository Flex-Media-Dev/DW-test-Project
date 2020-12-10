<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomPayment_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomPayment_Edit" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Module/OMC/js/NumberSelector.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript" language="JavaScript" src="../images/functions.js"></script>
    <script type="text/javascript" language="JavaScript" src="../images/addrows.js"></script>
    <script src="/Admin/FileManager/FileManager_browse2.js" type="text/javascript"></script>

    <script type="text/javascript">
        strHelpTopic = 'ecom.controlpanel.payment.edit';
        function TabHelpTopic(tabName) {
            switch (tabName) {
                case 'GENERAL':
                    strHelpTopic = 'ecom.controlpanel.payment.edit.general';
                    break;
                case 'FEES':
                    strHelpTopic = 'ecom.controlpanel.payment.edit.fees';
                    break;
                case 'COUNTYFEES':
                    strHelpTopic = 'ecom.controlpanel.payment.edit.countryfees';
                    break
                default:
                    strHelpTopic = 'ecom.controlpanel.payment.edit';
            }
        }
    </script>

    <%=CheckoutAddin.Jscripts%>

    <script type="text/javascript">
        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
            onBeforeUpdateSelection = "onChangeCheckouthandler()";
            onChangeCheckouthandler();

            var userSelectorAllEl = $("user_mode_1");
            var userSelectorChooseEl = $("user_mode_2");
            var userSelectorCnt = $("users_container");

            var showUserSelector = !!($("AllowedGroups").value) || $("AllowAnonymousUsers").checked;
            if (showUserSelector) {
                userSelectorCnt.show();
                userSelectorChooseEl.checked = true;
            } else {
                userSelectorAllEl.checked = true;
            }

            userSelectorAllEl.on("change", function () {
                userSelectorCnt.hide();
            });
            userSelectorChooseEl.on("change", function () {
                userSelectorCnt.show();
            });
        });


        function savePayment(close) {
            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }

        function SwapAddInTypePanel(radio) {
            var isCheckout = radio.value == 'checkout'
            document.getElementById('CheckoutPanel').style.display = isCheckout ? 'block' : 'none';
        }

        function onChangeCheckouthandler() {
            if ('<%=isActions %>' == 'True' && $F("Dynamicweb.Ecommerce.Cart.CheckoutHandler_AddInTypes") == '<%=checkouthandlerType %>') {
		        $('panelActions').show();
		    }
		    else {
		        $('panelActions').hide();
		    }
		}

		function executeAction(action, callback) {
		    var payID = '<%=payId %>';
		    if (!payID || !action) return;

		    new Ajax.Request('EcomPayment_Edit.aspx', {
		        parameters: {
		            AJAX: "ExecuteAction",
		            action: action,
		            payID: payID
		        },
		        onCreate: function () {
		            $('loadingDiv').show();
		        },
		        onSuccess: function (transport) {
		            if (!!callback) {
		                callback(transport);
		            }
		        },
		        onFailure: function () { alert('Something went wrong...'); },
		        onComplete: function () { $('loadingDiv').hide(); }
		    });
		}

    </script>

    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
</head>
<body class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <dwc:GroupBox runat="server" DoTranslation="True" Title="Metode">
                <table class="formsTable">
                    <tr>
                        <td>
                            <label for="NameStr">
                                <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn"></dw:TranslateLabel>
                            </label>
                        </td>
                        <td>
                            <div id="errNameStr" name="errNameStr" style="color: Red;"></div>
                            <asp:TextBox ID="NameStr" CssClass="std" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="DescriptionStr">
                                <dw:TranslateLabel ID="tLabelDescription" runat="server" Text="Beskrivelse"></dw:TranslateLabel>
                            </label>
                        </td>
                        <td>
                            <div id="errDescriptionStr" name="errDescriptionStr" style="color: Red;"></div>
                            <asp:TextBox ID="DescriptionStr" CssClass="std" TextMode="MultiLine" Rows="5" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="IconStr">
                                <dw:TranslateLabel ID="tLabelIcon" runat="server" Text="Ikon"></dw:TranslateLabel>
                            </label>
                        </td>
                        <td>
                            <dw:FileArchive runat="server" CssClass="std" ID="IconStr" ShowPreview="true"></dw:FileArchive>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="IconOrder">
                                <dw:TranslateLabel ID="tLabelIconOrder" runat="server" Text="Ikon (orderliste)"></dw:TranslateLabel>
                            </label>
                        </td>
                        <td>
                            <dw:FileArchive runat="server" CssClass="std" ID="IconOrder" ShowPreview="true"></dw:FileArchive>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                            <dw:CheckBox ID="ActiveCheckBox" runat="server" Label="Active" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <ecom:CountryRelationSelector ID="CountryRelList" runat="server" />

            <dwc:GroupBox Title="Frontend group(s) and user(s)" runat="server"> 
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Payment available for" />
                        </td>
                        <td>
                            <dwc:RadioGroup runat="server" ID="user_mode" Name="user-mode" Indent="false">
                                <dwc:RadioButton runat="server" Label="All users" FieldValue="all" />
                                <dwc:RadioButton runat="server" Label="Selected groups" FieldValue="choose" />
                            </dwc:RadioGroup>
                            <div id="users_container" class="m-t-10" style="display: none">
                                <dw:UserSelector runat="server" ID="AllowedGroups" Show="Groups" Width="250" />
                                <dwc:CheckBox runat="server" ID="AllowAnonymousUsers" Label="Anonymous users" Indent="false" />
                            </div>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" DoTranslation="True" Title="Gebyrer">
                <dw:EditableList ID="Fees" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" Personalize="true"></dw:EditableList>
            </dwc:GroupBox>

            <asp:Panel runat="server" ID="AddInTypeRadioPanel">
                <dwc:GroupBox runat="server" Title="Cart type" DoTranslation="true">
                    <dwc:RadioGroup runat="server" Name="AddInTypeRadios" ID="AddInTypeRadios" Label="Type">
                        <dwc:RadioButton runat="server" FieldValue="none" Label="None" OnClick="SwapAddInTypePanel(this);" />
                        <dwc:RadioButton runat="server" FieldValue="checkout" Label="Checkout Handler (Shopping Cart v2)" OnClick="SwapAddInTypePanel(this);" />
                    </dwc:RadioGroup>
                </dwc:GroupBox>
            </asp:Panel>

            <asp:Panel runat="server" ID="CheckoutPanel">
                <de:AddInSelector
                    runat="server"
                    ID="CheckoutAddin"
                    AddInGroupName="Checkout Handler"
                    AddInTypeName="Dynamicweb.Ecommerce.Cart.CheckoutHandler"
                    AddInShowNoFoundMessage="false"
                    AddInShowNoFoundMsg="false" />
            </asp:Panel>

            <asp:Literal runat="server" ID="LoadParametersScript"></asp:Literal>
            <div id="panelActions" style="display: none">
                <fieldset style='width: 100%; margin: 5px;'>
                    <legend class="gbTitle"><%=Translate.Translate("Actions")%>&nbsp;</legend>
                    <div runat="server" id="panelActionButtons"></div>
                    <div id="loadingDiv" style="display: none;">
                        <img src='/Admin/Module/eCom_Catalog/images/ajaxloading_trans.gif' style='margin: 5px; padding: 5px;' />
                    </div>
                </fieldset>
            </div>

            <asp:Button ID="SaveButton" Style="display: none" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" runat="server"></asp:Button>
            <input id="Close" type="hidden" name="Close" value="0" />
        </form>
    </div>

    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        activateValidation('Form1');
    </script>
</body>
</html>
