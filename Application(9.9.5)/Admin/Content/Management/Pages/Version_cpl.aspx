<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="Version_cpl.aspx.vb" Inherits="Dynamicweb.Admin.Version_cpl" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">    
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js"></script>
    <script src="/Admin/Images/Ribbon/UI/List/List.js" type="text/javascript"></script>
    <script src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <style type="text/css">
        .list tbody[id] tr.selected td {
            background-color: #0085CA !important;
            color: #fff;
        }
    </style>
    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () {
            page.submit();
        };

        function showFileLocationsDlg() {
            dialog.show("dlgFileLocations");
        }

        function showReleasesInfo() {
            window.open("http://doc.dynamicweb.com/releases-and-downloads/releases", "_blank", "");
        }

        function downgradeWarningOk() {
            dialog.hide('dlgDowngradeWarning');
            dialog.show('dlgConfirmUpdate');
        }

        function downgradeWarningCancel() {
            dialog.hide('dlgDowngradeWarning');	            
        }

        function apply(){
            dialog.hide("dlgConfirmUpdate");
            var o = new overlay('wait');
            o.show();
            window.location = "Version_cpl.aspx?newpath=" + encodeURIComponent(document.getElementById("SelectedVersion").value);
        }

        (function ($) {
            var isSelectedVersionBeforeVersion = function (version) {                
                var ret = false;
                var selectedOptEl = $("#SelectedVersion option:selected");
                var selectedVersion = selectedOptEl.text();
                if (selectedOptEl.val() && selectedVersion) {
                    var regex = /\(([^)]+)\)/;
                    var matches = selectedVersion.match(regex);
                    if (matches.length > 1) {
                        selectedVersion = matches[1].split(".");
                        var beforeVersion = version.split(".");
                        if (selectedVersion.length > 1 && beforeVersion.length > 1) {
                            if (parseInt(selectedVersion[0]) <= parseInt(beforeVersion[0])) {
                                if(parseInt(selectedVersion[0]) < parseInt(beforeVersion[0])) {
                                    ret = true;
                                } else {
                                    ret = (parseInt(selectedVersion[1]) < parseInt(beforeVersion[1]));
                                }
                            }
                        }
                    }
                }
                return ret;
            };

            var showDowngradeWarningFor83AndLower = function () {
                var isAfter83Version = <%= System.Web.Helpers.Json.Encode(IsCurrentVersionAfter83)%>;
                return isAfter83Version && isSelectedVersionBeforeVersion("8.4");
            };

            var showDowngradeWarningDlgFor851AndLower = function () {
                var isAfter861Version = <%= System.Web.Helpers.Json.Encode(IsCurrentVersionAfter861)%>;
                return isAfter861Version && isSelectedVersionBeforeVersion("8.6");
            };

            var isValid =  function() {
                var selectedVersionEl = $("#SelectedVersion");
                var errMsg = "";
                if (!selectedVersionEl.val()) {
                    errMsg = "<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.Translate("version"))%>";
                }
                dwGlobal.controlErrors("SelectedVersion", !!errMsg, errMsg);
                return !errMsg;
            };

            var changeVersionConfirm = function () {
                var selectedVersionEl = $("#SelectedVersion");
                if (!isValid()) {
                    return false;
                }
                
                $("#pathNameb").text(selectedVersionEl.val());
                dialog.hide('dlgChangeVersion');

                var showWarningFor83AndLower = showDowngradeWarningFor83AndLower();
                $("#before84DowngradeWarning").toggle(showWarningFor83AndLower);
                var showWarningDlgFor851AndLower = showDowngradeWarningDlgFor851AndLower();
                $("#before86DowngradeWarning").toggle(showWarningDlgFor851AndLower);
                if (showWarningFor83AndLower || showWarningDlgFor851AndLower) {
                    dialog.show('dlgDowngradeWarning');
                } else {
                    dialog.show('dlgConfirmUpdate');
                }
            };

            var showChangeVersionDlg = function () {
                var idx = ContextMenu.callingID || 0;
                var selectedVersionEl = $("#SelectedVersion");
                var v = selectedVersionEl.find("option").eq(idx).val();
                selectedVersionEl.selectpicker("val", v);
                dwGlobal.hideControlErrors("SelectedVersion", "");
                dialog.show('dlgChangeVersion');
            };

            $(function () {
                window.changeVersionConfirm = changeVersionConfirm;
                window.showChangeVersionDlg = showChangeVersionDlg;
                $("#SelectedVersion").on("change", isValid);
            });
        })(jQuery);

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
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Versions"></dwc:CardHeader>
        <dw:Toolbar ID="ToolbarButtons" runat="server">
            <dw:ToolbarButton runat="server" ID="changeVersionBtn" Divide="None" Icon="Refresh" Text="Change version" OnClientClick="ContextMenu.callingID = 0; showChangeVersionDlg(); return false;" />
            <dw:ToolbarButton runat="server" ID="releaseInfoBtn" Divide="None" Icon="InfoCircle" IconColor="Success" Text="Releases" OnClientClick="showReleasesInfo();" />
            <dw:ToolbarButton runat="server" ID="fileLocationsBtn" Divide="None" Icon="Folder" Text="File locations" OnClientClick="showFileLocationsDlg(); return false;" />
        </dw:Toolbar>

        <dw:List ID="lstVersions" ShowPaging="false" NoItemsMessage="" ShowTitle="false" ShowCollapseButton="false" runat="server">
            <Columns>
                <dw:ListColumn ID="colName" Name="Name" runat="server" />
                <dw:ListColumn ID="colVersion" Name="Version" runat="server" />
                <dw:ListColumn ID="colDate" Name="Dato" runat="server" />
                <dw:ListColumn ID="colType" Name="Type" runat="server" />
                <dw:ListColumn ID="colPath" Name="Sti" runat="server" />
            </Columns>
        </dw:List>

        <dw:Infobar ID="infoCustom" runat="server" Type="Information" Visible="false">
            <span>Custom</span>
            <b runat="server" id="CustomHomeDir"></b>
        </dw:Infobar>

        <dw:Infobar ID="serviseDownWarning" runat="server" Type="Error" Visible="false">
            <dw:TranslateLabel Text="The Version webservice is down please try again later. Contact service desk if the problem persists" runat="server" />
        </dw:Infobar>

        <dw:Overlay ID="wait" runat="server" Message="" ShowWaitAnimation="True">
            <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Opdatering" />
            ...
        </dw:Overlay>

        <% Translate.GetEditOnlineScript() %>
    </dwc:Card>

    <dw:Dialog ID="dlgChangeVersion" runat="server" Title="Change version" OkAction="changeVersionConfirm();" ShowOkButton="true" ShowCancelButton="true" Size="Medium">
        <dwc:InputText runat="server" ID="CurrentVersion" Label="Current version" Disabled="true" />
        <dwc:SelectPicker runat="server" ID="SelectedVersion" ClientIDMode="Static" Label="Change to version" ValidationMessage="" Container="body" />
        <dwc:InputText runat="server" ID="homedir" Label="Sti" Disabled="true" Visible="false" />
    </dw:Dialog>

    <dw:Dialog ID="dlgConfirmUpdate" runat="server" Title="Bekræft" OkAction="apply();" ShowOkButton="true" ShowCancelButton="true" Width="550">
        <img src="/Admin/Images/Ribbon/Icons/warning.png" alt="" style="vertical-align: middle;" />
        <%=Translate.JsTranslate("Opdater %%", "%%", Translate.JsTranslate("Home directory"))%>?
		        <p id="pathNameb" class="lead text-center"></p>
        <div class="alert alert-warning" role="alert">
            <strong><%=Translate.JsTranslate("ADVARSEL!")%></strong>
            <%=Translate.JsTranslate("The website will restart and you will be logged off.")%>
        </div>
    </dw:Dialog>

    <dw:Dialog ID="dlgDowngradeWarning" runat="server" Title="Downgrade warning" OkAction="downgradeWarningOk();" CancelAction="downgradeWarningCancel();" ShowOkButton="true" ShowCancelButton="true" Width="600">
        <ul id="before84DowngradeWarning" style="display: none;">
            <li><%=Translate.JsTranslate("It is not possible to downgrade a custom solution to pre 8.4 versions.")%></li>
            <li><%=Translate.JsTranslate("If this is a custom solution please click Cancel and contact servicedesk for help with downgrading.")%></li>
            <li><%=Translate.JsTranslate("If this is a standard solution click OK to continue.")%></li>
        </ul>
        <ul id="before86DowngradeWarning" style="display: none;">
            <li><%=Translate.JsTranslate("All shared item types will be lost when downgrading below Dynamicweb 8.6")%></li>
        </ul>
    </dw:Dialog>

    <dw:Dialog ID="dlgFileLocations" runat="server" Title="File locations" Width="600" ShowCancelButton="true" CancelText="Close">
        <dw:Infobar ID="assemblyWarning" runat="server" Type="Error" Visible="false">ERROR. This solution has a version conflict.</dw:Infobar>
        <dwc:InputText runat="server" ID="litHomeDir" Label="Home directory" Disabled="true" />
        <dwc:InputText runat="server" ID="litAdminLocation" Label="Admin location" Disabled="true" />
        <dwc:InputText runat="server" ID="litBinLocation" Label="Bin location" Disabled="true" />
        <dwc:InputText runat="server" ID="litFilesLocation" Label="File location" Disabled="true" />
    </dw:Dialog>
</asp:Content>

<asp:Content ContentPlaceHolderID="FooterContext" runat="server">
    <dw:ContextMenu ID="VersionsListRowContextMenu" runat="server">
        <dw:ContextMenuButton ID="ContextmenuButton1" runat="server" Divide="None" Icon="Refresh" Text="Change version" OnClientClick="showChangeVersionDlg();" />
        <dw:ContextMenuButton ID="ContextmenuButton2" runat="server" Divide="None" Icon="InfoCircle" Text="Information" OnClientClick="showReleasesInfo();" />
    </dw:ContextMenu>
</asp:Content>
