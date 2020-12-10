<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewFile.aspx.vb" Inherits="Dynamicweb.Admin.ViewFile" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <dwc:ScriptLib runat="server" ID="ScriptLib1" />
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="CardHeader" DoTranslate="false" ></dwc:CardHeader>
            <dwc:CardBody runat="server">
                <dwc:Groupbox runat="server" Title="Content">
                    <asp:Repeater id="FileOutput" runat="server" >
                        <HeaderTemplate>
                            <div class="form-group">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%# Container.DataItem%>
                            <br />
                        </ItemTemplate>
                        <FooterTemplate>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>
                </dwc:Groupbox>
            </dwc:CardBody>
        </dwc:Card>
    </div>
</body>
</html>