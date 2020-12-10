<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomOrder_PopupContent.aspx.vb"
    Inherits="Dynamicweb.Admin.eComBackend.EcomOrder_PopupContent" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
        <div height="100%" id="Body" runat="server" style="height: 100%; width: 100%; overflow: auto; overflow-x: hidden;">
        </div>
        <dw:TranslateLabel ID="NoTemplate" Text="could not load template." runat="server" />
    </form>
</body>
</html>
