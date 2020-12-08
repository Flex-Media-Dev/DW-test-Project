<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditUserAddress.aspx.vb" Inherits="Dynamicweb.Admin.UserManagement.EditUserAddress" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Backend" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources runat="server" IncludePrototype="true" IncludeUIStylesheet="true">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Validation.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        function saveAndClose() {
            save(true);
        }

        function saveAndNotClose() {
            save(false);
        }

        function save(close, suppresItemValidation) {
            var frm = document.getElementById('EditUserAddressForm');
            if (!isValidAddress()) {
                return false;
            }
            document.getElementById("DoSave").value = "True";
            if (close) {
                document.getElementById("DoClose").value = "True";
            }
            frm.submit();
        }

        function isValidAddress() {
            if (!document.getElementById("txtTitle").disabled && document.getElementById("txtTitle").value == '') {
                alert('Please enter address title');
                document.getElementById("txtTitle").focus();
                return false;
            }
            var emailFiled = document.getElementById("txtEmail");
            if (emailFiled) {
                var emailRegEx = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i;
                if (!emailFiled.value == '' && emailFiled.value.search(emailRegEx) == -1) {
                    alert("Please enter a valid email address.");
                    return false;
                }
            }
            var addressField = document.getElementById("txtAddress");
            if (addressField && addressField.value == '') {
                alert('Please enter address');
                addressField.focus();
                return false;
            }
            return true;
        }
        
        function cancel() {
            document.location = '<%= GetUserEditUrl() %>';
        }
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <form id="EditUserAddressForm" runat="server">
            <dwc:CardHeader runat="server" Title="Edit address"></dwc:CardHeader>
            <dw:Toolbar runat="server" ShowEnd="false">
                <dw:ToolbarButton runat="server" Text="Gem" Icon="Save" OnClientClick="saveAndNotClose();" />
                <dw:ToolbarButton runat="server" Text="Gem og luk" Icon="Save" OnClientClick="saveAndClose();" />
                <dw:ToolbarButton runat="server" Text="Annuller" Icon="Cancel" OnClientClick="cancel();" />
            </dw:Toolbar>
            <asp:HiddenField ID="DoSave" runat="server" />
            <asp:HiddenField ID="DoClose" runat="server" />

            <dwc:GroupBox runat="server" Title="Address" DoTranslation="true">
                <dwc:CheckBox runat="server" ID="chkIsDefault" Label="Default" />
                <dwc:InputText runat="server" ID="txtTitle" Label="Description" />
                <dwc:InputText runat="server" ID="txtEmail" Label="E-mail" />
                <dwc:InputText runat="server" ID="txtAddress" Label="Address" />
                <dwc:InputText runat="server" ID="txtAddress2" Label="Address2" />
                <dwc:InputText runat="server" ID="txtZip" Label="Zip" />
                <dwc:InputText runat="server" ID="txtCity" Label="City" />
                <dwc:InputText runat="server" ID="txtState" Label="State or region" />
                <dwc:InputText runat="server" ID="txtCountry" Label="Country" />
                <dwc:SelectPicker runat="server" ID="ddlAddressCountries" Label="Billing/Shipping country"></dwc:SelectPicker>
                <dwc:InputText runat="server" ID="txtCompany" Label="Company" />
                <dwc:InputText runat="server" ID="txtPhone" Label="Phone number" />
                <dwc:InputText runat="server" ID="txtCell" Label="Mobile number" />
                <dwc:InputText runat="server" ID="txtPhoneBusiness" Label="Phone (business)" />
                <dwc:InputText runat="server" ID="txtFax" Label="Fax" />
                <dwc:InputText runat="server" ID="txtCustomerNumber" Label="Customer number" />
            </dwc:GroupBox>

            <dw:CustomFieldValueEdit ID="UserAddressCustomFields" runat="server" />
        </form>
    </dwc:Card>
</body>
</html>