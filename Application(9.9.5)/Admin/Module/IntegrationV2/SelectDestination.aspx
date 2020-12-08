<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SelectDestination.aspx.vb" Inherits="Dynamicweb.Admin.SelectDestination" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <script src="/Admin/FileManager/FileManager_browse2.js" type="text/javascript"></script>
    <script type="text/javascript" src="/Admin/Link.js"></script>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Module/IntegrationV2/js/SelectDestination.js" />
            <dw:GenericResource Url="/Admin/Images/Controls/UserSelector/UserSelector.js" />
        </Items>
    </dw:ControlResources>
    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/activity.css" type="text/css" />
</head>
<body onload="if (!(window.doMapping===undefined)) {parent.changeUrl('DoMapping.aspx'); document.getElementById('content').innerHTML='Please Wait';} else document.getElementById('Dynamicweb.DataIntegration.Integration.Interfaces.IDestination_AddInTypes').focus()">
    <div id="content">
        <dw:Overlay ID="forward" Message="Please wait" runat="server"></dw:Overlay>
        <form id="form1" runat="server">
            <div class="content-area">
                <dw:Infobar ID="errorBar" runat="server" Visible="false"></dw:Infobar>
                <input type="hidden" id="goBack" runat="server" />
                <asp:Literal ID="destinationSelectorScripts" runat="server"></asp:Literal>
                <de:AddInSelector ID="destinationSelector" runat="server" ShowOnlySelectedGroup="true" AddInGroupName="Destination" UseLabelAsName="True" AddInShowNothingSelected="false" AddInTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.IDestination" AddInIgnoreTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.INotDestination" AddInShowFieldset="true" onBeforeUpdateSelection='deactivateButtons();' onafterUpdateSelection='activateButtons()' />
                <asp:Literal ID="destinationSelectorLoadScript" runat="server"></asp:Literal>
            </div>
            <div class="cmd-pane fixed-pane text-right">
                <button class="btn btn-clean" id="forwardButton" onclick="$('goBack').value = 'true';"><%=Translate.JsTranslate("Previous")%></button>
                <button class="dialog-button-ok btn btn-clean" id="backButton" onclick="var o = new overlay('forward'); o.show();"><%=Translate.JsTranslate("Next")%></button>
                <button class="dialog-button-cancel btn btn-clean" type="button" onclick="parent.dialog.hide('NewJobWizardDialog');"><%=Translate.JsTranslate("Cancel")%></button>
            </div>
        </form>
    </div>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
