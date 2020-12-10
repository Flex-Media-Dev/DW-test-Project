<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="ExternalLoginProvidersList.aspx.vb" Inherits="Dynamicweb.Admin.ExternalLoginProvidersList" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">    
    <script src="/Admin/Images/Ribbon/UI/List/List.js" type="text/javascript"></script>
    <script src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" type="text/javascript"></script>
    <script type="text/javascript">
        function Add() {
            if (!Toolbar.buttonIsDisabled('cmdAdd')) { { location.href = 'ExternalLoginProviderEdit.aspx'; } }
        }

        function GetHelp() {
		    <%=Dynamicweb.SystemTools.Gui.Help("", "administration.managementcenter.controlpanel.externalloginproviderslist")%>
        }

        function SelectItem(id) {
            var url = 'ExternalLoginProviderEdit.aspx?id=' + id;
            location.href = url;
        }
        function ChangeStatus(id) {
            location.href = 'ExternalLoginProvidersList.aspx?id=' + id + '&cmd=ChangeStatus';
        }
    </script>
    <style>
        i.provider-icon {
            width: 18px; 
            text-align: center; 
            margin-right: 4px;
        }

        .listRow {
            cursor: pointer;
        }
    </style>
</asp:Content>
<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <div id="breadcrumb"></div>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:GetHelp();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="External Login" />
        <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
            <dw:ToolbarButton ID="cmdAdd" runat="server" Disabled="false" Divide="None" Icon="PlusSquare" OnClientClick="Add()" Text="Add" />
        </dw:Toolbar>
        <dw:List ID="lstProviders" ShowPaging="true" ShowTitle="false" runat="server" PageSize="25">
            <Columns>
                <dw:ListColumn ID="colName" EnableSorting="true" Name="Login Provider Name" Width="300" runat="server" />
                <dw:ListColumn ID="colEnabled" ItemAlign="left" EnableSorting="false" Name="Active" Width="75" runat="server" />
            </Columns>
        </dw:List>

        <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
        </dw:Overlay>
        <% Translate.GetEditOnlineScript() %>
    </dwc:Card>
</asp:Content>
