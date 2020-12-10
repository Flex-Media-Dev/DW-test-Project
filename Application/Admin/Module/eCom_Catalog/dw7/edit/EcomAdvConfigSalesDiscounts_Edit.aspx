<%@ Page Language="vb" MasterPageFile="/Admin/Content/Management/EntryContent2.Master" AutoEventWireup="false" CodeBehind="EcomAdvConfigSalesDiscounts_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvConfigSalesDiscounts_Edit" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">

    <script language="javascript" type="text/javascript">
        var page = SettingsPage.getInstance();
        
        page.onSave = function() {

            document.getElementById('MainForm').submit();
        }
        
        page.onHelp = function() {
            <%=Dynamicweb.SystemTools.Gui.Help("", "administration.controlpanel.ecom.discount") %>
        }

    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server" >
    <dwc:GroupBox runat="server" Title="Indstillinger">
        <dwc:CheckBox runat="server" Label="Differentiate on VAT Groups" Value="True" Name="/Globalsettings/Ecom/Order/VAT/DifferentiateDiscountOnVATGroup" ID="DifferentiateDiscountOnVATGroup" />
        <dwc:SelectPicker runat="server" Label="Valg af rabat" Name="/Globalsettings/Ecom/Discount/DiscountSelection" ID="DiscountSelection"></dwc:SelectPicker>
        <dwc:CheckBox runat="server" Label="Include product discounts" Value="True" Name="/Globalsettings/Ecom/Discount/IncludeProductDiscounts" ID="IncludeProductDiscounts" Info="When the option is not selected this setting does not effect the product discounts, as they are always accumulated." />
    </dwc:GroupBox>

    <% Translate.GetEditOnlineScript() %>

</asp:Content>
