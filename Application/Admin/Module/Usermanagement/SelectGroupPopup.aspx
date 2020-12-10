<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SelectGroupPopup.aspx.vb" Inherits="Dynamicweb.Admin.UserManagement.SelectGroupPopup" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <meta name="Cache-control" content="no-cache" />
    <meta http-equiv="Cache-control" content="no-cache" />
    <title>
        <%=Dynamicweb.SystemTools.Translate.JsTranslate("Select a group")%></title>
    <dw:ControlResources IncludePrototype="True" runat="server" />

    <script type="text/javascript">
        function addGroup(groupCallBack, groupID, groupName, userCount, groupsIsSmartSearch)
        {
            try
            {
                eval('parent.' + groupCallBack + '("' + groupID + '","' + groupName + '",' + userCount + ', false,' + groupsIsSmartSearch + ')');
                window.close();
                return;
            } catch(e) { }
            try
            {
                eval('opener.' + groupCallBack + '("' + groupID + '","' + groupName + '",' + userCount + ', false,' + groupsIsSmartSearch + ')');
                window.close();
                return;
            } catch(e) { }

            var returnValue = new Object();
            returnValue.groupID = groupID;
            returnValue.groupName = groupName;
            returnValue.userCount = userCount;
            returnValue.groupsIsSmartSearch = groupsIsSmartSearch;
            window.returnValue = returnValue;
            window.close();
        }
    </script>
        
    <style type="text/css">
        html{overflow-x: hidden} /*Remove horizontal scrollbar*/
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <dw:Tree ContextMenuID="TreeContext" ID="UserTree" runat="server" Title="Groups" ShowRoot="false" OpenAll="false" UseSelection="true" LoadOnDemand="true" UseCookies="false" UseLines="true" InOrder="false" AutoID="true">
            <dw:TreeNode ID="Root" NodeID="0" runat="server" Name="Root" ParentID="-1" />
        </dw:Tree>
        <dw:ContextMenu runat="server" ID="TreeContext"/>
    </form>
    
    <script type="text/javascript" language="javascript">
        
        document.observe("dom:loaded", function () {
            var arr, i;

            arr = $$('#title1, #subtitle1, #tree1');

            for (i = 0; i < arr.length; i += 1) {
                arr[i].setStyle({
                    'width' : '100%'
                });
            }
            
            // Trick to get the postback to call this modal window
            if (window.name == '') {
                window.name = 'AddGroupWindow';
            }
                
            document.forms[0].target = window.name;
        });
        

        function closeOnEscapeKey(e) // note: takes the event as an arg (IE doesn't)
        {
            if(!e) e = window.event; // fix IE

            if(e.keyCode) // IE
            {
                if(e.keyCode == "27") window.close();
            }
            else if(e.charCode) // Netscape/Firefox/Opera
            {
                // MUST OPEN about:config in FIREFOX and set userpref dom.allow_scripts_to_close_windows to true
                if(e.keyCode == "27") window.close();
            }
        }
        document.onkeypress = closeOnEscapeKey;
    </script>

</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
%>
</html>
