<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomRmaState_List.aspx.vb"
    Inherits="Dynamicweb.Admin.EcomRmaState_List" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true"
        runat="server">
    </dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/images/layermenu.js"></script>
</head>
<body class="screen-container">
    <div class="card">
        <div class="card-header">
            <h2 class="subtitle"><dw:TranslateLabel runat="server" Text="RMA states" /></h2>
        </div>
        <form id="form1" runat="server">
            <dw:Toolbar runat="server" ID="Toolbar" ShowStart="true" ShowEnd="false"></dw:Toolbar>
            <dw:List ID="lstRmaStates" runat="server" Title="" ShowTitle="false" StretchContent="false"
                PageSize="25">
                <Filters>
                </Filters>
                <Columns>
                    <dw:ListColumn ID="colName" runat="server" Name="Name" EnableSorting="true" Width="300" />
                    <dw:ListColumn ID="colIsTranslated" runat="server" Name="Translated" EnableSorting="true"
                        Width="300" />
                    <dw:ListColumn ID="colIsDefault" runat="server" Name="Default" EnableSorting="true"
                        Width="300" />
                </Columns>
            </dw:List>
            <asp:Literal ID="BoxEnd" runat="server"></asp:Literal>
        </form>
    </div>
</body>
</html>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
