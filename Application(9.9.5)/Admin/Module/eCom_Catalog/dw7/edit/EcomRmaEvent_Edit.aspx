<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomRmaEvent_Edit.aspx.vb"
    Inherits="Dynamicweb.Admin.EcomRmaEvent_Edit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true"
        runat="server">
    </dw:ControlResources>

    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/images/layermenu.js"></script>
</head>
<body class="area-pink screen-container">
    <div class="card">
        <form id="Form1" runat="server">
            <asp:Literal ID="BoxStart" runat="server"></asp:Literal>
            <div class="card-header">
                <h2 class="subtitle">
                    <asp:Literal runat="server" ID="Header"></asp:Literal>
                </h2>
            </div>
            <dw:Toolbar runat="server" ID="Toolbar" ShowStart="True" ShowEnd="false">
            </dw:Toolbar>
            <dw:Infobar runat="server" ID="InfoBarNotTranslated" Visible="False">
            </dw:Infobar>
            <dwc:GroupBox ID="GroupBox1" runat="server" Title="State settings">
                <dwc:InputText runat="server" ID="Type" ClientIDMode="Static" Label="Name" Disabled="true" />
                <dwc:InputTextArea runat="server" ID="Description" ClientIDMode="Static" Label="Description" Height="50" />
            </dwc:GroupBox>


            <input type="hidden" name="Save" id="Save" value="" />
            <input type="hidden" name="SaveClose" id="SaveClose" value="" />
            <input type="hidden" name="Delocalize" id="Delocalize" value="" />
            <asp:Literal ID="BoxEnd" runat="server"></asp:Literal>
        </form>
    </div>
</body>
</html>
