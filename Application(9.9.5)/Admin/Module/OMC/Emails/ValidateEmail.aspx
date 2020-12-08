<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ValidateEmail.aspx.vb" Inherits="Dynamicweb.Admin.ValidateEmail" %>
<%@ Register TagPrefix="omc" TagName="ValidationList" Src="~/Admin/Module/OMC/Controls/ValidationList.ascx" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title></title>
<dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server" />
</head>
<body style="height: auto">
    <form id="frmRecipientsList" runat="server">
        <omc:ValidationList id="vValidationList" runat="server" />
    </form>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>

