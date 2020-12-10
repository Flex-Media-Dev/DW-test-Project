<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomOrderState_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrderState_List" %>

<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Systemtools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>    
</head>
<body class="screen-container">
    <div class="card">
        <form id="Form1" method="post" runat="server">
            <input type="hidden" name="selctedRowID" id="selctedRowID" />
            <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>

            <dw:List ID="List1" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="25">
                <Filters></Filters>
                <Columns>
                    <dw:ListColumn ID="colName" runat="server" Name="Navn" EnableSorting="true" />
                    <dw:ListColumn ID="colStandard" runat="server" Name="Standard" EnableSorting="true" Width="150" />
                    <dw:ListColumn ID="colDontUseInstatistics" runat="server" Name="Udelad fra statistik" EnableSorting="true" Width="150" />
                </Columns>
            </dw:List>

            <asp:Button ID="DeleteButton" Style="display: none;" runat="server" />
        </form>
    </div>

    <script>
        <% If Converter.ToBoolean(Request("ReferenceConflictOnDelete")) Then %> 
        alert('<%=Translate.Translate(String.Format("Cannot delete {0} flow since it is used in orders.", If(IsQuotes, "quote", If(IsCarts, "cart", "order")))) %>');
        <% End If%>       
    </script>
</body>
</html>
