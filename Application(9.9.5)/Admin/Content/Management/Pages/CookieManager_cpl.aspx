<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="CookieManager_cpl.aspx.vb" Inherits="Dynamicweb.Admin.CookieManager_cpl" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>
    <script src="/Admin/Images/SelectionBox/SelectionBox.js" type="text/javascript"></script>
    <asp:Literal ID="litScript" runat="server" />
    <asp:Literal ID="litImagesFolderName" runat="server" />

    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () { return save(false); };
        page.saveAndClose = function () { return save(true); };

        function save(close) {
            document.getElementById('TrackingCookiesSelectorValue').value = SelectionBox.getElementsRightAsArray('TrackingCookiesSelector');
            document.getElementById('SecureCookiesSelectorValue').value = SelectionBox.getElementsRightAsArray('SecureCookiesSelector');

            var url = "CookieManager_cpl.aspx?Save=true";
            if (close)
                url += "&Close=True";
            $("MainForm").action = url;
            $("MainForm").submit();
        }

        function addCustomCookie(customCookieInputId, selectorId) {
            var input = document.getElementById(customCookieInputId);
            var list = document.getElementById(selectorId + '_lstRight');

            var name = (input.value || '').trim();
            var selectedNames = SelectionBox.getElementsRightAsArray(selectorId);
            
            if (name.length > 0 && !selectedNames.includes(name))
            {
                var option = new Option(name, name);

                SelectionBox.insertOption(option, list);

                SelectionBox.setNoDataRight(selectorId);            
            
                if (typeof (eval(selectorId + "_onChange")) == 'function') {
                    eval(selectorId + "_onChange")();
                }
            }

            input.value = "";
        }

        (function ($) {
            $(function () {
                var enableNotificationEl = $('input[type=radio][name=UserNotificationGroup]');
                var templateSelector = $('[name=templateContainer]');
                var showHide = function () {
                    if (this.value === 'rbWarnings') {
                        templateSelector.show();
                    } else {
                        templateSelector.hide();
                    }
                };
                enableNotificationEl.on("change", showHide);

                var secureAllCookies = $('input[type=checkbox][name=cbSecureAllCookies]');
                var secureCookiesSelector = $('[name=SecureCookiesSelectorContainer]');
                var showHideSecureCookiesSelector = function () {
                    if (this.checked) {
                        secureCookiesSelector.hide();
                    } else {
                        secureCookiesSelector.show();
                    }
                };
                secureAllCookies.on("change", showHideSecureCookiesSelector);
            });
        })(jQuery);
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <div id="breadcrumb"></div>

        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="lbSetup" Title="Cookie Manager"></dwc:CardHeader>
        <dwc:CardBody runat="server">
            <input id="hiddenSource" type="hidden" name="_source" value="ManagementCenter" />
            <input id="hiddenCheckboxNames" type="hidden" name="CheckboxNames" />

            <dwc:GroupBox ID="UserNotificationGroupBox" runat="server" Title="User notification" GroupWidth="6">

                <dwc:CheckBox Name="cbDisableTrackingCookies" ID="cbDisableTrackingCookies" Label="Enable cookie manager" runat="server" />

                <div style="display: none;">
                    <dwc:CheckBox Name="cbDeleteJsTrackingCookies" ID="cbDeleteJsTrackingCookies" Label="Delete js tracking cookies" runat="server" />
                </div>

                <div class="selection-box">
                    <dwc:RadioGroup runat="server" Name="UserNotificationGroup">
                        <dwc:RadioButton ID="rbWarnings" FieldValue="rbWarnings" Label="Template based warnings" runat="server" />
                        <dwc:RadioButton ID="rbCustomUserNotifications" FieldValue="rbCustomUserNotifications" Label="Custom (set with Javascript or .Net)" runat="server" />
                    </dwc:RadioGroup>
                </div>

                <div id="templateContainer" name="templateContainer" runat="server">                    
                    <dw:FileManager ID="templateSelector" runat="server" Label="Select template" FixFieldName="true" ShowPreview="false" Folder="Templates/CookieWarning" ShowNothingSelectedOption="False" />
                </div>                                    
            </dwc:GroupBox>

            <dwc:GroupBox ID="SettingsGroupBox" runat="server" Title="Settings">
                <dwc:SelectPicker ID="drCookieLifetime" Label="Cookie lifetime" runat="server"></dwc:SelectPicker>

                <dwc:CheckBox Name="cbDisableHttpOnlyCookies" ID="cbDisableHttpOnlyCookies" Label="Disable httponly cookies" runat="server" />
                <dwc:CheckBox Name="cbUseDomainAndNotHost" ID="cbUseDomainAndNotHost" Label="Use domain for cookies" runat="server" Info="Set cookies using domain.com instead of host1.domain.com and host2.domain.com" />
                <dwc:CheckBox Name="cbSecureAllCookies" ID="cbSecureAllCookies" Label="Secure all cookies" runat="server" />
                <div id="SecureCookiesSelectorContainer" name="SecureCookiesSelectorContainer" runat="server">
                    <dw:SelectionBox ID="SecureCookiesSelector" runat="server" LeftHeader="All cookies" RightHeader="Selected cookies" Label="Secure cookies" TranslateHeaders="true" Height="250" />
                    <input type="hidden" name="SecureCookiesSelectorValue" id="SecureCookiesSelectorValue" value="" />

                    <div class="form-group">
                        <label class="control-label" for="customSecureCookie"><%=Translate.Translate("Add custom cookie to list")%></label>
                        <div class="input-group">
                            <input type="text" id="customSecureCookie" value="" class="form-control fg-input" />
                            <span class="input-group-addon">
                                <i class="fa fa-plus color-success" onclick="addCustomCookie('customSecureCookie', 'SecureCookiesSelector');" border="0" align="absMiddle" alt="Add" style="cursor: pointer; width: 100%;" title="Add"></i>
                            </span>
                        </div>
                    </div>
                </div>
            </dwc:GroupBox>

            <dwc:GroupBox ID="TrackingCookiesGroupBox" runat="server" Title="Tracking">
                <dw:SelectionBox ID="TrackingCookiesSelector" runat="server" LeftHeader="All cookies" RightHeader="Selected cookies" Label="Cookies" TranslateHeaders="true" Height="250" />
                <input type="hidden" name="TrackingCookiesSelectorValue" id="TrackingCookiesSelectorValue" value="" />
                <div class="form-group">
                    <label class="control-label" for="customTrackingCookie"><%=Translate.Translate("Add custom cookie to list")%></label>
                    <div class="input-group">
                        <input type="text" id="customTrackingCookie" value="" class="form-control fg-input" />
                        <span class="input-group-addon">
                            <i class="fa fa-plus color-success" onclick="addCustomCookie('customTrackingCookie', 'TrackingCookiesSelector');" border="0" align="absMiddle" alt="Add" style="cursor: pointer;  width: 100%;" title="Add"></i>
                        </span>
                    </div>
                </div>
            </dwc:GroupBox>

            <div id="CookieCategoriesContainer" runat="server"></div>

            <asp:Literal ID="LoaderJavaScript" runat="server" />

            <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
            </dw:Overlay>
        </dwc:CardBody>
    </dwc:Card>
    <% Translate.GetEditOnlineScript() %>
</asp:Content>