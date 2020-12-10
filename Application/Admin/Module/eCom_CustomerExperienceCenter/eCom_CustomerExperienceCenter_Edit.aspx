<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="eCom_CustomerExperienceCenter_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eCom_CustomerExperienceCenter_Edit" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
    <Items>
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/functions.js" />
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/AjaxAddInParameters.js" />
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ecomParagraph.js" />
    </Items>
</dw:ControlResources>

<dw:ModuleHeader ID="ModuleHeader1" runat="server" ModuleSystemName="eCom_CustomerExperienceCenter"></dw:ModuleHeader>
<dw:ModuleSettings ID="ModuleSettings1" runat="server" ModuleSystemName="eCom_CustomerExperienceCenter" Value="OrderType, RetrieveListBasedOn, PageSize, SortByField, SortOrder, OrderListTemplate, DetailTemplate, EmailTemplate" />

<dw:GroupBox runat="server" Title="Show" DoTranslation="true">
    <dwc:RadioGroup runat="server" ID="OrderType" Label="Order type">
        <dwc:RadioButton FieldValue="Order" Label="Orders" runat="server" />
        <dwc:RadioButton FieldValue="Cart" Label="Carts" runat="server" />
        <dwc:RadioButton FieldValue="Quote" Label="Quotes" runat="server" />
        <dwc:RadioButton FieldValue="LedgerEntry" Label="Ledgers" runat="server" />
        <dwc:RadioButton FieldValue="Recurringorder" Label="Recurring" runat="server" />                
    </dwc:RadioGroup>
    <dwc:RadioGroup runat="server" ID="RetrieveListBasedOn" Label="Retrieve list based on">
        <dwc:RadioButton FieldValue="UseUserID" Label="User id" runat="server" />
        <dwc:RadioButton FieldValue="UseCustomerNumber" Label="Customer number" runat="server" />
        <dwc:RadioButton FieldValue="UseImpersonationIds" Label="Own orders and orders made by users that current user can impersonate" runat="server" />     
    </dwc:RadioGroup>
    <table class="formsTable">
        <tr>
            <td colspan="2">

            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox runat="server" Title="List" DoTranslation="true">
    <table class="formsTable">
        <tr>
            <td colspan="2">
                <dwc:InputNumber runat="server" Label="Orders per page" ID="PageSize" Min="0" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel id="Translatelabel19" runat="server" text="Sort by field" />
            </td>
            <td>
                <select id="SortByField" name="SortByField" runat="server" class="std"></select>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" text="Sort direction" />
            </td>
            <td>
                <select id="SortOrder" name="SortOrder" runat="server" class="std"></select>
            </td>
        </tr>

    </table>
</dw:GroupBox>

<dw:GroupBox runat="server" Title="Templates">
    <dw:FileManager runat="server" ID="OrderListTemplate" Label="List" Folder="Templates/eCom/CustomerExperienceCenter/" FullPath="True"></dw:FileManager>
    <dw:FileManager runat="server" ID="DetailTemplate" Label="Detail" Folder="Templates/eCom/CustomerExperienceCenter/" FullPath="True"></dw:FileManager>
    <dw:FileManager runat="server" ID="EmailTemplate" Label="Email" Folder="Templates/eCom/CustomerExperienceCenter/" FullPath="True"></dw:FileManager>
</dw:GroupBox>