<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TestEndpoint.aspx.vb" Inherits="Dynamicweb.Admin.TestEndpoint" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
    </script>
</head>
<body>
    <dwc:Card runat="server">
        <form id="MainForm" action="TestEndpoint.aspx" runat="server">
            <asp:HiddenField ID="UrlReferrer" runat="server" />
            <asp:HiddenField ID="EndpointId" runat="server" />

            <dwc:CardHeader runat="server" ID="lbSetup" Title="Test endpoint"></dwc:CardHeader>
            <dw:Toolbar ID="Buttons" runat="server" ShowEnd="false">
                <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" IconColor="Default" Icon="TimesCircle" Text="Cancel" OnClientClick="onCancel();" ShowWait="True">
                </dw:ToolbarButton>
            </dw:Toolbar>

            <dwc:CardBody runat="server">
                <dwc:GroupBox ID="GroupBox" runat="server" Title="Settings">
                    <dwc:InputText ID="txtName" runat="server" Label="Name" Disabled="true" />
                    <dwc:InputTextArea ID="txtDescription" Label="Description" runat="server" Disabled="true" />
                    <dwc:InputText ID="txtUrl" runat="server" Label="Url" Disabled="true" />
                    <dwc:InputText ID="txtRequestType" runat="server" Label="Type" Disabled="true" />
                    <dwc:InputText runat="server" ID="txtDynamicwebRequest" Label="Dynamicweb Codeunit Request" Visible="false" Disabled="true" />
                    <dwc:InputTextArea runat="server" ID="txtBody" Label="Body" Info="text/xml" Rows="5" Visible="false" Disabled="true" />
                </dwc:GroupBox>
                <dwc:GroupBox ID="GroupBox1" runat="server" Title="Request Headers">
                    <dw:EditableGrid ID="headersGrid" AllowAddingRows="false" ShowHeader="true"
                        NoRowsMessage="No headers found" AllowSortingRows="false" runat="server">
                        <Columns>
                            <asp:TemplateField HeaderText="Key">
                                <ItemTemplate>
                                    <div style="white-space: nowrap">
                                        <asp:TextBox ID="txKey" CssClass="form-control" Text='<%#Eval("Key")%>' runat="server" ReadOnly="true" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Value">
                                <ItemTemplate>
                                    <asp:TextBox ID="txValue" CssClass="form-control" Text='<%#Eval("Value")%>' runat="server" ReadOnly="true" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </dw:EditableGrid>
                </dwc:GroupBox>
                <dwc:GroupBox ID="gbAuthenticationSettings" runat="server" Title="Authentication settings" Visible="false">
                    <dwc:InputText ID="txtAuthenticationName" runat="server" Label="Authentication Name" Disabled="true" />
                    <dwc:InputTextArea ID="txtAuthenticationType" Label="Authentication type" runat="server" Disabled="true" />
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" Title="Response">
                    <dwc:InputTextArea runat="server" ID="txtResponse" Label="Response" Rows="10" />
                    <dwc:Button runat="server" DoTranslate="true" Title="Send request" ActionType="submit" OnClick="" />
                </dwc:GroupBox>
            </dwc:CardBody>
        </form>
    </dwc:Card>
</body>
</html>
