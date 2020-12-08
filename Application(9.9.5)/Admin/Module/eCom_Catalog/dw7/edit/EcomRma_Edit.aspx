<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master" CodeBehind="EcomRma_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomRma_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadHolder" runat="server">
    <style type="text/css">
        .InfoBox
        {
            width: 300px;
            height: 150px;
        }
        
        .LabelWidth
        {
            width: 170px;
        }
        
        .InputBoxWidth
        {
            width: 200px !important;
        }
        
        .SerialNumberInputBoxWidth
        {
            width: 450px !important;
        }
        
        .InfoEditBox
        {
            vertical-align: top;
        }
        
        .CommentBox
        {
            width: 99%;
            height: 200px;
        }
        
        .ClassHidden
        {
            display: none;
        }
        
        .padding-left
        {
            padding-left: 5px;
        }
        
    </style>

    <script type="text/javascript">

        var _closeQuestion = "<%= _closeQuestion %>";
        var _deleteQuestion = "<%= _deleteQuestion %>";
        var _createOrderQuestion = "<%= _createOrderQuestion %>";

        function help(){
		    <%=Dynamicweb.SystemTools.Gui.Help("", "ecom.rma.edit", "en") %>
	    }

        function toggleUserInfoEdit(action) {
            if ($('userCustomerInfoViewDiv').style.display == 'none' && action == 'view') {
                $('emailLanguageSelectDiv').style.display = 'none';
                $('emailLanguageViewDiv').style.display = 'block';
                // Untoggle Edit
                $('userCustomerInfoViewDiv').style.display = 'block';
                $('userDeliveryInfoViewDiv').style.display = 'block';
                $('RmaTypeEdit').style.display = 'block';
                $('productDiv').style.display = 'block';
                $('commentDiv').style.display = 'block';
                $('historyDiv').style.display = 'block';
                $('divOriginalOrder').style.display = 'block';
                $('userCustomerInfoEditDiv').style.display = 'none';
                $('userDeliveryInfoEditDiv').style.display = 'none';

                // Do Ajax and fill View mode
                var idPart
                if ($("RmaID").value != "" && $("RmaID").value != "0") {
                    idPart = "RmaID=" + $("RmaID").value;
                } else {
                    idPart = "OrderID=" + $("OrderID").value;
                }

                // Fill Customer Info
                var customerInfoUrl = "EcomRma_Edit.aspx?Ajax=CreateCustomerInfo&timestamp=" + new Date().getTime() + "&" + idPart;
                var customerInputs = $$('div#userCustomerInfoEditDiv input');
                for (var i = 0; i < customerInputs.length; i++) {
                    customerInfoUrl += "&" + customerInputs[i].name + "=" + customerInputs[i].value;
                }
                ajaxDiv(customerInfoUrl, "divUserInfo");

                // Fill Delivery Info
                var deliveryInfoUrl = "EcomRma_Edit.aspx?Ajax=CreateDeliveryInfo&timestamp=" + new Date().getTime() + "&" + idPart;
                var deliveryInputs = $$('div#userDeliveryInfoEditDiv input');
                for (var i = 0; i < deliveryInputs.length; i++) {
                    deliveryInfoUrl += "&" + deliveryInputs[i].name + "=" + deliveryInputs[i].value;
                }
                ajaxDiv(deliveryInfoUrl, "divDeliveryInfo");

            } else if (action == 'edit') {
                // Toggle Edit
                 $('emailLanguageSelectDiv').style.display = 'block';
                $('emailLanguageViewDiv').style.display = 'none';
                

                $('userCustomerInfoViewDiv').style.display = 'none';
                $('userDeliveryInfoViewDiv').style.display = 'none';
                $('RmaTypeEdit').style.display = 'none';
                $('productDiv').style.display = 'none';
                $('commentDiv').style.display = 'none';
                $('historyDiv').style.display = 'none';
                $('divOriginalOrder').style.display = 'none';
                $('userCustomerInfoEditDiv').style.display = 'block';
                $('userDeliveryInfoEditDiv').style.display = 'block';
            }
        }
        function updateEmailLanguageLabel(select) {
            $('emailLanguageViewSpan').innerHTML=select.options[select.selectedIndex].innerHTML;
        }

        function ajaxDiv(url, div) {
            new Ajax.Updater($(div), url);
        }

        function showPerformActionDialog() {
            dialog.show('rmaActionDialog');
        }

        function performAction() {
            if (!confirm(_createOrderQuestion))
                return;

            var hidden = document.createElement("input");
            hidden.type = "hidden";
            hidden.name = "PerformAction";
            hidden.value = "True";
            document.Form1.appendChild(hidden);
            document.Form1.submit();
        }

        function showSerialNumberRows(className, count) {
            $$("tr." + className).each(function(tr) {
                tr.addClassName("ClassHidden");

            });

            if($(className).checked)
            {
                for (var i = 1; i - 1 < count; i++) {
                    $$("tr." + className + "_" + i)._each(function(tr) {
                        tr.removeClassName("ClassHidden");
                    });
                }
            }
        }
    </script>

    <%= ReplacementOrderProviderAddin.Jscripts%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentHolder" runat="server">
    <input type="hidden" name="RmaID" id="RmaID" value="<%= _rmaID%>" />
    <input type="hidden" name="OrderID" id="OrderID" value="<%= _orderID%>" />
    <input type="hidden" id="BackUrl" runat="server" />

    <div id="ribbonContainer" style="min-width: 930px;">
        <dw:RibbonBar ID="RibbonBar" runat="server">
            <dw:RibbonBarTab ID="RibbonBarTab1" Name="RMA" runat="server">
                <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                    <dw:RibbonBarButton ID="btnSave" Text="Save" Icon="Save" Size="Small" runat="server" ShowWait="true"
                        EnableServerClick="true" OnClick="Ribbon_Save">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="btnSaveAndClose" Text="Save and close" Icon="Save" Size="Small" runat="server" ShowWait="true"
                        EnableServerClick="true" OnClick="Ribbon_SaveAndClose">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="btnCancel" Text="Cancel" Icon="TimesCircle" Size="Small"
                        runat="server" EnableServerClick="true" OnClick="Ribbon_Cancel">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="rbgFinalize" Name="Finalize" runat="server">
                    <dw:RibbonBarButton ID="btnClose" Text="Close" Icon="Delete" Size="Small"
                        runat="server" EnableServerClick="true" OnClientClick=" if(!confirm(_closeQuestion)) {return false;} " OnClick="Ribbon_CloseRMA">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="btnDelete" Text="Delete" Icon="Delete" Size="Small"
                        runat="server" EnableServerClick="true" OnClientClick=" if(!confirm(_deleteQuestion)) {return false;} " OnClick="Ribbon_Delete">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroup5" Name="Show" runat="server">
                    <dw:RibbonBarRadioButton ID="btnRma" Text="RMA" Icon="Assignment" Size="Large"
                        runat="server" Group="ShowEdit" OnClientClick="toggleUserInfoEdit('view');" Checked="true" />
                    <dw:RibbonBarRadioButton ID="btnUserInfo" Text="User info" Icon="User" Size="Large"
                        runat="server" Group="ShowEdit" OnClientClick="toggleUserInfoEdit('edit');" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="rbgStates" Name="State" runat="server">
                    <dw:RibbonBarPanel runat="server">
                        <asp:DropDownList runat="server" ID="ddlStates" class="NewUIinput LabelWidth"></asp:DropDownList>
                    </dw:RibbonBarPanel>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="rbgReplacementOrder" Name="Replacement order" runat="server">
                    <dw:RibbonBarButton ID="btnPerformAction" Text="Create order" Icon="Exchange" Size="Large" runat="server" OnClientClick="showPerformActionDialog();">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonbarGroup6" runat="server" Name="Help">
                    <dw:RibbonBarButton ID="btnHelp" runat="server" Text="Help" Icon="Help" Size="Large"
                        OnClientClick="help();" />
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
        </dw:RibbonBar>
    </div>
    <dw:Infobar runat="server" ID="RmaInfoBar" Visible="false" />

    <!-- RMA ACTION DIALOG START -->
    <dw:Dialog runat="server" Size="Medium" ID="rmaActionDialog" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" 
        Title="Create replacement order" OkAction="performAction();" CancelAction="dialog.hide('rmaActionDialog');">
        <asp:Panel runat="server" ID="ReplacementOrderProviders">
            <de:AddInSelector 
				runat="server" 
				ID="ReplacementOrderProviderAddin" 
                AddInShowNothingSelected="true" 
				AddInGroupName="Select replacement order type"
                AddInParameterName="Replacement order settings" 
				AddInTypeName="Dynamicweb.Ecommerce.Orders.ReturnMerchandiseAuthorization.ReturnMerchandiseAuthorizationReplacementOrderProvider"
				/>
        </asp:Panel>

        <asp:Literal runat="server" ID="LoadParametersScript"></asp:Literal>   
    </dw:Dialog>
    <!-- RMA ACTION DIALOG END -->

    <dw:StretchedContainer ID="ProductEditScroll" Stretch="Fill" Scroll="VerticalOnly" Anchor="document" runat="server">
        
        <dw:GroupBox ID="ReplacementOrderBox" runat="server" Title="Replacement order" DoTranslation="true" Visible="false">
            <table>
                <tr>
                    <td class ="LabelWidth"><dw:TranslateLabel runat="server" Text="Replacement order id"/></td>
                    <td>
                        <asp:Label runat="server" ID="lblReplacementOrderId" />
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <dw:GroupBox ID="GroupBox1" runat="server" Title="Information" DoTranslation="true">
            <div id="divOriginalOrder">
                <table>
                    <tr>
                        <td>
                            <b><dw:TranslateLabel runat="server" Text="Original order id"/>: <asp:Label runat="server" ID="lblOriginalOrderId" /></b>
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>
            </div>
             <div id="div1">
                <table>
                    <tr>
                        <td>
                           <div id="emailLanguageViewDiv" style="display:block"><b><dw:TranslateLabel runat="server"   Text="RMA Email notification language"/>:</b> <span  id="emailLanguageViewSpan"><asp:Label  runat="server" ID="lblEmailNotificationLanguage" /></span></div> 
                           <div  id="emailLanguageSelectDiv" style="display:none"><b><dw:TranslateLabel   ID="TranslateLabel29" runat="server" Text="RMA Email notification language"/>:</b> <select class="NewUIinput"  runat="server" id = "EmailNotificationLanguageSelect" onchange="updateEmailLanguageLabel(this)"/></div>
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>
            </div>
            <table class="disabled">
                <tr>
                    <td>
                        <b><dw:TranslateLabel runat="server" Text="Customer information" /></b>
                    </td>
                    <td>
                        <b><dw:TranslateLabel runat="server" Text="Delivery information" /></b>
                    </td>
                </tr>
                <tr>
                    <td class="InfoEditBox">
                        <div id="userCustomerInfoViewDiv">
                            <div id="divUserInfo" class="InfoBox">
                                <asp:Literal runat="server" ID="CustomerInfo" />
                            </div>
                        </div>
                        <div id="userCustomerInfoEditDiv" style="display: none;">
                            <table>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Company" /></td>
                                    <td><input type="text" runat="server" name="CustomerCompany" id="CustomerCompany" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Name" /></td>
                                    <td><input type="text" runat="server" name="CustomerName" id="CustomerName" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Address" /></td>
                                    <td><input type="text" runat="server" name="CustomerAddress" id="CustomerAddress" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Address 2" /></td>
                                    <td><input type="text" runat="server" name="CustomerAddress2" id="CustomerAddress2" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Zip" /></td>
                                    <td><input type="text" runat="server" name="CustomerZip" id="CustomerZip" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="City" /></td>
                                    <td><input type="text" runat="server" name="CustomerCity" id="CustomerCity" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Country" /></td>
                                    <td><input type="text" runat="server" name="CustomerCountry" id="CustomerCountry" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel30" runat="server" Text="Country code" /></td>
                                    <td><input type="text" runat="server" name="CustomerCountryCode" id="CustomerCountryCode" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Region" /></td>
                                    <td><input type="text" runat="server" name="CustomerRegion" id="CustomerRegion" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Phone" /></td>
                                    <td><input type="text" runat="server" name="CustomerPhone" id="CustomerPhone" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel16" runat="server" Text="Fax" /></td>
                                    <td><input type="text" runat="server" name="CustomerFax" id="CustomerFax" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel11" runat="server" Text="Email" /></td>
                                    <td><input type="text" runat="server" name="CustomerEmail" id="CustomerEmail" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel12" runat="server" Text="Cell" /></td>
                                    <td><input type="text" runat="server" name="CustomerCell" id="CustomerCell" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Number" /></td>
                                    <td><input type="text" runat="server" name="CustomerNumber" id="CustomerNumber" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel13" runat="server" Text="Reference ID" /></td>
                                    <td><input type="text" runat="server" name="CustomerRefID" id="CustomerRefID" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel14" runat="server" Text="EAN" /></td>
                                    <td><input type="text" runat="server" name="CustomerEAN" id="CustomerEAN" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel15" runat="server" Text="VAT reg. number" /></td>
                                    <td><input type="text" runat="server" name="CustomerVatRegNumber" id="CustomerVatRegNumber" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td class="InfoEditBox">
                        <div id="userDeliveryInfoViewDiv">
                            <div id="divDeliveryInfo" class="InfoBox">
                                <asp:Literal runat="server" ID="DeliveryInfo" />
                            </div>
                        </div>
                        <div id="userDeliveryInfoEditDiv" style="display: none;">
                            <table>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel17" runat="server" Text="Company" /></td>
                                    <td><input type="text" runat="server" name="DeliveryCompany" id="DeliveryCompany" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel18" runat="server" Text="Name" /></td>
                                    <td><input type="text" runat="server" name="DeliveryName" id="DeliveryName" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel19" runat="server" Text="Address" /></td>
                                    <td><input type="text" runat="server" name="DeliveryAddress" id="DeliveryAddress" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel20" runat="server" Text="Address 2" /></td>
                                    <td><input type="text" runat="server" name="DeliveryAddress2" id="DeliveryAddress2" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel21" runat="server" Text="Zip" /></td>
                                    <td><input type="text" runat="server" name="DeliveryZip" id="DeliveryZip" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel22" runat="server" Text="City" /></td>
                                    <td><input type="text" runat="server" name="DeliveryCity" id="DeliveryCity" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel23" runat="server" Text="Country" /></td>
                                    <td><input type="text" runat="server" name="DeliveryCountry" id="DeliveryCountry" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel31" runat="server" Text="Country code" /></td>
                                    <td><input type="text" runat="server" name="DeliveryCountryCode" id="DeliveryCountryCode" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel24" runat="server" Text="Region" /></td>
                                    <td><input type="text" runat="server" name="DeliveryRegion" id="DeliveryRegion" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel25" runat="server" Text="Phone" /></td>
                                    <td><input type="text" runat="server" name="DeliveryPhone" id="DeliveryPhone" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel26" runat="server" Text="Fax" /></td>
                                    <td><input type="text" runat="server" name="DeliveryFax" id="DeliveryFax" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel27" runat="server" Text="Email" /></td>
                                    <td><input type="text" runat="server" name="DeliveryEmail" id="DeliveryEmail" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                                <tr>
                                    <td class="LabelWidth"><dw:TranslateLabel ID="TranslateLabel28" runat="server" Text="Cell" /></td>
                                    <td><input type="text" runat="server" name="DeliveryCell" id="DeliveryCell" class="NewUIinput InputBoxWidth" /></td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>

        <div id="RmaTypeEdit">
            <dw:GroupBox runat="server" ID="grpRmaType"  Title="Select type" DoTranslation="true">
                <table>
                    <tr>
                        <td class ="LabelWidth" style="vertical-align: top;"><dw:TranslateLabel runat="server" Text="Type"/></td>
                        <td>
                            <asp:Literal runat="server" ID="TypeSelector" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </div>
        
        <div id="productDiv">
            <dw:GroupBox runat="server" ID="grpProduct" Title="Select products" DoTranslation="true">
                <asp:Panel runat="server" ID="OrderLineSelectPanel">
                    <dw:List runat="server" ID="OrderlineList" AllowMultiSelect="false" ShowHeader="true" ShowPaging="false" ShowTitle="false" OnRowExpand="HandleListRow_Expanded" >
                    </dw:List>
                </asp:Panel>
            </dw:GroupBox>
        </div>

        <div id="commentDiv">
            <dw:GroupBox runat="server" ID="grpComment" Title="Comment" DoTranslation="true" ClassName="padding-left">
                <asp:TextBox runat="server" ID="Comment" TextMode="MultiLine" class="CommentBox"></asp:TextBox>
            </dw:GroupBox>
        </div>

        <div id="historyDiv">
            <dw:GroupBox runat="server" ID="grpHistory" Title="History" DoTranslation="true" ClassName="padding-left">
                <asp:Literal runat="server" ID="History"></asp:Literal>
            </dw:GroupBox>
        </div>

    </dw:StretchedContainer>
	<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</asp:Content>
