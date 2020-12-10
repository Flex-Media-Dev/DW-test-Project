<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="EcomPeriod_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.PeriodEdit" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true"
        runat="server" />
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
    <script type="text/javascript">

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('PeriodName').focus();
        });

        function save(close) {
            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }

        function AlwaysCheckBoxClick() {
            var isChecked = $('Always').checked;
            var inputs = $$('td#Cell_THEENDDATE select');
            inputs.each(function (input) {
                input.disabled = isChecked;
            });
            $('THEENDDATE_calendar_btn').style.display = isChecked ? "none" : "";
        }

    </script>

</head>
<body onload="AlwaysCheckBoxClick()" class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <dwc:GroupBox runat="server" Title="Publication period" ID="GroupBoxStart1">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn"></dw:TranslateLabel>
                        </td>
                        <td>
                            <div id="errPeriodName" name="errPeriodName" style="color: Red;">
                            </div>
                            <asp:TextBox ID="PeriodName" CssClass="NewUIinput" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelStartDate" runat="server" Text="Gyldig fra"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:Literal ID="THESTARTDATE" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelEndDate" runat="server" Text="Gyldig til"></dw:TranslateLabel>
                        </td>
                        <td id="Cell_THEENDDATE">
                            <asp:Literal ID="THEENDDATE" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="Always" AttributesParm="onclick='javascript:AlwaysCheckBoxClick()'" runat="server" Label="Altid gyldig"></dw:CheckBox>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="Active" runat="server" Label="Active"></dw:CheckBox>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="ShowProductsAfterExpiration" runat="server" Label="Show products after product period expires" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <asp:Button ID="SaveButton" Style="display: none" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" runat="server"></asp:Button>                        
        </form>
    </div>
    <script>
        addMinLengthRestriction('PeriodName', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        activateValidation('Form1');
    </script>
</body>
</html>
