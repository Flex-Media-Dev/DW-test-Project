<%@ Page Language="vb" AutoEventWireup="false" EnableEventValidation="false" CodeBehind="SetupWizard.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.SetupWizard" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="true" />
    <title></title>
    <link rel="stylesheet" type="text/css" href="SetupWizard.css" />
    <script src="/Admin/FileManager/FileManager_browse2.js" type="text/javascript"></script>
    <%=CheckoutAddin.Jscripts%>
	<!--should after AddInControl-->
	<!--script type="text/javascript" src="../images/AjaxAddInParameters.js"></script-->
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
    <script type="text/javascript">

        function hideAll() {
            $("step1Introduction").hide();
            $("step2Shop").hide();
            $("step3Language").hide();
            $("step4Currency").hide();
            $("step5Country").hide();
            $("step6Payment").hide();
            $("step7Shipment").hide();

            $('PAGEEXECUTE').hide();
            $('PAGEFINISH').hide();
            $('PAGEERROR').hide();
        }

        function save() {
            showStep('PAGEEXECUTE');
            document.setupWizardForm.style.cursor = "wait";

            var d = new Date();
            ajaxLoader("RequestAjax");
        }

        function help() {
            window.open("http://manual.net.dynamicweb.dk/Default.aspx?ID=1&m=keywordfinder&keyword=ecom.light.wizard&LanguageID=en", "dw_help_window", "location=no,directories=no,menubar=no,toolbar=yes,top=0,width=1024,height=" + (screen.availHeight - 100) + ",resizable=yes");
        }

        function cancel(neverShowAgain) {
            if (neverShowAgain) {
                $('CMD').value = 'HideECommerceGuide';
                $('setupWizardForm').request();
            }
            parent.setupWizardHide();
        }

        function closeWizard() {
            // Update parent window to see new shops
            var src = parent.document.location.href;
            if (src.endsWith('#'))
                src = src.substr(0, src.length - 1);
            parent.document.location.href = src;
        }

        function WizardFinish() {
            document.setupWizardForm.style.cursor = "default";
            showStep('PAGEFINISH');
        }

        function WizardError(errorMsg) {
            document.setupWizardForm.style.cursor = "default";

            showStep('PAGEERROR');
            alert(errorMsg);

            window.setTimeout("showStep('step1Introduction')", 10000);
        }

        function showStep(stepid) {
            hideAll();
            $(stepid).show();
            setPageStatus(stepid);
        }

        function setPageStatus(stepid) {
            var totalPages = <%= IIf(Dynamicweb.Security.Authorization.HasAccess("eCom_CartV2"), IIf(Dynamicweb.Security.Authorization.HasAccess("eCom_Payment"), 8, 7), 6) %>;

            var currentStep = 1;
            switch (stepid) {
                case "step1Introduction":
                    currentStep = 1; break;
                case "step2Shop":
                    currentStep = 2; break;
                case "step3Language":
                    currentStep = 3; break;
                case "step4Currency":
                    currentStep = 4; break;
                case "step5Country":
                    currentStep = 5; break;
                case "step6Payment":
                    currentStep = 6; break;
                case "step7Shipment":
                    currentStep = totalPages - 1; break;
                default:
                    currentStep = totalPages;
            }

            $('currentPage').update(currentStep);
            $('totalPages').update(totalPages);
        }

        function initPages() {
            if ($('__VIEWSTATE')) $('__VIEWSTATE').value = '';

            setPageStatus("step1Introduction");
        }

        function ValidateShop() {
            return doInputValidation($("shopName"));
        }

        function ValidateLang() {
            return doInputValidation($("languageName"));
        }

        function ValidateCurrency() {
            var result = doInputValidation($("currencyName"));
            result &= doInputValidation($("currencyRate"));
            result &= doInputValidation($("currencySymbol"));
            return result;
        }

        function ValidateCountry() {
            return doInputValidation($("countryName"));
        }

        function ajaxLoader(divId) {
                $('CMD').value = 'SetupECommerceGuide';
                $('setupWizardForm').request({
                onLoading: function (request) {
                    $(divId).update("<p style='text-align:center;'><img src='/Admin/Module/eCom_Catalog/images/ajaxloading_trans.gif' style='margin:5px;padding:5px;' /></p>");
                },

                onFailure: function (request) {
                },

                onComplete: function (request) {
                    var finished = false;
                    if (request.responseText == "true") {
                        finished = true;
                    }
                    $(divId).update("<br/><span style='text-align:center;margin:5px;padding:5px;'></span>");
                    if (finished)
                        WizardFinish();
                    else
                        WizardError(request.responseText);
                },

                onSuccess: function (request) {
                },

                onException: function (request) {
                }

            });
        }

    </script>
    <style>
        .cmd-pane {
            position: fixed;
            width: 100%;
            bottom: 0;
            background: white;
        }

        .wrapper {
            padding-bottom: 45px;
        }
    </style>

