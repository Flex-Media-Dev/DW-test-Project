<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SelectSource.aspx.vb" Inherits="Dynamicweb.Admin.SelectSource" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>
    <dw:ControlResources runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Module/IntegrationV2/js/SelectSource.js" />
        </Items>
    </dw:ControlResources>
    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/activity.css" type="text/css" />
</head>
<body onload="document.getElementById('Dynamicweb.DataIntegration.Integration.Interfaces.ISource_AddInTypes').focus()">
    <form id="form1" runat="server">
        <div class="content-area">
            <dw:Infobar ID="errorBar" runat="server" Visible="false"></dw:Infobar>
            <asp:Literal ID="sourceSelectorScripts" runat="server"></asp:Literal>
            <de:AddInSelector ID="sourceSelector" runat="server" ShowOnlySelectedGroup="true" AddInGroupName="Source" UseLabelAsName="True" AddInShowNothingSelected="false" AddInTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.ISource" AddInShowFieldset="true" AddInIgnoreTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.INotSource" onBeforeUpdateSelection='deactivateButtons();' onafterUpdateSelection='activateButtons()' />
            <asp:Literal ID="sourceSelectorLoadScript" runat="server"></asp:Literal>
        </div>
        <div class="cmd-pane fixed-pane text-right">
            <button class="btn btn-clean" disabled="disabled"><%=Translate.JsTranslate("Previous")%></button>
            <button class="dialog-button-ok btn btn-clean" disabled="disabled" id="forwardButton"><%=Translate.JsTranslate("Next")%></button>
            <button class="dialog-button-cancel btn btn-clean" type="button" onclick="parent.dialog.hide('NewJobWizardDialog');"><%=Translate.JsTranslate("Cancel")%></button>
        </div>
    </form>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
