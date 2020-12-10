<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Content/Management/EntryContent2.Master" CodeBehind="EcomAdvConfigOrderDiscounts_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvConfigOrderDiscounts_Edit" %>

<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script language="javascript" type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function () {    
            close = document.getElementById('hiddenSource').value != "ManagementCenterSave";
            if(document.getElementsByName('/Globalsettings/Ecom/Order/Discounts/OrderDiscountsUseOnly')[0].checked != <%=Converter.ToBoolean(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Order/Discounts/OrderDiscountsUseOnly")).ToString.ToLower()%>)
            {            
                document.getElementById('MainForm').action += "OpenTo=" + "OpenTo=" + (close ? "ManagementCenter" : "Ecom7Settins_ORDERDISCOUNTS");
        }
        
        document.getElementById('MainForm').submit();
        }

        page.onHelp = function () {
            <%=Dynamicweb.SystemTools.Gui.Help("", "administration.controlpanel.ecom.discount") %>
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:GroupBox runat="server" Title="Indstillinger">
        <dwc:SelectPicker runat="server" Label="Valg af rabat" Name="/Globalsettings/Ecom/Order/Discounts/Selection" ID="Selection"></dwc:SelectPicker>
        <dwc:CheckBox runat="server" Value="True" Label="Only use order discounts" Name="/Globalsettings/Ecom/Order/Discounts/OrderDiscountsUseOnly" ID="OrderDiscountsUseOnly" />
        <dwc:CheckBox runat="server" Value="True" Label="Apply discount before taxes" Name="/Globalsettings/Ecom/Order/Discounts/ApplyDiscountBeforeTaxes" ID="ApplyDiscountBeforeTaxes" />
        <dwc:CheckBox runat="server" ID="RoundDiscountPerQuantity" Name="/Globalsettings/Ecom/Price/RoundDiscountPerQuantity" Label="Round orderline discounts per quantity" Info="5 * 20% of 8.99 becomes 1,8*5 = 9 instead of 1,798*5 = 8,99" />
        <dwc:CheckBox runat="server" ID="AddOrderlineDiscountsPerQuantity" Name="/Globalsettings/Ecom/Price/AddOrderlineDiscountsPerQuantity" Label="Add orderline discounts per quantity" Info="If 5 of 8,99 with 20% discount is ordered, 5 discounts of 1.8 instead of 1 discount of 9 is added" />

    </dwc:GroupBox>

    <% Translate.GetEditOnlineScript() %>
</asp:Content>
