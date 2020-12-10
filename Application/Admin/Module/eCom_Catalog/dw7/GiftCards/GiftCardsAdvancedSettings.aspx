<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent2.Master" Language="vb" AutoEventWireup="false" CodeBehind="GiftCardsAdvancedSettings.aspx.vb" Inherits="Dynamicweb.Admin.GiftCardsAdvancedSettings" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server" >
    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () {
            var expirationInput = $('ExpirationPeriod');
            if (parseInt(expirationInput.value) <= 0) {
                expirationInput.value = '30';
            }
            document.getElementById('MainForm').submit();
        }
    </script>
    <dwc:GroupBox runat="server" Title="Indstillinger">
        <dwc:InputNumber runat="server" ClientIDMode="Static" Min="1" ID="ExpirationPeriod" Label="Expiration period (in months)" Name="/Globalsettings/Ecom/GiftCards/ExpirationPeriod" />
        <dwc:CheckBox runat="server" ID="IncludeVAT" Name="/Globalsettings/Ecom/GiftCards/IncludeVAT" Label="Calculate VAT for gift cards" />
	</dwc:GroupBox>
</asp:Content>