<%@ Page Language="vb" AutoEventWireup="false" Codebehind="EcomOrder_Popup.aspx.vb"  Inherits="Dynamicweb.Admin.eComBackend.EcomOrder_Popup" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    
    	<dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
		
    
    <style type="text/css">
		BODY.margin {MARGIN: 0px }
		input,select,textarea {font-size: 11px; font-family: verdana,arial;}
	</style>

    <script type="text/javascript" language="JavaScript" src="../images/functions.js"></script>

    <script type="text/javascript" language="JavaScript">
		function Print()
		{
		   var sel = document.getElementById("FM_SelectedTemplate");
		    SetGC(SelectedTemplate(sel));
		    
		    var content = window.frames["ContentCell"];
		    content.focus();
		    content.print(); 
		}
		function SelectedTemplate(sel)
		{
		    var template = '';
		    if(sel.selectedIndex != -1)
		    {
		        template = sel.options[sel.selectedIndex].value;
		    }
		    return template;
		}
		function TemplateChanged(sel, orderId)
		{
		    var template = SelectedTemplate(sel);
		    window.frames["ContentCell"].location = "EcomOrder_PopupContent.aspx?id=<%=OrderId %>&template=" + template;
		}
		function SetUp(value)
		{
		    var sel = document.getElementById("FM_SelectedTemplate");
		    for (var i=0; i < sel.options.length; i++)
            {
                if (sel.options[i].value == value) sel.options[i].selected = true;
                else sel.options[i].selected = false;
            }
            TemplateChanged(sel);
		}
		function SetGC(template) 
		{
		    window.frames["iframeSetGc"].location = "EcomOrder_SetGC.aspx?command=<%=CInt(_command) %>&template=" + template;
		}
    </script>

</head>
<body style="background-color: #ECE9D8" leftmargin="1" rightmargin="0" topmargin="0">
    <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
    <form id="Form1" method="post" runat="server">
        <dw:TabHeader ID="TabHeader1" runat="server" TotalWidth="100%"></dw:TabHeader>
        <table border="0" cellpadding="0" cellspacing="0" class="tabTable100Small" id="DW_Ecom_tableTab">
            <tr>
                <td valign="top">
                    <div id="Tab1">
                        <div id="GroupWaitDlg" style="position: absolute; top: 40; left: 5; width: 100%;
                            height: 1; display: none; cursor: wait;">
                            <img src="../images/loading.gif" border="0">
                        </div>
                        <table height="100%" width="100%" border="0" cellpadding="0" cellspacing="0" id="DW_Ecom_GroupTree">
                            <tr>
                                <td valign="top">
                                    <div height="100%" id="Navi_DW_PopUp" style="height: 100%; width: 100%; overflow: no;
                                        overflow-x: hidden;">
                                        <iframe name="ContentCell" src="" marginwidth="0" marginheight="0" border="0" topmargin="0"
                                            leftmargin="10" frameborder="0" height="100%" width="100%" scrolling="auto"></iframe>
                                        <asp:Button ID="SubmitCheckBoxForm" Style="display: none;" runat="server"></asp:Button>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </form>
    <iframe id="iframeSetGc" frameborder="0" scrolling="no" height="0" width="0"></iframe>
</body>
</html>
