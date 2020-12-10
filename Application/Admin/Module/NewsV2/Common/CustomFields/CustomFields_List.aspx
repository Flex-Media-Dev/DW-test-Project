<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CustomFields_List.aspx.vb" Inherits="Dynamicweb.Admin.CustomFields_List" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <dw:ControlResources IncludePrototype="true" runat="server" IncludeUIStylesheet="true"></dw:ControlResources>
    <script type="text/javascript">
        function addField() {
            window.location.href = 'CustomFields_edit.aspx?context=<%= Converter.ToString(Request("context"))%>';
        }
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server">
            <h2 class="header">
                <dw:TranslateLabel runat="server" Text="Custom fields" />
            </h2>
        </dwc:CardHeader>
        <dwc:CardBody runat="server">
            <form id="form1" runat="server">
                <dw:Toolbar runat="server">
                    <dw:ToolbarButton runat="server" Text="New custom field" Icon="AddBox" OnClientClick="addField();"></dw:ToolbarButton>
                </dw:Toolbar>
                <dw:List runat="server" ID="customFields" ShowTitle="false">
                    <Columns>
                        <dw:ListColumn runat="server" Name="Field name" />
                        <dw:ListColumn runat="server" Name="Template tag" />
                        <dw:ListColumn runat="server" Name="Field type" />
                    </Columns>
                </dw:List>
            </form>
        </dwc:CardBody>
    </dwc:Card>
</body>
</html>
