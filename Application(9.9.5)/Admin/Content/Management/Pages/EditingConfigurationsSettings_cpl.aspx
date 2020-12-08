<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditingConfigurationsSettings_cpl.aspx.vb" Inherits="Dynamicweb.Admin.EditingConfigurationsSettings" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html>
<head runat="server">
    
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/List/List.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/WaterMark.js" type="text/javascript"></script>  
        <link rel="stylesheet" type="text/css" href="/Admin/Resources/css/dw8stylefix.css" />               
    </dwc:ScriptLib>
    <script type="text/javascript">
        function confirmDeleteEditorConfiguration(configurationID, warningMsg) {
            if (confirm(warningMsg))
                location = 'EditingConfigurationsSettings_cpl.aspx?deleteConfig=' + configurationID;
        }

        function editEditorConfiguration(configurationID) {
            location = '/Admin/Access/EditorConfiguration/Configuration_Edit.aspx?ConfigurationID=' + configurationID + '&ReturnURL=/Admin/Content/Management/Pages/EditingConfigurationsSettings_cpl.aspx';
        }

        function newEditorConfiguration() {
            location = '/Admin/Access/EditorConfiguration/Configuration_Edit.aspx?ReturnURL=' + encodeURIComponent('/Admin/Content/Management/Pages/EditingConfigurationsSettings_cpl.aspx');
        }

        function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("", "administration.managementcenter.editing.editorconfiguration")%>
        }
    </script>
</head>

<body class="area-blue">
    <div class="dw8-container">
        <dwc:BlockHeader runat="server">
        </dwc:BlockHeader>
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbSetup" Title="Editor configurations"></dwc:CardHeader>
            <form id="MainForm" runat="server">
                <asp:Panel ID="MainContent" runat="server">
                <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="cmdNewConfiguration" runat="server" Divide="None" Icon="PlusSquare" Text="New editor configuration" OnClientClick="newEditorConfiguration(); return false;" />
                </dw:Toolbar>
                    <dw:List ID="configurationsList" runat="server" Title="" ShowTitle="false" PageSize="25" NoItemsMessage="Der er endnu ikke oprettet nogle konfigurationer">
                        <Filters></Filters>
                        <Columns>
                            <dw:ListColumn ID="colName" runat="server" Name="Name" EnableSorting="true" Width="300" />
                            <dw:ListColumn ID="colIsDefault" runat="server" Name="Default" EnableSorting="true" />
                            <dw:ListColumn ID="colDelete" runat="server" Name="Delete" EnableSorting="true" />
                        </Columns>
                    </dw:List>
                </asp:Panel>
                <asp:Panel ID="pNoAccess" runat="server">                        
                    <dwc:GroupBox ID="GroupBox2" runat="server" Title="Updates" GroupWidth="6">                            
                        <div class="form-group">
                            <dw:TranslateLabel ID="lbNoAccess" Text="Du har ikke de nødvendige rettigheder til denne funktion." runat="server" />                                
                        </div>
                    </dwc:GroupBox>
                </asp:Panel>
            </form>
        </dwc:Card>
    </div>

    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
    </dw:Overlay>
</body>

<%Translate.GetEditOnlineScript()%>
</html>
