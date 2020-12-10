<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="KnownIconsExamples.aspx.vb" Inherits="Dynamicweb.Admin.Known_Icons_Examples" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls.OMC" TagPrefix="omc" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<head>

    <title></title>
    <link href="/Admin/Resources/css/fonts.min.css" rel="stylesheet">
    <link href="/Admin/Resources/css/app.min.css" rel="stylesheet">
    <style>
        pre {
            display: inline-block;
            padding: 5.5px;
            margin: 0 0 2px;
            line-height: 1.1;
        }

        .size-3x {
            width: 48px;
            height: 48px;
            font-size: 38px;
        }

        .control-label {
            display: block;
            float: left;
            display: none;
        }
    </style>
</head>
<body class="screen-container area-blue label-left">
    <section id="content" class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Known Icons" DoTranslate="False">
            </dwc:CardHeader>

            <dwc:CardBody runat="server">
                <dwc:GroupBox runat="server">
                    <dw:Infobar runat="server" Message="This is how you use the icons, simply type and remember to include Dynamicweb.Core.UI.Icons: KnownIconInfo.ClassNameFor(KnownIcon.IconName, True)" Type="Information"></dw:Infobar>
                    <div runat="server" id="TheList"></div>
                    <br />
                    <br />
                    <br />
                    <h2>Known Adornments</h2>
                    <br />
                    <div runat="server" id="TheAdornments"></div>

                    <br />
                    <br />
                    <br />
                    <h2>Flags(Known Icons)</h2>
                    <br />
                    <div runat="server" id="FlagsList"></div>
                </dwc:GroupBox>
            </dwc:CardBody>

            <dwc:CardFooter runat="server">
            </dwc:CardFooter>
        </dwc:Card>

    </section>

    <script src="/Admin/Resources/js/jquery-2.1.1.min.js"></script>
</body>
