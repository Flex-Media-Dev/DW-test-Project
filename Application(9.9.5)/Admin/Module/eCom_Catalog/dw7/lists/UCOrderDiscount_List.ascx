<%@ Control Language="vb" AutoEventWireup="true" CodeBehind="UCOrderDiscount_List.ascx.vb" Inherits="Dynamicweb.Admin.eComBackend.UCOrderDiscount_List" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<dw:List runat="server" ID="DiscountList" EnableViewState="false">
    <Filters>
        <dw:ListAutomatedSearchFilter ID="sFilter" runat="server" />
    </Filters>
</dw:List>
