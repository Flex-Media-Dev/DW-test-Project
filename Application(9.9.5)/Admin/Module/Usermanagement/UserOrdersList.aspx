<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UserOrdersList.aspx.vb" Inherits="Dynamicweb.Admin.UserManagement.UserOrdersList" %>
<%@ Register Src="~/Admin/Module/eCom_Catalog/dw7/UCOrderList.ascx" TagPrefix="ol" TagName="UCOrderList" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server" />
    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/OrderList.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ol:UCOrderList runat="server" ID="UCOrderList" />
    </div>
    </form>
</body>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
