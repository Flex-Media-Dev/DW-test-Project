<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" ClientIDMode="Static" Language="vb" AutoEventWireup="false" CodeBehind="DatabaseSetup_cpl.aspx.vb" Inherits="Dynamicweb.Admin.DatabaseSetup_cpl" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function() {
            page.submit();
        }

        function SSPI() {
            if (document.getElementById("IntegratedSecurity").checked) {
                document.getElementById("DatabaseUserName").disabled = true;
                document.getElementById("DatabasePassword").disabled = true;
                document.getElementById("DatabaseUserName2").disabled = true;
                document.getElementById("DatabasePassword2").disabled = true;
            }
            else {
                document.getElementById("DatabaseSQLServer").disabled = false;
                document.getElementById("DatabaseDatabase").disabled = false;
                document.getElementById("DatabaseUserName").disabled = false;
                document.getElementById("DatabasePassword").disabled = false;

                document.getElementById("DatabaseDWWebIP").disabled = false;
                document.getElementById("DatabaseSQLServer2").disabled = false;
                document.getElementById("DatabaseDatabase2").disabled = false;
                document.getElementById("DatabaseUserName2").disabled = false;
                document.getElementById("DatabasePassword2").disabled = false;
            }
        }

    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Header">
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="ContentHeader" Title="Database setup"></dwc:CardHeader>
        <dwc:CardBody runat="server">
			<div class="showOnSql">
				<dwc:GroupBox ID="GroupBoxSettings" runat="server" Title="Indstillinger">
                    <dwc:CheckBox runat="server" ID="IntegratedSecurity" Name="/Globalsettings/System/Database/IntegratedSecurity" Label="Brug pålidelig forbindelse" Header="Connection" />
                    <dwc:InputText runat="server" ID="DatabaseSQLServer" Name="/Globalsettings/System/Database/SQLServer" Label="Server" MaxLength = "255" />
                    <dwc:InputText runat="server" ID="DatabaseName" Name="/Globalsettings/System/Database/Database" Label="Database" MaxLength = "255" />
                    <dwc:InputText runat="server" ID="DatabaseUserName" Name="/Globalsettings/System/Database/UserName" Label="Brugernavn" MaxLength = "255" />
                    <dwc:InputText runat="server" ID="DatabasePassword" Name="/Globalsettings/System/Database/Password" Label="Adgangskode" Password="true" />
                    <dwc:InputText runat="server" ID="DatabaseConnectionString" Name="/Globalsettings/System/Database/ConnectionString" Label="Connection string" MaxLength = "255" />
				</dwc:GroupBox>
                    
                <dwc:GroupBox ID="GroupBox3" runat="server" Title="Alternativ">
                    <dwc:InputText runat="server" ID="DatabaseDWWebIP" Name="/Globalsettings/System/Database/DWWebIP" Label="Check IP" />
                    <dwc:InputText runat="server" ID="DatabaseSQLServer2" Name="/Globalsettings/System/Database/SQLServer2" Label="Server 2" MaxLength = "255" />
                    <dwc:InputText runat="server" ID="DatabaseName2" Name="/Globalsettings/System/Database/Database2" Label="Database 2" MaxLength = "255" />
                    <dwc:InputText runat="server" ID="DatabaseUserName2" Name="/Globalsettings/System/Database/UserName2" Label="Brugernavn 2" MaxLength = "255" />
                    <dwc:InputText runat="server" ID="DatabasePassword2" Name="/Globalsettings/System/Database/Password2" Label="Adgangskode 2" Password="true" />
                    <dwc:InputText runat="server" ID="DatabaseConnectionString2" Name="/Globalsettings/System/Database/ConnectionString2" Label="Connection string 2" MaxLength = "255" />
				</dwc:GroupBox>
			</div>
        </dwc:CardBody>
    </dwc:Card>
	<script type="text/javascript">
	    sqlAccessChange();
	    SSPI();

	    document.getElementById("IntegratedSecurity").onclick = function () { SSPI() };
	</script>

<%Translate.GetEditOnlineScript()%>
</asp:Content>
