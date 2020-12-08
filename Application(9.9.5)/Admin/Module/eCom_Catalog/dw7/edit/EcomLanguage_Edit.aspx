<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomLanguage_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.LanguageEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var confirmMsg = '<%= Translate.JsTranslate("Changing the default language will force a localization of not translated products and groups. Do you want to continue?") %>';

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('Name').focus();

            <%If Not hasPermissionAll Then%>
            document.getElementById('linkToolbarButtonPermissions').classList.add('disabled');
            <%End if%>
        });

        function saveLanguage(close) {
            if ((!$('IsDefault') || $('IsDefault').checked == false) || confirm(confirmMsg)) {
                document.getElementById("imgProcessing").style.display = "";
                document.getElementById("Close").value = close ? 1 : 0;
                document.getElementById('Form1').SaveButton.click();
            }
        }

        function openPermissionsDialog() {
            <%= GetPermissionsShowAction() %>
        }
    </script>
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
</head>
<body class="screen-container">
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" name="Form1" method="post" runat="server">
            <asp:Literal ID="errCodeBlock" runat="server"></asp:Literal>
            <dwc:Groupbox runat="server" Title="Indstillinger">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="Name" CssClass="std" runat="server"></asp:TextBox>
                            <small class="help-block error" id="errName"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelLanguagesId" runat="server" Text="ID" />
                        </td>
                        <td>
                            <asp:TextBox ID="LangIdBox" Enabled="false" CssClass="std" ReadOnly="true" runat="server"></asp:TextBox>
                            <small class="help-block error" id="errId"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelCode2" runat="server" Text="Landekode %%"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:DropDownList ID="Code2" CssClass="std" runat="server"></asp:DropDownList>
                            <small class="help-block error" id="errCode2"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelNativeName" runat="server" Text="Egennavn"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="NativeName" CssClass="std" runat="server"></asp:TextBox>
                            <small class="help-block error" id="errNativeName"></small>
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
                <div id="imgProcessing" style="display: none">
                    <i class="fa fa-refresh fa-spin"></i>
                </div>
                <asp:Button ID="SaveButton" Style="display: none" runat="server"></asp:Button><asp:Button ID="DeleteButton" Style="display: none" runat="server"></asp:Button>
            <input id="Close" type="hidden" name="Close" value="0" />
            </dwc:Groupbox>
        </form>
        <asp:Literal ID="removeDelete" runat="server"></asp:Literal>
    </div>
    <script>
        addMinLengthRestriction('Name', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        addMinLengthRestriction('Code2', 1, '<%=Translate.JsTranslate("A country code needs to be selected")%>');
        addMinLengthRestriction('NativeName', 1, '<%=Translate.JsTranslate("A native name is needed")%>');
        activateValidation('Form1');
    </script>
</body>
</html>
