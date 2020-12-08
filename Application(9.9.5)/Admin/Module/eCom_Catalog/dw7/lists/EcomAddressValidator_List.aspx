<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomAddressValidator_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomAddressValidator_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
            <dw:List ID="List1" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                <Filters></Filters>
                <Columns>
                    <dw:ListColumn ID="colName" runat="server" Name="Navn" Width="300" EnableSorting="true" />
                    <dw:ListColumn ID="colActive" runat="server" Name="Active" EnableSorting="true" />
                </Columns>
            </dw:List>
            <asp:Literal ID="BoxEnd" runat="server"></asp:Literal>
        </form>
    </div>
</body>
</html>