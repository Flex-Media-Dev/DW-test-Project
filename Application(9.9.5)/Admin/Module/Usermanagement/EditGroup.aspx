<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditGroup.aspx.vb" Inherits="Dynamicweb.Admin.UserManagement.EditGroup" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
            <dw:GenericResource Url="/Admin/Link.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Validation.js" />
            <dw:GenericResource Url="EditGroup.js" />
            <dw:GenericResource Url="ItemEdit.js" />
        </Items>
    </dw:ControlResources>    
</head>
<body class="area-green screen-container">
    <div class="card">
        <form id="EditGroupForm" runat="server">
            <dw:RibbonBar ID="Ribbon" runat="server">
                <dw:RibbonBarTab ID="RibbonbarTab1" runat="server" Active="true" Name="Default">
                    <dw:RibbonBarGroup ID="RibbonbarGroup2" runat="server" Name="Show">
                        <dw:RibbonBarRadioButton runat="server" ID="ViewGroupSettingsButton" Size="Large" Text="Group" Icon="PeopleOutline" IconColor="Success" OnClientClick="SetMainDiv('EditGroup');" />
                        <dw:RibbonBarButton runat="server" ID="ViewGroupPermissionsButton" Size="Large" Text="Permissions" Icon="LockOutline" OnClientClick="ShowBulkEditPermissions();" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup3" runat="server" Name="Settings">
                        <dw:RibbonBarButton ID="RibbonbarButton1" runat="server" Text="Editor configuration" OnClientClick="popupEditorConfiguration();" Size="Small" Icon="ToggleOn" />
                        <dw:RibbonBarButton runat="server" ID="AllowBackendLoginButton" Text="Allow backend login" OnClientClick="popupAllowBackend();" Size="Small" Icon="Key" />
                        <dw:RibbonBarButton runat="server" ID="StartPageButton" Text="Start page" OnClientClick="popupStartPageDialog();" Size="Small" Icon="Home" />
                        <dw:RibbonBarButton runat="server" ID="CommPermissionsButton" Visible="False" Text="Email permissions" OnClientClick="popupCommPermissions(true);" Size="Small" Icon="EnvelopeO" />
                        <dw:RibbonBarButton runat="server" ID="ImpersonationButton" Text="Impersonation" OnClientClick="dialog.show('ImpersonationDialog');" Size="Small" Icon="FaceUnlock" />
                        <dw:RibbonBarButton runat="server" ID="AdministratorsButton" Text="Group admins" OnClientClick="dialog.show('AdministratorsDialog');" Size="Small" Icon="PersonAdd" />
                        <dw:RibbonBarButton runat="server" ID="ItemTypeButton" Text="Item Type" OnClientClick="dialog.show('ItemTypeDialog');" Size="Small" Icon="Cube" />
                        <dw:RibbonBarButton runat="server" ID="PermissionsButton" Text="Permissions" Title="Permissions" Icon="Lock" DoTranslate="true" Size="Small" Visible="false" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup7" runat="server" Name="Validate">
                        <dw:RibbonBarButton ID="cmdValidateEmail" runat="server" Text="Validate e-mails" Icon="Check" Size="Small" OnClientClick="validateEmails();" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="groupHelp" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="cmdHelp" runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="help();" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>
            <!-- End: Toolbar -->

            <div id="scrollDiv">
                <div id="EditGroupDiv">
                    <dw:Infobar runat="server" ID="GroupRestrictionsErrorMessage" CssClass="hidden" Type="Error" Message="Group type restrictions does not allow to attach one or more selected users">
                        <br />
                        <asp:Label runat="server" ID="WrongUsers"></asp:Label>
                    </dw:Infobar>
                    <dw:Infobar runat="server" ID="GroupNameFieldMissedMessage" CssClass="hidden" Type="Error" Message="You can't create a group without a name field. You need to enable the Name field in User and group type settings">
                    </dw:Infobar>

                    <dw:GroupBox ID="SettingsGroupBox" runat="server" Title="Indstillinger">
                        <table class="formsTable">
                            <tr>
                                <td>
                                    <div class="nobr">
                                        <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Name" />
                                    </div>
                                </td>
                                <td>
                                    <input type="text" name="GroupName" id="GroupName" onkeyup="groupNameChanged(this);" runat="server" maxlength="255" class="NewUIinput groupNameField" />
                                    <script type="text/javascript">
                                        if (document.getElementById('GroupName').value.length == 0) {
                                            document.getElementById('GroupName').focus();
                                        }
                                    </script>
                                </td>                                
                            </tr>
                        </table>
                        <dwc:SelectPicker runat="server" ID="DefaultPermissionSelector" Label="Default permission"></dwc:SelectPicker>
                    </dw:GroupBox>
                    <!-- End: 'Settings' group box -->
                    <!-- 'Users' group box -->
                    <dw:GroupBox ID="GroupBoxUsers" runat="server" Title="Users">
                        <table class="formsTable" id="UserSelectorTable" runat="server">
                            <tr>
                                <td>
                                    <div class="nobr">
                                        <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Select users" />
                                    </div>
                                </td>
                                <td>
                                    <dw:UserSelector runat="server" ID="UserSelector" Show="Users" EnableViewState="false">
                                    </dw:UserSelector>
                                </td>
                            </tr>
                        </table>
                        <div id="UsersProviderChangedWarning" style="display: none;">
                            <dw:Infobar TranslateMessage="false" runat="server" Type="Warning" Title="" ID="UsersProviderChangedInfo"></dw:Infobar>
                        </div>
                        <table class="formsTable">
                            <tr>
                                <td>
                                    <div class="nobr">
                                        <dw:TranslateLabel ID="SelectSmartSearchLbl" runat="server" Text="Select SmartSearch" />
                                    </div>
                                </td>
                                <td>
                                    <select class="std" id="UserSmartSearchSelector" runat="server" onchange="handleUserSelectorTableVisibility(this)">
                                        <option value="0" label="None" />
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                    <!-- End: 'Users' group box -->

                    <!-- 'Information' group box -->
                    <dw:GroupBox ID="InformationGroupBox" runat="server" Title="Information">
                        <dwc:InputText runat="server" ID="CustomerNumber" MaxLength="255" Label="Customer number" />
                        <dwc:InputText runat="server" ID="JobTitle" MaxLength="255" Label="Job title" />
                        <dwc:InputText runat="server" ID="CompanyName" MaxLength="255" Label="Company name" />
                        <dwc:InputText runat="server" ID="Address" MaxLength="255" Label="Address" />
                        <dwc:InputText runat="server" ID="Address2" MaxLength="255" Label="Address 2" />
                        <dwc:InputText runat="server" ID="ZipCode" MaxLength="255" Label="Zip code" />
                        <dwc:InputText runat="server" ID="City" MaxLength="255" Label="City" />
                        <dwc:InputText runat="server" ID="State" MaxLength="255" Label="State or region" />
                        <dwc:InputText runat="server" ID="Country" MaxLength="255" Label="Country" />
                        <dwc:InputText runat="server" ID="Telephone" MaxLength="255" Label="Phone" />
                        <dwc:InputText runat="server" ID="TelephoneHome" MaxLength="255" Label="Phone (private)" />
                        <dwc:InputText runat="server" ID="Telefax" MaxLength="255" Label="Fax" />
                        <dwc:InputText runat="server" ID="Cellular" MaxLength="255" Label="Mobile phone" />
                    </dw:GroupBox>
                    <!-- End: 'Information' group box -->


                    <%If Dynamicweb.Security.UserManagement.License.IsModuleAvailable("Maps") AndAlso Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("Maps") Then%>
                    <dw:GroupBox runat="server" ID="GeoLocationGroupBox" Title="GeoLocation">
                        <dwc:InputText runat="server" ID="GeoLocationLat" MaxLength="255" Label="GeoLocationLat" />
                        <dwc:InputText runat="server" ID="GeoLocationLng" MaxLength="255" Label="GeoLocationLng" />
                        <table class="formsTable">
                            <tr>
                                <td></td>
                                <td>
                                    <button runat="server" type="button" id="GeoLocationShowOnMap" class="btn btn-default">
                                        <dw:TranslateLabel runat="server" Text="Show location on map" />
                                    </button>
                                    <button runat="server" type="button" id="GeoLocationGetFromAPI" class="btn btn-default">
                                        <dw:TranslateLabel runat="server" Text="Get location from API" />
                                    </button>
                                </td>
                            </tr>
                        </table>
                        <dwc:CheckBox runat="server" ID="GeoLocationIsCustom" Label="GeoLocationIsCustom" />
                        <dw:FileManager ID="GeoLocationImage" Name="GeoLocationImage" Extensions="jpg,png,gif,webp" runat="server" Label="Image" />
                    </dw:GroupBox>

                    <script type="text/javascript" src="Maps.js"></script>
                    <script type="text/javascript">
                        mapsSettings.messages['Unable to get location for address "#{address}"'] = '<%= StringHelper.JsEnable(Translate.Translate("Unable to get location for address ""#{address}""")) %>';
                        mapsSettings.fieldMap['zip'] = 'ZipCode';
                    </script>
                    <%End If%>

                    <dw:CustomFieldValueEdit ID="GroupCustomFields" runat="server" />

                    <%--Group properties--%>
                    <div id="content-item">
                        <asp:Literal ID="litFields" runat="server" />
                    </div>
                    <%--Group properties--%>
                </div>
                <!-- 'Configuration' dialog -->
                <dw:Dialog runat="server" ID="EditorConfigurationDialog" Title="Editor configuration" ShowCancelButton="true" ShowOkButton="true" OkAction="setEditorConfiguration();">
                    <dw:GroupBox ID="GroupBox3" runat="server" Title="Select configuration" DoTranslation="true">
                        <asp:DropDownList runat="server" CssClass="std" ID="ConfigurationSelector" />
                    </dw:GroupBox>
                </dw:Dialog>
                <asp:HiddenField runat="server" ID="ConfigurationSelectorValue" />
                <!-- End: 'Configuration' dialog -->
                <!-- 'AllowBackend' dialog -->
                <dw:Dialog runat="server" ID="AllowBackendDialog" Title="Allow backend login" ShowCancelButton="true" ShowOkButton="true" OkAction="setAllowBackend();">
                    <dw:GroupBox ID="GroupBox4" runat="server" Title="Backend login" DoTranslation="true">
                        <dw:CheckBox runat="server" ID="AllowBackendCheckbox" />
                        <div style="margin: 5px 5px 5px 5px;">
                            <asp:Literal runat="server" ID="AllowBackendDisabledText" Text="This option is disabled because the group inherits backend login from this group:"></asp:Literal>
                        </div>
                        <div style="margin: 10px 10px 10px 10px;">
                            <asp:Literal runat="server" ID="AllowBackendGroups"></asp:Literal>
                        </div>
                    </dw:GroupBox>
                </dw:Dialog>
                <asp:HiddenField runat="server" ID="AllowBackendValue" />
                <!-- End: 'AllowBackend' dialog -->
                <!-- Communication permissions dialog -->
                <dw:Dialog runat="server" ID="CommPermissionsDialog" Title="Permissions" ShowCancelButton="True" ShowOkButton="True" OkAction="updateCommPermissions();" CancelAction="revertCommPermissions();" OkText="Update">
                    <dw:GroupBox ID="GroupBox8" runat="server" Title="Update permissions for all users in the group" DoTranslation="true">
                        <div class="EditCommPermissions">
                            <label>
                                <dw:CheckBox runat="server" ID="CommunicationEmail" Label="Email" />
                            </label>
                            <input type="hidden" runat="server" id="CommunicationEmailValue" name="CommunicationEmailValue" value="" />
                        </div>
                        <script type="text/javascript">
                            confirmationMsgSelect = '<%= Translate.JsTranslate("This will overwrite existing values. Continue?") %>';
                            confirmationMsgUnSelect = '<%= Translate.JsTranslate("This will overwrite existing values. Continue?") %>';
                        </script>
                    </dw:GroupBox>
                </dw:Dialog>
                <!-- End: Communication permissions dialog -->
                <!-- Start Page Dialog -->
                <dw:Dialog runat="server" ID="StartPageDialog" Title="Start page" ShowCancelButton="true" ShowOkButton="true" OkAction="javascript:saveStartPageDialog();">
                    <dw:GroupBox ID="GroupBox5" runat="server" Title="Frontend Start page" DoTranslation="true">
                        <div style="margin: 10px 10px 10px 10px;">
                            <dw:LinkManager runat="server" ID="StartPage" DisableFileArchive="true" />
                            <asp:HiddenField runat="server" ID="StartPageValue" />
                        </div>
                    </dw:GroupBox>
                </dw:Dialog>
                <input type="hidden" id="GroupID" name="GroupID" value="" runat="server" />
                <input type="hidden" id="ParentGroupID" name="ParentGroupID" value="" runat="server" />
                <input type="hidden" id="IsRootGroup" name="IsRootGroup" value="false" runat="server" />
                <input type="hidden" id="cmd" name="cmd" value="" runat="server" />
                <input type="hidden" id="DoClose" name="DoClose" value="false" runat="server" />
                <input type="hidden" id="GroupBasedOn" value="" runat="server" />
            </div>

            <dwc:ActionBar runat="server">
                <dw:ToolbarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Image="NoImage" OnClientClick="save();" ID="cmdSave" ShowWait="true" WaitTimeout="500">
                </dw:ToolbarButton>
                <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500" OnClientClick="saveAndClose();">
                </dw:ToolbarButton>
                <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" ID="cmdCancel" ShowWait="true" WaitTimeout="500" OnClientClick="closeForm()">
                </dw:ToolbarButton>

            </dwc:ActionBar>

            <!-- Impersonation Dialog -->
            <dw:Dialog runat="server" ID="ImpersonationDialog" Title="Impersonation" ShowCancelButton="true" ShowOkButton="true" OkAction="__impersonationContext.saveImpersonationDialog();">
                <dw:GroupBox ID="GroupBox9" runat="server" Title="I can impersonate" DoTranslation="true">
                    <table class="EditUserTable" cellpadding="1" cellspacing="1">
                        <tr>
                            <td>
                                <dw:UserSelector runat="server" ID="ICanImpersonateUserSelector" Show="Both" HideAdmins="true"></dw:UserSelector>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="GroupBox10" runat="server" Title="Can impersonate me" DoTranslation="true">
                    <table class="EditUserTable" cellpadding="1" cellspacing="1">
                        <tr>
                            <td>
                                <dw:UserSelector runat="server" ID="CanImpersonateMeUserSelector" Show="Both" HideAdmins="true"></dw:UserSelector>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>

            <!-- Group administrators Dialog -->
            <dw:Dialog runat="server" ID="AdministratorsDialog" Title="Group admins" ShowCancelButton="False" ShowOkButton="true">
                <dw:UserSelector runat="server" ID="Administrators" Show="Users" HideAdmins="true"></dw:UserSelector>
            </dw:Dialog>

            <dw:Dialog ID="ValidationEmailDialog" runat="server" Title="Invalid email addresses" HidePadding="true" ShowOkButton="false" ShowCancelButton="true" ShowClose="true" Width="800" CancelAction="OnCloseValidationEmailPopUp();">
                <iframe id="ValidationEmailDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="BulkEditPermissionsDialog" runat="server" Title="Permissions" Size="Auto" HidePadding="true" ShowOkButton="true" OkText="Save and close" ShowCancelButton="true" ShowClose="true" OkAction="OnSaveBulkEditPermissions();" CancelAction="CloseBulkEditPermissions();">
                <iframe id="BulkEditPermissionsDialogFrame"></iframe>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="ItemTypeDialog" Width="480" Title="Item type" ShowOkButton="true" ShowCancelButton="true" CancelAction="closeChangeItemTypeDialog();" OkAction="changeItemType();">
                <dw:GroupBox ID="GroupBox11" runat="server" Title="Item type">
                    <table cellpadding="1" cellspacing="1">
                        <tr>
                            <td width="170">
                                <dw:TranslateLabel ID="TranslateLabel21" runat="server" Text="Group properties" />
                            </td>
                            <td>
                                <dw:Richselect ID="ItemTypeSelect" runat="server" Height="60" Itemheight="60" Width="300" Itemwidth="300">
                                </dw:Richselect>
                            </td>
                        </tr>
                        <tr>
                            <td width="170">
                                <dw:TranslateLabel ID="TranslateLabel22" runat="server" Text="User default properties" />
                            </td>
                            <td>
                                <dw:Richselect ID="ItemTypeUserDefaultSelect" runat="server" Height="60" Itemheight="60" Width="300" Itemwidth="300">
                                </dw:Richselect>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Overlay ID="UpdatingOverlay" runat="server"></dw:Overlay>
        </form>
    </div>

    <div class="card-footer">
    </div>

    <span id="jsHelp" style="display: none">
        <%=Dynamicweb.SystemTools.Gui.Help("", "modules.usermanagement.general")%>
    </span>
    <script type="text/javascript">
        var id = <%=_id %>;
        var parentID = <%= _parentID%>;        
        var __impersonationContext = new ImpersonationContext(id, parentID);

        $$('input.groupNameField').each(function(elm) {
            groupNameChanged(elm);
        });        
    </script>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
