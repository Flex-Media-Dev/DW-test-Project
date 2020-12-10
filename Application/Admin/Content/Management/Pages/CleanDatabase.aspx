<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CleanDatabase.aspx.vb" Inherits="Dynamicweb.Admin.CleanDatabase" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
		<input type="hidden" name="clean" value="true" />
    <div>
    <button onclick="this.form.submit()">Clean db...</button>
    </div>
    </form>
	<div id="result" runat="server"></div>
</body>
</html>
