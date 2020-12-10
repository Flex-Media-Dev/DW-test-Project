<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomManu_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.ManuEdit" %>

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
            document.getElementById('Name').focus();
        });

        function save(close) {
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
            <dwc:GroupBox runat="server" DoTranslation="True" Title="Indstillinger">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="Name" CssClass="std" runat="server" MaxLength="255"></asp:TextBox>
                            <small class="help-block" id="errName"></small>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelAddress" runat="server" Text="Adresse"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="Address" CssClass="std" runat="server" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelZipCode" runat="server" Text="Postnummer"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="ZipCode" CssClass="std" runat="server" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelCity" runat="server" Text="By"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="City" CssClass="std" runat="server" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelCountry" runat="server" Text="Land"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="Country" CssClass="std" runat="server" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelPhone" runat="server" Text="Telefon"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="Phone" CssClass="std" runat="server" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelFax" runat="server" Text="Fax"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="Fax" CssClass="std" runat="server" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelEmail" runat="server" Text="Email"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="Email" CssClass="std" runat="server" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelWeb" runat="server" Text="URL"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="Web" CssClass="std" runat="server" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelLogo" runat="server" Text="Logo"></dw:TranslateLabel>
                        </td>
                        <td>
                            <dw:FileArchive CssClass="std" runat="server" ID="Logo"></dw:FileArchive>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelDescription" runat="server" Text="Beskrivelse"></dw:TranslateLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="Description" CssClass="std" TextMode="MultiLine" Rows="5" runat="server" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
                                       

            <asp:Button ID="SaveButton" Style="display: none;" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none;" runat="server"></asp:Button>

        </form>
    </div>
    <script>
        addMinLengthRestriction('Name', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        activateValidation('Form1');
    </script>
</body>
</html>
