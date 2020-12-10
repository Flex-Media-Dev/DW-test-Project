<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ControlsExamples.aspx.vb" Inherits="Dynamicweb.Admin.ControlsExamples" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        body {
            display: flex;
            flex-direction: row;
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
        }

        iframe {
            flex: 0.5;
        }
    </style>
</head>
<body>
    <iframe src="/Admin/Examples/ControlsDW.aspx"></iframe>
    <iframe src="/Admin/Examples/ControlsDWC.aspx"></iframe>
</body>
</html>
