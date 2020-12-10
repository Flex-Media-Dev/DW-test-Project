<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent2.Master" Language="vb" AutoEventWireup="false" CodeBehind="EcomAdvConfigLoyaltyPoints_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvConfigLoyaltyPoints_Edit" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () {
            document.getElementById('MainForm').submit();
        }

        page.onHelp = function () {
            <%=Dynamicweb.SystemTools.Gui.Help("", "administration.controlpanel.ecom.loyaltypoints") %>
        }
    </script>
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server" >
    <dwc:GroupBox runat="server" Title="Indstillinger">
        <dwc:InputNumber runat="server" Label="Expiration period (in months)" Name="/Globalsettings/Ecom/LoyaltyPoints/ExpirationPeriodInMonths" ID="ExpirationPeriodInMonths" Info="0 - Loyalty points do not expire" />
        <dwc:CheckBox runat="server" Label="Disallow reward points from products purchased with loyalty points" Name="/Globalsettings/Ecom/LoyaltyPoints/DisallowEarnPointsFromPoints" ID="DisallowEarnPointsFromPoints" Value="True" />
    </dwc:GroupBox>
</asp:Content>

