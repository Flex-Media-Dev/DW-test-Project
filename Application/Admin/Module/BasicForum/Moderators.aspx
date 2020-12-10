<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Moderators.aspx.vb"
    Inherits="Dynamicweb.Admin.BasicForum.Moderators" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <script type="text/javascript">
        function closeDialog() {
            parent.dialog.hide('<%=dialogID %>');
        }
        if (parent) {
            parent.dialog.set_okButtonOnclick('<%=dialogID %>', function () {
                document.getElementById("form1").submit();
            });
        }
        if ('<%=doClose %>' == 'True')
            closeDialog();
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <dwc:GroupBox ID="GroupBox1" runat="server" Title="Select users" DoTranslation="true">            
            <dw:UserSelector runat="server" ID="UserSelector" Show="Users" />            
        </dwc:GroupBox>        
    </form>
</body>
<%  Translate.GetEditOnlineScript()%>
</html>
