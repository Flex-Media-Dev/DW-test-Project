<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Edit.aspx.vb" Inherits="Dynamicweb.Admin.Edit2" EnableEventValidation="false" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="area" TagName="RegionalSelect" Src="/Admin/Content/Area/RegionalSelect.ascx" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <dw:ControlResources ID="ctrlResources" runat="server" IncludeUIStylesheet="true" CombineOutput="false" IncludePrototype="true" IncludeScriptaculous="true">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
            <dw:GenericResource Url="/Admin/Content/Items/js/Preset.js" />
            <dw:GenericResource Url="/Admin/Link.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Validation.js" />
            <dw:GenericResource Url="/Admin/Content/Area/Edit.js" />
            <dw:GenericResource Url="/Admin/Content/Area/Edit.css" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" />
        </Items>
    </dw:ControlResources>

    <title>Area edit</title>
    <script type="text/javascript">
        <% If Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "refreshrootselector" Then %>
        dwGlobal.getContentNavigator().refreshRootSelector();
        <% End If %>

        Event.observe(document, 'dom:loaded', function () {
            <% If EnableRibbonButtons Then %>
            if ($('PermissionsButton')) {
                $('PermissionsButton').toggleClassName('disabled');
            }
            if ($('ExtranetButton')) {
                $('ExtranetButton').toggleClassName('disabled');
            }
            if ($('EcomButton')) {
                $('EcomButton').toggleClassName('disabled');
            }
            $('RobotsTxt').toggleClassName('disabled');
            <% End If %>

            <% If EnableExportSettingsButton Then %>
            $('cmdExportSettings').toggleClassName('disabled');
            <% End If %>

            $('LoginTemplateButton').toggleClassName('disabled');
            $('ItemTypeButton').toggleClassName('disabled');
            $('CookieButton').toggleClassName('disabled');
            $('cmdImportSettings').toggleClassName('disabled');            
        });

        function cancel() {
        	<%	If LCase(Dynamicweb.Context.Current.Request("FrontPage")) = "true" Then%>
            location = '/Admin/Blank.aspx';
            <% Else%>
            location = 'List.aspx';
            <% End If%>
            return false;
        }

        function validate() {
            if ($('AreaPermission')) {
                if ($('AreaPermission').options) {
                    for (i = 0; i < $('AreaPermission').options.length; i++) {
                        $('AreaPermission').options[i].selected = true;
                    }
                }
            }

            <%  If Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/Designs/UseOnlyDesignsAndLayouts") = "True" Then%>
            var areaLayout = $('AreaLayout');
            if (areaLayout.value.length < 1) {
                alert("<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.Translate("Layout"))%>");
                areaLayout.activate();
                return false;
            }
            <% End If%>

            var name = $('AreaName');
            var domain = $('AreaDomain');
            if (name.value.length < 1) {
                alert("<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.Translate("Navn"))%>");
                name.activate();
            } else if (name.value.length > 255) {
                alert("<%=Translate.JSTranslate("Max %% tegn i: ´%f%´","%%","255", "%f%", Translate.JSTranslate("Navn"))%>");
                name.activate();
            } else {
                return true;
            }
            return false;
        }

        function save(action) {
            if (validate()) {
                var itemEdit = Dynamicweb.Area.ItemEdit.get_current();
                itemEdit.validate(function (result) {
                    itemEdit.showWait();
                    if (result.isValid) {
                        // Fire event to handle saving
                        window.document.fire("General:DocumentOnSave");
                        $("action").value = (action) ? action : "save";
                        if (action != "saveAndClose") {
                            $("MainForm").target = "SaveFrame";
                            $('SaveFrame').onload = function () {
                                itemEdit.hideWait();
                            };
                        } else {
                            $("MainForm").target = "";
                        }
                        $('cmdSubmit').click();
                    } else {
                        itemEdit.hideWait();
                    }
                });
            }
            return false;
        }

        function saveAndClose() {
            save("saveAndClose");
            return false;
        }

        function openEditPermission(mode) {
            dialog.show('AreaPermissionDialog', '/Admin/Content/Page/PagePermission.aspx?AreaID=<%=Dynamicweb.Context.Current.Request("AreaID")%>&DialogID=AreaPermissionDialog&Mode=' + mode);
        }

        function savePermission() {
            var permissionsFrame = document.getElementById('AreaPermissionDialogFrame');
            var iFrameDoc = (permissionsFrame.contentWindow || permissionsFrame.contentDocument);
            if (iFrameDoc.document) iFrameDoc = iFrameDoc.document;
            iFrameDoc.getElementById("PagePermissionForm").submit();
        }

        function showHideCookieWarningTemplateSelector() {
            if (document.getElementById("rbCustomUserNotifications").checked) {
                document.getElementById("templateContainer").style.display = "none";
            } else {
                document.getElementById("templateContainer").style.display = "";
            }
        }

        function cookieSettingsDialogSave() {
            document.getElementById("CookieDialogOkAction").value = "true";
            dialog.hide("CookieSettingsDialog");
        }

        function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("", "modules.area.edit") %>
        }

        function addPrimDom() {
            var pd = "";
            pd = prompt("<%=Translate.JSTranslate("Primær domæne")%>", "");
            if (pd != null && pd != '') {
                var sl = document.getElementById("AreaDomainLock");

                var elOptNew = document.createElement('option');
                elOptNew.text = pd;
                elOptNew.value = pd;
                elOptNew.setAttribute("selected", "selected")

                try {
                    sl.add(elOptNew, null);
                }
                catch (ex) {
                    sl.add(elOptNew);
                }
            }
        }

        function exportArea() {
            dialog.hide('ExportAreaDialog');

            var areaID = $('AreaID').value;
            var name = $('AreaName').value;
            var mode = $('chkFullExport').checked ? 'full' : 'translation';

            location = 'Edit.aspx?Export=True&Compress=false&Name=' + name + '&AreaID=' + areaID + '&Mode=' + mode;
        }

        function ReloadLanguages() {
            var shopEl = $('AreaEcomShopID');
            var langEl = $('AreaEcomLanguageID');

            new Dynamicweb.Ajax.doPostBack({
                parameters: {
                    IsAjax: 'true',
                    AjaxAction: 'UpdateLanguages:' + shopEl.value,
                },
                onComplete: function (transport) {
                    if (transport.responseText) {
                        var len = langEl.length;

                        for (i = 0; i < len; i++)
                            langEl.remove(0);

                        var data = transport.responseText.split(',');

                        for (i = 0; i < data.length / 2; i++)
                            langEl.options[i] = new Option(data[i * 2 + 1], data[i * 2]);
                    }
                }
            });
        }

        var useSSLOption = '<%=area.SSLMode%>';
        var sslConfirmation1 = '<%=Translate.JsTranslate("Are you sure you want to change SSL settings from ")%>';
        var sslConfirmation2 = '<%=Translate.JsTranslate(" to ")%>';
        function changeSSLMode(sslMode) {
            var previousSSLMode = "";

            if (useSSLOption == "0") {
                previousSSLMode = "cmdSSLStandard";
            } else if (useSSLOption == "1") {
                previousSSLMode = "cmdSSLForce";
            } else if (useSSLOption == "2") {
                previousSSLMode = "cmdSSLUnforce";
            }

            if (sslMode != previousSSLMode) {
                var sslOptionConfirmed = confirm(sslConfirmation1 + "'" + document.getElementById(previousSSLMode).title + "'" + sslConfirmation2 + "'" + document.getElementById(sslMode).title + "' ?");
                document.getElementById("cmdSSLStandard").className = "ribbon-section-button";
                document.getElementById("cmdSSLForce").className = "ribbon-section-button";
                document.getElementById("cmdSSLUnforce").className = "ribbon-section-button";
                if (sslOptionConfirmed != true) {

                    document.getElementById(previousSSLMode).className = "ribbon-section-button active";
                    document.getElementById("radio_SSLMode_selected").value = previousSSLMode;
                    if (document.getElementById("SSLMode") != null) {
                        document.getElementById("SSLMode").value = useSSLOption;
                    } else {
                        document.getElementById("radio_SSLMode").value = useSSLOption;
                    }
                } else {
                    document.getElementById(sslMode).className = "ribbon-section-button active";
                }
            }
        }

        function CdnActiveChanged(val) {
            var cdnHostEl = document.getElementById("CdnHost");
            var cdnImageHostEl = document.getElementById("CdnImageHost");
            cdnHostEl.disabled = !val;
            cdnImageHostEl.disabled = !val;
        }

        function serializePermissions() {
            $("GroupPermissionsIDs").value = SelectionBox.getElementsRightAsArray("GroupPermissions");
        }

        function exportSettings() {
            var settingName = $("ExportSettingName").value;
            if (!settingName) {
                return;
            }

            new overlay('PleaseWait').show();

            new Ajax.Request('Edit.aspx', {
                parameters: {
                    IsAjax: true,
                    AjaxAction: 'ExportSettings',
                    AreaId: $('AreaID').value,
                    SettingName: settingName
                },
                onSuccess: function (transport) {
                    var errorMessage = transport.responseText;
                    if (errorMessage) {
                        dwGlobal.showControlErrors("ExportSettingName", errorMessage);
                    }
                    else {
                        dialog.hide('ExportSettingsDialog');
                        dwGlobal.hideControlErrors("ExportSettingName", "");

                        var importSettings = $("FM_ImportSettingFile");
                        var opt = document.createElement('option');
                        opt.value = settingName + ".json";
                        opt.innerHTML = opt.value;
                        importSettings.appendChild(opt);
                    }
                    new overlay('PleaseWait').hide();
                }
            });
        }

        function importSettings() {
            // Update website property item settings
            var settingName = $("FM_ImportSettingFile").value;
            if (!settingName) {
                return;
            }
            var itemType = $("ItemTypeSelect").value;

            new overlay('PleaseWait').show();

            new Ajax.Request('Edit.aspx', {
                parameters: {
                    IsAjax: true,
                    AjaxAction: 'ImportSettings',
                    ItemType: itemType,
                    SettingName: settingName
                },
                onSuccess: function (transport) {
                    //var errorMessage = transport.responseText;
                    var jsonObj = transport.responseText ? transport.responseText.evalJSON() : {};
                    var errorMessage = jsonObj.ErrorMessage;
                    var newItemType = jsonObj.ItemType;

                    if (errorMessage) {
                        var importWarning = $("ImportSettingNameError");
                        importWarning.innerHTML = errorMessage;
                    }
                    else {
                        if (itemType != newItemType) {
                            $("action").value = "changeItemType";
                            $("ItemTypeSelect").value = newItemType;
                        }
                        else {
                            $("action").value = "";
                        }
                        $("MainForm").target = "";
                        $("MainForm").submit();
                    }
                    new overlay('PleaseWait').hide();
                }
            });

        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="MainForm" runat="server" action="Edit.aspx" method="post">
            <input type="hidden" name="action" id="action" value="" />
            <input type="hidden" name="FrontPage" id="FrontPage" value="<%=Dynamicweb.Context.Current.Request("FrontPage")%>" />
            <input type="hidden" name="AreaID" id="AreaID" value="<%=Dynamicweb.Context.Current.Request("AreaID")%>" />
            <input type="hidden" id="AreaSavedItemTypeProperty" value="<%=area.ItemType%>" />
            <input type="hidden" id="AreaSavedItemTypePageProperty" value="<%=area.ItemTypePageProperty%>" />
            <input type="submit" id="cmdSubmit" value="Submit" style="display: none" />
            <dw:RibbonBar runat="server" ID="myribbon">
                <dw:RibbonBarTab ID="RibbonBarTab1" runat="server" Name="Website">
                    <dw:RibbonBarGroup runat="server" ID="toolsGroup" Name="Funktioner" Visible="true">
                        <dw:RibbonBarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Icon="Save" OnClientClick="save();" ID="cmdSave" ShowWait="false">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="saveAndClose();" ID="cmdSaveAndClose" ShowWait="false">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" OnClientClick="cancel();" ID="cmdCancel" ShowWait="true" WaitTimeout="1000">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup2" runat="server" Name="Website">
                        <dw:RibbonBarButton runat="server" ID="RobotsTxt" Size="Small" Icon="FileTextO" Text="Robots.txt" OnClientClick="dialog.show('RobotsTxtDialog')" Disabled="true" />
                        <dw:RibbonBarButton runat="server" ID="Export" Visible="false" Size="Small" Icon="SignOut" Text="Eksporter" OnClientClick="dialog.show('ExportAreaDialog')" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" Name="Advanced" ID="grpAdvanced">
                        <dw:RibbonBarButton runat="server" Text="Permissions" Icon="Lock" ID="PermissionsButton" Size="Small" OnClientClick="openEditPermission('permissions');" Disabled="true" />
                        <dw:RibbonBarButton runat="server" Text="AD permissions" Icon="Key" Size="Small" ID="ExtranetButton" OnClientClick="dialog.show('SecurityDialog');" Disabled="true" />
                        <dw:RibbonBarButton runat="server" Text="Login template" Icon="AccountBox" ID="LoginTemplateButton" Size="Small" OnClientClick="openEditPermission('template');" Disabled="true" />
                        <dw:RibbonBarButton runat="server" Text="eCommerce" Icon="ShoppingCart" ID="EcomButton" Size="Small" OnClientClick="dialog.show('EcomSettingsDialog');" Disabled="true" />
                        <dw:RibbonBarButton runat="server" Text="Item type" Icon="Cube" ID="ItemTypeButton" Size="Small" OnClientClick="dialog.show('AreaItemTypeDialog');" Disabled="true" />
                        <dw:RibbonBarButton runat="server" Text="Cookies" Icon="Cake" ID="CookieButton" Size="Small" OnClientClick="dialog.show('CookieSettingsDialog');" Disabled="true" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="SSLRibbonbarGroup" runat="server" Name="Https">
                        <dw:RibbonBarRadioButton ID="cmdSSLStandard" Group="SSLMode" runat="server" Checked="false" Value="0" Text="Standard" Icon="VpnKey" Size="Small" OnClientClick="changeSSLMode('cmdSSLStandard');"></dw:RibbonBarRadioButton>
                        <dw:RibbonBarRadioButton ID="cmdSSLForce" Group="SSLMode" runat="server" Checked="false" Value="1" Text="Force SSL" Icon="VpnLock" Size="Small" OnClientClick="changeSSLMode('cmdSSLForce');"></dw:RibbonBarRadioButton>
                        <dw:RibbonBarRadioButton ID="cmdSSLUnforce" Group="SSLMode" runat="server" Checked="false" Value="2" Text="Un-force SSL" Icon="Unlock" Size="Small" OnClientClick="changeSSLMode('cmdSSLUnforce');"></dw:RibbonBarRadioButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup3" runat="server" Name="Import / export">
                        <dw:RibbonBarButton ID="cmdExportSettings" runat="server" Text="Export settings" Icon="ArrowRight" Size="Small" OnClientClick="dialog.show('ExportSettingsDialog');" Disabled="true" />
                        <dw:RibbonBarButton ID="cmdImportSettings" runat="server" Text="Import settings" Icon="ArrowLeft" Size="Small" OnClientClick="dialog.show('ImportSettingsDialog');" Disabled="true" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup4" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="RibbonbarButton4" runat="server" Text="Help" Size="Large" Icon="Help" OnClientClick="help();"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
                <dw:RibbonBarTab ID="grpLayout" Active="False" Name="Layout" runat="server" Visible="true">
                    <dw:RibbonBarGroup runat="server" ID="RibbonBarGroup7" Name="Funktioner" Visible="true">
                        <dw:RibbonBarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Icon="Save" OnClientClick="save();" ID="RibbonBarButton1" ShowWait="false">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="saveAndClose();" ID="RibbonBarButton2" ShowWait="false">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" OnClientClick="cancel();" ID="RibbonBarButton3" ShowWait="true" WaitTimeout="1000">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup9" runat="server" Name="Layout">
                        <dw:RibbonBarPanel ID="RibbonbarPanel1" runat="server">
                            <dw:Richselect ID="AreaLayout" runat="server" Height="80" Width="300" Itemheight="60" Itemwidth="300">
                            </dw:Richselect>
                        </dw:RibbonBarPanel>
                        <dw:RibbonBarButton runat="server" ID="RibbonBarButton7" Size="Small" Icon="Mobile" Text="Device layouts" OnClientClick="dialog.show('DeviceLayoutDialog');" />
                        <dw:RibbonBarButton runat="server" ID="ItemTypePageLayoutsButton" Size="Small" Icon="Cube" Text="Item page layouts" OnClientClick="dialog.show('ItemTypePageLayoutDialog');" />
                        <dw:RibbonBarButton runat="server" ID="ItemTypeParagraphLayoutsButton" Size="Small" Icon="Cube" Text="Item paragraph layouts" OnClientClick="dialog.show('ItemTypeParagraphLayoutDialog');" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup6" runat="server" Name="HTML type">
                        <dw:RibbonBarPanel ID="AreaHtmlTypePanel" runat="server">
                            <asp:ListBox runat="server" Rows="1" ID="AreaHtmlType" CssClass="NewUIinput" Width="100" />
                        </dw:RibbonBarPanel>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup5" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="RibbonbarButton5" runat="server" Size="Large" Text="Help" Icon="Help" OnClientClick="help();"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
                <dw:RibbonBarTab ID="grpWorkflow" Active="False" Name="Workflow" runat="server" Visible="true">
                    <dw:RibbonBarGroup runat="server" ID="RibbonBarGroup8" Name="Funktioner" Visible="true">
                        <dw:RibbonBarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Icon="Save" OnClientClick="save();" ID="RibbonBarButton6" ShowWait="false">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="saveAndClose();" ID="RibbonBarButton8" ShowWait="false">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" OnClientClick="cancel();" ID="RibbonBarButton9" ShowWait="true" WaitTimeout="1000">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Workflow">
                        <dw:RibbonBarPanel runat="server" ID="DateFormatRb" ExcludeMarginImage="true">
                            <%= Gui.ApprovalTypeBox(AreaApprovalType, True) %>
                        </dw:RibbonBarPanel>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>



            <dw:Infobar ID="infoNoPermissions" Visible="false" Type="Error" Message="You do not have access to this functionality" runat="server" />

            <asp:Panel ID="pContent" runat="server">
                <dw:GroupBox ID="GbSettings" runat="server" Title="Settings">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="tl1" runat="server" Text="Name" />
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="AreaName" MaxLength="255" CssClass="NewUIinput" />
                            </td>
                        </tr>
                        <tr runat="server" id="AreaRenameLanguagesDiv">
                            <td></td>
                            <td>
                                <dw:CheckBox runat="server" ID="AreaRenameLanguages" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="tl2" runat="server" Text="Regionale indstillinger" />
                            </td>
                            <td>
                                <%= CultureList(AreaCulture, "AreaCulture", True)%><br />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="tl3" runat="server" Text="Published" />
                            </td>
                             <td>
                                <dw:CheckBox runat="server" ID="AreaPublished" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="GbDetails" runat="server" Title="Details">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="tl4" runat="server" Text="Domæne" />
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="AreaDomain" CssClass="NewUIinput" TextMode="MultiLine" Rows="10" Wrap="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="tl5" runat="server" Text="Primær domæne" />
                            </td>
                            <td>
                                <div class="input-group">
                                    <div class="form-group-input">
                                        <asp:ListBox runat="server" ID="AreaDomainLock" CssClass="form-control std" Rows="1" />
                                    </div>
                                    <span class="input-group-addon" id="TaskActiveFrom_calendar_btn" title="<%=Translate.JsTranslate("Add")%>" onclick="addPrimDom();"><i class="fa fa-plus-square"></i></span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <dw:CheckBox runat="server" ID="AreaLockPagesToDomain" />
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td colspan="2">
                                <dw:CheckBox runat="server" ID="Noindex" FieldName="Noindex" />
                                <label for="Noindex">
                                    <dw:TranslateLabel Text="Noindex" runat="server" />
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td colspan="2">
                                <dw:CheckBox runat="server" ID="Nofollow" FieldName="Nofollow" />
                                <label for="Nofollow">
                                    <dw:TranslateLabel Text="Nofollow" runat="server" />
                                </label>
                            </td>
                        </tr>
                        <tr id="AreaNotFoundTr" runat="server" visible="false">
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="HTTP 404" />
                            </td>
                            <td>
                                <dw:LinkManager ID="AreaNotFound" runat="server" DisableFileArchive="False" DisableParagraphSelector="True" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="GB_Url" runat="server" Title="Url" DoTranslation="true">
                    <table class="formsTable">
                        <tr id="FriendlyUrlRow" runat="server">
                            <td>
                                <div class="nobr">
                                    <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Url" />
                                </div>
                            </td>
                            <td>
                                <div runat="server" id="FriendlyUrl">
                                </div>
                            </td>
                        </tr>
                        <tr id="Tr1" runat="server">
                            <td>
                                <div class="nobr">
                                    <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Use in url" />
                                </div>
                            </td>
                            <td>
                                <input type="text" id="AreaUrlName" name="AreaUrlName" size="30" maxlength="50" class="NewUIinput" runat="server" />
                            </td>
                        </tr>
                        <tr id="AreaUrlIgnoreForChildrenRow" runat="server">
                            <td>
                                <div class="nobr">
                                </div>
                            </td>
                            <td>
                                <dw:CheckBox runat="server" ID="AreaUrlIgnoreForChildren" />
                            </td>
                        </tr>
                        <tr id="Tr2" runat="server">
                            <td></td>
                            <td>
                                <dw:CheckBox runat="server" ID="AreaRedirectFirstPage" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>

                <dw:GroupBox ID="gbCDN" Title="Content Delivery Network" runat="server">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel27" Text="Content Delivery Network" runat="server" />
                            </td>
                            <td>
                                <asp:RadioButtonList ID="EnableCdn" runat="server" RepeatDirection="Vertical" CellPadding="0" CellSpacing="0">
                                    <asp:ListItem Value="True" onClick="CdnActiveChanged(true);" Text="Activate">                                        
                                    </asp:ListItem>
                                    <asp:ListItem Value="False" onClick="CdnActiveChanged(false);" Text="Deactivate">                                        
                                    </asp:ListItem>
                                    <asp:ListItem Value="" onClick="CdnActiveChanged(null);" Text="Inherits global settings">                                        
                                    </asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="tlCdnHost" Text="Host" runat="server" />
                            </td>
                            <td>
                                <input type="text" id="CdnHost" name="CdnHost" maxlength="255" class="NewUIinput" runat="server" />
                                <br />
                                <small>http(s)://cdn.domain.com</small>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="tlCdnImgHost" Text="Host" runat="server" />
                                <small>(GetImage.ashx)</small>
                            </td>
                            <td>
                                <input type="text" id="CdnImageHost" name="CdnImageHost" maxlength="255" class="NewUIinput" runat="server" />
                                <br />
                                <small>http(s)://cdn.domain.com</small>
                            </td>
                        </tr>

                    </table>
                </dw:GroupBox>

                <div id="content-item">
                    <asp:Literal ID="litFields" runat="server" />
                </div>
            </asp:Panel>

            <dw:Dialog ID="ExportAreaDialog" Width="200" runat="server" Title="Select export mode" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" CancelAction="dialog.hide('ExportAreaDialog');" OkAction="exportArea();">
                <table cellpadding="1" cellspacing="1" class="formsTable">
                    <tr>
                        <td>
                            <input type="radio" id="chkFullExport" name="RenamedFile" disabled="disabled" />
                            <label for="chkFullExport" style="color: #999999"><%= Translate.Translate("Full export")%></label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="radio" id="chkTranslationExport" name="RenamedFile" checked="checked" />
                            <label for="chkTranslationExport"><%= Translate.Translate("Translation export")%></label>
                        </td>
                    </tr>
                </table>
            </dw:Dialog>

            <dw:Dialog ID="ExportSettingsDialog" runat="server" Size="Medium" Title="Export settings" OkText="Save" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" CancelAction="dialog.hide('ExportSettingsDialog');" OkAction="exportSettings();">
                <dwc:GroupBox runat="server" Title="Export settings">
                    <dwc:InputText runat="server" ID="ExportSettingName" MaxLength="255" Label="Save as" ValidationMessage="" Info="Don't forget to save site settings before export" />
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="ImportSettingsDialog" runat="server" Size="Medium" Title="Import settings" OkText="Load" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" CancelAction="dialog.hide('ImportSettingsDialog');" OkAction="importSettings();">
                <dwc:GroupBox runat="server" Title="Import settings">
                    <dw:FileManager ID="ImportSettingFile" runat="server" Label="Load from" ShowPreview="false" AllowUpload="true" Extensions="json" Folder="System/Items/WebsiteSettings" />
                    <div class="form-group">
                        <label class="control-label">&nbsp;</label>
                        <div class="form-group-input has-error">
                            <small class="help-block info">
                                <dw:TranslateLabel ID="TranslateLabel12" runat="server" Text="Don't forget to save all changes before import" />
                            </small>
                            <small class="help-block error" id="ImportSettingNameError"></small>
                        </div>
                    </div>
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="DeviceLayoutDialog" Size="Small" Title="Device layouts" ShowOkButton="true">
                <dw:GroupBox ID="GroupBox1" runat="server" Title="Templates">
                    <table cellpadding="1" cellspacing="1" class="formsTable">
                        <tr>
                            <td width="70" height="67" valign="middle">
                                <dw:TranslateLabel ID="TranslateLabel15" runat="server" Text="Phone" />
                            </td>
                            <td valign="middle">
                                <dw:Richselect ID="AreaLayoutPhone" runat="server" Height="80" Width="300" Itemheight="60" Itemwidth="300"></dw:Richselect>
                            </td>
                        </tr>
                        <tr>
                            <td height="67" valign="middle">
                                <dw:TranslateLabel ID="TranslateLabel16" runat="server" Text="Tablet" />
                            </td>
                            <td valign="middle">
                                <dw:Richselect ID="AreaLayoutTablet" runat="server" Height="80" Width="300" Itemheight="60" Itemwidth="300"></dw:Richselect>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="AreaItemTypeDialog" Size="Medium" Title="Item type" ShowOkButton="true" ShowCancelButton="true" CancelAction="Dynamicweb.Area.ItemEdit.get_current().cancelChangeItemType();" OkAction="Dynamicweb.Area.ItemEdit.get_current().changeItemType();">
                <dw:GroupBox ID="GroupBox3" runat="server">
                    <table cellpadding="1" cellspacing="1" class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel21" runat="server" Text="Website properties" />
                            </td>
                            <td>
                                <dw:Richselect ID="ItemTypeSelect" runat="server" Height="80" Width="300" Itemheight="60" Itemwidth="300">
                                </dw:Richselect>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel22" runat="server" Text="Page properties" />
                            </td>
                            <td>
                                <dw:Richselect ID="ItemTypePageSelect" runat="server" Height="80" Width="300" Itemheight="60" Itemwidth="300">
                                </dw:Richselect>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="ItemTypePageLayoutDialog" Size="Medium" Title="Item page layouts" ShowOkButton="true">
                <dw:GroupBox ID="GroupBox2" runat="server" Title="Item types">
                    <div class="items-container">
                        <asp:Repeater ID="ItemTypePageLayoutRepeater" runat="server" EnableViewState="false">
                            <HeaderTemplate>
                                <table cellpadding="1" cellspacing="1" class="formsTable">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <%#Eval("Name")%>
                                    </td>
                                    <td runat="server" id="ItemTypeSelectorContainer">
                                        <input type="hidden" id="ItemTypeSystemName" value="<%#Eval("SystemName")%>" />
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="ItemTypeParagraphLayoutDialog" Size="Medium" Title="Item paragraph layouts" ShowOkButton="true">
                <dw:GroupBox ID="GroupBox4" runat="server" Title="Item types">
                    <div class="items-container">
                        <asp:Repeater ID="ItemTypeParagraphLayoutRepeater" runat="server" EnableViewState="false">
                            <HeaderTemplate>
                                <table cellpadding="1" cellspacing="1" class="formsTable">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <%#Eval("Name")%>
                                    </td>
                                    <td runat="server" id="ItemTypeSelectorContainer">
                                        <input type="hidden" id="ItemTypeSystemName" value="<%#Eval("SystemName")%>" />
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="RobotsTxtDialog" Size="Medium" Title="Robots.txt" ShowOkButton="true">
                <dw:GroupBox ID="gbRobotsTxtDialog" runat="server">
                    <table cellpadding="1" cellspacing="1" class="formsTable">
                        <tr>
                            <td valign="top">
                                <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Link to Google Sitemap" />
                            </td>
                            <td>
                                <dw:CheckBox runat="server" ID="AreaRobotsTxtIncludeSitemap" />
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <dw:TranslateLabel ID="TranslateLabel25" runat="server" Text="Include products inside sitemap.xml" />
                            </td>
                            <td>
                                <dw:CheckBox runat="server" ID="AreaIncludeProductsInSitemap" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Robots.txt" />
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="AreaRobotsTxt" CssClass="NewUIinput" TextMode="MultiLine" Rows="5" Columns="50" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="AreaPermissionDialog" Width="500" Title="Website permissions" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" OkAction="savePermission();">
                <iframe id="AreaPermissionDialogFrame" src="" style="width: 531px; border: solid 0px black;"></iframe>
            </dw:Dialog>

            <% If Dynamicweb.Security.Licensing.LicenseManager.LicenseHasFeature("Ecommerce") Then%>
            <dw:Dialog runat="server" ID="EcomSettingsDialog" Size="Medium" Title="Ecommerce settings" ShowOkButton="true">
                <dw:GroupBox ID="gbEcomSettingsDialog" runat="server">
                    <table cellpadding="1" cellspacing="1" class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel19" runat="server" Text="Shop" />
                            </td>
                            <td>
                                <select onchange="ReloadLanguages();" id="AreaEcomShopID" name="AreaEcomShopID" runat="server" size="1" class="NewUIinput"></select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Language" />
                            </td>
                            <td>
                                <select id="AreaEcomLanguageID" name="AreaEcomLanguageID" runat="server" size="1" class="NewUIinput"></select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel11" runat="server" Text="Currency" />
                            </td>
                            <td>
                                <select id="AreaEcomCurrencyID" name="AreaEcomCurrencyID" runat="server" size="1" class="NewUIinput"></select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel17" runat="server" Text="Country" />
                            </td>
                            <td>
                                <select id="AreaEcomCountryCode" name="AreaEcomCountryCode" runat="server" size="1" class="NewUIinput"></select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel26" runat="server" Text="Prices with VAT" />
                            </td>
                            <td>
                                <select id="AreaEcomPricesWithVAT" name="AreaEcomPricesWithVat" runat="server" size="1" class="NewUIinput"></select>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" class="nobr">
                                <dw:TranslateLabel Text="Stock location" runat="server" />
                            </td>
                            <td>
                                <select id="AreaStockLocationID" name="AreaStockLocationID" runat="server" size="1" class="NewUIinput"></select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Reverse charge for VAT" />
                            </td>
                            <td>
                                <select id="ReverseVat" name="ReverseVat" runat="server" size="1" class="NewUIinput"></select>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>
            <% End If%>

            <dw:Dialog ID="SecurityDialog" runat="server" Title="Sikkerhed" Size="Medium" ShowOkButton="true">
                <dwc:GroupBox runat="server" Title="Rettigheder">
                    <dw:SelectionBox ID="GroupPermissions" RightHeader="Selected groups" LeftHeader="All groups" Label="Allowed groups" NoDataTextLeft="No groups" NoDataTextRight="No groups"
                        TranslateNoDataText="true" TranslateHeaders="true" Width="180" ContentChanged="serializePermissions();" runat="server">
                    </dw:SelectionBox>
                    <input type="hidden" value="GroupPermissionsIDs" name="" id="GroupPermissionsIDs" runat="server" />
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" Title="Login">
                    <dw:FileManager ID="AreaPermissionTemplate" runat="server" Label="Template" Folder="Templates/Extranet" />
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="CookieSettingsDialog" Width="450" Title="Cookie settings" ShowOkButton="true" OkAction="cookieSettingsDialogSave();">
                <input type="hidden" name="CookieDialogShown" id="CookieDialogOkAction" value="" runat="server" />
                <div class="form-group">
                    <label class="control-label">User notification</label>
                    <div class="form-group-input">
                        <input type="radio" runat="server" id="rbWarnings" name="UserNotificationGroup" />
                        <label for="rbWarningTemplate">
                            <dw:TranslateLabel ID="TranslateLabel23" Text="Template based warnings" runat="server" />
                        </label>
                        <div id="templateContainer" runat="server" style="margin: 10px 0px 10px 20px;">
                            <dw:FileManager ID="templateSelector" runat="server" FixFieldName="true" ShowPreview="false" Folder="Templates/CookieWarning" ShowNothingSelectedOption="False" />
                        </div>
                        <input type="radio" runat="server" id="rbCustomUserNotifications" name="UserNotificationGroup" />
                        <label for="rbCustomSet">
                            <dw:TranslateLabel ID="TranslateLabel24" Text="Custom (set with Javascript or .Net)" runat="server" />
                        </label>
                        <small class="help-block error" id="ExportSettingNameErro2r">ExportSettingNameError
                        </small>
                    </div>
                </div>
            </dw:Dialog>

            <dw:Overlay ID="PleaseWait" runat="server" />
        </form>
    </div>
    <div class="card-footer">
    </div>
    <iframe id="SaveFrame" name="SaveFrame" style="display: none;"></iframe>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
