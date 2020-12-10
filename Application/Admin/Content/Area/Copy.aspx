<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Copy.aspx.vb" Inherits="Dynamicweb.Admin.Copy1" Buffer="True" %>

<!DOCTYPE html>

<html>
<head>
    <title></title>
    <meta http-equiv="Pragma" content="no-cache" />
    <meta name="Cache-control" content="no-cache" />
    <meta http-equiv="Cache-control" content="no-cache" />
    <meta http-equiv="Expires" content="Tue, 20 Aug 1996 14:25:27 GMT" />
    <script src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script type="text/javascript">
<%If NewAreaID > 0 Then%>
        var nav = dwGlobal.getContentNavigator();
        var areaID = '<%=String.Format("Area{0}", NewAreaID) %>';
        if (nav) {
            nav.changeRootSelectorVal(areaID, true);
            nav.refreshRootSelector();
        }
        close();
<%Else %>
        parent.updateStatus("Error happened while executing operation! See {Monitoring-Event viewer} for details.");
        setTimeout(close, 5000);
<%End If %>

        function close() {
<%If IsNew Then%>
            location = "List.aspx";
<%Else %>
            parent.location = "List.aspx";
<%End If %>
        }
    </script>
</head>
<body>
    Done...
</body>
</html>
