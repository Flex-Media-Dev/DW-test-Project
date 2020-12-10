<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FastLoadRedirect.aspx.vb" Inherits="Dynamicweb.Admin.FastLoadRedirect" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
</head>
<body>
    <div style="margin-top:15px; margin-left:10px;">
        <%=Dynamicweb.Core.UI.Icons.KnownIconInfo.GetIconHtml(Dynamicweb.Core.UI.Icons.KnownIcon.Recycle) %>
    </div>
</body>
</html>

<script type="text/javascript">
    document.location = '<%=redirectTo %>';
</script>
