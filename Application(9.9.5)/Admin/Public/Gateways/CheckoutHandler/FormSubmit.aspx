<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FormSubmit.aspx.vb" Inherits="Dynamicweb.Admin.FormSubmit" EnableViewState="false" EnableEventValidation="false" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <form id="CheckoutForm" runat="server" method="post" enableviewstate="false">
        
    </form>
    <input type="hidden" runat="server" id="DoSubmit" value="false" />
    <script type="text/javascript">
        if (document.getElementById('DoSubmit').value != 'false') {
            var form = document.getElementById('CheckoutForm');
            var vs = document.getElementById("__VIEWSTATE");
            var vsgen = document.getElementById("__VIEWSTATEGENERATOR");
            if (vs) {
                vs.parentNode.removeChild(vs);
            }
            if (vsgen) {
                vsgen.parentNode.removeChild(vsgen);
            }
            form.submit();
        }
    </script>
</body>
</html>