</head>

<body onload="initPages();">
    <form id="setupWizardForm" runat="server">
        <input type="hidden" id="CMD" runat="server" />
        
        <div id="step1Introduction">
            <div class="wrapper">
                <div class="row row-pad header">
                    <div class="col-1-4">
                        <h1><%= Translate.JsTranslate("Introduction")%></h1>
                    </div>
                    <div class="col-1-2">
                        <div class="pager-status text-center">
                            <%=Translate.JsTranslate("Page")%>
                            <span id="currentPage">1</span> <%=Translate.JsTranslate("of")%> <span id="totalPages">6</span>  
                        </div>
                    </div>
                    <div class="col-1-4">
                        <a class="pull-right icon" href="#" onclick="help();"><i title="<%=Translate.JsTranslate("Help")%>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i></a>
                    </div>                
                </div>
            
                <div class="row row-pad content">
                    <%= Translate.JsTranslate("Welcome to Dynamicweb eCommerce.")%><br />
	                <%= Translate.JsTranslate("This wizard would guide you through the process of initial eCommerce setting up.")%><br />

	                <%=Translate.JsTranslate("Items that is needed to setup the system:")%><br />
	                <ul>
	                    <li><%=Translate.JsTranslate("Shop")%></li>
	                    <li><%=Translate.JsTranslate("Language")%></li>
	                    <li><%=Translate.JsTranslate("Currency")%></li>
	                    <li><%=Translate.JsTranslate("Country")%></li>
	                </ul>
                    <asp:Literal ID="notFirstTimeAlert" runat="server"></asp:Literal>
                    <p><%= Translate.JsTranslate("After the guide is finished you'll be able to use your eCommerce.")%></p>
                </div>
            </div>

            <div class="cmd-pane footer">
                <div class="m-t-5 pull-left">
                    <dwc:CheckBox ID="neverShowAgain" FieldName="neverShowAgain" Label="Never show this again" Indent="false" runat="server" />                
                </div>
                <div class="pager">
                    <ul>
                        <li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Next")%>" onclick="showStep('step2Shop');" /></li>
                        <li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Cancel")%>" onclick="cancel(neverShowAgain.checked);" /></li>
                    </ul>
                </div>                
            </div>
        </div>

        <div id="step2Shop" style="display: none;">
            <div class="wrapper">
                <div class="row row-pad header">
                    <div class="col-1-4">
                        <h1><%= Translate.Translate("Shop")%></h1>
                    </div>
                    <div class="col-1-2">
                        <div class="pager-status text-center">
                            <%=Translate.JsTranslate("Page")%>
                            <span id="Span1">2</span> <%=Translate.JsTranslate("of")%> <span id="Span2">8</span>  
                        </div>
                    </div>
                    <div class="col-1-4">
                        <a class="pull-right icon" href="#" onclick="help();"><i title="<%=Translate.JsTranslate("Help")%>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i></a>
                    </div>  
                </div>
            
                <div class="row row-pad content">
                    <%= Translate.JsTranslate("A ""shop"" is located at the top level of your eCommerce structure where it acts a logical container for product groups and products. In this step you will need to define the shop for your solution.")%>
                    <br />
                    <br />
	                <table class="formsTable disableMedia">
                        <tr>
                            <td><label for="shopName"><%=Translate.JsTranslate("Enter the shop name")%></label></td>
                            <td>
                                <input type="text" class="std" id="shopName" runat="server" />
                                <small class="help-block error" id="errshopName"></small>
                            </td>
                        </tr>
	                </table>      
                    <input type="hidden" id="shopID" runat="server" />
                </div>
            </div>
            <div class="cmd-pane footer">                
                <div class="pager">
                    <ul>
                        <li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Previous")%>" onclick="showStep('step1Introduction');" /></li>
                        <li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Next")%>" onclick="if(ValidateShop()) showStep('step3Language');" /></li>
                        <li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Cancel")%>" onclick="cancel();" /></li>
                    </ul>
                </div>                
            </div>
        </div>
        
        <div id="step3Language" style="display: none;">
            <div class="wrapper">
                <div class="row row-pad header">
                    <div class="col-1-4">
                        <h1><%= Translate.Translate("Language")%></h1>
                    </div>
                    <div class="col-1-2">
                        <div class="pager-status text-center">
                            <%=Translate.JsTranslate("Page")%>
                            <span id="Span3">3</span> <%=Translate.JsTranslate("of")%> <span id="Span4">8</span>  
                        </div>
                    </div>
                    <div class="col-1-4">
                        <a class="pull-right icon" href="#" onclick="help();"><i title="<%=Translate.JsTranslate("Help")%>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i></a>
                    </div>  
                </div>
                <div class="row row-pad content">
                    <%= Translate.JsTranslate("A ""language"" allows you to control language specific settings for products, product groups and much more. In this step you will need to define the default language for your solution.")%>
                    <br />
                    <br />
                    <table class="formsTable disableMedia">
                        <tr>
                            <td><label for="languageName"><%=Translate.JsTranslate("Enter the language name")%></label></td>
                            <td>
                                <input type="text" class="std" id="languageName" runat="server" />
                                <small class="help-block error" id="errlanguageName"></small>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="languageCode2"><%=Translate.JsTranslate("Select country code")%></label></td>
                            <td>
                                <asp:DropDownList ID="languageCode2" runat="server" CssClass="std"></asp:DropDownList>
                            </td>
                        </tr>
	                </table>
                    <input type="hidden" id="languageID" runat="server" />
                </div>
            </div>
            <div class="cmd-pane footer">
                <div class="pager">
                	<ul>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Previous")%>" onclick="showStep('step2Shop');" /></li>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Next")%>" onclick="if(ValidateLang()) showStep('step4Currency');" /></li>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Cancel")%>" onclick="cancel();" /></li>
                	</ul>
                </div>
            </div>
        </div>
       
        <div id="step4Currency" style="display: none;">
            <div class="wrapper">
                <div class="row row-pad header">
                    <div class="col-1-4">
                        <h1><%= Translate.Translate("Currency")%></h1>
                    </div>
                    <div class="col-1-2">
                        <div class="pager-status text-center">
                            <%=Translate.JsTranslate("Page")%>
                            <span id="Span5">4</span> <%=Translate.JsTranslate("of")%> <span id="Span6">8</span>  
                        </div>
                    </div>
                    <div class="col-1-4">
                        <a class="pull-right icon" href="#" onclick="help();"><i title="<%=Translate.JsTranslate("Help")%>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i></a>
                    </div>  
                </div>
            
                <div class="row row-pad content">
                    <%= Translate.JsTranslate("A ""currency"" lets you manage various currency attributes, which relates to countries you do business with. In this step you will need to define the currency for your solution, which includes setting the currency rate as well as the correct currency code.")%>
                    <br />
                    <br />
                    <table class="formsTable disableMedia">
                        <tr>
                            <td><label for="currencyName"><%=Translate.JsTranslate("Enter currency name")%></label></td>
                            <td>
                                <input type="text" id="currencyName" class="std" runat="server" />
                                <small class="help-block error" id="errcurrencyName"></small>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="currencyRate"><%=Translate.JsTranslate("Enter currency rate")%></label></td>
                            <td>
                                <input type="text" id="currencyRate" class="std" runat="server" />
                                <small class="help-block error" id="errcurrencyRate"></small>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="currencySymbol"><%=Translate.JsTranslate("Enter currency symbol")%></label></td>
                            <td>
                                <input type="text" id="currencySymbol" class="std" runat="server" />
                                <small class="help-block error" id="errcurrencySymbol"></small>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="currencyCode"><%=Translate.JsTranslate("Select currency code")%></label></td>
                            <td>
                                <asp:DropDownList ID="currencyCode" CssClass="std" runat="server"></asp:DropDownList>
                            </td>
                        </tr>
	                </table>
                    <input type="hidden" id="currencySymbolPlace" runat="server" />
                </div>
            </div>
            <div class="cmd-pane footer">
                <div class="pager">
                	<ul>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Previous")%>" onclick="showStep('step3Language');" /></li>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Next")%>" onclick="if(ValidateCurrency()) showStep('step5Country');" /></li>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Cancel")%>" onclick="cancel();" /></li>
                	</ul>
                </div>
            </div>
        </div>
        
        <div id="step5Country" style="display: none;">
            <div class="wrapper">
                <div class="row row-pad header">
                    <div class="col-1-4">
                        <h1><%= Translate.Translate("Country")%></h1>
                    </div>
                    <div class="col-1-2">
                        <div class="pager-status text-center">
                            <%=Translate.JsTranslate("Page")%>
                            <span id="Span7">5</span> <%=Translate.JsTranslate("of")%> <span id="Span8">8</span>  
                        </div>
                    </div>
                    <div class="col-1-4">
                        <a class="pull-right icon" href="#" onclick="help();"><i title="<%=Translate.JsTranslate("Help")%>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i></a>
                    </div>  
                </div>
            
                <div class="row row-pad content">
                    <%= Translate.JsTranslate("A ""country"" lets you manage various attributes related to countries you do business with. In this step you will need to define the default country for your solution which includes setting the correct country code.")%>
                    <br />
                    <br />
                    <table class="formsTable disableMedia">
                        <tr>
                            <td><label for="countryName"><%=Translate.JsTranslate("Enter country name")%></label></td>
                            <td>
                                <input type="text" id="countryName" class="std" runat="server" />
                                <small class="help-block error" id="errcountryName"></small>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="countryCode"><%=Translate.JsTranslate("Select country code")%></label></td>
                            <td>
                                <asp:DropDownList ID="countryCode" CssClass="std" runat="server"></asp:DropDownList>
                            </td>
                        </tr>
	                </table>
                </div>
            </div>
            <div class="cmd-pane footer">
                <div class="pager">
                	<ul>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Previous")%>" onclick="showStep('step4Currency');" /></li>
                		<li>                    
                            <%  If Dynamicweb.Security.Authorization.HasAccess("eCom_CartV2") Then%>
                                    <input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Next")%>" onclick="if(ValidateCountry()) showStep('step6Payment');" />        
                            <%  Else%>                       
                                <input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Save")%>" onclick="if(ValidateCountry()) save();" />        
                            <%  End If%>
                		</li>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Cancel")%>" onclick="cancel();" /></li>
                	</ul>
                </div>
            </div>
        </div>
        
        <div id="step6Payment" style="display: none;">
            <div class="wrapper">
                <div class="row row-pad header">
                    <div class="col-1-4">
                        <h1><%= Translate.Translate("Payment")%></h1>
                    </div>
                    <div class="col-1-2">
                        <div class="pager-status text-center">
                            <%=Translate.JsTranslate("Page")%>
                            <span id="Span9">6</span> <%=Translate.JsTranslate("of")%> <span id="Span10">8</span>  
                        </div>
                    </div>
                    <div class="col-1-4">
                        <a class="pull-right icon" href="#" onclick="help();"><i title="<%=Translate.JsTranslate("Help")%>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i></a>
                    </div>  
                </div>

                <div class="row row-pad content">
                    <%= Translate.JsTranslate("This step allows to set up a method of payment for your Ecommerce. The wizard only support the basic functions of each gateway. For advanced setup use the Management Center.")%>
                    <br />
                    <dwc:GroupBox runat="server" Title="Method">
                        <dwc:InputText runat="server" Label="Name" ID="paymentName" ClientIDMode="Static" />
                        <dwc:InputText runat="server" Label="Description" ID="paymentDescription" ClientIDMode="Static" />
                        <dwc:InputNumber runat="server" ID="paymentFee" Placeholder="0.00" Label="Fee" ClientIDMode="Static" />
                        <dwc:RadioGroup runat="server" Label="Fee type" Name="paymentFeeType">
                            <dwc:RadioButton runat="server" ID="paymentFeeTypeVal" FieldValue="0" Label="$" />
                            <dwc:RadioButton runat="server" ID="paymentFeeTypeProc" FieldValue="1" Label="%" />
                        </dwc:RadioGroup>
                    </dwc:GroupBox>                    
				    <asp:Panel runat="server" ID="CheckoutPanel">
					    <de:AddInSelector  
						    runat="server" 
						    ID="CheckoutAddin" 
						    AddInGroupName="Checkout Handler" 
						    AddInTypeName="Dynamicweb.Ecommerce.Cart.CheckoutHandler"
						    />
				    </asp:Panel>              
	                <asp:Literal runat="server" ID="paymentLoadScript"></asp:Literal>   
                </div>
            </div>
            <div class="cmd-pane footer">
                <div class="pager">
                	<ul>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Previous")%>" onclick="showStep('step5Country');" /></li>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Next")%>" onclick="showStep('step7Shipment');" /></li>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Cancel")%>" onclick="cancel();" /></li>
                	</ul>
                </div>
            </div>
        </div>

        <div id="step7Shipment" style="display: none;">
            <div class="wrapper">
                <div class="row row-pad header">
                    <div class="col-1-4">
                        <h1><%= Translate.Translate("Delivery")%></h1>
                    </div>
                    <div class="col-1-2">
                        <div class="pager-status text-center">
                            <%=Translate.JsTranslate("Page")%>
                            <span id="Span11">7</span> <%=Translate.JsTranslate("of")%> <span id="Span12">8</span>  
                        </div>
                    </div>
                    <div class="col-1-4">
                        <a class="pull-right icon" href="#" onclick="help();"><i title="<%=Translate.JsTranslate("Help")%>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i></a>
                    </div>  
                </div>

                <div class="row row-pad content">
                    <%= Translate.JsTranslate("This step sets up a delivery option. Only flat fees are support. For full weight/volume matrix setup use the Management Center.")%>
                    <br /><br />
                    <dwc:GroupBox runat="server" Title="Method">
                        <dwc:InputText runat="server" Label="Name" ID="shipmentName" />
                        <dwc:InputText runat="server" Label="Description" ID="shipmentDescription" />
                        <dwc:InputNumber runat="server" ID="shipmentFee" Placeholder="0.00" Label="Default fee" ClientIDMode="Static" />
                        <dwc:InputNumber runat="server" ID="shipmentFreeFee" Placeholder="0.00" Label="No fee for purchases over" ClientIDMode="Static" />
                    </dwc:GroupBox>
				    <asp:Panel runat="server" ID="ServicePanel">
					    <de:AddInSelector  
						    runat="server" 
						    ID="ServiceAddin" 
						    AddInGroupName="Shipping Provider" 
						    AddInTypeName="Dynamicweb.Ecommerce.Cart.ShippingProvider"
						    />
				    </asp:Panel>

	                <asp:Literal runat="server" ID="shipmentLoadScript"></asp:Literal>                  
                
                </div>
            </div>
            <div class="cmd-pane footer">
                <div class="pager">
                	<ul>
                		<li>
                            <%  If Dynamicweb.Security.Authorization.HasAccess("eCom_CartV2") Then %>
                                <input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Previous")%>" onclick="showStep('step6Payment');" />
                            <%  Else%>
                                <input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Previous")%>" onclick="showStep('step5Country');" />
                            <%  End If %>
                		</li>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Save")%>" onclick="save();" /></li>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Cancel")%>" onclick="cancel();" /></li>
                	</ul>
                </div>
            </div>
        </div>

        <div id="PAGEEXECUTE" style="display: none;">
            <div class="wrapper">
                <div class="row row-pad header">
                    <div class="col-1-2">
                        <h1><%= Translate.JsTranslate("Guide is setting up eCommerce")%></h1>
                    </div>
                    <div class="col-1-2">
                        <a class="pull-right icon" href="#" onclick="help();"><i title="<%=Translate.JsTranslate("Help")%>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i></a>
                    </div>  
                </div>

		        <div class="row row-pad content">
                    <%= Translate.JsTranslate("The guide is now finisned and the eCommerce is now being setup.")%>	
                        
                    <div class="subContent" id="RequestAjax"></div>
    	        </div>  
            </div>
            <div class="cmd-pane footer">
            </div>
	    </div>  	      
	            
        <div id="PAGEFINISH" style="display: none;">
            <div class="wrapper">
                <div class="row row-pad header">
                    <div class="col-1-2">
                        <h1><%= Translate.JsTranslate("Guide is now finished")%></h1>
                    </div>
                    <div class="col-1-2">
                        <a class="pull-right icon" href="#" onclick="help();"><i title="<%=Translate.JsTranslate("Help")%>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i></a>
                    </div>  
                </div>

		        <div class="row row-pad content">
                    <%= Translate.JsTranslate("You can now use your eCommerce.")%><br />
                    <%= Translate.JsTranslate("This guide will not appear again. If you need to change your settings please use the Management Center to edit settings.")%><br /><br />
                    <%= Translate.JsTranslate("Advanced features such as variants and product categories must be set up in the Management Center.")%><br />
                    <%= Translate.JsTranslate("Remember to go the websites / frontpage module and select the language, country and currency you have set up for the appropriate website")%>
    	        </div>
            </div>
            <div class="cmd-pane footer">
                <div class="pager">
                	<ul>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Close")%>" onclick="closeWizard();" /></li>
                	</ul>
                </div>                
            </div>
	    </div>  		            
	            
        <div id="PAGEERROR" style="display: none;">
            <div class="wrapper">
                <div class="row row-pad header">
                    <div class="col-1-2">
                        <h1><%= Translate.JsTranslate("An error has accord in the eCommece Guide")%></h1>
                    </div>
                    <div class="col-1-2">
                        <a class="pull-right icon" href="#" onclick="help();"><i title="<%=Translate.JsTranslate("Help")%>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Help) %>"></i></a>
                    </div>  
                </div>

		        <div class="row row-pad content">
                    <%= Translate.JsTranslate("The guide will restart in 10 sec.")%>
    	        </div>
            </div>
            <div class="cmd-pane footer">
                <div class="pager">
                	<ul>
                		<li><input type="button" class="dialog-button-ok btn btn-clean" value="<%=Translate.JsTranslate("Close")%>" onclick="cancel();" /></li>
                	</ul>
                </div>
            </div>
	    </div>
    </form>

	<script type="text/javascript">
	    addMinLengthRestriction('shopName', 1, '<%=Translate.JsTranslate("A name is needed")%>');
	    addMinLengthRestriction('languageName', 1, '<%=Translate.JsTranslate("A name is needed")%>');
	    addMinLengthRestriction('currencyName', 1, '<%=Translate.JsTranslate("A name is needed")%>');
	    addValueNonNegativeOrZeroRestriction('currencyRate', '<%=Translate.JsTranslate("Exchange rate must be larger than 0.")%>');
	    addMinLengthRestriction('currencySymbol', 1, '<%=Translate.JsTranslate("Please enter a currency symbol")%>');
	    addMinLengthRestriction('countryName', 1, '<%=Translate.JsTranslate("A name is needed")%>');
    </script>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
