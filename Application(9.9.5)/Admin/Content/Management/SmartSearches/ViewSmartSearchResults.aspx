<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewSmartSearchResults.aspx.vb" Inherits="Dynamicweb.Admin.ViewSmartSearchResults" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

    <!-- Default ScriptLib-->
    <dwc:ScriptLib runat="server" ID="ScriptLib1" >
        <script src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" type="text/javascript"></script>        
        <script src="/Admin/Images/Ribbon/UI/List/List.js" type="text/javascript"></script>
    </dwc:ScriptLib>

    <script type="text/javascript">
        var itemId = <%= Converter.ToInt32(Dynamicweb.Context.Current.Request("ID"))%>;
        var redirCMD = '<%= Converter.ToString(Dynamicweb.Context.Current.Request("CMD"))%>';
        if ('<%=Converter.ToBoolean(Dynamicweb.Context.Current.Request("Refresh")) %>' == 'True') {
            if (redirCMD.length != 0) {
                parent.submitReload(itemId, redirCMD);
            }else{
                parent.submitMe(itemId);
            }
        }  

        


        <%--
        
         22/3/16 TODO: Figure out why this function don't take in the right ID.

       
             var edit = function(){
            location.href='EditSmartSearch.aspx?ID=<%=SmartSearch.UserID%>&CMD=EDIT_SMART_SEARCH&providerType=<%=SmartSearch.DataProviderTypeName%>&calledFrom=<%=Converter.ToString(Dynamicweb.Context.Current.Request("calledFrom"))%>';
        }
        
        --%>
    </script>

</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:BlockHeader ID="Header" runat="server">
            <ul class="actions">
                <li>
                    <a class="icon-pop" href="javascript:edit();"><i class="fa fa-edit"></i></a>
                </li>
            </ul>
        </dwc:BlockHeader>
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="CardHeader"></dwc:CardHeader>
            <dwc:CardBody runat="server">
                <form id="form1" runat="server">
                    <dw:List ID="ListResults" runat="server" Title="Items" PageSize="30" ShowTitle="false" />
                    <dw:Infobar ID="previewDescription" Visible="False" Type="Information" runat="server" />
                </form>
            </dwc:CardBody>
        </dwc:Card>
    </div>

</body>

<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
