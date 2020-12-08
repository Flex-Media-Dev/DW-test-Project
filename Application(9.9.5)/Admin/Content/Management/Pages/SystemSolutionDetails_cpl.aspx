<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="SystemSolutionDetails_cpl.aspx.vb" Inherits="Dynamicweb.Admin.SystemSolutionDetails_cpl" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Configuration" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        function doUpdate() {
            var loader = new overlay("__ribbonOverlay");
            loader.show();
            document.forms[0].action = document.location.toString();
            document.forms[0].submit();
        };
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <br />
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>
            <li><a href="#">System</a></li>
            <li class="active"><%= Translate.Translate("System information") %></li>
        </ol>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="System information" />
        <dwc:CardBody runat="server">
            <dwc:GroupBox runat="server" ID="groupbox12" Title="IIS">
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Version")%></label>
                    <div>
                        <%=HttpContext.Current.Request.ServerVariables("SERVER_SOFTWARE")%>(<asp:Literal ID="iisVersion" runat="server" />)
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("IIS Name")%></label>
                    <div>
                        <asp:Literal ID="iisName" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Application pool")%></label>
                    <div>
                        <asp:Literal ID="iisAppPoolId" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("404 Handler")%></label>
                    <div>
                        <asp:Literal ID="iisHandler404" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Is Azure web app")%></label>
                    <div>
                        <asp:Literal ID="iisIsAzureWebApp" runat="server" />
                    </div>
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="groupbox15" Title="Server">
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Server")%></label>
                    <div>
                        <asp:Literal ID="litServer" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Machine")%></label>
                    <div>
                        <asp:Literal ID="litMachine" runat="server" />&nbsp;(<a id="lnkMachine" target="_blank" runat="server"></a>)
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("OS type")%></label>
                    <div>
                        <asp:Literal ID="litOSBitVersion" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Server time")%></label>
                    <div>
                        <asp:Literal ID="litServertime" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Memory")%> (Total/Available)</label>
                    <div>
                        <asp:Literal ID="litServerMemory" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate(".NET Runtime version")%></label>
                    <div>
                        <asp:Literal ID="NetRuntimeVersion" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Application bit version")%></label>
                    <div>
                        <asp:Literal ID="litApplicationBitVersion" runat="server" />Bit
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Path")%></label>
                    <div>
                        <a id="lnkPath" target="_blank" runat="server"></a>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Intranet path")%></label>
                    <div>
                        <a id="lnkIntranetPath" target="_blank" runat="server"></a>
                    </div>
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="groupbox16" Title="Database">
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Database type")%></label>
                    <div>
                        <asp:Literal ID="litDatabaseType" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Server")%></label>
                    <div>
                        <asp:Literal ID="litDatabaseServer" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Name")%></label>
                    <div>
                        <asp:Literal ID="litDatabaseName" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Language database")%></label>
                    <div>
                        <asp:Literal ID="litLanguageDB" runat="server" />
                    </div>
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="groupbox13" Title="File locations">
                <dw:Infobar ID="assemblyWarning" runat="server" Type="Error" Visible="false">
                    ERROR. This solution has a version conflict.
                </dw:Infobar>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Home directory")%></label>
                    <div>
                        <asp:Literal ID="litHomeDir" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Admin location")%></label>
                    <div>
                        <asp:Literal ID="litAdminLocation" runat="server" /><br />
                        <span>
                            <asp:Literal ID="litAdminBinLocation" runat="server" Visible="false" />
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Bin location")%></label>
                    <div>
                        <span>
                            <asp:Literal ID="litBinLocation" runat="server" />
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("File location")%></label>
                    <div>
                        <asp:Literal ID="litFilesLocation" runat="server" />
                    </div>
                </div>
                <div class="form-group" id="databaseLocation" runat="server">
                    <label class="control-label"><%=Translate.Translate("Database location")%></label>
                    <div>
                        <asp:Literal ID="litDatabaseLocation" runat="server" />
                    </div>
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="groupbox11" Title="Version">
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Content version")%></label>
                    <div>
                        <asp:Literal ID="litContentVersion" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Assembly versions")%></label>
                    <div class="pull-left" style="max-height:340px;overflow:auto">
                        <asp:Repeater ID="DWAssembliesRepeater" runat="server" EnableViewState="false">
                        </asp:Repeater>
                    </div>
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="groupbox14" Title="Reporting">
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Last CRM report")%></label>
                    <div>
                        <%=Converter.ToDateTime(SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/CommonInformation/SolutionLastReportDate")).ToString(DateHelper.DateFormatStringShort)%>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("CRM installation ID")%></label>
                    <div>
                        <%=SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/CommonInformation/InstallationCrmID")%>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Installation checksum")%></label>
                    <div>
                        <asp:Literal ID="InstallationChecksum" runat="server" />
                    </div>
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="groupbox17" Title="Updates">
                <%=GetUpdateScriptsAndVersionNumbers()%>
                <div class="form-group">
                    <label class="control-label"></label>
                    <div>
                        <input name="RunUpdate" type="hidden" value="True" />
                        <input type="button" id="RunUpdate" class="btn btn-danger" <%If Not CanUpdate Then%> disabled="disabled" title="<%=Translate.Translate("Only user with administrator privileges can run update")%>" <%End If%> value="Rerun updates" onclick="doUpdate();" />
                        <a href="/Admin/Content/Management/Pages/ShowUpdateLog.aspx" class="btn btn-primary" target="_blank"><%=Translate.Translate("Download update log")%></a>
                    </div>
                </div>
            </dwc:GroupBox>

            <% Translate.GetEditOnlineScript()%>
        </dwc:CardBody>
    </dwc:Card>

</asp:Content>
