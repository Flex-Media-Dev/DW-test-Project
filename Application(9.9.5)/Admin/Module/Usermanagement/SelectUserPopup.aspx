<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SelectUserPopup.aspx.vb" Inherits="Dynamicweb.Admin.UserManagement.SelectUserPopup" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title><%=Dynamicweb.SystemTools.Translate.JsTranslate("Select a user")%></title>
    <dw:ControlResources runat="server" />
    
    <script type="text/javascript">
        function addUser(userCallBack, userID, userName) {
            try {
                eval('parent.' + userCallBack + '(' + userID + ',"' + userName + '")');
                window.close();
                return;
            } catch (e) { }
            try {
                eval('opener.' + userCallBack + '(' + userID + ',"' + userName + '")');
                window.close();
                return;
            } catch (e) { }

            var returnValue = new Object();
            returnValue.userID = userID;
            returnValue.userName = userName;
            window.returnValue = returnValue;
            window.close();
        }
    </script>
    
</head>

<body>
    <form id="form1" runat="server" >
        <dw:List id="UserList" runat="server" PageSize="12" Title="Users" TranslateTitle="true">
            <Filters>
                <dw:ListAutomatedSearchFilter runat="server" ID="SearchFilter" EnableQueryExpressions="true" WaterMarkText="Search" />
                <dw:UserGroupListFilter runat="server" ID="UserGroupFilter" WaterMarkText="No group selected" ShowSubmitButton="false" />
            </Filters>
            <Columns>
                <dw:ListColumn ID="ListColumn1" runat="server" EnableSorting="true" Name="Username" TranslateName="true" />
                <dw:ListColumn ID="ListColumn2" runat="server" EnableSorting="true" Name="Email" TranslateName="true" />
                <dw:ListColumn ID="ListColumn3" runat="server" EnableSorting="true" Name="Name" TranslateName="true" />
            </Columns>
        </dw:List>
    </form>
    <script type="text/javascript">
        // Trick to get the postback to call this modal window
        if (window.name == '')
            window.name = 'AddUserWindow';
        document.forms[0].target = window.name;
    </script>

    <script type="text/javascript" language="javascript">
        function closeOnEscapeKey(e) // note: takes the event as an arg (IE doesn't)
        {
            if (!e) e = window.event; // fix IE
            if (e.keyCode) // IE
            {
                if (e.keyCode == "27") window.close();
            }
            else if (e.charCode) // Netscape/Firefox/Opera
            {
                // MUST OPEN about:config in FIREFOX and set userpref dom.allow_scripts_to_close_windows to true
                if (e.keyCode == "27") window.close();
            }
        }
        document.onkeypress = closeOnEscapeKey;
    </script>

    
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
    %>
</html>