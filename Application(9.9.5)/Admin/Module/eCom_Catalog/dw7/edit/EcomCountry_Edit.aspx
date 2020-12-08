<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomCountry_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomCountryEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Ecommerce.International" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />


    <style type="text/css">
        .dwGrid .header th {
            height: 20px;
            font-weight: bold;
        }

        .dwGrid tr.row {
            height: 25px;
        }

            .dwGrid tr.row td {
                padding: 0px 2px;
            }
    </style>

    <script type="text/javascript">

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('Name').focus();

            dwGrid_regionsGrid.onRowAddedCompleted = function (row) {
                var nameBox = row.findControl("colCode");
                nameBox.focus();
            };
        });

        function SaveCountry(close) {
            var oldItem = "<%=countryId%>";
            var newItem = "";

            var countrySelect = document.getElementById('Form1').cID;
            if (countrySelect.selectedIndex > -1) {
                newItem = countrySelect.options[countrySelect.selectedIndex].value;
            }

            document.getElementById('hiddenClose').value = close ? '1' : '';

            var save = true;
            if (oldItem != "" && oldItem != newItem) {
                save = false;
            }

            if (save) {
                document.getElementById('Form1').SaveButton.click();
            } else {
                var msg = '<%=Translate.JsTranslate("Du har ændret den oprindelige Landekode (2)\nDette vil medføre ændringer i relationer til landet!\nVil du fortsætte ?")%>';
                if (confirm(msg)) {
                    document.getElementById('Form1').SaveButton.click();
                }
            }

        }

        var deleteMsg = '<%= DeleteMessage %>';
        function DeleteCountry() {
            if (confirm(deleteMsg)) document.getElementById('Form1').DeleteButton.click();
        }

        //  Delete row
        function delRow(link) {
            var row = dwGrid_regionsGrid.findContainingRow(link);
            if (row) {
                if (confirm('<%= Translate.JsTranslate("Do you want to delete this region?") %>')) {
                    dwGrid_regionsGrid.deleteRows([row]);
                }
            }
        }

        var standardAddressFormatValue = `<%= StandardAddressFormatText %>`;
        var customDisplayFormatValue = ""
        var customEditFormatValue = "";

        function changeFormatMode(modeValue, isDisplayFormat) {
            const textareaId = isDisplayFormat ? "AddressDisplayFormat" : "AddressEditFormat";
            const textareaElement = document.getElementById(textareaId);
            const isStandardMode = modeValue === "<%= AddressFormatMode.Standard %>";
            if (isStandardMode && !textareaElement.disabled) {
                textareaElement.disabled = true;
                if (isDisplayFormat) {
                    customDisplayFormatValue = textareaElement.value;
                } else {
                    customEditFormatValue = textareaElement.value;
                }
                textareaElement.value = standardAddressFormatValue;
            } else if (!isStandardMode && textareaElement.disabled) {
                textareaElement.disabled = false;
                textareaElement.value = isDisplayFormat ? customDisplayFormatValue : customEditFormatValue;
                if (!textareaElement.value) {
                    textareaElement.value = standardAddressFormatValue;
                }
            }            
        }

        function countryCodeChanged() {
            let countryCode = "";
            const countrySelect = document.getElementById('cID');
            if (countrySelect.selectedIndex > -1) {
                countryCode = countrySelect.options[countrySelect.selectedIndex].value;
            }

            fetch(`EcomCountry_Edit.aspx?CountryCode=${countryCode}&cmd=changeDefaultFormat&IsAjax=true`).then(resp => {
                if (resp.ok) {
                    resp.text().then(addressFormatText => updateDefaultAddressFormat(addressFormatText));                    
                }
            });  
        }

        function updateDefaultAddressFormat(addressFormatText) {
            standardAddressFormatValue = addressFormatText;
            const addressFormatElements = [
                ['AddressDisplayMode', 'AddressDisplayFormat'],
                ['AddressEditMode', 'AddressEditFormat']
            ];

            addressFormatElements.forEach(formatData => {
                const radioGroupName = formatData[0];
                const textareaId = formatData[1];
                const modeValue = document.querySelector(`input[name="${radioGroupName}"]:checked`).value;
                if (modeValue === "<%= AddressFormatMode.Standard %>") {
                    const textarea = document.getElementById(textareaId);
                    textarea.value = standardAddressFormatValue;
                }
            });
        }

    </script>
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
</head>
<body class="area-pink screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>

        <form id="Form1" method="post" runat="server">
            <input type="hidden" id="hiddenClose" name="Close" value="" />
            <asp:Literal ID="errCodeBlock" runat="server"></asp:Literal>
            <asp:Literal ID="NoCountryExistsForLanguageBlock" runat="server"></asp:Literal>

            <dwc:GroupBox runat="server" Title="Indstillinger">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn" />
                        </td>
                        <td>
                            <asp:TextBox ID="Name" CssClass="std" runat="server"></asp:TextBox>
                            <small class="help-block error" id="errName"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelcID" runat="server" Text="Landekode %%" />
                        </td>
                        <td>
                            <asp:DropDownList ID="cID" CssClass="std" runat="server" onchange="countryCodeChanged()"></asp:DropDownList>
                            <small class="help-block error" id="errcID"></small>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelCode3" runat="server" Text="Landekode %%" />
                        </td>
                        <td>
                            <asp:DropDownList ID="Code3" CssClass="std" runat="server"></asp:DropDownList>
                            <small class="help-block error" id="errCode3"></small>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelCurrencyCode" runat="server" Text="Valutakode" />
                        </td>
                        <td>
                            <asp:DropDownList ID="CurrencyCode" CssClass="std" runat="server"></asp:DropDownList>
                            <small class="help-block error" id="errCurrencyCode"></small>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelNumber" runat="server" Text="Betalingskode" />
                        </td>
                        <td>
                            <asp:DropDownList ID="Number" CssClass="std" runat="server"></asp:DropDownList>
                            <small class="help-block error" id="errNumber"></small>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelCultureInfo" runat="server" Text="Landestandard ID" />
                        </td>
                        <td>
                            <asp:TextBox ID="CultureInfo" CssClass="std" runat="server"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelVat" runat="server" Text="Moms" /> (%)
                        </td>
                        <td>
                            <dwc:InputNumber ID="Vat" runat="server" IncrementSize="0.01" />
                            <small class="help-block error" id="errVat"></small>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <asp:Button ID="SaveButton" Style="display: none;" runat="server" />
            <asp:Button ID="DeleteButton" Style="display: none;" runat="server" />
            <dwc:GroupBox runat="server" Title="Frontend address format">
                <dwc:RadioGroup runat="server" ID="AddressDisplayMode" Name="AddressDisplayMode" Label="Address display mode" SelectedValue="1" >
                    <dwc:RadioButton ID="DisplayModeStandard" Label="Standard" FieldValue="1" DoTranslation="true" runat="server" OnClick="changeFormatMode(this.value, true)" />
                    <dwc:RadioButton ID="DisplayModeCustom" Label="Custom" FieldValue="2" DoTranslation="true" runat="server" OnClick="changeFormatMode(this.value, true)" />
                </dwc:RadioGroup>
                <dwc:InputTextArea ID="AddressDisplayFormat" runat="server" Label="Address display format" Rows="7" />
                <dwc:RadioGroup runat="server" ID="AddressEditMode" Name="AddressEditMode" SelectedValue="1" Label="Address edit mode" >
                    <dwc:RadioButton ID="EditModeStandard" Label="Standard" FieldValue="1" DoTranslation="true" runat="server" OnClick="changeFormatMode(this.value, false)" />
                    <dwc:RadioButton ID="EditModeCustom" Label="Custom" FieldValue="2" DoTranslation="true" runat="server" OnClick="changeFormatMode(this.value, false)" />
                </dwc:RadioGroup>
                <dwc:InputTextArea ID="AddressEditFormat" runat="server" Label="Address edit format" Rows="7" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Default methods">
                <asp:Literal ID="countryRelDefaultList" runat="server" />
            </dwc:GroupBox>
            <%--Select default payment and shipping methods--%>
            <dwc:GroupBox runat="server" Title="Regions \ States">
                <dw:EditableGrid runat="server" ID="regionsGrid" ClientIDMode="AutoID" AllowAddingRows="True">
                    <Columns>
                        <asp:TemplateField HeaderStyle-Width="100" HeaderStyle-CssClass="OutlookHeaderStart">
                            <ItemTemplate>
                                <input type="hidden" id="colOldCode" />
                                <asp:TextBox runat="server" ID="colCode" Text="" CssClass="std" Width="100" MaxLength="3" Style="margin-left: 5px;" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderStyle-Width="90%" HeaderStyle-CssClass="OutlookHeader">
                            <ItemTemplate>
                                <asp:TextBox runat="server" ID="colName" Text="" CssClass="std" Width="200" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="20px" HeaderStyle-CssClass="OutlookHeader">
                            <ItemTemplate>
                                <span class="option-field-offset">
                                    <img id="imgError" runat='server' src="/Admin/Images/Ribbon/Icons/Small/Error.png" style="display: none" alt="" title="" border="0" />
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="20px" HeaderStyle-CssClass="OutlookHeader">
                            <ItemTemplate>
                                <span class="option-field-offset">
                                    <a href="javascript:void(0);" onclick="javascript:delRow(this);">
                                        <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>" title="<%= Translate.Translate("Delete")%>"></i>
                                    </a>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </dw:EditableGrid>
            </dwc:GroupBox>
        </form>
    </div>
    <script>
        addMinLengthRestriction('Name', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        addMinLengthRestriction('cID', 1, '<%=Translate.JsTranslate("A country code (2) has to be selected")%>');
        addMinLengthRestriction('Code3', 1, '<%=Translate.JsTranslate("A country code (3) has to be selected")%>');
        addMinLengthRestriction('CurrencyCode', 1, '<%=Translate.JsTranslate("A currency code has to be selected")%>');
        addMinLengthRestriction('Number', 1, '<%=Translate.JsTranslate("A payment gateway country code has to be selected")%>');
        addPercentRestriction('Vat', 0, 100, '<%=Translate.JsTranslate("Needs to be a valid percentage value between %lower% and %higher%", "%lower%", "0", "%higher%", "100")%>');
        activateValidation('Form1');
    </script>
</body>
</html>