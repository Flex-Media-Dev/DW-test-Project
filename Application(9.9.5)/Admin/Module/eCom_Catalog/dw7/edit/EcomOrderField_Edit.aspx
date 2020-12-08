<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomOrderField_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrderFieldEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>

    <script type="text/javascript">

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
        }); 

        function checkfield(field){
            var result		= true;
            var fieldTmp	= field.toLowerCase();
            var validChars 	= "0123456789abcdefghijklmnopqrstuvwxyz";

            for (var i = 0; i < fieldTmp.length; i++) {
                if (validChars.indexOf(fieldTmp.charAt(i)) == -1) {
                    result = false;
                }
            }
        
            return result;
        }

        function saveOrderField(close) {
            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }
    </script>

</head>
<body class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <asp:Literal ID="TableIsBlocked" runat="server"></asp:Literal>
            <dwc:GroupBox runat="server" Title="Felt">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="std" runat="server"></asp:TextBox>
                            <small class="help-block error" id="errNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelSystemName" runat="server" Text="Systemnavn"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="SystemNameStr" CssClass="std" runat="server"></asp:TextBox>
                            <small class="help-block error" id="errSystemNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelTemplatName" runat="server" Text="Template tag"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="TemplateNameStr" CssClass="std" runat="server"></asp:TextBox>
                            <small class="help-block error" id="errTemplateNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelType" runat="server" Text="Felt type"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:DropDownList ID="TypeStr" CssClass="std" runat="server"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td></td>
                        <td>
                            <dw:CheckBox ID="Locked" runat="server" Label="Lås felt" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <asp:Button ID="SaveButton" Style="display: none;" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none;" runat="server"></asp:Button>
        </form>
    </div>
    <script>
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        addMinLengthRestriction('SystemNameStr', 1, '<%=Translate.JsTranslate("A system name is needed")%>');
        addMinLengthRestriction('TemplateNameStr', 1, '<%=Translate.JsTranslate("A templatetag-name is needed")%>');
        activateValidation('Form1');
    </script>
</body>
</html>