<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomStockLocation_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.StockLocationEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
        <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
        <script type="text/javascript" src="/Admin/FormValidation.js"></script>	
        <script type="text/javascript">
            $(document).observe('dom:loaded', function () {
                window.focus(); // for ie8-ie9 
                document.getElementById('Name').focus();
            });

            function save(close) {
                document.getElementById("Close").value = close ? 1 : 0;
                document.getElementById('Form1').SaveButton.click();
            }

            var deleteMsg = '<%= DeleteMessage %>';
            function deleteStockLocation() {
                if (confirm(deleteMsg)) document.getElementById('Form1').DeleteButton.click();
            }
        </script>
</head>
<body class="area-pink screen-container" >
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <asp:Literal id="NoUnitExistsForLanguageBlock" runat="server"></asp:Literal>
            <dwc:GroupBox runat="server" Title="Stock location">
                <table class="formsTable">
                    <tr>
                        <td>
                            <label for="Name">
                                <dw:TranslateLabel id="tLabelName" runat="server" Text="Name"></dw:TranslateLabel>
                            </label>
                        <td>
                            <small class="help-block error" id="errName"></small>
                            <asp:textbox id="Name" CssClass="std" runat="server"></asp:textbox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="description">
                                <dw:TranslateLabel id="tLabelDescription" runat="server" Text="Description"></dw:TranslateLabel>
                            </label>
                        <td>
                            <asp:textbox id="description" CssClass="std" runat="server" TextMode="MultiLine" Rows="6"></asp:textbox>
                            <small class="help-block error" id="errDescription"></small>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <asp:Button id="SaveButton" style="display:none;" runat="server"></asp:Button>
            <asp:Button id="DeleteButton" style="display:none;" runat="server"></asp:Button>
        </form>
    </div>
    <script>
        addMinLengthRestriction('Name', 1, '<%=Translate.JsTranslate("A name needs to be specified")%>');
        activateValidation('Form1');
    </script>
</body>
</html>