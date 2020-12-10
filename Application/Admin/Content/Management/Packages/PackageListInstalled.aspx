<%@ Page Language="vb" AutoEventWireup="false" EnableViewState="false" CodeBehind="PackageListInstalled.aspx.vb" Inherits="Dynamicweb.Admin.PackageListInstalled" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib">
        <script src="/Admin/Content/JsLib/dw/Utilities.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/List/List.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/WaterMark.js" type="text/javascript"></script>
        <link rel="stylesheet" type="text/css" href="/Admin/Resources/css/dw8stylefix.css" />
    </dwc:ScriptLib>
    <% If ShowLicenseWarning Then %>
    <script>
        Action.Execute(<%=GetLicenseWarningDialog()%>)
    </script>
    <% End If %>
    <style type="text/css">
        table.table#ListTable {
            border: none;
        }
        table.table#ListTable tr.header > td:last-child,
        table.table#ListTable > tbody > tr > td:last-child {
             display: none;
        }
    </style>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:BlockHeader runat="server" id="Blockheader">
        </dwc:BlockHeader>
        <form method="post" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Installed packages" />
                <dw:Infobar runat="server" ID="ErrorBlock" Type="Error" Visible="false" Message="This solution doesn't have the setup to use packages." Title="Error" />
                <dw:List runat="server" ID="InstalledPackagesList" ShowTitle="false">
                    <Columns>
                        <dw:ListColumn runat="server" Name="Name" />
                        <dw:ListColumn runat="server" Name="Installed" Width="150" />
                        <dw:ListColumn runat="server" Name="Version" Width="150" />
                        <dw:ListColumn runat="server" Name="Latest" Width="150" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
</body>
</html>