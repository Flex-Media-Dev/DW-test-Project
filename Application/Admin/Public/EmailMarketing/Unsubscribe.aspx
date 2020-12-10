<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Unsubscribe.aspx.vb" Inherits="Dynamicweb.Admin.Unsubscribe" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

    <style type="text/css">
        body {
            background-color: darkgray;
        }
        p {
            text-align: center;
        }
        span.heading {
            font-size: 24px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form runat="server">
        <p>
            <span class="heading"><asp:Label runat="server" ID="lblHeader"></asp:Label></span><br />
            <asp:Label runat="server" ID="lblDescription"></asp:Label>
        </p>
    </form>
</body>
</html>
