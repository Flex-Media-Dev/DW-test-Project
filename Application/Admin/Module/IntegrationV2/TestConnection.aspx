<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TestConnection.aspx.vb" Inherits="Dynamicweb.Admin.TestConnection" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>            
    <script type="text/javascript">        
        function onCancel() {
            document.location = '<%= UrlReferrer.Value%>';
        }

        function validate() {
            var result = true;
            var el = document.getElementById("txtUrl");
            var endpointsList = document.getElementById("EndpointList");
            if (!el.value) {
                if (endpointsList == null) {
                    dwGlobal.showControlErrors("txtUrl", '<%=Translate.JsTranslate("Url can not be empty")%>');
                    result = false;
                } else if (endpointsList.selectedIndex <= 0) {
                    dwGlobal.showControlErrors("EndpointList", '<%=Translate.JsTranslate("Select endpoint")%>');
                    result = false;
                }
            } 
            return result;
        }

        // Open trace route dialog 
        function tracertOpen() {            
            var host = host = document.getElementById("txtUrl").value;
            var endpointsList = document.getElementById("EndpointList");
            if (endpointsList != null && endpointsList.selectedIndex > 0) {
                host = spUrls.options[endpointsList.selectedIndex].text;
            }
            var timeout = document.getElementById("traceTimeout").value
            var hops = document.getElementById("traceHops").value
            var timeoutIsNum = /^\d+$/.test(timeout);
            var hopsIsNum = /^\d+$/.test(hops);

            // Hops and timeout only digits
            if (host !== "") {
                if (timeout === "" || hops === "" || timeoutIsNum === false || hopsIsNum === false) {
                    alert('<%=Translate.JsTranslate("Hops count and trace timeout should be only digits")%>')
                } else {
                    window.open("/Admin/Module/IntegrationV2/TraceRt.aspx?host=" + host + "&timeout=" + timeout + "&hops=" + hops, '<%=Translate.JsTranslate("Test route")%>', 'resizable=yes,scrollbars=yes,toolbar=no,location=no,directories=no,status=no,minimize=no,location=no,width=900,height=600,left=200,top=120')
                }
            } else {
                alert('<%=Translate.JsTranslate("Enter host name or IP Address")%>')
            }
        }
    </script>
</head>
<body>
    <dwc:Card runat="server">
        <form id="MainForm" action="TestConnection.aspx" runat="server">
            <asp:HiddenField ID="UrlReferrer" runat="server" />
            <asp:HiddenField ID="AddInType" runat="server" />

            <dwc:CardHeader runat="server" ID="lbSetup" Title="Test connection"></dwc:CardHeader>
            <dw:Toolbar ID="Buttons" runat="server" ShowEnd="false">
                <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" IconColor="Default" Icon="TimesCircle" Text="Cancel" OnClientClick="onCancel();" ShowWait="True">
                </dw:ToolbarButton>
            </dw:Toolbar>

            <dwc:CardBody runat="server">
                <dwc:GroupBox ID="GroupBox" runat="server" Title="Settings">
                    <dwc:InputText runat="server" ID="txtUrl" Label="Web service URL" ValidationMessage="" />
                    <dwc:InputText runat="server" ID="txtSecret" Label="Security key" Password="true" />
                    <dwc:SelectPicker runat="server" ID="EndpointList"  CssClass="selectpicker" Name="EndpointList" Label="Endpoint" Info="Only works with a web service exposed by a plug-in unit from Dynamicweb. This option takes precedence"  ValidationMessage="">
                        <asp:ListItem Text="None" Value="0"></asp:ListItem>
                    </dwc:SelectPicker>
                    <div style="display:none;">
                        <dwc:SelectPicker runat="server" ID="spUrls"  CssClass="selectpicker" Name="spUrls">
                            <asp:ListItem Text="None" Value="0"></asp:ListItem>
                        </dwc:SelectPicker>
                    </div>
                    <dwc:InputTextArea Name="XmlRequest" runat="server" ID="XmlRequest" Label="Request XML" />
                    <dwc:InputTextArea runat="server" ID="XmlResponse" Label="Response XML" />
                    <dwc:Button runat="server" DoTranslate="true" Title="Check connection" ActionType="submit" OnClick="return validate();" />                    
                    <dwc:InputText runat="server" ID="traceTimeout" Label="Trace hop time out (in ms)" MaxLength="4" Value="1000" />
                    <dwc:InputText runat="server" ID="traceHops" Label="Trace hops number" MaxLength="24" Value="20" />
                    <dwc:Button runat="server" DoTranslate="true" Title="Show trace information" OnClick="tracertOpen();" />
                </dwc:GroupBox>
            </dwc:CardBody>
        </form>
    </dwc:Card>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
