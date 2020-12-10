<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="editDestination.aspx.vb" Inherits="Dynamicweb.Admin.editDestination" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>

    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>
    <script type="text/javascript" src="/Admin/Link.js"></script>

    <dw:ControlResources runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Images/Controls/UserSelector/UserSelector.js" />
        </Items>
    </dw:ControlResources>
    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/editDestination.css" type="text/css" />
    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/Base.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <dwc:GroupBox runat="server" ID="mainarea">
            <dw:Infobar ID="errorBar" runat="server" Visible="false"></dw:Infobar>
            <asp:Literal ID="destinationSelectorScripts" runat="server"></asp:Literal>
            <de:AddInSelector ID="DestinationSelector" runat="server" ShowOnlySelectedGroup="true" AddInGroupName="Destination" UseLabelAsName="True" AddInShowNothingSelected="false" AddInTypeName="Dynamicweb.DataIntegration.Integration.Interfaces.IDestination" AddInShowSelector="false" AddInShowFieldset="false" />
            <asp:Literal ID="destinationSelectorLoadScript" runat="server"></asp:Literal>
        </dwc:GroupBox>
        <div class="footer">
            <button class="dialog-button-ok btn btn-clean"><%=Translate.Translate("Save changes")%></button>
        </div>
    </form>
    <script type="text/javascript">
        addInParameters_onLoaded = function () {
            var el = document.getElementById('DestinationSelector_params');
            if (el != null && el.value != null && el.value.indexOf("UserProvider") > 0) {
                document.form1.style["min-height"] = "1010px";
            }
        }
    </script>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
