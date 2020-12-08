<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CookieOptInLevelConfig.aspx.vb" Inherits="Dynamicweb.Admin.CookieOptInLevelConfig" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>OptIn Cookie Management</title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="margin: 100px 0px 0px 100px;">
        <p><asp:Literal ID="lblCurrentCookie" runat="server"></asp:Literal></p>
        <p>Change OptIn Level Cookie:<br /></p>
        <table>
            <tr>
                <td>None:</td>
                <td><input type="radio" runat="server" id="rbNone" name="level" /></td>
            </tr>
            <tr>
                <td>Functional:</td>
                <td><input type="radio" runat="server" id="rbFunctional" name="level" /></td>
            </tr>
            <tr>
                <td>All:</td>
                <td><input type="radio" runat="server" id="rbAll" name="level" /></td>
            </tr>
            <tr>
                <td></td>
                <td align="right"><input id="Submit1" type="submit" runat="server" value="Set" /></td>
            </tr>
        </table>                
    </div>
    </form>
</body>
</html>