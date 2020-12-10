<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SelectTableMappings.aspx.vb" Inherits="Dynamicweb.Admin.SelectTableMappings" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <dw:ControlResources ID="ctrlResources" runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Module/IntegrationV2/js/SelectTableMappings.js" />
        </Items>
    </dw:ControlResources>
    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/activity.css" type="text/css" />
    <title></title>
</head>
<body onload="if (!(window.doMapping===undefined)) {parent.changeUrl('DoMapping.aspx'); var o = new overlay('waitForNewJob'); o.show();}" style="border-right-width: 0px; height: auto;">
    <form id="form1" runat="server">
        <dw:Overlay ID="waitForNewJob" Message="Please wait" runat="server"></dw:Overlay>
        <div id="content">
            <div class="content-area">
                <dwc:GroupBox runat="server" Title="Select source tables">
                    <dw:Infobar runat="server" ID="errorInfoBar" Visible="false"></dw:Infobar>
                    <table class="mappings">
                        <thead>
                            <tr>
                                <th>
                                    <input type="checkbox" id="checkAll" onclick="toggleAll()" class="checkbox" />
                                    <label for="checkAll"><%=Translate.JsTranslate("Source")%></label>
                                </th>
                                <th>
                                    <%=Translate.JsTranslate("Destination")%>
                                </th>
                            </tr>
                        </thead>
                        <tbody id="tableMappings" runat="server"></tbody>
                    </table>
                </dwc:GroupBox>
            </div>
            <div class="cmd-pane fixed-pane text-right">
                <input type="hidden" id="goBack" runat="server" />
                <button class="btn btn-clean" onclick="$('goBack').value = 'true';"><%=Translate.JsTranslate("Previous")%></button>
                <button class="dialog-button-ok btn btn-clean" onclick="dialog.show('newJob'); document.getElementById('newJobName').focus(); return false;"><%=Translate.JsTranslate("Finish")%></button>
                <button class="dialog-button-cancel btn btn-clean" type="button" onclick="parent.dialog.hide('NewJobWizardDialog');"><%=Translate.JsTranslate("Cancel")%></button>
            </div>
        </div>

        <dw:Dialog Title="New activity" ID="newJob" Size="Small" runat="server" ShowCancelButton="true" ShowOkButton="true" OkAction="$('form1').submit();">
            <dwc:GroupBox runat="server" Title="Activity">
                <dwc:InputText runat="server" ID="newJobName" ClientIDMode="Static" Name="newJobName" Label="Name" />
                <dwc:InputTextArea runat="server" ID="newJobDesc" ClientIDMode="Static" Name="newJobDesc" Label="Description" />
                <dwc:CheckBox runat="server" ID="newJobAutomatedMapping" ClientIDMode="Static" Name="newJobAutomatedMapping" Label="Perform mapping automatically on run" />
            </dwc:GroupBox>
        </dw:Dialog>

    </form>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
