<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ListVisits.aspx.vb" Inherits="Dynamicweb.Admin.ListVisits" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" TagName="VisitsList" Src="~/Admin/Module/OMC/Controls/VisitsList.ascx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server" />
</head>
<body>
    <form id="frmListVisits" runat="server">
        <omc:VisitsList ID="lstVisits" runat="server" Title="Visits" ShowTitle="True" />
    </form>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
