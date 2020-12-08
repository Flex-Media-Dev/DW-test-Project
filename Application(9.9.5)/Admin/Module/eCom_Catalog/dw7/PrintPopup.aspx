<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PrintPopup.aspx.vb" Inherits="Dynamicweb.Admin.PrintPopup" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Print</title>
    <script type="text/javascript" language="javascript">
        function fillPrintContent() {
            var divElm = document.getElementById("PrintContent");
            divElm.innerHTML = opener.document.getElementById("PrintContent").innerHTML;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="PrintContent">
    
    </div>
    </form>
    
</body>
    <script type="text/javascript" language="javascript">
        fillPrintContent();
        print();
    </script>
</html>
