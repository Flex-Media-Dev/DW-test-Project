<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomOrderFlow_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrderFlowEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

 <!DOCTYPE html>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
    
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
    <script type="text/javascript">
        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
        }); 

        function saveOrderFlow(close) {
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
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID='tLabelName' runat='server' Text='Navn' />
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="NewUIinput" runat="server"></asp:TextBox>
                            <small class="help-block error" id="errNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelDescr" runat="server" Text="Beskrivelse" />
                        </td>
                        <td>
                            <asp:TextBox ID="DescrStr" CssClass="NewUIinput" runat="server"></asp:TextBox>
                            <small class="help-block error" id="errDescrStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox ID="IsDefault" runat="server" Label="Default" />
                            <dw:CheckBox ID="IsDefaultTmp" runat="server" Label="Default" AttributesParm="disabled" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <asp:Button ID="SaveButton" Style="display: none;" runat="server" />
            <asp:Button ID="DeleteButton" Style="display: none;" runat="server" />
        </form>
    </div>
    <asp:Literal ID="removeDelete" runat="server" />
    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        activateValidation('Form1');
        
        <% If Converter.ToBoolean(Request("ReferenceConflictOnDelete")) Then %>
        alert('<%=Translate.Translate(String.Format("Cannot delete {0} flow since it is used in orders.", If(IsQuotes, "quote", If(IsCarts, "cart", "order")))) %>');
        <% ElseIf Converter.ToBoolean(Request("CannotDelete")) Then %>
        alert('<%=Translate.Translate(String.Format("Cannot delete {0} flow", If(IsQuotes, "quote", "order")))%>');
        <% End If %>
    </script>
</body>
</html>
