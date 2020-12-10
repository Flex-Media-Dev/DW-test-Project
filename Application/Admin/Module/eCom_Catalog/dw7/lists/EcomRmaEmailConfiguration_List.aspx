<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomRmaEmailConfiguration_List.aspx.vb"
    Inherits="Dynamicweb.Admin.EcomRmaEmailConfiguration_List" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
    </dw:ControlResources>
    <script type="text/javascript" src="../js/ecomLists.js"></script>
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/images/layermenu.js"></script>
</head>
<body class="area-pink screen-container">
    <div class="card">
        <form id="form1" runat="server">
            <div class="card-header">
                <h2 class="subtitle">
                    <dw:TranslateLabel runat="server" Text="Email notifications" />
                </h2>
            </div>
            <dw:Toolbar runat="server" ID="Toolbar" ShowStart="true" ShowEnd="false">
            </dw:Toolbar>
            <!-- table to show emails in -->
            <dw:List runat="server" ID="StateEmailConfigurations" ShowTitle="false" ShowPaging="false">
                <Columns>
                    <dw:ListColumn runat="server" ID="stateColumn" Name="State email notifications" WidthPercent="45" />
                    <dw:ListColumn runat="server" ID="stateNotificationCountColumn" Name="Notifications" WidthPercent="45" />
                </Columns>
            </dw:List>
            <!-- table to show emails in -->
            <dw:List runat="server" ID="EventEmailConfigurations" ShowTitle="false" ShowPaging="false">
                <Columns>
                    <dw:ListColumn runat="server" ID="eventcolumn" Name="Event email notifications" WidthPercent="45" />
                    <dw:ListColumn runat="server" ID="eventNotificationCountColumn" Name="Notifications" WidthPercent="45" />
                </Columns>
            </dw:List>
            <!-- table to show emails in -->
            <dw:List runat="server" ID="replacementOrderProviderEmailConfigurations" ShowTitle="false"
                ShowPaging="false">
                <Columns>
                    <dw:ListColumn runat="server" ID="replacementOrderProviderColumn" Name="Replacement order provider email notifications" WidthPercent="45" />
                    <dw:ListColumn runat="server" ID="replacementOrderProviderNotificationCounColumn" Name="Notifications" WidthPercent="45" />
                </Columns>
            </dw:List>
        </form>
    </div>
</body>
</html>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
