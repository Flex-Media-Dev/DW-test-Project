<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NewJobFromTemplate.aspx.vb"
    Inherits="Dynamicweb.Admin.NewJobFromTemplate" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>
    <dw:ControlResources runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
    </dw:ControlResources>
    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/NewFromTemplate.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="templateName" name="templateName" />

        <div class="header">
            <h3>
                <%=Translate.JsTranslate("Choose template:")%>
            </h3>
        </div>
        <div class="mainArea">
            <dw:Infobar ID="errorBar" runat="server" Visible="false">
            </dw:Infobar>
            <dw:List runat="server" ID="templatesList" Title="Templates" Personalize="true" ShowHeader="False">
                <Columns>
                    <dw:ListColumn ID="ListColumn1" Name="Name" runat="server" />
                </Columns>
            </dw:List>
        </div>

        <dw:Dialog Title="Create" ID="NewFromTemplateDialog" Width="360" runat="server" ShowCancelButton="true" ShowOkButton="true" OkAction="$('form1').submit();">
            <dwc:GroupBox runat="server">
                <dw:TranslateLabel runat="server" Text="Enter name for new activity based on" /> "<label id="templateNameLabel">test</label>":
                <br />
                <br />
                <dwc:InputText ID="newName" runat="server" Label="Name" />
            </dwc:GroupBox>
        </dw:Dialog>
    </form>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
