<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Title="" Language="vb" AutoEventWireup="false" CodeBehind="LicenseConfiguration.aspx.vb" Inherits="Dynamicweb.Admin.LicenseConfiguration" EnableEventValidation="false" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %><%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib1"></dwc:ScriptLib>
    
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/List/List.js"></script>

    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () { return save('cmdSave'); };
        page.saveAndClose = function () { return save('cmdSaveAndClose'); };
        page.cancel = function () { return cancel(); };

        var prevLicenseName = "";
        function save(cmd) {
            var confirmMsg = "<%=Translate.JsTranslate("Your changes will now be saved. After re-login your solution will be configured as you have selected and an invoice will be sent to you - for any questions please contant your sales representative.")%>";
            if (confirm(confirmMsg)) {
                $('cmd').value = cmd;

                var url = "LicenseConfiguration.aspx";
                $("MainForm").action = url;
                $('MainForm').submit();
            } else {
                
            }
        }

        function cancel() {
            window.location = "/Admin/Blank.aspx";
        }

        function insertParam(key, value) {
            key = encodeURI(key); value = encodeURI(value);

            var kvp = document.location.search.substr(1).split('&');

            var i = kvp.length; var x; while (i--) {
                x = kvp[i].split('=');

                if (x[0] == key) {
                    x[1] = value;
                    kvp[i] = x.join('=');
                    break;
                }
            }

            if (i < 0) { kvp[kvp.length] = [key, value].join('='); }

            //this will reload the page, it's likely better to store this until finished
            document.location.search = kvp.join('&');
        }

        function changeLicence(radio) {
            var container = document.getElementById("gbAddOns");
            var addons = Array.from(container.querySelectorAll("input[type=checkbox]"));
            var row = radio.closest(".listRow");
            var licenceAddons = row.readAttribute("data-licence-addons").split(",");
            var licenceSelectedAddons = row.readAttribute("data-licence-selected-addons").split(",");

            addons.forEach(function (addon) {
                addon.disabled = (licenceAddons.indexOf(addon.value) == -1);
                addon.checked = (licenceSelectedAddons.indexOf(addon.value) != -1);
            })
        }

    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server"> 
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="License configuration" />



            <dwc:CardBody runat="server">
            <dw:Infobar ID="TrialWarning" runat="server" Type="Information" Visible="False" Message="This solution is currently running a trial license and cannot be configured. To install a non-trial license click 'Setup License' below."></dw:Infobar>
            <dwc:Button ID="RefreshLicenseBtn" runat="server" Title="Renew trial" Visible="False"/>
            <dwc:Button ID="SetupLicenseBtn" runat="server" Title="Setup License" Visible="False"/>
                    <input type="hidden" id="cmd" name="cmd" value="" />
                    <dwc:GroupBox ID="gbLicense" runat="server" Title="License">
                        <dw:List ID="lstLicense" ShowPaging="false" NoItemsMessage="" ShowTitle="false" ShowCollapseButton="false" runat="server">
                        </dw:List>
                    </dwc:GroupBox>

                    <dwc:GroupBox ID="gbAddOns" runat="server" Title="Add-ons">
                        <asp:Repeater ID="AddonRepeater" runat="server" EnableViewState="false">
                            <ItemTemplate>
                                <dwc:CheckBox runat="server" Name='<%# Eval("Number") %>' Label='<%# Eval("Name") %>' Value='<%# Eval("Number") %>' Checked='<%# Eval("Checked") %>' Disabled='<%# Eval("Disabled") %>' DoTranslate="False" ></dwc:CheckBox>
                            </ItemTemplate>
                        </asp:Repeater>
                    </dwc:GroupBox>

                    <dwc:ActionBar runat="server">
                        <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" OnClientClick="return save('cmdSave');" ID="cmdSave" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
                        </dw:ToolbarButton>
                        <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" OnClientClick="return save('cmdSaveAndClose');" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
                        </dw:ToolbarButton>
                        <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="cancel();" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
                        </dw:ToolbarButton>
                    </dwc:ActionBar>
            </dwc:CardBody>
        </dwc:Card>
    </div>
    <% Translate.GetEditOnlineScript() %>
        <script type="text/javascript">
            (function () {
                var refreshButton = document.getElementById('<%= RefreshLicenseBtn.ID%>');
                var setupButton = document.getElementById('<%= SetupLicenseBtn.ID%>');
                if (refreshButton != null) {
                    refreshButton.onclick = function () {
                        insertParam("RefreshLicense", "true");
                    };
                }
                if (setupButton != null) {
                    setupButton.onclick = function () {
                        insertParam("SetupLicense", "true");
                    };
                }
            })();
    </script>
</asp:Content>
