<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="editSource.aspx.vb" Inherits="Dynamicweb.Admin.editSource" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>

    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>

    <dw:ControlResources runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
    </dw:ControlResources>
    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/Base.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <dwc:GroupBox runat="server" ID="mainarea">
            <dw:Infobar ID="errorBar" runat="server" Visible="false">
            </dw:Infobar>
            <asp:Literal ID="sourceSelectorScripts" runat="server"></asp:Literal>
            <de:AddInSelector ID="SourceSelector" runat="server" ShowOnlySelectedGroup="true" AddInGroupName="Source" UseLabelAsName="True" AddInShowNothingSelected="false" AddInTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.ISource" AddInShowSelector="false" AddInShowFieldset="false" />
            <asp:Literal ID="sourceSelectorLoadScript" runat="server"></asp:Literal>
        </dwc:GroupBox>
        <div class="footer">
            <button class="dialog-button-ok btn btn-clean"><%=Translate.Translate("Save changes")%></button>
        </div>
    </form>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
