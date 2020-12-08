<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LogFilesList.aspx.vb" Inherits="Dynamicweb.Admin.LogFilesList" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <dwc:ScriptLib runat="server" ID="ScriptLib1" /> 
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/List/List.js"></script>
    <style>
        .card-body{
            padding-top:0!important;
        }
        .listRow td{
            vertical-align:middle!important;
        }
        .md {
            font-size:16px;
        }
    </style>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:BlockHeader ID="Header" runat="server">
        </dwc:BlockHeader>
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Logs"></dwc:CardHeader>
                <form id="MainForm" runat="server">
                    <dw:List Title="Logs" ShowTitle="False" ID="LogFilesList" runat="server" PageSize="100" >
                        <Columns>
                            <dw:ListColumn Name="" Width="16" runat="server" />
                            <dw:ListColumn Name="File name" ID="FileNameColumn" runat="server" CssClass="pointer" />
                        </Columns>
                    </dw:List>
                </form>
        </dwc:Card>
    </div>
</body>
</html>