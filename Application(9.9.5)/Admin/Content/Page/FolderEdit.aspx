<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FolderEdit.aspx.vb" Inherits="Dynamicweb.Admin.FolderEdit" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server" />
    <script type="text/javascript">        
        function validateFields() {
            var element = document.getElementById('<%=newName.ClientID%>');
            if (element && (!element.value || element.value == "")) {
                alert('<%= Translate.JsTranslate("Folder name can not be empty.") %>');
                return false;
            }
            return true;
        }

        function onload() {            
            setTimeout(function () { document.getElementById('<%=newName.ClientID%>').focus() }, 100);            
        }
    </script>
</head>
<body onload="onload();">
    <form id="form1" runat="server">
    <div>
        <br />
        <table>
            <tr>
                <td><dw:TranslateLabel runat="server" Text="Folder name" /></td>
                <td ><input type="text" id="newName" runat="server" class="NewUIinput"  /></td>
            </tr>
            <tr>
                <td></td>
                <td align="right"><asp:Button ID="btnSave" runat="server" OnClientClick="return validateFields();" Text="Save" Width="50" /></td>
            </tr>
        </table>        
    </div>
    </form>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
