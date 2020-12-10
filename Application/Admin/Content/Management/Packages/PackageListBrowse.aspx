<%@ Page Language="vb" AutoEventWireup="false" EnableViewState="false" CodeBehind="PackageListBrowse.aspx.vb" Inherits="Dynamicweb.Admin.PackageListBrowse" %>

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
</head>
<body class="area-blue">
    <div class="dw8-container">
        <form method="post" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Packages" />
                <dwc:CardBody runat="server">
                    <dwc:GroupBox runat="server" ID="BrowsePackagesGroupBox">
                        <div runat="server" id="BrowsePackagesList">
                        </div>
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
        </form>
    </div>
</body>
</html>
